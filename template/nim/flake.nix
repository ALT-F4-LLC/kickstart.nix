{
  description = "Kickstart Nim package flake.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        self',
        pkgs,
        ...
      }: let
        name = "nim";
        version = "0.1.0";

        inherit (pkgs) buildNimPackage;
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [self'.packages.default];
        };

        packages = {
          default = buildNimPackage {
            inherit version;
            pname = name;
            src = ./.;
          };
        };
      };
    };
}
