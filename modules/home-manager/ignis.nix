{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.programs.ignis;
  system = pkgs.system;
in
{
  options.programs.ignis = {
    enable = lib.mkEnableOption "Ignis widget framework for building desktop shells, written and configurable in Python";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ inputs.ignis.packages.${system}.ignis ];
  };
}
