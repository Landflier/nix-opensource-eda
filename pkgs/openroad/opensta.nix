{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cmake
, tcl
, bison
, flex
, eigen
, cudd
, tclreadline
, zlib
, pcre2
, automake
, autoconf
, libtool
, openssl
, curl
, m4
}:

let
  cmake-3_24_2 = stdenv.mkDerivation rec {
    pname = "cmake";
    version = "3.24.2";

    src = fetchurl {
      url = "https://cmake.org/files/v3.24/cmake-${version}.tar.gz";
      sha256 = "1ny8y2dzc6fww9gzb1ml0vjpx4kclphjihkxagxigprxdzq2140d";
    };

    nativeBuildInputs = [ ];
    buildInputs = [ openssl curl ];

    configureFlags = [
      "--system-curl"
      "--system-openssl"
    ];

    meta = with lib; {
      description = "CMake 3.24.2 for OpenSTA";
      homepage = "https://cmake.org/";
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  };

  swig-4_1_0 = stdenv.mkDerivation rec {
    pname = "swig";
    version = "4.1.0";

    src = fetchurl {
      url = "https://downloads.sourceforge.net/swig/swig-${version}.tar.gz";
      sha256 = "0gdvymnn8b1cc9l2dllfcg48iqqz3qkwqwqaz2vczxvq9q4siafn";
    };

    nativeBuildInputs = [ automake autoconf libtool m4 ];
    buildInputs = [ pcre2 ];

    configureFlags = [ "--without-pcre" "--with-pcre2" ];

    meta = with lib; {
      description = "SWIG 4.1.0 for OpenSTA";
      homepage = "http://swig.org/";
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
  };

  bison-3_8_2 = stdenv.mkDerivation rec {
    pname = "bison";
    version = "3.8.2";

    src = fetchurl {
      url = "mirror://gnu/bison/bison-${version}.tar.xz";
      sha256 = "1wjvbbzrr16k1jlby3l436an3kvv492h08arbnf0gwgprha05flv";
    };

    nativeBuildInputs = [ m4 ];
    buildInputs = [ ];

    meta = with lib; {
      description = "Bison 3.8.2 for OpenSTA";
      homepage = "https://www.gnu.org/software/bison/";
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
    };
  };

  flex-2_6_4 = stdenv.mkDerivation rec {
    pname = "flex";
    version = "2.6.4";

    src = fetchurl {
      url = "https://github.com/westes/flex/releases/download/v${version}/flex-${version}.tar.gz";
      sha256 = "15g9bv236nzi665p9ggqjlfn4dwck5835vf0bbw2cz7h5c1swyp8";
    };

    nativeBuildInputs = [ m4 ];
    buildInputs = [ ];

    meta = with lib; {
      description = "Flex 2.6.4 for OpenSTA";
      homepage = "https://github.com/westes/flex";
      license = licenses.bsd2;
      platforms = platforms.unix;
    };
  };
in

stdenv.mkDerivation rec {
  pname = "opensta";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenSTA";
    rev = "v${version}";
    sha256 = "sha256-qKcTEtFdZM/VKFbo6ldoXfJgHsS2JMf+9IfrPja5GLw=";
  };

  nativeBuildInputs = [ 
    cmake-3_24_2
    swig-4_1_0
    bison-3_8_2
    flex-2_6_4
  ];
  
  buildInputs = [ 
    tcl 
    eigen
    cudd
    tclreadline
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSWIG_EXECUTABLE=${swig-4_1_0}/bin/swig"
    "-DSWIG_DIR=${swig-4_1_0}/share/swig"
    "-DSWIG_VERSION=4.1.0"
  ];

  meta = with lib; {
    description = "OpenSTA - Static Timing Analysis tool";
    homepage = "https://github.com/The-OpenROAD-Project/OpenSTA";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
} 