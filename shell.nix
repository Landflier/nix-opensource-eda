{ pkgs ? import <nixpkgs> {} }:

let
  eda-tools = import ./default.nix { inherit pkgs; };
in
  pkgs.mkShell {
    buildInputs = [
      eda-tools.all
    ];

    shellHook = ''
      echo "EDA Tools Development Environment"
      echo "Available tools:"
      echo "  - Magic VLSI"
      echo "  - Netgen"
      echo "  - Yosys"
      echo "  - OpenROAD"
      echo "  - KLayout"
      echo "  - Open PDKs"
      echo "  - NGspice"
    '';
  }
