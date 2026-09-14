"""Run with Python + lupa (Lua 5.1); no WoW account or saved variables needed."""
from pathlib import Path
import sys
from lupa.lua51 import LuaRuntime

ROOT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]
lua = LuaRuntime(unpack_returned_tuples=True)
parse = lua.eval('function(s,n) local f,e=loadstring(s,n); return f~=nil,e end')
files = list(ROOT.rglob('*.lua'))
for path in files:
    ok, error = parse(path.read_text(encoding='utf-8-sig'), str(path))
    assert ok, error
print(f'PASS: Lua 5.1 syntax ({len(files)} files)')

def section(path, start, end):
    text = (ROOT / path).read_text(encoding='utf-8-sig')
    return text[text.index(start):text.index(end, text.index(start))]

lua.execute('''
combat = false
function InCombatLockdown() return combat end
queue = {}
C_Timer = {After = function(_, f) table.insert(queue, f) end}
function flush()
    local count = 0
    while #queue > 0 do
        count = count + 1
        assert(count < 100, 'layout callback loop')
        local f = table.remove(queue, 1); f()
    end
end
function hooksecurefunc(target, method, callback)
    if type(target) == 'string' then callback = method; method = target; target = _G end
    local old = target[method]
    target[method] = function(...) old(...); callback(...) end
end
function makeFrame(name)
    local f = {name=name, point={'BOTTOMLEFT',nil,'BOTTOMLEFT',42,35}, width=460, height=207,
               scripts={}, shown=true, scale=1, mouse=true}
    function f:GetName() return self.name end
    function f:GetPoint() return unpack(self.point) end
    function f:GetSize() return self.width, self.height end
    function f:SetPoint(...) self.point={...} end
    function f:ClearAllPoints() self.point={} end
    function f:SetSize(w,h) self.width=w; self.height=h end
    function f:SetWidth(w) self.width=w end
    function f:SetHeight(h) self.height=h end
    function f:SetScale(s) self.scale=s end
    function f:SetParent(p) self.parent=p end
    function f:GetParent() return self.parent end
    function f:SetUserPlaced(v) self.userPlaced=v end
    function f:HookScript(s,fn) self.scripts[s]=fn end
    function f:Show() local changed=not self.shown; self.shown=true; if changed and self.scripts.OnShow then self.scripts.OnShow(self) end end
    function f:Hide() local changed=self.shown; self.shown=false; if changed and self.scripts.OnHide then self.scripts.OnHide(self) end end
    function f:SetShown(v) if v then self:Show() else self:Hide() end end
    function f:IsShown() return self.shown end
    function f:EnableMouse(v) self.mouse=v end
    function f:StartMoving() end
    function f:StartSizing() end
    function f:StopMovingOrSizing() assert(not (combat and self.protected), 'protected move in combat') end
    function f:SetMovable(v) self.movable=v end
    return f
end
UIParent=makeFrame('UIParent')
ChatFrame1=makeFrame('ChatFrame1')
ChatFrame1.point[2]=UIParent
EditModeManagerFrame=makeFrame('EditModeManagerFrame'); EditModeManagerFrame.shown=false
function FCF_SavePositionAndDimensions() end
function FCF_StopDragging(f) f:StopMovingOrSizing(); FCF_SavePositionAndDimensions(f) end
defaults={profile={x=42,y=35,sizeX=460,sizeY=207}}
DF={Settings={ValidateFrame=function() return false end}}
Module={db={profile={x=42,y=35,sizeX=460,sizeY=207,anchorFrame='UIParent'}},WorldEntered=true}
function Module:ApplySettings() self:ApplySettingsInternal() end
''')
chat = 'Modules/Chat/Chat.lua'
lua.execute(section(chat, 'function Module:HasSavedLayout()', 'function Module:OnDisable()'))
lua.execute(section(chat, 'function Module:ApplySettingsInternal', 'function Module:SaveChatCommand'))
lua.execute(section(chat, 'function Module:ScheduleLayoutRestore()', "local frame = CreateFrame"))
lua.execute('''
-- A default-valued axis may be absent after AceDB serializes a profile.
Module.db.profile={x=88}; assert(Module:HasSavedLayout())
Module.db.profile={layoutSaved=true}; assert(Module:HasSavedLayout())
Module.db.profile={}; assert(not Module:HasSavedLayout())
Module.db.profile={x=90,y=110,sizeX=500,sizeY=220,anchorFrame='UIParent',layoutSaved=true}
Module:InstallLayoutHooks()
-- Late native resets must restore the saved layout without recapturing defaults.
ChatFrame1:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',0,0)
ChatFrame1:SetSize(300,100); FCF_SavePositionAndDimensions(ChatFrame1); flush()
assert(ChatFrame1.point[4]==90 and ChatFrame1.width==500 and Module.db.profile.x==90)
-- Normal tab dragging must win over pending restoration.
ChatFrame1:StartMoving(); ChatFrame1:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',177,99)
flush(); FCF_StopDragging(ChatFrame1); flush(); assert(Module.db.profile.x==177)
-- Native Edit Mode resizing and exit preserve the new layout.
EditModeManagerFrame:Show(); ChatFrame1:SetSize(640,260)
ChatFrame1:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',200,150)
EditModeManagerFrame:Hide(); flush()
assert(Module.db.profile.x==200 and Module.db.profile.sizeX==640)
-- Loading screens and combat cannot overwrite the saved point.
Module.WorldEntered=false; ChatFrame1:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',0,0); flush()
assert(Module.db.profile.x==200)
Module.WorldEntered=true; combat=true; Module:ScheduleLayoutRestore(); flush()
assert(Module.PendingLayoutRestore and ChatFrame1.point[4]==0)
combat=false; Module:ScheduleLayoutRestore(); flush(); assert(ChatFrame1.point[4]==200)
-- A profile containing only the explicit marker uses valid default dimensions.
Module.db.profile={layoutSaved=true}; Module:ApplySettings()
assert(ChatFrame1.width==460 and ChatFrame1.point[4]==42)
''')
print('PASS: chat default stripping, late resets, drag, native edit, loading, combat, defaults')

lua.execute('''
Module={db={profile={bags={scale=1,anchorFrame='UIParent',anchor='BOTTOMRIGHT',anchorParent='BOTTOMRIGHT',x=-30,y=60}}}}
DF.Era=true; DF.API={Version={IsTBC=false}}
DragonflightUIBagBar=makeFrame('DragonflightUIBagBar')
function DragonflightUIBagBar:UpdateStateHandler() end
MainMenuBarBackpackButton=makeFrame('MainMenuBarBackpackButton')
for i=0,3 do _G['CharacterBag'..i..'Slot']=makeFrame('CharacterBag'..i..'Slot') end
KeyRingButton=makeFrame('KeyRingButton')
function KeyRingButton:UpdateOrientation(horizontal) self.horizontal=horizontal end
Module.FrameBagToggle=makeFrame('Toggle')
function Module.BagBarExpandToggled() end
''')
action = 'Modules/Actionbar/Actionbar.lua'
# Select the next top-level function following UpdateBagState without assuming its name.
source = (ROOT/action).read_text()
start = source.index('function Module:QueueBagLayoutRestore()')
end = source.index('\nfunction ', source.index('function Module.UpdateBagState(state)', start) + 1)
lua.execute(source[start:end])
lua.execute(section(action, '    if DF.Era and not Module.BagAnchorHooksInstalled then', '\n    if DF.API.Version.IsTBC then\n        --\n        addonTable:OverrideBlizzEditmode',))
lua.execute('''
Module.UpdateBagState(Module.db.profile.bags); flush()
-- Simulate Blizzard's cached pre-hook Layout callback changing the buttons.
local function cachedNativeLayout()
    MainMenuBarBackpackButton:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',0,0)
    CharacterBag0Slot:SetScale(2)
    KeyRingButton:UpdateOrientation(false)
end
cachedNativeLayout(); flush()
assert(MainMenuBarBackpackButton.point[2]==DragonflightUIBagBar)
assert(CharacterBag0Slot.scale==1 and KeyRingButton.horizontal)
combat=true; cachedNativeLayout(); assert(Module.PendingBagState); flush()
combat=false; Module.UpdateBagState(Module.db.profile.bags); flush()
assert(MainMenuBarBackpackButton.point[2]==DragonflightUIBagBar)
''')
print('PASS: cached bag layout callbacks, child scale/orientation, combat retry, no callback loops')

lua.execute('''
EditModeModule={IsEditMode=false,callbacks={}}
function EditModeModule:RegisterCallback(_,fn) table.insert(self.callbacks,fn) end
useBlizzardSystemSelections=true
MainActionBar=makeFrame('MainActionBar'); MainActionBar.Selection=makeFrame('native selection')
MainMenuBarVehicleLeaveButton=makeFrame('leave'); MainMenuBarVehicleLeaveButton.Selection=makeFrame('taxi selection')
function EditModeManagerFrame:ShowSystemSelections() MainActionBar.Selection:Show() end
''')
block = section(action, '    if useBlizzardSystemSelections then', '\nfunction Module:RegisterOptionScreens()')
lua.execute(block.rsplit('\nend',1)[0])
lua.execute('''
assert(not MainActionBar.Selection.mouse and not MainActionBar.Selection.shown)
MainActionBar.Selection:Show(); assert(not MainActionBar.Selection.shown)
assert(not MainMenuBarVehicleLeaveButton.Selection.shown)
combat=true; MainActionBar.Selection:Show(); assert(Module.PendingNativeSelectionCleanup)
combat=false; Module.SuppressNativeSelections(); assert(not MainActionBar.Selection.shown)
''')
print('PASS: native selection suppression during gameplay, taxi selection, combat retry')

lua.execute('''
Module={SelectionFrames={}}
function Module:HideAlignmentGuides() end
local parent=makeFrame('secure mover'); parent.protected=true
local selection=makeFrame('selection'); selection.parent=parent; selection.StartMovable=true
Module.SelectionFrames={selection}
function GetCurrentKeyBoardFocus() end
function IsDragonflightUIKeyboardFocus() return false end
''')
lua.execute(section('Modules/Core/Editmode.lua', 'function Module:HideCustomEditModeSurfaces()', 'function Module:ResetInputStateAfterLoading()'))
lua.execute('''
combat=true; Module:HideCustomEditModeSurfaces(); assert(Module.PendingParentCleanup)
assert(not Module.SelectionFrames[1].mouse)
combat=false; Module:HideCustomEditModeSurfaces()
assert(Module.SelectionFrames[1].parent.movable)
''')
print('PASS: protected mover cleanup deferred until combat ends')

lua.execute('''
SubModuleMixin={state={scale=1.25,anchorFrame='UIParent',anchor='CENTER',anchorParent='CENTER',x=50,y=50}}
DragonflightUIVehicleLeaveButton=makeFrame('leave mover')
''')
lua.execute(section('Modules/Actionbar/VehicleLeaveButton.mixin.lua', 'function SubModuleMixin:Update()', 'function SubModuleMixin:CreateVehicleLeaveButton()'))
lua.execute('''
combat=true; SubModuleMixin:Update(); assert(SubModuleMixin.PendingUpdate)
combat=false; SubModuleMixin:Update()
assert(MainMenuBarVehicleLeaveButton.point[2]==DragonflightUIVehicleLeaveButton)
assert(MainMenuBarVehicleLeaveButton.scale==1.25)
''')
print('PASS: native taxi button anchoring and combat deferral')

lua.execute(section(action, "        for _, name in ipairs({'MainActionBar', 'MainMenuBar', 'BagsBar'}) do", '\n\n        -- Classic Era 1.15.9 moved XP'))
lua.execute('assert(not MainActionBar.mouse)')
print('PASS: empty native main action bar no longer consumes clicks')

lua.execute('''
EditModeModule={db={profile={advanced={Test=true}}}}
function EditModeModule:RegisterCallback(_,fn,owner) self.callback=function(v) fn(owner,v) end end
self=makeFrame('selection'); self.parent=makeFrame('mover'); self.AdvancedName='Test'
function self:ShowHighlighted() end
function self.parent:SetEditMode(v) self.finalEditMode=v end
''')
lua.execute(section('Mixin/Editmode.mixin.lua', "    EditModeModule:RegisterCallback('OnEditMode'", "    EditModeModule:RegisterCallback('OnSelection'"))
lua.execute('''
EditModeModule.callback(true); EditModeModule.callback(false); flush()
assert(self.parent.finalEditMode==false and not self.mouse)
EditModeModule.callback(true); self.EditModeGeneration=self.EditModeGeneration+1; flush()
assert(self.parent.finalEditMode==false)
''')
print('PASS: stale Edit Mode callbacks discarded after exit or loading cleanup')

init = section('Modules/Unitframe/Player.mixin.lua', '    local function AlternatePowerBar_OnLoad(self)', '    local function AlternatePowerBar_UpdateValue(self)')
lua.execute('''
function AlternatePowerBar_Initialize() end
modernCalls=0; legacyCalls=0
function TextStatusBar_Initialize() legacyCalls=legacyCalls+1 end
''')
lua.execute(init + '''
local modern={InitializeTextStatusBar=function() modernCalls=modernCalls+1 end}
AlternatePowerBar_OnLoad(modern)
assert(modernCalls==1 and legacyCalls==0)
AlternatePowerBar_OnLoad({}); assert(legacyCalls==1)
TextStatusBar_Initialize=nil; AlternatePowerBar_OnLoad({})
''')
print('PASS: modern, legacy and unavailable mana status-bar initialization APIs')

lua.execute('''
DF.db={global={}}
C_AddOns={GetAddOnMetadata=function() return '1.3.0' end}
Module={}
local popup=makeFrame('update notice'); popup.shown=false
popup.ScrollFrame={SetVerticalScroll=function() end}
function Module:CreateChangelogFrame() return popup end
''')
lua.execute(section('Modules/Core/Editmode.lua', 'function Module:ShowLoginUpdateNotice()', 'function Module:CreateChangelogFrame()'))
lua.execute('''
combat=true; Module:ShowLoginUpdateNotice()
assert(Module.PendingUpdateNotice and not DF.db.global.lastUpdateNoticeVersion)
combat=false; Module.IsEditMode=true; Module:ShowLoginUpdateNotice()
assert(not DF.db.global.lastUpdateNoticeVersion)
Module.IsEditMode=false; Module:ShowLoginUpdateNotice()
assert(Module:CreateChangelogFrame():IsShown() and DF.db.global.lastUpdateNoticeVersion=='1.3.0')
Module:CreateChangelogFrame():Hide(); Module:ShowLoginUpdateNotice()
assert(not Module:CreateChangelogFrame():IsShown())
DF.db.profile={}; Module:ShowLoginUpdateNotice()
assert(not Module:CreateChangelogFrame():IsShown())
DF.db.global.lastUpdateNoticeVersion='1.1.0'; Module:ShowLoginUpdateNotice()
assert(Module:CreateChangelogFrame():IsShown())
''')
print('PASS: update notice once per version/account, profile independence, combat/edit deferral')

lua.execute('''
Helper = {}
function CreateFrame()
    local f = makeFrame('event')
    function f:RegisterEvent() end
    function f:SetScript(event, fn) self.scripts[event] = fn end
    return f
end
function geometryFrame(name)
    local f = makeFrame(name)
    function f:GetScale() return self.scale end
    function f:GetNumPoints() return #self.point == 0 and 0 or 1 end
    return f
end
''')
lua.execute(section('Helper.lua', 'function Helper:KeepFrameAnchored(', 'function Helper:Benchmark('))
lua.execute('''
combat=false
local mover=geometryFrame('mover')
local native=geometryFrame('native')
Helper:KeepFrameAnchored(native,mover,1,UIParent)
native:SetPoint('TOPLEFT',UIParent,'TOPLEFT',40,-20)
native:SetScale(1.5); native:SetParent(mover); flush()
assert(native.point[2]==mover and native.point[1]=='CENTER')
assert(native.scale==1 and native.parent==UIParent)
combat=true
native:ClearAllPoints(); native:SetScale(2); flush()
assert(#native.point==0 and native.scale==2)
combat=false
native.DFLunaAnchorGuard.events.scripts.OnEvent(); flush()
assert(native.point[2]==mover and native.scale==1)
local replacement=geometryFrame('replacement')
native:SetPoint('TOPLEFT',UIParent,'TOPLEFT',0,0)
Helper:KeepFrameAnchored(native,replacement,0.8,UIParent); flush()
assert(native.point[2]==replacement and native.scale==0.8)
native:Hide(); flush(); assert(not native:IsShown())
native:Show(); flush(); assert(native.point[2]==replacement)
''')
print('PASS: native anchor/scale/parent resets, combat recovery, latest settings and native visibility')

lua.execute('''
PossessBarFrame=geometryFrame('possessMover')
NativePossessBar=geometryFrame('possessNative')
PossessActionBar=NativePossessBar
Module={db={profile={}}}
DF={Settings={ValidateFrame=function(name) return name and _G[name]~=nil end}}
function GetNumShapeshiftForms() return 0 end
''')
lua.execute(section('Modules/Actionbar/Actionbar.lua', 'function Module.UpdatePossesbarState(', '-- function Module:ActivateAllActionbars()'))
lua.execute('''
local state={anchorFrame='UIParent',anchor='BOTTOMLEFT',anchorParent='BOTTOMLEFT',x=90,y=120,scale=1.2}
Module.UpdatePossesbarState(state); flush()
assert(PossessBarFrame.point[4]==90 and NativePossessBar.point[2]==PossessBarFrame)
NativePossessBar:SetPoint('TOPLEFT',UIParent,'TOPLEFT',0,0); flush()
assert(NativePossessBar.point[2]==PossessBarFrame)
combat=true; state.x=240; Module.UpdatePossesbarState(state)
assert(Module.PendingPossessState and PossessBarFrame.point[4]==90)
combat=false; Module.UpdatePossesbarState(state); flush()
assert(not Module.PendingPossessState and PossessBarFrame.point[4]==240)
''')
print('PASS: modern possess bar follows mover, survives native resets and defers combat moves')

lua.execute('DragonflightUIRepBarMixin = {}')
lua.execute(section('Mixin/Statusbar.mixin.lua', 'function DragonflightUIRepBarMixin:OnLoad()', 'function DragonflightUIRepBarMixin:OnEvent('))
lua.execute('''
local rep=makeFrame('rep')
function rep:CreateBar() self:SetPoint('CENTER',UIParent,'CENTER',0,0) end
function rep:SetupTooltip() end
function rep:InitStateHandler() end
function rep:RegisterEvent() end
function rep:SetScript() end
function rep:OnEvent() assert(not self:IsShown(), 'reputation startup flash') end
function Mixin() end
DragonflightUIRepBarMixin.OnLoad(rep)
assert(not rep:IsShown())
''')
print('PASS: reputation bar stays hidden at its temporary startup center anchor')
