{ pkgs, config, lib, inputs, ... }:

let
  tokyonight = {
    base00 = "222436"; # Default Background
    base01 = "444a73"; # Lighter Background (Used for status bars, line number and folding marks)
    base02 = "2f334d"; # Selection Background
    base03 = "636da6"; # Comments, Invisibles, Line Highlighting, Unfocused window border
    base04 = "828bb8"; # Dark Foreground (Used for status bars), Alternate text
    base05 = "c8d3f5"; # Default Foreground, Caret, Delimiters, Operators, Default text
    base06 = "737aa2"; # Light Foreground (Not often used)
    base07 = "545c7e"; # Light Background (Not often used)
    base08 = "ff757f"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted, Error
    base09 = "ff966c"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url, Urgent
    base0A = "ffc777"; # Classes, Markup Bold, Search Text Background, Warning
    base0B = "c3e88d"; # Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "4fd6be"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "82aaff"; # Functions, Methods, Attribute IDs, Headings, Accent color, Focused window border
    base0E = "c099ff"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "c53b53"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = tokyonight;

    polarity = "dark";
    image = inputs.nixy-wallpapers + "/wallpapers/astronaut.png"; # Required. Might not be required in the future according to https://github.com/danth/stylix/issues/200

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 18;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
        name = "SFProDisplay";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.ny;
        name = "SFProDisplay";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };

    opacity.terminal = 0.95;
  };
}
