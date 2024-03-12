{
  description = "Example kickstart Go package project.";

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
        inherit
          (pkgs)
          buildGoPackage
          curlMinimal
          mkShell
          just
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
        name = "example";
        version = "latest";
      in {
        devShells = {
          default = mkShell {
            inputsFrom = [self'.packages.default];
            buildInputs = [just];
          };
        };

        packages = {
          default = buildGoPackage {
            inherit name;
            goDeps = ./deps.nix;
            goPackagePath = "github.com/example/${name}";
            src = ./.;
            subPackages = ["cmd/example"];
          };

          docker = buildImage {
            inherit name;
            tag = version;
            # https://ryantm.github.io/nixpkgs/builders/images/dockertools/#ssec-pkgs-dockerTools-helpers
            copyToRoot = [
              binSh
              caCertificates
              curlMinimal
              usrBinEnv
            ];
            config = {
              Cmd = ["${self'.packages.default}/bin/${name}"];
            };
          };
        };
      };
    };
}
