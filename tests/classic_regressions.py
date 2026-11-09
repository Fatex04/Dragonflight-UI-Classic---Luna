"""Focused Classic regressions; Python + lupa (Lua 5.1), no game account required."""
from pathlib import Path
import unittest

from lupa.lua51 import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]


def section(path, start, end):
    source = (ROOT / path).read_text(encoding='utf-8-sig')
    first = source.index(start)
    return source[first:source.index(end, first)]


class PlayerTooltips(unittest.TestCase):
    def boot(self, before=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(r'''
            Module = {db={profile={general={unitClassBorder=true,
                backdropBorderAlpha=0.7, unitClassName=true, unitRealm=true,
                unitGuild=true}}}}
            DF = {}
            function DF:GetClassColor(className)
                assert(className == 'MAGE', 'missing player class')
                return 0.25, 0.78, 0.92, 1, 'ff40c7eb'
            end
            function DF:GetClassColoredText(text, className)
                assert(className == 'MAGE')
                return '|cff40c7eb' .. text .. '|r'
            end
            function Module:UpdateStatusbar(unit) self.healthUnit=unit end
            function Module:HideLines() end
            function Module:HideLine() end
            function Module:GetLine(tip, index)
                self.guildLine={}
                function self.guildLine:SetTextColor(...) self.color={...} end
                function self.guildLine:SetFormattedText(pattern, ...) self.text=pattern:format(...) end
                return self.guildLine
            end
            function Module:AddUnitLine(tip, unit, index) self.unitLine=index end
            function Module:AddLocationLine() end
            function Module:GrayOutOnDeath() end
            UnitClass=function() return 'Mage', 'MAGE', 8 end
            UnitName=function() return 'Luna', 'OtherRealm' end
            UnitPVPName=function() return 'Archmage Luna' end
            GameTooltip_UnitColor=function() return 0, 1, 0 end
            UnitIsAFK=function() return false end
            UnitIsDND=function() return false end
            UnitIsConnected=function() return true end
            GetGuildInfo=function() return guildName, 'Member', 0 end
            UnitIsInMyGuild=function() return false end
            UnitIsSameServer=function() return true end
            UnitIsFriend=function() return true end
            LEVEL, FACTION_ALLIANCE, FACTION_HORDE, PVP = 'Level','Alliance','Horde','PvP'
            tip={}
            function tip:GetUnit() return 'Luna', 'mouseover' end
            function tip:GetName() return 'TestTooltip' end
            function tip:SetBackdropBorderColor(...) self.border={...} end
            function tip:SetBackdropColor(...) self.backdrop={...} end
            function tip:AppendText(text) self.appended=text end
            TestTooltipTextLeft1={SetText=function(self,text) self.text=text end}
        ''')
        lua.execute(section('Modules/Tooltip/Tooltip.lua', 'function Module:UnitPlayerTooltip(',
                            'function Module:GetZone('))
        lua.execute(before)
        return lua

    def test_player_class_color_and_name_options_run_without_a_global_class(self):
        lua = self.boot()
        lua.execute('Module:UnitPlayerTooltip(tip)')
        self.assertEqual(list(lua.eval('tip.border').values()), [0.25, 0.78, 0.92, 0.7])
        self.assertEqual(lua.eval('TestTooltipTextLeft1.text'), '|cff40c7ebLuna (OtherRealm)|r')
        self.assertEqual(lua.eval('Module.unitLine'), 2)

    def test_hidden_guild_does_not_leave_an_empty_guild_row(self):
        lua = self.boot("guildName='TestGuild'; Module.db.profile.general.unitGuild=false")
        lua.execute('Module:UnitPlayerTooltip(tip)')
        self.assertEqual(lua.eval('Module.unitLine'), 2)

    def test_unavailable_unit_class_is_safe_even_with_an_unrelated_global(self):
        lua = self.boot("class='some other addon'; UnitClass=function() return nil end")
        lua.execute('Module:UnitPlayerTooltip(tip)')
        self.assertIsNone(lua.eval('TestTooltipTextLeft1.text'))

    def test_visible_guild_keeps_its_row(self):
        lua = self.boot("guildName='TestGuild'")
        lua.execute('Module:UnitPlayerTooltip(tip)')
        self.assertEqual(lua.eval('Module.guildLine.text'), '<TestGuild>')
        self.assertEqual(lua.eval('Module.unitLine'), 3)

    def test_title_and_plain_name_options_are_respected(self):
        lua = self.boot('''
            Module.db.profile.general.unitTitle=true
            Module.db.profile.general.unitRealm=false
            Module.db.profile.general.unitClassName=false
        ''')
        lua.execute('Module:UnitPlayerTooltip(tip)')
        self.assertEqual(lua.eval('TestTooltipTextLeft1.text'), 'Archmage Luna')


class ChannelTicks(unittest.TestCase):
    def boot(self, flavor, missing=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute('DF={API={Version={}}}; Module={}; DragonFlightUICastbarMixin={}')
        lua.execute({
            'era': 'DF.Era=true',
            'tbc': 'DF.API.Version.IsTBC=true',
            'wrath': 'DF.Wrath=true',
            'cata': 'DF.Cata=true; DF.Wrath=true',
        }[flavor])
        lua.execute('''
            GetSpellInfo=function(id)
                if missingSpells and missingSpells[id] then return nil end
                if missingAll then return nil end
                if id==5143 or id==5144 or id==5145 then return 'Arcane Missiles' end
                return 'Spell ' .. id
            end
        ''')
        lua.execute(missing)
        lua.execute(section('Modules/Castbar/Castbar.lua', 'Module.ChannelTicks =',
                            'function Module.AddNewCastbar('))
        lua.execute(section('Mixin/Castbar.mixin.lua', 'function DragonFlightUICastbarMixin:GetTickCount(',
                            'function DragonFlightUICastbarMixin:SetShowTicks('))
        lua.execute('bar={showTicks=true,tickTable=Module.ChannelTicks}')
        return lua

    def test_unavailable_sod_spells_cannot_abort_era_castbar_loading(self):
        lua = self.boot('era', 'missingSpells={[402174]=true,[413259]=true,[401417]=true,[412510]=true}')
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Spell 689',689)"), 5)

    def test_tbc_channels_and_arcane_missile_ranks_have_markers(self):
        lua = self.boot('tbc')
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Spell 689',689)"), 5)
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Arcane Missiles',5143)"), 3)
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Arcane Missiles',5144)"), 4)
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Arcane Missiles',5146)"), 5)

    def test_missing_spell_cache_can_still_use_spell_ids(self):
        lua = self.boot('era', 'missingAll=true')
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Drain Life',689)"), 5)

    def test_modern_spell_name_api_is_supported_for_rank_fallbacks(self):
        lua = self.boot('tbc', "C_Spell={GetSpellInfo=function(id) return {name='Spell '..id} end}; GetSpellInfo=nil")
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Spell 689',11699)"), 5)

    def test_existing_era_wrath_cata_tick_counts_are_preserved(self):
        for flavor, spell_id, expected in [('era', 413259, 2), ('wrath', 48045, 5), ('cata', 47540, 2)]:
            with self.subTest(flavor=flavor):
                lua = self.boot(flavor)
                self.assertEqual(lua.eval(f"DragonFlightUICastbarMixin.GetTickCount(bar,'Spell {spell_id}',{spell_id})"), expected)
        lua = self.boot('cata')
        self.assertIsNone(lua.eval('Module.ChannelTicks["Spell 5138"]'))
        self.assertIsNone(lua.eval('Module.ChannelTicks["Spell 1510"]'))
        lua.execute('bar.showTicks=false')
        self.assertEqual(lua.eval("DragonFlightUICastbarMixin.GetTickCount(bar,'Spell 689',689)"), 0)


class ClassicSeasons(unittest.TestCase):
    def boot(self, interface, setup=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute('''
            DF={API={}}; L={}
            LibStub=function(name)
                if name=='AceAddon-3.0' then return {GetAddon=function() return DF end} end
                return {GetLocale=function() return L end}
            end
            WOW_PROJECT_MAINLINE=1; WOW_PROJECT_CLASSIC=2
            WOW_PROJECT_BURNING_CRUSADE_CLASSIC=5; WOW_PROJECT_WRATH_CLASSIC=11
            WOW_PROJECT_CATACLYSM_CLASSIC=14; WOW_PROJECT_MISTS_CLASSIC=19
        ''')
        lua.execute(f"GetBuildInfo=function() return 'test','build','date',{interface} end")
        lua.execute(setup)
        lua.execute((ROOT / 'API/Version.API.lua').read_text(encoding='utf-8-sig'))
        return lua

    def test_missing_season_api_does_not_abort_any_supported_classic_flavor(self):
        for interface, project in [(11509, 2), (20505, 5), (30405, 11), (40402, 14), (50503, 19)]:
            with self.subTest(interface=interface):
                lua = self.boot(interface, f'WOW_PROJECT_ID={project}')
                self.assertEqual(lua.eval('DF.API.Version.SeasonID'), 0)
                self.assertFalse(lua.eval('DF.API.Version.IsSoD'))

    def test_active_sod_is_still_detected(self):
        lua = self.boot(11509, '''
            WOW_PROJECT_ID=2; Enum={SeasonID={SeasonOfDiscovery=2}}
            C_Seasons={HasActiveSeason=function() return true end, GetActiveSeason=function() return 2 end}
        ''')
        self.assertTrue(lua.eval('DF.API.Version.IsSoD'))
        self.assertEqual(lua.eval('DF.API.Version.SeasonID'), 2)

    def test_missing_season_enum_or_incomplete_api_is_safe(self):
        for setup in ("C_Seasons={HasActiveSeason=function() return true end}",
                      "C_Seasons={HasActiveSeason=function() return true end,GetActiveSeason=function() return 2 end}"):
            with self.subTest(setup=setup):
                lua = self.boot(11509, 'WOW_PROJECT_ID=2; ' + setup)
                self.assertFalse(lua.eval('DF.API.Version.IsSoD'))


class VersionMessages(unittest.TestCase):
    def boot(self, metadata="'20261109'"):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute('''
            DF={sent={}}
            LibStub=function() return {GetAddon=function() return DF end} end
            UnitName=function() return 'Luna' end
            function DF:RegisterComm(prefix) self.prefix=prefix end
            function DF:SendCommMessage(...) self.sent[#self.sent+1]={...} end
            function strsplit(separator, value)
                assert(type(value)=='string', 'invalid communication payload')
                local first,last=value:find(separator,1,true)
                if first then return value:sub(1,first-1),value:sub(last+1) end
                return value
            end
        ''')
        lua.execute(f'C_AddOns={{GetAddOnMetadata=function() return {metadata} end}}')
        lua.execute((ROOT / 'Version.lua').read_text(encoding='utf-8-sig'))
        return lua

    def test_malformed_version_broadcasts_do_not_raise_lua_errors(self):
        lua = self.boot()
        for value in ('nil', '42', '{}', "'DFTimestamp'", "'DFTimestamp:'", "'DFTimestamp:broken'"):
            with self.subTest(payload=value):
                lua.execute(f"DF:OnCommReceived('DragonflightUI',{value},'PARTY','Other-Realm')")
        self.assertEqual(lua.eval('#DF.sent'), 0)

    def test_missing_local_date_does_not_break_requests_or_updates(self):
        lua = self.boot('nil')
        lua.execute("DF:OnCommReceived('DragonflightUI','GIV VERSION','PARTY','Other-Realm')")
        lua.execute("DF:OnCommReceived('DragonflightUI','DFTimestamp:20261110','PARTY','Other-Realm')")
        self.assertEqual(lua.eval('#DF.sent'), 0)

    def test_valid_legacy_requests_keep_the_same_wire_format_and_scope(self):
        lua = self.boot()
        lua.execute("DF:InitVersionCheck(); DF:OnCommReceived('DragonflightUI','GIV VERSION','PARTY','Other-Realm')")
        self.assertEqual(lua.eval('DF.prefix'), 'DragonflightUI')
        self.assertEqual(list(lua.eval('DF.sent[1]').values()),
                         ['DragonflightUI', 'DFTimestamp:20261109', 'PARTY', 'Other-Realm'])

    def test_unrelated_prefixes_and_own_messages_are_ignored(self):
        lua = self.boot()
        lua.execute("DF:OnCommReceived('OtherAddon','GIV VERSION','PARTY','Other-Realm')")
        lua.execute("DF:OnCommReceived('DragonflightUI','GIV VERSION','PARTY','Luna')")
        self.assertEqual(lua.eval('#DF.sent'), 0)


if __name__ == '__main__':
    unittest.main(verbosity=2)
