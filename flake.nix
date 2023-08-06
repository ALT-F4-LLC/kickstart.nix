{
  description = "Example kickstart Nix development setup.";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    let
      ### START OPTIONS ###
      system = "<insert system here>"; # aarch64-darwin aarch64-linux x86_64-darwin x86_64-linux
      username = "<insert username here>"; # should match your host username
      ### END OPTIONS ###

      ### START MODULES ###
      system-config = import ./modules/configuration.nix { inherit username; }; # maintains nix options
      home-manager-config = import ./modules/home-manager.nix; # maintains home-manager user options
      ### END MODULES ###
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # systems: archs this flake supports (can be more than 1 system)
      systems = [ system ];
      flake = {
        darwinConfigurations = {
          kickstart-darwin = inputs.darwin.lib.darwinSystem
            {
              # system: supports only 1 system
              system = system;
              # modules: allows for reusable code
              modules = [
                system-config

                inputs.home-manager.darwinModules.home-manager
                {
                  # add home-manager settings here
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users."${username}" = home-manager-config;
                }
                # add more nix modules here
              ];
            };
        };
      };
    };
}
