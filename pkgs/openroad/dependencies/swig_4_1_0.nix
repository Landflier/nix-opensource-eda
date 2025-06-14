{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, bison
, pcre2
}:

# SWIG 4.1.0 - matches swigVersion=4.1.0 from DependencyInstaller.sh
stdenv.mkDerivation rec {
  pname = "swig";
  version = "4.1.0";
  
  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "v${version}";
    sha256 = "sha256-h8WNXcYd4xEHg0ynopfSX1ERPSDP2M/RTOjgWfBMnB0="; 
  };

  nativeBuildInputs = [ 
    autoconf 
    automake 
    libtool 
    pkg-config 
    bison
  ];
  buildInputs = [ pcre2 ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ 
    "--with-pcre=${pcre2}"
  ];

  meta = with lib; {
    description = "SWIG - Simplified Wrapper and Interface Generator";
    homepage = "http://swig.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
} 