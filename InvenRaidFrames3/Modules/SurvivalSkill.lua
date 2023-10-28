local _G = _G
local pairs = _G.pairs
local GetTime = _G.GetTime
local UnitBuff = _G.UnitBuff
local IRF3 = _G[...]
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
-- 직업별 생존기 정의 (*는 타인에게 걸 수 있는 생존기)
local SL = IRF3.GetSpellName
local skills = {	-- 7.2.5
	["WARRIOR"] = { [SL(871)] = L["lime_survival_방벽"], [SL(12975)] = L["lime_survival_최저"],  [SL(23920)] = L["lime_survival_주반"] },
	["ROGUE"] = { [SL(5277)] = L["lime_survival_회피"], [SL(31224)] = L["lime_survival_그망"], [SL(1966)] = L["lime_survival_교란"], [SL(11327)] = L["lime_survival_소멸"]},
	["PALADIN"] = { [SL(642)] = L["lime_survival_무적"], [SL(498)] = L["lime_survival_가호"], [SL(31850)] = L["lime_survival_헌수"], [SL(31821)] = L["lime_survival_오숙"], [SL(64205)] =L["lime_survival_성희"] ,[SL(70940)]=L["lime_survival_천수"] },
	["MAGE"] = { [SL(45438)] = L["lime_survival_얼방"], [SL(32612)] = L["lime_survival_투명"]},
	["HUNTER"] = { [SL(5384)] = L["lime_survival_죽척"],[SL(19263)] = L["lime_survival_저지"] },
	["PRIEST"] = { [SL(27827)] = L["lime_survival_구원"], [SL(47585)] = L["lime_survival_분산"], [SL(586)] = L["lime_survival_소실"], [SL(64843)]=L["lime_survival_찬가"]},--, [SL(25222)]="renew"},
	["DRUID"] = { [SL(61336)] = L["lime_survival_생본"], [SL(22812)] = L["lime_survival_껍질"], [SL(22842)] = L["lime_survival_광포"] },	-- , [SL(200851)] = "분노"
	["DEATHKNIGHT"] = { [SL(48707)] = L["lime_survival_대보"], [SL(48792)] = L["lime_survival_얼인"], [SL(51271)] = L["lime_survival_불굴"], [SL(49039)] = L["lime_survival_리치"], [SL(55233)] = L["lime_survival_흡혈"] }, -- , [SL(207319)] = "시체", [SL(194844)] = "뼈폭" 
	["SHAMAN"] = { [SL(30823)] = L["lime_survival_주분"] },
	["WARLOCK"] = {  },
--	["MONK"] = { [SL(115203)] = "강화", [SL(120954)] = "강화", [SL(243435)] = "강화", [SL(201318)] = "강화", [SL(122783)] = "마해", [SL(122278)] = "해악", [SL(122470)] = "업보", [SL(213664)] = "민활", [SL(115176)] = "명상", [SL(328682)] = "명상"},
--	["DEMONHUNTER"] = { [SL(187827)] = "탈태", [SL(196555)] = "황천", [SL(198589)] = "흐릿", [SL(263648)] = "영방" },--, [SL(218256)] = "강화"
	["*"] = {  [SL(1022)] = L["lime_survival_보축"], [SL(47788)] = L["lime_survival_수호"], [SL(33206)] = L["lime_survival_고억"], [SL(6940)] = L["lime_survival_희축"],  [SL(29166)] = L["lime_survival_자극"] },
	["POTION"] = { [SL(53908)]="속도",[SL(53909)]="마폭",[SL(307162)] = "지능", [SL(307164)] = "힘", [SL(307159)] = "민첩", [SL(322302)] = "희물", [SL(307161)] = "총명", [SL(307494)] = "퇴마", [SL(307497)] = "집착", [SL(307495)] = "도깨", [SL(307163)] = "체력", [SL(307496)] = "각성", [SL(307195)] = "투물" },
	["SUB"] = { [SL(203720)] = "쐐기",  [SL(215479)] = "무쇠",  [SL(65116)] = "석화" }
}
--공대 생존기급 아이콘 표시할것 : 방벽/최저/속도/마폭/그망/소멸/얼방/보축/고억/희축/생본/껍질/대보/얼인/불굴/흡혈

if IRF3.isClassic then

	
	wipe(skills["POTION"])
	skills["POTION"] = { [SL(53908)]=L["Survival_속도"], [SL(53909)]=L["Survival_마폭"], [SL(28507)] = L["Survival_가속"], [SL(28508)] = L["Survival_파괴"], [SL(28506)] = L["Survival_영웅"], [SL(28726)] = L["Survival_씨앗"], [SL(3680)] = L["Survival_하투"], [SL(11392)] = L["lime_survival_투명"], [SL(4079)] = L["Survival_은폐"] }
	
	wipe(skills["SUB"])
	skills["SUB"] = {  [SL(20594)] = L["Survival_석화"], [SL(7744)] = L["Survival_포세"] }
	
	
end

local checkSpellID = {
	[SL(86659)] = 86659, -- 고대 왕의 수호자(보호 특성)
}
local ignoreEndTime = { [SL(5384)] = true, [SL(122278)] = true }
for _, v in pairs(skills) do
	v[""] = nil
end
ignoreEndTime[""] = nil
checkSpellID[""] = nil


function survivalSkillOnUpdate(self)

	if self.survivalSkillEndTime  then
		self.survivalSkillTimeLeft = (":%d"):format(self.survivalSkillEndTime - GetTime() + 0.5)
 
	end
	InvenRaidFrames3Member_UpdateLostHealth(self)--이름 프레임 업데이트
end

function addSurvivalSkill(self, spellKey, skillShortName, endTime)

	 

	self.survivalSkillKey = spellKey
	self.survivalSkill = skillShortName
	self.survivalSkillEndTime = endTime
	self.survivalSkillTimeLeft = self.survivalSkillEndTime and (self.survivalSkillEndTime - GetTime()) or ""
	if spellKey and not self.survivalticker then
		self.survivalticker = C_Timer.NewTicker(0.5, function() survivalSkillOnUpdate(self) end)
	end
end

function initSurvivalSkill(self)
	if self.survivalticker then
		self.survivalticker:Cancel()
		self.survivalticker = nil
	end
	self.survivalSkillKey, self.survivalSkill, self.survivalSkillEndTime, self.survivalSkillTimeLeft  = nil, nil, nil, nil 
end

local function allCheckSkill(unit, class)
	local findSpellInfoMain = {}
	local findSpellInfoClass = {}
	local findSpellInfoSub = {}
	local findSpellInfoPotion = {}

	IRF3:ForEachAura(unit, "HELPFUL", nil, 
		function(name, _, _, _, _, endTime,caster,_,_,spellId)

			if findSpellInfoMain.spellKey or findSpellInfoClass.spellKey or findSpellInfoSub.spellKey or findSpellInfoPotion.spellKey then  return end


			local spellKey = name
			if spellKey then
				if skills["*"][spellKey] then	-- 1순위가 찾아지면 바로 리턴
					findSpellInfoMain.spellKey = spellKey
					findSpellInfoMain.shortName = skills["*"][spellKey]
					findSpellInfoMain.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return true
				elseif class and skills[class][spellKey]     then	-- pet은 class 가 nil로 올때가 있다

				if  class=="PRIEST" and spellId==64844 then return end --사제의 찬가버프중 리필되는 버프는 제외

--캔슬성희->천수로 표기
--성희(or 성희+천수) =>성희로 표기
--무적+성희(or 무적+성희+천수) -> 무적성희로 별도 표기

				if class=="PALADIN" then--성기사일땐 성희때문에 별도 처리(start)
					if (spellId~=64205 and spellId ~=70940   ) or ((spellId==64205  or spellId==70940   ) and endTime and endTime > 0)  then   --endTime으로 본인의 성희인지, 타인의 성희인지 판단 (start)

						if spellId==70940 then --천수가 먼저 검색되었을떄에는, 무적이나 성희가 동시에 있는지 체크.
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(64205),unit,"HELPFUL") --성희 

							if name2 then  --성희가 있으면, 천수대신 성희를 표기

								name3,_,_,_,_,endTime3 = AuraUtil.FindAuraByName(SL(642),unit,"HELPFUL")--무적(천상의 보호막)
								if name3 then --무적/성희/천수가 모두 있으면 그냥 무적성희로 표기
									findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
				 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
									findSpellInfoClass.endTime = (endTime2 and endTime3 and endTime2<endTime3) and endTime2 or endTime3--짧은 잔여시간으로 표기
									return true
								end

								if findSpellInfoClass.spellKey then return true end

								--성희/천수만 있으면 성희로 표기
								findSpellInfoClass.spellKey = name2
			 					findSpellInfoClass.shortName = skills[class][name2]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return true
							end
							if findSpellInfoClass.spellKey then return true end
						end

						if findSpellInfoClass.spellKey then return true end

						--성희가 먼저 검색되었을때는 (천수는 기본이니), 무적이 동시에 있는지 체크

						if spellId==64205 then 
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(642),unit,"HELPFUL")

							if name2 then  --무적이 있으면, 성희 대신 무적성희로 표기
						
								findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
			 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return true
							end
							if findSpellInfoClass.spellKey then return true end
						end
						if findSpellInfoClass.spellKey then return true end


						--무적이 먼저 검색되었을때는 , 성희가 동시에 있는지 체크
						if spellId==642  then 
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(64205),unit,"HELPFUL")--성희
			
							if name2 and endTime2 and endTime2>0 then  --성희가 있으면, 무적 대신 무적성희로 표기(본인의 성희만)

								findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
			 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return true
							end
							if findSpellInfoClass.spellKey then return true end
						end

						if findSpellInfoClass.spellKey then return true end
 
						findSpellInfoClass.spellKey = spellKey
	 					findSpellInfoClass.shortName = skills[class][spellKey]
						findSpellInfoClass.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime

						return true

					end--성기사일땐 성희때문에 별도 처리(end)

				else--성기사 아닌 클래스는 표준 처리

						findSpellInfoClass.spellKey = spellKey
	 					findSpellInfoClass.shortName = skills[class][spellKey]
						findSpellInfoClass.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime

						return true


				end

				elseif IRF3.db.units.showSurvivalSkillSub and skills["SUB"][spellKey] then

					findSpellInfoSub.spellKey = spellKey
					findSpellInfoSub.shortName = skills["SUB"][spellKey]
					findSpellInfoSub.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return true
				elseif IRF3.db.units.showSurvivalSkillPotion and skills["POTION"][spellKey] then

					findSpellInfoPotion.spellKey = spellKey
					findSpellInfoPotion.shortName = skills["POTION"][spellKey]
					findSpellInfoPotion.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return true
				end


				return true
			end

			return false
		end
	)

	

	if findSpellInfoMain.spellKey then
		return findSpellInfoMain.spellKey, findSpellInfoMain.shortName, findSpellInfoMain.endTime
	elseif findSpellInfoClass.spellKey then
		return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime
	elseif findSpellInfoSub.spellKey then
		return findSpellInfoSub.spellKey, findSpellInfoSub.shortName, findSpellInfoSub.endTime
	elseif findSpellInfoPotion.spellKey then
		return findSpellInfoPotion.spellKey, findSpellInfoPotion.shortName, findSpellInfoPotion.endTime
	end

	return nil
end

function InvenRaidFrames3Member_AllUpdateSurvivalSkill(self)
	if IRF3.db.units.useSurvivalSkill then
		local spellKey, skillShortName, endTime = allCheckSkill(self.displayedUnit, self.class)
-- print(spellkey,skillShortName,endTime)
		addSurvivalSkill(self, spellKey, skillShortName, endTime)
		survivalSkillOnUpdate(self)
 
	else
		initSurvivalSkill(self)
	end
	InvenRaidFrames3Member_UpdateLostHealth(self)--이름 프레임 업데이트
end

local function findSkill(unit, spellShortName, spellKey)

	local name, _, _, _, _, endTime, _, _, _, spellId = AuraUtil.FindAuraByName(spellKey, unit, "HELPFUL")

	if name and ( not (name ==L["가속"] and spellId~=28507)) then --가속버프명이 너무 많아서
		return "show", spellShortName, (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
	else
		return "hide", spellShortName, nil
	end
	
	
	
	
	
	
	
end

local function checkSkill(unit, class, spellKey, spellName)
	local isFind, spellShortName, endTime = nil, nil, nil
	-- 타인에게 걸 수 있는 생존기 체크 및 표시 우선 순위 조정
	if skills["*"][spellKey] then	-- 우선순위 1등 (외생기)
		isFind, spellShortName, endTime = findSkill(unit, skills["*"][spellKey], spellKey)
	elseif class and skills[class][spellKey] then-- 우선순위 2등 (본인 생존기)
		isFind, spellShortName, endTime = findSkill(unit, skills[class][spellKey], spellKey)
	elseif skills["SUB"][spellKey] and IRF3.db.units.showSurvivalSkillSub then 	--우선순위 3등 (준생존기)
		isFind, spellShortName, endTime = findSkill(unit, skills["SUB"][spellKey], spellKey)
	elseif skills["POTION"][spellKey] and IRF3.db.units.showSurvivalSkillPotion then --우선순위 4등 (물약류)
		isFind, spellShortName, endTime = findSkill(unit, skills["POTION"][spellKey], spellKey)
	end	
	return isFind, spellShortName, endTime
end

local function updateSurvivalSkill(self, spellKey)
	local isFind, spellShortName, survivalSkillEndTime = checkSkill(self.displayedUnit, self.class, spellKey)
	if isFind then
		if isFind == "show" then
			addSurvivalSkill(self, spellKey, spellShortName, survivalSkillEndTime)
			survivalSkillOnUpdate(self)
		elseif isFind == "hide" and spellShortName == self.survivalSkill then
			 
			initSurvivalSkill(self)
			survivalSkillOnUpdate(self)
			 
		end
	end
end

function InvenRaidFrames3Member_UpdateSurvivalSkill(self, isFullUpdate, updatedAuras)
if isFullUpdate ~= nil then 
--print("Survival UNIT_AURA_check:")
--print(isFullUpdate)
end
	if isFullUpdate or not updatedAuras then
		InvenRaidFrames3Member_AllUpdateSurvivalSkill(self)
		return
	end	
	
	local isHelpful = false
	for i = 1, updatedAuras and #updatedAuras or 0 do	-- 버프가 아니면 패스
		if updatedAuras[i].isHelpful == true then
			isHelpful = true
			break
		end
	end
	
	if isHelpful == false then
		return
	end
	
	for i = 1, updatedAuras and #updatedAuras or 0 do
		if IRF3.db.units.useSurvivalSkill then
			updateSurvivalSkill(self, updatedAuras[i].name)
		else
			initSurvivalSkill(self)
		end
		InvenRaidFrames3Member_UpdateLostHealth(self)--이름 프레임 업데이트
	end
end