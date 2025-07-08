{
  description = "WhisperWriter environment: Whisper + GUI dictation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mach = mach-nix.lib.${system};
        whisperWriterReqs = builtins.readFile ./whisper-writer/requirements.txt;
      in {
        # Expose a python package output with Python 3.11 environment
        packages = {
          python = mach.mkPythonShell {
            python = pkgs.python311;
            requirements = whisperWriterReqs;
          };
        };

        # Optional devShell that uses the python package
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              packages.python
            ];

            shellHook = ''
              echo "WhisperWriter dev shell ready!"
              python whisper-writer/run.py
            '';
          };
        };
      });
}