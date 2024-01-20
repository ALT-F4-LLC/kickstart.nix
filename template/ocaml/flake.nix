{
  description = "Example kickstart OCaml application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) dockerTools ocaml-ng mkShell;
          inherit (dockerTools) buildImage;
          inherit (ocaml-ng) ocamlPackages_5_1;
          inherit (ocamlPackages_5_1) buildDunePackage;
          name = "example";
          version = "0.1.0";
        in
        {
          devShells = {
            default = mkShell {
              inputsFrom = [ self'.packages.default ];
            };
          };

          packages = {
            default = buildDunePackage {
              inherit version;
              pname = name;
              src = ./.;
            };

            docker = buildImage {
              inherit name;
              tag = version;
              config = {
                Cmd = "${self'.packages.default}/bin/${name}";
                Env = [
                  "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                ];
              };
            };
          };
        };
    };
}
