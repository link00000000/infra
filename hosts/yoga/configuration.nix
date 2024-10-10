{ pkgs, lib, ... }:

{
  imports = [
    ../../system/modules/bluetooth.nix
    ../../system/modules/locale.nix
    ../../system/modules/network-manager.nix
    ../../system/modules/nix.nix
    ../../system/modules/nixos.nix
    ../../system/modules/openssh.nix
    ../../system/modules/polkit.nix
    ../../system/modules/power-management.nix
    ../../system/modules/sound.nix
    ../../system/modules/sudo.nix
    ../../system/modules/systemd-boot.nix
    ../../system/modules/tailscale.nix
    ../../system/modules/utils.nix

    ../../users/logan

    #../../system/modules/hyprland.nix # TODO: Import this per user

    ./hardware-configuration.nix
  ];

  # TODO: Setup automatic garbage collection
  # TODO: Setup XDG portal

  environment.systemPackages = with pkgs; [
    curl
  ];

  # Networking
  networking.hostName = "yoga";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  # Graphics drivers
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # Do not change
  system.stateVersion = "20.03";
}

