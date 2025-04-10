---@meta

---@alias RustboltGameTileFlags number
---@alias RustboltGameVersion string | number

---@class RustboltGameAuthor
---@field Name string
---@field SocialHandle string?
---@field Role string?

---@class RustboltGameTile
---@field Asset string
---@field Flags RustboltGameTileFlags
---@field Location Vector2DMixin

---@class RustboltGameLevel
---@field Name string
---@field Size Vector2DMixin
---@field Tiles RustboltGameTile[]

---@class RustboltGame
---@field Name string
---@field Authors RustboltGameAuthor[]
---@field Version RustboltGameVersion
---@field Levels RustboltGameLevel[]
---@field DefaultLevel RustboltGameLevel
---@field Worlds table<string, RustboltWorld>