# EDA Tools Nix Setup

A comprehensive Nix-based setup for Electronic Design Automation (EDA) tools, providing a reproducible development environment for digital circuit design, analog simulation, and VLSI layout.

## 🎯 Purpose

This project packages and provides easy access to essential EDA tools through the Nix package manager, ensuring:
- **Reproducible builds** across different systems
- **Isolated environments** without conflicts
- **Easy setup** for students, researchers, and engineers
- **Version consistency** across team members

## 🛠️ Included Tools

### Circuit Characterization & Analysis
- **[CACE](https://cace.readthedocs.io/)** - Circuit Automatic Characterization Engine for analog and mixed-signal circuits

### Digital Design & Synthesis
- **[Yosys](http://www.clifford.at/yosys/)** - RTL synthesis framework for Verilog HDL
- **[OpenROAD](https://openroad.readthedocs.io/)** - Complete RTL-to-GDSII platform *(commented out - WIP)*

### Analog Circuit Design & Simulation
- **[Xschem](http://repo.hu/projects/xschem/)** - Schematic capture and netlist generator
- **[Xcircuit](http://opencircuitdesign.com/xcircuit/)** - Circuit drawing and schematic capture
- **[NGSpice](http://ngspice.sourceforge.net/)** - Mixed-level/mixed-signal circuit simulator
- **[Xyce](https://xyce.sandia.gov/)** - High-performance analog circuit simulator

### Layout & Physical Verification
- **[Magic VLSI](http://opencircuitdesign.com/magic/)** - VLSI layout editor
- **[KLayout](https://www.klayout.de/)** - High-performance layout viewer and editor
- **[Netgen](http://opencircuitdesign.com/netgen/)** - LVS (Layout vs Schematic) tool
- **[IRSIM](http://opencircuitdesign.com/irsim/)** - Switch-level simulator

### Process Design Kits
- **[Open PDKs](https://github.com/RTimothyEdwards/open_pdks)** - Open-source PDK installer *(commented out - WIP)*

## 📁 Project Structure

```
CAD_nix_setup/
├── README.md           # This file
├── LICENSE             # GPL v2 license
├── flake.nix           # Nix flake configuration
├── flake.lock          # Flake lock file for reproducibility (generated)
├── pkgs/               # Individual package definitions
│   ├── cace/           # Circuit Automatic Characterization Engine
│   ├── irsim/
│   ├── klayout/
│   ├── magic-vlsi/
│   ├── netgen/
│   ├── ngspice/
│   ├── open_pdks/      # Work in progress
│   ├── openroad/       # Work in progress
│   ├── xcircuit/
│   ├── xschem/
│   ├── xyce/
│   └── yosys/
├── simulation/         # Directory for simulation projects
└── result/             # Nix build outputs (generated)
```

## 🚀 Quick Start

### Prerequisites
- **Nix package manager** with flakes support installed on your system
  ```bash
  # Install Nix (if not already installed)
  curl -L https://nixos.org/nix/install | sh
  # Enable flakes (add to ~/.config/nix/nix.conf or /etc/nix/nix.conf)
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  ```

### Option 1: Development Shell (Recommended)
Enter a shell with all EDA tools available:
```bash
# Enter development shell
nix develop

# Or use the legacy shell for compatibility
nix develop .#legacy
```

### Option 2: Build Individual Tools
```bash
# Build a specific tool
nix build .#yosys
nix build .#magic-vlsi
nix build .#ngspice
nix build .#cace

# Build all tools
nix build .#all
```

### Option 3: Run Tools Directly
```bash
# Run tools without entering a shell
nix run .#magic
nix run .#yosys
nix run .#xschem
nix run .#cace
```

### Option 4: Install Globally
```bash
# Install all tools to your user profile
nix profile install .#all
```

## 🚀 Flake-Based Architecture

This project uses **Nix flakes** for improved reproducibility and easier dependency management.

### Key Benefits of Flakes
- **Lock file** (`flake.lock`) ensures exact reproducibility
- **Better caching** and performance
- **Direct tool execution** without entering shells
- **Modern Nix CLI** commands
- **Easier CI/CD integration**

### Flake Commands Summary
```bash
# Development shells
nix develop              # Main development environment
nix develop .#legacy     # Minimal shell environment

# Building packages
nix build .#all          # Build all tools
nix build .#yosys       # Build specific tool

# Running tools directly
nix run .#magic         # Run Magic VLSI directly
nix run .#yosys         # Run Yosys directly
nix run .#cace          # Run CACE directly

# Show available outputs
nix flake show          # List all available packages and apps
```

## 💻 Usage Examples

### Circuit Characterization with CACE
```bash
# Enter the development environment
nix develop

# Or run CACE directly
nix run .#cace -- datasheet.yaml output/ --summary

# Run parametric analysis
nix run .#cace -- datasheet.yaml output/ --param corner=tt --temp 27
```

### Digital Design Flow
```bash
# Enter the development environment
nix develop

# Or run tools directly without shell
nix run .#yosys -- -p "read_verilog design.v; synth; write_json design.json"

# View results in KLayout
nix run .#klayout -- design.gds
```

### Analog Simulation Flow
```bash
# Enter the development environment
nix develop

# Or run tools directly
nix run .#xschem        # Create schematic with Xschem
nix run .#ngspice -- simulation.cir  # Simulate with NGSpice
nix run .#xyce -- netlist.cir        # High-performance simulation
```

### Layout and Verification
```bash
# Enter the development environment
nix develop

# Or run tools directly
nix run .#magic -- -T technology_file layout.mag
nix run .#klayout -- layout.gds

# Verify with Netgen (LVS) - in dev shell
netgen -batch lvs "layout.spice" "schematic.spice"
```

## 🔧 Development

### Adding New Tools
1. Create a new directory in `pkgs/toolname/`
2. Add a `default.nix` file with the package definition
3. Import it in the main `default.nix`
4. Add it to the build inputs in `shell.nix`

### Modifying Existing Packages
Each tool's package definition is in `pkgs/toolname/default.nix`. Modify these files to:
- Update versions
- Add build dependencies
- Fix build issues
- Add patches

### Building and Testing
```bash
# Test build of a single package
nix build .#toolname

# Test the development shell
nix develop --command which toolname

# Clean build outputs
rm -rf result/
```

## 🐛 Troubleshooting

### Common Issues

**Build failures**: Check the specific tool's build log:
```bash
nix build .#toolname 2>&1 | tee build.log
```

**Missing dependencies**: Ensure all required system packages are available. On NixOS, they're handled automatically. On other systems, you might need additional packages.

**Path issues**: Make sure you're in the development shell when trying to run tools:
```bash
nix develop
which magic  # Should show a /nix/store/... path
```

## 📄 License

This project is licensed under the GNU General Public License v2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## 📚 Resources

- [Nix Package Manager Documentation](https://nixos.org/manual/nix/stable/)
- [NixOS Packages Collection](https://github.com/NixOS/nixpkgs)
- [EDA Tools Documentation](https://opencircuitdesign.com/)

## 🏷️ Status

- ✅ **Stable**: irsim, klayout, magic-vlsi, netgen, ngspice, xcircuit, xschem, xyce, yosys
- 🚧 **Work in Progress**: openroad, open_pdks

---

*Happy designing! 🔬⚡*
