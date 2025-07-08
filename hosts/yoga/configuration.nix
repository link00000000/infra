{
  pkgs,
  lib,
  inputs,
  ...
}:

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
    #../../system/tailscale.nix
    ../../system/utils.nix
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
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965
      libvdpau-va-gl # VDPAU→VA-API bridge
      vulkan-loader # for WebRender/Vulkan support
      #intel-vulkan-driver     # Intel Vulkan ICD
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  /*
    systemd.user.services.desktop-shell = {
      unitConfig = {
        Description = "A custom desktop shell made with AGS";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session-pre.target"];
      };

      serviceConfig = {
        ExecStart = "${inputs.desktop-shell.packages.${pkgs.system}.desktop-shell}/bin/my-shell";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      wantedBy = ["graphical-session.target"];
    };
  */

  environment.systemPackages = [
    inputs.desktop-shell.packages.${pkgs.system}.desktop-shell
  ];

  swapDevices = [
    { device = "/swapfile"; size = 16 * 1024; }
  ];

  # Do not change
  system.stateVersion = "20.03";
}
