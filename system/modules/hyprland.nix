{ pkgs, lib, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
    mako # TODO: Move to user config?
    #xdg-desktop-portal # TODO: Remove? Already included by programs.hyprland.enable?
    kdePackages.polkit-kde-agent-1
    kdePackages.qtwayland
    wl-clipboard
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
}
