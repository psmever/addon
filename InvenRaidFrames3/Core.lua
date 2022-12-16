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
IRF3:RegisterEvent("ADDON_LOADED")
IRF3:SetFrameStrata("MEDIUM")
IRF3:SetFrameLevel(2)
IRF3:SetMovable(true)
IRF3:SetClampedToScreen(true)

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

function IRF3:PLAYER_LOGIN()
	self.PLAYER_LOGIN = nil
	self.playerClass = select(2, UnitClass("player"))
	self:InitDB()
	self.version = GetAddOnMetadata(self:GetName(), "Version")
	self.website = GetAddOnMetadata(self:GetName(), "X-Website")
	self:ApplyPorfile()

--처음사용시 현재특성의 클릭캐스트정보가 비어있으면 이전것을 그대로두고, 아니면 저장된 특성db로 교체

--print(next(InvenRaidFrames3CharDB.clickCasting[2]))
		if InvenRaidFrames3CharDB.clickCasting and   next(InvenRaidFrames3CharDB.clickCasting[1]) and next(InvenRaidFrames3CharDB.clickCasting[2]) == nil then
--print("복사됨")
print(L["ClickCast_desc1"])
			for k,v in pairs(InvenRaidFrames3CharDB.clickCasting[1] ) do
--				print(k,v)
				InvenRaidFrames3CharDB.clickCasting[2][k]=v
			end
			
--			  InvenRaidFrames3CharDB.clickCasting[2]  = InvenRaidFrames3CharDB.clickCasting[1] --비어있는 특성의 db정보에 현재 db정보 복제
--	else
--		print("복사 불필요")
	end
	if IRF3.db.enableClickCast then

		self:SelectClickCastingDB()

	end 

	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
--	self:RegisterEvent("PET_BATTLE_OPENING_START")
--	self:RegisterEvent("PET_BATTLE_CLOSE")
	self.PLAYER_REGEN_ENABLED = self.UpdateTooltipState
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
end	 




	 
 
 	



function IRF3:LoadPosition()
--	self:SetUserPlaced(nil)
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

self.tankheaders[0]:ClearAllPoints()

if IRF3.db.enableTankFrame then 


		self.tankheaders[0]:SetPoint(self.db.anchor, self , tankpx,tankpy)
--		self.tankheaders[0]:SetPoint(self.db.anchor, self ,self.db.anchor, self.db.tankpx / self.db.scale , self.db.tankpy / self.db.scale)
--		self.tankheaders[0]:SetPoint(self.db.anchor, self, self.db.anchor,-100,13)
	else

		self.tankheaders[0]:SetPoint(self.db.anchor, UIParent, "CENTER", 0, 0)
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

		self.db.petpx = self.petHeader:GetLeft()  * (self.db.petscale * self.db.scale)
		self.db.petpy = self.petHeader:GetTop()  * (self.db.petscale * self.db.scale) - UIParent:GetTop()

	elseif self.db.petanchor == "TOPRIGHT" then

		self.db.petpx = self.petHeader:GetRight()  * (self.db.petscale * self.db.scale) - UIParent:GetRight()
		self.db.petpy = self.petHeader:GetTop()  * (self.db.petscale * self.db.scale) - UIParent:GetTop()
	elseif self.db.petanchor == "BOTTOMLEFT" then
		self.db.petpx = self.petHeader:GetLeft()  * (self.db.petscale * self.db.scale)
		self.db.petpy = self.petHeader:GetBottom()  * (self.db.petscale * self.db.scale)
	elseif self.db.petanchor == "BOTTOMRIGHT" then
		self.db.petpx = self.petHeader:GetRight()  * (self.db.petscale * self.db.scale) - UIParent:GetRight()
		self.db.petpy = self.petHeader:GetBottom()  * (self.db.petscale * self.db.scale)
	end 
 
	
--self.db.tankpx= IRF3.tankheaders[0]:GetLeft() * self.db.scale
--self.db.tankpy= IRF3.tankheaders[0]:GetTop() * self.db.scale -UIParent:GetTop()

if IRF3.db.enableTankFrame then 
	self.db.tankpx= IRF3.tankheaders[0]:GetLeft() - self:GetLeft()
	self.db.tankpy= IRF3.tankheaders[0]:GetTop() - self:GetTop()
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
--		self.border.updater:Show()
--		self.petHeader.border:Show()

	else

		self.border:Hide()
--		self.border:SetAlpha(0)
--		self.petHeader.border:Hide()
	end
end

function IRF3:OnClick(button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, IRF3.mapButtonMenu, "cursor")
	elseif InterfaceOptionsFrame:IsShown() and InterfaceOptionsFramePanelContainer.displayedPanel == IRF3.optionFrame then
		InterfaceOptionsFrame_Show()
	else
		InterfaceOptionsFrame_Show()
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

function IRF3:HideBlizzardPartyFrame(hide)
	self.db.hideBlizzardParty = hide
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

	if not IRF3.db.borderEdgeValue or IRF3.db.borderEdgeValue == 1 or IRF3.db.borderEdgeValue == "기본" then
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
	if IRF3.db.run ~= IRF3:GetAttribute("run") then
		IRF3.db.run = IRF3:GetAttribute("run")
		if IRF3.db.run then
			IRF3:Message(L["Lime_Show"])
		else
			IRF3:Message(L["Lime_Hide"])
		end
		if IRF3.optionFrame.runMenu and IRF3.optionFrame.runMenu:IsVisible() then
			IRF3.optionFrame.runMenu:Update()
		end
		IRF3.manager.content.hideButton:SetText(IRF3.db.run and HIDE or SHOW)
	end
end)

BINDING_HEADER_INVENRAIDFRAMES3 = "인벤 레이드 프레임 3"
BINDING_NAME_INVENRAIDFRAMES3_OPTION = "옵션창 열기"
BINDING_NAME_INVENRAIDFRAMES3_DOREADYCHECK = "전투 준비 확인하기"
BINDING_NAME_INVENRAIDFRAMES3_INITIATEROLEPOLL = "역할 확인하기"
BINDING_NAME_INVENRAIDFRAMES3_SWAP= "다음 프로필 불러오기"
_G["BINDING_NAME_CLICK InvenRaidFrames3Overlord:LeftButton"] = "사용/비사용 전환"


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

function IRF3:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)
 


	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
      if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) then
        InvenRaidFrames3Member_UpdateHealth(member)
--        InvenRaidFrames3Member_UpdateHealPrediction(member)
      end
		end
	end	


if IRF3.db.enableTankFrame then 

--	for _, header in pairs(IRF3.tankheaders) do
--		for _, member in pairs(header.members) do
		for _, member in pairs(IRF3.tankheaders[0].members) do
      if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) then
        InvenRaidFrames3Member_UpdateHealth(member)
--        InvenRaidFrames3Member_UpdateHealPrediction(member)
      end
		end
--	end	
end

	for _, member in pairs(IRF3.petHeader.members) do
    if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) then
      InvenRaidFrames3Member_UpdateHealth(member)
--      InvenRaidFrames3Member_UpdateHealPrediction(member)
    end
	end
end


function IRF3:HealComm_HealModifier(event, guid)
 


	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do

      if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) and guid == UnitGUID(member.displayedUnit) then
        InvenRaidFrames3Member_UpdateHealth(member)
--        InvenRaidFrames3Member_UpdateHealPrediction(member)
      end
		end
	end


--	for _, header in pairs(IRF3.headers) do
--		for _, member in pairs(header.members) do
		for _, member in pairs(IRF3.tankheaders[0].members) do
      if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) and guid == UnitGUID(member.displayedUnit) then
        InvenRaidFrames3Member_UpdateHealth(member)
--        InvenRaidFrames3Member_UpdateHealPrediction(member)
      end
		end
--	end



	for _, member in pairs(IRF3.petHeader.members) do
    if IRF3.visibleMembers[member] and UnitExists(member.displayedUnit) then
      InvenRaidFrames3Member_UpdateHealth(member)
--      InvenRaidFrames3Member_UpdateHealPrediction(member)
    end
	end
end 
	
 
	





function IRF3:GROUP_JOINED(self, index, uuid)
--	updateRoleType()
	InvenRaidFrames3_ReadyCheckHide()
end

function IRF3:ADDON_LOADED()

end
function IRF3:GROUP_LEFT(self, index, uuid) --category,partyGUID return함
	--updateRoleType() --classic에선 롤 없음
	--체력바 오작동 보정용. 파탈시점에 member위치가 정확하게 리턴되지 않음(eg:파탈직후에 혼자남은데 raid1,2..x라 리턴됨)

C_Timer.After(0.1, function() InvenRaidFrames3Member_UpdateHealth_Reset() end)


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



