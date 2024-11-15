{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    
    config = {
      common.default = [ "kde" "hyprland" "gtk" ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-kde
    ];
  };
}
