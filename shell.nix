{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc884" }:
let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages (ps: with ps; [
          cabal-install 
          brittany
          ghcid
        ]);
in
pkgs.stdenv.mkDerivation {
  name = "my-haskell-env-0";
  buildInputs = [
    ghc
    pkgs.nodejs
    pkgs.zlib
  ];
  shellHook = ''
    export NIX_GHC="${ghc}/bin/ghc"
    export NIX_GHCPKG="${ghc}/bin/ghc-pkg"
    export NIX_GHC_DOCDIR="${ghc}/share/doc/ghc/html"
    export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
  '';
  LD_LIBRARY_PATH="${pkgs.zlib}/lib";
}
