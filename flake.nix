{
  description = "Kickstart templates to get started building with Nix.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, self, ... }:
    let
      lib = import ./lib { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        templates = {
          darwin = {
            description = "Kickstart macOS development environment flake.";
            path = ./template/darwin;
          };

          go-mod = {
            description = "Kickstart Go language module flake.";
            path = ./template/go-mod;
          };

          go-pkg = {
            description = "Kickstart Go language package flake.";
            path = ./template/go-pkg;
          };

          nixos-desktop = {
            description = "Kickstart NixOS desktop environment flake.";
            path = ./template/nixos-desktop;
          };

          nixos-minimal = {
            description = "Kickstart NixOS minimal environment flake.";
            path = ./template/nixos-minimal;
          };

          python-app = {
            description = "Kickstart Python application flake.";
            path = ./template/python-app;
          };

          python-pkg = {
            description = "Kickstart Python package flake.";
            path = ./template/python-pkg;
          };

          rust = {
            description = "Kickstart Rust package flake.";
            path = ./template/rust;
          };
        };
      };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ just ];
          };
        };

        packages = {
          example-darwin = lib.flake.darwin system;
          example-go-mod = lib.flake.go-mod system;
          example-go-pkg = lib.flake.go-pkg system;
          example-nixos-desktop-gnome = lib.flake.nixos-desktop system "gnome";
          example-nixos-desktop-plasma5 = lib.flake.nixos-desktop system "plasma5";
          example-nixos-hardware = lib.flake.nixos-hardware system;
          example-nixos-minimal = lib.flake.nixos-minimal system;
          example-python-app = lib.flake.python-app system;
          example-python-pkg = lib.flake.python-pkg system;
          example-rust = lib.flake.rust system;
        };
      };

      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
    };
}
