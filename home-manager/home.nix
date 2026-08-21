{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    netease-cloud-music-gtk
    ansifilter
    halloy
    eza
    ripgrep
    zoxide
    jq
    qbittorrent
    ncspot
    libreoffice
    # animeko
    # localsend

    uv
    black
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    clang
    clang-tools
    bash-language-server
    vscode-css-languageserver
    yaml-language-server
    fish-lsp
    haskell-language-server
    superhtml
    typescript-language-server
    vscode-json-languageserver
    texlab
    marksman
    nil
    ty
    taplo
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

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "EverForest";
    };
    iconTheme = {
      name = "papirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "papirus_cursors";
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = true;
      gtk-cursor-blink = true;
      gtk-cursor-blink-time = 500;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-menu-images = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
      gtk-toolbar-style = 3;
      gtk-xft-dpi = 196608;
    };

    gtk4.extraConfig = {
      gtk-cursor-blink = true;
      gtk-cursor-blink-time = 500;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
      gtk-xft-dpi = 196608;
    };
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;

  xdg.configFile."mako/config".source = ./mako;

  xdg.configFile."tlrc/config/toml".source = ./tlrc.toml;

  programs.obs-studio = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "Hello! AlohaHenry"
      # set fish_cursor_default block
      abbr --add add --set-cursor='%' 'nix shell nixpkgs#%'
    '';
    shellAbbrs = {
      ls = "eza";
      la = "eza -a";
      ll = "eza -al";
      cd = "z";
      grep = "rg";
    };
    shellAliases = {
      bd = "sudo nixos-rebuild switch --impure --flake /etc/nixos ";
    };
    functions = {
      mkcd = ''
        mkdir -p -- $argv[1]
        and cd -- $argv[1]
      '';
      rm = ''
        mkdir -p ~/.trash
        mv -- $agrv ~/.trash/
      '';
      manrg = ''
        man $argv[1] | col -b | rg -C 3 -- $argv[2]
      '';

    };
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

      nixpkgs = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_nixpkgs.pub";
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

  programs.bash = {
    enable = true;

  };

  xdg.configFile."fcitx5/config".source = ./fcitx5;
  xdg.configFile."kitty/Everforest.conf".source = ./Everforest.conf;
  programs.kitty = lib.mkForce {
    enable = true;
    # mouse_map = "mouse_map left release ungrabbed mouse_handle_click selection link";
    keybindings = {
      "esc" =
        "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
    };
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
