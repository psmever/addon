
-- ---------------------------------------------------------------------
-- Getting Started

assert(LibStub, "LibIsClassic-1.0 requires LibStub")

local lib = LibStub:NewLibrary("LibIsClassic-1.0", 2)

if not lib then return end

local WOW_PROJECT_ID = _G.WOW_PROJECT_ID
local WOW_PROJECT_MAINLINE = _G.WOW_PROJECT_MAINLINE
local WOW_PROJECT_CLASSIC = _G.WOW_PROJECT_CLASSIC
local WOW_PROJECT_BURNING_CRUSADE_CLASSIC = _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local WOW_PROJECT_WRATH_CLASSIC = _G.WOW_PROJECT_WRATH_CLASSIC

-- ---------------------------------------------------------------------
-- Public API

function lib:IsRetail()
	-- One...
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function lib:IsClassic()
	-- Two...
	return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function lib:IsBurningCrusadeClassic()
	-- Five!
	return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function lib:IsWrathClassic()
	-- Kevin E. Levin?
	return WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
end

-- ---------------------------------------------------------------------
-- Embed Handling

lib.embeds = lib.embeds or {}

local mixins = { "IsRetail", "IsClassic", "IsBurningCrusadeClassic", "IsWrathClassic" }

function lib:Embed(target)
	for _, v in next, mixins do
		target[v] = lib[v]
	end
	lib.embeds[target] = true
	return target
end

for addon in next, lib.embeds do
	lib:Embed(addon)
end
