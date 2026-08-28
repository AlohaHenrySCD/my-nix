{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # wechat
    # wechat-uos
    codex
    ansifilter
    eza
    ripgrep
    jq
    bat
    ov
    # animeko
    fzf
    tlrc
    navi
    hugo
    lazygit
    btop

    pkg-config

    (lib.hiPrio jdk25)
    (lib.lowPrio jdk8)

    python3
    uv
    black
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # clang
    lld
    llvm
    gnumake
    cmake
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
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
  };

  xdg.configFile."tlrc/config/toml".source = ./tlrc.toml;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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
      ove = "ov --exec --";
      # bd = "sudo nixos-rebuild switch --impure --flake /etc/nixos ";
    };
    functions = {
      mkcd = ''
        mkdir -p -- $argv[1]
        and cd -- $argv[1]
      '';
      rm = ''
        mkdir -p ~/.trash
        mv -- $argv ~/.trash/
      '';
      manrg = ''
        man $argv[1] | col -b | rg -C 3 -- $argv[2]
      '';
      fd = ''
        find . -iname $argv[1] 2>/dev/null
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
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        ControlMaster = "no";
        ControlPersist = "no";

      };
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
        identityFile = "~/.ssh/id_ed25519_nixpkgs";
      };
    };
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bash = {
    enable = true;

  };

  xdg.configFile."kitty/Everforest.conf".source = ./Everforest.conf;
  xdg.configFile."kitty/hotkeys-overlay.fish".source = ./hotkeys-overlay.fish;
  programs.kitty = {
    enable = true;
    # mouse_map = "mouse_map left release ungrabbed mouse_handle_click selection link";
    keybindings = {
      "ctrl+shift+q" = "no_op";
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+/" =
        "launch --type=overlay --title=Hotkeys fish -i ~/.config/kitty/hotkeys-overlay.fish";
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
