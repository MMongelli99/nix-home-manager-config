{ config, pkgs, ... }:

{

  # basically copy the whole nvchad that is fetched from github to ~/.config/nvim
  # xdg.configFile."nvim/" = {
  #   source = (pkgs.callPackage ./nvchad/default.nix{}).nvchad;
  # };

  programs.nixvim = {
    enable = true;
    # viAlias = true;
    # vimAlias = true;
    # vimdiffAlias = true;

		# defaultEditor = true;

    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2; # Tab width should be 2
    };

    # Nixvim colorscheme modules: https://github.com/nix-community/nixvim/tree/main/plugins/colorschemes
    colorschemes.vscode = {
      enable = true;
      settings.transparent = true;
    };

    # Set colorscheme from extraPlugins
    # colorscheme = "vague";

    plugins = {

      # navic = {
      #   enable = true;
      #   lsp.autoAttach = true;
      # };

      # neoscroll = {
      #   enable = true;
      #   settings.easing_function = "linear";
      # };

			blink-cmp.enable = true;

			web-devicons.enable = true;

      lualine = {
        enable = true;
        # all the lualine config below is just to get rid
				# of that damn white triangle next to the filename
        settings = {
					options = {
					  theme = "auto";
						section_separators = {
							left = ""; # "";
							right = ""; # "";
						};
						component_separators = {
							left = "";
							right = "";
					  };
					};

					sections = {
						lualine_a = [
							{
								__unkeyed-1 = "mode";
								separator.right = "";
								padding = { left = 2; right = 2; };
							}
						];
						lualine_c = [
							# you can specify only the sections you want to change
							{
								__unkeyed-1 = "filename";
								newfile_status = true;
								separator = {
									left = "";
									right = "";
								};
							}
						];
						lualine_z = [
							{
								__unkeyed-1 = "location";
								separator.left = "";
								padding = {
									left = 2;
									right = 2;
								};
							}
							# { __unkeyed-1 = "%L"; } # total lines
						];
					};
				};
      };

      bufferline = {
				enable = true;
				settings.options = {
				  numbers = "ordinal";
					# indicator.style = "underline"; # not working, might be a Kitty thing
				};
			};

      diffview.enable = true;

      # codeium-vim.enable = true;

      neo-tree = {
        enable = true;
        window.width = 30;
        window.position = "right";
        closeIfLastWindow = true;
        extraOptions = {
          filesystem = {
            filtered_items = {
              visible = true;
            };
          };
        };
      };

      /*
        fzf-lua = {
        	enable = true;
        	keymaps = {
        	  "<leader>ff" = "find_files";
        	  "<leader>fg" = "live_grep";
        	  "<leader>fb" = "buffers";
        	  "<leader>fh" = "help";
        	};
              };
      */

      harpoon = {
        enable = true;
        keymaps.addFile = "<leader>a";
      };

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
        settings.notify = {
          enabled = false;
        };
        settings.messages = {
          enabled = true; # Adds a padding-bottom to neovim statusline when set to false for some reason
        };
        settings.lsp = {
          message = {
            enabled = true;
          };
          progress = {
            enabled = false;
            view = "mini";
          };
        };
        settings.popupmenu = {
          enabled = true;
          backend = "nui";
        };
        settings.format = {
          filter = {
            pattern = [
              ":%s*%%s*s:%s*"
              ":%s*%%s*s!%s*"
              ":%s*%%s*s/%s*"
              "%s*s:%s*"
              ":%s*s!%s*"
              ":%s*s/%s*"
            ];
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
            K = "hover";
            # "<F2>" = "rename";
          };
        };

        # Nixvim LSP modules: https://github.com/nix-community/nixvim/blob/a5e9dbdef1530a76056db12387d489a68eea6f80/plugins/lsp/language-servers/default.nix#L57
        servers = {
          pylsp.enable = true; # Python
          nil_ls.enable = true; # Nix
					# nixd.enable = true;
          bashls.enable = true; # Bash
          html.enable = true; # HTML
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
					tsserver.enable = true; # TypeScript
          jsonls.enable = true; # JSON
          htmx.enable = true; # HTMX
          sqls.enable = true; # SQL
          lua_ls.enable = true; # Lua
          marksman.enable = true; # Markdown
          # hls.enable = true; # Haskell
        };
      };

    };

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
      render-markdown-nvim
      markdown-preview-nvim
      # indent-blankline-nvim
			direnv-vim
      # vim-sneak
			# vim-wakatime
      # headlines-nvim
      # markview-nvim
      # statix
      # ollama-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-scrollbar";
        version = "2024-06-03";
        src = pkgs.fetchFromGitHub {
          owner = "petertriho";
          repo = "nvim-scrollbar";
          rev = "d09f14aa16c9f2748e77008f9da7b1f76e4e7b85";
          sha256 = "1zm0xaph29hk2dw4rpmpz67nxxbr39f67zfil5gwyzk3d87q56k3";
        };
        meta.homepage = "https://github.com/petertriho/nvim-scrollbar/";
      })
			# (pkgs.vimUtils.buildVimPlugin {
      #   name = "smear-cursor.nvim";
			# 	version = "2024-11-25";
			# 	src = pkgs.fetchFromGitHub {
      #     owner = "sphamba";
			# 		repo = "smear-cursor.nvim";
			# 		rev = "d0a3aaeb7cd4ad4ead50c6d95fa48216364255e0";
			# 		sha256 = "192jjjwnl4s6cpz69zqd4iz6d1dwd30bv8ig524dpg6afr8gnm8s";
			# 	};
			# 	meta.homepage = "https://github.com/sphamba/smear-cursor.nvim";
			# })
			(pkgs.vimUtils.buildVimPlugin {
				name = "modicator.nvim";
				version = "2024-10-21";
				src = pkgs.fetchFromGitHub {
					owner = "mawkler";
					repo = "modicator.nvim";
					rev = "e349636d905e03305f1eda9c081e63560598f118";
					sha256 = "mmO0IYe02tYXm2cT0PT6u5Aa+3GDCidQ8YW75oXOPwQ=";
				};
				meta.homepage = "https://neovimcraft.com/plugin/mawkler/modicator.nvim/";
			})
			(pkgs.vimUtils.buildVimPlugin {
			  name = "let-it-snow.nvim";
				version = "2024-12-04";
				src = pkgs.fetchFromGitHub {
				  owner = "marcussimonsen";
					repo = "let-it-snow.nvim";
					rev = "7ff767f7b6e787989ca73ebcdcd0dd5ea483811a";
					sha256 = "w8bNUclsaQg/fwzFLfNM4WXZwb6efnLaUYasbIxjElY=";
				};
			})
			(pkgs.vimUtils.buildVimPlugin {
				pname = "vim-prisma";
				version = "2023-01-24";
				src = pkgs.fetchFromGitHub {
					owner = "prisma";
					repo = "vim-prisma";
					rev = "95c5b25066efb34c75bce78698baa371fe0ee7c2";
					sha256 = "046lpazz44f6b1lcvklaq1jl0sbyiklj6kcv580rrff89511nzsy";
				};
				meta.homepage = "https://github.com/prisma/vim-prisma/";
			})
			(pkgs.vimUtils.buildVimPlugin {
        pname = "rainbow_csv.nvim";
				version = "2024-07-08";
				src = pkgs.fetchFromGitHub {
				  owner = "cameron-wags";
					repo = "rainbow_csv.nvim";
					rev = "7f3fddfe813641035fac2cdf94c2ff69bb0bf0b9";
					sha256 = "/XHQd/+sqhVeeMAkcKNvFDKFuFecChrgp56op3KQAhs=";
				};
			})
			(pkgs.vimUtils.buildVimPlugin {
			  pname = "animatedbg.nvim";
				version = "2024-12-27";
				src = pkgs.fetchFromGitHub {
					owner = "alanfortlink";
					repo = "animatedbg.nvim";
					rev = "5d093d681e157250db6dc808aeb9081775120ddb";
					sha256 = "0rbdpKO8IOMxTTQa5XriCamZhm8JNSPSqUZSwenjnT4=";
				};
			})
			(pkgs.vimUtils.buildVimPlugin {
				pname = "beepboop.nvim";
				version = "2025-01-06";
				src = pkgs.fetchFromGitHub {
					owner = "EggbertFluffle";
					repo = "beepboop.nvim";
					rev = "9a7fbb722526d6a73161ef11aaeb13207437ec17";
					sha256 = "0yjhyqlafsnzs3wq27ypdm9121bwfda8cplz2yr4299rvch9ib9l";
				};
			})

      # colorschemes #

      pure-lua # moonlight
      vim-code-dark # codedark
      vim-monokai-tasty # vim-monokai-tasty
      poimandres-nvim # poimandres
      # vague
      (pkgs.vimUtils.buildVimPlugin {
        name = "vague.nvim";
        version = "1.2.0";
        src = pkgs.fetchFromGitHub {
          owner = "vague2k";
          repo = "vague.nvim";
          rev = "8ebe3010d04bebdfd60d920d652996e360a79f33";
          sha256 = "180crxd8k68hl6bycsd4c2aawbvpvnlxj8pkyprama9qpn1hginq";
        };
        meta.homepage = "https://github.com/vague2k/vague.nvim/";
      })
      # catppuccin
      (pkgs.vimUtils.buildVimPlugin {
        name = "primeppuccin";
        src = pkgs.fetchFromGitHub {
          owner = "DanWlker";
          repo = "primeppuccin";
          rev = "dd28a21d83f8088074a66d66ae6508567b79a65a";
          sha256 = "0aawd7vichvlsp7zw4h7vcm5dvs65bdkp4pnx0was9rz9i7lbdqf";
        };
        meta.homepage = "https://github.com/DanWlker/primeppuccin.git";
      })
      # ashen
      (pkgs.vimUtils.buildVimPlugin {
      	name = "ashen.nvim";
	      src = pkgs.fetchFromGitHub {
		      owner = "ficcdaf";
		      repo = "ashen.nvim";
		      rev = "b0ddf13ff5fcc20f3c78aaf7a28e68b3923224e2";
		      sha256 = "1kx7zqs89ri80627arzyjkbcbc4grp18fk2dhy5a8achyjq0kvnj";
	      };
	      meta.homepage = "https://github.com/ficcdaf/ashen.nvim";
      })
			# neofusion
			(pkgs.vimUtils.buildVimPlugin {
			  name = "neofusion.nvim";
			  version = "2024-12-23";
			  src = pkgs.fetchFromGitHub {
			    owner = "diegoulloao";
			    repo  = "neofusion.nvim";
			    rev   = "82267203b44ec5c54291dc9bd3a0ef9faba05638";
			    sha256 = "0s6vwgypgfxria1p5h5kmidgnriazjssvxy6jj2q3qiy1m2a944w";
			  };
			  meta.homepage = "https://github.com/diegoulloao/neofusion.nvim";
			})
    ];

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

    highlight.ExtraWhitespace.bg = "red";
    match.extraWhitespace = "\\s\\+$";

    autoCmd = [
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2";
      }
    ];

		# extraConfigVim = ''
    #   " mark col 80 with vertical line
		# 	highlight ColorColumn ctermbg=gray
    #   set colorcolumn=80
		# '';

    extraConfigLua = ''
      -- transparent background for all themes --
		  -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
      -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
      -- vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'NONE' })
      -- vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })

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

      -- nvim-notify --
      require("notify").setup({
        background_colour = "#000000",
      })

      -- indent-blankline.nvim --
      -- require("ibl").setup()

      -- markdown-preview.nvim --
      --[[
      use({
      	"iamcco/markdown-preview.nvim",
      	run = function() vim.fn["mkdp#util#install"]() end,
      })
      use({
      	"iamcco/markdown-preview.nvim",
      	run = "cd app && npm install",
      	setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
      	ft = { "markdown" },
      })
      --]]

      -- smear-cursor.nvim --
      -- require('smear_cursor').setup()

      -- modicator.nvim --
      require('modicator').setup()
      vim.o.termguicolors = true
      vim.o.cursorline = true
			vim.cmd("highlight CursorLine guibg=NONE ctermbg=NONE") -- transparent cursor line
      vim.o.number = true

      -- let-it-snow.nvim --
      require("let-it-snow").setup({
        snowflake_char = "\u{F313}",
      })
      -- require("let-it-snow").let_it_snow()

      -- rainbow_csv.nvim --
      require("rainbow_csv").setup()

      -- animatedbg.nvim --
      local animatedbg = require("animatedbg-nvim")
      animatedbg.setup()
      animatedbg.play({ animation = "matrix" })

      -- beepboop.nvim --
      require("beepboop").setup()

      if vim.g.neovide then
        -- Put anything you want to happen only in Neovide here

      	-- Helper function for transparency formatting
      	local alpha = function()
      		return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
      	end
      	-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
      	vim.g.neovide_transparency = 0.0
      	vim.g.transparency = 0.8
      	vim.g.neovide_background_color = "#0f1117" .. alpha()

        vim.g.neovide_window_blurred = true
      	  vim.g.neovide_floating_blur_amount_x = 2.0
        vim.g.neovide_floating_blur_amount_y = 2.0
      end
    '';

  };
}
