{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
      rofi-wayland
  ];
}
