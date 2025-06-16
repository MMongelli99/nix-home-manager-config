{pkgs, ...}: {
  vim.extraPlugins.modicator-nvim = {
    package = pkgs.vimPlugins.modicator-nvim;
    setup = ''
      require('modicator').setup({
        -- Warn if any required option is missing. May emit false positives if some
        -- other plugin modifies them, which in that case you can just ignore
        show_warnings = false,
        highlights = {
          -- Default options for bold/italic
          defaults = {
            bold = false,
            italic = false,
          },
          -- Use `CursorLine`'s background color for `CursorLineNr`'s background
          use_cursorline_background = false
        },
        integration = {
          lualine = {
            enabled = true,
            -- Letter of lualine section to use (if `nil`, gets detected automatically)
            mode_section = nil,
            -- Whether to use lualine's mode highlight's foreground or background
            highlight = 'bg',
          },
        },
      })
      local marks_fix_group = vim.api.nvim_create_augroup('marks-fix-hl', {})
      vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        group = marks_fix_group,
        callback = function()
          vim.api.nvim_set_hl(0, 'MarkSignNumHL', {})
        end,
      })
    '';
  };
}
