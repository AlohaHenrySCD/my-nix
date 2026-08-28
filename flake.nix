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
    # nirinit = {
    #   url = "github:amaanq/nirinit";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # frpc.url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-14/frpc_linux_arm64";
  };

  outputs =
    {
      self,
      nixpkgs,
      nirimod,
      home-manager,
      # nirinit,
      # frpc,
      ...
    }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # hjem.nixosModules.default
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.alohahenry = import ./home-manager/home.nix;
              # users.root = /home/alohahenry/.config/home-manager/home.nix;
            };
          }
        ];
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
