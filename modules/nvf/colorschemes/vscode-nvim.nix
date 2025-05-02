{
  pkgs,
  lib,
  ...
}: {
  vim.extraPlugins.vscode-nvim = {
    package = pkgs.vimPlugins.vscode-nvim;
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
}
