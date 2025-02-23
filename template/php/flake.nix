{
  description = "Example kickstart PHP application project.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        lib,
        ...
      }: let
        inherit (pkgs) dockerTools php83 mkShell writeShellApplication;
        inherit (lib) getExe;
        inherit (dockerTools) buildImage;
        inherit (php83) buildComposerProject buildEnv;
        name = "example";
        version = "0.1.0";
        phpEnvironment = buildEnv {
          extensions = {
            enabled,
            all,
          }:
            enabled
            ++ (with all; [
              imagick
              opcache
            ]);

          extraConfig = "memory_limit=256M";
        };
      in {
        devShells = {
          default = mkShell {
            inputsFrom = [self'.packages.default];
          };
        };

        apps.default = {
          type = "app";
          program = getExe (writeShellApplication {
            inherit name;

            runtimeInputs = [
              phpEnvironment
            ];

            text = ''
              ${getExe phpEnvironment} ${self'.packages.default}/share/php/${name}/src/index.php
            '';
          });
        };

        packages = {
          default = buildComposerProject {
            inherit version;
            pname = name;
            src = ./.;
            vendorHash = "sha256-I/uxU1BWb+Uez4dork145EfKKoxHrcUGuyWlps1p628=";

            php = phpEnvironment;

            composerLock = ./composer.lock;
            composerNoDev = false;

            preInstall = ''
              ls -la
            '';
          };

          docker = buildImage {
            inherit name;
            tag = version;
            config = {
              Cmd = ["${self'.apps.default.program}"];
            };
          };
        };
      };
    };
}
