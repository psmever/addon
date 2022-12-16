local _G = _G
local next = _G.next
local pairs = _G.pairs
local ipairs = _G.ipairs
local select = _G.select
local tinsert = _G.table.insert
local wipe = _G.wipe
local UnitBuff = _G.UnitBuff
local GetSpellInfo = _G.GetSpellInfo
local IsSpellKnown = _G.IsSpellKnown
local UnitIsPlayer = _G.UnitIsPlayer
local UnitInVehicle = _G.UnitInVehicle
local IRF3 = _G[...]
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")

if not UnitInVehicle then
	UnitInVehicle = function(unit) return false end
end

IRF3.raidBuffData = {}

function InvenRaidFrames3Member_UpdateBuffs()

end

function IRF3:SetupClassBuff()

	self.SetupClassBuff = nil
	InvenRaidFrames3CharDB.classBuff = nil
	InvenRaidFrames3CharDB.classBuff2 = type(InvenRaidFrames3CharDB.classBuff2) == "table" and InvenRaidFrames3CharDB.classBuff2 or {}

end

local playerClass = select(2, UnitClass("player"))

local classRaidBuffs = ({
	WARRIOR = {
		[6673] = { 1 },		-- [전사] 전투의 외침 (Legit 8.0)
	},
	ROGUE = {
	},
	PRIEST = {
		[21562] = { 2 },	-- 신의 권능: 인내 (Legit 8.0)
	},
	MAGE = {
		[1459] = { 3 },		-- 신비한 총명함 (Legit 8.0)
	},
	WARLOCK = {
	},
	HUNTER = {
	},
	DRUID = {
	},
	SHAMAN = {
	},
	PALADIN = {
	},
	DEATHKNIGHT = {
	},
	MONK = {
	},
	DEMONHUNTER = {
	},
})[playerClass]

local classicClassRaidBuff = ({
	WARRIOR = {
--		[2048] = { 1 },		-- [전사] 전투의 외침 2048
		[6673] = { 1 },		-- [전사] 전투의 외침 6673

	},
	ROGUE = {
	},
	PRIEST = {
		[1243] = { 2 },	-- 신의 권능: 인내 1244 1245 2791 10937 10938
--~ 		[21562] = { 2 },	-- 인내의 기원 21564
		[14752] = { 7 },	-- 천상의 정신
--~ 		[27681] = { 7 },	-- 정신력의 기원
		[976] = { 8 } , --암흑보호의 기원
	},
	MAGE = {
		[1459] = { 3 },		-- 신비한 지능
--~ 		[23028] = { 3 },		-- 신비한 총명함 (Legit 8.0)
	},
	WARLOCK = {
	},
	HUNTER = {
	},
	DRUID = {
		[1126] = { 5 },	-- 야생의 징표
--~ 		[21849] = { 5 },	-- 야생의 선물
		[467] = { 6 },		-- [드루이드] 가시
	},
	SHAMAN = {
	},
	PALADIN = {
		[1022]  = { 4 },	-- 보호의 축복 +
		[1038]  = { 4 },	-- 구원의 축복
		[1044]  = { 4 },	-- 자유의 축복
		[6940]  = { 4 },	-- 희생의 축복 +
		[19740] = { 4 },	-- 힘의 축복 +
		[19742] = { 4 },	-- 지혜의 축복 +
		[19977]  = { 4 },	-- 빛의 축복 +
		[20217]  = { 4 },	-- 왕의 축복 +
		[20911]  = { 4 },	-- 성역의 축복 +
--~ 		[25782] = { 4 },	-- 상급 힘의 축복 +
--~ 		[25890]  = { 4 },	-- 상급 빛의 축복 +
--~ 		[25894] = { 4 },	-- 상급 지혜의 축복 +
--~ 		[25895]  = { 4 },	-- 상급 구원의 축복
--~ 		[25898] = { 4 },	-- 상급 왕의 축복 +
--~ 		[25899]  = { 4 },	-- 상급 성역의 축복 +
	},
	DEATHKNIGHT = {

	},
	MONK = {
	},
	DEMONHUNTER = {
	},
})[playerClass]

local classicClassRaidBuffWOTLK = ({
	WARRIOR = {
--		[2048] = { 1 },		-- [전사] 전투의 외침 2048
		[6673] = { 1 },		-- [전사] 전투의 외침 6673
		[469] = {1}, 		-- [전사] 지휘의 외침

	},
	ROGUE = {
	},
	PRIEST = {
		[1243] = { 2 },	-- 신의 권능: 인내 1244 1245 2791 10937 10938
--~ 		[21562] = { 2 },	-- 인내의 기원 21564
		[14752] = { 7 },	-- 천상의 정신
--~ 		[27681] = { 7 },	-- 정신력의 기원
		[976] = { 8 } , --암흑보호의 기원
	},
	MAGE = {
		[1459] = { 3 },		-- 신비한 지능

--~ 		[23028] = { 3 },		-- 신비한 총명함 (Legit 8.0)
	},
	WARLOCK = {
	},
	HUNTER = {
	},
	DRUID = {
		[1126] = { 5 },	-- 야생의 징표
--~ 		[21849] = { 5 },	-- 야생의 선물
		[467] = { 6 },		-- [드루이드] 가시
	},
	SHAMAN = {
	},
	PALADIN = {
--		[1022]  = { 4 },	-- 보호의 손길로 변경
--		[1038]  = { 4 },	-- 구원의 손길로 변경
--		[1044]  = { 4 },	-- 자유의 손길로 변경
--		[6940]  = { 4 },	-- 희생의 손길로 변경
		[19740] = { 4 },	-- 힘의 축복 +
		[19742] = { 4 },	-- 지혜의 축복 +
--		[19977]  = { 4 },	-- 빛의 축복.리분에서 삭제
		[20217]  = { 4 },	-- 왕의 축복 +
		[20911]  = { 4 },	-- 성역의 축복 +
--~ 		[25782] = { 4 },	-- 상급 힘의 축복 +
--~ 		[25890]  = { 4 },	-- 상급 빛의 축복 +
--~ 		[25894] = { 4 },	-- 상급 지혜의 축복 +
--~ 		[25895]  = { 4 },	-- 상급 구원의 축복
--~ 		[25898] = { 4 },	-- 상급 왕의 축복 +
--~ 		[25899]  = { 4 },	-- 상급 성역의 축복 +
	},
	DEATHKNIGHT = {
		[57330]={ 1 }, -- [죽기] 겨울의 뿔피리
	},
	MONK = {
	},
	DEMONHUNTER = {
	},
})[playerClass]


if IRF3.isClassic then
	wipe(classRaidBuffs)
	if IRF3.isWOTLK then
		classRaidBuffs = classicClassRaidBuffWOTLK
	else

		classRaidBuffs = classicClassRaidBuff
	end
end

if not classRaidBuffs then return end

local raidBuffs = {
	-- 전투력
	[1] = {
		6673,		-- [전사] 전투의 외침 (Legit 8.0)
	},
	-- 체력
	[2] = {
		21562,		-- [사제] 신의 권능: 인내 (Legit 8.0)
	},
	-- 지능
	[3] = {
		1459,		-- [마법사] 신비한 총명함 (Legit 8.0)
	},
--~ 	-- 왕축
--~ 	[4] = {
--~ 		203538,		-- [성기사] 상급 왕의 축복
--~ 	},
--~ 	-- 지축
--~ 	[5] = {
--~ 		203539,		-- [성기사] 상급 지혜의 축복
--~ 	},
}

local classicRaidBuffs = {

	-- 전투력
	[1] = {
		6673,		-- [전사] 전투의 외침 (Legit 8.0)

	},
	-- 체력
	[2] = {
		1243,		-- [사제] 신의 권능: 인내 (Legit 8.0)
--~  		21562,		-- [사제] 인내의 기원
	},
	-- 지능
	[3] = {
		1459,		-- [마법사] 신비한 지능
--~ 		23028,		-- [마법사] 신비한 총명함 (Legit 8.0)
	},
	-- 왕축
	[4] = {
		1022,		-- [성기사] 보호의 축복
		1038,		-- [성기사] 구원의 축복
		1044,		-- [성기사] 자유의 축복
		6940,		-- [성기사] 희생의 축복
		19740,	-- [성기사] 힘의 축복
		19742,	-- [성기사] 지혜의 축복
		19977,	-- [성기사] 빛의 축복
		20217,	-- [성기사] 왕의 축복
		20911,	-- [성기사] 성역의 축복
--~ 		25782,	-- [성기사] 상급 힘의 축복
--~ 		25890,	-- [성기사] 상급 빛의 축복
--~ 		25894,	-- [성기사] 상급 지혜 축복
--~ 		25895,	-- [성기사] 상급 구원 축복
--~ 		25898,	-- [성기사] 상급 왕의 축복
--~ 		25899,	-- [성기사] 상급 성역 축복
	},
	-- 야징
	[5] = {
		1126,		-- [드루이드] 야생의 징표
--~ 		21849,		-- [드루이드] 야생의 선물
	},
	[6] = {
		467,		-- [드루이드] 가시
	},
	[7] = {
		14752,		-- [사제] 천상의 정신
--~  		27681,		-- [사제] 정신력의 기원
	},
	[8] = {
		976, 		-- [사제] 암흑보호
		27683, 		-- [사제] 암흑보호 기원
	}
}


local classicRaidBuffsWOTLK = {

	-- 전투력
	[1] = {
		6673,		-- [전사] 전투의 외침 (Legit 8.0)
		469, 		-- [전사] 지휘의 외침
--		5242,
	},
	-- 체력
	[2] = {
		1243,		-- [사제] 신의 권능: 인내 (Legit 8.0)
--~  		21562,		-- [사제] 인내의 기원
	},
	-- 지능
	[3] = {
		1459,		-- [마법사] 신비한 지능
--~ 		23028,		-- [마법사] 신비한 총명함 (Legit 8.0)
	},
	-- 왕축
	[4] = {
--		1022,		-- [성기사] 보호의 손길
--		1038,		-- [성기사] 구원의 손길
--		1044,		-- [성기사] 자유의 손길
--		6940,		-- [성기사] 희생의 손길
		19740,	-- [성기사] 힘의 축복
		19742,	-- [성기사] 지혜의 축복
--		19977,	-- [성기사] 빛의 축복 --리분에서 삭제
		20217,	-- [성기사] 왕의 축복
		20911,	-- [성기사] 성역의 축복
--~ 		25782,	-- [성기사] 상급 힘의 축복
--~ 		25890,	-- [성기사] 상급 빛의 축복
--~ 		25894,	-- [성기사] 상급 지혜 축복
--~ 		25895,	-- [성기사] 상급 구원 축복
--~ 		25898,	-- [성기사] 상급 왕의 축복
--~ 		25899,	-- [성기사] 상급 성역 축복
	},
	-- 야징
	[5] = {
		1126,		-- [드루이드] 야생의 징표
--~ 		21849,		-- [드루이드] 야생의 선물
	},
	[6] = {
		467,		-- [드루이드] 가시
	},
	[7] = {
		14752,		-- [사제] 천상의 정신
--~  		27681,		-- [사제] 정신력의 기원
	},
	[8] = {
		976, 		-- [사제] 암흑보호
		27683, 		-- [사제] 암흑보호 기원
	},
	[9] = {
		57330,		-- [죽음의기사] 겨울의 뿔피리
	}
}

if IRF3.isClassic then
	wipe(raidBuffs)
 
	if IRF3.isWOTLK then
		raidBuffs = classicRaidBuffsWOTLK
	else

		raidBuffs = classicRaidBuffs	
	end

end

local sameBuffs = {
	--[1459] = 61316,	-- 신비한 총명함 = 달라란의 총명함
}

local classicSameBuffs = {
	[1243] = 21562, -- 인내
	[14752] = 27681, -- 정신
	[976] = 27683, -- 암흑 보호
	[1459] = 23028, -- 지능
	[1126] = 21849, -- 야생
	[19740] = 25782, -- 힘
	[19977] = 25890, -- 빛
	[19742] = 25894, -- 지혜
	[1038] = 25895, -- 구원
	[20217] = 25898, -- 왕
	[20911] = 25899, -- 성역


		  [5242] = 6673,
		  [6192] = 6673,
		  [11549] = 6673,
		  [11550] = 6673,
		  [11551] = 6673,
		  [25289] = 6673,
		  [2048] = 6673,
		[47439] = 469, -- 지휘
		[47440] = 469,

	--[1459] = 61316,	-- 신비한 총명함 = 달라란의 총명함
}

local classicSameBuffsWOTLK = {
	[1243] = 21562, -- 인내
	[14752] = 27681, -- 정신
	[976] = 27683, -- 암흑 보호
	[1459] = 23028, -- 지능
	[1126] = 21849, -- 야생
	[19740] = 25782, -- 힘
--	[19977] = 25890, -- 빛
	[19742] = 25894, -- 지혜
--	[1038] = 25895, -- 구원
	[20217] = 25898, -- 왕
	[20911] = 25899, -- 성역


		  [5242] = 6673,
		  [6192] = 6673,
		  [11549] = 6673,
		  [11550] = 6673,
		  [11551] = 6673,
		  [25289] = 6673,
		  [2048] = 6673,

		[47439] = 469, -- 지휘
		[47440] = 469,

		[61024] = 61316, -- 달라란의 지능 = 달라란의 총명함
--  [1459] = 61316,	-- 신비한 총명함 = 달라란의 총명함
}


if IRF3.isClassic then
	wipe(sameBuffs)


	if IRF3.isWOTLK then
		sameBuffs = classicSameBuffsWOTLK
	else
		sameBuffs = classicSameBuffs
	end
	
end

IRF3.raidBuffData = {
	same = sameBuffs,
	link = {
		--[469] = 6673,		-- 지휘의 외침 = 전투의 외침
		--[20217] = 19740,	-- 왕의 축복 = 힘의 축복
	},
}

local linkRaidBuffs = {}

local raidBuffInfo = {}

local function addRaidBuff(tbl, spellId, isClassBuff)
	local spellName, _, spellIcon = GetSpellInfo(spellId)
	if spellName then
		if isClassBuff then
			for _, v in ipairs(tbl) do
				if v.id == spellId then
					return true
				end
			end
		end
		tinsert(tbl, {
			id = spellId,
			name = spellName,
			--rank = spellRank,
			icon = spellIcon,
			passive = IsPassiveSpell(spellId)
		})
 
		raidBuffInfo[spellId] = tbl[#tbl]
		return true
	end
	return nil
end

for i, spellIds in pairs(raidBuffs) do
	local n = {}
	for _, spellId in ipairs(spellIds) do
		addRaidBuff(n, spellId)
	end
	raidBuffs[i] = n
end


for spellId, mask in pairs(classRaidBuffs) do

	for _, i in ipairs(mask) do

		if #raidBuffs[i] > 0 and addRaidBuff(raidBuffs[i], spellId, true) and not raidBuffInfo[spellId].passive then

			if sameBuffs[spellId] then
				addRaidBuff(raidBuffs[i], sameBuffs[spellId], true)
			end
		else
			classRaidBuffs[spellId] = nil
			sameBuffs[spellId] = nil
			break
		end
	end
end

if not next(classRaidBuffs) then return end

local currentRaidBuffs, checkMask, buffCnt, buff, buff2 = {}, {}, 0

local function showBuffIcon(icon, texture)

	icon:SetSize(IRF3.db.units.buffIconSize, IRF3.db.units.buffIconSize)
	icon:SetTexture(texture)
	icon:Show()
end

local function hideBuffIcon(icon)
	icon:SetSize(0.001, 0.001)
	icon:Hide()
end

local function getBuff(unit, spellId,filter)
local higherspellId
--print("----------------")
--print(sameBuffs[spellId])
--print(raidBuffInfo[sameBuffs[spellId]].name)

if not filter then 
	filter="HELPFUL"
end 
 

--	if raidBuffInfo[spellId] and InvenRaidFrames3Member_UnitAura(raidBuffInfo[spellId].name, unit, "HELPFUL") then
--	if raidBuffInfo[spellId] and InvenRaidFrames3Member_UnitAura(raidBuffInfo[spellId].name, unit, filter) then
	if raidBuffInfo[spellId] and AuraUtil.FindAuraByName(raidBuffInfo[spellId].name, unit, filter) then

		if classRaidBuffs[spellId] then
		for _, i in ipairs(classRaidBuffs[spellId]) do
			checkMask[i] = raidBuffInfo[spellId]
		end
		end

	elseif IRF3.isClassic and sameBuffs[spellId] and raidBuffInfo[sameBuffs[spellId]] and AuraUtil.FindAuraByName(raidBuffInfo[sameBuffs[spellId]].name, unit, filter) then

		if classRaidBuffs[spellId] then
		for _, i in ipairs(classRaidBuffs[spellId]) do
			checkMask[i] = raidBuffInfo[sameBuffs[spellId]]
			higherspellId=sameBuffs[spellId]
		end
		end




	--달라란의 지능/총명함 보강
	elseif playerClass=="MAGE" and spellId==1459 and (AuraUtil.FindAuraByName(L["달라란의 지능"], unit, filter) or AuraUtil.FindAuraByName(L["달라란의 총명함"], unit, filter)) then
		if classRaidBuffs[spellId] then
		for _, i in ipairs(classRaidBuffs[spellId]) do
			checkMask[i] = raidBuffInfo[sameBuffs[spellId]]
			higherspellId=sameBuffs[spellId]
		end
		end
 
	else


		if classRaidBuffs[spellId] and not IRF3.isClassic then

		for _, i in ipairs(classRaidBuffs[spellId]) do
			if checkMask[i] == nil then

				checkMask[i] = false
				for _, v in ipairs(raidBuffs[i]) do
					if AuraUtil.FindAuraByName(v.name, unit) then -- , v.rank
						checkMask[i] = v
						break
					end
				end
				if checkMask[i] == false then
					spellId = nil
					break
				end
			elseif checkMask[i] == false then

				spellId = nil
				break
			end
		end
		else
			
			spellId=nil
			higherspellId=nil
		end

	end
	return spellId, higherspellId

end

local function isMyParty(arg1, arg2)
	if not arg1 or not arg2 then
		return true
	end
	if select(3, GetRaidRosterInfo(arg1)) == select(3, GetRaidRosterInfo(arg2)) then
		return true
	end
	return false
end

InvenRaidFrames3Member_UpdateBuffs = function(self, isFullUpdate, updatedAuras)

local buff,higherspellId 
--local paladinplayerbuffed = false
--local warriorplayerbuffed = false
local playerbuffed = false --통합

if isFullUpdate ~= nil then 
--print("Buff UNIT_AURA_check:")
--print(isFullUpdate)
end


	if not UnitIsPlayer(self.displayedUnit) or UnitInVehicle(self.displayedUnit) then 
		hideBuffIcon(self["buffIcon1"])
		hideBuffIcon(self["buffIcon2"])
		hideBuffIcon(self["buffIcon3"])
		hideBuffIcon(self["buffIcon4"])
		return 
	end

	local isMyParty = (not IRF3.isClassic) or (IRF3.isClassic and IRF3.isWOTLK )  or (playerClass ~= "WARRIOR") or isMyParty(UnitInRaid("player"), UnitInRaid(self.displayedUnit))	-- 클래식 전사 외침 파티만 적용

	
	-- 걸러버리면 버프표시가 안되어있을 때 버프 주문이 들어오기전까지 안걸려있다고 표시를 못해줌.
	if not isFullUpdate and updatedAuras then
		local isFindSpell = false

		for i = 1, updatedAuras and #updatedAuras or 0 do	-- 자신의 공대 버프가 아니면 패스

			if updatedAuras[i].isHelpful == true then
				for spellId in pairs(currentRaidBuffs) do
					if updatedAuras[i].spellId == spellId then
						isFindSpell = true
						break
					end
				end
				if isFindSpell then
					break
				end
			end
		end		
		if isFindSpell == false then
			return
		end
	end


	wipe(checkMask)
	buffCnt = 0

--기사이고 버프가 없을떄 표시조건이면 --> 자기가 건 축복이 하나라도 있으면 나머지는 없어도 표시않함(하나밖에 못거니까)
--전사이고 버프가 없을때 표시조건이면-->자기가 건 전투/지휘가 하나라도 있으면 나머지는 없어도 표시안함(하나밖에 못거니까)
if playerClass=="PALADIN" or playerClass=="WARRIOR"  then
	for spellId in pairs(currentRaidBuffs) do
 
		if  playerbuffed ==false then-- and (InvenRaidFrames3CharDB.classBuff2[spellId] == 1 or InvenRaidFrames3CharDB.classBuff2[spellId] == 3 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]]==1 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]] ==3 ) then
 
--전투8레벨이 와서 인식안됨(2048) -->same buff로직 타줘야함
--지휘1레벨이 오면 인식됨(469)-->same buff로직 타줘야함

		 buff,higherspellId = getBuff(self.displayedUnit, spellId, "PLAYER")

			if buff then --본인이 건 버프가 하나라도 있으면 break
				playerbuffed= true
				break

			elseif sameBuffs[spellId] then --없으면 samebuff라도 체크, 하나라도 있으면 break
				buff,higherspellId = getBuff(self.displayedUnit, sameBuffs[spellId], "PLAYER")

				if buff then
					playerbuffed = true
					break
				end
			end

		end
	end

end

 

	for spellId in pairs(currentRaidBuffs) do
	buff,higherspellId = getBuff(self.displayedUnit, spellId)

		if not isMyParty then

--1:버프없을때, 2:버프있을떄, 3(구버전)자신의 버프가 없을때, 4(구버전)자신의 버프가 있을때
		elseif InvenRaidFrames3CharDB.classBuff2[spellId] == 1 or InvenRaidFrames3CharDB.classBuff2[spellId] == 3 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]]==1 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]] ==3 then
			-- 버프가 없을 때 표시

			if not buff and playerbuffed==false  then

				buffCnt = buffCnt + 1
				if raidBuffInfo[spellId] then

					showBuffIcon(self["buffIcon"..buffCnt], raidBuffInfo[spellId].icon)
				else
					showBuffIcon(self["buffIcon"..buffCnt], raidBuffInfo[sameBuffs[spellId]].icon)
				end
			end
		elseif InvenRaidFrames3CharDB.classBuff2[spellId] == 2 or InvenRaidFrames3CharDB.classBuff2[spellId] == 4 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]]==2 or InvenRaidFrames3CharDB.classBuff2[sameBuffs[spellId]] == 4 then

			-- 버프가 있을 때 표시

			if buff then
				buffCnt = buffCnt + 1


--상급/일반 축복아이콘구분
				if higherspellId then --상급주문을 사용한 경우라면 상급아이콘을 사용
					_,_,higherspellIcon = GetSpellInfo(higherspellId)
					showBuffIcon(self["buffIcon"..buffCnt], higherspellIcon)
 
				else

 					if raidBuffInfo[spellId] then

						showBuffIcon(self["buffIcon"..buffCnt], raidBuffInfo[spellId].icon)
					else

						showBuffIcon(self["buffIcon"..buffCnt], raidBuffInfo[sameBuffs[spellId]].icon)
					end
				end

--				showBuffIcon(self["buffIcon"..buffCnt], raidBuffInfo[spellId].icon)
			end
		else--버프체크 안할떄
 	
		
		end
		if buffCnt == 4 then return end
	end

	for i = buffCnt + 1, 4 do
		hideBuffIcon(self["buffIcon"..i])
	end
end

local function updateClassBuff()

	wipe(currentRaidBuffs)
	wipe(linkRaidBuffs)

	for spellId, mask in pairs(classRaidBuffs) do


 

		if IsPlayerSpell(spellId) then
			currentRaidBuffs[spellId] = mask
		else

			for nextSpellId, sameId in pairs(sameBuffs) do


				if IsPlayerSpell(nextSpellId) and sameId==spellId then


					currentRaidBuffs[nextSpellId] = mask
					break
				end
			end
		end


	end
	for a, b in pairs(IRF3.raidBuffData.link) do
		if currentRaidBuffs[a] and currentRaidBuffs[b] then
			linkRaidBuffs[a] = b
			currentRaidBuffs[a] = nil
			currentRaidBuffs[b] = nil
		end
	end
	if not IRF3.SetupClassBuff then

		for _, header in pairs(IRF3.headers) do
			for _, member in pairs(header.members) do
				if member:IsVisible() then

					InvenRaidFrames3Member_UpdateBuffs(member)
				end
			end
		end
	end
end

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", updateClassBuff)

if wowtocversion and wowtocversion > 90000 then
	handler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	handler:RegisterEvent("PLAYER_TALENT_UPDATE")
end
handler:RegisterEvent("PLAYER_ENTERING_WORLD")
handler:RegisterEvent("LEARNED_SPELL_IN_TAB")

function IRF3:SetupClassBuff()
	self.SetupClassBuff = nil
	InvenRaidFrames3CharDB.classBuff = nil
	InvenRaidFrames3CharDB.classBuff2 = type(InvenRaidFrames3CharDB.classBuff2) == "table" and InvenRaidFrames3CharDB.classBuff2 or {}
	for spellId in pairs(InvenRaidFrames3CharDB.classBuff2) do
		if not classRaidBuffs[spellId] then
			InvenRaidFrames3CharDB.classBuff2[spellId] = nil
		end
	end
	for spellId in pairs(classRaidBuffs) do
--달라란의 축복,달라란의 총명함 예외 처리(61024, 61316)
		if raidBuffInfo[spellId].passive and not (spellId==61024 or spellId ==61316) then
			InvenRaidFrames3CharDB.classBuff2[spellId] = nil
		elseif InvenRaidFrames3CharDB.classBuff2[spellId] ~= 0 and InvenRaidFrames3CharDB.classBuff2[spellId] ~= 1 and InvenRaidFrames3CharDB.classBuff2[spellId] ~= 2 and not (spellId==61024 or spellId ==61316) then
			if spellId == 203538 or spellId == 203539 then	-- 성기사 예외 처리
				InvenRaidFrames3CharDB.classBuff2[spellId] = 2
			else
				InvenRaidFrames3CharDB.classBuff2[spellId] = 1
			end
		end
	end
	updateClassBuff()
end