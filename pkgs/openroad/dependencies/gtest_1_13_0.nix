{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

# Google Test 1.13.0 - matches gtestVersion=1.13.0 from DependencyInstaller.sh
stdenv.mkDerivation rec {
  pname = "gtest";
  version = "1.13.0";
  
  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${version}";
    sha256 = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ="; 
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "Google Test - C++ testing framework";
    homepage = "https://github.com/google/googletest";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
} 