{
  description = "WhisperWriter environment: Whisper + GUI dictation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        requirementsFile = ./requirements.txt;
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.python311 pkgs.python311Packages.pip ];

          shellHook = ''
            echo "Installing pip packages from requirements.txt..."
            pip install --upgrade pip
            pip install -r ${toString requirementsFile}
          '';
        };
      });
}