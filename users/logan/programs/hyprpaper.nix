{ pkgs, ... }:

{
  # TODO: Setup config
  home.packages = with pkgs; [
    hyprpaper
  ];
}
