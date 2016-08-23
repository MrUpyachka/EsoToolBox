-- Used to create widgets.
UpyachkaUiFactory = {}

--[[
    TODO list
    # Configure layouts in xml.
    ]]--

-- System window manager. Same as GetWindowManager(). See globalvars.lua
local windowManager = WINDOW_MANAGER
-- Default size of shadows.
UpyachkaUiFactory.DEFAULT_INSET_SIZE = 16

-- Produces simple top level container.
function UpyachkaUiFactory.createWindow(id)
    local container = windowManager:CreateTopLevelWindow(id)
    container:SetClampedToScreen(true)
    container:SetMouseEnabled(true)
    container:SetResizeToFitDescendents(true)
    container:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0, 0)
    container:SetHidden(false)
    return container
end

-- Produces simple container.
function UpyachkaUiFactory.createContainer(id, parent, type)
    local backdrop = windowManager:CreateControl("$(parent)_" .. id, parent, type)
    backdrop:SetClampedToScreen(true)
    backdrop:SetResizeToFitDescendents(true)
    backdrop:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    backdrop:SetHidden(false)
    return backdrop
end

-- Produces window with shadow backdrop.
function UpyachkaUiFactory.createShadowWindow(id, padding)
    local root = UpyachkaUiFactory.createWindow(id)

    local backdrop = UpyachkaUiFactory.createContainer("backdrop", root, CT_BACKDROP)
    backdrop:SetResizeToFitPadding(2 * padding, 2 * padding)
    backdrop:SetAnchor(TOPLEFT, root, TOPLEFT, 0, 0)

    local container = UpyachkaUiFactory.createContainer("container", backdrop, CT_CONTROL)
    container:SetAnchor(TOPLEFT, backdrop, TOPLEFT, padding, padding)

    local insetSize = UpyachkaUiFactory.DEFAULT_INSET_SIZE
    backdrop:SetInsets(insetSize, insetSize, -insetSize, -insetSize)
    backdrop:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, insetSize) -- TODO custom color
    backdrop:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    backdrop:SetAlpha(0.7)
    backdrop:SetDrawLayer(0) -- TODO check better solution

    return BackdropWindow:new(id, root, backdrop, container)
end

-- Creates label and adds it to specified container.
function UpyachkaUiFactory.createNormalLabel(id, parent)
    local container = UpyachkaUiTools.getContainer(parent)
    local label = windowManager:CreateControl("$(parent)_" .. id, container, CT_LABEL)
    label:SetColor(0.8, 0.8, 0.8, 1) -- TODO custom color
    label:SetFont("ZoFontGameMedium")
    label:SetWrapMode(TEX_MODE_CLAMP)
    return label
end