require "config.options"
require "config.session"
require "config.keymaps"
require "config.lazy"

function _G.MyTabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr "$" do
    local current = i == vim.fn.tabpagenr()
    local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
    local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    name = name ~= "" and name or " Empty"

    s = s .. (current and "%#TabLineSel#" or "%#TabLine#")
    s = s .. "%" .. i .. "T"
    s = s .. " " .. name .. " "
  end
  return s .. "%#TabLineFill#%T"
end

vim.o.tabline = "%!v:lua.MyTabline()"
