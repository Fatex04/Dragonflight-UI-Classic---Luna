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
    self.HadSavedLayout = rawget(self.db.profile, 'x') ~= nil and rawget(self.db.profile, 'y') ~= nil
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

    if ChatFrame1 and not Module.ChatHooksInstalled then
        ChatFrame1:HookScript('OnDragStop', function()
            C_Timer.After(0, function() Module:CaptureChatLayout() end)
        end)

        local resizeButton = _G.ChatFrame1ResizeButton or ChatFrame1.ResizeButton
        if resizeButton and resizeButton.HookScript then
            resizeButton:HookScript('OnMouseUp', function()
                C_Timer.After(0, function() Module:CaptureChatLayout() end)
            end)
        end
        Module.ChatHooksInstalled = true
    end

    if type(FCF_StopResize) == 'function' and not Module.ResizeHookInstalled then
        hooksecurefunc('FCF_StopResize', function(chatFrame)
            if chatFrame == ChatFrame1 then C_Timer.After(0, function() Module:CaptureChatLayout() end) end
        end)
        Module.ResizeHookInstalled = true
    end

    if type(FCF_SavePositionAndDimensions) == 'function' and not Module.PositionSaveHookInstalled then
        hooksecurefunc('FCF_SavePositionAndDimensions', function(chatFrame)
            if chatFrame ~= ChatFrame1 or Module.ApplyingChatLayout or not Module.WorldEntered then return end
            if GetTime() < (Module.SuppressCapturesUntil or 0) then return end

            -- Blizzard calls this after moving a chat window by its tab and
            -- after Edit Mode changes. Capture on the next frame, once its
            -- final anchors and dimensions have been committed.
            Module.ChatCaptureGeneration = (Module.ChatCaptureGeneration or 0) + 1
            local generation = Module.ChatCaptureGeneration
            C_Timer.After(0, function()
                if generation == Module.ChatCaptureGeneration then Module:CaptureChatLayout() end
            end)
        end)
        Module.PositionSaveHookInstalled = true
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
    if type(FCF_SetLocked) == 'function' then FCF_SetLocked(ChatFrame1, true) end

    -- Keep Blizzard's own chat cache in agreement with DragonflightUI. This
    -- prevents a later loading screen from restoring an older default point.
    if type(FCF_SavePositionAndDimensions) == 'function' then
        pcall(FCF_SavePositionAndDimensions, ChatFrame1)
    end
    Module.ApplyingChatLayout = false

    -- ChatFrame1:UpdateStateHandler(db)
end

function Module:CaptureChatLayout()
    if Module.ApplyingChatLayout or not ChatFrame1 or not ChatFrame1.GetPoint then return end

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
    Module.HadSavedLayout = true
end

function Module:SaveChatCommand()
    Module:CaptureChatLayout()
    Module:Print('Chat position and size saved.')
end

function Module:ScheduleLayoutRestore()
    Module.LayoutRestoreGeneration = (Module.LayoutRestoreGeneration or 0) + 1
    local generation = Module.LayoutRestoreGeneration
    for _, delay in ipairs({0, 0.25, 1.0}) do
        C_Timer.After(delay, function()
            if generation == Module.LayoutRestoreGeneration and Module.HadSavedLayout then Module:ApplySettings() end
        end)
    end
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
        -- Blizzard may save its temporary/default point while restoring chat
        -- windows. Do not let those startup writes replace the user's layout.
        Module.SuppressCapturesUntil = GetTime() + 1.25
        if Module.HadSavedLayout then
            Module:ScheduleLayoutRestore()
        else
            -- On a first install, adopt the user's Blizzard chat layout instead
            -- of replacing it with an arbitrary addon default.
            C_Timer.After(1.0, function()
                if not Module.HadSavedLayout then Module:CaptureChatLayout() end
            end)
        end
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
end

function Module:Cata()
    Module:Wrath()
end

function Module:Mists()
    Module:Wrath()
end
