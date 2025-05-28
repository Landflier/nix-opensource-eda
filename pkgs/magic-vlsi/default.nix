{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "magic-vlsi";
  version = "8.3.525";

  src = pkgs.fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    rev = "8.3.525";
    sha256 = "sha256-yviA36C4KkGNM56rvZvPBi5huvKDO5Z4DG9gO5tKYCA=";
  };

  nativeBuildInputs = with pkgs; [
    autoconf
    automake
    libtool
    pkg-config
    git
  ];

  buildInputs = with pkgs; [
    tcl
    tk
    xorg.libX11
    cairo
    mesa
    mesa_glu
    python3
  ];

  configureFlags = [
    "--with-tcl=${pkgs.tcl}/lib"
    "--with-tk=${pkgs.tk}/lib"
    "--with-x"
    "--with-python=${pkgs.python3}/bin/python3"
  ];
  /*
  postUnpack = ''
    cd $sourceRoot
    git init
    git add .
    git commit -m "Initial commit"
  '';
  */

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
