let
  fetchNixpkgs = import ./nix/fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
    rev = "804060ff9a79ceb0925fe9ef79ddbf564a225d47";

    sha256 = "01pb6p07xawi60kshsxxq1bzn8a0y4s5jjqvhkwps4f5xjmmwav3";

    outputSha256 = "0ga345hgw6v2kzyhvf5kw96hf60mx5pbd9c4qj5q4nan4lr7nkxn";
  };

  config = {
    packageOverrides = pkgs: {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: {
          dhall = haskellPackagesNew.callPackage ./nix/dhall.nix { };

          dhall-text =
            pkgs.haskell.lib.failOnAllWarnings
              (pkgs.haskell.lib.justStaticExecutables
                (haskellPackagesNew.callPackage ./nix/dhall-text.nix { })
              );

          formatting = haskellPackagesOld.formatting_6_3_0;

          prettyprinter = haskellPackagesOld.prettyprinter_1_2_0_1;
        };
      };
    };
  };

  pkgs =
    import nixpkgs { inherit config; };

in
  { inherit (pkgs.haskellPackages) dhall-text; }
