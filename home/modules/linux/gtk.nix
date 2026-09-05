{
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;
    gtk2.force = true;
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
