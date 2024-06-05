{ lib, pkgs, inputs, nvidiaPackages?null, config, ... }: let
  cfg = config.jspspike.graphicsWrapper;
in {
  options.jspspike.graphicsWrapper = {
    kind = lib.mkOption {
      type = lib.types.enum ["intel" "none" "nvidia"];

      default = "none";
      description = lib.mdDoc ''
        idk
      '';
    };
    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    sha256 = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    functions = {
      vulkan = lib.mkOption {
        readOnly = true;
        visible = false;
      };
      opengl = lib.mkOption {
        readOnly = true;
        visible = false;
      };
    };
    package = lib.mkOption { readOnly = true; visible = false; };
  };

  config = {
    /*assertions = [
      { assertion = ((cfg.version != null && cfg.sha256 != null) && cfg.kind == "nvidia") || (cfg.version == null && cfg.sha256 == null && cfg.kind == "intel");
        message = ''
          do not set `version` and `sha256` when using `jspspike.graphicsWrapper.kind`s other than nvidia (using kind ${cfg.kind})!
        '';
      }
    ];*/

    jspspike.graphicsWrapper = let
      # Our bespoke version of: .... (TODO: find issue on nix-gl repo)
      wrapFunc = graphicsWrapperPackage: pkg: let
        name = "nixGL-${pkg.name}";
        wrapped = pkgs.runCommand name {} ''
          mkdir -p $out/bin
          for bin in "${lib.getBin pkg}"/bin/*; do
            echo -e > $out/bin/"$(basename "$bin")" \
            "#!/bin/bash\n" \
            "exec -a \"\$0\" ${lib.getExe graphicsWrapperPackage} \"$bin\" \"\$@\""
          done;
          chmod +x "$out"/bin/*
        '';
        wrappedWithEnv = pkgs.buildEnv {
          inherit name;
          paths = [ pkg ] ++ [(pkgs.hiPrio wrapped)];
        };
      in wrappedWithEnv // {
        # !!! uhhhh.. grab all the attrs?
        inherit (pkg) version pname;
      };

      # TODO: when this issue (https://github.com/nix-community/nixGL/issues/154)
      # is resolved we can get rid of `nvidiaPackages` and just use the regular
      # nixpkgs instance..
      nvidia = let
        nvidiaPackagesForDriverVersion = nvidiaPackages.nixgl.nvidiaPackages {
          inherit (cfg) version sha256;
        };
      in with nvidiaPackagesForDriverVersion; {
        opengl = nixGLNvidia;
        vulkan = nixVulkanNvidia;
      };

      intel = with inputs.nixgl.packages.${pkgs.system}; {
        opengl = nixGLIntel;
        vulkan = nixVulkanIntel;
      };
    in {
      functions = {
        none   = { vulkan = lib.id; opengl = lib.id; };
        intel  = lib.mapAttrs (_: wrapFunc) intel;
        nvidia = lib.mapAttrs (_: wrapFunc) nvidia;
      }.${cfg.kind};

      package = { none = null; inherit intel nvidia; }.${cfg.kind};
    };

    home = lib.mkIf (cfg.kind != "none") {
      packages = (with cfg.package; [ opengl vulkan ]);
      shellAliases = with cfg.package; {
        runOpengl = lib.getExe opengl;
        runVulkan = lib.getExe vulkan;
      };
    };
  };
}
