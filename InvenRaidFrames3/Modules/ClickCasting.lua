local _G = _G
local IRF3 = _G[...]
local pairs = _G.pairs
local wipe = _G.table.wipe
local InCombatLockdown = _G.InCombatLockdown
local GetSpellInfo = _G.GetSpellInfo
local SpellHasRange = _G.SpellHasRange
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local talent, specId, ctype, ckey, ckey1, ckey2, spellName, wheelScript, wheelCount, prev_wheelCount
local modifilters = { [""] = true, ["alt-"] = true, ["ctrl-"] = true, ["shift-"] = true, ["alt-ctrl-"] = true, ["alt-shift-"] = true, ["ctrl-shift-"] = true }
IRF3.numMouseButtons = 15
local startWheelButton = 31
local clearWheelBinding = "self:ClearBindings()"
local state = {}
local applied_profile
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")

IRF3.overrideClickCastingSpells = {
	ROGUE = {
		-- 암살
		-- 무법
		["교섭"] = "실명",
		["난도질"] = "뼈주사위",
		-- 잠행
		["어둠칼날"] = "기습",
	},
	DRUID = {
		--조화
		["화신: 엘룬의 선택"] = "천체의 정렬",
		--야성
		["화신: 밀림의 왕"] = "광폭화",
		["잔혹한 베기"] = "휘둘러치기",
		--수호
		["행동 불가의 포효"] = "위협의 포효",
	},
	MAGE = {
		-- 냉기
		["얼음 형상"] = "얼음 핏줄",

	},
	HUNTER = {
		-- 야수
		["광포한 격노"] = "광포한 야수",
		["일점 사격"] = "고정 사격",
		-- 사격
		["강철 덫"] = "빙결 덫",
		["마름쇠 덫"] = "타르 덫",
		["도살"] = "저미기",
	},
	PRIEST = {
		-- 신성
		["상급 소실"] = "소실",
		-- 수양
		["사악의 정화"] = "어둠의 권능: 고통",
		-- 암흑
		["정신 폭탄"] = "영혼의 절규",
		-- 특성
		["환각의 마귀"] = "어둠의 마귀",
	},
	PALADIN = {
		["정화의 빛"] = "독소 정화",
		-- 신성
		["고결의 봉화"] = "빛의 봉화",
		["응징의 성전사"] = "응징의 격노",
		-- 보호
		["수호자의 손길"] = "수호자의 빛",
		["주문 수호의 축복"] = "보호의 축복",
		["축복받은 망치"] = "정의의 망치",
		["잊힌 여왕의 수호자"] = "고대 왕의 수호자",
		-- 징벌
		["열정"] = "성전사의 일격",
		["천상의 망치"] = "심판의 칼날",
		["격노의 칼날"] = "심판의 칼날",
		["성전"] = "응징의 격노",
	},
	MONK = {
		-- 특성
		["기공탄"] = "구르기",
		["평온"] = "폭풍과 대지의 불",
	},
	WARRIOR = {
		-- 무기
		["쇠날발톱"] = "칼날폭풍",
		["봉쇄"] = "돌진",
		-- 방어
		["피의 갈증"] = "영웅의 일격",
		["대규모 주문 반사"] = "주문 반사",
		-- 특성
		["예견된 승리"] = "연전연승",
	},
	SHAMAN = {
		-- 정기
		["용암 제어"] = "용암 쇄도",
		["폭풍의 정령"] = "불의 정령",
		-- 고양
		["바위주먹"] = "대지이빨",
		["에테리얼 형상"] = "영혼 이동",
		-- 복원
		["정신의 고리"] = "정신의 고리 토템",
		-- 특성
		["부두 토템"] = "사술",
	},
	DEATHKNIGHT = {
		-- 냉기
		["굶주린 룬 무기"] = "룬 무기 강화",
		-- 부정
		["어둠의 중재자"] = "가고일 부르기",
		["파멸"] = "죽음과 부패",
		["할퀴는 어둠"] = "스컬지의 일격",
	},
	WARLOCK = {
		-- 고통
		["영혼 흡수"] = "생명력 흡수",
		-- 악마
		["악마 화살"] = "어둠의 화살",
		-- 파괴
		["어둠의 연소"] = "점화",
	},
	DEMONHUNTER = {
		-- 파멸
		["악마 칼날"] = "악마의 이빨",

	},
}

do
	local overrideSpells = {}
	for c, spells in pairs(IRF3.overrideClickCastingSpells) do
		for p, v in pairs(spells) do
			if p and v and p ~= v then
				 overrideSpells[c] = overrideSpells[c] or {}
				 overrideSpells[c][p] = v
			end
		end
	end
	for c, spells in pairs(overrideSpells) do
		for p, v in pairs(spells) do
			IRF3.overrideClickCastingSpells[c][p] = v
		end
	end
end

function IRF3:GetClickCasting(modifilter, button)
	ckey = IRF3.ccdb[modifilter..button]
	if ckey == "togglemenu" then
		ckey = "menu"
		IRF3.ccdb[modifilter..button] = ckey
	end
	if ckey then
		ctype, ckey1 = ckey:match("(.+)__(.+)")
		if ctype == "macrotext" then
			return "macro", ctype, ckey1
		elseif ctype == "spell" then
			if not SpellHasRange(ckey1) then
				if self.overrideClickCastingSpells[self.playerClass] then
					spellName = self.overrideClickCastingSpells[self.playerClass][ckey1]
				elseif self.overrideClickCastingSpells[self.specId] then
					spellName = self.overrideClickCastingSpells[self.specId][ckey1]
				else
					spellName = nil
				end
				if spellName and SpellHasRange(spellName) then
					ckey1 = spellName
				end
			end
			return ctype, ctype, ckey1
		elseif ctype then
			return ctype, ctype, ckey1
		else
			return ckey
		end
	end
	return nil
end


local function reset(member, modifilter, button, ctype)

	if member:SetAttribute(modifilter.."type"..button, ctype) then
		member:SetAttribute(modifilter.."type"..button, ctype)
		member:SetAttribute(modifilter.."spell"..button, nil)
		member:SetAttribute(modifilter.."item"..button, nil)
		member:SetAttribute(modifilter.."macro"..button, nil)
		member:SetAttribute(modifilter.."macrotext"..button, nil)
	end

end


local function setupMembers(func, ...)
	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do


				func(member, ...)
				func(member.petButton, ...)

		end
	end



		for _, member in pairs(IRF3.tankheaders.members) do

				func(member, ...)


		end

	for _, member in pairs(IRF3.petHeader.members) do

			func(member, ...)

	end

 if IRF3.db and IRF3.db.enableClickCast  and IRF3.db.activateUnitFrame then --유닛프레임에도 클릭캐스트 활성화시
	--ElvUI
	if ElvUF_Player then
--print("elv")
		if ElvUF_Player then func(ElvUF_Player,...) end
		if ElvUF_Pet then func(ElvUF_Pet,...) end
		if ElvUF_Target then func(ElvUF_Target,...) end
		if ElvUF_Focus then func(ElvUF_Focus,...) end
		if ElvUF_PartyGroup1UnitButton2 then func(ElvUF_PartyGroup1UnitButton2,...) end
		if ElvUF_PartyGroup1UnitButton3 then func(ElvUF_PartyGroup1UnitButton3,...) end
		if ElvUF_PartyGroup1UnitButton4 then func(ElvUF_PartyGroup1UnitButton4,...) end
		if ElvUF_PartyGroup1UnitButton5 then func(ElvUF_PartyGroup1UnitButton5,...) end
	end


	--Shadowed Unit Frames
	if SUFUnitplayer then
--print("suf")
		if SUFUnitplayer then func(SUFUnitplayer,...) end
		if SUFUnitpet then func(SUFUnitpet,...) end
		if SUFUnittarget then func(SUFUnittarget,...) end
		if SUFUnitfocus then func(SUFUnitfocus,...) end
		if SUFHeaderpartyUnitButton1 then func(SUFHeaderpartyUnitButton1,...) end
		if SUFHeaderpartyUnitButton2 then func(SUFHeaderpartyUnitButton2,...) end
		if SUFHeaderpartyUnitButton3 then func(SUFHeaderpartyUnitButton3,...) end
		if SUFHeaderpartyUnitButton4 then func(SUFHeaderpartyUnitButton4,...) end


	end
 



	--Inven unit Frame
	if InvenUnitFrames_Player then
--print("iuf")
		if InvenUnitFrames_Player then  func(InvenUnitFrames_Player,...) end
		if InvenUnitFrames_Pet then func(InvenUnitFrames_Pet,...) end
		if InvenUnitFrames_Target then func(InvenUnitFrames_Target,...) end
		if InvenUnitFrames_Focus then func(InvenUnitFrames_Focus,...) end
		if InvenUnitFrames_Party1 then func(InvenUnitFrames_Party1,...) end
		if InvenUnitFrames_Party2 then func(InvenUnitFrames_Party2,...) end
		if InvenUnitFrames_Party3 then func(InvenUnitFrames_Party3,...) end
		if InvenUnitFrames_Party4 then func(InvenUnitFrames_Party4,...) end
 

	end


	--Blizzard
	if PlayerFrame then
--print("blizzard")
		func(PlayerFrame,...)
		func(PetFrame,...)
		func(TargetFrame,...)
		func(FocusFrame,...)
		func(PartyMemberFrame1,...)
		func(PartyMemberFrame2,...)
		func(PartyMemberFrame3,...)
		func(PartyMemberFrame4,...)

	end

	end--유닛프레임에도 클릭캐스트 활성화시

end

local function setClickCasting(member, modifilter, button, ctype, ckey1, ckey2)
if member then
	reset(member, modifilter, button, ctype)
	if ckey1 then
		member:SetAttribute(modifilter..ckey1..button, ckey2)
	end
end
end

function IRF3:SetClickCasting(modifilter, button)
	ctype, ckey1, ckey2 = self:GetClickCasting(modifilter, button)
	setupMembers(setClickCasting, modifilter, button, ctype, ckey1, ckey2)
end

local function setClickCastingWheel(modifilter, wheel, button)
	ctype, ckey1, ckey2 = IRF3:GetClickCasting(modifilter, wheel)
 
	if ckey1 == "macro" then
		wheelScript = wheelScript.." self:SetBindingMacro(1, '"..modifilter.."MOUSE"..wheel.."', '"..ckey2.."')"

	elseif ctype and ckey1 then
		for i = startWheelButton, button + 1, -1 do
			if IRF3.headers[1].members[1]:GetAttribute("type"..i) == ctype and IRF3.headers[1].members[1]:GetAttribute(ckey1..i) == ckey2 then
				wheelScript = wheelScript.." self:SetBindingClick(1, '"..modifilter.."MOUSE"..wheel.."', self, 'Button"..i.."')"
				return button
			end
		end
		wheelScript = wheelScript.." self:SetBindingClick(1, '"..modifilter.."MOUSE"..wheel.."', self, 'Button"..button.."')"
		setupMembers(setClickCasting, "", button, ctype, ckey1, ckey2)
		return button - 1
	end
	return button
end

local dummyWheel = function() end

local function overrideWheel(member, has)
	IRF3:UnwrapScript(member, "OnEnter")
	IRF3:UnwrapScript(member, "OnLeave")
	IRF3:UnwrapScript(member, "OnHide")
	IRF3:WrapScript(member, "OnEnter", wheelScript)
	IRF3:WrapScript(member, "OnLeave", clearWheelBinding)
	IRF3:WrapScript(member, "OnHide", clearWheelBinding)
end

function IRF3:SetClickCastingMouseWheel()
	wheelScript, wheelCount = clearWheelBinding, startWheelButton
	for modifilter in pairs(modifilters) do
		wheelCount = setClickCastingWheel(modifilter, "WHEELUP", wheelCount)
		wheelCount = setClickCastingWheel(modifilter, "WHEELDOWN", wheelCount)
	end
	setupMembers(overrideWheel)
	if prev_wheelCount then
		for i = prev_wheelCount, wheelCount do
			setupMembers(setClickCasting, "", i)
		end
	end

	prev_wheelCount, wheelScript, wheelCount = wheelCount + 1
end


function IRF3:SelectClickCastingDB()
 
 

if InCombatLockdown() or not InvenRaidFrames3CharDB then return end
	InvenRaidFrames3CharDB.clickCasting = InvenRaidFrames3CharDB.clickCasting or { {}, {}, {}, {} }
	for i = 1, 4 do
		InvenRaidFrames3CharDB.clickCasting[i] = InvenRaidFrames3CharDB.clickCasting[i] or {}
	end
	IRF3.playerClass = IRF3.playerClass or select(2, UnitClass("player"))
--	IRF3.specId, specId = GetSpecializationInfo(GetSpecialization(false, false, 0) or 0), IRF3.specId--현재 사용 안함. 추후 사용을 위해 남겨둠.
--	IRF3.talent, talent = 1, IRF3.talent--GetSpecialization() or 1, IRF3.talent
	talent = GetActiveTalentGroup()	
	--기존talent와 현재 talent값을 교체.로딩직후에는 기존talent값이 없으므로 이중특성중 다른값으로 지정
	IRF3.talent, talent =talent,  ((2-talent)+1)
--IRF3.specId = 1
--	if IRF3.specId ~= specId or IRF3.talent ~= talent then


			IRF3.ccdb = InvenRaidFrames3CharDB.clickCasting[IRF3.talent]

		if IRF3.db and IRF3.db.enableClickCast then
		for modifilter in pairs(modifilters) do
			for button = 1, IRF3.numMouseButtons do
				IRF3:SetClickCasting(modifilter, button)
			end
		end
	
		IRF3:SetClickCastingMouseWheel()
		end
 
		if IRF3.optionFrame.UpdateClickCasting then
			IRF3.optionFrame:UpdateClickCasting()

		end
--	end
end

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", IRF3.SelectClickCastingDB)
handler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
--handler:RegisterEvent("PLAYER_TALENT_UPDATE")
handler:RegisterEvent("PLAYER_LOGIN")
handler:RegisterEvent("PLAYER_ENTERING_WORLD")
--handler:RegisterEvent("PLAYER_REGEN_ENABLED")
--handler:RegisterEvent("LEARNED_SPELL_IN_TAB")