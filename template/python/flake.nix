{
  description = "Example kickstart Python project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) python3Packages;
          inherit (python3Packages) buildPythonApplication buildPythonPackage;
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [
                self'.packages.myapp # only need to specify top-level packages
              ];
            };
          };

          packages = {
            mylib = buildPythonPackage {
              pname = "mylib";
              src = ./package;
              version = "1.0.0";
            };

            myapp = buildPythonApplication {
              buildInputs = [ ]; # build and/or run-time (ie. non-Python dependencies)
              nativeBuildInputs = [ ]; # build-time only (ie. setup_requires)
              nativeCheckInputs = [ ]; # checkPhase only (ie. tests_require)
              pname = "myapp";
              propagatedBuildInputs = [ self'.packages.mylib ];
              src = ./application;
              version = "1.0.0";
            };
          };
        };
    };
}
