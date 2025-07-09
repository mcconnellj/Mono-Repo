{
  description = "Python 3.11 environment with requirements.txt auto-installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;

        # Manually install evdev from nixpkgs to avoid pip build issues
        pythonPackages = pkgs.python311Packages;

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            pythonPackages.pip
            pythonPackages.evdev
          ];

          shellHook = ''
            echo "Python 3.11 dev environment ready."
            echo "Installing Python packages from requirements.txt"
            pip install --no-deps --disable-pip-version-check --requirement requirements.txt || true
          '';
        };
      }
    );
}