{
  description = "Flake for Python 3.11 environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: 
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python311
          pkgs.python311Packages.pip
          pkgs.python311Packages.virtualenv
        ];
      };
    };
}