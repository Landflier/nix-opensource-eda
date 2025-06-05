{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) lib callPackage runCommand symlinkJoin;

  # Import individual package derivations
  irsim = callPackage ./pkgs/irsim {};
  klayout = callPackage ./pkgs/klayout {};
  magic-vlsi = callPackage ./pkgs/magic-vlsi {};
  netgen = callPackage ./pkgs/netgen {};
  ngspice = callPackage ./pkgs/ngspice {};
  # open_pdks = callPackage ./pkgs/open_pdks {};
  # openroad = callPackage ./pkgs/openroad {};
  xcircuit = callPackage ./pkgs/xcircuit {};
  xschem = callPackage ./pkgs/xschem {};
  xyce = callPackage ./pkgs/xyce {};
  yosys = callPackage ./pkgs/yosys {};

in {
  # inherit magic-vlsi irsim netgen yosys openroad klayout open_pdks ngspice xschem xcircuit;
  inherit irsim klayout magic-vlsi netgen ngspice xcircuit xschem xyce yosys;

  # Create a combined package with all tools
  all = pkgs.buildEnv {
    name = "eda-tools";
    paths = [
      irsim
      klayout
      magic-vlsi
      netgen
      ngspice
      # openroad
      # open_pdks
      xcircuit
      xschem
      xyce
      yosys
    ];
  };

  # Create structured output with each package in its own directory
  result = runCommand "eda-tools-result" {} ''
    mkdir -p $out
    
    # Create symlinks for each package in its own subdirectory
    ln -s ${irsim} $out/irsim
    ln -s ${klayout} $out/klayout
    ln -s ${magic-vlsi} $out/magic-vlsi
    ln -s ${netgen} $out/netgen
    ln -s ${ngspice} $out/ngspice
    ln -s ${xcircuit} $out/xcircuit
    ln -s ${xschem} $out/xschem
    ln -s ${xyce} $out/xyce
    ln -s ${yosys} $out/yosys
  '';

  # Shell environment
  shell = pkgs.mkShell {
    buildInputs = [
      irsim
      klayout
      magic-vlsi
      netgen
      ngspice
      # openroad
      # open_pdks
      xcircuit
      xschem
      xyce
      yosys
    ];
  };
}
