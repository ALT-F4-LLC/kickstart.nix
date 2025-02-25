{
  description = "Example kickstart Powershell application project.";

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
        inherit
          (pkgs)
          dockerTools
          mkShell
          powershell
          writeScriptBin
          ;
        inherit
          (dockerTools)
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
            copyToRoot = [
              usrBinEnv
              binSh
              caCertificates
            ];
            config = {
              Cmd = ["${self'.packages.default}/bin/${name}"];
            };
          };
        };
      };
    };
}
