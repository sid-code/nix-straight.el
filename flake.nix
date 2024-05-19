{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    straight = {
      url = "github:radian-software/straight.el";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    straight,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux"];
    forEachSystem = f: (nixpkgs.lib.genAttrs supportedSystems (system:
      f {
        inherit system;
        pkgs = import nixpkgs {inherit system;};
      }));
  in {
    emacsEnv = forEachSystem (
      {pkgs, ...}: pkgs.callPackage ./.
    );

    packages = forEachSystem (
      {pkgs, ...}: {
        straight = pkgs.emacsPackages.callPackage ./straight {
          straightSource = straight;
        };
      }
    );
  };
}
