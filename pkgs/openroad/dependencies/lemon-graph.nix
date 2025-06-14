{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "lemon-graph";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "lemon-graph";
    rev = version;
    sha256 = "sha256-snqjc82vtgKC5uGu7V6Hhcf7YzRk0xHJDEOCN91iywI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    description = "LEMON - Library for Efficient Modeling and Optimization in Networks";
    homepage = "https://github.com/The-OpenROAD-Project/lemon-graph";
    license = licenses.boost;
    platforms = platforms.linux;
  };
} 