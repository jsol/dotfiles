local function search()
  local word = vim.fn.expand('<cword>')

  print("Not a snake_case or camelCase word")
end

return { search = search }
