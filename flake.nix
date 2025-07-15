{
  description = "Kickstart templates to get started building with Nix.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }: let
    lib = import ./lib {inherit inputs;};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        templates = {
          bash = {
            description = "Kickstart Bash language module flake.";
            path = ./template/bash;
          };

          cpp-cmake = {
            description = "Kickstart C++ CMake project flake.";
            path = ./template/cpp-cmake;
          };

          dart = {
            description = "Kickstart Dart package flake.";
            path = ./template/dart;
          };

          darwin = {
            description = "Kickstart macOS development environment flake.";
            path = ./template/darwin;
          };

          go-mod = {
            description = "Kickstart Go language module flake.";
            path = ./template/go-mod;
          };

          haskell = {
            description = "Kickstart Haskell package flake.";
            path = ./template/haskell;
          };

          home-manager = {
            description = "Kickstart Home Manager environment flake.";
            path = ./template/home-manager;
          };

          lua-app = {
            description = "Kickstart Lua application flake.";
            path = ./template/lua-app;
          };

          nestjs = {
            description = "Kickstart NestJS application flake.";
            path = ./template/nestjs;
          };

          nixos-desktop = {
            description = "Kickstart NixOS desktop environment flake.";
            path = ./template/nixos-desktop;
          };

          nixos-minimal = {
            description = "Kickstart NixOS minimal environment flake.";
            path = ./template/nixos-minimal;
          };

          nodejs-backend = {
            description = "Kickstart Node.js backend package flake.";
            path = ./template/nodejs-backend;
          };

          ocaml = {
            description = "Kickstart OCaml package flake.";
            path = ./template/ocaml;
          };

          php = {
            description = "Kickstart PHP application flake.";
            path = ./template/php;
          };

          powershell = {
            description = "Kickstart Powershell application flake.";
            path = ./template/powershell;
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

          swiftpm = {
            description = "Kickstart Swift package flake.";
            path = ./template/swiftpm;
          };

          vite-react = {
            description = "Kickstart Vite React package flake.";
            path = ./template/vite-react;
          };

          zig = {
            description = "Kickstart Zig package flake.";
            path = ./template/zig;
          };

          nim = {
            description = "Kickstart Nim package flake.";
            path = ./template/nim;
          };

          tf = {
            description = "Kickstart Terraform project flake.";
            path = ./template/terraform;
          };
        };
      };

      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) alejandra callPackage just jq mkShell;
      in {
        devShells = {
          default = mkShell {
            buildInputs = [just jq];
          };
        };

        formatter = alejandra;

        packages = let
          mkDarwin = callPackage lib.flake.mkDarwin;
          mkHomeManager = callPackage lib.flake.mkHomeManager;
          mkLanguage = callPackage lib.flake.mkLanguage;
          mkNixosDesktop = callPackage lib.flake.mkNixosDesktop;
          mkNixosMinimal = callPackage lib.flake.mkNixosMinimal;
        in {
          example-bash = mkLanguage {name = "bash";};
          example-cpp-cmake = mkLanguage {name = "cpp-cmake";};
          example-dart = mkLanguage {name = "dart";};
          example-darwin = mkDarwin {};
          example-go-mod = mkLanguage {name = "go-mod";};
          example-haskell = mkLanguage {name = "haskell";};
          example-home-manager = mkHomeManager {};
          example-lua-app = mkLanguage {name = "lua-app";};
          example-nestjs = mkLanguage {name = "nestjs";};
          example-nixos-desktop-gnome = mkNixosDesktop {desktop = "gnome";};
          example-nixos-desktop-plasma5 = mkNixosDesktop {desktop = "plasma5";};
          example-nixos-minimal = mkNixosMinimal {};
          example-nodejs-backend = mkLanguage {name = "nodejs-backend";};
          example-ocaml = mkLanguage {name = "ocaml";};
          example-php = mkLanguage {name = "php";};
          example-powershell = mkLanguage {name = "powershell";};
          example-python-app = mkLanguage {name = "python-app";};
          example-python-pkg = mkLanguage {name = "python-pkg";};
          example-rust = mkLanguage {name = "rust";};
          example-swiftpm = mkLanguage {name = "swiftpm";};
          example-vite-react = mkLanguage {name = "vite-react";};
          example-zig = mkLanguage {name = "zig";};
          example-nim = mkLanguage {name = "nim";};
          example-tf = mkLanguage {name = "terraform";};
        };
      };
    };
}
