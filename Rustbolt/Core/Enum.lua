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

---@enum RustboltCVarCategory
Rustbolt.Enum.CVarCategory = {
    ENGINE = 1,
    GAME = 2,
    DEBUG = 3,
    EDITOR = 4,
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
    Bounce = 1, -- peak consistency
    SlideIn = 2,
    ScaleOnMouseover = 3,
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
    ENTRYBOX = 1,
    CHECKBOX = 2,
    ASSET = 3
};

--- DIALOG ENUMS

---@enum RustboltDialogRowType
Rustbolt.Enum.DialogRowType = {
    Editbox = 1,
    Checkbox = 2,
    ScrollBox = 3
};

---@enum RustboltDialogScrollBoxType
Rustbolt.Enum.DialogScrollBoxType = {
    SINGLE = 1,
    MULTI = 2
};