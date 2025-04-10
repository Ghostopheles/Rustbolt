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

---@class RustboltEditorConstants
local Editor = {
    DefaultGameVersion = "0.0.1"
};

Constants.Editor = Editor;

------------

---@class RustboltWorldConstants
local World = {
    MaxWidth = 64,
    MaxHeight = 64,
};

Constants.World = World;

------------

Rustbolt.Constants = Constants;