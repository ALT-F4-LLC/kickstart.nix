{
  description = "Example kickstart Nix development setup.";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      username = "<insert username>"; # should match your host username

      nixos-system = import ./system/nixos.nix { inherit inputs username; };
    in
    {
      nixosConfigurations = {
        nixos-aarch64 = nixos-system "aarch64-linux";
        nixos-x86_64 = nixos-system "x86_64-linux";
      };
    };
}
