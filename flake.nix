{
  description = "NixOS system configurations";

  nixConfig = {
    # Enable build caches
    extra-substituters = [
      "https://wezterm.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";

    # TODO: Setup impemanence
    # TODO: Setup Mic92/nix-fast-build
  };

  outputs = { self, home-manager, ... }@inputs: {
    nixosConfigurations = {
      yoga = let system = "x86_64-linux"; in inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs.inputs = inputs;
        specialArgs.pkgs-unstable = inputs.nixpkgs-unstable.outputs.legacyPackages.${system};
        modules = [
          ./hosts/yoga/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
