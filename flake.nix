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
      system = "example";
      username = "example";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ system ];
      flake = {
        darwinConfigurations = {
          kickstart-darwin = inputs.darwin.lib.darwinSystem
            {
              system = system;
              modules = [
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users."${username}" = { pkgs, ... }: {
                    home.packages = [ pkgs.neovim ];
                  };
                }
              ];
            };
        };

        nixosConfigurations = {
          kickstart-nixos = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              # copy this from your NixOS host at /etc/nix/hardward-configuration.nix
              # ./hardware-configuration.nix

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${username}" = { pkgs, ... }: {
                  home.packages = [ pkgs.neovim ];
                };
              }
            ];
          };
        };
      };
    };
}
