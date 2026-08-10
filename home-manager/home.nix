{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    clash-verge-rev
    ansifilter
    eza
    ripgrep
  ];
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  home.username = "alohahenry";
  home.homeDirectory = "/home/alohahenry";
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;

  xdg.configFile."tlrc/config/toml".source = ./tlrc.toml;

  programs.obs-studio = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "AlohaHenry";
      user.email = "aloha.henry.2018@gmail.com";
    };
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      blog = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_blog";
      };

      my-nix = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };

  };

  xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship = {
    enableFishIntegration = true;
  };

  programs.starship.enable = true;

  programs.i3bar-river = {
    enable = true;
    settings = {
      font = "JetBriansMono Nerd Font Bold 15";
      height = 22;
      tags_padding = 25;
      separator_width = 1;
      command = "i3status-rs /home/alohahenry/.config/i3status-rust/config-default.toml";
      background = "#3C4841FF";
      color = "#d3c6aaff";
      separator = "#83c092ff";
      tag_fg = "#dbbc7fff";
      tag_bg = "#3C4841FF";
      tag_focused_fg = "#3C4841FF";
      tag_focused_bg = "#a7c080ff";
      tag_urgent_fg = "#3C4841FF";
      tag_urgent_bg = "#e67e80ff";
      tag_inactive_fg = "#dbbc7fff";
      tag_inactive_bg = "#3C4841FF";
    };
  };
  programs.i3status-rust.enable = true;
  programs.i3status-rust = {
    bars = {
      default = {
        blocks = [
          {
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
            alert = 10.0;
            format = "$icon$available";
          }
          # {
          #   block = "keyboard_layout";
          # }
          {
            block = "memory";
            format = "^icon_memory_mem $mem_used_percents";
            interval = 3;
          }
          {
            block = "cpu";
            format = "$icon $utilization";
            interval = 3;
          }
          {
            block = "battery";
            format = "$icon $percentage $time";
            full_format = "$icon";
            interval = 5;
          }
          {
            block = "net";
            format = "$icon ";
          }
          {
            block = "sound";
            format = "$icon {$volume.eng(w:2)|}";
          }
          {
            block = "time";
            format = "$timestamp.datetime(f:'%a%m/%d %R') ";
            interval = 60;
          }
        ];
        settings = {
          theme = {
            theme = "gruvbox-light";
            # overrides = {
            #   separator_fg = "#A7C080FF";
            # };
          };
        };
        icons = "material-nf";
      };
    };
  };

  # programs.waybar.enable = true;
  # programs.waybar.settings.main = {
  #   layer = "top";
  #   position = "top";
  #   height = 25;
  #   output = [
  #     "eDP-1"
  #     "HDMI-A-1"
  #   ];
  #   modules-left = ["niri/workspace" "pulseaudio" "clock"];
  #   modules-center = ["niri/window"];
  #   modules-right = ["battery" "bluetooth" "cpu" "memory" "load" "network" "temperature"];
  #   cpu = {
  #     interval = 30;
  #     format = " {usage}%";
  #     cursor = true;
  #     status = {
  #       warning = 80;
  #       critival = 90;
  #     };
  #   };
  #   memory = {
  #     interval = 30;
  #     format = "  {used:0.1f}G";
  #     status = {
  #       warning = 80;
  #       critival = 90;
  #     };
  #   };
  #   temperature = {
  #     interval = 10;
  #     format = "{icon} {temperatureC}°";
  #     critical-threshold = 90;
  #     format-icons = ["" "" "" "" ""];
  #   };
  #   pulseaudio = {
  #     format = "{icon}";
  #     format-bluetooth = "{icon}";
  #     tooltip-format = "{volume}%";
  #     format-muted = "<span size='12pt'>󰝟</span>";
  #     scroll-step = 2;
  #     on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
  #     on-click-right = "hyprctl eval \"hl.exec_cmd('pavucontrol -t 4')\"";
  #     format-icons = {
  #       "headphone" = "";
  #       "hands-free" = "";
  #       "headset" = "";
  #       "phone" = "";
  #       "portable" = "";
  #       "car" = "";
  #       "default" = [
  #         "<span size='12pt'>󰕿</span>"
  #         "<span size='12pt'>󰖀</span>"
  #         "<span size='12pt'>󰕾</span>"
  #       ];
  #     };
  #   };
  #   "niri/workspaces" = {
  #       "format" = "{icon}";
  #       "cursor"  = true;
  #       "on-scroll-up" = "niri msg action focus-workspace-up";
  #       "on-scroll-down" = "niri msg action focus-workspace-down";
  #       "hide-empty" = true;
  #       "format-icons" = {
  #           "active" = "󰮯";
  #           "default" = "";
  #           "empty" = "";
  #       };
  #   };
  #   "pulseaudio/slider" = {
  #     "min" = 0;
  #     "max" = 100;
  #     "cursor" = true;
  #     "on-click-right" = "hyprctl eval \"hl.exec_cmd('pavucontrol -t 4')\"";
  #   };
  #   "battery" = {
  #       "interval" = 20;
  #       "full-at" = 100;
  #       "tooltip" = true;
  #       "format-full" = "";
  #       "format" = "{icon} {capacity}%";
  #       "format-time" = "{H}:{M:02}";
  #       "format-charging" = " {capacity}% ({time})";
  #       "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂂" "󰁹"];
  #       "states" = {
  #           "warning" = 30;
  #           "critical" = 15;
  #       };
  #   };
  #   "clock" = {
  #       "timezone" = "America/Argentina/Buenos_Aires";
  #       "tooltip-format" = "<tt><small>{calendar}</small></tt>";
  #       "format-alt" = "{ :%H :%M %d %B %Y}";
  #       "on-click-right" = "hyprctl eval \"hl.exec_cmd('alacritty --class=peaclock -e peaclock')\"";
  #       "calendar" = {
  #           "mode" = "year";
  #           "weeks-pos" = "right";
  #           "mode-mon-col" = 3;
  #           "format" = {
  #               "months" =   "<span color='#acb0d0'><b>{}</b></span>";
  #               "weeks" =    "<span color='#7aa2f7'><b>W{}</b></span>";
  #               "weekdays" = "<span color='#e0af68'><b>{}</b></span>";
  #               "days" =     "<span color='#acb0d0'><b>{}</b></span>";
  #               "today" =    "<span color='#41a6b5'><b><u>{}</u></b></span>";
  #           };
  #       };
  #   };
  # };

  programs.bash = {
    enable = true;

    # initExtra = ''
    #   # include .profile if it exists
    #   [[ -f ~/.profile]] && . ~/.profile
    #   '';
  };

  # Will define in configuration.nix
  # fonts.fontconfig = {
  #   enable = true;
  #   defaultFonts = {
  #     monospace = [
  #       "JetBrainsMono Nerd Font"
  #       "Symbols Nerd Font Mono"
  #     ];

  #     sansSerif = [
  #       "Noto Sans"
  #       "Symbols Nerd Font"
  #     ];

  #     serif = [
  #       "Noto Serif"
  #       "Symbols Nerd Font"
  #     ];
  #   };
  # };

  xdg.configFile."kitty/Everforest.conf".source = ./Everforest.conf;
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      font_size = 13;
      confirm_os_window_close = 0;
      include = "Everforest.conf";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      font_family = "JetBrainsMonoNL Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      hide_window_decorations = "titlebar-only";
      window_padding_width = 10;
      remember_window_size = "yes";

      # cursor = "none";
      cursor_trail = 1;
      cursor_trail_decay = "0.05 0.4";
      cursor_trail_start_threshold = 0;
      cursor_blink_interval = "0.5 ease-in-out";

      scrollback_pager = "sh -c 'cat > /tmp/kitty-scrollback.txt && ansifilter -i /tmp/kitty-scrollback.txt -o /tmp/kitty-scrollback-filtered.txt && hx /tmp/kitty-scrollback-filtered.txt'";
      "map alt+q" = "show_scrollback";
    };
  };

  xdg.configFile."helix/languages.toml".source = ./helix-languages.toml;
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "everforest_dark";
      editor = {
        completion-trigger-len = 1;
        idle-timeout = 0;
        completion-replace = true;
        soft-wrap.enable = true;
        line-number = "relative";
        mouse = false;
        cursorline = true;
        bufferline = "always";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        indent-guides.render = true;
        indent-guides.skip-levels = 1;
      };
      keys.normal = {
        w = "rotate_view";
        C-j = "jump_view_left";
        C-k = "jump_view_down";
        C-l = "jump_view_up";
        "C-;" = "jump_view_right";
        j = "move_char_left";
        k = "move_line_down";
        l = "move_line_up";
        ";" = "move_char_right";
        C-q = ":wq";
        C-Q = ":q!";
      };
      keys.select = {
        j = "extend_char_left";
        k = "extend_line_down";
        l = "extend_line_up";
        ";" = "extend_char_right";
      };

    };

  };
}
