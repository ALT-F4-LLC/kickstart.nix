{
  description = "Example kickstart Bash application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) swiftpm2nix swift clang swift-corelibs-libdispatch;
          inherit (pkgs.dockerTools) buildImage;
          inherit (pkgs.swiftPackages) swiftpm Foundation;
          name = "example";
          version = "0.1.0";
        in
        {
          devShells.default = pkgs.mkShell.override { stdenv = swift.stdenv; } {
            buildInputs = [ swiftpm2nix ];
            inputsFrom = [ self'.packages.default ];
            shellHook = ''
                export LD_LIBRARY_PATH="${swift-corelibs-libdispatch}/lib"
                export CC=clang
            '';
          };

          packages = {
            default = let
              generated = swiftpm2nix.helpers ./nix;
            in swift.stdenv.mkDerivation {
              pname = name;
              inherit version;

              src = ./.;

              nativeBuildInputs = [ swift swiftpm pkgs.pkg-config ];
              buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [
                Foundation
              ];

              configurePhase = generated.configure
              + pkgs.lib.optionals pkgs.stdenv.isLinux ''
                export LD_LIBRARY_PATH="${swift-corelibs-libdispatch}/lib"
              '';

              installPhase = ''
                binPath="$(swiftpmBinPath)"
                mkdir -p $out/bin
                cp $binPath/${name} $out/bin/
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
