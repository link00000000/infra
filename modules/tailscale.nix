{ pkgs, ... }:

{
  # NOTE: Run `tailscale up` once to authenticate
  services.tailscale.enable = true;
}
