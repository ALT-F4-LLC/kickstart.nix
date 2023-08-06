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
      hardware-config = import ./modules/hardware-configuration.nix; # maintains hardware options
      system-config = import ./modules/configuration.nix; # maintains nix options
      home-manager-config = import ./modules/home-manager.nix; # maintains home-manager user options
      ### END MODULES ###
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # systems: archs this flake supports (can be more than 1 system)
      systems = [ "aarch64-darwin" "aarch64-linux" ];
      flake = {
        darwinConfigurations = {
          kickstart-darwin = inputs.darwin.lib.darwinSystem
            {
              # system: supports only 1 system
              system = "aarch64-darwin";
              # modules: allows for reusable code
              modules = [
                {
                  services.nix-daemon.enable = true;
                  users.users.${username}.home = "/Users/${username}";
                }
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

        nixosConfigurations = {
          kickstart-nixos = inputs.nixpkgs.lib.nixosSystem
            {
              # system: supports only 1 system
              system = "aarch64-linux";
              # modules: allows for reusable code
              modules = [
                {
                  users.mutableUsers = false;
                  users.users."${username}".extraGroups = [ "wheel" ];
                  users.users."${username}".password = "password";
                  users.users."${username}".home = "/home/${username}";
                  users.users."${username}".isNormalUser = true;
                }
                hardware-config
                system-config
                # add more nix modules here
              ];
            };
        };
      };
    };
}

