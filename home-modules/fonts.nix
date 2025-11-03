{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    font-awesome
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    comic-neue
    inter
    mononoki
    pango.bin
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [
        "Noto Sans Symbols"
        "Noto Sans Symbols 2"
        "Symbols Nerd Font"
        "Noto Serif"
        "Noto Sans Math"
        "Noto Serif CJK JP"
      ];
      sansSerif = [
        "Noto Sans Symbols"
        "Noto Sans Symbols 2"
        "Symbols Nerd Font"
        "Noto Sans"
        "Noto Sans Math"
        "Noto Sans CJK JP"
      ];
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Symbols"
        "Noto Sans Symbols 2"
        "Symbols Nerd Font Mono"
        "Noto Sans Mono CJK JP"
        "Noto Sans Math"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
  };
}
