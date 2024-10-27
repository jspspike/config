{ pkgs, lib, inputs, config, ... }:
{
  home = {
    packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];
  };
}
