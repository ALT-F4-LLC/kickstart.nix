{
  description = "Example kickstart Node.js backend project.";

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
        ...
      }: let
        name = "example";
        version = "0.1.0";
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [pkgs.prefetch-npm-deps];
            inputsFrom = [self'.packages.default];
          };
        };

        packages = {
          default = pkgs.buildNpmPackage {
            inherit version;
            pname = name;
            src = ./.;
            npmDepsHash = "sha256-KeXRIp4qNywb1sy5lXTagoUsW6EeK1kF5OWJ97w9Vfk=";
            installPhase = ''
              cp --no-preserve=mode -r dist $out
            '';
          };
        };
      };
    };
}
