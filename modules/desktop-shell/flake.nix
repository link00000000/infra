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
          gtkmm4
          wayland
          glib
          cmake
          pkg-config
          gtk4-layer-shell
          clang
        ];
      in {
        formatter = pkgs.nixpkgs-fmt;

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bash-language-server
            clang-tools
            gum
            inotify-tools
            coreutils
            argc
          ] ++ buildInputs;
        };

        packages = {
          default = self.packages.${system}.desktop-shell;
          desktop-shell = pkgs.stdenv.mkDerivation {
            pname = "desktop-shell";
            version = "0.1.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config ];
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
      }) // {
        homeModules = {
          default = self.homeModules.desktop-shell;
          desktop-shell = { config, pkgs, lib, ... }:
          let
            cfg = config.programs.desktop-shell;
            system = pkgs.stdenv.hostPlatform.system;
          in
          {
            options.programs.desktop-shell = {
              enable = lib.mkEnableOption "desktop-shell";

              package = lib.mkOption {
                type = lib.types.package;
                default = self.packages.${system}.desktop-shell;
                description = "The desktop-shell package to use.";
              };
            };

            config = lib.mkIf cfg.enable {
              systemd.user.services.desktop-shell = {
                Unit = {
                  Description = "A custom desktop shell for Wayland compositors";
                  PartOf = ["graphical-session.target"];
                  After = ["graphical-session-pre.target"];
                };

                Service = {
                  ExecStart = "${cfg.package}/bin/desktop-shell";
                  Restart = "on-failure";
                  KillMode = "mixed";
                };

                Install = {
                  WantedBy = ["graphical-session.target"];
                };
              };
            };
          };
        };
      };
}
