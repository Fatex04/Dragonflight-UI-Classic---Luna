local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local mName = 'Chat'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)

local defaults = {
    profile = {
        scale = 1,
        anchorFrame = 'UIParent',
        customAnchorFrame = '',
        anchor = 'BOTTOMLEFT',
        anchorParent = 'BOTTOMLEFT',
        x = 42,
        y = 35,
        sizeX = 460,
        sizeY = 207,
        -- Visibility
        alphaNormal = 1.0,
        alphaCombat = 1.0,
        showMouseover = false,
        hideAlways = false,
        hideCombat = false,
        hideOutOfCombat = false,
        hideVehicle = false,
        hidePet = false,
        hideNoPet = false,
        hideStance = false,
        hideStealth = false,
        hideNoStealth = false,
        hideCustom = false,
        hideCustomCond = ''
    }
}
Module:SetDefaults(defaults)

local function getDefaultStr(key, sub)
    return Module:GetDefaultStr(key, sub)
end

local function setDefaultValues()
    Module:SetDefaultValues()
end

local function setDefaultSubValues(sub)
    Module:SetDefaultSubValues(sub)
end

local function getOption(info)
    return Module:GetOption(info)
end

local function setOption(info, value)
    Module:SetOption(info, value)
end

local frameTable = {{value = 'UIParent', text = 'UIParent', tooltip = 'descr', label = 'label'}}

local options = {
    type = 'group',
    name = 'DragonflightUI - ' .. mName,
    get = getOption,
    set = setOption,
    args = {
        scale = {
            type = 'range',
            name = 'Scale',
            desc = '' .. getDefaultStr('scale'),
            min = 0.2,
            max = 5,
            bigStep = 0.1,
            order = 1,
            disabled = true,
            editmode = true
        },
        anchorFrame = {
            type = 'select',
            name = 'Anchorframe',
            desc = 'Anchor' .. getDefaultStr('anchorFrame'),
            dropdownValues = frameTable,
            values = frameTable,
            order = 4,
            editmode = true
        },
        anchor = {
            type = 'select',
            name = 'Anchor',
            desc = 'Anchor' .. getDefaultStr('anchor'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            dropdownValues = DF.Settings.DropdownAnchorTable,
            order = 2,
            editmode = true
        },
        anchorParent = {
            type = 'select',
            name = 'AnchorParent',
            desc = 'AnchorParent' .. getDefaultStr('anchorParent'),
            values = {
                ['TOP'] = 'TOP',
                ['RIGHT'] = 'RIGHT',
                ['BOTTOM'] = 'BOTTOM',
                ['LEFT'] = 'LEFT',
                ['TOPRIGHT'] = 'TOPRIGHT',
                ['TOPLEFT'] = 'TOPLEFT',
                ['BOTTOMLEFT'] = 'BOTTOMLEFT',
                ['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
                ['CENTER'] = 'CENTER'
            },
            dropdownValues = DF.Settings.DropdownAnchorTable,
            order = 3,
            editmode = true
        },
        x = {
            type = 'range',
            name = 'X',
            desc = 'X relative to BOTTOM LEFT' .. getDefaultStr('x'),
            min = 0,
            max = 3500,
            bigStep = 1,
            order = 5,
            editmode = true
        },
        y = {
            type = 'range',
            name = 'Y',
            desc = 'Y relative to BOTTOM LEFT' .. getDefaultStr('y'),
            min = 0,
            max = 3500,
            bigStep = 1,
            order = 6,
            editmode = true
        },
        sizeX = {
            type = 'range',
            name = 'Size X',
            desc = 'Size X' .. getDefaultStr('sizeX'),
            min = 0,
            max = 1000,
            bigStep = 1,
            order = 10,
            editmode = true
        },
        sizeY = {
            type = 'range',
            name = 'Size Y',
            desc = 'Size Y' .. getDefaultStr('sizeY'),
            min = 0,
            max = 1000,
            bigStep = 1,
            order = 11,
            editmode = true
        }
    }
}
-- DragonflightUIStateHandlerMixin:AddStateTable(Module, options, nil, 'Chat', getDefaultStr, setOption)

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)
    -- AceDB omits values that equal their defaults when writing SavedVariables,
    -- so an explicitly saved 460x207 chat only retains its non-default point.
    self.HadSavedLayout = self:HasSavedLayout()
    hooksecurefunc(DF:GetModule('Config'), 'AddConfigFrame', function()
        Module:RegisterSettings()
    end)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    DF:RegisterModuleOptions(mName, options)
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    self:EnableAddonSpecific()

    -- Module.AddStateUpdater()
    -- Module:AddEditMode()

    DF.ConfigModule:RegisterSettingsData('chat', 'misc', {name = 'Chat', options = options, default = setDefaultValues})

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)

    Module:RegisterChatCommand('dfsavechat', 'SaveChatCommand')

    self:InstallLayoutHooks()
end

function Module:HasSavedLayout()
    local db = self.db.profile
    if db.layoutSaved then return true end
    -- AceDB strips default-valued fields, including either coordinate.
    for _, key in ipairs({'x', 'y', 'anchor', 'anchorParent', 'anchorFrame', 'sizeX', 'sizeY'}) do
        if rawget(db, key) ~= nil then return true end
    end
    return false
end

function Module:IsEditingChat()
    return self.ChatInteraction or MOVING_CHATFRAME == ChatFrame1 or
        (EditModeManagerFrame and EditModeManagerFrame:IsShown())
end

function Module:InstallLayoutHooks()
    if not ChatFrame1 or self.ChatHooksInstalled then return end
    self.ChatHooksInstalled = true
    local function beginInteraction()
        Module.ChatInteraction = true
    end
    local function finishInteraction()
        -- Capture synchronously before a queued native layout can overwrite it.
        Module:CaptureChatLayout()
        Module.ChatInteraction = false
    end
    for _, method in ipairs({'StartMoving', 'StartSizing'}) do
        hooksecurefunc(ChatFrame1, method, beginInteraction)
    end
    hooksecurefunc(ChatFrame1, 'StopMovingOrSizing', function()
        if Module.ChatInteraction then finishInteraction() end
    end)
    for _, name in ipairs({'FCF_StopDragging', 'FCF_StopResize'}) do
        if type(_G[name]) == 'function' then
            hooksecurefunc(name, function(chatFrame)
                if chatFrame == ChatFrame1 then finishInteraction() end
            end)
        end
    end
    for _, method in ipairs({'SetPoint', 'SetSize', 'SetWidth', 'SetHeight'}) do
        hooksecurefunc(ChatFrame1, method, function()
            if not Module.ApplyingChatLayout and not Module:IsEditingChat() then
                Module:ScheduleLayoutRestore()
            end
        end)
    end
    if EditModeManagerFrame then
        EditModeManagerFrame:HookScript('OnShow', function()
            -- Start the editor at Luna's saved position, while retaining its
            -- native drag, resize and Save/Cancel controls.
            if Module:HasSavedLayout() then Module:ApplySettings() end
        end)
        EditModeManagerFrame:HookScript('OnHide', finishInteraction)
    end
end

function Module:OnDisable()
end

function Module:RegisterSettings()
    local moduleName = 'Chat'
    local cat = 'misc'
    local function register(name, data)
        data.module = moduleName;
        DF.ConfigModule:RegisterSettingsElement(name, cat, data, true)
    end

    register('chat', {order = 1, name = 'Chat', descr = 'Chatss', isNew = false})
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame

    local refreshCat = function(name)
        configFrame:RefreshCatSub('Misc', name)
    end

    refreshCat('Chat')
    -- ChatFrame1.DFEditModeSelection:RefreshOptionScreen();
end

function Module:ApplySettings(sub, key)
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:ApplySettingsInternal(sub, key)
    if not ChatFrame1 then return end
    if not Module.WorldEntered then return end
    if InCombatLockdown() then
        Module.PendingLayoutRestore = true
        return
    end
    local db = Module.db.profile

    local parent;
    if DF.Settings.ValidateFrame(db.customAnchorFrame) then
        parent = _G[db.customAnchorFrame]
    else
        parent = _G[db.anchorFrame]
    end
    parent = parent or UIParent

    local width = math.max(100, tonumber(db.sizeX) or defaults.profile.sizeX)
    local height = math.max(50, tonumber(db.sizeY) or defaults.profile.sizeY)
    local x = tonumber(db.x) or defaults.profile.x
    local y = tonumber(db.y) or defaults.profile.y

    Module.ApplyingChatLayout = true
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint(db.anchor or 'BOTTOMLEFT', parent, db.anchorParent or 'BOTTOMLEFT', x, y)
    ChatFrame1:SetSize(width, height)
    ChatFrame1:SetUserPlaced(true)

    -- Keep Blizzard's own chat cache in agreement with DragonflightUI. This
    -- prevents a later loading screen from restoring an older default point.
    if type(FCF_SavePositionAndDimensions) == 'function' then
        pcall(FCF_SavePositionAndDimensions, ChatFrame1)
    end
    Module.ApplyingChatLayout = false

    -- ChatFrame1:UpdateStateHandler(db)
end

function Module:CaptureChatLayout()
    if Module.ApplyingChatLayout or not Module.WorldEntered or not ChatFrame1 or not ChatFrame1.GetPoint then return end

    local point, relativeTo, relativePoint, x, y = ChatFrame1:GetPoint(1)
    local width, height = ChatFrame1:GetSize()
    if not point or type(x) ~= 'number' or type(y) ~= 'number' or type(width) ~= 'number' or type(height) ~= 'number' then
        return
    end

    local relativeName = relativeTo and relativeTo.GetName and relativeTo:GetName()
    if not relativeName or not _G[relativeName] then relativeName = 'UIParent' end

    local db = Module.db.profile
    db.anchor = point
    db.anchorFrame = relativeName
    db.customAnchorFrame = ''
    db.anchorParent = relativePoint or point
    db.x = x
    db.y = y
    db.sizeX = width
    db.sizeY = height
    db.layoutSaved = true
    Module.HadSavedLayout = true
end

function Module:SaveChatCommand()
    Module:CaptureChatLayout()
    Module:Print('Chat position and size saved.')
end

function Module:ScheduleLayoutRestore()
    if not Module.WorldEntered or not Module:HasSavedLayout() or Module.LayoutRestoreQueued then return end
    Module.LayoutRestoreQueued = true
    C_Timer.After(0, function()
        Module.LayoutRestoreQueued = false
        if Module.WorldEntered and not Module:IsEditingChat() then Module:ApplySettings() end
    end)
end

local frame = CreateFrame('FRAME', 'DragonflightUIChatFrame', UIParent)

function Module.AddStateUpdater()
    Mixin(ChatFrame1, DragonflightUIStateHandlerMixin)
    ChatFrame1:InitStateHandler()
    -- Minimap:SetHideFrame(frame.CalendarButton, 2)
end

function Module:AddEditMode()
    local EditModeModule = DF:GetModule('Editmode');
    EditModeModule:AddEditModeToFrame(ChatFrame1)

    ChatFrame1.DFEditModeSelection:SetGetLabelTextFunction(function()
        return 'Chat'
    end)

    ChatFrame1.DFEditModeSelection:RegisterOptions({
        name = 'Chat',
        options = options,
        default = setDefaultValues,
        moduleRef = self
    });
end

function Module.ChangeSizeAndPosition()
    ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 42, 35)
    ChatFrame1:SetSize(420 + 40, 200 + 7)
end

function frame:OnEvent(event, arg1)
    -- print('event', event)
    if event == 'PLAYER_ENTERING_WORLD' then
        Module.WorldEntered = true
        if Module:HasSavedLayout() then
            Module:ScheduleLayoutRestore()
        else
            -- On a first install, adopt the user's Blizzard chat layout instead
            -- of replacing it with an arbitrary addon default.
            C_Timer.After(1.0, function()
                if not Module:HasSavedLayout() then Module:CaptureChatLayout() end
            end)
        end
    elseif event == 'PLAYER_LEAVING_WORLD' then
        Module.WorldEntered = false
        Module.ChatInteraction = false
    elseif event == 'PLAYER_REGEN_ENABLED' and Module.PendingLayoutRestore then
        Module.PendingLayoutRestore = false
        Module:ScheduleLayoutRestore()
    end
end
frame:SetScript('OnEvent', frame.OnEvent)

function Module:Era()
    Module:Wrath()
end

function Module:TBC()
end

function Module:Wrath()
    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('PLAYER_LEAVING_WORLD')
    frame:RegisterEvent('PLAYER_REGEN_ENABLED')
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end
