{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    usbutils
    tree
    vesktop
    wechat
    chromium
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
}
