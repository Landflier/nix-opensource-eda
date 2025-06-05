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
      echo "You can now run these tools directly by name!"
    '';
  }
