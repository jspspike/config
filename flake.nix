{
  nixConfig = {
    extra-substituters = [
      "https://colmena.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";

    pineapple = {
      url = "github:p1n3appl3/config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        ragenix.follows = "";
      };
    };
  };

  outputs = { nixpkgs, home-manager, nixgl, self, ... } @ inputs:
    let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    home = hostModule: home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      inherit pkgs;
      modules = [ ./home-modules/common.nix hostModule ];
    };
    machine = system: module: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      inherit system;
      modules = [ module ];
    };
  in {
    homeConfigurations = {
      work = home ./hosts/work.nix;
    };

    nixosConfigurations = {
      desktop = machine "x86_64-linux" ./hosts/desktop;
      laptop = machine "x86_64-linux" ./hosts/laptop;
      media = machine "x86_64-linux" ./hosts/media;
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

