{
  description = "WhisperWriter environment: Whisper + GUI dictation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mach = mach-nix.lib.${system};
        whisperWriterReqs = builtins.readFile ./whisper-writer/requirements.txt;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python311

            # Python environment based ONLY on whisper-writer requirements.txt
            (mach.mkPythonShell {
              requirements = whisperWriterReqs;
            })
          ];

          shellHook = ''
            echo "WhisperWriter dev shell ready!"
            python whisper-writer/run.py
          '';
        };
      });
}