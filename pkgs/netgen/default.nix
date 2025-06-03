{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, tcl
, tk
, xorg
}:

stdenv.mkDerivation {
  pname = "netgen";
  version = "1.5.295";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "netgen";
    rev = "1.5.295";
    sha256 = "sha256-e/Vld5euQrm2oc9Ijs2CXWDmr3tfmnO3BTR8Co8la6E=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    tcl
    tk
    xorg.libX11
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
  ];

  meta = with lib; {
    description = "Circuit netlist comparison tool";
    homepage = "http://ngspice.sourceforge.net/netgen.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
} 