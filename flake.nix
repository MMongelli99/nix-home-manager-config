{
  description = "Home Manager configuration of michaelmongelli";

  inputs = {
    
    # Specify the source of Home Manager and Nixpkgs.

    nixpkgs-master.url     = "github:nixos/nixpkgs"; 
    nixpkgs-unstable.url   = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url     = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    }; 

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
