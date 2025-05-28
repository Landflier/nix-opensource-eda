{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) lib;

  # Import individual package derivations
  magic-vlsi = import ./pkgs/magic-vlsi { inherit pkgs; };
  netgen = import ./pkgs/netgen { inherit pkgs; };
  yosys = import ./pkgs/yosys { inherit pkgs; };
  openroad = import ./pkgs/openroad { inherit pkgs; };
  klayout = import ./pkgs/klayout { inherit pkgs; };
  open_pdks = import ./pkgs/open_pdks { inherit pkgs; };
  ngspice = import ./pkgs/ngspice { inherit pkgs; };

in {
  inherit magic-vlsi netgen yosys openroad klayout open_pdks ngspice;

  # Create a combined package with all tools
  all = pkgs.buildEnv {
    name = "eda-tools";
    paths = [
      magic-vlsi
      netgen
      yosys
      openroad
      klayout
      open_pdks
      ngspice
    ];
  };
}
