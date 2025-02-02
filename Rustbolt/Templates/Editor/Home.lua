local Registry = Rustbolt.EventRegistry;
local Events = Rustbolt.Events;
local Enum = Rustbolt.Enum;
local Engine = Rustbolt.Engine;
local L = Rustbolt.Strings;

------------

RustboltEditorHomeMixin = {};

function RustboltEditorHomeMixin:OnLoad()
    Registry:RegisterCallback(Events.ADDON_LOADED, self.RegisterToolbarButtons, self);

    self.HorizontalResizeBar:SetTarget(self.ReflectionPanel, nil, Rustbolt.Enum.ResizeDirection.HORIZONTAL);
    self.VerticalResizeBar:SetTarget(self.Viewport, "BOTTOMRIGHT", Rustbolt.Enum.ResizeDirection.VERTICAL);
end

function RustboltEditorHomeMixin:RegisterToolbarButtons()
    do
        local dialogConfig = {
            Title = L.DIALOG_NEW_PROJECT_TITLE,
            Tag = "NEW_PROJECT_DIALOG",
            Fields = {
                {
                    RowType = Enum.DialogRowType.Editbox,
                    Title = L.DIALOG_NEW_PROJECT_NAME,
                    Required = true,
                    Tag = "Name"
                },
                {
                    RowType = Enum.DialogRowType.Editbox,
                    Title = L.DIALOG_NEW_PROJECT_AUTHOR,
                    Required = true,
                    Tag = "AuthorName"
                },
            }
        };

        local function DialogCallback(results)
            local game = Rustbolt.EditorObjects.CreateGame({
                Name = results.Name,
                Authors = {results.AuthorName},
                Version = "0.0.1"
            });
            Registry:TriggerEvent(Events.PROJECT_CREATED, game);
        end

        local function GenerateMenu(rootDescription)
            rootDescription:CreateButton(L.TOOLBAR_FILE_NEW_PROJECT, function()
                Rustbolt.Dialog.CreateAndShowDialog(dialogConfig, DialogCallback);
            end);
            rootDescription:CreateButton(L.TOOLBAR_FILE_LOAD_PROJECT, function()
                print("uwu");
            end);
        end

        local name = L.TOOLBAR_TITLE_FILE;
        local buttonConfig = {
            Text = name,
            ID = "Toolbar_" .. name,
            ButtonType = Rustbolt.Enum.ToolbarButtonType.DROPDOWN,
            MenuConfig = {
                Generator = GenerateMenu
            }
        };
        Engine:AddAtticButton(buttonConfig);
    end
end