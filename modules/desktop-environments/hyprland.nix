{ config, pkgs, lib, pkgs-unstable, inputs, ... }:


with lib;

{
  environment.systemPackages = with pkgs; [
    catppuccin-sddm
    kitty # Default terminal, remove after setting up config
    mako # Notification daemon
    #xdg-desktop-portal # TODO: Remove? Already included by programs.hyprland.enable?
    kdePackages.polkit-kde-agent-1
    kdePackages.qtwayland
    tofi
    wl-clipboard
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    xwayland.enable = true;
  };

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      }); 
    '';
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
