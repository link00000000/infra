{ ... }:

{
  hardware.pulseaudio.enable = true;

  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
}
