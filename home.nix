{
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  inputs,
  config,
  ...
}:
let
  systemSpecificPackages = {
    aarch64-darwin = with pkgs; [
      iterm2
      arc-browser
    ];
  };
  p10k-config-file = /Users/michaelmongelli/.config/home-manager/dotfiles/.p10k.zsh;
in
rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      allowBroken = true; # allow hell
      permittedInsecurePackages = [
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
      ];
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./modules/nixvim.nix
    ./modules/vscode.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "michaelmongelli";
  home.homeDirectory = "/Users/michaelmongelli";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      ## cli tools ##
      # neofetch # RIP
      trash-cli
      eza # used in custom zsh function `lt`
      bat
      ripgrep # needed for telescope.nvim
      # tmux
      zsh-powerlevel10k
      nixfmt-rfc-style
      nix-tree
      nix-output-monitor # <nix command> |& nom # shows build process with some style, used in `switch` shell alias
      # cached-nix-shell
      ollama
      htop
      nixd
      # devenv
      # wakatime
      # imagemagick # convert image formats on the command line
      # sqlite-web # view SQLite database in web browser
      # open-webui
      # devenv
      # cachix

      ## window management ##
      # yabai
      # skhd

      ## applications ##

      kitty
      sqlitebrowser
      # emacs # emacsMacport
      utm
      cinny-desktop
      obsidian
      spotify
      # teams
      discord
      # ungoogled-chromium
      # kicad
      # code-cursor # not available on MacOS
      # zed-editor # broken package
      # darwin.xcode
      # element-desktop
      # ladybird
      # zen-browser
      # thunderbird
      # nyxt

      ## languages ##

      # haskellPackages.hell
      # rustc
      # rustup
      # cargo # included in rustup
      python312Packages.python
      python312Packages.pip
      # ghc
      # nodejs_22
      # nodePackages.ts-node
      deno
      # nodemon

      ## fonts ##

      meslo-lgs-nf

      # TODO: to try in the future
      # virtualbox            # not available on MacOS
      # devbox                # wasn't a fan but might try again in the future
      # haskellPackages.hell  # broken package, debug it?

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
		++ (with pkgs-stable; [ wireshark ])
    ++ systemSpecificPackages.${system};

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file =
    let
		  dotfilesDirectory = "${config.home.homeDirectory}/.config/home-manager/dotfiles";

      # Ensure each config file is present at its source path specified below.
      # Home Manager will create/update the file in your home directory upon `home-manager switch`.

			nixStoreDotfiles =
        [
          # ".config/kitty/"
          # ".ghc/ghci.conf"
          # ".tmux.conf"
          # ".config/skhd/skhdrc"
          # ".config/yabai/yabairc"
        ]
        |> map (dotfile: {
          name = dotfile;
          value = {
            source = ./dotfiles/${dotfile};
            recursive = true;
            onChange = "echo 'Changes detected in dotfile ${dotfile}'";
          };
        })
        |> builtins.listToAttrs;

      outOfStoreDotfiles =
				[
					".p10k.zsh"
          ".config/kitty/"
				]
				|> map (dotfile: {
				  name = dotfile;
					value = {
					  source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/${dotfile}";
					};
				})
				|> builtins.listToAttrs;
			# {
			# 	".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink p10k-config-file;
			# 	".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink /Users/michaelmongelli/.config/home-manager/dotfiles/.config/kitty/kitty.conf;
				# ".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${home.homeDirectory}/.config/home-manager/dotfiles/.config/zed/settings.json";
      # };
    in
      nixStoreDotfiles // outOfStoreDotfiles;

  /*
    let
      p10k = ".p10k.zsh";
      ghci = ".ghc/ghci.conf";
    in {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      ${p10k}.source = ./dotfiles/${p10k};
      ${ghci}.source = ./dotfiles/${ghci};
    };
  */

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/michaelmongelli/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = "nvim";
    POWERLEVEL9K_CONFIG_FILE = p10k-config-file;
	};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # silent = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
    # stdlib = ''
    #   echo "activating direnv"
    # '';
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      "theme" = "VScode Dark Plus";
      "format_on_save" = "on";
      "ui_font_family" = "Inconsolata";
      "buffer_font_family" = "FiraCode Nerd Font";
      "tab_size" = 2;
      "ui_font_size" = 16;
      "buffer_font_size" = 16;
      "load_direnv" = "direct";
      "vim_mode" = true;
    };
    extensions = [
      "nix"
      "Catppuccin Blur"
    ];
    extraPackages = [ pkgs.nixd ];
  };

  # programs.neovide = {
  #   enable = true;
  #   # empty attrset needs to be supplied for default settings
  # 	settings = {};
  # 	/* settings = {
  # 		fork = false;
  # 		frame = "full";
  # 		idle = true;
  # 		maximized = false;
  # 		no-multigrid = false;
  # 		srgb = false;
  # 		tabs = true;
  # 		theme = "auto";
  # 		title-hidden = true;
  #
  # 		font = {
  # 			normal = [];
  # 			size = 14.0;
  # 		};
  #   }; */
  # };

  programs.fastfetch.enable = true;

  # programs.fish.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;

    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo" # double tap ESC to rerun a command with sudo
        # "copypath" # copy current working directory to clipboard with ^O
        "copyfile" # copy contents of file to clipboard
        # "copybuffer" # copy command line buffer to clipboard
        "magic-enter" # execute `git status` when hitting ENTER in a git repo
      ];
      # theme = "wezm";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra =	''
			# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
			# Idk how but `p10k configure` does modify the home-manager p10k dotfile
			# even thouhg POWERLEVEL9K_CONFIG_FILE is not set because `source ~/.p10k.zsh` after hm-session-vars.sh
			# source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
			source ~/.p10k.zsh

			# ohmyzsh magic-enter config
			MAGIC_ENTER_GIT_COMMAND='git status'
			MAGIC_ENTER_OTHER_COMMAND='eza -a'

			## custom utility functions ##

			list-tree () {
				if [[ "''${1-1}" =~ "[0-9]+" ]]; then   # if first arg is a number
					eza --tree --level ''${1-1} ''${@:2}  # then treat it as level and include rest of args
				else                                    # if arg is anything else
					eza --tree --level 1 $@               # then run args with default level
				fi
			}

			search-git-log () {
				 git log --diff-filter=A -- ''${$1}
			}
		'';

    shellAliases = {
      "sw" = "home-manager switch |& nom && exec $SHELL"; # make sure nix-output-monitor is installed for `nom`
      "home" = "nvim ~/.config/home-manager/home.nix";
      "flake" = "nvim ~/.config/home-manager/flake.nix";
      "gt" = "git log --graph --decorate --oneline $(git rev-list -g --all)"; # git tree
      "git-count-lines" = "git ls-files | xargs wc -l";
      # "git-log-search" = "search-git-log";
      "lt" = "list-tree"; # defined in initExtra
      "nix-shell-init" = "curl -O https://gist.githubusercontent.com/MMongelli99/af848753e3445e35534932c44e1cb9e7/raw/ef8dd127fec5a2e7bc5eed61e9a35d768b18010e/shell.nix";
      "devenv-init" = "curl -O https://gist.githubusercontent.com/MMongelli99/b2cd34eacfe3ef0f8fd6439afa8c38e3/raw/3716f3324b74083dcfa4c2e2fee29c12956a63be/flake.nix";
      "ai" = "ollama serve & ollama run llama3.1";
      "ip" = "ipconfig getifaddr en0";
      "Wireshark" = "sudo '${home.homeDirectory}/Applications/Home Manager Apps/Wireshark.app/Contents/MacOS/Wireshark'";
    };

  };

  programs.git = {
    enable = true;
    userName = "Michael Mongelli";
    userEmail = "mmongelli99@gmail.com";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

}
