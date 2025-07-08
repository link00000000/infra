{
  description = "A custom desktop shell for Wayland compositors";

inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        buildInputs = with pkgs; [
          gtk4
          wayland
          glib
          cmake
          pkg-config
          gtk4-layer-shell
          gcc
        ];
      in {
        formatter = pkgs.nixpkgs-fmt;

        devShell = pkgs.mkShell {
          packages = buildInputs;
        };

        packages = {
          default = self.packages.${system}.desktop-shell;
          desktop-shell = pkgs.stdenv.mkDerivation {
            pname = "desktop-shell";
            version = "0.1.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config pkgs.breakpointHook ];
            buildInputs = buildInputs;

            cmakeFlags = [
              "-DCMAKE_BUILD_TYPE=Release"
            ];

            buildPhase = ''
              cmake --build . --parallel $NIX_BUILD_CORES --config Release
            '';

            installPhase = ''
              mkdir -p $out/
              cmake --install . --prefix $out
            '';
          };
        };
      });
}
