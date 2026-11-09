---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

local DFPrefix = 'DragonflightUI'
local DFPlayer = UnitName('player')

local DFTimestamp = C_AddOns.GetAddOnMetadata('DragonflightUI', 'X-Date')
local newerVersionFound = false

local function ReadTimestamp(value)
    if type(value) ~= 'string' then return end
    return tonumber(value:match('^%d%d%d%d%d%d%d%d$'))
end

local DFTimestampNumber = ReadTimestamp(DFTimestamp)

function DF:InitVersionCheck()
    --  DF:Print('DF:InitVersionCheck()---------------')
    DF:RegisterComm(DFPrefix)

    -- DF:SendCommMessage(DFPrefix, 'TESTSSS', "WHISPER", UnitName("player"))
end

function DF:OnCommReceived(prefix, payload, distribution, sender)
    if prefix ~= DFPrefix or sender == DFPlayer or type(payload) ~= 'string' then return end
    -- print('OnCommReceived:', prefix, payload, distribution, sender)

    if payload == 'GIV VERSION' then
        --
        if DFTimestampNumber then
            DF:SendCommMessage(DFPrefix, 'DFTimestamp:' .. DFTimestamp, distribution, sender)
        end
        return
    end

    local k, v = strsplit(':', payload, 2)
    if k == 'DFTimestamp' then
        --   print('DFTimestamp', v)
        local timestamp = ReadTimestamp(v)
        if timestamp and DFTimestampNumber and timestamp > DFTimestampNumber and not newerVersionFound then
            --
            newerVersionFound = true
        end
    end
end
