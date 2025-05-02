{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./lualine.nix
  ];

  vim = {
    extraPlugins = with pkgs.vimPlugins; {
      vscode-nvim = {
        package = vscode-nvim;
        setup = let
          # https://github.com/nix-community/nixvim/blob/main/plugins/colorschemes/vscode.nix
          settings = {
            transparent = true;
          };
        in ''
          local _vscode = require("vscode")
          _vscode.setup(${lib.nvim.lua.toLuaObject settings})
          _vscode.load()
        '';
      };
      # modicator-nvim = {
      #   package = modicator-nvim;
      #   setup = ''
      #     require('modicator').setup({
      #       -- Warn if any required option is missing. May emit false positives if some
      #       -- other plugin modifies them, which in that case you can just ignore
      #       show_warnings = false,
      #       highlights = {
      #         -- Default options for bold/italic
      #         defaults = {
      #           bold = false,
      #           italic = false,
      #         },
      #         -- Use `CursorLine`'s background color for `CursorLineNr`'s background
      #         use_cursorline_background = false
      #       },
      #       integration = {
      #         lualine = {
      #           enabled = true,
      #           -- Letter of lualine section to use (if `nil`, gets detected automatically)
      #           mode_section = nil,
      #           -- Whether to use lualine's mode highlight's foreground or background
      #           highlight = 'bg',
      #         },
      #       },
      #     })
      #     local marks_fix_group = vim.api.nvim_create_augroup('marks-fix-hl', {})
      #     vim.api.nvim_create_autocmd({ 'VimEnter' }, {
      #       group = marks_fix_group,
      #       callback = function()
      #         vim.api.nvim_set_hl(0, 'MarkSignNumHL', {})
      #       end,
      #     })
      #   '';
      # };
    };

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    telescope.enable = true;

    autocomplete.nvim-cmp.enable = true;

    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
      nvim-cursorline = {
        enable = true;
        setupOpts.cursorline = {
          enable = true;
          timeout = 0;
          number = false;
          cursorword = {
            enable = true;
            min_length = 3;
            hl.underline = true;
          };
        };
      };

      nvim-scrollbar = {
        enable = true;
        setupOpts = {
          throttle_ms = 0;
          handle = {
            blend = 75; # transparency %
            color = "#ffffff";
          };
          marks = {
            Cursor = {
              text = "◼";
              color = "#aaaaaa";
            };
          };
        };
      };
    };

    languages = {
      enableLSP = true;
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      lua.enable = true;
      ts.enable = true;
      python.enable = true;
      bash.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
    };
  };
}
