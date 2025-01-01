{
  description = "cl nix system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      mac-app-util,
    }:
    {
      darwinConfigurations.mac-mini = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            home-manager.verbose = true;
            home-manager.users.cl = import ./home.nix;
          }
        ];
      };
    };
}
