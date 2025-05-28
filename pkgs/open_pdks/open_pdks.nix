{ lib
, stdenv
, fetchFromGitHub
, callPackage
, git
, wget
, curl
, gnused
, python3 
}:
 
stdenv.mkDerivation {
  name = "open_pdks";

  buildInputs = [
    git
    wget
    curl
    gnused
    python3
    ( callPackage ../magic/magic.nix {} )
  ];

  makeFlags = [];

  # TODO fix hardcoded paths  
  configureFlags = [
    "--enable-sky130-pdk"
    "--with-sky130-variant=A"
    "--disable-io-sky130"
    "--disable-sc-hs-sky130"
    "--disable-sc-ms-sky130"
    "--disable-sc-ls-sky130"
    "--disable-sc-lp-sky130"
    "--disable-sc-hd-sky130"
    "--disable-sc-hdll-sky130"
    "--disable-sc-hvl-sky130"
    "--disable-alpha-sky130"
    "--disable-xschem-sky130"
    "--disable-klayout-sky130"
  ];

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "open_pdks";
    rev = "1.0.455";
    sha256 = "1nwwp6rg8wvqh5ac4264kdv9lfh8zc84nfy2g8lsgpyl90y7nbmx";
  };
}
