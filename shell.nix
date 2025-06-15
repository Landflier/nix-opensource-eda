{ pkgs ? import <nixpkgs> {} }:

let
  eda-tools = import ./default.nix { inherit pkgs; };
  pythonEnv = pkgs.python3.withPackages(ps: with ps; [
    pip
    setuptools
    wheel
    cairocffi 
  ]);
in
  pkgs.mkShell {
    buildInputs = [
      eda-tools.allWithDeps

      # Build dependencies that should be available in PATH
      pkgs.cairo
      pkgs.pkg-config
      pkgs.autoconf
      pkgs.automake
      pkgs.libtool
      pkgs.git
      pkgs.m4
      pkgs.tcl
      pkgs.tk
      pkgs.mesa
      pkgs.mesa_glu
      pkgs.python3
      pkgs.ncurses
      pkgs.freeglut
    ];

    packages = [
      pythonEnv
    ];

    shellHook = ''
      echo "EDA Tools Development Environment"
      
      # Add all EDA tool binaries to PATH
      export PATH="${eda-tools.result}/irsim/bin:$PATH"
      export PATH="${eda-tools.result}/magic-vlsi/bin:$PATH"
      export PATH="${eda-tools.result}/netgen/bin:$PATH"
      export PATH="${eda-tools.result}/ngspice/bin:$PATH"
      export PATH="${eda-tools.result}/xcircuit/bin:$PATH"
      export PATH="${eda-tools.result}/xschem/bin:$PATH"
      export PATH="${eda-tools.result}/xyce/bin:$PATH"
      export PATH="${eda-tools.result}/yosys/bin:$PATH"
      
      echo "Available tools (now in PATH):"
      echo "  - irsim"
      echo "  - magic"
      echo "  - netgen"
      echo "  - ngspice"
      echo "  - xcircuit"
      echo "  - xschem"
      echo "  - xyce"
      echo "  - yosys"
      echo ""
      echo "Build dependencies also available:"
      echo "  - cairo (pkg-config: cairo)"
      echo "  - autotools (autoconf, automake, libtool)"
      echo "  - pkg-config"
      echo "  - tcl/tk"
      echo ""
      echo "You can now run these tools directly by name!"

      export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}"
      export PATH="${pythonEnv}/bin:$PATH"
    '';
  }
