{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kdePackages.kdenlive
    kazumi
    qemu
    (symlinkJoin {
      name = "wechat-scaled";
      paths = [ wechat ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        # Match the built-in display's 2x scale for WeChat's bundled Qt.
        wrapProgram "$out/bin/wechat" --set-default QT_SCALE_FACTOR 2
      '';
    })
    vesktop
    chromium
    netease-cloud-music-gtk
    ncspot
    obsidian
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
