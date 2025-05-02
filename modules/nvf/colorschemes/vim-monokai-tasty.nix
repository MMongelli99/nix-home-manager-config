{pkgs, ...}: {
  vim.extraPlugins.vim-monokai-tasty = {
    package = pkgs.vimPlugins.vim-monokai-tasty;
    setup = ''
      vim.cmd.colorscheme("vim-monokai-tasty")

      -- transparent background
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
    '';
  };
}
