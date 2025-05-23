{pkgs, ...}: {
  vim.extraPlugins.monokai-nightasty = {
    package = pkgs.vimUtils.buildVimPlugin {
      name = "monokai-nightasty-nvim";
      version = "2025-04-03";
      src = pkgs.fetchFromGitHub {
        owner = "polirritmico";
        repo = "monokai-nightasty.nvim";
        rev = "8182c45dcaf82e7316cfda6d439ee8ad783ae594";
        sha256 = "9t8STF2h1arOFf7Bi0rFeVi8sOELviBlTY+lUzJOFFY=";
      };
      meta.homepage = "https://github.com/polirritmico/monokai-nightasty.nvim";
    };
    setup = ''
      vim.opt.background = "dark" -- light or dark
      require("monokai-nightasty").load()

      -- transparent background
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
    '';
  };
}
