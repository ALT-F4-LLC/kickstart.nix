{
  description = "Example kickstart Home Manager environment.";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    home-manager,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {};
      flake = {
        homeConfigurations = let
          homeManagerModule = import ./module/home-manager.nix {
            homeDirectory = throw "<enter homeDirectory in flake.nix>"; # TODO: home directory of the user
            username = throw "<enter username in flake.nix>"; # TODO: username of the user
          };
          homeManager = system:
            home-manager.lib.homeManagerConfiguration {
              modules = [homeManagerModule];
              pkgs = nixpkgs.legacyPackages.${system};
            };
        in {
          aarch64-darwin = homeManager "aarch64-darwin";
          aarch64-linux = homeManager "aarch64-linux";
          x86_64-darwin = homeManager "x86_64-darwin";
          x86_64-linux = homeManager "x86_64-linux";
        };
      };
    };
}
