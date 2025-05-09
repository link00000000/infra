{ pkgs, lib, ... }:

{
  imports = [
    ../../system/bluetooth.nix
    ../../system/docker.nix
    ../../system/hyprland.nix
    ../../system/locale.nix
    ../../system/network-manager.nix
    ../../system/nix.nix
    ../../system/nixos.nix
    ../../system/openssh.nix
    ../../system/polkit.nix
    ../../system/power-management.nix
    ../../system/sddm.nix
    ../../system/sound.nix
    ../../system/sudo.nix
    ../../system/systemd-boot.nix
    ../../system/tailscale.nix
    ../../system/utils.nix
    ../../system/virtualbox.nix
    ../../system/wireshark.nix

    ../../users/logan

    ../../themes/tokyonight.nix

    #../../system/hyprland.nix # TODO: Import this per user

    ./hardware-configuration.nix
  ];

  # TODO: Setup automatic garbage collection
  # TODO: Setup XDG portal

  # Networking
  networking.hostName = "yoga";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  # Graphics drivers
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver      # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver      # LIBVA_DRIVER_NAME=i965
      libvdpau-va-gl          # VDPAU→VA-API bridge
      vulkan-loader           # for WebRender/Vulkan support
      #intel-vulkan-driver     # Intel Vulkan ICD
    ];
  };

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Do not change
  system.stateVersion = "20.03";
}

