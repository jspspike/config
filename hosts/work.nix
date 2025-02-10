{ pkgs, lib, inputs, config, ... }:
{
  home = {
    username = "jjohnson";
    homeDirectory = "/home/jjohnson";
    packages = with pkgs; [
      tcpflow
    ];
  };
  programs = {
    git = {
      userName = "jjohnson";
      userEmail = "jjohnson@cloudflare.com";
    };
    alacritty = {
      settings = {
        font.size = 10.0;
      };
    };
    kitty = {
      settings = {
        font_size = 18.0;
      };
    };
    autorandr = {
      enable = true;
      profiles = {
        "laptop" = {
          fingerprint = {
            "eDP1" = "00ffffffffffff004c836441000000000b1f0104b5221678020cf1ae523cb9230c50540000000101010101010101010101010101010171df0050f06020902008880058d71000001b71df0050f06020902008880058d71000001b000000fe0044334b4a468031363059563033000000000003040300010000000b010a202001f802030f00e3058000e606050174600700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b7";
          };
          config = {
            "eDP1" = {
              enable = true;
              primary = true;
              mode = "2560x1600";
              position = "0x0";
            };
          };
        };
        "+work_monitor" = {
          fingerprint = {
            "eDP1" = "00ffffffffffff004c836441000000000b1f0104b5221678020cf1ae523cb9230c50540000000101010101010101010101010101010171df0050f06020902008880058d71000001b71df0050f06020902008880058d71000001b000000fe0044334b4a468031363059563033000000000003040300010000000b010a202001f802030f00e3058000e606050174600700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b7";
            "DVI-I-1-1" = "00ffffffffffff0010ac3bf1424e464123200104b53c22783a5095a8544ea5260f5054a54b00714f8180a9c0d1c001010101010101014dd000a0f0703e803020350055502100001a000000ff003351395a5751330a2020202020000000fc0044454c4c20503237323351450a000000fd0018560f873c000a20202020202001bc020314b14f5f5e5d101f2221200413121103020104740030f2705a80b0588a0055502100001c565e00a0a0a029503020350055502100001c023a801871382d40582c450055502100001e114400a0800025503020360055502100001c000000000000000000000000000000000000000000000000000000000000000000000046";
          };
          config = {
            "eDP1" = {
              enable = true;
              primary = true;
              mode = "2560x1600";
              position = "0x0";
            };
            "DVI-I-1-1" = {
              enable = true;
              mode = "3840x2160";
              position = "2560x0";
            };
          };
        };
        "home_setup" = {
          fingerprint = {
            "DP3-1" = "00ffffffffffff000469a7274896020030190104a53c22783ac8c5a8554ea2260d5054b7ef00d1c095008180714f0101010101010101e8e40050a0a067500820980455502100001e565e00a0a0a029503020350055502100001e000000fd00329018de3c000a202020202020000000fc0041535553204d473237390a2020013d02031cf1491213041f900e0f1d1e230917078301000065030c002000e8e40050a0a067500820980455502100001e011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e565e00a0a0a029503020350055502100001e87bc0050a0a055500820780055502100001e00000000000000000095";
            "DP3-2" = "00ffffffffffff001e6d7f5bdc1d010006220104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf09ec00a0a0a0675030203a0055502100001a000000fd003090e6e63c010a202020202020000000fc004c4720554c545241474541520a000000ff003430364e54514432353138300a015902031a7123090607e305c000e60605015a5a4446100403011f13565e00a0a0a029503020350055502100001a5aa000a0a0a0465030203a005550210000006fc200a0a0a0555030203a0055502100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c3";
          };
          config = {
            "DP3-2" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              position = "1440x450";
            };
            "DP3-1" = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "120";
              rotate = "left";
            };
          };
        };
        "+home_setup" = {
          fingerprint = {
            "eDP1" = "00ffffffffffff004c836441000000000b1f0104b5221678020cf1ae523cb9230c50540000000101010101010101010101010101010171df0050f06020902008880058d71000001b71df0050f06020902008880058d71000001b000000fe0044334b4a468031363059563033000000000003040300010000000b010a202001f802030f00e3058000e606050174600700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b7";
            "DP3-1" = "00ffffffffffff000469a7274896020030190104a53c22783ac8c5a8554ea2260d5054b7ef00d1c095008180714f0101010101010101e8e40050a0a067500820980455502100001e565e00a0a0a029503020350055502100001e000000fd00329018de3c000a202020202020000000fc0041535553204d473237390a2020013d02031cf1491213041f900e0f1d1e230917078301000065030c002000e8e40050a0a067500820980455502100001e011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e565e00a0a0a029503020350055502100001e87bc0050a0a055500820780055502100001e00000000000000000095";
            "DP3-2" = "00ffffffffffff001e6d7f5bdc1d010006220104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf09ec00a0a0a0675030203a0055502100001a000000fd003090e6e63c010a202020202020000000fc004c4720554c545241474541520a000000ff003430364e54514432353138300a015902031a7123090607e305c000e60605015a5a4446100403011f13565e00a0a0a029503020350055502100001a5aa000a0a0a0465030203a005550210000006fc200a0a0a0555030203a0055502100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c3";
          };
          config = {
            "eDP1" = {
              enable = false;
            };
            "DP3-2" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              position = "1440x450";
            };
            "DP3-1" = {
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

  imports = [ ../home-modules/i3.nix ];
}
