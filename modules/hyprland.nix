{ pkgs, ... }:

{
  imports = [
    ./wayland.nix
  ];

  environment.systemPackages = with pkgs; [
    hyprland
  ];
}
