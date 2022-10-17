#
# This is a derivation
# nix shell nixpkgs#nix-template
# nix-template python -f pypi -u https://pypi.org/project/pydstool/ --stdout > shell.nix

{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, cython
, python
, numpy
, scipy
, matplotlib  # optional, needed for plotting functionality and running many of the examples.
# Dopri/Radau and AUTO interface requirements
, swig
, clang
, gfortran  # radau only
# test inpts
, pytest
, pytest-mock
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "pydstool";
  version = "0.91.0";


  # src from PyPI might have test stripped, ie. `doCheck = false;` is needed
  # keeps looking for  https://files.pythonhosted.org/packages/source/p/pydstool/pydstool-0.91.0.tar.gz
  # src = fetchPypi {
  #   inherit pname version;
  #   format = "setuptools";
  #   sha256 = "sha256-8hBE1yFGExDwYFt6g/umy6eNFwNFYEKAm96ddyybXJU=";
  # };

  src = fetchFromGitHub {
    owner = "robclewley";
    repo = "pydstool";
    # rev is the commit- or tag id. See either
    # https://github.com/robclewley/pydstool/tags
    # https://github.com/robclewley/pydstool/commits/master
    rev = version;
    # rev = "939e3abc9dd1f180d35152bacbde57e24c85ff26";
    sha256 = "sha256-ENNT0bthF5ELyC1K7CTNRsjwXRI9APs6MNZ2yr0oAw0=";
  };

  #only needed at build time
  BuildInputs = [ swig ];  # cython
  # runtime dependencies
  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    clang
    gfortran
    cython
  ];

  # swig needs to be available at runtime
  wrapperPath = with lib; makeBinPath ([
    swig
  ]);

  postFixup = ''
    export PATH=${lib.makeBinPath [ swig ]}:$PATH
  '';

  checkInputs = [
    pytest
    pytest-mock
    pytest-xdist
    # maybe
    # six
  ];

  doCheck = false;
  disabledTests = [ ];
  # test if pydstool can be imported
  pythonImportsCheck = [ "PyDSTool" ];


  meta = with lib; {
    description = "Python dynamical systems simulation and modeling";
    homepage = "https://pydstool.github.io/PyDSTool/FrontPage.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ p ];
  };
}

