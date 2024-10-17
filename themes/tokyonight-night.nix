{ lib, ... }:

let
  tokyonight-night = rec {
    base00 = "1a1b26"; # Default Background
    base01 = base03; # Lighter Background (Used for status bars, line number and folding marks)
    base02 = "292e42"; # Selection Background
    base03 = "565f89"; # Comments, Invisibles, Line Highlighting
    base04 = "a9b1d6"; # Dark Foreground (Used for status bars)
    base05 = "c0caf5"; # Default Foreground, Caret, Delimiters, Operators
    base06 = base05; # Light Foreground (Not often used)
    base07 = base00; # Light Background (Not often used)
    base08 = "db4b4b"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "ff9e64"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "e0af68"; # Classes, Markup Bold, Search Text Background
    base0B = "9ece6a"; # Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "1abc9c"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "9d7cd8"; # Functions, Methods, Attribute IDs, Headings, Accent color
    base0E = "bb9af7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "f7768e"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  };
in
{
  imports = [
    ./tokyonight.nix
  ];

  stylix = {
    enable = lib.mkForce true;
    base16Scheme = lib.mkForce tokyonight-night;
  };
}
