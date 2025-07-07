{ config, ... }:

{
  # TODO: Setup copying nushell config
  programs.nushell = {
    enable = true;

    # HACK: Workaround until https://github.com/nix-community/home-manager/issues/4313 is merged
    environmentVariables = builtins.mapAttrs (name: value: "${builtins.toString value}") config.home.sessionVariables;

    extraConfig = /* nu */ ''
      def "config home" [] {
        cd /etc/nixos/users/logan
        ^$env.EDITOR default.nix
      }

      def "config nixos" [] {
        cd /etc/nixos
        ^$env.EDITOR flake.nix
      }

      def --wrapped "nix flake init" [
      --template: string
        ...rest
      ] {
        if ($template == null) {
          ^nix flake init ...$rest
            return
        }
        let parsed_template = ($template | parse "{repo}#{name}")
        if ($parsed_template | is-empty) {
          ^nix flake init --template $"($template)" ...$rest
            return
        }

        let parsed_template = $parsed_template | first
        if (($parsed_template | get repo) != "dev") {
          ^nix flake init --template $"($template)" ...$rest
          return
        }

        ^nix flake init --template $"https://flakehub.com/f/the-nix-way/dev-templates/*#($parsed_template | get name)" ...$rest
      }

      def battery [] {
        open /sys/class/power_supply/BAT1/capacity
      }

      def --wrapped sudo [...rest] {
        if ($rest | is-empty) {
          ^sudo -E -s nu
        } else {
          ^sudo ...$rest
        }
      }

      def --wrapped git [...rest] {
        if ($rest | is-empty) {
          ${config.programs.lazygit.package}/bin/lazygit
        } else if (($rest | length) == 1 and ($rest | first) == "status") {
          ${config.programs.lazygit.package}/bin/lazygit status
        } else if (($rest | length) == 1 and ($rest | first) == "branch") {
          ${config.programs.lazygit.package}/bin/lazygit branch
        } else if (($rest | length) == 1 and ($rest | first) == "log") {
          ${config.programs.lazygit.package}/bin/lazygit log
        } else if (($rest | length) == 1 and ($rest | first) == "stash") {
          ${config.programs.lazygit.package}/bin/lazygit stash
        } else {
          ^git ...$rest
        }
      }
    '';
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.keychain = {
    enable = true;
    enableNushellIntegration = true;
    keys = [ "id_rsa" "id_ed25519" ];
    extraFlags = [ "--quick" "--ignore-missing" ];
  };
}
