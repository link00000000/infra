{ pkgs, inputs, ... }:

let
  username = "logan";

in
{
  users.users.${username} = {
    name = username;
    home = "/home/logan";
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "admin" ];
    shell = pkgs.nushell;
  };

  home-manager.users.${username} = { pkgs, ... }:
  {
    # TODO: Setup copying config
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "link00000000";
      userEmail = "crandall.logan@gmail.com";
    };

    programs.lazygit = {
      enable = true;
    };

    # TODO: Setup copying config
    programs.neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };

    # TODO: Setup copying nushell config
    programs.nushell = {
      enable = true;
      extraConfig = ''
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
      '';
    };

    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableNushellIntegration = true;
    };

    # TODO: Setup wezterm
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };

    # TODO: Setup clipboard history

    # TODO: Add hyprpaper config

    # TODO: Add hyprland config

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";
  };
}
