{
  # config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nvim.dag) entryAfter;
in {
  # make sure treesitter is enabled

  vim = {
    startPlugins = ["haskell-tools-nvim"];
    luaConfigRC.haskell-tools-nvim =
      entryAfter
      ["lsp-setup"]
      ''
        vim.g.haskell_tools = {
        -- LSP
          tools = {
            hover = {
              enable = true,
            },
          },
          hls = {
            cmd = {"${pkgs.haskellPackages.haskell-language-server}/bin/haskell-language-server", "--lsp"},
            on_attach = function(client, bufnr, ht)
              default_on_attach(client, bufnr, ht)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
              vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
              vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts)
              vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
              vim.keymap.set('n', '<leader>rf', function()
                ht.repl.toggle(vim.api.nvim_buf_get_name(0))
              end, opts)
              vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
            end,
          },
          dap = {
            cmd = {"${pkgs.haskellPackages.haskell-debug-adapter}/bin/haskell-debug-adapter"},
          },
        }
      '';
  };
}
