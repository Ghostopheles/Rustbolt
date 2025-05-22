local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;

--[[
the editor is the heart of our most beloved developers
]]

---@class RustboltEditor
---@field private ActiveGame RustboltGame?
local Editor = {};

function Editor:GetEditorWindow()
    return Rustbolt.Engine:GetWindow().EditorHome;
end

---@param game RustboltGame
function Editor:SetActiveGame(game)
    self.ActiveGame = game;
end

---@return RustboltGame? game
function Editor:GetActiveGame()
    return self.ActiveGame;
end

---@param game RustboltGame
function Editor:LoadGame(game)
    self.ActiveGame = game;
    Registry:TriggerEvent(Events.EDITOR_GAME_PRELOAD, game);
end

function Editor:NewGame(...)
    ---@type RustboltGame
    local game = Rustbolt.ObjectManager:CreateObject("Game", ...);
    Registry:TriggerEvent(Events.EDITOR_GAME_CREATED, game);
    self:LoadGame(game);
end

--[[
    it's toolbar'n time
]]--

---@param toolbar RustboltToolbarLocation
---@param buttonInfo RustboltToolbarButtonConfig
function Editor:AddToolbarButton(toolbar, buttonInfo)
    local screen = self:GetEditorWindow();
    screen[toolbar]:AddButton(buttonInfo);
end

---@param buttonInfo RustboltToolbarButtonConfig
function Editor:AddAtticButton(buttonInfo)
    self:AddToolbarButton(Enum.ToolbarLocation.TOP, buttonInfo);
end

---@param buttonInfo RustboltToolbarButtonConfig
function Editor:AddBasementButton(buttonInfo)
    self:AddToolbarButton(Enum.ToolbarLocation.BOTTOM, buttonInfo);
end

--[[
    it's savin' time
]]--

function Editor:SaveProject()
    local game = self:GetActiveGame();
    if not game then
        return;
    end

    local serializer = Rustbolt.ObjectManager:GetSerializerForObject(Rustbolt.ObjectType.GAME);
    if not serializer then
        return;
    end

    local serializedGame = serializer(game);
    RustboltGames[game:GetName()] = serializedGame;
    Registry:TriggerEvent(Events.EDITOR_GAME_SAVED, game);
end

function Editor:LoadProject(projectName)
    
end

------------

Rustbolt.Editor = Editor;