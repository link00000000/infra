{ pkgs, inputs, ... }:

let
  catppuccin = {
    base00 = "0b0b0b"; # Default Background
    base01 = "1b1b1b"; # Lighter Background (Used for status bars, line number and folding marks)
    base02 = "2b2b2b"; # Selection Background
    base03 = "45475a"; # Comments, Invisibles, Line Highlighting
    base04 = "585b70"; # Dark Foreground (Used for status bars)
    base05 = "fcfcfc"; # Default Foreground, Caret, Delimiters, Operators
    base06 = "f5e0dc"; # Light Foreground (Not often used)
    base07 = "b4befe"; # Light Background (Not often used)
    base08 = "f38ba8"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "fab387"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "f9e2af"; # Classes, Markup Bold, Search Text Background
    base0B = "a6e3a1"; # Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "94e2d5"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "a594fd"; # Functions, Methods, Attribute IDs, Headings, Accent color
    base0E = "cba6f7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "f2cdcd"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  };

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

  tokyonight-moon = rec {
    base00 = "222436"; # Default Background
    base01 = "1e2030"; # Lighter Background (Used for status bars, line number and folding marks)
    base02 = "2f334d"; # Selection Background
    base03 = "636da6"; # Comments, Invisibles, Line Highlighting
    base04 = "828bb8"; # Dark Foreground (Used for status bars)
    base05 = "c8d3f5"; # Default Foreground, Caret, Delimiters, Operators
    base06 = base05; # Light Foreground (Not often used)
    base07 = base00; # Light Background (Not often used)
    base08 = "c53b53"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "ff966c"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "ffc777"; # Classes, Markup Bold, Search Text Background
    base0B = "c3e88d"; # Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "4fd6be"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "c099ff"; # Functions, Methods, Attribute IDs, Headings, Accent color
    base0E = "fca7ea"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "ff757f"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  };
in
{
  stylix = {
    enable = false;
    base16Scheme = tokyonight-moon;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 10;
        terminal = 13;
      };
    };

    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };
  };
}
