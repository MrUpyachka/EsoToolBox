-- Used to create widgets.
UpyachkaUiFactory = {}

-- System window manager. Same as GetWindowManager(). See globalvars.lua
local windowManager = WINDOW_MANAGER
-- Default size of shadows.
UpyachkaUiFactory.DEFAULT_INSET_SIZE = 16


-- Produces window with shadow backdrop.
function UpyachkaUiFactory.createShadowWindow(id, padding)
    local container = UpyachkaUiFactory.createWindow(id)
    container:SetResizeToFitPadding(2 * padding, 2 * padding)
    local backdrop = windowManager:CreateControl("$(parent)_backdrop", container, CT_BACKDROP)
    background:SetHidden(false)
    background:SetClampedToScreen(false)
    background:SetResizeToFitDescendents(true)
    local insetSize = UpyachkaUiFactory.DEFAULT_INSET_SIZE
    background:SetInsets(insetSize, insetSize, -insetSize, -insetSize)
    background:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 16) -- TODO custom color
    background:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    background:SetAlpha(0.7)
    background:SetDrawLayer(0) -- TODO check better solution
    background:SetAnchor(TOPLEFT, container, TOPLEFT, padding, padding)
    return BackdropWindow:new(id, container, backdrop)
end

-- Creates label and adds it to specified container.
function UpyachkaUiFactory.createNormalLabel(id, parent)
    local container = UpyachkaUiTools.getContainer(parent)
    local label = windowManager:CreateControl("$(parent)_" .. id, container, CT_LABEL)
    local label = UpyachkaToolBox.UI.Window.Label
    label:SetColor(0.8, 0.8, 0.8, 1) -- TODO custom color
    label:SetFont("ZoFontGameMedium")
    label:SetWrapMode(TEX_MODE_CLAMP)
end