---@meta

---@class RustboltWorldSettings

---@class RustboltWorld
---@field protected ID string Unique world identifier
---@field protected Name string Human-readable world name
---@field protected Objects RustboltObject[]
---@field protected GUIDToObject table<string, RustboltObject>
---@field protected NameToObject table<string, RustboltObject>
---@field protected Settings RustboltWorldSettings