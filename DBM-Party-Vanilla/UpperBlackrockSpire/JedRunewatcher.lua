local mod	= DBM:NewMod("JedRunewatcher", "DBM-Party-Vanilla", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230903141716")
mod:SetCreatureID(10509)

mod:RegisterCombat("combat")
