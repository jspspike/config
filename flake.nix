{
  description = "An example config";

  # These are the flakes that your config takes as an input, nixpkgs is of
  # course the big one, but any project that has a flake.nix can be added here which
  # gives you the ability to lock their version independently from the rest of nixpkgs.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # if you're curious about "follows", it's essentially making your transitive deps
    # use the same versions of things. The flake ecosystem is pretty young and they
    # don't have any sort of version resolver, so each flake just pins all its deps
    # to some hash and that would mean that every flake you use depends on a different
    # version of nixpkgs (as well as some other common flakes like flake-utils). Instead
    # we manually override the nixpkgs input of each of the flakes we depend on so at the
    # end of the day we end up with a single version used everywhere. You can see it in
    # action if you uncomment the above line and run `nix flake update`, then look at your
    # flake.lock, there will be a nixpkgs_1 and nixpkgs_2. It's not the end of the world
    # to use multiple versions of nixpkgs, but it can bog down evaluation time and increase
    # the amount of stuff you have to redownload or rebuild.

    # this one's a pre-populated index for easily looking up which (not currently installed)
    # packages have a certain file (like /bin/notify-send). While search.nixos.org is
    # usually the easiest thing, sometimes you'll want to run `nix-locate <some-path>` and
    # this will make it so you don't have to build an index for it yourself.
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";
    #nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/nixGL/issues/154
    pinnedNixpkgs.url = "github:nixos/nixpkgs/6df37dc6a77654682fe9f071c62b4242b5342e04";
  };

  outputs = { nixpkgs, home-manager, nixgl, pinnedNixpkgs, self, ... } @ inputs:
    let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    home = hostModule: home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs nvidiaPackages; };
      inherit pkgs;
      modules = [ ./home-modules/common.nix hostModule ];
    };
    machine = system: module: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      inherit system;
      modules = [ module ];
    };
    nvidiaPackages = import pinnedNixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [ nixgl.overlay ];
    };
  in {
    homeConfigurations = {
      work = home ./hosts/work.nix;
      laptop = home ./hosts/laptop.nix;
    };

    nixosConfigurations = {
      desktop = machine "x86_64-linux" ./hosts/desktop;
    };

    inherit pkgs;

    # If you find some program you want in your config and it's not in nixpkgs, it's
    # usually not too hard to follow the build instructions for it and create your own
    # little package. Maybe it's a little more effort than cargo install or git
    # clone+configure+make install but on the bright side it's pretty much guaranteed to
    # stay working whereas your unmanaged self-built binaries would be a pain to keep up
    # to date or move to a new machine. I used nix-init to stick some random stuff in
    # there as an example.
    packages.x86_64-linux = nixpkgs.lib.packagesFromDirectoryRecursive {
      callPackage = pkgs.callPackage; directory = ./pkgs;
    };
  };
}

