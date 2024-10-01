{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.qtwayland
    wl-clipboard
  ];
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
