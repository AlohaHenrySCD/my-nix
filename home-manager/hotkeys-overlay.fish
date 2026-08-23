# ~/.config/kitty/show-hotkeys.fish

begin
    printf '\e[1;36m━━ KITTY ━━\e[0m\n\n'

    kitty --debug-config 2>&1 | awk '
        /^Added shortcuts:/   { show=1; print; next }
        /^Changed shortcuts:/ { show=1; print; next }
        /^Removed shortcuts:/ { show=0 }
        show && /^[[:space:]]/ { print }
    '

    printf '\n\e[1;36m━━ FISH ━━\e[0m\n\n'

    for mode in (bind -L)
        set bindings (bind --user -M $mode 2>/dev/null)

        if test (count $bindings) -gt 0
            printf '\e[1;33m[%s]\e[0m\n' $mode
            printf '%s\n' $bindings
            printf '\n'
        end
    end
end | fzf \
    --ansi \
    --no-sort \
    --layout=reverse \
    --border \
    --prompt='Hotkeys > ' \
    --info=inline
