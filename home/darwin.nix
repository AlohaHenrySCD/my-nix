{ ... }:
{
  home.homeDirectory = "/Users/alohahenry";
  programs.man.generateCaches = false;
  targets.darwin.copyApps.enable = true;
}
