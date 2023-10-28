--[[
인벤 레이드 프레임 Core 스크립트
]]
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local overlord = CreateFrame("Button", (...).."Overlord", UIParent, "SecureHandlerClickTemplate")
local IRF3 = CreateFrame("Frame", ..., overlord, "SecureHandlerAttributeTemplate")

IRF3:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
IRF3:RegisterEvent("PLAYER_LOGIN")
IRF3:RegisterEvent("GROUP_JOINED")
IRF3:RegisterEvent("GROUP_LEFT")
IRF3:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
IRF3:RegisterEvent("ADDON_LOADED")
--IRF3:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
IRF3:RegisterEvent("ZONE_CHANGED_NEW_AREA")
IRF3:RegisterEvent("PLAYER_ENTERING_WORLD")
IRF3:SetFrameStrata("MEDIUM")
IRF3:SetFrameLevel(2)
IRF3:SetMovable(true)
IRF3:SetClampedToScreen(true) 

local spellName=GetSpellInfo(48066)--보호막
local spellName2=GetSpellInfo(47515)--신의 보호
local spellName3=GetSpellInfo(64413)--고대왕의 보호
local spellName4=GetSpellInfo(64411)--고대왕의 축복


local wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()
if wowtocversion and wowtocversion < 90000 then
	IRF3.isClassic = true
	if wowtocversion >30000 then
		IRF3.isWOTLK = true
	else
		IRF3.isWOTLK = false
	end
 
end

 

local _G = _G
local type = _G.type
local pairs = _G.pairs


local unpack = _G.unpack
local GetSpellInfo = _G.GetSpellInfo
local LBDB = LibStub("LibBlueDB-1.0")
 
local function getMemberCount()
	if(IsInRaid()) then
		return GetNumGroupMembers();
	elseif(IsInGroup())then
		return GetNumGroupMembers()-1;
	else
		return 0;
	end
end

local GetSpellName = _G.GetSpellName


local function getMemberIndex(index)
	local pName = "";
	if(IsInRaid()) then
		pName = "raid"..index

	elseif(IsInGroup() and index > 0) then
		pName = "party"..index

	elseif(index == 0) then
		pName = "player"

	end
	return pName;
end

local COMBATLOG_FILTER_FRIENDLY_PLAYERS = bit.bor(
	COMBATLOG_OBJECT_AFFILIATION_MINE,
	COMBATLOG_OBJECT_AFFILIATION_PARTY,
	COMBATLOG_OBJECT_AFFILIATION_RAID,
--	COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
	COMBATLOG_OBJECT_REACTION_FRIENDLY,
	COMBATLOG_OBJECT_CONTROL_PLAYER,
	COMBATLOG_OBJECT_TYPE_PLAYER
)

local COMBATLOG_FILTER_MASK=bit.bor(
	COMBATLOG_OBJECT_AFFILIATION_MINE,
	COMBATLOG_OBJECT_AFFILIATION_PARTY,
	COMBATLOG_OBJECT_AFFILIATION_RAID
)

function IRF3:AutoProfileReload(init)

if not InvenRaidFrames3CharDB then return end


	--profile reload by spec and member

	local profile
	if  GetNumGroupMembers() ==0  then --파티없을때

		profile=InvenRaidFrames3CharDB.profile_1m 
	elseif  GetNumGroupMembers() <6 then
		profile=InvenRaidFrames3CharDB.profile_5m
	elseif  GetNumGroupMembers() <11 then
		profile=InvenRaidFrames3CharDB.profile_10m
	elseif  GetNumGroupMembers() <26 then
		profile=InvenRaidFrames3CharDB.profile_25m
	else
		profile=InvenRaidFrames3CharDB.profile_40m
	end


	if GetActiveTalentGroup()== 1 then
		profile =InvenRaidFrames3CharDB.profile_spec1 or profile
	else
		profile =InvenRaidFrames3CharDB.profile_spec2 or profile
	end


	if init then--초기실행시에는 core에서 그냥 실행
--print(InvenRaidFrames3.profileName) --초기로딩시엔 InvenRaidFrames3.profileName값이 없어서 후속 로직이 오류남. 따라서 초기실행시엔 자동프로필 적용하지 않음 
		IRF3:ApplyPorfile()
	elseif profile and (not applied_profile or applied_profile ~=profile) then  --프로필 조건이 변경되었을경우만 수행(초기제외)

		applied_profile=profile

		if InvenRaidFrames3.profileName then --아직로드되기 전일때가 있다
		 	IRF3:SetProfile(profile) 
			IRF3:ApplyPorfile()
			IRF3:Message((L["lime_profile_apply_message_01"]):format(profile))
		end

	end



	
end

function IRF3:ForEachAura(unit, filter, maxCount, func)

		local i = 1
		while true do
			if maxCount and i > maxCount  then

				return
			elseif func(UnitAura(unit, i, filter)) then

--				func(UnitAura(unit, i, filter))
			else


				return
			end
			i = i + 1
		end
--~ 	end	
end

function IRF3:delayedFunc()
--전투중으로 인해 예약된 작업들 수행(MemberSort, 전투종료 후 잔여HealIcon 클리어(누락방지용)
	InvenRaidFrames3Member_Sort()
	InvenRaidFrames3_ClearHealIcon()
end
function IRF3:PLAYER_LOGIN()
	self.PLAYER_LOGIN = nil
	self.playerClass = select(2, UnitClass("player"))
	self:InitDB()
	if GetAddOnMetadata then --old API 
		self.version = GetAddOnMetadata(self:GetName(), "Version")
		self.website = GetAddOnMetadata(self:GetName(), "X-Website")
	else
		self.version = C_AddOns.GetAddOnMetadata(self:GetName(), "Version")
		self.website = C_AddOns.GetAddOnMetadata(self:GetName(), "X-Website")
	end
--	self:ApplyPorfile()

	IRF3:AutoProfileReload(true)--첫로딩시에는 기존 프로필 유지(자동프로필정보를 못읽은 경우가 있으므로 첫로딩은 기존설정 유지.그렇지 않을경우 각종 좌표 오류발생함)
 




--구버전 보정:처음사용시 현재특성의 클릭캐스트정보가 비어있으면 이전것을 그대로두고, 아니면 저장된 특성db로 교체

	if InvenRaidFrames3CharDB.clickCasting and   InvenRaidFrames3CharDB.clickCasting[1] and not InvenRaidFrames3CharDB.clickCasting[2] then


	IRF3:Message(L["ClickCast_desc1"])
			for k,v in pairs(InvenRaidFrames3CharDB.clickCasting[1] ) do

				InvenRaidFrames3CharDB.clickCasting[2][k]=v
			end
		

	else

--		IRF3:Message("복사 불필요" )
	end

--구버전 보정 : 기존에 주문타이머 동적표시 및 폰트겹치기가 체크되어 있으면 개별 설정으로 변경후 false로 전환

	if IRF3.db.enableFadeIn then
		for i=1, 15 do --15까지만(이후는 생존기 아이콘이므로)
			InvenRaidFrames3CharDB.spellTimer[i].FadeIn=true
		end
		IRF3.db.enableFadeIn=false
	end



	if IRF3.db.enableSpellTimerType1 then
		for i=1, 15 do --15까지만(이후는 생존기 아이콘이므로)
			InvenRaidFrames3CharDB.spellTimer[i].enableSpellTimerType1=true
		end
		IRF3.db.enableSpellTimerType1=false
	end



	--Clique registration / or inbuilt clickcast map
	if IRF3.db and IRF3.db.enableClickCast then --자체 클릭캐스트사용할때는 Clique무관하게 mapping수행

		self:SelectClickCastingDB()

	elseif Clique and IRF3.db and IRF3.db.useClique  then --Clique가 있고,선택되어있고, 자체클릭캐스트가 아닐때
		
		for _, header in pairs(IRF3.headers) do
			for _, member in pairs(header.members) do
			
			Clique:RegisterFrame(member)
			end
		end

		for _, member in pairs(IRF3.tankheaders.members) do
			Clique:RegisterFrame(member)
		end

		for _, member in pairs(IRF3.petHeader.members) do
			Clique:RegisterFrame(member)
		end

	end 



	

	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
--	self:RegisterEvent("PET_BATTLE_OPENING_START")
--	self:RegisterEvent("PET_BATTLE_CLOSE")
	self.PLAYER_REGEN_ENABLED = function()
		 IRF3:UpdateTooltipState()
--		print("A",IRF3.delayedAction) --전투중 예약작업(player sort등)
		if IRF3.delayedAction then --전투종료되면 예약된 작업 실행
			IRF3:delayedFunc()
			IRF3.delayedAction=false
		end
	end
	self.PLAYER_REGEN_DISABLED = self.UpdateTooltipState
	LibStub("LibMapButton-1.1"):CreateButton(self, "InvenRaidFrames3MapButton", "Interface\\AddOns\\InvenRaidFrames3\\Texture\\Icon.tga", 190, InvenRaidFrames3DB.minimapButton)
	self.mapButtonMenu:SetParent(InvenRaidFrames3MapButton)
	self.mapButtonMenu:SetPoint("CENTER", 0, 0)
	self.mapButtonMenu:Hide()


	LibStub("LibDataBroker-1.1"):NewDataObject("InvenRaidFrames3", {
		type = "launcher",
		text = "IRF3",
		OnClick = function(_, button) IRF3:OnClick(button) end,
		icon = "Interface\\AddOns\\InvenRaidFrames3\\Texture\\Icon.tga",
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			IRF3:OnTooltip(tooltip)
		end,
		OnLeave = GameTooltip_Hide,
	})
	self:SetScript("OnHide", InvenRaidFrames3Member_OnDragStop)
	LibStub("LibRealDispel-1.0").RegisterCallback(self, "Update", function()
		for member in pairs(IRF3.visibleMembers) do
			if member:GetScript("OnEvent") and member:IsEventRegistered("UNIT_AURA") and member.displayedUnit then
				member:GetScript("OnEvent")(member, "UNIT_AURA", member.displayedUnit)
			end
		end
	end)



IRF3:SetupLib()
IRF3:SetupBuff()
IRF3:SetupSpellTimerYn()
IRF3:SetupMemberSelect()

 --순차멤버선택 2번-(보호막시전)일때 방어전담 제외 보정 로직
InvenRaidFrames3CharDB.memberselect = InvenRaidFrames3CharDB.memberselect or 0

			if InvenRaidFrames3CharDB.memberselect==0 then
				SecureHandlerUnwrapScript(IRF3PartyTarget,"OnClick")
				SecureHandlerUnwrapScript(IRF3RaidTarget,"OnClick")
				SecureHandlerUnwrapScript(IRF3RaidTargetMelee,"OnClick")
			elseif InvenRaidFrames3CharDB.memberselect==1 then
--do nothing
			elseif InvenRaidFrames3CharDB.memberselect>1 then

				IRF3:MemberSelect_Adjust()
			end


end	 




	 
 
 	



function IRF3:LoadPosition() 

if InCombatLockdown() then return end
	self:SetUserPlaced(false)
	self:SetScale(self.db.scale)
	self:ClearAllPoints()

	if self.db.px then
		self:SetPoint(self.db.anchor, UIParent, self.db.px / self.db.scale, self.db.py / self.db.scale)
	else
		self:SetPoint(self.db.anchor, UIParent, "CENTER", 0, 0)
	end

	if self.db.tankpx  then

local tankpx = self.db.tankpx
local tankpy = self.db.tankpy

self.tankheaders:ClearAllPoints()
if IRF3.db.enableTankFrame then 



		self.tankheaders:SetPoint(self.db.anchor, self , tankpx,tankpy)

	else

		self.tankheaders:SetPoint(self.db.anchor, UIParent, "CENTER", 0, 0)
	end
end
	


--	self.petHeader:SetUserPlaced(nil)
	self.petHeader:SetScale(self.db.petscale)

	self.petHeader:ClearAllPoints()

	if self.db.petpx then

 

		 self.petHeader:SetPoint(self.db.petanchor, UIParent, self.db.petanchor, self.db.petpx / (self.db.petscale * self.db.scale), self.db.petpy / (self.db.petscale * self.db.scale))
		--self.petHeader:SetPoint(self.db.petanchor, self.db.petpx , self.db.petpy )
		--self.petHeader:SetPoint(self.db.petanchor, UIParent,  self.db.petpx / (self.db.petscale * self.db.scale), self.db.petpy / (self.db.petscale * self.db.scale))
		--self.petHeader:SetPoint(self.db.petanchor, UIParent , self.db.petpx, self.db.petpy)
 
	

	else 

		self.petHeader:SetPoint(self.db.petanchor, UIParent, "CENTER", 0, 0)
	end 
end

 
 


function IRF3:SavePosition() 
	if self.db.anchor == "TOPLEFT" then
		self.db.px = self:GetLeft() * self.db.scale
		self.db.py = self:GetTop() * self.db.scale - UIParent:GetTop()

	elseif self.db.anchor == "TOPRIGHT" then
		self.db.px = self:GetRight() * self.db.scale - UIParent:GetRight()
		self.db.py = self:GetTop() * self.db.scale - UIParent:GetTop()
	elseif self.db.anchor == "BOTTOMLEFT" then
		self.db.px = self:GetLeft() * self.db.scale
		self.db.py = self:GetBottom() * self.db.scale
	elseif self.db.anchor == "BOTTOMRIGHT" then
		self.db.px = self:GetRight() * self.db.scale - UIParent:GetRight()
		self.db.py = self:GetBottom() * self.db.scale
	end


	if self.db.petanchor == "TOPLEFT" then
			if self.petHeader:GetLeft()  and self.petHeader:GetTop() then
				self.db.petpx = (self.petHeader:GetLeft()   )  * ((self.db.petscale or 1) * (self.db.scale or 1))
				self.db.petpy = (self.petHeader:GetTop() )  * ((self.db.petscale or 1) * (self.db.scale or 1)) - UIParent:GetTop()
			end


	elseif self.db.petanchor == "TOPRIGHT" then
			if self.petHeader:GetRight() and self.petHeader:GetTop() then
				self.db.petpx = self.petHeader:GetRight()  * ((self.db.petscale or 1) * (self.db.scale or 1)) - UIParent:GetRight()
				self.db.petpy = self.petHeader:GetTop()  * ((self.db.petscale or 1) * (self.db.scale or 1)) - UIParent:GetTop()
			end

	elseif self.db.petanchor == "BOTTOMLEFT" then
			if self.petHeader:GetLeft() and self.petHeader:GetBottom() then
				self.db.petpx = self.petHeader:GetLeft()  * ((self.db.petscale or 1) * (self.db.scale or 1))
				self.db.petpy = self.petHeader:GetBottom()  * ((self.db.petscale or 1) * (self.db.scale or 1))
			end

	elseif self.db.petanchor == "BOTTOMRIGHT" then
			if self.petHeader:GetRight() and self.petHeader:GetBottom() then
				self.db.petpx = self.petHeader:GetRight()  * ((self.db.petscale or 1) * (self.db.scale or 1)) - UIParent:GetRight()
				self.db.petpy = self.petHeader:GetBottom()  * ((self.db.petscale or 1) * (self.db.scale or 1))
			end

	end 
 
	
--self.db.tankpx= IRF3.tankheaders[0]:GetLeft() * self.db.scale
--self.db.tankpy= IRF3.tankheaders[0]:GetTop() * self.db.scale -UIParent:GetTop()

if IRF3.db.enableTankFrame and IRF3.tankheaders:GetLeft() and IRF3.tankheaders:GetTop()  then 
		self.db.tankpx= IRF3.tankheaders:GetLeft()   - self:GetLeft()
		self.db.tankpy= IRF3.tankheaders:GetTop()   - self:GetTop()

end

end

function IRF3:UpdateTooltipState()

	if self.db.units.tooltip == 0 then
		self.tootipState = nil
	elseif self.db.units.tooltip == 1 then
		self.tootipState = true
	elseif InCombatLockdown() or UnitAffectingCombat("player") then
		self.tootipState = self.db.units.tooltip == 3
	elseif self.db.units.tooltip == 2 then
		self.tootipState = true
	else
		self.tootipState = nil
	end

	if self.onEnter then
		InvenRaidFrames3Member_OnEnter(self.onEnter)
	end
end

function IRF3:BorderUpdate(fast)
	if self.db.border then
		if fast then

			self.border.updater:GetScript("OnUpdate")(self.border.updater)
		else
			self.border.updater:Show()
		end
		self.border:Show()
		self.border:SetAlpha(IRF3.db.borderBackdropBorder[4] or 1)
--		self.border.updater:Show()
		self.petHeader.border:Show()
--		self.petHeader.border:SetAlpha(IRF3.db.borderBackdropBorder[4] or 1)
--print(self.petHeader.members[1].unit,self.petHeader.members[1].unit)
		if self.petHeader.members[1].unit then --팻이 하나라도 있으면 팻테두리 적용
			self.petHeader.border:SetAlpha(IRF3.db.borderBackdropBorder[4] or 1)			
		else
			self.petHeader.border:SetAlpha(0)			
		end

	else

		self.border:Hide()
--		self.border:SetAlpha(0)
		self.petHeader.border:Hide()
	end
end

function IRF3:OnClick(button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, IRF3.mapButtonMenu, "cursor")

	elseif InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown() and InterfaceOptionsFramePanelContainer.displayedPanel == IRF3.optionFrame then
		InterfaceOptionsFrame_Show()

	elseif InterfaceOptionsFrame then
		if wowtocversion < 30402 then --리분 십자군PTR부터 인터페이스 옵션이 바뀌어서 interfaceoptionsframe이 사라짐
			InterfaceOptionsFrame_Show()
		end
		InterfaceOptionsFrame_OpenToCategory(IRF3.optionFrame)
	else

		InterfaceOptionsFrame_OpenToCategory(IRF3.optionFrame)
	end
end

function IRF3:OnTooltip(tooltip)
	tooltip = tooltip or GameTooltip
	tooltip:AddLine("Inven Raid Frames 3".." "..IRF3.version)
	tooltip:AddLine(L["Lime_leftclick"], 1, 1, 0)
	tooltip:AddLine(L["Lime_rightclick"], 1, 1, 0)
end

function IRF3:Message(msg)
	ChatFrame1:AddMessage("|cffffff00IRF3: |r"..msg, 1, 1, 1)
end

function IRF3:IsLeader()
	return IsInGroup() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end

function IRF3:IsLeader2()
	if IsInRaid() then
		return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
	elseif IsInGroup() then
		return true
	end
	return nil
end

local clearObjectFuncs = {}

function IRF3:RegisterClearObject(func)
	clearObjectFuncs[func] = true
end

function IRF3:CallbackClearObject(object)
	for func in pairs(clearObjectFuncs) do
		func(object)
	end
end

local function changeParent(frame, prevParent, newParent)
	if frame and frame:GetParent() == prevParent then
		frame:SetParent(newParent)

	end
end

function IRF3:HideBlizFrames()
	if not PartyFrame then
		return
	end
	local hide = self.db.hideBlizzardParty
	if hide then
		if not InCombatLockdown() then
			if PartyFrame:IsShown() then

				PartyFrame:Hide()
			end
		end
	else
--~ 		if not InCombatLockdown() then
--~ 			if not PartyFrame:IsShown() then
--~ 				PartyFrame:Show()
--~ 			end
--~ 		end
	end
end

--- 기본 파티 창 숨기기 코드

function IRF3:HideBlizzardPartyFrame(hide)
	self.db.hideBlizzardParty = hide
	self:HideBlizFrames()

	if hide then
		for i = 1, MAX_PARTY_MEMBERS do
			changeParent(_G["PartyMemberFrame"..i], UIParent, self.dummyParent)
		end


		changeParent(PartyMemberBackground, UIParent, self.dummyParent)
	else

		for i = 1, MAX_PARTY_MEMBERS do
			changeParent(_G["PartyMemberFrame"..i], self.dummyParent, UIParent)
		end

		changeParent(PartyMemberBackground, self.dummyParent, UIParent)
		
	end

end

function IRF3:GetHeaderHeight(member)
	if member then
		if member > 0 then
			return self.db.height * member + ((self.db.usePet == 2 and self.db.petHeight or 0) + self.db.offset) * (member - 1)--return self.db.height * member + (self.db.offset) * (member - 1)
		else
			return 0.1
		end
	else
		return (self.db.height + (self.db.usePet == 2 and self.db.petHeight or 0)) * 5 + self.db.offset * 4--return (self.db.height) * 5 + self.db.offset * 4
	end
end

function IRF3.GetSpellName(id)
	--if not GetSpellInfo(id) then print("IRF: spell id "..id.." removed!") end
	return GetSpellInfo(id) or ""
end
--[[
local savedStatus = true

function IRF3:PET_BATTLE_OPENING_START()
	savedStatus = self:GetAttribute("run") or IRF3.db.run
	self:SetAttribute("run", false)
end
function IRF3:PET_BATTLE_CLOSE()
	self:SetAttribute("run", savedStatus)
end
--]]

if not BACKDROP_IRF_16_16_2222 then
	BACKDROP_IRF_16_16_2222 = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Addons\\InvenRaidFrames3\\Texture\\Border.tga",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	};
end
if not BACKDROP_TOOLTIP_16_16_5555 then
	BACKDROP_TOOLTIP_16_16_5555 = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	};
end
if not BACKDROP_DIALOG_16_16_2222 then
	BACKDROP_DIALOG_16_16_2222 = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	};
end
if not BACKDROP_TESTWATERMARK_16_16_2222 then
	BACKDROP_TESTWATERMARK_16_16_2222 = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-TestWatermark-Border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	};
end

IRF3.dummyParent = CreateFrame("Frame")
IRF3.dummyParent:Hide()

IRF3.border = CreateFrame("Frame", nil, IRF3, BackdropTemplateMixin and "BackdropTemplate")
IRF3.border:SetFrameLevel(1)
IRF3.border:SetBackdrop(BACKDROP_IRF_16_16_2222)
IRF3.border.updater = CreateFrame("Frame", nil, IRF3.border)
IRF3.border.updater:Hide()

local function hasAllPoints(frame)
	return frame:GetLeft() and frame:GetRight() and frame:GetTop() and frame:GetBottom()
end

function IRF3:UpdateLayoutSkin()

	if not IRF3.db.borderEdgeValue or IRF3.db.borderEdgeValue == 1 or IRF3.db.borderEdgeValue == L["lime_a"] then
		IRF3.border:SetBackdrop(BACKDROP_IRF_16_16_2222)
	elseif IRF3.db.borderEdgeValue == 2 or IRF3.db.borderEdgeValue == "UI-Tooltip-Border" then
		IRF3.border:SetBackdrop(BACKDROP_TOOLTIP_16_16_5555)
	elseif IRF3.db.borderEdgeValue == 3 or IRF3.db.borderEdgeValue == "UI-DialogBox-Border" then
		IRF3.border:SetBackdrop(BACKDROP_DIALOG_16_16_2222)
	elseif IRF3.db.borderEdgeValue == 4 or IRF3.db.borderEdgeValue == "TestWaterMark" then
		IRF3.border:SetBackdrop(BACKDROP_TESTWATERMARK_16_16_2222)
	end
	
	IRF3.petHeader.border:SetBackdrop(IRF3.border:GetBackdrop())
	
	IRF3.border:SetBackdropColor(IRF3.db.borderBackdrop[1], IRF3.db.borderBackdrop[2], IRF3.db.borderBackdrop[3], IRF3.db.borderBackdrop[4] or 1)
	IRF3.border:SetBackdropBorderColor(IRF3.db.borderBackdropBorder[1], IRF3.db.borderBackdropBorder[2], IRF3.db.borderBackdropBorder[3], IRF3.db.borderBackdropBorder[4] or 1)
	IRF3.petHeader.border:SetBackdropColor(IRF3.db.borderBackdrop[1], IRF3.db.borderBackdrop[2], IRF3.db.borderBackdrop[3], IRF3.db.borderBackdrop[4] or 1)
	IRF3.petHeader.border:SetBackdropBorderColor(IRF3.db.borderBackdropBorder[1], IRF3.db.borderBackdropBorder[2], IRF3.db.borderBackdropBorder[3], IRF3.db.borderBackdropBorder[4] or 1)

end

IRF3.border.updater:SetScript("OnUpdate", function(self)

	IRF3:UpdateLayoutSkin()

	self:Hide()
	self = self:GetParent()
	self.headers = self:GetParent().headers
	self.count, self.left, self.right, self.top, self.bottom = 0
	for i = 0, 8 do
		if self.headers[i]:IsVisible() then
			self.count = self.count + 1
			if self.headers[i].visible > 0 then
				if hasAllPoints(self.headers[i]) then
					if not self.left or self.headers[i]:GetLeft() < self.left:GetLeft() then
						self.left = self.headers[i]
					end
					if not self.right or self.headers[i]:GetRight() > self.right:GetRight() then
						self.right = self.headers[i]
					end
					if IRF3.db.usePet == 2 and self.headers[i].members[self.headers[i].visible].petButton:IsShown() then
						if IRF3.db.anchor:find("TOP") then
							if not self.top or self.headers[i]:GetTop() > self.top:GetTop() then
								self.top = self.headers[i]
							end
							if not self.bottom or self.headers[i].members[self.headers[i].visible].petButton:GetBottom() < self.bottom:GetBottom() then
								self.bottom = self.headers[i].members[self.headers[i].visible].petButton
							end
						else
							if not self.top or self.headers[i].members[self.headers[i].visible].petButton:GetTop() > self.top:GetTop() then
								self.top = self.headers[i].members[self.headers[i].visible].petButton
							end
							if not self.bottom or self.headers[i]:GetBottom() < self.bottom:GetBottom() then
								self.bottom = self.headers[i]
							end
						end
					else
            if not self.top or self.headers[i]:GetTop() > self.top:GetTop() then
              self.top = self.headers[i]
            end
            if not self.bottom or self.headers[i]:GetBottom() < self.bottom:GetBottom() then
              self.bottom = self.headers[i]
            end
          end
				else
					self:SetAlpha(0)
					return self.updater:Show()
				end
			end
		end
	end
	if self.left then
		self:ClearAllPoints()
		if IRF3.db.anchor == "TOPLEFT" then
			self:SetPoint("TOP", -5, 5)
			self:SetPoint("LEFT", self.left, -5, 0)
			self:SetPoint("RIGHT", self.right, 5, 0)
			self:SetPoint("BOTTOM", self.bottom, "BOTTOM", 0, -5)
		elseif IRF3.db.anchor == "TOPRIGHT" then
			self:SetPoint("TOP", 5, 5)
			self:SetPoint("LEFT", self.left, -5, 0)
			self:SetPoint("RIGHT", self.right, 5, 0)
			self:SetPoint("BOTTOM", self.bottom, "BOTTOM", 0, -5)
		elseif IRF3.db.anchor == "BOTTOMLEFT" then
			self:SetPoint("BOTTOM", -5, -5)
			self:SetPoint("LEFT", self.left, -5, 0)
			self:SetPoint("RIGHT", self.right, 5, 0)
			self:SetPoint("TOP", self.top, 0, 5)
		elseif IRF3.db.anchor == "BOTTOMRIGHT" then
			self:SetPoint("BOTTOM", 5, -5)
			self:SetPoint("LEFT", self.left, -5, 0)
			self:SetPoint("RIGHT", self.right, 5, 0)
			self:SetPoint("TOP", self.top, 0, 5)
		end
		self:SetAlpha(1)
	else
		self:SetAlpha(0)
		if self.count > 0 then
			return self.updater:Show()
		end
	end
	self.headers, self.count, self.left, self.right, self.top, self.bottom, self.anchor = nil
end)

IRF3.optionFrame = CreateFrame("Frame", IRF3:GetName().."OptionFrame", InterfaceOptionsFramePanelContainer)
IRF3.optionFrame:Hide()
IRF3.optionFrame.name = "InvenRaidFrames3"
IRF3.optionFrame.addon = IRF3:GetName()
IRF3.optionFrame:SetScript("OnShow", function(self)

	if InCombatLockdown() then
		if not self.title then
			self.title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
			self.title:SetText(self.name)
			self.title:SetPoint("TOPLEFT", 8, -12)
			self.version = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			self.version:SetText("v"..IRF3.version)
			self.version:SetPoint("LEFT", self.title, "RIGHT", 2, 0)
			self.combatWarn = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
			self.combatWarn:SetText(L["Lime_option_error"])
			self.combatWarn:SetPoint("CENTER", 0, 0)
		end

		if not self:IsEventRegistered("PLAYER_REGEN_ENABLED") then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:SetScript("OnEvent", nil)
		self:SetScript("OnShow", nil)
		LoadAddOn(self.addon.."_Option")
	end
end)
IRF3.optionFrame:SetScript("OnEvent", function(self, event, arg)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if self:IsVisible() and not self.loaded and self:GetScript("OnShow") then
			self:GetScript("OnShow")(self)
		end
	end
end)
InterfaceOptions_AddCategory(IRF3.optionFrame)

SLASH_INVENRAIDFRAMES31 = "/irf"
SLASH_INVENRAIDFRAMES32 = "/irf3"
SLASH_INVENRAIDFRAMES33 = "/인벤레이드"
SLASH_INVENRAIDFRAMES34 = "/인벤레이드프레임"
SLASH_INVENRAIDFRAMES35 = "/invenraidframe"
SLASH_INVENRAIDFRAMES36 = "/invenraidframes"
SLASH_INVENRAIDFRAMES37 = "/ㅑㄱㄹ"
SLASH_INVENRAIDFRAMES38 = "/ㅑㄱㄹ3"
local function handler(msg)
local command, arg1 = strsplit(" ",msg)
	if command == "s" and arg1 then
		if InvenRaidFrames3DB.profiles[arg1] then
			if not InCombatLockdown() then
				IRF3:SetProfile(arg1)
				IRF3:ApplyPorfile()

				IRF3:Message((L["Lime_applyprofile"]):format(arg1))
			else
				IRF3:Message(L["Lime_profile_error1"])
			end
		else
			IRF3:Message((L["Lime_profile_error2"]):format(arg1))
		end
	elseif command == "s" then
			IRF3:Message(L["Lime_profile_info"])
	else
		InvenRaidFrames3:OnClick("LeftButton")
	end
end
SlashCmdList["INVENRAIDFRAMES3"] = handler;

overlord:SetFrameRef("frame", IRF3)
overlord:Execute("IRF3 = self:GetFrameRef('frame')")
overlord:SetAttribute("_onclick", "IRF3:SetAttribute('run', not IRF3:GetAttribute('run'))")
overlord:SetScript("PostClick", function()
	if InCombatLockdown() 	then IRF3:Message(L["Lime_option_error2"]) return end 
	if IRF3.db.run ~= IRF3:GetAttribute("run") then
		IRF3.db.run = IRF3:GetAttribute("run")
		if IRF3.db.run then

			IRF3:Message(L["Lime_Show"])
		else
			IRF3:Message(L["Lime_Hide"])
		end
		IRF3:ToggleManager() -- 사용여부에 따라 기본레이드프레임 표시여부
		if IRF3.optionFrame.runMenu and IRF3.optionFrame.runMenu:IsVisible() then
			IRF3.optionFrame.runMenu:Update()
		end
		IRF3.manager.content.hideButton:SetText(IRF3.db.run and HIDE or SHOW)
	end

end)



BINDING_HEADER_INVENRAIDFRAMES3 = "Inven Raid Frames3"
BINDING_NAME_INVENRAIDFRAMES3_OPTION = L["Lime_Preference"]
BINDING_NAME_INVENRAIDFRAMES3_DOREADYCHECK = L["Lime_ReadyCheck"]
BINDING_NAME_INVENRAIDFRAMES3_INITIATEROLEPOLL = L["Lime_RoleCheck"]
BINDING_NAME_INVENRAIDFRAMES3_SWAP= "다음 프로필 불러오기"
_G["BINDING_NAME_CLICK InvenRaidFrames3Overlord:LeftButton"] = L["Lime_Toggle"]

_G["BINDING_NAME_CLICK IRF3PartyTarget:LeftButton"] = L["IRF3 Party Target Backward"]
_G["BINDING_NAME_CLICK IRF3PartyTarget:RightButton"] = L["IRF3 Party Target Forward"]
_G["BINDING_NAME_CLICK IRF3RaidTarget:LeftButton"] = L["IRF3 Raid Target Backward"]
_G["BINDING_NAME_CLICK IRF3RaidTarget:RightButton"] = L["IRF3 Raid Target Forward"]
_G["BINDING_NAME_CLICK IRF3RaidTargetMelee:LeftButton"] = L["IRF3 Raid Target Melee Backward"]
_G["BINDING_NAME_CLICK IRF3RaidTargetMelee:RightButton"] = L["IRF3 Raid Target Melee Forward"]



local function runFunc()
	if InCombatLockdown() then
		IRF3:Message(L["Lime_option_error2"])
	else
		IRF3:SetAttribute("run", not IRF3:GetAttribute("run"))
		overlord:GetScript("PostClick")(overlord)

	end
end

local function lockFunc()
	IRF3.db.lock = not IRF3.db.lock
end

local function initializeDropDown()
	local info = UIDropDownMenu_CreateInfo()
	info.notCheckable = true
	info.isNotRadio = true
	info.text = L["Lime_Preference"]
	info.func = IRF3.OnClick
	UIDropDownMenu_AddButton(info)
	info.notCheckable = nil
	info.text = L["Lime_use"]
	info.checked = IRF3.db and IRF3.db.run
	info.func = runFunc
	UIDropDownMenu_AddButton(info)
	info.text = L["Lime_lock"]
	info.checked = IRF3.db and IRF3.db.lock
	info.func = lockFunc
	UIDropDownMenu_AddButton(info)
	info.notCheckable = true
	info.checked = nil
	info.text = L["Lime_ReadyCheck"]
	info.disabled = not IRF3:IsLeader()
	info.func = DoReadyCheck
	UIDropDownMenu_AddButton(info)
	info.text = L["Lime_RoleCheck"]
	info.func = InitiateRolePoll
	UIDropDownMenu_AddButton(info)
	info.disabled = nil
	info.func = nil
	info.text = CLOSE
	UIDropDownMenu_AddButton(info)
end

IRF3.mapButtonMenu = CreateFrame("Frame", "InvenRaidFrames3MapButtonMenu", IRF3, "UIDropDownMenuTemplate")
IRF3.mapButtonMenu:SetID(1)
IRF3.mapButtonMenu:SetWidth(10)
IRF3.mapButtonMenu:SetHeight(10)
UIDropDownMenu_Initialize(IRF3.mapButtonMenu, initializeDropDown)


IRF3.libCLHealth = LibStub("LibCombatLogHealth-1.0")

function IRF3:HealComm_HealUpdate_Detail(targetGUID)

--[[
for members in pairs(IRF3.visibleMembersByGUID) do
	print(members,IRF3.visibleMembersByGUID[members])
end

for members in pairs(IRF3.visibleMembersTankByGUID) do
	print(members,IRF3.visibleMembersTankByGUID[members],"tank")
end
]]--

--[[
local updated=0
local check_num=1

	updated=0
	check_num=1
		for member in pairs(IRF3.visibleMembers) do


--			if UnitGUID(member.unit) ==targetGUID then 
			if member.unitGUID ==targetGUID then 

								
				--탱커프레임일 경우 대상프레임이 2개이므로 2배 검색
				if member.unit and IRF3.db.enableTankFrame and IRF3_UnitGroupRolesAssigned(member.unit) then 
						check_num=2
				end

				InvenRaidFrames3Member_UpdateHealth(member)
				updated=updated+1

 
--print(targetGUID)
			end

			if updated ==check_num then return end
		end

]]--

---loop감소 로직

	if IRF3.visibleMembersByGUID[targetGUID] then InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersByGUID[targetGUID]) end
	if IRF3.visibleMembersTankByGUID[targetGUID] then InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersTankByGUID[targetGUID]) end

end


function IRF3:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, destGUID1,destGUID2,destGUID3,destGUID4,destGUID5,destGUID6,destGUID7,destGUID8,destGUID9,destGUID10)
--print(destGUID1,destGUID2,destGUID3,destGUID4,destGUID5,destGUID6)
 

array_dest={destGUID1,destGUID2,destGUID3,destGUID4,destGUID5,destGUID6,destGUID7,destGUID8,destGUID9,destGUID10}

--heal comm에서 return된 치유대상(다중대상)을 배열에 저장

 

	for i=1,10 do

		if array_dest[i] then

			IRF3:HealComm_HealUpdate_Detail(array_dest[i])
	
		else

			return
		end
	end
  

end


function IRF3:HealComm_HealModifier(event, guid)
--[[
local updated=0
local check_num=1

	for member in pairs(IRF3.visibleMembers) do


			if member.unitGUID ==guid then 

								
				--탱커프레임일 경우 대상프레임이 2개이므로 2배 검색
				if member.unit and IRF3.db.enableTankFrame and IRF3_UnitGroupRolesAssigned(member.unit) then 
						check_num=2
				end

			


				InvenRaidFrames3Member_UpdateHealth(member)
				updated=updated+1

 

			end

			if updated ==check_num then return end
		end
]]--
---loop감소 로직
	if IRF3.visibleMembersByGUID[targetGUID] then InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersByGUID[targetGUID]) end
	if IRF3.visibleMembersTankByGUID[targetGUID] then InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersTankByGUID[targetGUID]) end
end 
	
 
	





function IRF3:GROUP_JOINED(self, index, uuid)
--	updateRoleType()
	InvenRaidFrames3_ReadyCheckHide()
	IRF3:AutoProfileReload()
	InvenRaidFrames3Member_Sort()--본인이 파티에 나중에 들어갔을경우 정렬(항상위/아래)적용
end

function IRF3:ADDON_LOADED()

end

function IRF3:ZONE_CHANGED_NEW_AREA(self)
	IRF3.DivineAegisGUID={}
	IRF3.ValanirGUID={}
	IRF3.AuraMasteryGUID={}
	IRF3.AuraMasteryTargetGUID={}

end

function IRF3:PLAYER_ENTERING_WORLD()
	IRF3.DivineAegisGUID={}
	IRF3.ValanirGUID={}
	IRF3.AuraMasteryGUID={}
	IRF3.AuraMasteryTargetGUID={}


end


local eventRegistered = {
	SPELL_HEAL = true,
	SPELL_ABSORBED= true,
	SPELL_PERIODIC_HEAL = true,
	SPELL_AURA_REMOVED = true,
	SPELL_AURA_APPLIED = true,

}



function IRF3:AbsorbCalculation(member,eventType,a,b,d,e,g,h,k,sourceGUID)
local updateflag = false



					if eventType=="SPELL_HEAL"  then
--print("1",GetSpellInfo(64411))
--print("0")
						--1)보호막 문양 힐 계산(크리제외한 값 기준)
						if a==56160 then 

							if g then --critical
								member.PWSAbsorb=(d or 0)/2*5
							else
								member.PWSAbsorb=(d or 0)*5
							end
							updateflag = true
--						print(">>>권능 보호막",member.PWSAbsorb)
						 end 

							


						--2-1)발아니르 발동자의 힐이 들어올때(힐주는 사람이 고대왕의 축복이 있을때, 힐량의 15%추가)
						if IRF3.ValanirGUID[sourceGUID] then 

--							print("발아니르 보호막-직접힐",member.ValanirAbsorb,d*0.15)
							member.ValanirAbsorb= (member.ValanirAbsorb or 0)+ (d*0.15)
--							member.ValanirAbsorb=("-%.0f%%"):format((member.ValanirAbsorb or 0)+ (d*0.15))
--print(member.ValanirAbsorb,"CC")
							if member.ValanirAbsorb > 20000 then member.ValanirAbsorb= 20000 end
							updateflag = true
--						print(">>>발아 보호막",member.ValanirAbsorb)

						end


						--2-2)힐크리에 의해 신의 보호가 들어올때(첫신보 발생시 수사 GUID인지. 그 수사의 힐크리일때)
						if IRF3.DivineAegisGUID[sourceGUID]  and g then --치유한 플레이어가 신보사용가능한(수사)이고 크리가 발생했으면


							--[[
							if d*0.3 >(member.DivineAegisAbsorb or 0) then--잔여수치보다 현재 값이 더 크면
								member.DivineAegisAbsorb=d*0.3
							end
							]]--
--							신의 보호 보호막도 중첩됨(+시간 연장되므로 일부가 따로 만료될 일은 없음)
							member.DivineAegisAbsorb=(member.DivineAegisAbsorb or 0) +d*0.3
							updateflag = true
--							print("신보 보호막 생성, 수치:",member.DivineAegisAbsorb)
						end

--						print(">>>신보 보호막",member.DivineAegisAbsorb)
							if updateflag then

								InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
								InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update
							end



					elseif eventType=="SPELL_PERIODIC_HEAL"  then


						--2-3)발아니르 발동자의 HoT힐이 들어올때(힐주는 사람이 고대왕의 축복이 있을때, 힐량의 15%추가)
						if IRF3.ValanirGUID[sourceGUID] then 
--							print("발아니르 보호막-소생",member.ValanirAbsorb,d*0.15)
							member.ValanirAbsorb= (member.ValanirAbsorb or 0)+ (d*0.15)


							if member.ValanirAbsorb > 20000 then member.ValanirAbsorb= 20000 end

							InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
							InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update

						end




					elseif eventType=="SPELL_ABSORBED" then --3)보막이 까질때
						member.PWSAbsorb = member.PWSAbsorb or 0
						member.ValanirAbsorb = ValanirAbsorb or 0
						member.DivineAegisAbsorb=member.DivineAegisAbsorb or 0 
						if member.PWSAbsorb + member.ValanirAbsorb +member.DivineAegisAbsorb  > 0 then

						if type(e)=="number" then
							dmgamount = h

						else
							dmgamount = k

						end
						

						if member.ValanirAbsorb >0  then --3-1)발아부터 선계산
							if member.ValanirAbsorb >= dmgamount then
								member.ValanirAbsorb=member.ValanirAbsorb-dmgamount --잔여보호막
								dmgamount=0
							else

								dmgamount = dmgamount - member.ValanirAbsorb	 --잔여수치		
								member.ValanirAbsorb=0
							end

						end

						if member.DivineAegisAbsorb >0 and dmgamount>0  then --3-2)신보계산
							if member.DivineAegisAbsorb >= dmgamount then
								member.DivineAegisAbsorb=member.DivineAegisAbsorb-dmgamount --잔여보호막
								dmgamount=0
							else

								dmgamount = dmgamount - member.DivineAegisAbsorb	 --잔여수치			
								member.DivineAegisAbsorb=0
							end

						end

						if member.PWSAbsorb >0 and dmgamount>0 then --3-3)사제 보호막 계산

							if member.PWSAbsorb >= dmgamount then
								member.PWSAbsorb=member.PWSAbsorb-dmgamount --잔여보호막
								dmgamount=0
							else

--								dmgamount=dmgamout - member.PWSAbsorb
								member.PWSAbsorb=0
							end
						end
	

--						member.overAbsorb = (member.PWSAbsorb or 0) +(member.ValanirAbsorb or 0)+(member.DivineAegisAbsorb or 0)
						InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
						InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update

						end

					elseif eventType=="SPELL_AURA_APPLIED" and a==64411 then --발아니르 버프(고대왕의 축복 추가시)
						IRF3.ValanirGUID[sourceGUID] = true

					elseif eventType=="SPELL_AURA_REMOVED" and a==64413 then  --발아니르 버프 제거시(고대왕의 보호-힐받는사람) 
--						print(">>>발아 제거됨. 보호막 수치 제거",member.ValanirAbsorb)

							member.ValanirAbsorb=0
							InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
							InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update

					elseif 	eventType=="SPELL_AURA_REMOVED" and a==64411 then --발아니르버프 (고대왕의 축복)제거시
							IRF3.ValanirGUID[sourceGUID]=false --발아니르 버프(고대왕의 축복)가 사라지면 등록해제


					elseif eventType=="SPELL_AURA_APPLIED" and b==spellName2 then --and not  IRF3.DivineAegisGUID[sourceGUID] then--신의 보호 버프
						IRF3.DivineAegisGUID[sourceGUID] = true
--						print(">>>신보 감지:".. sourceGUID.."등록")






					elseif eventType=="SPELL_AURA_REMOVED" and b==spellName2 then  --신의 보호 버프 제거시
--						print(">>>신보 제거됨. 보호막 수치 제거",member.DivineAegisAbsorb)
						member.DivineAegisAbsorb=0
							InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
							InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update


					elseif 	eventType=="SPELL_AURA_REMOVED"  then --사제 보호막 제거시
--						print(">>>권능 제거됨. 보호막 수치 제거",member.PWSAbsorb)
						member.PWSAbsorb=0
							InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member) --absorb prediction bar update
							InvenRaidFrames3Member_UpdateLostHealth(member) --absorb text update


					end

--					if (member.PWSAbsorb or 0)<0 then member.PWSAbsorb=0 end
--					if (member.ValanirAbsorb or 0)<0 then member.PWSAbsorb=0 end 





end

 


function IRF3:COMBAT_LOG_EVENT_UNFILTERED(self)
--흡수량 계산(보호막,신보,발아니르)



	local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,a,b,c,d,e,f,g,h,i,j,k,l = CombatLogGetCurrentEventInfo()
 


if( not eventRegistered[eventType] ) then return end

if not CombatLog_Object_IsA(destFlags,COMBATLOG_FILTER_FRIENDLY_PLAYERS) then  return end


 


local updateflag =false
 

--print(timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,a,b,c,d,e,f,g,h,i,j,k,l)
--print(sourceFlags,destGUID,destFlags,"1",CombatLog_Object_IsA(destFlags,COMBATLOG_FILTER_FRIENDLY_PLAYERS))
--and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE )
--print(timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,a,b,c,d,e,f,g,h,i,j,k,l)
--발아니르는 보막수치 확인불가(순수힐이 아니라..)
--보막문양 : SPELL_HEAL , 56160, 보호막의 문양 1418
 
--print(IRF3.ValanirGUID)

	if (eventType=="SPELL_HEAL"  and  (a==56160 or IRF3.ValanirGUID[sourceGUID] or IRF3.DivineAegisGUID[sourceGUID] )) or (eventType=="SPELL_ABSORBED" ) or (eventType=="SPELL_PERIODIC_HEAL" and IRF3.ValanirGUID[sourceGUID]) or (eventType=="SPELL_AURA_APPLIED" and (a==64411 or b==spellName2)   ) or (eventType=="SPELL_AURA_REMOVED" and (b==spellName or b==spellName2 or a==64413 or a==64411))  then
	


--loop없이 로직변경
	if IRF3.visibleMembersByGUID[destGUID] then
 	
		IRF3:AbsorbCalculation(IRF3.visibleMembersByGUID[destGUID],eventType,a,b,d,e,g,h,k,sourceGUID)
--print(destGUID)
--		print("Absorb  updated")
	end

	if IRF3.visibleMembersTankByGUID[destGUID] and UnitInRaid("player")   then
--ppint("2 tank")
--print(IRF3.visibleMembersTankByGUID[destGUID])
		IRF3:AbsorbCalculation(IRF3.visibleMembersTankByGUID[destGUID],eventType,a,b,d,e,g,h,k,sourceGUID)
--		print("Absorb  updated-tank")
	end

	end

 

end




function IRF3:GROUP_LEFT(self, index, uuid) --category,partyGUID return함
	--updateRoleType() --classic에선 롤 없음
	--체력바 오작동 보정용. 파탈시점에 member위치가 정확하게 리턴되지 않음(eg:파탈직후에 혼자남은데 raid1,2..x라 리턴됨)

C_Timer.After(0.1, function() InvenRaidFrames3Member_UpdateHealth_Reset() end)
	IRF3:AutoProfileReload()
	IRF3.AuraMasteryGUID={}--오라숙련 사용자 초기화
end
function IRF3:ACTIVE_TALENT_GROUP_CHANGED()

	IRF3:AutoProfileReload()


		IRF3.DivineAegisGUID[UnitGUID("player")]=false --수양사제 정보 초기화
		--특성이 바뀌므로 흡수량 초기화용도

		for member in pairs(IRF3.visibleMembers) do
			InvenRaidFrames3Member_UpdateHealPrediction_Absorb(member)
		end


end


function InvenRaidFrames3Member_UpdateHealth_Reset()

	for _, header in pairs(IRF3.headers) do

		for _, member in pairs(header.members) do
		 	if member.displayedUnit and UnitGUID(member.displayedUnit) ==UnitGUID("player")  then

			        InvenRaidFrames3Member_UpdateHealth(member)
	    		InvenRaidFrames3Member_UpdateLostHealth(member)
			InvenRaidFrames3Member_UpdateState(member)
			InvenRaidFrames3Member_UpdateNameColor(member)
			InvenRaidFrames3Member_UpdateDisplayText(member)

			end

		end
	end

	 

		for _, member in pairs(IRF3.petHeader.members) do
		 	if member.displayedUnit  and UnitGUID(member.displayedUnit) ==UnitGUID("player")  then
			        InvenRaidFrames3Member_UpdateHealth(member)
	    		InvenRaidFrames3Member_UpdateLostHealth(member)
			InvenRaidFrames3Member_UpdateState(member)
			InvenRaidFrames3Member_UpdateNameColor(member)
			InvenRaidFrames3Member_UpdateDisplayText(member)

			end

		end
	 

end



