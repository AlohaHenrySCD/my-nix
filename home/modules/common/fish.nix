{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "Hello! AlohaHenry"
      set -g fish_cursor_default block
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
      # rm = ''
      #   mkdir -p ~/.trash
      #   mv -- $argv ~/.trash/
      # '';
      manrg = ''
        man $argv[1] | col -b | rg -C 3 -- $argv[2]
      '';
      fd = ''
        find . -iname $argv[1] 2>/dev/null
      '';
    };
  };
}
