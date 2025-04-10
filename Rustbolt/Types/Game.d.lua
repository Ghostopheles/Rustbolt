---@meta

---@alias RustboltGameTileFlags number
---@alias RustboltGameVersion string | number

---@class RustboltGameAuthor
---@field Name string
---@field SocialHandle string?
---@field Role string?

---@class RustboltGame
---@field Name string
---@field Authors RustboltGameAuthor[]
---@field Version RustboltGameVersion
---@field Worlds table<RustboltWorldID, RustboltWorld>
---@field StartupWorldID RustboltWorldID?