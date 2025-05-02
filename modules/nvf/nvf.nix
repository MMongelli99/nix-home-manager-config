{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./plugins/lualine.nix
    ./colorschemes/vim-monokai-tasty.nix
  ];

  vim = {
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
