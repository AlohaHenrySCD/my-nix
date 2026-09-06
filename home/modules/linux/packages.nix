{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    usbutils
    wechat
    tree
    vesktop
    chromium
    netease-cloud-music-gtk
    halloy
    ncspot
    libreoffice
    localsend
    glib
    gcc
    gtk4
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
