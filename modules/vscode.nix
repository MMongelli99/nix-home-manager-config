{ config, pkgs, ... }:
{
  programs.vscode = {
	  enable = true;
		extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode # format on save
      visualstudioexptteam.vscodeintellicode # AI assisted suggestions
			tim-koehler.helm-intellisense # type-inferenced suggestions
			jnoortheen.nix-ide # nix language support
			# b4dm4n.vscode-nixpkgs-fmt
			# brettm12345.nixfmt-vscode
			wholroyd.jinja
			mkhl.direnv
			# phind.phind
			# asvetliakov.vscode-neovim # loaded with errors about lua
			# vscodevim.vim # interfering with prettier and autosuggestions
		];
	};
}
