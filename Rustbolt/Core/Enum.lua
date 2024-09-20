Rustbolt.Enum = {};

--- MISC ENGINE ENUMS

---@enum RustboltThemeName
Rustbolt.Enum.ThemeName = {
    DEFAULT = "DEFAULT",
};

---@enum RustboltNotificationType
Rustbolt.Enum.NotificationType = {
    INFO = 1,
    WARNING = 2,
    ERROR = 3,
};

---@enum RustboltResizeDirection
Rustbolt.Enum.ResizeDirection = {
    HORIZONTAL = 1,
    VERTICAL = 2,
    BOTH = 3,
};

--- WINDOW ENUMS

---@enum RustboltGameWindowScreenName
Rustbolt.Enum.GameWindowScreen = {
    EMPTY = "EMPTY",
    START = "START",
    GAME = "GAME",
    EDITOR_HOME = "EDITOR_HOME"
};

--- ANIMATION ENUMS

---@enum RustboltAnimType
Rustbolt.Enum.AnimationType = {
    Bounce = 1,
    SlideIn = 2,
};

---@enum RustboltSlideInSide
Rustbolt.Enum.SlideInSide = {
    LEFT = 1,
    RIGHT = 2,
    TOP = 3,
    BOTTOM = 4,
};

--- TOOLBAR ENUMS

---@enum RustboltToolbarLocation
Rustbolt.Enum.ToolbarLocation = {
    TOP = "Attic",
    BOTTOM = "Basement"
};

---@enum RustboltToolbarSide
Rustbolt.Enum.ToolbarSide = {
    LEFT = 1,
    RIGHT = 2
};

---@enum RustboltToolbarButtonType
Rustbolt.Enum.ToolbarButtonType = {
    BASE = 1,
    DROPDOWN = 2,
};

---@enum RustboltToolbarMenuOpenDirection
Rustbolt.Enum.ToolbarMenuOpenDirection = {
    UP = 1,
    DOWN = 2,
};

--- REFLECTION ENUMS

---@enum RustboltReflectionEntryType
Rustbolt.Enum.ReflectionEntryType = {
    EntryBoxSingle = 1,
    EntryBoxDouble = 2,
    EntryBoxTriple = 3,
    Checkbox = 4,
    Asset = 5
};