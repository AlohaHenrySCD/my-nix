{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/linux/packages.nix
    ./modules/linux/bar.nix
    ./modules/linux/gtk.nix
  ];

  home.homeDirectory = "/home/alohahenry";

  programs.obs-studio = {
    enable = true;
  };
  programs.alacritty.enable = true;

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
      bd = "sudo nixos-rebuild switch --impure --flake /etc/nixos#asahi";
    };
    shellAbbrs = {
      nix-clean = "nix-collect-garbage && sudo nix-collect-garbage && sudo journalctl --vacuum-size=300M";
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

  xdg.dataFile."color-schemes/Everforest.colors".source =
    inputs.kde-everforest + "/Everforest.colors";
  programs.plasma = {
    enable = true;

    workspace.colorScheme = "Everforest";

    panels = [
      {
        location = "top";
        height = 32;
        floating = false;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }

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

}
