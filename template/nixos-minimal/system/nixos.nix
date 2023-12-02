{ inputs, username, password }:

system:

let
  hardware-configuration = import ./hardware-configuration.nix;
  configuration = import ../module/configuration.nix;
  home-manager = import ../module/home-manager.nix;
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  # modules: allows for reusable code
  modules = [
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      security.sudo.enable = true;
      security.sudo.wheelNeedsPassword = false;
      services.openssh.enable = true;
      services.openssh.settings.PasswordAuthentication = false;
      services.openssh.settings.PermitRootLogin = "no";
      users.mutableUsers = false;
      users.users."${username}" = {
        extraGroups = [ "wheel" ];
        home = "/home/${username}";
        isNormalUser = true;
        password = password;
      };
      system.stateVersion = "23.11";
    }
    hardware-configuration
    configuration

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
