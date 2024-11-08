{ pkgs, lib, ... }:

let
  pkgsToml = "/etc/nixos/users/logan/pkgs.toml";
  nixosPkgsCmd = pkgs.writeScriptBin "nixos-pkgs" /* bash */''
    GREP="${pkgs.gnugrep}/bin/grep"
    GIT="${pkgs.git}/bin/git"
    OPENSSL="${pkgs.openssl}/bin/openssl"
    NIXSEARCH="${pkgs.nix-search-cli}/bin/nix-search"
    DIRNAME="${pkgs.coreutils}/bin/dirname"
    NIXOS_REBUILD="${pkgs.nixos}/bin/nixos-rebuild"
    TOMLQ="${pkgs.yq}/bin/tomlq"

    PKGS_TOML_PATH="${pkgsToml}"
    REBUILD=true
    STASH=false
    ORIGINAL_CWD=$(pwd)

    DID_STASH=false
    STASH_MESSAGE="Stashing changes before script execution - ID: $($OPENSSL rand -hex 6)"

    help() {
      cat << EOF
Usage: $0 {command} <package-name> [OPTIONS]

Manage packages in pkgs.toml for NixOS.

Subcommands:
a, add, i, install        Add a package to pkgs.toml.
r, remove, u, uninstall   Remove a package from pkgs.toml.

Options:
--no-rebuild   Skip the nixos-rebuild command after changes.
--stash        Stash any uncommitted changes before making modifications.
--path <path>  Override the default path to pkgs.toml (default: ${pkgsToml}).

Example:
$0 install firefox
EOF
      exit 1
    }

    cleanup() {
      if [ "$DID_STASH" = true ]; then
        if $GIT stash list | grep -q "$STASH_MESSAGE"; then
          $GIT stash pop
        fi
      fi

      cd "$ORIGINAL_CWD" || exit 1
    }

    trap cleanup EXIT

    if [ "$#" -ne 2 ]; then
      help
    fi

    while [[ "$#" -gt 0 ]]; do
      case "$1" in
        a|add|i|install)
          SUBCOMMAND="install"
          shift
          ;;
        r|remove|u|uninstall)
          SUBCOMMAND="uninstall"
          shift
          ;;
        --no-rebuild)
          REBUILD=false
          shift
          ;;
        --stash)
          STASH=true
          shift
          ;;
        --path)
          PKGS_TOML_PATH="$2"
          shift 2
          ;;
        *)
          if [[ -z "$PACKAGE_NAME" ]]; then
              PACKAGE_NAME="$1"
          else
              help
          fi
          shift
          ;;
        esac
    done

    if [[ -z "$SUBCOMMAND" || -z "$PACKAGE_NAME" ]]; then
      help
    fi

    # 1. cd to git repo root containing pkgs.toml
    PKGS_DIR=$($DIRNAME "$PKGS_TOML_PATH")
    cd "$PKGS_DIR" || { echo "Failed to change directory to $PKGS_DIR"; exit 1; }

    GIT_ROOT=$($GIT rev-parse --show-toplevel)
    cd "$GIT_ROOT" || { echo "Failed to change directory to git root $GIT_ROOT"; exit 1; }

    # 2. Stash changes if --stash was passed, otherwise fail
    if ! $GIT diff-index --quiet HEAD --; then
      if [ "$STASH" = true ]; then
        DID_STASH=true
        $GIT stash push -m "$STASH_MESSAGE"
      else
        echo "There are pending changes. Use --stash to stash them or commit them before running the script."
        exit 1
      fi
    fi

    if [[ "$SUBCOMMAND" == "install" ]]; then
      # 3a. Check if package exists in nixpkgs
      $NIXSEARCH $PACKAGE_NAME | $GREP -E "^$PACKAGE_NAME " -q
      if [ $? -ne 0 ]; then
        echo "Package $PACKAGE_NAME does not exist."
        $NIXSEARCH $PACKAGE_NAME
        exit 1
      fi

      # 3b. Add package to pkgs.toml if it is not already in there
      if [[ $($TOMLQ "(.pkgs | index(\"$PACKAGE_NAME\")) != null)") == "true" ]]; then
        echo "$PACKAGE_NAME already installed."
        exit 0
      else
        $TOMLQ --in-place --toml-output ".pkgs += [\"$PACKAGE_NAME\"]" $PKGS_TOML_PATH
      fi

      # 3c. Create a git commit
      $GIT add "$PKGS_TOML_PATH"
      $GIT commit -m "Added '$PACKAGE_NAME' to pkgs.toml"

    elif [[ "$SUBCOMMAND" == "uninstall" ]]; then
      # 4a. Remove package from pkgs.toml if it is there
      if [[ $($TOMLQ "(.pkgs | index(\"$PACKAGE_NAME\")) != null)") == "true" ]]; then
        $TOMLQ --in-place --toml-output ".pkgs |= map(select(. != \"$PACKAGE_NAME\"))" $PKGS_TOML_PATH
      else
        echo "$PACKAGE_NAME is not installed."
        exit 0
      fi

      # 4b. Create a git commit
      $GIT add "$PKGS_TOML_PATH"
      $GIT commit -m "Removed '$PACKAGE_NAME' from pkgs.toml"
    fi

    # 5. Rebuild the system if --no-rebuild was not passed
    if [ "$REBUILD" = true ]; then
      $NIXOS_REBUILD switch
    fi
  '';

  pkgsFromPkgsToml = lib.map (p: pkgs.${p}) (lib.importTOML ./pkgs.toml).pkgs;
in
{
  home.packages = [ nixosPkgsCmd ];
}
