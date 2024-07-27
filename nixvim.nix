{ config, pkgs, ... }: 

{
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
     
    # Nixvim colorscheme modules: https://github.com/nix-community/nixvim/tree/main/plugins/colorschemes
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

}
