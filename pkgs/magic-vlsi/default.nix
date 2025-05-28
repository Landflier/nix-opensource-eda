{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "magic-vlsi";
  version = "8.3.525";

  src = pkgs.fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    rev = "8.3.525";
    sha256 = "sha256-yviA36C4KkGNM56rvZvPBi5huvKDO5Z4DG9gO5tKYCA=";
    leaveDotGit = true;
  };

  nativeBuildInputs = with pkgs; [
    autoconf
    automake
    libtool
    pkg-config
    git
    m4
  ];

  buildInputs = with pkgs; [
    glibc
    tcl
    tk
    xorg.libX11
    cairo
    mesa
    mesa_glu
    python3
    tcsh
    ncurses
    freeglut
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${pkgs.tcl}/lib"
    "--with-tk=${pkgs.tk}/lib"
  ];

  preBuild = ''
    chmod +x scripts/makedbh
  '';

  meta = with pkgs.lib; {
    description = "VLSI layout tool";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
