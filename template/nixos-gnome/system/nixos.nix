{ inputs, username, password }:

system:

let
  configuration = import ../module/configuration.nix;
  hardware-configuration = import /etc/nixos/hardware-configuration.nix; # copy this locally to no longer run --impure
  home-manager = import ../module/home-manager.nix;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  # modules: allows for reusable code
  modules = [
    hardware-configuration
    configuration

    {
      environment.systemPackages = with pkgs; [
        neovim
      ];
      services.xserver.displayManager.autoLogin.user = username;
      users.users."${username}" = {
        extraGroups = [ "networkmanager" "wheel" ];
        home = "/home/${username}";
        isNormalUser = true;
        password = password;
      };
    }

    inputs.home-manager.nixosModules.home-manager
    {
      # add home-manager settings here
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = home-manager;
    }

    # add more nix modules here
  ];
}
