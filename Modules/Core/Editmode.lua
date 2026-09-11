local addonName, addonTable = ...;
local Helper = addonTable.Helper;
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local L = LibStub("AceLocale-3.0"):GetLocale("DragonflightUI")
local mName = 'Editmode'
local Module = DF:NewModule(mName, 'AceConsole-3.0', 'AceHook-3.0')

Mixin(Module, DragonflightUIModulesMixin)
Mixin(Module, CallbackRegistryMixin)

local defaults = {
    profile = {
        scale = 1,
        classicEraLayoutFixVersion = 0,
        general = {showGrid = true, gridSize = 20, snapGrid = true, snapElements = true},
        advanced = {
            -- actionbar
            ActionBars = true,
            StanceBar = true,
            PossessBar = true,
            PetBar = true,
            TotemBar = true,
            Bags = true,
            MicroMenu = true,
            FPS = true,
            XPBar = true,
            RepBar = true,
            ExtraActionButton = true,
            FlyoutBar = true,
            GroupLootContainer = true,
            VehicleLeave = true,
            -- Bossframe
            BossFrames = true,
            -- buffs,
            Buffs = true,
            Debuffs = true,
            -- castbar
            Castbars = true,
            MirrorTimer = true,
            -- minimap
            Minimap = true,
            Tracker = true,
            Durability = true,
            LFG = true,
            -- tooltip
            GameTooltip = true,
            -- UI
            WidgetBelow = true,
            -- unitframes
            PlayerFrame = true,
            Player_PowerBarAlt = true,
            PlayerSecondaryRes = true,
            PlayerTotemFrame = true,
            PetFrame = true,
            TargetFrame = true,
            TargetOfTargetFrame = true,
            FocusFrame = true,
            FocusTargetFrame = true,
            PartyFrame = true,
            RaidFrame = true
        }
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

local generalOptions = {
    type = 'group',
    name = 'EditMode',
    get = getOption,
    set = setOption,
    hideDefault = true,
    args = {
        showGrid = {
            type = 'toggle',
            name = 'Show Grid',
            desc = '' .. getDefaultStr('showGrid', 'general'),
            order = 100.5,
            small = true
        },
        gridSize = {
            type = 'range',
            name = 'Grid Size',
            desc = '' .. getDefaultStr('gridSize', 'general'),
            min = 8,
            max = 128,
            bigStep = 4,
            order = 101,
            small = true
        },
        snapGrid = {
            type = 'toggle',
            name = 'Snap to Grid',
            desc = '' .. getDefaultStr('snapGrid', 'general'),
            order = 102,
            small = true
        }
        -- snapElements = {
        --     type = 'toggle',
        --     name = 'Snap to Elements',
        --     desc = '*NOT YET IMPLEMENTED - COMING SOON*' .. getDefaultStr('snapElements', 'general'),
        --     order = 103,
        --     small = true
        -- }
    }
}

local advancedOptions;
if true then
    --
    advancedOptions = {
        type = 'group',
        name = 'EditMode',
        get = getOption,
        set = setOption,
        hideDefault = true,
        args = {
            headerActionbar = {
                type = 'header',
                name = 'Actionbar',
                desc = '...',
                order = 100,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerCombat = {
                type = 'header',
                name = 'Combat',
                desc = '...',
                order = 200,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerFrames = {
                type = 'header',
                name = 'Frames',
                desc = '...',
                order = 300,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            },
            headerMisc = {
                type = 'header',
                name = 'Misc',
                desc = '...',
                order = 400,
                sortComparator = DFSettingsListMixin.AlphaSortComparator,
                isExpanded = true,
                editmode = true
            }
        }
    }

    local displayTable = {}
    -- actionbar
    displayTable['ActionBars'] = L['ActionbarName']
    displayTable['FlyoutBar'] = L['ModuleFlyout']
    displayTable['MicroMenu'] = L['MicroMenu']
    displayTable['PetBar'] = L['PetBar']
    displayTable['PossessBar'] = L['PossessBar']
    displayTable['StanceBar'] = L['StanceBar']
    displayTable['TotemBar'] = L['TotemBar']
    displayTable['ExtraActionButton'] = L['ExtraActionButtonOptionsName']
    displayTable['VehicleLeave'] = L['VehicleLeaveButton']

    -- combat
    displayTable['Buffs'] = L['BuffsOptionsName']
    displayTable['Debuffs'] = L['DebuffsOptionsName']
    displayTable['Castbars'] = L['CastbarName']
    displayTable['MirrorTimer'] = L['CastbarMirrorTimerName']

    -- frames
    displayTable['PlayerFrame'] = L['PlayerFrameName']
    displayTable['PlayerSecondaryRes'] = L['PlayerSecondaryResName']
    displayTable['PlayerTotemFrame'] = L['PlayerTotemFrameName']
    displayTable['PetFrame'] = L['PetFrameName']
    displayTable['TargetFrame'] = L['TargetFrameName']
    displayTable['TargetOfTargetFrame'] = L['TargetOfTargetFrameName']
    displayTable['FocusFrame'] = L['FocusFrameName']
    displayTable['FocusTargetFrame'] = L['FocusFrameToTName']
    displayTable['PartyFrame'] = L['PartyFrameName']
    displayTable['RaidFrame'] = L['RaidFrameName']
    displayTable['BossFrames'] = L['BossFrameName']

    -- misc
    displayTable['Bags'] = L['BagsOptionsName']
    displayTable['XPBar'] = L['XPOptionsName']
    displayTable['RepBar'] = L['RepOptionsName']
    displayTable['FPS'] = L['FPSOptionsName']
    displayTable['LFG'] = L['MinimapLFGName']
    displayTable['Minimap'] = L['MinimapName']
    displayTable['Tracker'] = L['MinimapTrackerName']
    displayTable['Durability'] = L['MinimapDurabilityName']
    displayTable['GameTooltip'] = L['TooltipName']
    displayTable['Player_PowerBarAlt'] = L['PowerBarAltName']
    displayTable['GroupLootContainer'] = L['GroupLootContainerName']
    displayTable['WidgetBelow'] = L['WidgetBelowName']

    local function AddTableToCategory(t, header)
        for k, v in ipairs(t) do
            --
            advancedOptions.args[v] = {
                type = 'toggle',
                name = displayTable[v] or v,
                desc = '' .. getDefaultStr(v, 'advanced'),
                order = k,
                small = true,
                group = header,
                editmode = true
            }
        end
    end

    -- actionbar
    local actionbarFrames = {
        'ActionBars', 'FlyoutBar', 'MicroMenu', 'PetBar', 'PossessBar', 'StanceBar', 'TotemBar', 'VehicleLeave'
    };
    if DF.Cata then table.insert(actionbarFrames, 'ExtraActionButton') end
    AddTableToCategory(actionbarFrames, 'headerActionbar');

    -- combat
    local combatFrames = {'Buffs', 'Debuffs', 'Castbars', 'MirrorTimer'};
    AddTableToCategory(combatFrames, 'headerCombat');

    -- frames
    local framesFrames = {
        'PlayerFrame', 'PlayerSecondaryRes', 'PlayerTotemFrame', 'PetFrame', 'TargetFrame', 'TargetOfTargetFrame',
        'PartyFrame', 'RaidFrame'
    }
    if DF.Wrath then
        table.insert(framesFrames, 'FocusFrame')
        table.insert(framesFrames, 'FocusTargetFrame')
        table.insert(framesFrames, 'BossFrames')

    end
    AddTableToCategory(framesFrames, 'headerFrames')

    -- misc
    local miscFrames = {
        'Bags', 'XPBar', 'RepBar', 'FPS', 'LFG', 'GroupLootContainer', 'Minimap', 'Tracker', 'Durability',
        'GameTooltip', 'WidgetBelow'
    }
    if DF.Cata then table.insert(miscFrames, 'Player_PowerBarAlt') end
    AddTableToCategory(miscFrames, 'headerMisc')

    advancedOptions.set = function(...)
        -- print(...)
        setOption(...)
        Module:SetEditMode(Module.IsEditMode)
    end
end

function Module:OnInitialize()
    DF:Debug(self, 'Module ' .. mName .. ' OnInitialize()')
    self.db = DF.db:RegisterNamespace(mName, defaults)

    self:SetEnabledState(DF.ConfigModule:GetModuleEnabled(mName))

    -- DF:RegisterModuleOptions(mName, generalOptions)

    ---@diagnostic disable-next-line: param-type-mismatch
    if not self.callbackTables then CallbackRegistryMixin.OnLoad(self) end
end

function Module:OnEnable()
    DF:Debug(self, 'Module ' .. mName .. ' OnEnable()')
    self:SetWasEnabled(true)

    -- Earlier compatibility builds could save ActionBars=false after the
    -- native and custom selection layers fought each other. Repair that saved
    -- state once, while preserving all actual element coordinates and scales.
    if DF.EraLater and (self.db.profile.classicEraLayoutFixVersion or 0) < 2 then
        local advanced = self.db.profile.advanced
        advanced.ActionBars = true
        advanced.StanceBar = true
        advanced.PossessBar = true
        advanced.PetBar = true
        advanced.Bags = true
        advanced.MicroMenu = true
        advanced.XPBar = true
        advanced.RepBar = true
        self.db.profile.classicEraLayoutFixVersion = 2
    end

    self:EnableAddonSpecific()

    Module:CreateGrid()
    Module:SetupBlizzardEditModeSync()
    Module:SetupLunaLogo()
    Module:SetupDiscordButton()
    Module:SetupChangelogButton()
    Module:SetupMainmenuButton()

    Module:RegisterChatCommand('editmode', 'SlashCommand')
    Module:RegisterChatCommand('dfeditmode', 'SlashCommand')
    Module:RegisterChatCommand('dfmove', 'SlashCommand')

    local missingEvents = {}
    if not self.Event or not self.Event.OnEditMode then table.insert(missingEvents, 'OnEditMode') end
    if not self.Event or not self.Event.OnSelection then table.insert(missingEvents, 'OnSelection') end
    if #missingEvents > 0 then Module:GenerateCallbackEvents(missingEvents) end
    self:RegisterCallback('OnEditMode', function(self, value)
        DF:Debug(self, '~> OnEditMode', value)
    end, self)
    self:RegisterCallback('OnSelection', function(self, value)
        DF:Debug(self, '~> OnSelection', value and value:GetName())
    end, self)

    Module:ApplySettings()
    Module:RegisterOptionScreens()

    self:SecureHook(DF, 'RefreshConfig', function()
        -- print('RefreshConfig', mName)
        Module:ApplySettings()
        Module:RefreshOptionScreens()
    end)
end

function Module:OnDisable()
end

function Module:RegisterOptionScreens()
    if not Module.EditModeFrame then return end
    -- DF.ConfigModule:RegisterOptionScreen('Misc', 'Darkmode', {
    --     name = 'Darkmode',
    --     sub = 'general',
    --     options = generalOptions,
    --     default = function()
    --         setDefaultSubValues('general')
    --     end
    -- })

    Module.EditModeFrame:SetupOptions({
        name = 'EditMode',
        sub = 'general',
        options = generalOptions,
        default = function()
            setDefaultSubValues('general')
        end,
        shouldDisplayAsap = true
    }, true)

    Module.EditModeFrame:SetupAdvancedOptions({
        name = 'EditMode',
        sub = 'advanced',
        options = advancedOptions,
        default = function()
            setDefaultSubValues('advanced')
        end,
        shouldDisplayAsap = true
    })
end

function Module:RefreshOptionScreens()
    -- print('Module:RefreshOptionScreens()')

    local configFrame = DF.ConfigModule.ConfigFrame
    local cat = 'Misc'
    -- configFrame:RefreshCatSub(cat, 'Darkmode')
end

function Module:ApplySettings(sub, key)
    Helper:Benchmark(string.format('ApplySettings(%s,%s)', tostring(sub), tostring(key)), function()
        Module:ApplySettingsInternal(sub, key)
    end, 0, self)
end

function Module:ApplySettingsInternal(sub, key)
    local db = Module.db.profile
    local state = db.general

    local f = Module.EditModeFrame
    if not f or not f.Grid then return end

    if Module.IsEditMode then
        f.Grid:SetShown(state.showGrid)
        f.Grid:SetGridSpacing(state.gridSize)
    else
        f.Grid:SetShown(false)
    end
end

local function IsDragonflightUIKeyboardFocus(frameRef)
    local current = frameRef
    for _ = 1, 20 do
        if not current then return false end
        local name = current.GetName and current:GetName()
        if type(name) == 'string' and
            (name:find('DragonflightUI', 1, true) == 1 or name:find('DFSettings', 1, true) == 1) then
            return true
        end
        current = current.GetParent and current:GetParent() or nil
    end
    return false
end

function Module:HideCustomEditModeSurfaces()
    if self.EditModeDimmer then self.EditModeDimmer:Hide() end
    if self.InputBlocker then
        self.InputBlocker:StopMovingOrSizing()
        self.InputBlocker:Hide()
        self.InputBlocker:EnableMouse(false)
        self.InputBlocker:EnableMouseWheel(false)
    end

    if self.EditModeFrame then
        self.EditModeFrame:StopMovingOrSizing()
        self.EditModeFrame:Hide()
        if self.EditModeFrame.Grid then self.EditModeFrame.Grid:Hide() end
        if self.EditModeFrame.MouseOverChecker then self.EditModeFrame.MouseOverChecker:Hide() end
    end

    if self.ChangelogFrame then
        self.ChangelogFrame:StopMovingOrSizing()
        self.ChangelogFrame:Hide()
    end

    if StaticPopupDialogs and StaticPopupDialogs['DragonflightUIDiscordInvite'] then
        StaticPopup_Hide('DragonflightUIDiscordInvite')
    end

    for _, selection in ipairs(self.SelectionFrames or {}) do
        selection.EditModeGeneration = (selection.EditModeGeneration or 0) + 1
        selection:EnableMouse(false)
        selection.isDragging = false
        selection.CenterSnapX = nil
        selection.CenterSnapY = nil
        selection:StopMovingOrSizing()

        local parent = selection:GetParent()
        if parent and not InCombatLockdown() then
            parent:StopMovingOrSizing()
            if selection.StartMovable ~= nil then parent:SetMovable(selection.StartMovable) end
        elseif parent then
            self.PendingParentCleanup = true
        end

        selection:Hide()
        if selection.SelectionOptions then
            selection.SelectionOptions:StopMovingOrSizing()
            selection.SelectionOptions:Hide()
        end
    end

    self:HideAlignmentGuides()

    local quickKeybind = _G.DragonflightUIQuickKeybindFrame
    local quickKeybindActive = quickKeybind and
                                   (quickKeybind:IsShown() or quickKeybind.InQuickKeybindMode)
    if quickKeybind then
        quickKeybind:StopMovingOrSizing()
        quickKeybind:Hide()
        quickKeybind.InQuickKeybindMode = false
    end

    local quickOverlay = _G.DragonflightUIQuickKeybindButtonOverlay
    if quickOverlay then
        quickOverlay.buttonRef = nil
        quickOverlay.command = nil
        quickOverlay.commandHuman = nil
        quickOverlay:Hide()
    end

    if quickKeybindActive and KeybindListener and KeybindListener.StopListening then
        KeybindListener:StopListening()
    end

    local keyboardFocus = GetCurrentKeyBoardFocus and GetCurrentKeyBoardFocus()
    if keyboardFocus and IsDragonflightUIKeyboardFocus(keyboardFocus) and keyboardFocus.ClearFocus then
        keyboardFocus:ClearFocus()
    end

    if WorldFrame and WorldFrame.EnableMouse then WorldFrame:EnableMouse(true) end
    if IsMouselooking and IsMouselooking() and MouselookStop then MouselookStop() end
end

function Module:ResetInputStateAfterLoading()
    self.IsEditMode = false
    self.WasEditMode = false
    self.SelectedFrame = nil
    self:HideCustomEditModeSurfaces()

    -- Do not broadcast OnEditMode here. Action bars and secure state drivers
    -- already initialize during addon loading; rebuilding every system again
    -- on PLAYER_ENTERING_WORLD can exceed WoW's per-script time limit. The
    -- direct cleanup above is sufficient to release every custom mouse layer.
    self:ApplySettings()
    self:HideCustomEditModeSurfaces()
end

local frame = CreateFrame('FRAME')

function frame:OnEvent(event, arg1, arg2, arg3)
    -- print('event', event, InCombatLockdown())
    if event == 'PLAYER_REGEN_DISABLED' then
        Module:CombatHandler(true)
    elseif event == 'PLAYER_REGEN_ENABLED' then
        if Module.PendingParentCleanup then
            Module.PendingParentCleanup = false
            Module:HideCustomEditModeSurfaces()
        end
        Module:CombatHandler(false)
    elseif event == 'PLAYER_ENTERING_WORLD' then
        Module:HideCustomEditModeSurfaces()
        C_Timer.After(0, function()
            if not Module.IsEditMode then Module:ResetInputStateAfterLoading() end
        end)
        C_Timer.After(0.25, function()
            if not Module.IsEditMode then Module:HideCustomEditModeSurfaces() end
        end)
    end
end
frame:SetScript('OnEvent', frame.OnEvent)
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')

function Module:CreateGrid()
    DF:Debug(self, 'CreateGrid()')
    if Module.EditModeFrame then return Module.EditModeFrame end
    local editModeFrame = CreateFrame('Frame', 'DragonflightUIEditModeFrame', UIParent,
                                      'DragonflightUIEditModeFrameTemplate');
    editModeFrame:SetupGrid();
    editModeFrame:SetupMouseOverChecker();
    if DF.Era or DF.Cata then editModeFrame:SetupLayoutDropdown(); end
    editModeFrame:Hide()
    -- editModeFrame.Grid:Hide()
    Module.IsEditMode = false;
    Module.EditModeFrame = editModeFrame;
    -- Selection frames are created while the XML files load, before OnEnable.
    -- Keep that list instead of discarding it when the grid is created.
    Module.SelectionFrames = Module.SelectionFrames or {}

    -- Dim the world while keeping HUD systems and their selection fills crisp.
    -- This makes labels and selection rectangles readable on bright scenes.
    local dimmer = CreateFrame('Frame', 'DragonflightUIEditModeDimmer', UIParent)
    dimmer:SetAllPoints(UIParent)
    dimmer:SetFrameStrata('LOW')
    dimmer:SetFrameLevel(0)
    dimmer:EnableMouse(false)
    local dimTexture = dimmer:CreateTexture(nil, 'BACKGROUND')
    dimTexture:SetAllPoints(dimmer)
    dimTexture:SetColorTexture(0, 0, 0, 0.34)
    dimmer.Texture = dimTexture
    dimmer:Hide()
    Module.EditModeDimmer = dimmer

    -- Consume gameplay clicks while the custom HUD editor is open. Selection
    -- frames sit one level above this blocker and the editor windows sit above
    -- both, so bars remain selectable without casting spells or using items.
    local inputBlocker = CreateFrame('Button', 'DragonflightUIEditModeInputBlocker', UIParent)
    inputBlocker:Hide()
    inputBlocker:EnableMouse(false)
    inputBlocker:EnableMouseWheel(false)
    inputBlocker:SetAllPoints(UIParent)
    inputBlocker:SetFrameStrata('HIGH')
    inputBlocker:SetFrameLevel(40)
    inputBlocker:RegisterForClicks('AnyDown', 'AnyUp')
    inputBlocker:SetScript('OnMouseWheel', function()
    end)
    if inputBlocker.SetPropagateMouseClicks then inputBlocker:SetPropagateMouseClicks(false) end
    if inputBlocker.SetPropagateMouseMotion then inputBlocker:SetPropagateMouseMotion(false) end
    Module.InputBlocker = inputBlocker

    local alignmentGuides = CreateFrame('Frame', 'DragonflightUIEditModeAlignmentGuides', UIParent)
    alignmentGuides:SetAllPoints(UIParent)
    alignmentGuides:SetFrameStrata('HIGH')
    alignmentGuides:SetFrameLevel(68)
    alignmentGuides:EnableMouse(false)

    local vertical = alignmentGuides:CreateTexture(nil, 'OVERLAY')
    vertical:SetColorTexture(1, 0.08, 0.08, 0.95)
    vertical:SetWidth(1)
    vertical:SetPoint('TOP', UIParent, 'TOP', 0, 0)
    vertical:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 0)

    local horizontal = alignmentGuides:CreateTexture(nil, 'OVERLAY')
    horizontal:SetColorTexture(1, 0.08, 0.08, 0.95)
    horizontal:SetHeight(1)
    horizontal:SetPoint('LEFT', UIParent, 'LEFT', 0, 0)
    horizontal:SetPoint('RIGHT', UIParent, 'RIGHT', 0, 0)

    alignmentGuides.Vertical = vertical
    alignmentGuides.Horizontal = horizontal
    alignmentGuides:Hide()
    Module.AlignmentGuides = alignmentGuides
end

function Module:UpdateAlignmentGuides(frameRef)
    local guides = self.AlignmentGuides
    if not guides or not frameRef then return false, false end

    local frameX, frameY = frameRef:GetCenter()
    local screenX, screenY = UIParent:GetCenter()
    if not frameX or not frameY or not screenX or not screenY then
        guides:Hide()
        return false, false
    end

    local snapDistance = 8
    local snapX = math.abs(frameX - screenX) <= snapDistance
    local snapY = math.abs(frameY - screenY) <= snapDistance
    guides.Vertical:SetShown(snapX)
    guides.Horizontal:SetShown(snapY)
    guides:SetShown(snapX or snapY)
    return snapX, snapY
end

function Module:HideAlignmentGuides()
    if self.AlignmentGuides then self.AlignmentGuides:Hide() end
end

function Module:SlashCommand()
    Module:SetEditMode(not Module.IsEditMode);
end

function Module:SetupMainmenuButton()
    local configModule = DF:GetModule('Config')

    local btn = configModule.EditModeButton

    btn:SetScript('OnClick', function()
        -- 
        DF:Debug(self, 'editmode')
        Module:SetEditMode(not Module.IsEditMode)
    end)
end

function Module:SetupLunaLogo()
    if self.LunaLogo then return end

    -- Keep the Luna branding independent from Edit Mode. A texture region on
    -- UIParent has no mouse handling, so it can never intercept clicks.
    local logo = UIParent:CreateTexture('DragonflightUILunaLogo', 'OVERLAY')
    logo:SetSize(48, 48)
    logo:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 12, -12)
    logo:SetTexture('Interface\\AddOns\\DragonflightUI\\Textures\\Art\\luna-logo')
    logo:SetTexCoord(0, 1, 0, 1)
    logo:Hide()

    self.LunaLogo = logo
end

function Module:SetupDiscordButton()
    if self.DiscordButton then return end

    local parent = self:IsBlizzardEditModeAvailable() and EditModeManagerFrame or self.EditModeFrame
    if not parent then return end

    if not StaticPopupDialogs['DragonflightUIDiscordInvite'] then
        StaticPopupDialogs['DragonflightUIDiscordInvite'] = {
            text = 'Feedback or found Bugs? Join us on:',
            button1 = CLOSE,
            hasEditBox = true,
            editBoxWidth = 285,
            OnShow = function(dialog)
                local editBox = dialog.editBox or dialog.EditBox
                if editBox then
                    editBox:SetText('https://discord.gg/ZfYDHV6Qgs')
                    editBox:HighlightText()
                    editBox:SetFocus()
                end
            end,
            OnHide = function(dialog)
                local editBox = dialog.editBox or dialog.EditBox
                if editBox then
                    editBox:ClearFocus()
                    editBox:SetText('')
                end
            end,
            EditBoxOnEnterPressed = function(editBox)
                editBox:GetParent():Hide()
            end,
            EditBoxOnEscapePressed = function(editBox)
                editBox:GetParent():Hide()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3
        }
    end

    local button = CreateFrame('Button', 'DragonflightUIEditModeDiscordButton', parent, 'UIPanelButtonTemplate')
    button:SetSize(330, 34)
    button:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -8)
    button:SetFrameLevel(parent:GetFrameLevel() + 20)
    button:SetClampedToScreen(true)
    button:RegisterForClicks('LeftButtonUp')

    local logo = button:CreateTexture(nil, 'ARTWORK')
    logo:SetTexture('Interface\\AddOns\\DragonflightUI\\Textures\\Art\\discord')
    logo:SetSize(24, 24)
    logo:SetPoint('LEFT', button, 'LEFT', 8, 0)

    local label = button:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    label:SetPoint('LEFT', logo, 'RIGHT', 8, 0)
    label:SetPoint('RIGHT', button, 'RIGHT', -8, 0)
    label:SetJustifyH('LEFT')
    label:SetText('Feedback or found Bugs? Join us on:')

    button:SetScript('OnClick', function()
        StaticPopup_Show('DragonflightUIDiscordInvite')
    end)
    button:SetScript('OnEnter', function(frameRef)
        GameTooltip:SetOwner(frameRef, 'ANCHOR_RIGHT')
        GameTooltip:AddLine('Feedback or found Bugs? Join us on:', 1, 1, 1)
        GameTooltip:AddLine('https://discord.gg/ZfYDHV6Qgs', 0.35, 0.55, 1)
        GameTooltip:Show()
    end)
    button:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    button.Logo = logo
    button.Label = label
    self.DiscordButton = button
end

function Module:CreateChangelogFrame()
    if self.ChangelogFrame then return self.ChangelogFrame end

    local backdropTemplate = BackdropTemplateMixin and 'BackdropTemplate' or nil
    local frameRef = CreateFrame('Frame', 'DragonflightUILunaChangelogFrame', UIParent, backdropTemplate)
    frameRef:SetSize(680, 560)
    frameRef:SetPoint('CENTER')
    frameRef:SetFrameStrata('DIALOG')
    frameRef:SetToplevel(true)
    frameRef:SetClampedToScreen(true)
    frameRef:SetMovable(true)
    frameRef:EnableMouse(true)
    frameRef:RegisterForDrag('LeftButton')
    frameRef:SetScript('OnDragStart', function(frame)
        frame:StartMoving()
    end)
    frameRef:SetScript('OnDragStop', function(frame)
        frame:StopMovingOrSizing()
    end)
    frameRef:SetScript('OnHide', function(frame)
        frame:StopMovingOrSizing()
    end)
    if frameRef.SetPropagateMouseClicks then frameRef:SetPropagateMouseClicks(false) end
    if frameRef.SetPropagateMouseMotion then frameRef:SetPropagateMouseMotion(false) end
    if frameRef.SetBackdrop then
        frameRef:SetBackdrop({
            bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
            edgeFile = 'Interface\\DialogFrame\\UI-DialogBox-Border',
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = {left = 11, right = 12, top = 12, bottom = 11}
        })
    end

    -- Keep the normal Edit Mode world brightness unchanged. Only the
    -- changelog panel receives the stronger dark fill for text readability.
    local darkBackground = frameRef:CreateTexture(nil, 'BACKGROUND', nil, 1)
    darkBackground:SetPoint('TOPLEFT', frameRef, 'TOPLEFT', 12, -12)
    darkBackground:SetPoint('BOTTOMRIGHT', frameRef, 'BOTTOMRIGHT', -12, 11)
    darkBackground:SetColorTexture(0.015, 0.015, 0.015, 0.94)

    local title = frameRef:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLarge')
    title:SetPoint('TOP', frameRef, 'TOP', 0, -18)
    title:SetText('DragonflightUI_Luna Changelog')

    local closeButton = CreateFrame('Button', nil, frameRef, 'UIPanelCloseButton')
    closeButton:SetPoint('TOPRIGHT', frameRef, 'TOPRIGHT', -5, -5)

    local notice = frameRef:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
    notice:SetPoint('TOPLEFT', frameRef, 'TOPLEFT', 24, -52)
    notice:SetPoint('RIGHT', frameRef, 'RIGHT', -24, 0)
    notice:SetJustifyH('LEFT')
    notice:SetText(
        'If you find any bugs, please whisper Femboybaddie in-game or join our Discord:')

    local discordLink = CreateFrame('Button', nil, frameRef)
    discordLink:SetSize(285, 22)
    discordLink:SetPoint('TOPLEFT', notice, 'BOTTOMLEFT', 0, -2)
    discordLink:RegisterForClicks('LeftButtonUp')
    local discordLinkText = discordLink:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
    discordLinkText:SetAllPoints()
    discordLinkText:SetJustifyH('LEFT')
    discordLinkText:SetText('|cff5865F2https://discord.gg/ZfYDHV6Qgs|r')
    discordLink:SetScript('OnClick', function()
        StaticPopup_Show('DragonflightUIDiscordInvite')
    end)
    discordLink:SetScript('OnEnter', function()
        discordLinkText:SetText('|cffffffffhttps://discord.gg/ZfYDHV6Qgs|r')
    end)
    discordLink:SetScript('OnLeave', function()
        discordLinkText:SetText('|cff5865F2https://discord.gg/ZfYDHV6Qgs|r')
    end)

    local divider = frameRef:CreateTexture(nil, 'ARTWORK')
    divider:SetColorTexture(0.55, 0.42, 0.18, 0.75)
    divider:SetHeight(1)
    divider:SetPoint('TOPLEFT', frameRef, 'TOPLEFT', 24, -99)
    divider:SetPoint('RIGHT', frameRef, 'RIGHT', -24, 0)

    local scroll = CreateFrame('ScrollFrame', 'DragonflightUILunaChangelogScrollFrame', frameRef,
                               'UIPanelScrollFrameTemplate')
    scroll:SetPoint('TOPLEFT', frameRef, 'TOPLEFT', 24, -112)
    scroll:SetPoint('BOTTOMRIGHT', frameRef, 'BOTTOMRIGHT', -38, 24)

    local content = CreateFrame('Frame', nil, scroll)
    content:SetSize(595, 1)
    scroll:SetScrollChild(content)

    local changelogText = content:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    changelogText:SetPoint('TOPLEFT', content, 'TOPLEFT', 0, 0)
    changelogText:SetWidth(595)
    changelogText:SetJustifyH('LEFT')
    changelogText:SetJustifyV('TOP')
    changelogText:SetSpacing(4)
    changelogText:SetText(table.concat({
        '|cffffd200DragonflightUI_Luna V1.3 - 11 September 2026|r',
        '',
        '- Restored Action Bar 1 click access by disabling mouse input on empty Blizzard bar backgrounds.',
        '- Prevented duplicate Blizzard selection overlays for Luna-managed action bars, bags, stance, pet, possess and flight-path stop controls; kept these overlays non-interactive outside Edit Mode.',
        '- Fixed bag-bar snapping after login, loading screens and native layout callbacks, including cached callbacks; restored bag scale and keyring orientation and deferred combat-time repairs.',
        '- Kept chat position and size persistent through late native layout resets, login and loading screens; saved explicit moves and resizes without treating automatic resets as user changes, and preserved layouts whose coordinates match AceDB defaults.',
        '- Prevented stale deferred Edit Mode callbacks from reopening or hiding frames after rapid mode changes or loading-screen cleanup.',
        '- Deferred protected mover cleanup and flight-path button layout changes until combat ends, fixing the logged StopMovingOrSizing error.',
        '- Preserved native flight-path stop button events and visibility, restored its Luna anchor after native layout changes, and avoided displaying a second preview beside the real button.',
        '- Fixed the logged alternate mana-bar initialization error by detecting modern and legacy status-bar APIs and removing duplicate initialization.',
        '- Updated addon metadata and the in-game changelog to V1.3; synchronized the installed package with the repository copyright notice.',
        '- Added Lua 5.1 syntax checks and simulated regression coverage for layout persistence, input overlays, combat deferral, Edit Mode transitions and status-bar API compatibility.',
        '',
        '|cffffd200DragonflightUI_Luna V1.1 - 28 July 2026|r',
        '',
        '|cffffd200Combat and group safety|r',
        "- Removed insecure refreshes of Blizzard's protected pooled party and raid frames.",
        '- Fixed party members becoming untargetable after a member leaves.',
        '- Deferred secure action-bar, bag, unit-frame, and state-driver layout work until combat ends.',
        "- Split the full action-bar refresh across frames to prevent script-ran-too-long failures.",
        '',
        '|cffffd200Saved layout and visual stability|r',
        '- Added persistent chat position and size storage across /reload and loading screens.',
        "- Automatically saves chat moves made through Blizzard's chat controls or Edit Mode.",
        '- Stabilized player and pet frame scaling.',
        "- Prevented Blizzard's original cast bars from reappearing beside DragonflightUI cast bars.",
        '- Kept primary action buttons attached to their DragonflightUI mover.',
        '',
        '|cffffd200HUD Edit Mode|r',
        '- Restored missing action-bar and bottom-HUD selections for affected V1.0 profiles.',
        '- Added stronger white selection fills while keeping the normal Edit Mode world brightness.',
        '- Added a dedicated darker background only to the opened changelog panel.',
        '- Fixed Edit Mode startup and deferred-refresh errors.',
        '- Added the complete V1.1 release notes to the in-game changelog.',
        '',
        '|cffffd200Additional fixes|r',
        '- Added safe action-range color fallbacks.',
        '- Fixed invalid minimap ping units and minimap-button registration.',
        '',
        '|cffffd200DragonflightUI_Luna V1.0 - 24 July 2026|r',
        '',
        '|cffffd200Fork origin|r',
        '- Prepared DragonflightUI_Luna as an independently maintained fork of Dragonflight UI Classic.',
        '- Recorded the probable upstream base as Dragonflight UI Classic v0.40.3, commit b8b35451d4621a8097e887385f72ec03e17765f1.',
        '- Preserved the original MIT notice, Copyright (c) 2022 Karl-HeinzSchneider.',
        '- Added Copyright (c) 2026 Femboybaddie (modifications for DragonflightUI_Luna only).',
        '- No ownership is claimed over unchanged upstream code, bundled third-party libraries, Blizzard materials, or other inherited third-party content.',
        '',
        '|cffffd200Classic Era compatibility|r',
        '- Updated compatibility paths for current World of Warcraft Classic Era clients.',
        '- Repaired obsolete API usage and protected-frame handling affected by client changes.',
        '- Restored missing artwork references, icons, sharp text rendering, and pixel-aligned UI elements.',
        '',
        '|cffffd200HUD Edit Mode|r',
        '- Added the transparent Luna project logo as a non-interactive image in the upper-left corner while Edit Mode is active.',
        "- Integrated relevant DragonflightUI systems with Blizzard's Edit Mode window.",
        '- Restored selectable and movable action bars, bag bar, micro menu, experience and reputation bars, cast bars, buffs, debuffs, unit frames, and other HUD systems.',
        '- Added clearer selection areas, grid snapping, and center-alignment guides.',
        '- Prevented gameplay actions from passing through Edit Mode overlays.',
        '- Fixed overlapping values, duplicated labels, incorrect selection bounds, and asynchronous action-bar overlays.',
        '- Added startup and reload cleanup for hidden Edit Mode input layers.',
        '',
        '|cffffd200Action bars and bottom HUD|r',
        '- Reworked Classic Era action-bar registration, positioning, selection, and saved-layout restoration.',
        '- Fixed bars appearing outside the screen or shifting after /reload.',
        '- Corrected bag-bar layout, backpack sizing, micro-menu spacing, and bottom-right gaps.',
        '- Fixed experience-bar visibility and position restoration.',
        '',
        '|cffffd200Unit, party, and raid frames|r',
        '- Restored player, target, focus, pet, party, and raid-frame compatibility.',
        '- Fixed party and raid frames not appearing while grouped.',
        '- Corrected player power-bar layers, portrait artifacts, duplicate resource bars, and click regions.',
        '',
        '|cffffd200Combat UI|r',
        '- Fixed duplicated buff and debuff containers and restored their Edit Mode controls.',
        '- Restored cast-bar visuals, movement, selection bounds, and saved positions.',
        '- Improved frame update flow while entering or leaving Edit Mode.',
        '',
        '|cffffd200Publication preparation|r',
        '- Replaced copied upstream promotional text with an original DragonflightUI_Luna description.',
        '- Added THIRD_PARTY_NOTICES.md, CONTRIBUTORS.md, CURSEFORGE_DESCRIPTION.md, ASSET_PROVENANCE.md, and a generated asset hash manifest.',
        '- Removed the in-game donation link, supporter-benefit wording, and the unused coffee artwork.',
        "- Removed the upstream CurseForge project ID from DragonflightUI_Luna's TOC metadata to avoid false project association.",
        '- Added a distinct DragonflightUI_Luna project avatar and recorded its AI-generated origin.',
        '- Standardized the final distribution archive name as DragonflightUI_Luna.zip.',
        '- Retained third-party license files and copyright notices without shortening or relicensing them.',
        '- Added missing standard XML namespace declarations to the bundled LibTradeSkillRecipes loader without changing its loaded scripts.',
        '',
        '|cffffd200Feedback|r',
        '- Compatibility reports may be submitted through https://discord.gg/ZfYDHV6Qgs.'
    }, '\n'))
    content:SetHeight(math.max(scroll:GetHeight(), changelogText:GetStringHeight() + 16))

    frameRef.Title = title
    frameRef.Notice = notice
    frameRef.DiscordLink = discordLink
    frameRef.ScrollFrame = scroll
    frameRef.Content = content
    frameRef.DarkBackground = darkBackground
    frameRef:Hide()

    table.insert(UISpecialFrames, frameRef:GetName())
    self.ChangelogFrame = frameRef
    return frameRef
end

function Module:SetupChangelogButton()
    if self.ChangelogButton then return end

    local parent = self:IsBlizzardEditModeAvailable() and EditModeManagerFrame or self.EditModeFrame
    if not parent then return end

    local button = CreateFrame('Button', 'DragonflightUIEditModeChangelogButton', parent,
                               'UIPanelButtonTemplate')
    button:SetSize(185, 34)
    if self.DiscordButton then
        button:SetPoint('LEFT', self.DiscordButton, 'RIGHT', 8, 0)
    else
        button:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -8)
    end
    button:SetFrameLevel(parent:GetFrameLevel() + 20)
    button:SetClampedToScreen(true)
    button:RegisterForClicks('LeftButtonUp')

    local icon = button:CreateTexture(nil, 'ARTWORK')
    icon:SetTexture('Interface\\Icons\\INV_Misc_Book_09')
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    icon:SetSize(22, 22)
    icon:SetPoint('LEFT', button, 'LEFT', 8, 0)

    local label = button:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    label:SetPoint('LEFT', icon, 'RIGHT', 7, 0)
    label:SetPoint('RIGHT', button, 'RIGHT', -8, 0)
    label:SetJustifyH('LEFT')
    label:SetText('Show Changelog')

    button:SetScript('OnClick', function()
        local changelog = Module:CreateChangelogFrame()
        changelog:SetShown(not changelog:IsShown())
    end)
    button:SetScript('OnEnter', function(frame)
        GameTooltip:SetOwner(frame, 'ANCHOR_RIGHT')
        GameTooltip:AddLine('Show Changelog', 1, 1, 1)
        GameTooltip:AddLine('View DragonflightUI_Luna updates, compatibility fixes, and credits.', 0.8, 0.8, 0.8, true)
        GameTooltip:Show()
    end)
    button:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    button.Icon = icon
    button.Label = label
    self.ChangelogButton = button
end

function Module:IsBlizzardEditModeAvailable()
    return DF.Era and EditModeManagerFrame and type(EditModeManagerFrame.EnterEditMode) == 'function'
end

function Module:SetBlizzardEditMode(isEditMode)
    if not self:IsBlizzardEditModeAvailable() or self.SyncingBlizzardEditMode or InCombatLockdown() then return end

    local isShown = EditModeManagerFrame:IsShown()
    if isEditMode == isShown then return end

    self.SyncingBlizzardEditMode = true
    local ok, err = pcall(function()
        if isEditMode then
            ShowUIPanel(EditModeManagerFrame)
        else
            -- Let Blizzard's OnHide path run ExitEditMode exactly once. Calling
            -- ExitEditMode directly leaves its visible panel and mouse state
            -- behind on current Classic Era.
            HideUIPanel(EditModeManagerFrame)
        end
    end)
    self.SyncingBlizzardEditMode = false
    if not ok then error(err, 0) end
end

function Module:SetupBlizzardEditModeSync()
    if not self:IsBlizzardEditModeAvailable() or self.BlizzardEditModeSyncHooked then return end
    self.BlizzardEditModeSyncHooked = true

    hooksecurefunc(EditModeManagerFrame, 'EnterEditMode', function()
        if not Module.SyncingBlizzardEditMode and not Module.IsEditMode then Module:SetEditMode(true) end
    end)
    hooksecurefunc(EditModeManagerFrame, 'ExitEditMode', function()
        if not Module.SyncingBlizzardEditMode and Module.IsEditMode then Module:SetEditMode(false) end
    end)

    EditModeManagerFrame:HookScript('OnShow', function()
        if not Module.SyncingBlizzardEditMode and not Module.IsEditMode then Module:SetEditMode(true) end
    end)
    EditModeManagerFrame:HookScript('OnHide', function()
        if not Module.SyncingBlizzardEditMode and Module.IsEditMode then Module:SetEditMode(false) end
    end)
end

function Module:CombatHandler(preCombat)
    if preCombat then
        self.WasEditMode = self.IsEditMode

        if self.IsEditMode then
            self:Print('Combat started while in edit mode - deactivating until combat is over.')
            self:SetEditMode(false)
        end
    else
        if self.WasEditMode then
            self:Print('Combat ended - restoring edit mode.')
            self:SetEditMode(true)
            self.WasEditMode = false;
        end
    end
end

function Module:SetEditMode(isEditMode)
    DF:Debug(self, 'SetEditMode', isEditMode)

    if isEditMode and InCombatLockdown() then
        self:Print('HUD edit mode cannot be opened during combat.')
        return
    end

    Module.IsEditMode = isEditMode;

    -- Tear down every custom mouse surface before asking Blizzard to close its
    -- editor. This cleanup still runs if a third-party OnHide hook errors, so
    -- right-drag camera control cannot remain trapped behind an invisible
    -- Edit Mode frame.
    if not isEditMode then
        self:HideCustomEditModeSurfaces()
    end

    Module:SetBlizzardEditMode(isEditMode)

    -- Blizzard's editor already protects its action buttons and bag slots.
    -- Keep our fallback blocker only on clients without the native editor so
    -- its own selection frames remain fully clickable in the combined mode.
    if Module.InputBlocker then
        local shouldBlockInput = isEditMode and not Module:IsBlizzardEditModeAvailable()
        Module.InputBlocker:EnableMouse(shouldBlockInput)
        Module.InputBlocker:EnableMouseWheel(shouldBlockInput)
        Module.InputBlocker:SetShown(shouldBlockInput)
    end
    -- Era 1.15.9 supplies the complete Blizzard HUD Edit Mode window. Keep it
    -- as the single main editor window and add DragonflightUI's selectable
    -- systems around it; per-frame DragonflightUI options still open when a
    -- custom system is selected.
    if Module.EditModeFrame then
        Module.EditModeFrame:SetShown(isEditMode and not Module:IsBlizzardEditModeAvailable())
    end
    if Module.EditModeDimmer then Module.EditModeDimmer:SetShown(isEditMode) end
    if Module.LunaLogo then
        if isEditMode then
            Module.LunaLogo:Show()
        else
            Module.LunaLogo:Hide()
        end
    end

    Module:ApplySettings()

    if isEditMode then
        if not InCombatLockdown() then
            HideUIPanel(GameMenuFrame)
            HideUIPanel(SettingsPanel)
        end
    else
    end

    self.SelectedFrame = nil;
    if not isEditMode then self:HideAlignmentGuides() end
    self:TriggerEvent(self.Event.OnEditMode, isEditMode)
    if not isEditMode and Module.InputBlocker then Module.InputBlocker:Hide() end
end

function Module:AddEditModeToFrame(frameRef)
    if not frameRef then return end
    if frameRef.DFEditModeSelection then return frameRef.DFEditModeSelection end

    local f = CreateFrame('Frame', frameRef:GetName() .. '_DragonflightUIEditModeSelection', frameRef,
                          'DragonflightUIEditModeSystemSelectionTemplate')

    return f;
end

function Module:SelectFrame(frameRef)
    if frameRef and self.SelectedFrame == frameRef then
        -- already selected
    else
        DF:Debug(self, 'Module:SelectFrame(frameRef)', frameRef and frameRef:GetName())
        self.SelectedFrame = frameRef
        self:TriggerEvent(self.Event.OnSelection, frameRef)
    end
end

function Module:InitEditmodeOverride()
    -- print('InitEditmodeOverride')

    local LibEditModeOverride = LibStub("LibEditModeOverride-1.0");
    LibEditModeOverride:LoadLayouts();

    addonTable.LibEditModeOverride = LibEditModeOverride;

    local DFLayoutName = 'DragonflightUI_Layout'
    if not LibEditModeOverride:DoesLayoutExist(DFLayoutName) then
        --
        LibEditModeOverride:AddLayout(Enum.EditModeLayoutType.Character, DFLayoutName)
    end

    -- force edit profile - TODO?
    LibEditModeOverride:SetActiveLayout(DFLayoutName)

    -- if not LibEditModeOverride:CanEditActiveLayout() then
    --     --
    --     LibEditModeOverride:SetActiveLayout(DFLayoutName)
    -- end
    LibEditModeOverride:ApplyChanges()

    function addonTable:OverrideBlizzEditmode(f, ...)
        if not (LibEditModeOverride:GetActiveLayout() == DFLayoutName) then
            print('Wrong EditMode layout detected - please use ' .. DFLayoutName .. ' and /reload .')
            return;
        end
        LibEditModeOverride:ReanchorFrame(f, ...)

        if InCombatLockdown() then
            LibEditModeOverride:SaveOnly()
        else
            LibEditModeOverride:ApplyChanges()
        end
    end

    function addonTable:HookBlizzEditmodeAndFunc(fun, both)
        local lastUpdate = GetTime()

        EventRegistry:RegisterCallback("EditMode.Exit", function()
            -- print('EditMode.Exit', GetTime())
            local newUpdate = GetTime()

            if newUpdate > lastUpdate then
                lastUpdate = newUpdate;
                print('~> update')
                fun()
            end
        end)
        if both then
            EventRegistry:RegisterCallback("EditMode.Enter", function()
                -- print('EditMode.Enter')
                local newUpdate = GetTime()

                if newUpdate > lastUpdate then
                    lastUpdate = newUpdate;
                    print('~> update')
                    fun()
                end
            end)
        end
        fun()
    end

    function addonTable:GetBlizzEditmodeFrameSetting(f, setting)
        return LibEditModeOverride:GetFrameSetting(f, setting)
    end

    function addonTable:GetBlizzEditmodeFrameSettingBool(f, setting)
        local value = LibEditModeOverride:GetFrameSetting(f, setting)
        if value == 1 then
            return true;
        else
            return false;
        end
    end

    function addonTable:SetBlizzEditmodeFrameSetting(f, setting, value, saveOnly)
        LibEditModeOverride:SetFrameSetting(f, setting, value)

        if InCombatLockdown() or saveOnly then
            LibEditModeOverride:SaveOnly()
        else
            LibEditModeOverride:ApplyChanges()
        end
    end
end

function Module:GetEditmodeSettingValue(setting)
    local accountSettings = C_EditMode.GetAccountSettings()

    for k, v in ipairs(accountSettings) do if v.setting == setting then return v.value; end end

    return -1;
end

function Module:ShowEditmodeWarning(setting, value, str)
    if self:GetEditmodeSettingValue(setting) == value then return; end

    local valueStr = tostring(value);

    if value == 0 then
        valueStr = 'unchecked'
    elseif value == 1 then
        valueStr = 'checked'
    end

    local outputStr = string.format(
                          "Conflicting blizzard editmode setting found! Please enter the blizzard editmode and change setting |cff8080ff%s|r to |cff8080ff%s|r, or you risk game breaking issues.",
                          str, valueStr);

    C_Timer.After(5, function()
        DF:Print(outputStr)
    end)
end

function Module:Era()
end

function Module:TBC()
    self:InitEditmodeOverride()
end

function Module:Wrath()
end

function Module:Cata()
end

function Module:Mists()
end
