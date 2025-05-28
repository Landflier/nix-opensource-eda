{
  pkgs ? import <nixpkgs> { }
}:
{
  magic = pkgs.callPackage ./magic.nix {   };
}
