{
  description = "Example kickstart Nix development setup.";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
    let
      username = throw "<username>"; # TODO: replace with user name and remove throw 
      darwin-system = import ./system/darwin.nix { inherit inputs username; };
    in
    {
      darwinConfigurations = {
        darwin-aarch64 = darwin-system "aarch64-darwin";
        darwin-x86_64 = darwin-system "x86_64-darwin";
      };
    };
}
