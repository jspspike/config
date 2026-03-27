{ writeShellApplication, coreutils, grim, slurp, wofi }:

writeShellApplication {
  name = "screenshot";

  runtimeInputs = [
    coreutils
    grim
    slurp
    wofi
  ];

  text = ''
    set -eu

    target_dir="$HOME/Pictures"
    default_name="$(date +'%Y-%m-%d-%H:%M:%S')"

    if [ "$#" -gt 0 ]; then
      name="$1"
    else
      name="$(printf '%s\n' "$default_name" | wofi --dmenu --prompt 'Screenshot name')"
      name="''${name:-$default_name}"
    fi

    case "$name" in
      *.png) ;;
      *) name="$name.png" ;;
    esac

    mkdir -p "$target_dir"
    grim -g "$(slurp)" "$target_dir/$name"
  '';
}
