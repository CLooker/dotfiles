require("cl.init.lua_patch")

local buf = require("cl.lib.buf")
local config = require("cl.model.config")
local log = require("cl.lib.log")

config.project_dir = buf.dir()
if not config.neo_tree_enabled and not config.oil_enabled then
  config.netrw_enabled = true
end

log.debug({
  buf = {
    cwd = buf.cwd(),
    path = buf.path(),
    dir = buf.dir(),
  },
  config = config,
})

require("cl.init.vim")

if config.vs_code_located then
  return
end

require("cl.init.keymap")

if config.netrw_enabled then
  require("cl.init.netrw")
end

require("cl.init.windows_os")
require("cl.init.help")
require("cl.init.term")
require("cl.init.cmd")
require("cl.init.lazy")

