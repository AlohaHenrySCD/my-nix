{
  description = "AlohaHenry's Asahi-NixOS & macOS configuration";

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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nirinit = {
    #   url = "github:amaanq/nirinit";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # frpc.url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-14/frpc_linux_arm64";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nirimod,
      home-manager,
      nix-darwin,
      # nirinit,
      # frpc,
      ...
    }:
    let
      linuxSystem = "aarch64-linux";
      darwinSystem = "aarch64-darwin";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.alohahenry = {
                imports = [
                  ./home/home.nix
                  ./home/linux.nix
                ];
              };
            };
          }
        ];
      };

      # macbook here is host name NEED MODIFY
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.alohahenry = {
                imports = [
                  ./home/home.nix
                  ./home/darwin.nix
                ];
              };
            };
          }
        ];
      };

      formatter.${linuxSystem} = nixpkgs.legacyPackages.${linuxSystem}.nixfmt-rfc-style;
      formatter.${darwinSystem} = nixpkgs.legacyPackages.${darwinSystem}.nixfmt-rfc-style;
    };
}
