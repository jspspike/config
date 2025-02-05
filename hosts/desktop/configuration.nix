{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/i3.nix ../../machine-modules/common.nix ];

  environment.extraInit = ''
    autorandr --change
    xset s off -dpms
  '';

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];

  services = {
    autorandr = {
      enable = true;
      profiles = {
        "main" = {
          fingerprint = {
            "DP-0.1" = "00ffffffffffff000469a7274896020030190104a53c22783ac8c5a8554ea2260d5054b7ef00d1c095008180714f0101010101010101e8e40050a0a067500820980455502100001e565e00a0a0a029503020350055502100001e000000fd00329018de3c000a202020202020000000fc0041535553204d473237390a2020013d02031cf1491213041f900e0f1d1e230917078301000065030c002000e8e40050a0a067500820980455502100001e011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e565e00a0a0a029503020350055502100001e87bc0050a0a055500820780055502100001e00000000000000000095";
            "DP-0.2" = "00ffffffffffff001e6d7f5bdc1d010006220104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf09ec00a0a0a0675030203a0055502100001a000000fd003090e6e63c010a202020202020000000fc004c4720554c545241474541520a000000ff003430364e54514432353138300a015902031a7123090607e305c000e60605015a5a4446100403011f13565e00a0a0a029503020350055502100001a5aa000a0a0a0465030203a005550210000006fc200a0a0a0555030203a0055502100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c3";
          };
          config = {
            "DP-0.2" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              position = "1440x450";
            };
            "DP-0.1" = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "120";
              rotate = "left";
            };
          };
        };
      };
    };
  };
}
