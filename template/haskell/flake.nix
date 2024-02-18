{
  description = "Example kickstart Haskell application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) dockerTools haskellPackages;
          inherit (dockerTools) buildImage;
          inherit (haskellPackages) mkDerivation;
          name = "example";
          version = "0.1.0";
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
              buildInputs = with pkgs; [ cabal-install ];
            };
          };
          packages = {
            default = mkDerivation {
              pname = name;
              inherit version;
              src = ./.;
              license = "";
              description = "";
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
