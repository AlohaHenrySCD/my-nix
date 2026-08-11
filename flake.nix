{
  description = "NixOS starter flake with Apple Silicon support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nirimod = {
      url = "github:srinivasr/nirimod";
    };
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix-plugins.url = "github:maxschipper/helix-plugins-nix";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # frpc.url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-14/frpc_linux_arm64";
    # clash-verge-rev = {
    #   url = "github:clash-verge-rev/clash-verge-rev";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      nirimod,
      home-manager,
      helix-plugins,
      hjem,
      frpc,
      # clash-verge-rev,
      ...
    }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # environment.systemPackages = [
      #   inputs.nirimod.packages.${pkgs.system}.default
      # ];
      # devShells.${system}.default = pkgs.mkShell {
      #   nativeBuildInputs = with pkgs; [
      #     rustc
      #     cargo
      #     rustfmt
      #     clippy
      #     rust-analyzer
      #   ];
      #   RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      # };
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hjem.nixosModules.default
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alohahenry = import ./home-manager/home.nix;
              # users.root = /home/alohahenry/.config/home-manager/home.nix;
            };
          }
        ];
      };

      # packages.${system}.default = pkgs.stdenv.mkDerivation {
      #   src = clash-verge-rev;
      # }

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
