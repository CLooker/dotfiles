-- use git-bash in windows
vim.cmd [[
  if has("win32")
    let &shell='bash.exe'
    let &shellcmdflag = '-c'
    let &shellredir = '>%s 2>&1'
    set shellquote= shellxescape=
    set shellxquote=
    let &shellpipe='2>&1| tee'
  endif
]]

