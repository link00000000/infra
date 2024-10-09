# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ pkgs, lib, ... }:

{
  imports =
  [
    ../../system/modules/bluetooth.nix
    ../../system/modules/home-manager.nix
    ../../system/modules/nix.nix
    ../../system/modules/nixos.nix
    ../../system/modules/openssh.nix
    ../../system/modules/sudo.nix
    ../../system/modules/tailscale.nix

    ../../home/users/logan

    ../../system/modules/hyprland.nix # TODO: Import this per user

    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    firefox
    nix-search-cli
  ];

  time.timeZone = "America/New_York";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "yoga";

    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Use iwd because wpa_supplicant is not auto-connecting on startup or remembering passwords
    };

    interfaces.wlan0.useDHCP = lib.mkDefault true;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  sound.enable = true;
  powerManagement.enable = true;

  # TODO: Make microphone sound better

  # Do not change
  system.stateVersion = "20.03";
}

