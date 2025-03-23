{ pkgs, ... }:

{
  imports = [
    ../../system/locale.nix
    ../../system/nix.nix
    ../../system/nixos.nix
    ../../system/sudo.nix
    ../../system/utils.nix
    ../../system/openssh.nix

    ../../themes/tokyonight.nix

    ../../themes/tokyonight.nix

    ../../users/logan
  ];

  environment.sessionVariables.BROWSER = "explorer.exe";

  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [
    gh
  ];

  # WSL
  wsl.enable = true;
  #wsl.useWindowsDriver = true;
  wsl.defaultUser = "logan";
  wsl.docker.enable = true;

  # Hardware acceleration
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
    mesa.drivers
    libvdpau-va-gl
    (libedit.overrideAttrs (attrs: {postInstall = (attrs.postInstall or "") + ''ln -s $out/lib/libedit.so $out/lib/libedit.so.2'';}))
  ];

  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"
      "${pkgs.linuxPackages.nvidia_x11}/lib"
      "${pkgs.ncurses5}/lib"
      "/run/opengl-driver/lib"
    ];
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
  };

  # Networking
  networking.hostName = "wsl";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Do not change
  system.stateVersion = "23.11";
}
