{ pkgs ? import <nixpkgs> {} }:

with pkgs;
(

  let
    # pydstool = callPackage ./default.nix {
    #   buildPythonPackage = python310Packages.buildPythonPackage;
    # };
  in
mkShell {
  buildInputs = [
    swig
    gfortran
    clang
    (python39.withPackages (ps: with ps; [
      # pydstool
      (ps.callPackage ./default.nix {})

      pytest
    ]))
  ];
}
)
