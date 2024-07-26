{ config, pkgs, inputs, ... }:

{ 
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # allowBroken = true;
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    neofetch
    tree
    eza
    iterm2
    tmux
    zsh-powerlevel10k
    meslo-lgs-nf
    ripgrep # needed for telescope.nvim
    warp-terminal
    neovide
    cached-nix-shell

    # TODO: to try in the future
    # virtualbox            # not available on MacOS
    # devbox                # wasn't a fan but might try again in the future
    # zed-editor            # broken package, how to allow it?
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".ghc/ghci.conf".text = ''
      -- multiline mode
      :set +m
      -- prompt for each line input
      :set prompt  "𝝺 ❯ "
      -- how to add color: https://wiki.haskell.org/GHCi_in_colour
      :set prompt "\ESC[35m\STX𝝺 ❯ \ESC[m\STX"
      -- prompt for each line of multiline input
      :set prompt-cont "... "
      -- add color to multiline continuation
      :set prompt-cont "\ESC[35m\STX... \ESC[m\STX" 
    '';
  };

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
  
  # home.sessionVariables = {
  #   EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nixvim = {
    enable       = true;
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;

    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2;        # Tab width should be 2
    };
     
    # Nixvim modules colorschemes: https://github.com/nix-community/nixvim/tree/main/plugins/colorschemes
    # colorschemes.vscode.enable = true;

    plugins = {

      # navic = {
      #   enable = true;
      #   lsp.autoAttach = true;
      # }; 

      # neoscroll = {
      #   enable = true;
      #   settings.easing_function = "linear";
      # };

      lualine = {
        enable = true;
	theme = "auto";
	# sectionSeparators = {
        #   left = "";
        #   right = "";
        # };
        # componentSeparators = {
        #   left = "";
        #   right = "";
        # };
      };

      bufferline.enable = true;

      diffview.enable = true;
      
      codeium-vim.enable = true;

      neo-tree = {
	enable = true;
	window.width = 30;
	closeIfLastWindow = true;
	extraOptions = {
	  filesystem = {
	    filtered_items = {
	      visible = true;
	    };
	  };
	};
      };

      /* fzf-lua = {
	enable = true; 
	keymaps = {
	  "<leader>ff" = "find_files";
	  "<leader>fg" = "live_grep";
	  "<leader>fb" = "buffers";
	  "<leader>fh" = "help";
	};
      }; */

      telescope = {
        enable = true;
        settings = {
          pickers.find_files = {
            hidden = true;
          };
        };
        keymaps = {
	  "<leader>fs" = {
	    action = "grep_string";
	    options = {
	      desc = "Find String";
	    };
	  };
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Find File";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Find Via Grep";
            };
          };
          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Find Buffers";
            };
          };
          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Find Help";
            };
          };
        };
      };

      noice = {
	enable = true;
	notify = {
	  enabled = false;
	};
	messages = {
	  enabled = true; # Adds a padding-bottom to neovim statusline when set to false for some reason
	};
	lsp = {
	  message = {
	    enabled = true;
	  };
	  progress = {
	    enabled = false;
	    view = "mini";
	  };
	};
	popupmenu = {
	  enabled = true;
	  backend = "nui";
	};
	format = {
	  filter = {
	    pattern = [ ":%s*%%s*s:%s*" ":%s*%%s*s!%s*" ":%s*%%s*s/%s*" "%s*s:%s*" ":%s*s!%s*" ":%s*s/%s*" ];
	    icon = "";
	    lang = "regex";
	  };
	  replace = {
	    pattern = [
	      ":%s*%%s*s:%w*:%s*"
	      ":%s*%%s*s!%w*!%s*"
	      ":%s*%%s*s/%w*/%s*"
	      "%s*s:%w*:%s*"
	      ":%s*s!%w*!%s*"
	      ":%s*s/%w*/%s*"
	    ];
	    icon = "󱞪";
	    lang = "regex";
	  };
	};
      };

      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          # diagnostic = {
          #   # Navigate in diagnostics
          #   "<leader>k" = "goto_prev";
          #   "<leader>j" = "goto_next";
          # };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            # K = "hover";
            # "<F2>" = "rename";
          };
        };

	# Nixvim LSP modules: https://github.com/nix-community/nixvim/blob/a5e9dbdef1530a76056db12387d489a68eea6f80/plugins/lsp/language-servers/default.nix#L57
        servers = {
	  pylsp.enable       = true; # Python
	  nil-ls.enable      = true; # Nix
	  bashls.enable      = true; # Bash
	  html.enable        = true; # HTML
	  cssls.enable       = true; # CSS
	  tailwindcss.enable = true; # TailwindCSS
	  jsonls.enable      = true; # JSON
	  htmx.enable        = true; # HTMX
	  sqls.enable        = true; # SQL
	  lua-ls.enable      = true; # Lua
	  marksman.enable    = true; # Markdown
	  hls.enable         = true; # Haskell
        };
      };

    };
    
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
    ];

    # See NixVim GitHub - nixvim/docs/user-guide/faq.md
    # This is straightforward too, you can add the following to `extraPlugins` for a plugin hosted on GitHub:
    # (pkgs.vimUtils.buildVimPlugin {
    #   name = "my-plugin";			# plugin name
    #   version = "<version>";  		# plugin version (optional)
    #   src = pkgs.fetchFromGitHub {
    #     owner = "<owner>";         		# username of repo owner
    #     repo  = "<repo>";          		# name of repo
    #     rev   = "<commit hash>";   		# full SHA hash of commit
    #     hash  = "<nix NAR hash>";             # run `nix-prefetch-url --unpack <url for zip file of repo at specified commit>`
    #   };
    #   meta.homepage = "<URL for docs/repo>";  # link to project docs / GitHub repo (optional)
    # })
    
    # nixpkgs vim plugins: https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/applications/editors/vim/plugins/generated.nix
    extraPlugins = with pkgs.vimPlugins; [ 

      neo-tree-nvim
      nvim-notify
      markview-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-scrollbar";
	version = "2024-06-03";
        src = pkgs.fetchFromGitHub {
          owner   = "petertriho";
          repo    = "nvim-scrollbar";
          rev     = "d09f14aa16c9f2748e77008f9da7b1f76e4e7b85";
          sha256  = "1zm0xaph29hk2dw4rpmpz67nxxbr39f67zfil5gwyzk3d87q56k3";
        };
	meta.homepage = "https://github.com/petertriho/nvim-scrollbar/";
      })

      # colorschemes #

      pure-lua          # moonlight
      vim-code-dark     # codedark
      vim-monokai-tasty # vim-monokai-tasty
      poimandres-nvim   # poimandres 
      (pkgs.vimUtils.buildVimPlugin {
        name = "vague.nvim";
	version = "1.2.0";
        src = pkgs.fetchFromGitHub {
          owner   = "vague2k";
          repo    = "vague.nvim";
          rev     = "8ebe3010d04bebdfd60d920d652996e360a79f33";
          sha256  = "180crxd8k68hl6bycsd4c2aawbvpvnlxj8pkyprama9qpn1hginq";
        };
	meta.homepage = "https://github.com/vague2k/vague.nvim/";
      }) # vague

    ];

    colorscheme = "vim-monokai-tasty";  

    extraConfigLua = ''
      require("scrollbar").setup({
        throttle_ms = 0,
	handle = {
	    blend = 75, -- transparency %
	    color = "#ffffff",
	},
        marks = {
	  Cursor = {
	    text = " ",
	    -- text = "◼",
	    -- color = "#aaaaaa",
	  },
	},
      })
    '';
     
  };
  
  # basically copy the whole nvchad that is fetched from github to ~/.config/nvim
  # xdg.configFile."nvim/" = {
  #   source = (pkgs.callPackage ./nvchad/default.nix{}).nvchad;
  # };

  programs.zsh = {
    
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      switch   = "home-manager switch";
      git-tree = "git log --graph --decorate --oneline $(git rev-list -g --all)";
    };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "git" "systemd" "rsync" "kubectl" ];
    #   theme = "terminalparty";
    # }; 
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh
    ''; 

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
