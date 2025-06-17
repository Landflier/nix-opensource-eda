{
  description = "EDA Tools Nix Flake - A comprehensive setup for Electronic Design Automation tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib callPackage runCommand symlinkJoin;

        # Import individual package derivations
        edaPackages = {
          irsim = callPackage ./pkgs/irsim {};
          klayout = callPackage ./pkgs/klayout {};
          magic-vlsi = callPackage ./pkgs/magic-vlsi {};
          netgen = callPackage ./pkgs/netgen {};
          ngspice = callPackage ./pkgs/ngspice {};
          # open_pdks = callPackage ./pkgs/open_pdks {};
          yosys = callPackage ./pkgs/yosys {};
          xcircuit = callPackage ./pkgs/xcircuit {};
          xschem = callPackage ./pkgs/xschem {};
          xyce = callPackage ./pkgs/xyce {};
        };

        openroad = callPackage ./pkgs/openroad { yosys = edaPackages.yosys; };

        allEdaPackages = edaPackages // { inherit openroad; };

        # Create a combined package with all tools
        edaToolsAll = pkgs.buildEnv {
          name = "eda-tools";
          paths = with allEdaPackages; [
            irsim
            klayout
            magic-vlsi
            netgen
            ngspice
            openroad
            # open_pdks
            xcircuit
            xschem
            xyce
            yosys
          ];
        };

        # Development environment with build dependencies
        edaToolsWithDeps = pkgs.buildEnv {
          name = "eda-tools-with-deps";
          paths = with allEdaPackages; [
            irsim
            klayout
            magic-vlsi
            netgen
            ngspice
            openroad
            xcircuit
            xschem
            xyce
            yosys
            
            # Common build dependencies
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
        };

        # Create structured output with each package in its own directory
        edaToolsResult = runCommand "eda-tools-result" {} ''
          mkdir -p $out
          
          # Create symlinks for each package in its own subdirectory
          ln -s ${allEdaPackages.irsim} $out/irsim
          ln -s ${allEdaPackages.klayout} $out/klayout
          ln -s ${allEdaPackages.magic-vlsi} $out/magic-vlsi
          ln -s ${allEdaPackages.netgen} $out/netgen
          ln -s ${allEdaPackages.ngspice} $out/ngspice
          ln -s ${openroad} $out/openroad
          ln -s ${allEdaPackages.xcircuit} $out/xcircuit
          ln -s ${allEdaPackages.xschem} $out/xschem
          ln -s ${allEdaPackages.xyce} $out/xyce
          ln -s ${allEdaPackages.yosys} $out/yosys
        '';

        # Python environment with common packages
        pythonEnv = pkgs.python3.withPackages(ps: with ps; [
          pip
          setuptools
          wheel
        ]);

      in
      {
        # Export individual packages
        packages = allEdaPackages // {
          default = edaToolsAll;
          all = edaToolsAll;
          allWithDeps = edaToolsWithDeps;
          result = edaToolsResult;
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = [
            edaToolsAll
            
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
            echo "EDA Tools Development Environment (Flake)"
            
            # Add all EDA tool binaries to PATH
            export PATH="${edaToolsResult}/irsim/bin:$PATH"
            export PATH="${edaToolsResult}/magic-vlsi/bin:$PATH"
            export PATH="${edaToolsResult}/netgen/bin:$PATH"
            export PATH="${edaToolsResult}/ngspice/bin:$PATH"
            export PATH="${edaToolsResult}/xcircuit/bin:$PATH"
            export PATH="${edaToolsResult}/xschem/bin:$PATH"
            export PATH="${edaToolsResult}/xyce/bin:$PATH"
            export PATH="${edaToolsResult}/yosys/bin:$PATH"
            
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
        };

        # Legacy shell for compatibility
        devShells.legacy = pkgs.mkShell {
          buildInputs = with allEdaPackages; [
            irsim
            klayout
            magic-vlsi
            netgen
            ngspice
            openroad
            xcircuit
            xschem
            xyce
            yosys
          ];
        };

        # Apps for running tools directly
        apps = {
          magic = flake-utils.lib.mkApp {
            drv = allEdaPackages.magic-vlsi;
            name = "magic";
          };
          yosys = flake-utils.lib.mkApp {
            drv = allEdaPackages.yosys;
            name = "yosys";
          };
          ngspice = flake-utils.lib.mkApp {
            drv = allEdaPackages.ngspice;
            name = "ngspice";
          };
          xschem = flake-utils.lib.mkApp {
            drv = allEdaPackages.xschem;
            name = "xschem";
          };
          klayout = flake-utils.lib.mkApp {
            drv = allEdaPackages.klayout;
            name = "klayout";
          };
        };
      }
    );
} 