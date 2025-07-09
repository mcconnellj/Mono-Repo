{
  description = "Python 3.11 environment with drequirements.txt auto-installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = pkgs.python311;

        drequirements = pkgs.runCommand "install-drequirements"
          {
            buildInputs = [ python pkgs.python311Packages.pip ];
            # Copy drequirements.txt into the build context
            src = ./drequirements.txt;
          } ''
            mkdir -p $out
            export HOME=$(mktemp -d)  # Required for pip cache to work properly
            pip install --prefix=$out --no-warn-script-location -r $src
          '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ python ];

          # Makes installed packages available in the devShell
          PYTHONPATH = "${drequirements}/${python.sitePackages}";

          shellHook = ''
            echo "Python 3.11 dev environment ready."
            echo "Installing packages from drequirements.txt..."
          '';
        };
      }
    );
}