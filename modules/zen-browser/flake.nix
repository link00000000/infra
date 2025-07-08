{
  description = "Zen Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      zen-browser,
      ...
    }:
    let
      formatterOutputs = flake-utils.lib.eachDefaultSystem (system: {
        formatter = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      });
    in
    zen-browser
    // formatterOutputs
    // {
      overlays = {
        default =
          { system }: final: prev:
          let
            packages = zen-browser.packages.${system};
            overlayPkgs = builtins.map (name: {
              name = if name == "default" then "zen" else "zen-${name}";
              value = packages.${name};
            }) (builtins.attrNames packages);
          in
          builtins.listToAttrs overlayPkgs;
      };

      nixosModules = {
        default = self.nixosModules.zen-browser-overlay;
        zen-browser-overlay = { system }: { ... }: {
          nixpkgs.overlays = [ (self.overlays.default { inherit system; }) ];
        };
      };
    };
}
