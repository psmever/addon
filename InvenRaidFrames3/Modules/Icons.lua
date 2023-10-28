local _G = _G
local pairs = _G.pairs
local ipairs = _G.ipairs
local ceil = _G.math.ceil
local sort = _G.table.sort
local twipe = _G.table.wipe
local tinsert = _G.table.insert
local IRF3 = _G[...]

local iconTable = { TOPLEFT = {}, TOP = {}, TOPRIGHT = {}, LEFT = {}, CENTER = {}, RIGHT = {}, BOTTOMLEFT = {}, BOTTOM = {}, BOTTOMRIGHT = {} }
local relPoint = { TOPLEFT = "TOPRIGHT", TOPRIGHT = "TOPLEFT", LEFT = "RIGHT", RIGHT = "LEFT", BOTTOMLEFT = "BOTTOMRIGHT", BOTTOMRIGHT = "BOTTOMLEFT" }
local iconOrder = {
	--bossAura = 0,
	roleIcon = 1,
	leaderIcon = 2,
	raidIcon1 = 3,
	raidIcon2 = 4,
	buffIcon1 = 5,
	buffIcon2 = 6,
	buffIcon3 = 7,
	buffIcon4 = 8,
	debuffIcon1 = 9,
	debuffIcon2 = 10,
	debuffIcon3 = 11,
	debuffIcon4 = 12,
	debuffIcon5 = 13,
	debuffIcon6 = 14,
	debuffIcon7 = 15,
	debuffIcon8 = 16,
	debuffIcon9 = 17,
	debuffIcon10 = 18,
	looterIcon = 19
}
local centerIndex

local posTableDefault = {
	bossAura = { "bossAuraPos", "CENTER" },
	roleIcon = { "roleIconPos", "TOPLEFT" },
	leaderIcon = { "leaderIconPos", "TOPLEFT" },
	raidIcon1 = { "raidIconPos", "TOPLEFT" },
	healIcon = { "healIconPos", "BOTTOMLEFT" },
	debuffIcon1 = { "debuffIconPos", "TOPRIGHT" },
	buffIcon1 = { "buffIconPos", "LEFT" },
	looterIcon = { "looterIconPos", "TOPLEFT" }
}
posTableDefault.raidIcon2 = posTableDefault.raidIcon1
posTableDefault.debuffIcon2 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon3 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon4 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon5 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon6 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon7 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon8 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon9 = posTableDefault.debuffIcon1
posTableDefault.debuffIcon10 = posTableDefault.debuffIcon1
posTableDefault.buffIcon2 = posTableDefault.buffIcon1
posTableDefault.buffIcon3 = posTableDefault.buffIcon1
posTableDefault.buffIcon4 = posTableDefault.buffIcon1


local function addIcon(self, icon, pos)

	local leaderIconPos
	if self[icon] then
		self[icon]:ClearAllPoints()

		if not pos or not iconTable[pos] then
			if posTableDefault[icon] then
				self.optionTable[posTableDefault[icon][1]] =  posTableDefault[icon][2]
				pos = posTableDefault[icon][2]
			else

				pos = "CENTER"
			end
		end

		if iconOrder[icon] and (icon ~= "looterIcon")then

			tinsert(iconTable[pos], icon)
		else
			if icon == "looterIcon" then
 
 		 		if pos=="RIGHT" or pos=="TOPRIGHT" or pos =="BOTTOMRIGHT" then

					self[icon]:SetPoint(pos,-IRF3.db.units.leaderIconSize , 0)

				else
					self[icon]:SetPoint(pos, IRF3.db.units.leaderIconSize , 0)
				end

			else

				self[icon]:SetPoint(pos, 0, 0)
			end 
		end
	end
end

local function sortIcon(a, b)
	if iconOrder[a] and iconOrder[b] then
		if iconOrder[a] == iconOrder[b] then
			return a < b
		else
			return iconOrder[a] < iconOrder[b]
		end
	elseif iconOrder[a] then
		return true
	elseif iconOrder[b] then
		return false
	else
		return a < b
	end
end

local function fixPoint(point)
	if point == "CENTERLEFT" then
		return "LEFT"
	elseif point == "CENTERRIGHT" then
		return "RIGHT"
	else
		return point
	end
end

local function debug(self, ...)
	if self == IRF3.headers[0].members[1] then
		print(...)
	end
end

function InvenRaidFrames3Member_SetupIconPos(self)
 
	addIcon(self, "bossAura", IRF3.db.units.bossAuraPos)
	addIcon(self, "roleIcon", IRF3.db.units.roleIconPos)
	addIcon(self, "leaderIcon", IRF3.db.units.leaderIconPos)
	addIcon(self, "looterIcon", IRF3.db.units.looterIconPos)
	
	addIcon(self, "raidIcon1", IRF3.db.units.raidIconPos)
	addIcon(self, "raidIcon2", IRF3.db.units.raidIconPos) 




	addIcon(self, "healIcon", IRF3.db.units.healIconPos)
	addIcon(self, "debuffIcon1", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon2", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon3", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon4", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon5", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon6", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon7", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon8", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon9", IRF3.db.units.debuffIconPos)
	addIcon(self, "debuffIcon10", IRF3.db.units.debuffIconPos)
	addIcon(self, "buffIcon1", IRF3.db.units.buffIconPos)
	addIcon(self, "buffIcon2", IRF3.db.units.buffIconPos)
	addIcon(self, "buffIcon3", IRF3.db.units.buffIconPos)
	addIcon(self, "buffIcon4", IRF3.db.units.buffIconPos)
	for i = 1, 15 do

		addIcon(self, "spellTimer"..i, InvenRaidFrames3CharDB.spellTimer[i].pos)

	end
 

	for pos, tbl in pairs(iconTable) do

		if #tbl == 0 then
			-- noting
		elseif #tbl == 1 then
			self[tbl[1]]:SetPoint(pos, 0, 0)
		elseif relPoint[pos] then

			for i, icon in ipairs(tbl) do
				if i == 1 then
					self[icon]:SetPoint(pos, 0, 0)
				else
					self[icon]:SetPoint(pos, self[tbl[i - 1]], relPoint[pos], 0, 0)
				end
			end
		elseif #tbl % 2 == 0 then

			centerIndex = #tbl / 2
			sort(tbl, sortIcon)
			for i, icon in ipairs(tbl) do

				if i == centerIndex then
					self[icon]:SetPoint(fixPoint(pos.."RIGHT"), self, pos, 0, 0)
				elseif i == (centerIndex + 1) then
					self[icon]:SetPoint(fixPoint(pos.."LEFT"), self, pos, 0, 0)
				elseif i < centerIndex then
					self[icon]:SetPoint(fixPoint(pos.."RIGHT"), self[tbl[i + 1]], fixPoint(pos.."LEFT"), 0, 0)
				else
					self[icon]:SetPoint(fixPoint(pos.."LEFT"), self[tbl[i - 1]], fixPoint(pos.."RIGHT"), 0, 0)
				end
			end
		else

			centerIndex = ceil(#tbl / 2)
			sort(tbl, sortIcon)
			for i, icon in ipairs(tbl) do

					if i < centerIndex then
						self[icon]:SetPoint(fixPoint(pos.."RIGHT"), self[tbl[i + 1]], fixPoint(pos.."LEFT"), 0, 0)
					elseif i > centerIndex then
						self[icon]:SetPoint(fixPoint(pos.."LEFT"), self[tbl[i - 1]], fixPoint(pos.."RIGHT"), 0, 0)
					else
						self[icon]:SetPoint(pos, 0, 0)
					end

			end
		end
		twipe(tbl)
	end
--임시>>옵션:설정화면에서 주문타이머 설정 변경시, 이미 활성화되어 있던 주문타이머의 위치를 꼬이게한다. 주문타이머의 위치정보가 정확하므로 다시 호출(향후 Icon소스에서 주문타이머위치를 정확히 잡아두도록 수정해야함)
InvenRaidFrames3Member_UpdateSpellTimer(self)
end