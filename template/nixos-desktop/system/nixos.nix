{ inputs, username, password, desktop ? "gnome" }:

system:

let
  configuration = import ../module/configuration.nix;
  enabledDesktopGnome = desktop == "gnome";
  enabledDesktopPlasma5 = desktop == "plasma5";
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

      # Use gnome desktop environment
      services.xserver.desktopManager.gnome.enable = enabledDesktopGnome;
      services.xserver.displayManager.gdm.enable = enabledDesktopGnome;

      # Use plasma5 desktop environment
      services.xserver.desktopManager.plasma5.enable = enabledDesktopPlasma5;
      services.xserver.displayManager.sddm.enable = enabledDesktopPlasma5;

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
