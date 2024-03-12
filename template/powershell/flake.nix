{
  description = "Example kickstart Powershell application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
        inherit
          (pkgs)
          curlMinimal
          just
          mkShell
          powershell
          writeScriptBin
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
        name = "example";
        version = "0.1.0";
      in {
        devShells = {
          default = mkShell {
            inputsFrom = [self'.packages.default];
            buildInputs = [just];
          };
        };

        packages = {
          default =
            writeScriptBin "${name}"
            ''
              #!${powershell}/bin/pwsh
              function Log-Message
              {
                  [CmdletBinding()]
                  Param
                  (
                      [Parameter(Mandatory=$true, Position=0)]
                      [string]$LogMessage
                  )
                  Write-Output ("{0} - {1}" -f (Get-Date -format "dd-MMM-yyyy HH:mm:ss"), $LogMessage)
              }

              Log-Message "HI"
              Log-Message "CHAT!"
              exit 0
            '';

          docker = buildImage {
            inherit name;
            tag = version;
            # https://ryantm.github.io/nixpkgs/builders/images/dockertools/#ssec-pkgs-dockerTools-helpers
            copyToRoot = [
              binSh
              caCertificates
              curlMinimal
              usrBinEnv
            ];
            config = {
              Cmd = ["${self'.packages.default}/bin/${name}"];
            };
          };
        };
      };
    };
}
