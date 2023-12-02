{
  description = "Example kickstart Nix with Gnome development setup.";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      password = throw "<password>"; # TODO: replace with password and remove throw
      username = throw "<username>"; # TODO: replace with user name and remove throw

      nixos-system = import ./system/nixos.nix { inherit inputs password username; };
    in
    {
      nixosConfigurations = {
        aarch64 = nixos-system "aarch64-linux";
        x86_64 = nixos-system "x86_64-linux";
      };
    };
}
