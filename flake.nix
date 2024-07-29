{
  description = "Home Manager configuration of michaelmongelli";

  inputs = {
    
    # nixpkgs-master.url   = "github:nixos/nixpkgs"; 
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url   = "github:nixos/nixpkgs/nixos-24.05";

    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url       = "github:nix-community/nixvim";
    # mac-app-util.url = "github:hraban/mac-app-util";

  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (self) outputs;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."michaelmongelli" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
	  ./home.nix 
	];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
	extraSpecialArgs = { inherit inputs outputs nixpkgs; };
      };
    };
}
