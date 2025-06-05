# EDA Tools Nix Setup

A comprehensive Nix-based setup for Electronic Design Automation (EDA) tools, providing a reproducible development environment for digital circuit design, analog simulation, and VLSI layout.

## 🎯 Purpose

This project packages and provides easy access to essential EDA tools through the Nix package manager, ensuring:
- **Reproducible builds** across different systems
- **Isolated environments** without conflicts
- **Easy setup** for students, researchers, and engineers
- **Version consistency** across team members

## 🛠️ Included Tools

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
├── default.nix         # Main Nix expression defining all packages
├── shell.nix           # Development shell configuration
├── pkgs/               # Individual package definitions
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
- **Nix package manager** installed on your system
  ```bash
  # Install Nix (if not already installed)
  curl -L https://nixos.org/nix/install | sh
  ```

### Option 1: Development Shell (Recommended)
Enter a shell with all EDA tools available:
```bash
nix-shell
```

This will:
- Build all EDA tools
- Add them to your PATH
- Provide a ready-to-use environment

### Option 2: Build Individual Tools
```bash
# Build a specific tool
nix-build -A yosys
nix-build -A magic-vlsi
nix-build -A ngspice

# Build all tools
nix-build -A all
```

### Option 3: Install Globally
```bash
# Install all tools to your user profile
nix-env -f . -iA all
```

## 💻 Usage Examples

### Digital Design Flow
```bash
# Enter the development environment
nix-shell

# Synthesize Verilog with Yosys
yosys -p "read_verilog design.v; synth; write_json design.json"

# View results in KLayout
klayout design.gds
```

### Analog Simulation Flow
```bash
# Enter the development environment
nix-shell

# Create schematic with Xschem
xschem

# Simulate with NGSpice
ngspice simulation.cir

# For high-performance simulation
xyce netlist.cir
```

### Layout and Verification
```bash
# Enter the development environment
nix-shell

# Create/edit layout with Magic
magic -T technology_file layout.mag

# Verify with Netgen (LVS)
netgen -batch lvs "layout.spice" "schematic.spice"

# View layout in KLayout
klayout layout.gds
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
nix-build -A toolname

# Test the development shell
nix-shell --run "which toolname"

# Clean build outputs
rm -rf result/
```

## 🐛 Troubleshooting

### Common Issues

**Build failures**: Check the specific tool's build log:
```bash
nix-build -A toolname 2>&1 | tee build.log
```

**Missing dependencies**: Ensure all required system packages are available. On NixOS, they're handled automatically. On other systems, you might need additional packages.

**Path issues**: Make sure you're in the nix-shell when trying to run tools:
```bash
nix-shell
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
