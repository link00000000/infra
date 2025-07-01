{
  description = "NixOS system configurations";

  nixConfig = {
    # Enable build caches
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    stylix.url = "github:danth/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    nixy-wallpapers.url = "github:anotherhadi/nixy-wallpapers";
    nixy-wallpapers.flake = false;

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # TODO: Setup impemanence
    # TODO: Setup Mic92/nix-fast-build
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations = {
      yoga =
        let
          system = "x86_64-linux";
          pkgs-unstable = inputs.nixpkgs-unstable.outputs.legacyPackages.${system};
        in
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit inputs;
              inherit pkgs-unstable;
            };

            modules = [
              ./hosts/yoga/configuration.nix 
              inputs.stylix.nixosModules.stylix
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit pkgs-unstable;
                };
              }
            ];
          };

      wsl =
        let
          system = "x86_64-linux";
          pkgs-unstable = inputs.nixpkgs-unstable.outputs.legacyPackages.${system};
        in 
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit inputs;
              inherit pkgs-unstable;
            };

            modules = [
              ./hosts/wsl/configuration.nix
              inputs.stylix.nixosModules.stylix
              inputs.nixos-wsl.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit pkgs-unstable;
                };
              }
            ];
          };
    };
  };
}
