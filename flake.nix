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
      systems = [ system ];
      flake = {
        darwinConfigurations = {
          kickstart-darwin = inputs.darwin.lib.darwinSystem
            {
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
                }

                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users."${username}" = { pkgs, ... }: {
                    home.packages = [ pkgs.git pkgs.neovim ];
                    home.stateVersion = "23.05";
                  };
                }
              ];
            };
        };
      };
    };
}
