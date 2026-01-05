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

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixgl, self, ragenix, ... } @ inputs:
    let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    home = hostModule: home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      inherit pkgs;
      modules = [ ./home-modules/common.nix hostModule ragenix.homeManagerModules.default ];
    };
    machine = system: module: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      inherit system;
      modules = [ module ragenix.nixosModules.default ];
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

    packages.x86_64-linux = nixpkgs.lib.packagesFromDirectoryRecursive {
      callPackage = pkgs.callPackage; directory = ./pkgs;
    };
  };
}

