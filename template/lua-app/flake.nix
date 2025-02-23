{
  description = "Description for the project";

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
        inherit (pkgs) mkShell writeShellApplication;
        src = ./src;
      in {
        devShells = {
          default = mkShell {
            buildInputs = [pkgs.lua];
          };
        };

        packages = {
          default =
            writeShellApplication
            {
              name = "example";
              text = ''
                (cd ${src} && ${pkgs.lua}/bin/lua ./example.lua)
              '';
            };
        };
      };
    };
}
