{
  description = "My Awesome Desktop Shell";

  nixConfig = {
    # Enable build caches
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ags,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pname = "my-shell";
    entry = "app.ts";

    astalPackages = with ags.packages.${system}; [
      io
      astal4 # or astal3 for gtk3
      # notifd tray wireplumber
    ];

    extraPackages =
      astalPackages
      ++ [
        pkgs.libadwaita
        pkgs.libsoup_3
      ];
  in {
    packages.${system} = {
      default = pkgs.stdenv.mkDerivation {
        name = pname;
        src = ./.;

        nativeBuildInputs = with pkgs; [
          wrapGAppsHook
          gobject-introspection
          ags.packages.${system}.default
        ];

        buildInputs = extraPackages ++ [pkgs.gjs];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          mkdir -p $out/share
          cp -r * $out/share
          ags bundle ${entry} $out/bin/${pname} -d "SRC='$out/share'"

          runHook postInstall
        '';
      };
    };

    devShells.${system} = {
      default =
      let 
        devScript = pkgs.writeScriptBin "dev" # bash
          ''
            start_process() {
              setsid ags run app.ts &
              PID=$!
            }

            stop_process() {
              if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
                kill -TERM -"$PID"
                wait "$PID"
              fi
            }

            trap stop_process SIGINT

            start_process

            while ${pkgs.inotify-tools}/bin/inotifywait --quiet --event modify --event create --event delete --recursive .; do
              echo "File change detected. Restarting..."
              stop_process
              start_process
            done
          '';
      in pkgs.mkShell {
        buildInputs = [
          (ags.packages.${system}.default.override {
            inherit extraPackages;
          })
        ];

        packages = with pkgs; [
          emmet-language-server
          nodejs_24
          vscode-langservers-extracted
          devScript
        ];

        shellHook =
          let
            ansi = {
              cyan = "\\033[36m";
              bold = "\\033[1m";
              reset = "\\033[0m";
            };
          in # bash
          ''
            echo -e "${ansi.cyan}${ansi.bold}🔎 Run 'dev' to start project with auto-reloading.${ansi.reset}";
          '';
      };
    };
  };
}
