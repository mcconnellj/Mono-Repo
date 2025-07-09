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

        requirements = pkgs.runCommand "install-requirements" {
          buildInputs = [
            python
            pkgs.python311Packages.pip
            pkgs.gcc
            pkgs."pkg-config"
            pkgs.libffi
            pkgs.zlib
            pkgs.python311Full
          ];
          src = ./requirements.txt;
        } ''
          mkdir -p $out
          export HOME=$(mktemp -d)
          export CFLAGS="-I${pkgs.libffi.dev}/include -I${pkgs.zlib.dev}/include"
          export LDFLAGS="-L${pkgs.libffi.out}/lib -L${pkgs.zlib.out}/lib"
          pip install --prefix=$out --no-warn-script-location -r $src
        '';

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ python ];

          PYTHONPATH = "${requirements}/${python.sitePackages}";

          shellHook = ''
            echo "Python 3.11 dev environment ready."
            echo "Packages installed from requirements.txt"
          '';
        };
      }
    );
}
