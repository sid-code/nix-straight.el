{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    straight = {
      url = "github:radian-software/straight.el";
      flake = false;
    };
  };

  outputs = {
    self,
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
    lib = forEachSystem (
      {
        pkgs,
        system,
      }: args: pkgs.callPackage ./. (args // {straight = self.packages.${system}.straight;})
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
