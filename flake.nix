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
      # Pin Asahi (kernel 7.1.12); change this commit only for an intentional upgrade.
      # Then run: nix flake update nixos-apple-silicon
      url = "github:tpwrules/nixos-apple-silicon/fb602d1f8c6d83dd652fecc3f468328f8864f0c1";
      # To unpin, comment out the URL above and uncomment this one:
      # url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    kde-everforest = {
      url = "github:Serge2702/KDE-Everforest";
      flake = false;
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
      plasma-manager,
      # nirinit,
      # frpc,
      ...
    }:
    let
      mkNixos =
        {
          system,
          hostModules,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            hostModules
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                ];

                extraSpecialArgs = {
                  inherit inputs;
                };
                users.alohahenry.imports = [
                  ./home/home.nix
                  ./home/linux.nix
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        asahi = mkNixos {
          system = "aarch64-linux";
          hostModules = ./hosts/asahi;
        };

        x86_64 = mkNixos {
          system = "x86_64-linux";
          hostModules = ./hosts/x86_64;
        };
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

      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
