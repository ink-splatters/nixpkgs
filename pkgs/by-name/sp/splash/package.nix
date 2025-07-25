{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  giza,
  hdf5,
  cairo,
  freetype,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "splash";
  version = "3.11.4";

  src = fetchFromGitHub {
    owner = "danieljprice";
    repo = "splash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e777Te+gOsVDiu/y1VWBDYIW/C6Ojo3gY8qDfJuE5I4=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    giza
    cairo
    freetype
    hdf5
  ];
  makeFlags = [
    "SYSTEM=gfortran"
    "GIZA_DIR=${giza}"
    "PREFIX=${placeholder "out"}"
  ];
  # Upstream's simplistic makefile doesn't even `mkdir $(PREFIX)`, so we help
  # it:
  preInstall = ''
    mkdir -p $out/bin
  '';
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Interactive visualisation and plotting tool using kernel interpolation, mainly used for Smoothed Particle Hydrodynamics simulations";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
