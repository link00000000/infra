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

  home-manager.users.${username} = { pkgs, config, ... }:
  {
    home.packages = with pkgs; [
      hyprpaper
      parsec-bin
      fzf
      rofi
    ];

    # TODO: Add hyprexpo plugin
    wayland.windowManager.hyprland = {
      enable = true;
      #package = inputs.hyprland.packages.${pkgs.system}.default;
      xwayland.enable = true;
#      plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
#        hyprexpo
#      ];
      settings = {
        "debug:disable_logs" = true;
      
        # Refer to https://wiki.hyprland.org/Configuring/Variables/
        "$terminal" = "${inputs.wezterm.packages.${pkgs.system}.default}/bin/wezterm";
        "$fileManager" = "dolphin"; # TODO: Setup a file manager
        "$menu" = "${pkgs.rofi}/bin/rofi";

        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$mainMod" = "SUPER";

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [ ",preferred,auto,auto" ];
        xwayland = { force_zero_scaling = true; };

        exec-once = [ "${pkgs.hyprpaper}/bin/hyprpaper" ];

        # See https://wiki.hyprland.org/Configuring/Environment-variables/
        env = [
          "GDK_SCALE,4"
          "XCURSOR_SIZE,12"
          "HYPRCURSOR_SIZE,12"
        ];

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 1;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # https://wiki.hyprland.org/Configuring/Tearing/
          allow_tearing = false;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        # https://wiki.hyprland.org/Configuring/Animations/
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
          ];
        };

        # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # You probably want this
        };

        # https://wiki.hyprland.org/Configuring/Master-Layout/
        master = {
          new_status = "master";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = { 
          force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        };

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = true;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#gestures
        gestures = {
            workspace_swipe = true;
        };

        # https://wiki.hyprland.org/Configuring/Binds/
        bind = [
          "$mainMod, T, exec, $terminal"
          "$mainMod, X, killactive,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, F, togglefloating,"
          "$mainMod, SPACE, exec, $menu"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod, RIGHT, workspace, +1"
          "$mainMod, LEFT, workspace, -1"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrulev2 = "suppressevent maximize, class:.*";
      };
    };

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

    programs.ripgrep = {
      enable = true;
    };

    # TODO: Setup copying nushell config
    programs.nushell = {
      enable = true;

      # HACK: Workaround until https://github.com/nix-community/home-manager/issues/4313 is merged
      environmentVariables = builtins.mapAttrs (name: value: "\"${builtins.toString value}\"") config.home.sessionVariables;

      extraConfig = /* nu */ ''
        def "config home" [] {
          cd /etc/nixos/users/${username}
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

    # TODO: Setup wezterm
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };

    programs.tealdeer = {
      enable = true;
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
