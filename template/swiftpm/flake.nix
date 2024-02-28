{
  description = "Example kickstart Bash application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) swift clang swift-corelibs-libdispatch;
          inherit (pkgs.dockerTools) buildImage;
          inherit (pkgs.swiftPackages) swiftpm Foundation;
          name = "example";
          version = "0.1.0";
        in
        {
          devShells.default = pkgs.mkShell.override { stdenv = swift.stdenv; } {
            inputsFrom = [ self'.packages.default ];
            shellHook = ''
                export LD_LIBRARY_PATH="${swift-corelibs-libdispatch}/lib"
                export CC=clang
            '';
          };

          packages = {
            default = pkgs.stdenv.mkDerivation {
              inherit name version;
              src = ./.;

              stdenv = swift.stdenv;
              buildInputs = [
                clang
                swift
                swiftpm
                Foundation
              ];

              buildHook = ''
                export LD_LIBRARY_PATH="${swift-corelibs-libdispatch}/lib"
                export CC=clang

                swift build
              '';
            };

            docker = buildImage {
              inherit name;
              tag = version;
              config = {
                Cmd = [ "${self'.packages.default}/bin/${name}" ];
                Env = [
                  "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                ];
              };
            };
          };
        };
    };
}
