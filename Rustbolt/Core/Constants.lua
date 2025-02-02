---@class RustboltConstants
local Constants = {};

------------

---@class RustboltEditorCanvasConstants
local EditorCanvas = {};
EditorCanvas.TileWidth = 32;
EditorCanvas.TileHeight = 32;

Constants.EditorCanvas = EditorCanvas;

------------

Constants.SpritesheetSize = 512;

---@class RustboltInputConstants
local Input = {};
Input.DoubleTapTimeout = 0.5;

Constants.Input = Input;

------------

Rustbolt.Constants = Constants;