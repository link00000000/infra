{ ... }:

{
  # TODO: Enable this on a per-package basis
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    trusted-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
  };
}
