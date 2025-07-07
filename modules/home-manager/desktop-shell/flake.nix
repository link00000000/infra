{
  description = "A custom desktop shell made with AGS";

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
      default = self.packages.${system}.desktop-shell;
      desktop-shell = pkgs.stdenv.mkDerivation {
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
            if [[ "$DEVSCRIPT_DEBUG" -eq 1 ]]; then
              set -x
            fi

            SYSTEMD_SERVICE=desktop-shell.service
            AGS_ENTRYPOINT=app.ts

            log() {
              local level="$1"
              shift
              local message="$*"

              case "$level" in
                "error")
                  echo "$(tput setaf 1)$message$(tput sgr0)"
                  ;;
                "info")
                  echo "$(tput setaf 4)$message$(tput sgr0)"
                  ;;
                *)
                  echo "$message"
                  ;;
              esac
            }

            continue_prompt() {
              local prompt_message="$1"

              while true; do
                read -p "$prompt_message" answer
                case "$answer" in
                  [yY]|"")
                    return 0
                    ;;
                  [nN])
                    return 1
                    ;;
                  *)
                    ;;
                esac
              done
            }

            start_ags() {
              setsid ags run "$AGS_ENTRYPOINT" &
              AGS_PID=$!

              return $AGS_PID
            }

            stop_ags() {
              if [[ -n "$AGS_PID" ]] && kill -0 "$AGS_PID" 2>/dev/null; then
                kill -TERM -"$AGS_PID"
                wait "$AGS_PID"
              fi
            }

            stop_systemd_system_service() {
              if systemctl list-units --type=service | grep -q "$SYSTEMD_SERVICE"; then
                if continue_prompt "A running system service was found. Terminate the service and restore on exit? (Y/n)"; then
                  systemctl stop "$SYSTEMD_SERVICE"
                  DID_TERMINATE_SYSTEMD_SYSTEM_SERVICE=1
                  log "info" "Terminated systemd system service $SYSTEMD_SERVICE"
                else
                  return 1
                fi
              fi

              return 0
            }

            restore_systemd_system_service() {
              if [[ $DID_TERMINATE_SYSTEMD_SYSTEM_SERVICE -eq 1 ]]; then
                systemctl start "$SYSTEMD_SERVICE"
                log "info" "Restored systemd system service $SYSTEMD_SERVICE"
              fi
            }

            stop_systemd_user_service() {
              if systemctl list-units --user --type=service | grep -q "$SYSTEMD_SERVICE"; then
                if continue_prompt "A running user service was found. Terminate the service and restore on exit? (Y/n)"; then
                  systemctl stop --user "$SYSTEMD_SERVICE"
                  DID_TERMINATE_SYSTEMD_USER_SERVICE=1
                  log "info" "Terminated systemd user service $SYSTEMD_SERVICE"
                else
                  return 1
                fi
              fi
              
              return 0
            }

            restore_systemd_user_service() {
              if [[ $DID_TERMINATE_SYSTEMD_USER_SERVICE -eq 1 ]]; then
                systemctl start --user "$SYSTEMD_SERVICE"
                log "info" "Restored systemd user service $SYSTEMD_SERVICE"
              fi
            }

            cleanup() {
              log "info" "Exiting..."
              stop_ags
              restore_systemd_system_service
              restore_systemd_user_service
            }

            trap cleanup SIGINT

            if ! stop_systemd_system_service; then
              log "error" "Cannot start because system service is running."
              exit 1
            fi

            if ! stop_systemd_user_service; then
              log "error" "Cannot start because user service is running."
              exit 1
            fi

            start_ags

            while true; do
              ${pkgs.inotify-tools}/bin/inotifywait --quiet --event modify --event create --event delete --recursive . &
              INOTIFY_PID=$!

              wait -n "$AGS_PID" "$INOTIFY_PID" 2>/dev/null

              if ! kill -0 "$AGS_PID" 2>/dev/null; then
                kill "$INOTIFY_PID" 2>/dev/null
                wait "$INOTIFY_PID" 2>/dev/null
                break
              fi

              if ! kill -0 "$INOTIFY_PID" 2>/dev/null; then
                log "info" "File change detected. Restarting..."
                stop_ags
                start_ags
              fi
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

    homeManagerModules = {
      default = self.homeManagerModules.desktop-shell;
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
            description = "The Ags package to use.";
          };
        };

        config = lib.mkIf cfg.enable {
          systemd.user.services.desktop-shell = {
            Unit = {
              Description = "A custom desktop shell made with AGS";
              PartOf = ["graphical-session.target"];
              After = ["graphical-session-pre.target"];
            };

            Service = {
              ExecStart = "${cfg.package}/bin/my-shell";
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
