"""Merge current-workspace windows with i3status-rust's i3bar stream."""

import json
import queue
import signal
import subprocess
import sys
import threading
import time


def window_blocks(windows, workspaces):
    workspace = next((w["id"] for w in workspaces if w["is_focused"]), None)
    if workspace is None:
        return []
    visible = [w for w in windows if w.get("workspace_id") == workspace]
    visible.sort(key=lambda w: (
        w.get("layout", {}).get("pos_in_scrolling_layout") or [999999, 999999],
        w["id"],
    ))
    blocks = []
    aliases = {"chromium-browser": "Chromium", ".virt-manager-wrapped": "VM Manager"}
    for window in visible:
        app = window.get("app_id") or window.get("title") or "Window"
        name = aliases.get(app, app.rsplit(".", 1)[-1])
        name = " ".join(name.split()) or "Window"
        focused = window.get("is_focused", False)
        blocks.append({
            "name": "niri_windows",
            "instance": str(window["id"]),
            "full_text": " " + (name if len(name) <= 12 else name[:11] + "…") + " ",
            "short_text": " " + name[:3] + " ",
            "color": "#3c4841" if focused else "#d3c6aa",
            "background": "#a7c080" if focused else "#3c4841",
            "separator": False,
            "separator_block_width": 0,
        })
    return blocks


def main():
    updates = queue.Queue()
    stopped = threading.Event()
    event_processes = []
    def stop(signum, frame):
        raise SystemExit(0)
    signal.signal(signal.SIGTERM, stop)
    status = subprocess.Popen(
        ["i3status-rs", sys.argv[1]], stdin=subprocess.PIPE,
        stdout=subprocess.PIPE, text=True, bufsize=1,
    )

    def read_status():
        for line in status.stdout:
            try:
                value = json.loads(line.strip().strip(","))
            except json.JSONDecodeError:
                continue
            if isinstance(value, list):
                updates.put(("status", value))
        updates.put(("exit", status.wait()))

    def read_windows():
        # The initial event-stream snapshot also triggers a refresh after restart.
        while not stopped.is_set():
            events = subprocess.Popen(
                ["niri", "msg", "--json", "event-stream"],
                stdout=subprocess.PIPE, text=True,
            )
            event_processes.append(events)
            try:
                for line in events.stdout:
                    updates.put(("windows", None))
            finally:
                events.stdout.close()
                events.wait()
                event_processes.remove(events)
            updates.put(("clear", None))
            stopped.wait(1)

    def clicks():
        for line in sys.stdin:
            try:
                event = json.loads(line.strip().strip(","))
            except json.JSONDecodeError:
                continue
            if event.get("name") == "niri_windows":
                if event.get("button") == 1:
                    subprocess.run([
                        "niri", "msg", "action", "focus-window", "--id",
                        str(int(event["instance"])),
                    ], stdout=subprocess.DEVNULL, check=False)
            else:
                try:
                    status.stdin.write(json.dumps(event) + "\n")
                    status.stdin.flush()
                except (BrokenPipeError, ValueError):
                    return

    for target in (read_status, read_windows, clicks):
        threading.Thread(target=target, daemon=True).start()
    print(json.dumps({"version": 1, "click_events": True}), flush=True)
    print("[", flush=True)
    right, left = [], []
    first = True
    try:
        while True:
            pending = [updates.get()]
            # Coalesce bursts of Niri events into a single snapshot.
            time.sleep(0.03)
            while not updates.empty():
                pending.append(updates.get_nowait())
            refresh = False
            for kind, value in pending:
                if kind == "exit":
                    return value
                if kind == "status":
                    right = value
                elif kind == "clear":
                    left = []
                elif kind == "windows":
                    refresh = True
            if refresh:
                try:
                    def query(command):
                        return json.loads(subprocess.check_output(
                            ["niri", "msg", "--json", command], text=True, timeout=2,
                        ))
                    left = window_blocks(query("windows"), query("workspaces"))
                except (subprocess.SubprocessError, ValueError):
                    left = []
            print(("" if first else ",") + json.dumps(left + right), flush=True)
            first = False
    finally:
        stopped.set()
        for process in event_processes[:]:
            process.terminate()
        status.terminate()
        status.wait()


if __name__ == "__main__":
    try:
        sys.exit(main())
    except BrokenPipeError:
        pass
