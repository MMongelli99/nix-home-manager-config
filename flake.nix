{
  description = "Home Manager configuration of michaelmongelli";

  inputs = {
    # nixpkgs-master.url = "github:nixos/nixpkgs";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim.url = "github:nix-community/nixvim";

    # mac-app-util.url = "github:hraban/mac-app-util";

    nvf.url = "github:notashelf/nvf";

    # nix-index-database = {
    #   url = "github:nix-community/nix-index-database";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-2505,
    home-manager,
    nvf,
    # nix-index-database,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    pkgs-2505 = nixpkgs-2505.legacyPackages.${system};
    customNeovim = nvf.lib.neovimConfiguration {
      pkgs = pkgs-2505;
      # extraSpecialArgs = {inherit pkgs-2505;};
      modules = [
        ./modules/neovim/neovim.nix
      ];
    };
    # overlay so I can get most Zed editor from unstable without updating all my flake inputs
    # overlay = final: prev: {
    #   zed-editor = inputs.nixpkgs-unstable.legacyPackages.${system}.zed-editor;
    # };
    # nixpkgsWithOverlay = import nixpkgs { inherit system; overlays = [overlay]; };
    # pkgs = nixpkgsWithOverlay;
  in {
    packages.${system}.neovim = customNeovim.neovim;

    homeConfigurations."michaelmongelli" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        # nix-index-database.hmModules.nix-index
        # {programs.nix-index-database.comma.enable = true;}
      ];

      # Optionally use extraSpecialArgs to pass arguments through to home.nix
      extraSpecialArgs = {inherit pkgs-stable inputs outputs nixpkgs customNeovim;};
    };
  };
}
