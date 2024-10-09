{ ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd"; # Use iwd because wpa_supplicant is not auto-connecting on startup or remembering passwords
  };
}
