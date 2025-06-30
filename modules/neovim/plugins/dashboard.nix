{lib, ...}: {
  vim.dashboard.alpha = {
    enable = true;
    theme = null; # manually set to null to customize dashboard config through layout
    opts = {margin = 5;};
    layout = let
      header = {
        type = "text";
        val =
          lib.strings.splitString "\n"
          ''
                                           __
              ___     ___    ___   __  __ /\_\    ___ ___
             / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
            /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
            \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
             \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
          '';
        opts = {
          position = "center";
          hl = "Type";
          # wrap = "overflow";
        };
      };
      buttons = {
        type = "group";
        val = [
          {
            type = "text";
            val = "Quick links";
            opts = {
              hl = "SpecialComment";
              position = "center";
            };
          }
          {
            type = "padding";
            val = 1;
          }
          # dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        ];
      };
      section_mru = {
        type = "group";
        val = [
          [
            {
              type = "text";
              val = "Recent Files";
              opts = {
                hl = "SpecialComment";
                shrink_margin = false;
                position = "center";
              };
            }
            {
              type = "padding";
              val = 1;
            }
            {
              type = "group";
              val = lib.generators.mkLuaInline ''
                function()
                  local utils = require("alpha.utils")
                  local path_ok, plenary_path = pcall(require, "plenary.path")
                  if not path_ok then return end

                  local dashboard = require("alpha.themes.dashboard")
                  local if_nil = vim.F.if_nil

                  local file_icons = {
                    enabled = true,
                    highlight = true,
                    provider = "mini",
                  }

                  local function icon(fn)
                    if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
                      vim.notify("Alpha: Invalid file icons provider: " .. file_icons.provider, vim.log.levels.WARN)
                      file_icons.enabled = false
                      return "", ""
                    end
                    local ico, hl = utils.get_file_icon(file_icons.provider, fn)
                    if ico == "" then
                      file_icons.enabled = false
                      vim.notify("Alpha: Icons failed, disabling", vim.log.levels.WARN)
                    end
                    return ico, hl
                  end

                  local function file_button(fn, sc, short_fn, autocd)
                    short_fn = short_fn or fn
                    local ico_txt
                    local fb_hl = {}

                    if file_icons.enabled then
                      local ico, hl = icon(fn)
                      local hl_type = type(file_icons.highlight)
                      if hl_type == "boolean" and hl then
                        table.insert(fb_hl, { hl, 0, #ico })
                      elseif hl_type == "string" then
                        table.insert(fb_hl, { file_icons.highlight, 0, #ico })
                      end
                      ico_txt = ico .. "  "
                    else
                      ico_txt = ""
                    end

                    local cd_cmd = (autocd and " | cd %:p:h" or "")
                    local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
                    local fn_start = short_fn:match(".*[/\\]")
                    if fn_start then
                      table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
                    end
                    file_button_el.opts.hl = fb_hl
                    return file_button_el
                  end

                  local function mru(start, cwd, items_number, opts)
                    opts = opts or {
                      ignore = function(path, ext)
                        return path:find("COMMIT_EDITMSG") or vim.tbl_contains({ "gitcommit" }, ext)
                      end,
                      autocd = false,
                    }
                    items_number = if_nil(items_number, 10)

                    local oldfiles, tbl = {}, {}
                    for _, v in ipairs(vim.v.oldfiles) do
                      if #oldfiles >= items_number then break end
                      local match_cwd = not cwd or vim.startswith(v, cwd)
                      local ignore = opts.ignore and opts.ignore(v, utils.get_extension(v))
                      if vim.fn.filereadable(v) == 1 and match_cwd and not ignore then
                        table.insert(oldfiles, v)
                      end
                    end

                    local width = 35
                    for i, fn in ipairs(oldfiles) do
                      local short_fn = cwd and vim.fn.fnamemodify(fn, ":.") or vim.fn.fnamemodify(fn, ":~")
                      if #short_fn > width then
                        short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
                        if #short_fn > width then
                          short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
                        end
                      end
                      local shortcut = tostring(i + start - 1)
                      table.insert(tbl, file_button(fn, shortcut, short_fn, opts.autocd))
                    end

                    return {
                      type = "group",
                      val = tbl,
                      opts = {},
                    }
                  end

                  return mru(0, vim.fn.getcwd())
                end
              '';
              opts = {shrink_margin = false;};
            }
          ]
        ];
      };
      footer = {
        type = "text";
        val = "";
        opts = {
          position = "center";
          hl = "Number";
        };
      };
      padding = {
        type = "padding";
        val = 2;
      };
    in [
      padding
      header
      padding
      section_mru
      padding
      footer
    ];
  };
}
