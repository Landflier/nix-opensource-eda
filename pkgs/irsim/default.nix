{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "irsim";
  version = "9.7.119";

  src = pkgs.fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "irsim";
    rev = "9.7.119";
    sha256 = "sha256-SSTcAwwg6gTj/56sSGobnIR2P/qQjveb+n8tajmqais=";
    leaveDotGit = true;
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
  ];

  configureFlags = [
    "--with-tcl=${pkgs.tcl}/lib"
    "--with-tk=${pkgs.tk}/lib"
    "--with-x"
  ];
/*
  postInstall = ''
    mkdir -p $out/bin
    cp irsim $out/bin/
    chmod +x $out/bin/irsim
  '';
*/
  postInstall = ''
    mkdir -p $NIX_BUILD_TOP/results/irsim
    cp -r $out/* $NIX_BUILD_TOP/results/irsim/
  '';

  meta = with pkgs.lib; {
    description = "IRSIM - Switch-level Digital Circuit Simulator";
    homepage = "http://opencircuitdesign.com/irsim/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
} 