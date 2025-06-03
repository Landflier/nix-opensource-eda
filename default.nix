{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) lib callPackage runCommand symlinkJoin;

  # Import individual package derivations
  magic-vlsi = callPackage ./pkgs/magic-vlsi {};
  irsim = callPackage ./pkgs/irsim {};
  netgen = callPackage ./pkgs/netgen {};
  yosys = callPackage ./pkgs/yosys {};
  openroad = callPackage ./pkgs/openroad {};
  klayout = callPackage ./pkgs/klayout {};
  open_pdks = callPackage ./pkgs/open_pdks {};
  ngspice = callPackage ./pkgs/ngspice {};

  # Function to create a package result directory
  mkPkgResult = name: pkg: runCommand "${name}-result" {} ''
    mkdir -p $out/${name}
    cp -r ${pkg}/* $out/${name}/
  '';

in {
  inherit magic-vlsi irsim netgen yosys openroad klayout open_pdks ngspice;

  # Create a combined package with all tools
  all = pkgs.buildEnv {
    name = "eda-tools";
    paths = [
      magic-vlsi
      irsim
      netgen
      yosys
      openroad
      klayout
      open_pdks
      ngspice
    ];
  };

  # Create structured output with each package in its own directory
  result = symlinkJoin {
    name = "eda-tools-result";
    paths = [
      (mkPkgResult "magic-vlsi" magic-vlsi)
      (mkPkgResult "irsim" irsim)
      (mkPkgResult "netgen" netgen)
      (mkPkgResult "yosys" yosys)
      (mkPkgResult "openroad" openroad)
      (mkPkgResult "klayout" klayout)
      (mkPkgResult "open_pdks" open_pdks)
      (mkPkgResult "ngspice" ngspice)
    ];
  };

  # Shell environment
  shell = pkgs.mkShell {
    buildInputs = [
      magic-vlsi
      irsim
      netgen
      yosys
      openroad
      klayout
      open_pdks
      ngspice
    ];
  };
}
