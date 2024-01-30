{
  description = "Example kickstart Zig application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) dockerTools stdenv zig_0_11;
          inherit (dockerTools) buildImage;
          name = "example";
          version = "0.1.0";
        in
        {
          packages = {
            default = stdenv.mkDerivation {
              inherit name;
              inherit version;
              src = ./.;
              nativeBuildInputs = [
                zig_0_11.hook
              ];
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
