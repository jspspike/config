{ pkgs, lib, inputs, config, ... }: let
  gWrap = config.jspspike.graphicsWrapper.functions;
in {
  # Here's your list of packages, adding something to here and
  # rebuilding your config should be enough to make it available.
  home = {
    username = lib.mkDefault "jspspike";
    homeDirectory = lib.mkDefault "/home/jspspike";
    stateVersion = "23.11";
    packages = with pkgs; [
      # utils
      ripgrep fd bat eza jq htop bottom ncdu duf rust-analyzer rust-bindgen

      # apps
      (gWrap.opengl telegram-desktop) (gWrap.opengl google-chrome)

      # some nix-specific tools
      nix home-manager nix-output-monitor nix-tree nil comma
    ];
    sessionVariables = {
      WEE = "WOO"; # echo $WEE to check if it's working :P
      NIX_PATH = "nixpkgs=flake:nixpkgs";
    };
    file = builtins.listToAttrs (map (path:
      let f = lib.strings.removePrefix (inputs.self + "/dotfiles/") (toString path);
      in {
        name = f;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink
            (config.home.homeDirectory + "/config/dotfiles/" + f);
        };
      }) (lib.filesystem.listFilesRecursive ../dotfiles));
  };

  # this is the output that home-manager uses for "managed" stuff, when you want to start messing
  # with that you can go to https://mipmip.github.io/home-manager-option-search and look under
  # programs.<name> or services.<name> for all the relevant options.
  programs = {
    direnv = { enable = true; nix-direnv.enable = true; };
    alacritty = {
      enable = true;
      package = gWrap.opengl pkgs.alacritty;
      settings = {
        font.size = 12.0;
        colors = {
          draw_bold_text_with_bright_colors = true;
        };
      };
    };
    git = {
      enable = true;
      userName = lib.mkDefault "jspspike";
      userEmail = lib.mkDefault "jspspike@gmail.com";
      delta = {
        enable = true;
      };
      extraConfig.pull.rebase = "true";
      extraConfig.merge.conflictstyle = "diff3";
      extraConfig.core.editor = "nvim";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      shellAliases = {
        "xopen" = "xdg-open";
        "vi" = "nvim";
        "ls" = "exa --oneline --long --icons";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "michelebologna";
      };
      initExtra = "
        setxkbmap -option caps:escape\n

        function rm {
          mv \"\${@}\" /tmp
        }\n
      ";
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # finally for stuff that runs as a daemon you'll want to look under the services option
  services = {
    # records your clipboard history
    clipmenu.enable = true;
  };

  # when you use something like `nix run nixpkgs#htop`, the registry is where nix looks up
  # the thing on the left hand side
  nix.registry = {
    # you generally want your `nix shell` and `nix run` to use the same version of nixpkgs
    # that your home configuration is using, that way you don't have to redownload slightly
    # different versions of a bunch of stuff.
    nixpkgs.flake = inputs.nixpkgs;
    # this is just a QOL entry that lets you refer to your flake by name rather than
    # by path. it'll let you do stuff like `nix flake update config` and `nix run config#eggnogg`
    config.to = { type = "git"; url = "file://${config.home.homeDirectory}/config"; }; # !!!
  };

  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./graphics.nix
    ./nvim.nix
    # if you end up configuring stuff with home-manager it's helpful to stick related bits
    # in their own modules and you can organize them however you want. Those modules
    # get merged in a pretty elegant way, as a trivial example if you were to define
    # `home.packages = [ foo ]` in another module it'd concatenate those lists, but much
    # more powerful interactions are possible (a shell util module could check if you've
    # got zsh enabled and turn on some optional setting only in that case, etc.).
    # Eventually this list could look like: ./nvim.nix ./graphical-environment.nix etc.
  ];

  # friends don't let friends use proprietary software, but just in case:
  nixpkgs.config.allowUnfree = true;
}
