{ inputs, username }:

system:

let
  hardware-configuration = import ../module/hardware-configuration.nix;
  configuration = import ../module/configuration.nix;
in
inputs.nixpkgs.lib.nixosSystem {
  system = system;
  # modules: allows for reusable code
  modules = [
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      security.sudo.enable = true;
      security.sudo.wheelNeedsPassword = false;
      services.openssh.enable = true;
      services.openssh.passwordAuthentication = false;
      services.openssh.permitRootLogin = "no";
      users.mutableUsers = false;
      users.users."${username}" = {
        extraGroups = [ "wheel" ];
        home = "/home/${username}";
        isNormalUser = true;
        password = "password";
      };
      system.stateVersion = "23.05";
    }
    hardware-configuration
    configuration
    # add more nix modules here
  ];
}
