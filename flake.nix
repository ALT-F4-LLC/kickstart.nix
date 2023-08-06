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
      # system: aarch64-darwin aarch64-linux x86_64-darwin x86_64-linux
      system = "<insert-system>";
      # username: should match your host username
      username = "<insert-username>";
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
              modules = [
                {
                  nix = {
                    settings = {
                      auto-optimise-store = true;
                      builders-use-substitutes = true;
                      experimental-features = [ "nix-command" "flakes" ];
                      substituters = [
                        "https://nix-community.cachix.org"
                      ];
                      trusted-public-keys = [
                        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                      ];
                      trusted-users = [ "@wheel" ];
                      warn-dirty = false;
                    };
                  };
                  programs.zsh.enable = true;
                  services.nix-daemon.enable = true;
                  users.users.${username}.home = "/Users/${username}";

                  # add more nix-darwin settings here
                }

                inputs.home-manager.darwinModules.home-manager
                {
                  # add home-manager settings here
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  # add home-manager user settings here
                  home-manager.users."${username}" = { pkgs, ... }: {
                    home.packages = with pkgs; [ git neovim ];
                    home.stateVersion = "23.05";
                  };
                }

                # add more nix modules here
              ];
            };
        };
      };
    };
}
