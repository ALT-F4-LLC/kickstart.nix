{
  description = "Example kickstart PHP application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) dockerTools php83;
        inherit (dockerTools) buildImage;
        inherit (php83) buildComposerProject;
        name = "example";
        version = "0.1.0";
        phpEnvironment = php83.buildEnv {
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
          default = pkgs.mkShell {
            inputsFrom = [self'.packages.default];
          };
        };

        packages = {
          default = buildComposerProject {
            inherit version;
            pname = name;
            src = ./.;
            vendorHash = "sha256-I/uxU1BWb+Uez4dork145EfKKoxHrcUGuyWlps1p628=";

            php = phpEnvironment;

            composerLock = ./composer.lock;
          };

          docker = buildImage {
            inherit name;
            tag = version;
            config = {
              Cmd = ["${self'.packages.default}/bin/${name}"];
              Env = [
                "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              ];
            };
          };
        };
      };
    };
}
