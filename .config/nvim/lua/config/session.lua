local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions"

local function session_path()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
  return string.format("%s/%s.vim", session_dir, vim.fn.sha256(cwd))
end

local function has_file_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ""
      and vim.api.nvim_buf_get_name(bufnr) ~= ""
    then
      return true
    end
  end

  return false
end

function M.save()
  if not has_file_buffers() then
    return
  end

  vim.fn.mkdir(session_dir, "p")
  local ok, err = pcall(vim.cmd, "silent mksession! " .. vim.fn.fnameescape(session_path()))
  if not ok then
    vim.notify("Failed to save session: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.load()
  local path = session_path()
  if vim.fn.filereadable(path) == 0 then
    vim.notify("No session found for this directory", vim.log.levels.INFO)
    return
  end

  local ok, err = pcall(vim.cmd, "silent source " .. vim.fn.fnameescape(path))
  if not ok then
    vim.notify("Failed to restore session: " .. tostring(err), vim.log.levels.ERROR)
  end
end

local group = vim.api.nvim_create_augroup("NativeSessionPersistence", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = M.save,
  desc = "Save the current project session",
})

return M
