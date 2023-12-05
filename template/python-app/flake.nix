{
  description = "Example kickstart Python application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) python3Packages;
          inherit (python3Packages) buildPythonApplication;
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
            };
          };

          packages = {
            default = buildPythonApplication {
              buildInputs = [ ]; # build and/or run-time (ie. non-Python dependencies)
              nativeBuildInputs = [ ]; # build-time only (ie. setup_requires)
              nativeCheckInputs = [ ]; # checkPhase only (ie. tests_require)
              pname = "example";
              propagatedBuildInputs = [ ]; # build-time only propogated (ie. install_requires)
              src = ./.;
              version = "1.0.0";
            };
          };
        };
    };
}
