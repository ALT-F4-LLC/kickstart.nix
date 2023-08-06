{
  description = "My NixOS configuration";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
    let
      ### START OPTIONS ###
      username = "erikreinert"; # should match your host username
      ### END OPTIONS ###

      ### START SYSTEMS ###
      darwin-system = import ./system/darwin.nix { inherit inputs username; };
      nixos-system = import ./system/nixos.nix { inherit inputs username; };
      ### END SYSTEMS ###
    in
    {
      darwinConfigurations = {
        darwin-aarch64 = darwin-system "aarch64-darwin";
        darwin-x86_64 = darwin-system "x86_64-darwin";
      };

      nixosConfigurations = {
        nixos-aarch64 = nixos-system "aarch64-linux";
        nixos-x86_64 = nixos-system "x86_64-linux";
      };
    };
}
