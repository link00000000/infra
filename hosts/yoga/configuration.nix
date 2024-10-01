# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos.nix
    ../../modules/nix.nix
    ../../modules/home-manager.nix
    ../../modules/sudo.nix
    ../../modules/openssh.nix
    ../../modules/tailscale.nix
    ../../modules/sddm.nix
    ../../modules/polkit.nix
    ../../modules/pipewire.nix

    ../../users/logan
  ];

  time.timeZone = "America/New_York";

  networking = {
    hostName = "yoga";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Use iwd because wpa_supplicant is not auto-connecting on startup or remembering passwords
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    firefox
    nix-search-cli
  ];

  # TODO: Make microphone sound better

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}

