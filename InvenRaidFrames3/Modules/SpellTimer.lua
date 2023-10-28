local _G = _G
local IRF3 = _G[...]
local ipairs = _G.ipairs
local UnitAura = _G.UnitAura
local usedIndex = {}
local indexSpellInfo = {}
local indexSpellName = {}
local isHaveDebuff = false
local delimiter = ","
local numberFont = IRF3:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
local numberFontWidth = {}
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local SL = IRF3.GetSpellName
--local blockSpellID = {	}	--[SL(53601)] =53601,	}	--성스러운 보호막(6초 버프)
local blockSpellID = {	[SL(58597)] = 58597,} --	[SL(64843)] = 63843 , [SL(64901)] = 64901}	--성스러운 보호막(6초 버프),천사의찬가(메인),희망의 찬가(메인)

local ePos = { "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT", "TOPLEFT", "TOP", "TOPRIGHT", "CENTER" }
local eFilter = { "HELPFUL PLAYER", "HARMFUL PLAYER", "HELPFUL", "HARMFUL" }

--Survival Skill
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


---------

function IRF3:UpdateSpellTimerFont()

	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
		
			for i = 1, 18 do


				local frame = member["spellTimer"..i]
--				frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8)*0.7, IRF3.db.font.attribute)
				frame.count:SetTextColor(IRF3.db.units.SpellTimerCountColor[1], IRF3.db.units.SpellTimerCountColor[2], IRF3.db.units.SpellTimerCountColor[3])
				frame.count:SetShadowColor(0, 0, 0)
				frame.count:SetShadowOffset(1, -1)
--				frame.count:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 1, 1)
--				frame.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
				frame.timer:SetTextColor(IRF3.db.units.SpellTimerFontColor[1], IRF3.db.units.SpellTimerFontColor[2], IRF3.db.units.SpellTimerFontColor[3])
				frame.timer:SetShadowColor(0, 0, 0)
				frame.timer:SetShadowOffset(1, -1)
				frame.timer:ClearAllPoints()
--				frame.timer:SetIgnoreParentScale(true)
--				frame.count:SetIgnoreParentScale(true)



--		if InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1 then
-- 			frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8)*0.7, IRF3.db.font.attribute)
--			frame.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8)*0.7, IRF3.db.font.attribute)
--		else

			frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file),(InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
			frame.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
--		end


--					if IRF3.db.enableSpellTimerType1 then 
--print(i,InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1)
					if InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1 then
						frame.timer:SetPoint("CENTER", frame.icon, "CENTER", 0, 0)
					else
						frame.timer:SetPoint("LEFT", frame.icon, "RIGHT", 2, 0)
					end


					
				if not frame.initScale then
					frame:SetScale(InvenRaidFrames3CharDB.spellTimer[i].scale)				

					frame.initScale = InvenRaidFrames3CharDB.spellTimer[i].scale
				elseif frame.index then
					frame:SetScale(InvenRaidFrames3CharDB.spellTimer[frame.index].scale)

				end
				frame.STFadeStartTime = {}
			end
		end

	end



if IRF3.db.enableTankFrame then
--	for _, header in pairs(IRF3.tankheaders[1]) do
--		for _, member in pairs(header.members) do
		--방어전담은 한파티만 보여주므로 다 loop돌필요없다.
		for _, member in pairs(IRF3.tankheaders.members) do
 
			for i = 1, 18 do
				local frame = member["spellTimer"..i]
				frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
				frame.count:SetTextColor(IRF3.db.units.SpellTimerCountColor[1], IRF3.db.units.SpellTimerCountColor[2], IRF3.db.units.SpellTimerCountColor[3])
				frame.count:SetShadowColor(0, 0, 0)
				frame.count:SetShadowOffset(1, -1)
--				frame.count:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 1, 1)
				frame.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
				frame.timer:SetTextColor(IRF3.db.units.SpellTimerFontColor[1], IRF3.db.units.SpellTimerFontColor[2], IRF3.db.units.SpellTimerFontColor[3])
				frame.timer:SetShadowColor(0, 0, 0)
				frame.timer:SetShadowOffset(1, -1)
				frame.timer:ClearAllPoints()
--				frame.timer:SetIgnoreParentScale(true)
--				frame.count:SetIgnoreParentScale(true)

--					if IRF3.db.enableSpellTimerType1 or i >15 then --생존기 아이콘은 시간겹치기
					if InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1 or i>15 then--생존기 아이콘은 시간겹치기

						frame.timer:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 0, 0)
						
					else
						frame.timer:SetPoint("LEFT", frame.icon, "RIGHT", 2, 0)
					end

				if not frame.initScale then
					frame:SetScale(InvenRaidFrames3CharDB.spellTimer[i].scale)				

					frame.initScale = InvenRaidFrames3CharDB.spellTimer[i].scale
				elseif frame.index then
					frame:SetScale(InvenRaidFrames3CharDB.spellTimer[frame.index].scale)
				end
				frame.STFadeStartTime = {}

			end
--		end
end

	end



	for _, member in pairs(IRF3.petHeader.members) do
		
		for i = 1, 18 do 
			local frame = member["spellTimer"..i]

--			frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8)*0.7, IRF3.db.font.attribute)
			frame.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
			frame.count:SetTextColor(IRF3.db.units.SpellTimerCountColor[1], IRF3.db.units.SpellTimerCountColor[2], IRF3.db.units.SpellTimerCountColor[3])
			frame.count:SetShadowColor(0, 0, 0)
			frame.count:SetShadowOffset(1, -1)
--			frame.count:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 1, 1)
			frame.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[i].fontsize or 8), IRF3.db.font.attribute)
			frame.timer:SetTextColor(IRF3.db.units.SpellTimerFontColor[1], IRF3.db.units.SpellTimerFontColor[2], IRF3.db.units.SpellTimerFontColor[3])
			frame.timer:SetShadowColor(0, 0, 0)
			frame.timer:SetShadowOffset(1, -1)
			frame.timer:ClearAllPoints()
--				frame.timer:SetIgnoreParentScale(true)
--				frame.count:SetIgnoreParentScale(true)

--				if IRF3.db.enableSpellTimerType1  or i >15 then --생존기 아이콘은 시간겹치기
				if InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1 or i>15 then--생존기 아이콘은 시간겹치기
					frame.timer:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 0, 0)

				else
					frame.timer:SetPoint("LEFT", frame.icon, "RIGHT", 2, 0)
				end

			if not frame.initScale then
				frame:SetScale(InvenRaidFrames3CharDB.spellTimer[i].scale)

				frame.initScale = InvenRaidFrames3CharDB.spellTimer[i].scale
			elseif frame.index then
				frame:SetScale(InvenRaidFrames3CharDB.spellTimer[frame.index].scale)

			end
			frame.STFadeStartTime = {}

		end
	end


	for i = 1, 5 do
		numberFont:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
		numberFont:SetText(strrep("0", i))
		numberFont:SetShadowColor(0, 0, 0)
		numberFont:SetShadowOffset(1, -1)
		numberFontWidth[i] = ceil(numberFont:GetWidth()) + 1
	end
end

function IRF3:UpdateSpellTimerWidth()
	for index, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
			if member:IsShown() then
				InvenRaidFrames3Member_UpdateSpellTimer(member)
			end
		end
	end
	for _, member in pairs(IRF3.petHeader.members) do
		for i = 1, 18 do
			if member:IsShown() then
				InvenRaidFrames3Member_UpdateSpellTimer(member)
			end
		end
	end
end

local function PrintFadeCount(button)
	if not button.debugPrintValue2 then
		button.debugPrintValue2 = 0
	end
	if not button.STFadeCount then
		button.STFadeCount = 0
	end
	if button.debugPrintValue2 ~= button.STFadeCount then
		button.debugPrintValue2 = button.STFadeCount
		--print("SpellTimer = " .. button:GetParent():GetID() .. "-"  .. button:GetID() .. "   " .. button.STFadeCount)
	end
end

local function onUpdateIconTimer(self, opt ,survivalIcon,enableSpellTimerType1 )



		if opt == 4 or opt == 5 then

			self.timeLeft = GetTime() - self.startTime
		else

			self.timeLeft = self.expirationTime - GetTime()

		end



	if not survivalIcon then
		if self.timeLeft > 100 then
			if self.noIcon then

				self.timer:SetText("●")
			else

				self.timer:SetText("")
			end
		else

			self.timer:SetFormattedText("%d", self.timeLeft + 0.5)
		end
	else

		self.timer:SetText("")

	end

	if enableSpellTimerType1 or survivalIcon then

		self:SetWidth((self.noIcon and 0 or 13))

	else
		self:SetWidth((numberFontWidth[(self.timer:GetText() or ""):len()] or 0) + (self.noIcon and 0 or 13))
	end


end

local function DelFade(frame)
	if frame then

		frame:SetScale(frame.initScale or 1 )	-- 20220426 커진 상태로 노출되던 문제 수정

		if frame.STFadeticker then
			frame.STFadeticker:Cancel()
			frame.STFadeticker = nil
		end
	end
end

local function onFadeIn(frame)
	local tickLeft = GetTime() - (frame.tickStartTime or 0)
	
	if (tickLeft) < 0.30 then	-- 0.5초 연출		
		local nowScale = 1.0 + math.sin((tickLeft) * 10.0)
		if nowScale > 0.50 then
			frame:SetScale(frame.initScale * nowScale)

			return
		end
	end
	
	DelFade(frame)	
end

local function AddFade(self, frame, spellId, startTime)
	local spellCode = spellId .. startTime
	if frame.spellCode and frame.spellCode ~= spellCode then
		self.STFadeStartTime[frame.spellCode] = nil
		self.STFadeCount = (self.STFadeCount or 0) - 1
	end
	frame.spellCode = spellCode
	if not self.STFadeStartTime then
		self.STFadeStartTime = {}
	end
	if not self.STFadeStartTime[frame.spellCode] or (startTime ~= 0) then
		if not self.STFadeStartTime[frame.spellCode] then
			self.STFadeCount = (self.STFadeCount or 0) + 1
		end
		self.STFadeStartTime[frame.spellCode] = startTime
		if self.STFadeStartTime[frame.spellCode] == 0 then
			self.STFadeStartTime[frame.spellCode] = GetTime()
		end							
	end
	frame.tickStartTime = self.STFadeStartTime[frame.spellCode]	
	if not frame.STFadeticker then
		frame.STFadeticker = C_Timer.NewTicker(0.05, function()  onFadeIn(frame) end)
		onFadeIn(frame)
	end
end

function setIcon(self, index, duration, expirationTime, icon, count, spellId, caster)


	self.spellId = spellId
	self.index = index
	if self and index then
--print(index,InvenRaidFrames3CharDB.spellTimer[index].display,InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1)
		 
		if caster and caster~="player" then --타인의 주문타이머 폰트색상이 되어있을때

			self.timer:SetTextColor(IRF3.db.units.SpellTimerOtherFontColor[1],IRF3.db.units.SpellTimerOtherFontColor[2],IRF3.db.units.SpellTimerOtherFontColor[3])
		else
			self.timer:SetTextColor(IRF3.db.units.SpellTimerFontColor[1],IRF3.db.units.SpellTimerFontColor[2],IRF3.db.units.SpellTimerFontColor[3])
		end


		if InvenRaidFrames3CharDB.spellTimer[index].display == 1 then
			-- 아이콘 + 남은 시간

			self.noIcon = nil
			self.noLeft = nil
			self.icon:SetWidth(13)
			self.icon:SetTexture(icon)
			self.count:SetText(count and count > 1 and count or "")
--테스트중: 주문타이머 폰트겹치기->회기/피생/대보같이 타이머+중첩일 경우 좀더 폰트를 작게 보여줌->주문별 폰트사이즈를 추가해서 의미가 없어짐
--		if IRF3.db.enableSpellTimerType1 and count and count > 1 then

--		if InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1 and count and count>1 then
--			self.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8)*0.7, IRF3.db.font.attribute)
			 self.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8)*0.7, IRF3.db.font.attribute)
--		else
			 self.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file),(InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8), IRF3.db.font.attribute)
			 self.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8), IRF3.db.font.attribute)
--		end


		elseif InvenRaidFrames3CharDB.spellTimer[index].display == 2 then
			-- 아이콘
			self.noIcon = nil
			self:SetWidth(13)
			self.icon:SetWidth(13)
			self.icon:SetTexture(icon)
			self.count:SetText(count and count > 1 and count or "")
--			if index > 15 then self.timer:Hide() end
			duration = nil

		elseif InvenRaidFrames3CharDB.spellTimer[index].display == 3 then
			-- 남은 시간
			--주문타이머 폰트 겹치기일경우에는 아이콘위치와 동일하므로 아이콘위치는 그대로 유지
--			if not IRF3.db.enableSpellTimerType1 then
			if not InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1 then
				self.noIcon = true
				self.icon:SetWidth(0.001)
			end
			self.icon:SetTexture(nil)
			self.count:SetText(nil)

		elseif InvenRaidFrames3CharDB.spellTimer[index].display == 4 then
			-- 아이콘 + 경과 시간
			self.noIcon = nil
			self.icon:SetWidth(13)
			self.icon:SetTexture(icon)
			self.count:SetText(count and count > 1 and count or "")
--테스트중: 주문타이머 폰트겹치기->회기/피생/대보같이 타이머+중첩일 경우 좀더 폰트를 작게 보여줌->주문별 폰트사이즈를 추가해서 의미가 없어짐
--			if IRF3.db.enableSpellTimerType1 and count and count > 1 then
--			if   InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1 and count and count > 1 then

-- 				self.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8)*0.7, IRF3.db.font.attribute)
--			 	self.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8)*0.7, IRF3.db.font.attribute)
--			else

				 self.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8), IRF3.db.font.attribute)
				 self.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), (InvenRaidFrames3CharDB.spellTimer[index].fontsize or 8), IRF3.db.font.attribute)
--			end
		else
			-- 경과 시간
--주문타이머 폰트 겹치기일경우에는 아이콘위치와 동일하므로 아이콘위치는 그대로 유지
--			if not IRF3.db.enableSpellTimerType1 or index>16 then
			if not InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1 or index>16 then
				self.noIcon = true
				self.noLeft = true
				self.icon:SetWidth(0.001)
			end

			self.icon:SetTexture(nil)
			self.count:SetText(nil)
		end



		if duration and duration > 0 and expirationTime then

			self.startTime = expirationTime - duration
			self.expirationTime = expirationTime
			 

				if not self.spellticker then
					if index >  15 then --생존기 아이콘은 시간겹치기

						self.spellticker = C_Timer.NewTicker(0.5, function() onUpdateIconTimer(self, InvenRaidFrames3CharDB.spellTimer[index].display,true,InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1) end)
					else
						self.spellticker = C_Timer.NewTicker(0.5, function() onUpdateIconTimer(self, InvenRaidFrames3CharDB.spellTimer[index].display,false,InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1) end)
					end
				end

				if index >  15 then --생존기 아이콘은 시간겹치기
					onUpdateIconTimer(self, InvenRaidFrames3CharDB.spellTimer[index].display,true,InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1)
				else
					onUpdateIconTimer(self, InvenRaidFrames3CharDB.spellTimer[index].display,false,InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1)
				end
 				       
			
			self.initScale = InvenRaidFrames3CharDB.spellTimer[index].scale
 
--			if IRF3.db.enableFadeIn then --개별설정으로 변경
			if InvenRaidFrames3CharDB.spellTimer[index].FadeIn then

				AddFade(self:GetParent(), self, spellId, self.startTime)
			end
		else

			self:SetWidth(self.icon:GetWidth() + self.count:GetWidth()) -- add. 재사용된 frame이 width 값이 이전 값에 영향 받는다.
			
			DelFade(self)
			if self.spellCode then
				if self:GetParent().STFadeStartTime[self.spellCode] then
					self:GetParent().STFadeStartTime[self.spellCode] = nil
					self:GetParent().STFadeCount = self:GetParent().STFadeCount - 1
				end
			end
			
			if self.spellticker then --정상적으로 주문 타이머 만료 시 타이머 삭제
				self.spellticker:Cancel()
				self.spellticker = nil
				self.spellId, self.index = nil, nil
			end
			self.expirationTime, self.timeLeft = nil, nil
			if self.noIcon then
				self.timer:SetText("●")
			else
				self.timer:SetText("")
			end
		end

		self:Show()

	elseif self and self:IsShown() then

		DelFade(self)
		if self.spellCode then
			if self:GetParent().STFadeStartTime[self.spellCode] then
				self:GetParent().STFadeStartTime[self.spellCode] = nil
				self:GetParent().STFadeCount = self:GetParent().STFadeCount - 1
			end
		end
		
		if self.spellticker then
			self.spellticker:Cancel()
			self.spellticker = nil
		end
		self.expirationTime, self.timeLeft, self.noIcon, self.spellId, self.index = nil, nil, nil, nil, nil
		self:Hide()
	end
end

local function UnitAuraName(unit, spell, filter)
    --return AuraUtil.FindAuraByName(spell, unit, filter)
	return AuraUtil.FindAuraByName(spell, unit, filter)
end

local function initSortTable(self)
	if self.nowPos then
		table.wipe(self.nowPos)
	end
	self.nowPos = {}
	
	if self.nowWidth then
		table.wipe(self.nowWidth)
	end
	self.nowWidth = {}
	
	if self.centerIndex then
		table.wipe(self.centerIndex)
	end
	self.centerIndex = {}
end

local function nextIndex(self)
	local isFind = false
	for index = 1, 18 do
		local frame = self["spellTimer"..index]
		if frame and not frame.spellId then
			return index
		end
	end
	return nil
end

function setSort(self, frame, index)	-- frame = spellTimer
	local posName = InvenRaidFrames3CharDB.spellTimer[index].pos
	frame:SetScale(InvenRaidFrames3CharDB.spellTimer[index].scale)

	frame.initScale = InvenRaidFrames3CharDB.spellTimer[index].scale
	frame:ClearAllPoints()
	if posName == "RIGHT" or posName == "TOPRIGHT" or posName == "BOTTOMRIGHT" then
		if self.nowPos[posName] then
--			frame:SetPoint(posName, self.nowPos[posName], posName, -frame:GetWidth(), 0)
--			frame:SetPoint(posName, self.nowPos[posName], posName, -self.nowPos[posName]:GetWidth(), 0)
--			frame:SetPoint(posName, self.nowPos[posName], posName, -self.nowWidth[posName], 0) --scale로 인해 크기가 변경되어width,height와 화면이 틀어진다. 앵커고정이 틀어져서 강제 고정
			if posName=="TOPRIGHT" then
				frame:SetPoint("TOPRIGHT",self.nowPos[posName],"TOPLEFT",0,0)
			elseif posName=="RIGHT" then
				frame:SetPoint("RIGHT",self.nowPos[posName],"LEFT",0,0)
			elseif posName=="BOTTOMRIGHT" then
				frame:SetPoint("BOTTOMRIGHT",self.nowPos[posName],"BOTTOMLEFT",0,0)
			end
	


		else
			frame:SetPoint(posName, 0, 0)
		end
	self.nowWidth[posName] =  frame:GetWidth() * InvenRaidFrames3CharDB.spellTimer[index].scale

	elseif posName == "LEFT" or posName == "TOPLEFT" or posName == "BOTTOMLEFT" then

		if self.nowPos[posName] then
--			frame:SetPoint(posName, self.nowPos[posName], posName, frame:GetWidth(), 0)
--			frame:SetPoint(posName, self.nowPos[posName], posName, self.nowPos[posName]:GetWidth(), 0)--scale로 인해 크기가 변경되어width,height와 화면이 틀어진다. 앵커고정이 틀어져서 강제 고정
			if posName=="TOPLEFT" then
				frame:SetPoint("TOPLEFT",self.nowPos[posName],"TOPRIGHT",0,0)
			elseif posName=="LEFT" then
				frame:SetPoint("LEFT",self.nowPos[posName],"RIGHT",0,0)
			elseif posName=="BOTTOMLEFT" then
				frame:SetPoint("BOTTOMLEFT",self.nowPos[posName],"BOTTOMRIGHT",0,0)
			end
		else
			frame:SetPoint(posName, 0, 0)
		end
	elseif posName == "CENTER" or posName == "TOP" or posName == "BOTTOM" then
		if self.nowPos[posName] then
			frame:SetPoint(posName, self.nowPos[posName], posName, frame:GetWidth(), 0)
			self.nowPos[posName .. "Head"]:SetPoint(posName, self.nowWidth[posName] / 2, 0)			
		else
			frame:SetPoint(posName, 0, 0)
			self.nowPos[posName .. "Head"] = frame
		end
		self.nowWidth[posName] = (self.nowWidth[posName] or 0) - frame:GetWidth()
	end
	self.nowPos[posName] = frame

 
			frame.timer:ClearAllPoints()

 
				if InvenRaidFrames3CharDB.spellTimer[index].enableSpellTimerType1 or index>15 then--생존기 아이콘은 시간겹치기
					if frame.count and frame.count:GetText() and #frame.count:GetText()>0 then
						frame.timer:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 0, 0)
					else
						frame.timer:SetPoint("CENTER", frame.icon, "CENTER", 0, 0)
					end

				else

					frame.timer:SetPoint("LEFT", frame.icon, "RIGHT", 2, 0)
				end


end

function InvenRaidFrames3Member_UpdateSpellTimer(self, isFullUpdate, updatedAuras)
 
--if isFullUpdate ~= nil then 
--print("SpellTimer UNIT_AURA_check:")
--print(isFullUpdate)
--end
	if not self or not self.displayedUnit then
		return
	end
	if not updatedAuras or isFullUpdate then

		InvenRaidFrames3Member_AllUpdateSpellTimer(self)	
		return
	end
	
	local numAuras = updatedAuras and #updatedAuras or 0
--print("찾기 시작 " .. numAuras )
	for i = 1, updatedAuras and #updatedAuras or 0 do
		if indexSpellName[updatedAuras[i].name] then		-- 광역 버프가 계속 이벤트 들어와서 이캐릭의 주문타이머 목록 만들어서 먼저 비교
			local orgIndex = indexSpellName[updatedAuras[i].name]
			local filter = eFilter[InvenRaidFrames3CharDB.spellTimer[orgIndex].use]
--print("찾기 시작 for " .. i .. " name " .. updatedAuras[i].name )
			local isFind = false
			for index = 1, 18 do
				local frame = self["spellTimer"..index]
				if frame and frame.spellId then
					if frame.spellId ~= updatedAuras[i].spellId then
					else
						IRF3:ForEachAura(self.displayedUnit, filter, nil, 
							function(name, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId)
 

--								if name and spellId == updatedAuras[i].spellId then
								if name and spellId == updatedAuras[i].spellId and spellId ~= blockSpellID[name] then
									isFind = true
--print("이미 있는건 지속시간만 갱신 " .. updatedAuras[i].name)

									setIcon(frame, frame.index, duration, expirationTime, icon, count, spellId,unitCaster)

									return true
								end
							end
						)
						if not isFind then
--print("아이콘은 있는데 플레이어 버프에선 사라짐 ")
							isFind = true
							setIcon(self["spellTimer"..index])
							break	-- 추가함 04.19.
						end
					end
				else
				end
			end
			
			if not isFind then
--print("못찾은 주문 " .. updatedAuras[i].name)
				if nextIndex(self) then
					local frame = self["spellTimer" .. nextIndex(self)]
--print("  공간 있는거 확인 " .. updatedAuras[i].name .. " orgIndex " .. orgIndex .. " nextIndex " .. nextIndex(self))
					if frame then	-- 공간 있으면 새로 추가 시도
						if frame.spellId then	-- 같은 공간 다른 주문이 이미 있을 때 정렬 문제로 그냥 새로 그리기		
--print("  공간에 이미 있음 -> 전부 갱신 " .. frame.spellId)			
	
							InvenRaidFrames3Member_AllUpdateSpellTimer(self)	-- 테스트 후 아무것도 하지않게 수정할 예정
							return
						end

						IRF3:ForEachAura(self.displayedUnit, filter, nil, 
							function(name, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId)

--								if name and spellId == updatedAuras[i].spellId then
								if name and spellId == updatedAuras[i].spellId and spellId ~= blockSpellID[name] then
									setIcon(frame, orgIndex, duration, expirationTime, icon, count, spellId, unitCaster)
									isFind = true
--print("새로 추가 " .. updatedAuras[i].name .. " " .. updatedAuras[i].spellId .. " " .. orgIndex)
								end
							end
						)
					end
				else
					InvenRaidFrames3Member_AllUpdateSpellTimer(self)	-- 테스트 후 아무것도 하지않게 수정할 예정
--print("결국 전부 갱신 " .. updatedAuras[i].name)
					return
				end	
			end
		else
--print("주문 타이머에 없는 스펠은 패스" .. updatedAuras[i].name)
		end
	end

	initSortTable(self)


	for i = 1, 18 do
		local frame = self["spellTimer"..i]
		if frame and frame.spellId then
			setSort(self, frame, frame.index)
		end
	end
end

local function allCheckSkill_new(self,name,endTime, caster,spellId,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion)
local unit =self.displayedUnit
	if findSpellInfoMain.spellKey then
		return findSpellInfoMain.spellKey, findSpellInfoMain.shortName, findSpellInfoMain.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	elseif findSpellInfoClass.spellKey  then
		return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion

	elseif findSpellInfoSub.spellKey  then
		return findSpellInfoSub.spellKey, findSpellInfoSub.shortName, findSpellInfoSub.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	elseif findSpellInfoPotion.spellKey  then
		return findSpellInfoPotion.spellKey, findSpellInfoPotion.shortName, findSpellInfoPotion.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
 
	end
		
	local spellKey = name
	if spellKey then
				if skills["*"][spellKey] then	-- 1순위가 찾아지면 바로 리턴
					findSpellInfoMain.spellKey = spellKey
					findSpellInfoMain.shortName = skills["*"][spellKey]
					findSpellInfoMain.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return findSpellInfoMain.spellKey, findSpellInfoMain.shortName, findSpellInfoMain.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
				elseif self.class and skills[self.class][spellKey]     then	-- pet은 class 가 nil로 올때가 있다

				if  self.class=="PRIEST" and spellId==64844 then return end --사제의 찬가버프중 리필되는 버프는 제외

--캔슬성희->천수로 표기
--성희(or 성희+천수) =>성희로 표기
--무적+성희(or 무적+성희+천수) -> 무적성희로 별도 표기

				if self.class=="PALADIN" then--성기사일땐 성희때문에 별도 처리(start)
					if (spellId~=64205 and spellId ~=70940   ) or ((spellId==64205  or spellId==70940   ) and endTime and endTime > 0)  then   --endTime으로 본인의 성희인지, 타인의 성희인지 판단 (start)

						if spellId==70940 then --천수가 먼저 검색되었을떄에는, 무적이나 성희가 동시에 있는지 체크.
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(64205),unit,"HELPFUL") --성희 

							if name2 then  --성희가 있으면, 천수대신 성희를 표기

								name3,_,_,_,_,endTime3 = AuraUtil.FindAuraByName(SL(642),unit,"HELPFUL")--무적(천상의 보호막)
								if name3 then --무적/성희/천수가 모두 있으면 그냥 무적성희로 표기
									findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
				 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
									findSpellInfoClass.endTime = (endTime2 and endTime3 and endTime2<endTime3) and endTime2 or endTime3--짧은 잔여시간으로 표기
									return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
								end

								if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end

								--성희/천수만 있으면 성희로 표기
								findSpellInfoClass.spellKey = name2
			 					findSpellInfoClass.shortName = skills[self.class][name2]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
							end
							if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end
						end

						if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end

						--성희가 먼저 검색되었을때는 (천수는 기본이니), 무적이 동시에 있는지 체크

						if spellId==64205 then 
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(642),unit,"HELPFUL")

							if name2 then  --무적이 있으면, 성희 대신 무적성희로 표기
						
								findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
			 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
							end
							if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end
						end
						if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion  end


						--무적이 먼저 검색되었을때는 , 성희가 동시에 있는지 체크
						if spellId==642  then 
 
							name2,_,_,_,_,endTime2 = AuraUtil.FindAuraByName(SL(64205),unit,"HELPFUL")--성희
			
							if name2 and endTime2 and endTime2>0 then  --성희가 있으면, 무적 대신 무적성희로 표기(본인의 성희만)

								findSpellInfoClass.spellKey = L["lime_survival_무적성희"]
			 					findSpellInfoClass.shortName = L["lime_survival_무적성희"]
								findSpellInfoClass.endTime = (endTime and endTime2 and endTime<endTime2) and endTime or endTime2--짧은 잔여시간으로 표기
								return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
							end
							if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end
						end

						if findSpellInfoClass.spellKey then return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion end
 
						findSpellInfoClass.spellKey = spellKey
	 					findSpellInfoClass.shortName = skills[self.class][spellKey]
						findSpellInfoClass.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime

						return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion

					end--성기사일땐 성희때문에 별도 처리(end)

				else--성기사 아닌 클래스는 표준 처리

						findSpellInfoClass.spellKey = spellKey
	 					findSpellInfoClass.shortName = skills[self.class][spellKey]
						findSpellInfoClass.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime


						return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion


				end

				elseif IRF3.db.units.showSurvivalSkillSub and skills["SUB"][spellKey] then

					findSpellInfoSub.spellKey = spellKey
					findSpellInfoSub.shortName = skills["SUB"][spellKey]
					findSpellInfoSub.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return findSpellInfoSub.spellKey, findSpellInfoSub.shortName, findSpellInfoSub.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
				elseif IRF3.db.units.showSurvivalSkillPotion and skills["POTION"][spellKey] then

					findSpellInfoPotion.spellKey = spellKey
					findSpellInfoPotion.shortName = skills["POTION"][spellKey]
					findSpellInfoPotion.endTime = (not ignoreEndTime[spellKey] and endTime and endTime > 0) and endTime
					return findSpellInfoPotion.spellKey, findSpellInfoPotion.shortName, findSpellInfoPotion.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
				end


				return true
			end

 	if findSpellInfoMain.spellKey then
		return findSpellInfoMain.spellKey, findSpellInfoMain.shortName, findSpellInfoMain.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	elseif findSpellInfoClass.spellKey then
		return findSpellInfoClass.spellKey, findSpellInfoClass.shortName, findSpellInfoClass.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	elseif findSpellInfoSub.spellKey then
		return findSpellInfoSub.spellKey, findSpellInfoSub.shortName, findSpellInfoSub.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	elseif findSpellInfoPotion.spellKey then
		return findSpellInfoPotion.spellKey, findSpellInfoPotion.shortName, findSpellInfoPotion.endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion
	end

	return nil
end


local function allFind(self, filter)
if not self.unit then return end

local findSpellInfoMain = {}
local findSpellInfoClass = {}
local findSpellInfoSub = {}
local findSpellInfoPotion = {}

	IRF3:ForEachAura(self.displayedUnit, filter, nil, 
		function(name, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId)
--	print("0","prepare")


			local nNextIndex = nextIndex(self)
			local unitCasterGUID 
			if unitCaster then unitCasterGUID=UnitGUID(unitCaster) end

			if not nNextIndex then

				return false
			end
 
			if name  then

				if IRF3.db.enableSpellTimer then--spell timer사용할때(시작)

				if indexSpellName[name] and spellId ~= blockSpellID[name] then

					local index = indexSpellName[name]
--print("2",index)
					if indexSpellInfo[index] and indexSpellInfo[index][name] then
						local spell = indexSpellInfo[index][name] -- spell, efilter,use순서
--print("-2-")
--print(spell[1])--spell name
--print(spell[2])--harmful, helpful player
--print(spell[3])--1~4. 3,4는 디버프
--print(filter) 
--print("3",spellId, unitCaster,IRF3.AuraMasteryGUID[unitCasterGUID][1],IRF3.AuraMasteryGUID[unitCasterGUID][2],IRF3.AuraMasteryGUID[unitCasterGUID][3],IRF3.AuraMasteryGUID[unitCasterGUID][4])

						--오라숙련 true/false , icon, duration, expirationTime

						if (spell[1] == name) or (type(spell[1]) == "number" and spell[1] == spellId) then
							local frame = self["spellTimer" .. nNextIndex]
							local filterNum = spell[3]


							if filterNum > 2 or (unitCaster == "player") then	-- UnitBuff 호출 할 때 필터는 생략했다. 버프인지 디버프인지 비교 안했음.

								if (name==SL(19876) or name==SL(19888) or name ==SL(19891) or name ==SL(32223) or name ==SL(27149) or name== SL(19746) or name==SL(54043))  then --암/화/냉/성전자/기원/집중/응보


									--오라는 지속적으로 UNIT_AURA가 호출되는것을 이용
									if IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer and IRF3.db.units.showSurvivalAsSpellIcon[10] then 		--생존기 아이콘 표기, 그리고 오라숙련이 선택되어 있을 경우에는, 성기사 오라를 오숙으로 전환


										if unitCaster and IRF3.AuraMasteryGUID[unitCasterGUID] and  IRF3.AuraMasteryGUID[unitCasterGUID][1] then --and not (IRF3.AuraMasteryTargetGUID[self.unitGUID] and IRF3.AuraMasteryTargetGUID[self.unitGUID]==unitCasterGUID)  then  --오라숙련에 해당할경우 원래 오라대신 오라숙련으로 대체
										--또한 이미 표시중이면 pass

										--AuraMasteryGUID : true,icon,duration,expirationTime 순서
--											print("A",IRF3.AuraMasteryGUID[unitCasterGUID][1],IRF3.AuraMasteryGUID[unitCasterGUID][2],IRF3.AuraMasteryGUID[unitCasterGUID][3],IRF3.AuraMasteryGUID[unitCasterGUID][4])
											--천수/오숙의 경우 공대버프에는 duration안 들어옴(타이머표시 및 만료확인 불가). 둘다 6초니까 강제 지정(
--											setIcon(frame, index, IRF3.AuraMasteryGUID[unitCasterGUID][3], IRF3.AuraMasteryGUID[unitCasterGUID][4], IRF3.AuraMasteryGUID[unitCasterGUID][2], count, spellId,unitCaster)
											
											setIcon(frame, index, 6, IRF3.AuraMasteryGUID[unitCasterGUID][4], IRF3.AuraMasteryGUID[unitCasterGUID][2], count, spellId,unitCaster)



--print("1")
											setSort(self, frame, index)
											IRF3.AuraMasteryTargetGUID[self.unitGUID] = unitCasterGUID
											IRF3.AuraMasteryTargetGUIDAura[self.unitGUID] = spellId
--											print("target등록",name,self.unit,IRF3.AuraMasteryTargetGUID[self.unitGUID])
											self.AuraMasteryFrame=frame -- 만료시 제거할 아이콘프레임 위치 저장해두(seticon,setsort만 따로 돌리기위해) 
	
--[[대상제거로직은 member line2488로 이동
										elseif IRF3.AuraMasteryTargetGUID[self.unitGUID] and IRF3.AuraMasteryTargetGUIDAura[self.unitGUID] == spellId and self.unitGUID ~= unitCasterGUID  then -- 오라숙련 킨사람이 없으면 대상도해제, 그리고 만료지정
--											print("target 해제",name,self.unit)
											IRF3.AuraMasteryTargetGUID[self.unitGUID]=nil
											IRF3.AuraMasteryTargetGUIDAura[self.unitGUID]=nil
--											print(self.unit,"만료")
											setIcon(frame, index, 0, GetTime(), nil, count, spellId,unitCaster)
											setSort(self, frame, index)

]]--
										end
									end
								elseif spellId==70940 then	--천수/오숙의 경우 공대버프에는 duration안 들어옴(타이머표시 및 만료확인 불가). 둘다 6초니까 강제 지정(
									setIcon(frame, index, 6, GetTime()+5.9, icon, count, spellId,unitCaster) 
									setSort(self, frame, index)
								else

									setIcon(frame, index, duration, expirationTime, icon, count, spellId,unitCaster) 
									setSort(self, frame, index)

								end



							end		
						end
					end
				end
			end--spell timer사용할때(끝)
 

			if filter=="HELPFUL" then
----한번 ForEach돌때 survival spell도 같이 체크한다(aura loop감소용)--시작
				if IRF3.db.units.useSurvivalSkill then

					local spellKey, skillShortName, endTime,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion = allCheckSkill_new(self,name,expirationTime, unitCaster,spellId,findSpellInfoMain,findSpellInfoClass,findSpellInfoSub,findSpellInfoPotion)

					addSurvivalSkill(self, spellKey, skillShortName, endTime)
					survivalSkillOnUpdate(self)

				else
					initSurvivalSkill(self)
				end
----한번 ForEach돌때 survival spell도 같이 체크한다(aura loop감소용)--끝
 
			end



 



				return true
			end

			return false
		end
	)
end

--생존기로직을 여기에서 구동(SurvivalSkill의 allCheckSkill사용안함)



function InvenRaidFrames3Member_AllUpdateSpellTimer(self)
--print(1,self.unit)
	if not self or not self.displayedUnit then
		return
	end
	initSortTable(self)
	
	for removeIndex = 1, 18 do	

--print("1",removeIndex,self["spellTimer" .. removeIndex]:GetName(),self["spellTimer" .. removeIndex]:IsShown())
		if self["spellTimer" .. removeIndex]:IsShown() then --사용된 것만 초기화

			setIcon(self["spellTimer" .. removeIndex])
		end

	end
	
	allFind(self, "HELPFUL")
	if isHaveDebuff then		-- 디버프까지 사용하는 경우가 적으므로 미리 체크해두자.
		allFind(self, "HARMFUL")
	end

--[[-- 초기화 된 상태로 순차적으로 셋팅해서 나머지 다시 초기화 할 필요없어졌다.
	for removeIndex = nextIndex(self) or 18, 18 do	
		if InvenRaidFrames3CharDB.spellTimer[removeIndex].use ~= 0 then

			setIcon(self["spellTimer" .. removeIndex])
		end
	end
]]--


end

function IRF3:BuildSpellTimerList()
	table.wipe(usedIndex)
	table.wipe(indexSpellInfo)
	table.wipe(indexSpellName)
	indexSpellName = {}
	isHaveDebuff = false


	--공대생존기 아이콘표시를 선택한 경우, 16/17인덱스(hidden)에 추가
	if IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer then

--방벽 IRF3.db.units.showSurvivalAsSpellIcon[1] and (SL(871) ..",") or ""
--최저 IRF3.db.units.showSurvivalAsSpellIcon[2] and (SL(12975) ..",") or ""
--그망 IRF3.db.units.showSurvivalAsSpellIcon[3] and (SL(31224)  ..",") or ""
--소멸 IRF3.db.units.showSurvivalAsSpellIcon[4] and (SL(11327) ..",") or ""
--얼방 IRF3.db.units.showSurvivalAsSpellIcon[5] and (SL(45438) ..",") or ""
--보축 IRF3.db.units.showSurvivalAsSpellIcon[6] and (SL(1022) ..",") or ""
--희축 IRF3.db.units.showSurvivalAsSpellIcon[7] and (SL(6940) ..",") or ""
--천상의 보호막 IRF3.db.units.showSurvivalAsSpellIcon[8] and (SL(642) ..",") or ""
--천수 IRF3.db.units.showSurvivalAsSpellIcon[9] and (SL(70940) ..",") or ""
--오라숙련이 10번인데 특이케이스므로 마지막라인에서 처리
--고억 IRF3.db.units.showSurvivalAsSpellIcon[11] and (SL(33206) ..",") or ""
		


		InvenRaidFrames3CharDB.spellTimer[16].name = (IRF3.db.units.showSurvivalAsSpellIcon[1] and SL(871) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[2] and SL(12975) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[3] and SL(31224)  .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[4] and SL(11327) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[5] and SL(45438) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[6] and SL(1022) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[7] and SL(6940) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[8] and SL(642) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[9] and SL(70940) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[11] and SL(33206) .."," or "")
		if not InvenRaidFrames3CharDB.spellTimer[16].scale then  InvenRaidFrames3CharDB.spellTimer[16].scale= 1.2 end
		if not InvenRaidFrames3CharDB.spellTimer[16].pos then InvenRaidFrames3CharDB.spellTimer[16].pos= "TOPRIGHT" end

		InvenRaidFrames3CharDB.spellTimer[16].display = 2
		InvenRaidFrames3CharDB.spellTimer[16].use = 3
--print(InvenRaidFrames3CharDB.spellTimer[16].name)
--수호SL(47788)
--생본SL(61336)
--껍질SL(22812)
--자극SL(29166)
--대보SL(48707)
--얼인SL(48792)
--불굴SL(51271)
--흡혈SL(55233)
--속도SL(53908)
--마폭SL(53909)


		InvenRaidFrames3CharDB.spellTimer[17].name = (IRF3.db.units.showSurvivalAsSpellIcon[12] and SL(47788) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[13] and SL(61336) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[14] and SL(22812)  .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[15] and SL(29166) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[16] and SL(48707) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[17] and SL(48792) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[18] and SL(51271) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[19] and SL(55233) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[20] and SL(53908) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[21] and SL(53909) .."," or "")
		if not InvenRaidFrames3CharDB.spellTimer[16].scale then InvenRaidFrames3CharDB.spellTimer[17].scale = 1.2 else InvenRaidFrames3CharDB.spellTimer[17].scale=InvenRaidFrames3CharDB.spellTimer[16].scale end
		if not InvenRaidFrames3CharDB.spellTimer[16].pos then InvenRaidFrames3CharDB.spellTimer[17].pos= "TOPRIGHT" else InvenRaidFrames3CharDB.spellTimer[17].pos = InvenRaidFrames3CharDB.spellTimer[16].pos end
		InvenRaidFrames3CharDB.spellTimer[17].display = 2
		InvenRaidFrames3CharDB.spellTimer[17].use = 3
--print(InvenRaidFrames3CharDB.spellTimer[17].name)
--오숙SL(31821)
--오숙에 의해 강화되는 실제 버프 : SL(19876) ..","..SL(19888) ..","..SL(19891)..","..SL(32223)..","..SL(27149)..","..SL(19746)..","..SL(54043)	 오라숙련(모든 오라)
--파괴불가능SL(53762)
--신의 가호(498)
--천상의 찬가(64844) + 희망의 찬가(64904)

--		InvenRaidFrames3CharDB.spellTimer[18].name = IRF3.db.units.showSurvivalAsSpellIcon[10] and SL(19876) ..","..SL(19888) ..","..SL(19891)..","..SL(32223)..","..SL(27149)..","..SL(19746)..","..SL(54043) or ""
		InvenRaidFrames3CharDB.spellTimer[18].name = (IRF3.db.units.showSurvivalAsSpellIcon[10] and SL(19876) ..","..SL(19888) ..","..SL(19891)..","..SL(32223)..","..SL(27149)..","..SL(19746)..","..SL(54043).."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[22] and SL(53762) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[23] and SL(498) .."," or "")..(IRF3.db.units.showSurvivalAsSpellIcon[24] and SL(64844) ..","..SL(64904).."," or "")

		if not InvenRaidFrames3CharDB.spellTimer[16].scale then InvenRaidFrames3CharDB.spellTimer[18].scale = 1.2 else InvenRaidFrames3CharDB.spellTimer[18].scale=InvenRaidFrames3CharDB.spellTimer[16].scale end
		if not InvenRaidFrames3CharDB.spellTimer[16].pos then InvenRaidFrames3CharDB.spellTimer[18].pos= "TOPRIGHT" else InvenRaidFrames3CharDB.spellTimer[18].pos = InvenRaidFrames3CharDB.spellTimer[16].pos end
		InvenRaidFrames3CharDB.spellTimer[18].display = 2
		InvenRaidFrames3CharDB.spellTimer[18].use = 3

--print(InvenRaidFrames3CharDB.spellTimer[18].name)
--print("공대 생존기 아이콘 추가",InvenRaidFrames3CharDB.spellTimer[16].name)
	else
		InvenRaidFrames3CharDB.spellTimer[16].name=nil
--		InvenRaidFrames3CharDB.spellTimer[16].scale=1
--		InvenRaidFrames3CharDB.spellTimer[16].pos="TOPRIGHT"
		InvenRaidFrames3CharDB.spellTimer[16].display =2
		InvenRaidFrames3CharDB.spellTimer[16].use =0

		InvenRaidFrames3CharDB.spellTimer[17].name=nil
--		InvenRaidFrames3CharDB.spellTimer[17].scale=1
--		InvenRaidFrames3CharDB.spellTimer[17].pos="TOPRIGHT"
		InvenRaidFrames3CharDB.spellTimer[17].display =2
		InvenRaidFrames3CharDB.spellTimer[17].use =0

		InvenRaidFrames3CharDB.spellTimer[18].name=nil
--		InvenRaidFrames3CharDB.spellTimer[18].scale=1
--		InvenRaidFrames3CharDB.spellTimer[18].pos="TOPRIGHT"
		InvenRaidFrames3CharDB.spellTimer[18].display =2
		InvenRaidFrames3CharDB.spellTimer[18].use =0


		
--print("공대 생존기 주문타이머 삭제", InvenRaidFrames3CharDB.spellTimer[16] and InvenRaidFrames3CharDB.spellTimer[16].name or "empty" )
	end


	for i = 1, #InvenRaidFrames3CharDB.spellTimer do
		if eFilter[InvenRaidFrames3CharDB.spellTimer[i].use] and InvenRaidFrames3CharDB.spellTimer[i].name then

			table.insert(usedIndex, i)
			local spells = {}
			spells[1], spells[2], spells[3], spells[4], spells[5], spells[6], spells[7], spells[8], spells[9], spells[10], spells[11] = delimiter:split(InvenRaidFrames3CharDB.spellTimer[i].name)

			indexSpellInfo[i] = {}
			for _, spell in ipairs(spells) do
				local info = {spell:trim(), eFilter[InvenRaidFrames3CharDB.spellTimer[i].use], InvenRaidFrames3CharDB.spellTimer[i].use}
				--table.insert(indexSpellInfo[i], info)
				

				indexSpellInfo[i][info[1]] = info
				indexSpellName[spell] = i

				if InvenRaidFrames3CharDB.spellTimer[i].use == 2 or InvenRaidFrames3CharDB.spellTimer[i].use == 4 then
					isHaveDebuff = true
				end
			end
		end
	end


end

function IRF3:SetupSpellTimer(reset)
	if not reset and InvenRaidFrames3CharDB.spellTimer then  --구버전에서 올라올떄 (기존에 15개보다 적은 값이 있을 경우) 기존 값 유지--and #InvenRaidFrames3CharDB.spellTimer == 18 then return end 


		if #InvenRaidFrames3CharDB.spellTimer < 18 then 

			for i = #InvenRaidFrames3CharDB.spellTimer , 18 do
				--기존인덱스 이후는 사용안함으로 설정(충돌방지용)
				InvenRaidFrames3CharDB.spellTimer[i] = InvenRaidFrames3CharDB.spellTimer[i] or {}
				InvenRaidFrames3CharDB.spellTimer[i].use = 0		-- 1:내가 시전한 버프 2:내가 시전한 디버프 3:모든 버프 4:모든 디버프 0:사용 안함
				InvenRaidFrames3CharDB.spellTimer[i].display = 1	-- 1:아이콘 + 남은 시간 2:아이콘 3:남은 시간 4:아이콘 + 경과 시간 5:경과 시간
				InvenRaidFrames3CharDB.spellTimer[i].scale = 1
				InvenRaidFrames3CharDB.spellTimer[i].pos = ePos[i]
			end	
		end
		return --정상적인 사용중인 경우 skip
	end 

--reset이거나 주문타이머 데이터가 아예 없을때는 초기화

	InvenRaidFrames3CharDB.spellTimer = InvenRaidFrames3CharDB.spellTimer or {}
	for i = 1, 18 do

		InvenRaidFrames3CharDB.spellTimer[i] = InvenRaidFrames3CharDB.spellTimer[i] or {}
		InvenRaidFrames3CharDB.spellTimer[i].use = 0		-- 1:내가 시전한 버프 2:내가 시전한 디버프 3:모든 버프 4:모든 디버프 0:사용 안함
		InvenRaidFrames3CharDB.spellTimer[i].display = 1	-- 1:아이콘 + 남은 시간 2:아이콘 3:남은 시간 4:아이콘 + 경과 시간 5:경과 시간
		InvenRaidFrames3CharDB.spellTimer[i].scale = 1
		InvenRaidFrames3CharDB.spellTimer[i].pos = ePos[1]
		InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1=1
	end

	if self.playerClass == "ROGUE" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(57934)	-- 속임수 거래


	elseif self.playerClass == "PRIEST" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(139)	-- 소생
		InvenRaidFrames3CharDB.spellTimer[2].use = 3
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(17)	-- 신의 권능: 보호막
		InvenRaidFrames3CharDB.spellTimer[3].use = 4
		InvenRaidFrames3CharDB.spellTimer[3].name = SL(6788)	-- 약화된 영혼
		InvenRaidFrames3CharDB.spellTimer[4].use = 1
		InvenRaidFrames3CharDB.spellTimer[4].name = SL(41635)	-- 회복의 기원




	elseif self.playerClass == "HUNTER" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(34477)	-- 눈속임 


	elseif self.playerClass == "DRUID" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(33763)	-- 피어나는 생명
		InvenRaidFrames3CharDB.spellTimer[2].use = 1
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(774)	-- 회복
		InvenRaidFrames3CharDB.spellTimer[3].use = 1
		InvenRaidFrames3CharDB.spellTimer[3].name = SL(8936)	-- 재생
		InvenRaidFrames3CharDB.spellTimer[4].use = 1
		InvenRaidFrames3CharDB.spellTimer[4].name = SL(48438)	-- 급속 성장
		InvenRaidFrames3CharDB.spellTimer[5].use = 1
		InvenRaidFrames3CharDB.spellTimer[5].name = SL(155777)	-- 회복 (싹틔우기)




	elseif self.playerClass == "SHAMAN" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(61295)	-- 성난 해일
		InvenRaidFrames3CharDB.spellTimer[1].pos = "BOTTOMRIGHT"
		InvenRaidFrames3CharDB.spellTimer[2].use = 1
if not IRF3.isClassic then
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(974)..","..SL(52127)..","..SL(192106)	-- 대지의 보호막, 물의 보호막 52127, 번개 보호막 192106
else		
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(974)..","..SL(24398)..","..SL(10432)	-- 대지의 보호막, 물의 보호막 52127, 번개 보호막 192106
end
		InvenRaidFrames3CharDB.spellTimer[2].pos = "BOTTOM"
		InvenRaidFrames3CharDB.spellTimer[3].use = 1
		InvenRaidFrames3CharDB.spellTimer[3].name = SL(157504)..","..SL(192082)..","..SL(325174)..","..SL(207498)..","..SL(320763) -- 폭우의 토템,바람 질주,정신의 고리 토템,선조의 보호,마나 해일 토템
		InvenRaidFrames3CharDB.spellTimer[3].pos = "TOPLEFT"

 


	elseif self.playerClass == "PALADIN" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 3
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(53563)..","..SL(53601) -- 빛의 봉화,성스러운 보호막 --..","..SL(156910)	-- 빛의 봉화, 신념의 봉화
		InvenRaidFrames3CharDB.spellTimer[2].use = 1
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(1022)..","..SL(1044)..","..SL(6940)..","..SL(1038)	-- 보호의 손길, 자유의 손길, 희생의 손길, 구원의 손길
	elseif self.playerClass == "MONK" then
		InvenRaidFrames3CharDB.spellTimer[1].use = 1
		InvenRaidFrames3CharDB.spellTimer[1].name = SL(124682)	-- 포용의 안개
		InvenRaidFrames3CharDB.spellTimer[2].use = 1
		InvenRaidFrames3CharDB.spellTimer[2].name = SL(119611)	-- 소생의 안개 115151
		InvenRaidFrames3CharDB.spellTimer[3].use = 1
		InvenRaidFrames3CharDB.spellTimer[3].name = SL(191840)	-- 정수의 샘
	end


	 


end


-----------survival Spell logic included

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

------버프체크로직embed
