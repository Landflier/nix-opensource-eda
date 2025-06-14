{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

# spdlog 1.15.0 - matches spdlogVersion=1.15.0 from DependencyInstaller.sh
stdenv.mkDerivation rec {
  pname = "spdlog";
  version = "1.15.0";
  
  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v${version}";
    sha256 = "sha256-HCpnN28qWreg0NvL6Q9pfSSxOTHgV6glHt6P0FbH/Cw="; 
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DSPDLOG_BUILD_EXAMPLE=OFF"
  ];

  meta = with lib; {
    description = "Fast C++ logging library";
    homepage = "https://github.com/gabime/spdlog";
    license = licenses.mit;
    platforms = platforms.unix;
  };
} 