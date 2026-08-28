{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.homeDirectory = "/home/alohahenry";
  home.packages = with pkgs; [
    netease-cloud-music-gtk
    halloy
    qbittorrent
    ncspot
    libreoffice
    obsidian
    localsend
    glib
    gtk4
    gcc
    pavucontrol
    fuzzel
    mako
    libnotify
    kdePackages.kate
    papers
    (pkgs.osu-lazer.overrideAttrs (old: {
      meta = old.meta // {
        platforms = old.meta.platforms ++ [ "aarch64-linux" ];
      };
    }))
    prismlauncher
    polychromatic
  ];

  programs.obs-studio = {
    enable = true;
  };
  programs.alacritty.enable = true;
  # home.sessionVariables = {
  #   XMODIFIERS = "@im=fcitx";
  # };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Symbols Nerd Font Mono"
      ];

      sansSerif = [
        "Noto Sans"
        "Symbols Nerd Font"
      ];

      serif = [
        "Noto Serif"
        "Symbols Nerd Font"
      ];
    };
  };

  programs.kitty = {
    keybindings = {
      "esc" =
        "combine : send_text all \\x1b : launch --type=background ${pkgs.fcitx5}/bin/fcitx5-remote -c";
    };
  };

  programs.fish = {
    shellAliases = {
      bd = "sudo nixos-rebuild switch --impure --flake /etc/nixos ";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
    };
  };

  programs.i3bar-river = {
    enable = true;
    settings = {
      font = "JetBriansMono Nerd Font Bold 15";
      height = 22;
      tags_padding = 25;
      separator_width = 1;
      command = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
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
            interval = 15;
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
            interval = 1;
          }
          {
            block = "cpu";
            format = "$icon $utilization";
            interval = 1;
          }
          {
            block = "battery";
            format = "$icon $percentage $time";
            full_format = "$icon";
            interval = 3;
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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;

  xdg.configFile."mako/config".source = ./mako;
  xdg.configFile."fcitx5/config".source = ./fcitx5;

  home.pointerCursor = {
    enable = true;
    # package = pkgs.bibata-cursors;
    package = pkgs.everforest-cursors;
    # package = pkgs.phinger-cursors;
    # name = "Bibata-Modern-Ice";
    name = "everforest-cursors";
    # name = "phinger-cursors-light";
    size = 24;

    gtk.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark";
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    # cursorTheme = {
    #   name = "Bibata-Modern-Ice";
    #   package = pkgs.bibata-cursors;
    # };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      # gtk-cursor-theme-name = "Bibata-Modern-Ice";
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
      # gtk-cursor-theme-name = "Bibata-Modern-Ice";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = "ocean";
      gtk-xft-dpi = 196608;
    };
  };
}
