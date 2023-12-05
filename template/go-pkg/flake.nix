{
  description = "Example kickstart Go package project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          name = "example";
          version = "latest";
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
            };
          };

          packages = {
            default = pkgs.buildGoPackage {
              goDeps = ./deps.nix;
              goPackagePath = "github.com/example/${name}";
              name = name;
              src = ./.;
              subPackages = [ "cmd/example" ];
            };

            docker = pkgs.dockerTools.buildDockerImage {
              name = "${name}-docker";
              tag = version;

              config = {
                Cmd = "${self'.packages.default}/bin/${name}";
              };

              created = "now";
            };
          };
        };
    };
}
