{ config, pkgs, ... }:
{
  programs.vscode = {
	  enable = true;
		extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode # format on save
      visualstudioexptteam.vscodeintellicode # AI assisted suggestions
			tim-koehler.helm-intellisense # type-inferenced suggestions
			jnoortheen.nix-ide # nix language support
			mkhl.direnv
			# b4dm4n.vscode-nixpkgs-fmt
			# brettm12345.nixfmt-vscode

			# Python
			wholroyd.jinja # jinja syntax highlighting
			ms-python.python # python language support, intellisense, linting, etc.
			ms-python.vscode-pylance # needed for Intellicode
			matangover.mypy # cross-file type checking, `pip install dmypy-ls` with this extension
			# phind.phind
			asvetliakov.vscode-neovim # loaded with errors about lua
			# vscodevim.vim # interfering with prettier and autosuggestions

			waderyan.gitblame

			ms-vscode-remote.remote-ssh
			ms-vscode-remote.remote-ssh-edit

			nonylene.dark-molokai-theme

			tamasfe.even-better-toml

			# wakatime.vscode-wakatime
		];
	};
}
