# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ pkgs, lib, ... }:

{
  imports =
  [
    ./hardware-configuration.nix

    ../../modules/nixos.nix
    ../../modules/nix.nix
    ../../modules/home-manager.nix
    ../../modules/sudo.nix
    ../../modules/openssh.nix
    ../../modules/tailscale.nix
    ../../modules/blueman.nix

    ../../users/logan

    ../../modules/desktop-environments/hyprland.nix # TODO: Import this per user?
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}

