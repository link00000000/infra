{ ... }:

{
  # TODO: Enable this on a per-package basis
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
