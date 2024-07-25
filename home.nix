{ config, pkgs, inputs, ... }:

{ 
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
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

    ghc
    warp-terminal
    neovide

    # cached-nix-shell # not supported on MacOS

    # haskellPackages.hell


    # TODO: to try in the future
    # virtualbox  # not available on MacOS
    # cached-nix-shell  # only avaialble on NixOS and Linux
    # devbox  # wasn't a fan but might try again in the future
    # zed-editor  # broken package, how to allow it?

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
      # relativenumber = true; # Show relative line numbers

      shiftwidth = 2;        # Tab width should be 2
    };
     
    # Nixvim modules colorschemes: https://github.com/nix-community/nixvim/tree/main/plugins/colorschemes
    # colorschemes.vscode.enable = true;
    # plugins.lightline.enable = true;

    plugins = {

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

      telescope = {
        enable = true;
        settings = {
          pickers.find_files = {
            hidden = true;
          };
        };
        keymaps = {
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
    
    # vimPlugin colorschemes: https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/applications/editors/vim/plugins/generated.nix
    extraPlugins = with pkgs.vimPlugins; [ 
      neo-tree-nvim
      nvim-notify
      # colorschemes
      pure-lua          # moonlight
      vim-code-dark     # codedark
      vim-monokai-tasty # vim-monokai-tasty
    ];
    colorscheme = "vim-monokai-tasty"; 
    plugins.lightline.enable = false; # lightline only inherits colorschemes from Nixvim modules

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

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh
    '';
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    shellAliases = {
      # executing iTerm2 from command line has problems when using Nix's default iTerm2 path
      iTerm2 = "exec ~/Applications/Home Manager Apps/iTerm2.app/Contents/MacOS/iTerm2";
    };
  };

}
