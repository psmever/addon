--[[인벤 레이드 프레임 개인 멤버 스크립트]]
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local _G = _G
local IRF3, noOption = ...
local pairs = _G.pairs
local ipairs = _G.ipairs
local unpack = _G.unpack
local select = _G.select
local tinsert = _G.table.insert
local max = _G.math.max
local min = _G.math.min
local UnitExists = _G.UnitExists
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local UnitPowerType = _G.UnitPowerType
local UnitAlternatePowerInfo = _G.UnitAlternatePowerInfo
local UnitInRange = _G.UnitInRange
local UnitIsGhost = _G.UnitIsGhost
local UnitIsDead = _G.UnitIsDead
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsAFK = _G.UnitIsAFK
local UnitIsUnit = _G.UnitIsUnit
local UnitCanAttack = _G.UnitCanAttack
local UnitIsConnected = _G.UnitIsConnected
local UnitHasVehicleUI = _G.UnitHasVehicleUI
local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned
local UnitGetIncomingHeals = _G.UnitGetIncomingHeals
local UnitGetTotalAbsorbs = _G.UnitGetTotalAbsorbs
local UnitIsPlayer = _G.UnitIsPlayer
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid
local UnitClass = _G.UnitClass
local UnitDistanceSquared = _G.UnitDistanceSquared
local UnitInOtherParty = _G.UnitInOtherParty
local UnitHasIncomingResurrection = _G.UnitHasIncomingResurrection
local UnitInPhase = _G.UnitInPhase
local GetRaidRosterInfo = _G.GetRaidRosterInfo
local InCombatLockdown = _G.InCombatLockdown
local GetTime = _G.GetTime
local SM = LibStub("LibSharedMedia-3.0")
local LEDDM = LibStub("LibEnhanceDDMenu-1.0")
local eventHandler = {}
IRF3 = _G[IRF3]
IRF3.visibleMembers = {}
--local InstantHealth = LibStub("LibInstantHealth-1.0")


--local libCLHealth = LibStub("LibCombatLogHealth-1.0")
local LibSmooth = LibStub("LibSmoothStatusBar-1.0")
local SmoothBar = select(2, ...)
local SmoothBarScript =LibSmooth.frame:GetScript("OnUpdate")

 

-- Enable LibSmooth on frame
function SmoothBar:OnEnable(frame)
	if frame.healthBar then LibSmooth:SmoothBar(frame.healthBar) end
	if frame.powerBar then LibSmooth:SmoothBar(frame.powerBar) end
end

-- Disable LibSmooth on frame
function SmoothBar:OnDisable(frame)
	if frame.healthBar then LibSmooth:ResetBar(frame.healthBar) end
	if frame.powerBar then LibSmooth:ResetBar(frame.powerBar) end
end


local CallbackHandler = LibStub("CallbackHandler-1.0")
--local initAggroShout={} 

local COMBATLOG_FILTER_FRIENDLY_PLAYERS = bit.bor(
	COMBATLOG_OBJECT_AFFILIATION_MINE,
	COMBATLOG_OBJECT_AFFILIATION_PARTY,
	COMBATLOG_OBJECT_AFFILIATION_RAID,
	COMBATLOG_OBJECT_REACTION_FRIENDLY,
	COMBATLOG_OBJECT_CONTROL_PLAYER,
	COMBATLOG_OBJECT_TYPE_PLAYER

)

 

local COMBATLOG_FILTER_HOSTILE_MOBS = bit.bor(
--						COMBATLOG_OBJECT_AFFILIATION_PARTY,
--						COMBATLOG_OBJECT_AFFILIATION_RAID,
						COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
						COMBATLOG_OBJECT_REACTION_HOSTILE,
						COMBATLOG_OBJECT_CONTROL_NPC,
						COMBATLOG_OBJECT_TYPE_PLAYER,
						COMBATLOG_OBJECT_TYPE_NPC,
						COMBATLOG_OBJECT_TYPE_PET,
						COMBATLOG_OBJECT_TYPE_GUARDIAN,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_TYPE_OBJECT

)



local _
function IRF3:SetupBuff()
--test : 직업 버프 사용여부
IRF3.db.enableClassBuff=false
	if InvenRaidFrames3CharDB.classBuff2 then
		for a,b in pairs(InvenRaidFrames3CharDB.classBuff2) do
			if b~=0 then --하나라도 체크가 되어있으면 enable임.
				IRF3.db.enableClassBuff = true
				return
			end
			IRF3.db.enableClassBuff=false
		end

	end

end



function IRF3:SetupLib() --외부 라이브러리 로드

--1)CommbatLog Health
if IRF3.db.enableInstantHealth then

--print("Instant loaded")
	IRF3.libCLHealth.RegisterCallback(IRF3, "COMBAT_LOG_HEALTH", function (event, unit, eventType) 

			for _, header in pairs(IRF3.headers) do

				for _, member in pairs(header.members) do

				 	if member.displayedUnit and member.displayedUnit ==unit  then
 						InvenRaidFrames3Member_UpdateHealth(member) 
						InvenRaidFrames3Member_UpdateLostHealth(member) 
					end
				end
			end

--temporary commented for performance
--방어전담

--			if IRF3.db.enableTankFrame and IRF3.tankheaders[0]:IsShown() then
--
--				for _, member in pairs(IRF3.tankheaders[0].members) do
--					if member.displayedUnit and member.displayedUnit ==unit  then
 --						InvenRaidFrames3Member_UpdateHealth(member) 
--						InvenRaidFrames3Member_UpdateLostHealth(member) 
--					end 
--				end
--
--			end
--			
--			--팻
--
--			if IRF3.db.usePet =="3" and self.petHeader:IsShown() then
--				for _, member in pairs(self.petHeader.members) do
--					if member.displayedUnit and member.displayedUnit ==unit  then
--						InvenRaidFrames3Member_UpdateHealth(member) 
--						InvenRaidFrames3Member_UpdateLostHealth(member) 
--					end 
--				end
--			end
--


		end)

else
--print("Instant Unloaded")

	IRF3.libCLHealth.UnregisterCallback(IRF3, "COMBAT_LOG_HEALTH")
	

end

--2)HealComm
	
IRF3.libCHC = LibStub("LibHealComm-4.0") --사용안함이어도 객체를 일단 생성하고 그 후로직에서 unregister해야 불필요한 onevent수행안함
if IRF3.db.enableHealComm then
--print("HealComm load")

--	IRF3.libCHC = LibStub("LibHealComm-4.0")
	IRF3.libCHC.eventFrame:RegisterEvent("CHAT_MSG_ADDON")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	IRF3.libCHC.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	IRF3.libCHC.eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	IRF3.libCHC.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	IRF3.libCHC.eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	IRF3.libCHC.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
	IRF3.libCHC.eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_AURA", "player") 
	IRF3.libCHC.eventFrame:RegisterEvent("GLYPH_ADDED")
	IRF3.libCHC.eventFrame:RegisterEvent("GLYPH_REMOVED")
	IRF3.libCHC.eventFrame:RegisterEvent("GLYPH_UPDATED")
	IRF3.libCHC.eventFrame:RegisterEvent("UNIT_PET")
	IRF3.libCHC.eventFrame:RegisterEvent("PLAYER_LOGIN")
	IRF3.libCHC.eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	IRF3.libCHC.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	IRF3.libCHC.eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")




	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_HealStarted", "HealComm_HealUpdated")
	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_HealStopped", "HealComm_HealUpdated")
	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_HealDelayed", "HealComm_HealUpdated")
	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_HealUpdated", "HealComm_HealUpdated")
	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_ModifierChanged", "HealComm_HealModifier")
	IRF3.libCHC.RegisterCallback(IRF3, "HealComm_GUIDDisappeared", "HealComm_HealModifier") 

else

--print("heal comm unload")
 
		IRF3.libCHC.eventFrame:UnregisterAllEvents()
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_HealStarted")
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_HealStopped")
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_HealDelayed")
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_HealUpdated")
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_ModifierChanged")
		IRF3.libCHC.UnregisterCallback(IRF3, "HealComm_GUIDDisappeared")
 
end



  

local libtext=""
if IRF3.db.enableInstantHealth then libtext = libtext ..L["library_1"] end
if IRF3.db.enableHealComm then libtext=libtext .. L["library_2"] end
if IRF3.db.smootheffect then libtext=libtext .. L["library_3"] end

if #libtext > 0 then

	print("|cFF0FFF00IRF3:|r"..L["library_9"] .. string.sub(libtext,2,#libtext))
else
	print("|cFF0FFF00IRF3:|r"..L["library_10"])
end


end

function IRF3:SetupAll(update)

	for _, header in pairs(self.headers) do
		for _, member in pairs(header.members) do
			member:Setup()
		end
	end

if IRF3.db.enableTankFrame then
-- 	for _, header in pairs(self.tankheaders) do
--		for _, member in pairs(header.members) do
		for _, member in pairs(IRF3.tankheaders[0].members) do
			member:Setup()
		end
--	end
end


	for _, member in pairs(self.petHeader.members) do
		member:Setup()
	end

end


 


local statusBarTexture = "Interface\\RaidFrame\\Raid-Bar-Resource-Fill"

local function setupMemberTexture(self)

	statusBarTexture = SM:Fetch("statusbar", IRF3.db.units.texture)
	self.powerBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 2)
	self.healthBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 1)


 


	self.myHealPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 0)

	self.myHealPredictionBar:SetStatusBarColor(IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)

	self.myHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -2)
	self.myHoTPredictionBar:SetStatusBarColor(IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.otherHealPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -1)
	self.otherHealPredictionBar:SetStatusBarColor(IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.otherHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -3)
	self.otherHoTPredictionBar:SetStatusBarColor(IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.absorbPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -4)
	self.absorbPredictionBar:SetStatusBarColor(IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3], IRF3.db.units.healPredictionAlpha)



	self.overAbsorbGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
	self.overAbsorbGlow:SetDrawLayer("OVERLAY", 4)
	self.overAbsorbGlow:SetBlendMode("BLEND")
	self.overAbsorbGlow:ClearAllPoints()
	self.overAbsorbGlow:SetPoint("BOTTOMRIGHT", self.healthBar, "BOTTOMRIGHT", 7, 0)
	self.overAbsorbGlow:SetPoint("TOPRIGHT", self.healthBar, "TOPRIGHT", 7, 0)
	self.overAbsorbGlow:SetWidth(16)
	self.overAbsorbGlow:SetAlpha(0.4)
	if self.petButton then
		self.petButton.powerBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.healthBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.myHealPredictionBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.myHealPredictionBar:SetStatusBarColor(IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		self.petButton.myHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.myHoTPredictionBar:SetStatusBarColor(IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)

		self.petButton.otherHealPredictionBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.otherHealPredictionBar:SetStatusBarColor(IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		self.petButton.otherHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "BORDER", -1)
		self.petButton.otherHoTPredictionBar:SetStatusBarColor(IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	end
	if self.castingBar then
		self.castingBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 4)
		self.castingBar:SetStatusBarColor(IRF3.db.units.castingBarColor[1], IRF3.db.units.castingBarColor[2], IRF3.db.units.castingBarColor[3])
	end
	if self.powerBarAlt then
		self.powerBarAlt:SetStatusBarTexture(statusBarTexture, "OVERLAY", 1)
		self.powerBarAlt:SetStatusBarColor(self.powerBarAlt.r or 1, self.powerBarAlt.g or 1, self.powerBarAlt.b or 1)
	end
	if self.resurrectionBar then
		self.resurrectionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 5)
		self.resurrectionBar:SetStatusBarColor(IRF3.db.units.resurrectionBarColor[1], IRF3.db.units.resurrectionBarColor[2], IRF3.db.units.resurrectionBarColor[3])
	end
	if self.bossAura then
		self.bossAura:SetAlpha(IRF3.db.units.bossAuraAlpha)
	end
	if self.centerStatusIcon then
		self.centerStatusIcon:ClearAllPoints()
		self.centerStatusIcon:SetPoint("CENTER", self, "BOTTOM", 0, IRF3.db.height / 3 + 2)
		self.centerStatusIcon:SetSize(22, 22)
	end
end

local function setHorizontal(bar)
	bar:SetOrientation("HORIZONTAL")
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", bar:GetParent(), "TOPLEFT", 0, 0)
	bar:GetParent().orientation = 1
end

local function setVertical(bar, parent)
	bar:SetOrientation("VERTICAL")
	bar:ClearAllPoints()
	bar:SetPoint("BOTTOMLEFT", bar:GetParent(), "BOTTOMLEFT", 0, 0)
	bar:GetParent().orientation = 2
end

local function setupMemberBarOrientation(self)

	if IRF3.db.units.orientation == 1 then
		self.healthBar:SetOrientation("HORIZONTAL")
		setHorizontal(self.myHealPredictionBar)
		setHorizontal(self.myHoTPredictionBar)
		setHorizontal(self.otherHealPredictionBar)
		setHorizontal(self.otherHoTPredictionBar)
		setHorizontal(self.absorbPredictionBar)
	else
		self.healthBar:SetOrientation("VERTICAL")
		setVertical(self.myHealPredictionBar)
		setVertical(self.myHoTPredictionBar)
		setVertical(self.otherHealPredictionBar)
		setVertical(self.otherHoTPredictionBar)
		setVertical(self.absorbPredictionBar)
	end
end

local function setupMemberPowerBar(self)
	self.healthBar:ClearAllPoints()
	self.powerBar:ClearAllPoints()
	if IRF3.db.units.nameEndl then
		self.name:SetPoint("CENTER", self.healthBar, 0, 5)
		if self.losttext then
			self.losttext:SetPoint("TOP", self.name, "BOTTOM", 0, -2)
		end
	else
		self.name:SetPoint("CENTER", self.healthBar, 0, 0)
		if self.losttext then
			self.losttext:SetPoint("TOP", self.name, "BOTTOM", 0, -2)--no use
		end
	end
	if IRF3.db.units.powerBarPos == 1 or IRF3.db.units.powerBarPos == 2 then
		self.powerBar:SetWidth(0)
		self.powerBar:SetOrientation("HORIZONTAL")
		if IRF3.db.units.powerBarHeight > 0 then
			self.powerBar:SetHeight(IRF3.db.height * IRF3.db.units.powerBarHeight)
		else
			self.powerBar:SetHeight(0.001)
		end
		if IRF3.db.units.powerBarPos == 1 then
			self.healthBar:SetPoint("TOPLEFT", self.powerBar, "BOTTOMLEFT", 0, 0)
			self.healthBar:SetPoint("BOTTOMRIGHT", 0, 0)
			self.powerBar:SetPoint("TOPLEFT", 0, 0)
			self.powerBar:SetPoint("TOPRIGHT", 0, 0)
		else
			self.healthBar:SetPoint("TOPLEFT", 0, 0)
			self.healthBar:SetPoint("BOTTOMRIGHT", self.powerBar, "TOPRIGHT", 0, 0)
			self.powerBar:SetPoint("BOTTOMLEFT", 0, 0)
			self.powerBar:SetPoint("BOTTOMRIGHT", 0, 0)
		end
	else
		self.powerBar:SetHeight(0)
		self.powerBar:SetOrientation("VERTICAL")
		if IRF3.db.units.powerBarHeight > 0 then
			self.powerBar:SetWidth(IRF3.db.width * IRF3.db.units.powerBarHeight)
		else
			self.powerBar:SetWidth(0.001)
		end
		if IRF3.db.units.powerBarPos == 3 then
			self.healthBar:SetPoint("TOPLEFT", self.powerBar, "TOPRIGHT", 0, 0)
			self.healthBar:SetPoint("BOTTOMRIGHT", 0, 0)
			self.powerBar:SetPoint("TOPLEFT", 0, 0)
			self.powerBar:SetPoint("BOTTOMLEFT", 0, 0)
		else
			self.healthBar:SetPoint("TOPLEFT", 0, 0)
			self.healthBar:SetPoint("BOTTOMRIGHT", self.powerBar, "BOTTOMLEFT", 0, 0)
			self.powerBar:SetPoint("TOPRIGHT", 0, 0)
			self.powerBar:SetPoint("BOTTOMRIGHT", 0, 0)
		end
	end
end

local function checkMouseOver(self)
	if not UnitIsUnit(self:GetParent().displayedUnit, "mouseover") then
		self:Hide()
	end
end

local function setupMemberOutline(self)
	if not self.outline then
		self.outline = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
		self.outline:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 2);
		self.outline:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -2);
		self.outline:SetBackdrop({
			--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Addons\\InvenRaidFrames3\\Texture\\Border.tga",
			--tile = true,
			--tileEdge = true,
			--tileSize = 16,
			edgeSize = 16,
			--insets = { left = -3, right = 2, top = -2, bottom = 3 },
		})
	else
	end
	
	self.outline:SetScript("OnUpdate", nil)

if not self:GetName():find("TankGroup") then -- 방어전담프레임은 제외
	self.outline:SetScale(self.optionTable.outline.scale)
	self.outline:SetAlpha(self.optionTable.outline.alpha)
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	if self.optionTable.outline.type == 2 then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self.outline:SetBackdropBorderColor(self.optionTable.outline.targetColor[1], self.optionTable.outline.targetColor[2], self.optionTable.outline.targetColor[3])
	elseif self.optionTable.outline.type == 3 then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self.outline:SetBackdropBorderColor(self.optionTable.outline.mouseoverColor[1], self.optionTable.outline.mouseoverColor[2], self.optionTable.outline.mouseoverColor[3])
		self.outline:SetScript("OnUpdate", checkMouseOver)
	elseif self.optionTable.outline.type == 4 then
		self.outline:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor[1], self.optionTable.outline.lowHealthColor[2], self.optionTable.outline.lowHealthColor[3])
	elseif self.optionTable.outline.type == 5 then
		self.outline:SetBackdropBorderColor(self.optionTable.outline.aggroColor[1], self.optionTable.outline.aggroColor[2], self.optionTable.outline.aggroColor[3])
	elseif self.optionTable.outline.type == 6 then
		self.outline:SetBackdropBorderColor(self.optionTable.outline.raidIconColor[1], self.optionTable.outline.raidIconColor[2], self.optionTable.outline.raidIconColor[3])
	elseif self.optionTable.outline.type == 7 then
		self.outline:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor2[1], self.optionTable.outline.lowHealthColor2[2], self.optionTable.outline.lowHealthColor2[3])
	else
		self.outline:Hide()
	end
end

	if self.petButton then
		setupMemberOutline(self.petButton)
	end
end

local function setupMemberDebuffIcon(self)
	if self.optionTable.debuffIconType == 1 then
		for i = 1, 5 do
			self["debuffIcon"..i].color:ClearAllPoints()
			self["debuffIcon"..i].color:SetAllPoints()
			self["debuffIcon"..i].color:Show()
			self["debuffIcon"..i].icon:ClearAllPoints()
			self["debuffIcon"..i].icon:SetPoint("TOPLEFT", 1, -1)
			self["debuffIcon"..i].icon:SetPoint("BOTTOMRIGHT", -1, 1)
			self["debuffIcon"..i].icon:Show()
		end
	elseif self.optionTable.debuffIconType == 2 then
		for i = 1, 5 do
			self["debuffIcon"..i].color:Hide()
			self["debuffIcon"..i].icon:ClearAllPoints()
			self["debuffIcon"..i].icon:SetPoint("TOPLEFT", 1, -1)
			self["debuffIcon"..i].icon:SetPoint("BOTTOMRIGHT", -1, 1)
			self["debuffIcon"..i].icon:Show()
		end
	else
		for i = 1, 5 do
			self["debuffIcon"..i].color:ClearAllPoints()
			self["debuffIcon"..i].color:SetPoint("TOPLEFT", 1, -1)
			self["debuffIcon"..i].color:SetPoint("BOTTOMRIGHT", -1, 1)
			self["debuffIcon"..i].color:Show()
			self["debuffIcon"..i].icon:Hide()
		end
	end
end

local function setupMemberAll(self)

self.callbacks = CallbackHandler:New(self)
 
	InvenRaidFrames3Member_SetOptionTable(self, IRF3.db.units)
	self.background:SetColorTexture(IRF3.db.units.backgroundColor[1], IRF3.db.units.backgroundColor[2], IRF3.db.units.backgroundColor[3], IRF3.db.units.backgroundColor[4])

	if self.petButton then
--		CompactUnitFrame_SetOptionTable(self.petButton, IRF3.db.units)
		InvenRaidFrames3Member_SetOptionTable(self.petButton, IRF3.db.units) --CompactUnitFrame대신 IRF호출로 변경.전투중 block되서

		self.petButton.background:SetTexture(IRF3.db.units.backgroundColor[1], IRF3.db.units.backgroundColor[2], IRF3.db.units.backgroundColor[3], IRF3.db.units.backgroundColor[4])
	end

	setupMemberTexture(self)

	setupMemberPowerBar(self)
	setupMemberBarOrientation(self)
	setupMemberOutline(self)
	setupMemberDebuffIcon(self)
	InvenRaidFrames3Member_SetupPowerBarAltPos(self)
	InvenRaidFrames3Member_SetupCastingBarPos(self)
	InvenRaidFrames3Member_SetupIconPos(self)
	InvenRaidFrames3Member_SetAuraFont(self)
	self.name:SetFont(SM:Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
	self.name:SetShadowColor(0, 0, 0)
	if IRF3.db.font.shadow then
		self.name:SetShadowOffset(1, -1)
	else
		self.name:SetShadowOffset(0, 0)
	end
	self.losttext:SetFont(SM:Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
	self.losttext:SetShadowColor(0, 0, 0)
	if IRF3.db.font.shadow then
		self.losttext:SetShadowOffset(1, -1)
	else
		self.losttext:SetShadowOffset(0, 0)
	end

	self.healingtarget:SetFont(SM:Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
	self.healingtarget:SetShadowColor(0, 0, 0)
	if IRF3.db.font.shadow then
		self.healingtarget:SetShadowOffset(1, -1)
	else
		self.healingtarget:SetShadowOffset(0, 0)
	end

	 	--체력바,power바 애니메이션용
 
	if IRF3.db.smootheffect then
		if not LibSmooth.frame:GetScript("OnUpdate") then
			LibSmooth.frame:SetScript("OnUpdate", SmoothBarScript)
		end
		SmoothBar:OnEnable(self)

	else
		LibSmooth.frame:SetScript("OnUpdate", nil)
		SmoothBar:OnDisable(self)
	end

	InvenRaidFrames3Member_UpdateAll(self)



end
 

local function updateHealPredictionBarSize(self)

	self = self:GetParent()
	self.myHealPredictionBar:SetWidth(self.healthBar:GetWidth())
	self.myHealPredictionBar:SetHeight(self.healthBar:GetHeight())
	self.myHoTPredictionBar:SetWidth(self.healthBar:GetWidth())
	self.myHoTPredictionBar:SetHeight(self.healthBar:GetHeight())

	self.otherHealPredictionBar:SetWidth(self.healthBar:GetWidth())
	self.otherHealPredictionBar:SetHeight(self.healthBar:GetHeight())
	self.otherHoTPredictionBar:SetWidth(self.healthBar:GetWidth())
	self.otherHoTPredictionBar:SetHeight(self.healthBar:GetHeight())

	self.absorbPredictionBar:SetWidth(self.healthBar:GetWidth())
	self.absorbPredictionBar:SetHeight(self.healthBar:GetHeight())
end

local function getUnitPetOrOwner(unit)
	if unit then
		if unit == "player" then
			return "pet"
		elseif unit == "vehicle" or unit == "pet" then
			return "player"
		elseif unit:find("pet") then
			return (unit:gsub("pet", ""))
		else
			return (unit:gsub("(%d+)", "pet%1"))
		end
	end
	return nil
end
 
local function baseOnAttributeChanged(self, key, value)

	if key == "unit" then

		if value then
 
			key = getUnitPetOrOwner(value)
 
			self:RegisterUnitEvent("UNIT_NAME_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_CONNECTION", value, key)
 			self:RegisterUnitEvent("UNIT_HEALTH", value, key)
 			self:RegisterUnitEvent("UNIT_MAXHEALTH", value, key)
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", value, key)
			self:RegisterUnitEvent("UNIT_HEAL_PREDICTION", value, key)
--			self:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", value, key)
			self:RegisterUnitEvent("UNIT_POWER_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_MAXPOWER", value, key)
			self:RegisterUnitEvent("UNIT_DISPLAYPOWER", value, key)
			self:RegisterUnitEvent("UNIT_POWER_BAR_SHOW", value, key)
			self:RegisterUnitEvent("UNIT_POWER_BAR_HIDE", value, key)
			self:RegisterUnitEvent("UNIT_AURA", value, key)
 
--			self:RegisterUnitEvent("COMBAT_LOG_EVENT_UNFILTERED")



		else


			self:UnregisterEvent("UNIT_NAME_UPDATE")
			self:UnregisterEvent("UNIT_CONNECTION")
 			self:UnregisterEvent("UNIT_HEALTH")

			self:UnregisterEvent("UNIT_MAXHEALTH")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
			self:UnregisterEvent("UNIT_HEAL_PREDICTION")
--			self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
			self:UnregisterEvent("UNIT_POWER_UPDATE")
			self:UnregisterEvent("UNIT_MAXPOWER")
			self:UnregisterEvent("UNIT_DISPLAYPOWER")
			self:UnregisterEvent("UNIT_POWER_BAR_SHOW")
			self:UnregisterEvent("UNIT_POWER_BAR_HIDE")
			self:UnregisterEvent("UNIT_AURA")
--			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

			 
 		end
	end
end

function InvenRaidFrames3Member_SetOptionTable(self, optionTable)
	self.optionTable = optionTable
end

function InvenRaidFrames3Base_OnLoad(self)

	self:RegisterForClicks("AnyUp")
	self:RegisterForDrag("LeftButton", "RightButton")
	self.timer, self.health, self.maxHealth, self.lostHealth, self.overAbsorb = 0, 0, 1, 0, 0
	InvenRaidFrames3Member_SetOptionTable(self, noOption)
	self.healthBar:SetScript("OnSizeChanged", updateHealPredictionBarSize)
	if not self.petButton then
		setHorizontal(self.myHealPredictionBar)
		setHorizontal(self.myHoTPredictionBar)
		setHorizontal(self.otherHealPredictionBar)
		setHorizontal(self.otherHoTPredictionBar)
		setHorizontal(self.absorbPredictionBar)
	end
	self:SetFrameStrata("MEDIUM")
	self:SetFrameLevel(self:GetParent():GetFrameLevel())
	self:HookScript("OnAttributeChanged", baseOnAttributeChanged)
end

local function isPetGroup(self)
	return self:GetParent() == IRF3.petHeader
end

local function isTankGroup(self)
 
	return self:GetParent() == IRF3.tankheaders[0]
end

local function memberOnAttributeChanged(self, key, value)
	if key == "unit" then
		if value then
			key = getUnitPetOrOwner(value)
			self:RegisterUnitEvent("READY_CHECK_CONFIRM", value, key)
			self:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", value, key)
			self:RegisterUnitEvent("UNIT_EXITED_VEHICLE", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_START", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", value, key)
			self:RegisterUnitEvent("UNIT_FLAGS", value, key)
		else
			self:UnregisterEvent("READY_CHECK_CONFIRM")
			self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
			self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
			self:UnregisterEvent("UNIT_EXITED_VEHICLE")
			self:UnregisterEvent("UNIT_SPELLCAST_START")
			self:UnregisterEvent("UNIT_SPELLCAST_STOP")
			self:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			self:UnregisterEvent("UNIT_FLAGS")
		end
	end
end

function InvenRaidFrames3Member_OnLoad(self)

	InvenRaidFrames3Base_OnLoad(self)
	self.UpdateAll = InvenRaidFrames3Member_UpdateAll
	self.Setup = setupMemberAll
	self.SetupTexture = setupMemberTexture
	self.SetupPowerBar = setupMemberPowerBar
	self.SetupBarOrientation = setupMemberBarOrientation
	self.SetupPowerBarAltPos = InvenRaidFrames3Member_SetupPowerBarAltPos
	self.SetupCastingBarPos = InvenRaidFrames3Member_SetupCastingBarPos
	self.SetupIconPos = InvenRaidFrames3Member_SetupIconPos
	self.SetupOutline = setupMemberOutline
	self.SetupDebuffIcon = setupMemberDebuffIcon
	self:SetID(tonumber(self:GetName():match("UnitButton(%d+)$")))
	self:GetParent().members[self:GetID()] = self
	tinsert(UnitPopupMenus, self.dropDown:GetName())-- tinsert(UnitPopupFrames, self.dropDown:GetName()) --8.0
	CompactUnitFrame_SetMenuFunc(self, CompactUnitFrameDropDown_Initialize)
	self.nameTable = {}
	self.name:SetDrawLayer("OVERLAY", 2)
	self.name:Show()
	self.losttext:SetDrawLayer("OVERLAY", 2)
	self.losttext:Show()
	self.readyCheckIcon:SetParent(self.topLevel)
	self.readyCheckIcon:SetDrawLayer("OVERLAY", 6)
	self.readyCheckIcon:ClearAllPoints()
	self.readyCheckIcon:SetPoint("CENTER", 0, 0)
	self.readyCheckIcon:SetSize(24, 24)
	self.roleIcon:SetSize(0.001, 0.001)
	self.roleIcon:SetDrawLayer("OVERLAY", 2)
 	self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	self.leaderIcon:SetSize(0.001, 0.001)
	self.leaderIcon:SetDrawLayer("OVERLAY", 2)
 	self.looterIcon:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
	self.looterIcon:SetSize(0.001, 0.001)
	self.looterIcon:SetDrawLayer("OVERLAY", 2)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_ROLES_ASSIGNED")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("INCOMING_RESURRECT_CHANGED")
	self:RegisterEvent("UNIT_OTHER_PARTY_CHANGED")
	self:RegisterEvent("UNIT_PHASE")
	self:RegisterEvent("UNIT_PET")
	if self:GetParent().index == 0 and self:GetID() == 1 then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	else
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
 
	end

	self:HookScript("OnAttributeChanged", memberOnAttributeChanged)
end

function InvenRaidFrames3Member_OnShow(self)

	if IRF3.db then
		self:SetScript("OnEvent", InvenRaidFrames3Member_OnEvent)
		if not self.ticker then
			self.ticker = C_Timer.NewTicker(1, function() InvenRaidFrames3Member_OnUpdate(self) end) --전역 타이머 설정
		end



		self:GetParent().visible = self:GetParent().visible + 1
		InvenRaidFrames3Member_UpdateAll(self)
		if isPetGroup(self) then
			self:GetParent().border:SetAlpha(1)
		else
			IRF3:BorderUpdate()
		end
	end

	IRF3.visibleMembers[self] = true
end

function InvenRaidFrames3Member_OnHide(self)
	if IRF3.db then
		self:SetScript("OnEvent", nil)
		if self.ticker then  -- 레이드 프레임이 보이지 않을 때 타이머 변수 삭제
			self.ticker:Cancel()
			self.ticker = nil
		end
		if self.survivalticker then -- 플레이어가 보이지 않을 때 타이머 변수 삭제
			self.survivalticker:Cancel()
			self.survivalticker = nil
		end
		if self.castingBar.ticker then  --캐스팅 바 타이머 작동 중 파탈 또는 파티 해체 시 타이머 변수 삭제
			self.castingBar.ticker:Cancel()
			self.castingBar.ticker = nil
		end
		if self.bossAura.ticker then --  대상 플레이어가 보이지 않을 때 오라 타이머 삭제
			self.bossAura.ticker:Cancel()
			self.bossAura.ticker = nil
		end
		if self.spellticker then
			self.spellticker:Cancel()
			self.spellticker = nil
		end
		self:GetParent().visible = self:GetParent().visible - 1
		InvenRaidFrames3Member_OnDragStop(self)
		if isPetGroup(self) then
			self:GetParent().border:SetAlpha(self:GetParent().visible > 0 and 1 or 0)
		else
			IRF3:BorderUpdate()
		end
		table.wipe(self.nameTable)
		self.lostHealth, self.overAbsorb, self.hasAggro, self.isOffline, self.isAFK, self.color, self.class = 0, 0, nil, nil, nil, nil
		self.unit, self.displayedUnit = nil, nil
	end
	IRF3.visibleMembers[self] = nil
	IRF3:CallbackClearObject(self)
end

--타이머 작동 중 파티 탈퇴 또는 파티 해체 시 각 플레이어에게 할당된 주문 타이머 변수 삭제
function InvenRaidFrames3Member_OnSpellTimerHide(self)
	if self.spellticker then
			self.spellticker:Cancel()
			self.spellticker = nil
	end
end

function InvenRaidFrames3Member_OnEnter(self)
 
	IRF3.onEnter = self
	self.highlight:SetAlpha(IRF3.db.highlightAlpha)

	self.highlight:Show()
	if self.displayedUnit and IRF3.tootipState then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:SetUnit(self.displayedUnit)
		GameTooltipTextLeft1:SetTextColor(GameTooltip_UnitColor(self.displayedUnit))
--		GameTooltipTextLeft1:SetTextColor(IRF3.db.colors[self.class][1],IRF3.db.colors[self.class][2],IRF3.db.colors[self.class][3])--,IRF3.db.colors[self.class][4])

	else
		GameTooltip:Hide()
	end
end

function InvenRaidFrames3Member_OnLeave(self)
	IRF3.onEnter = nil
	self.highlight:Hide()
	GameTooltip:Hide()
end

function InvenRaidFrames3Member_OnDragStart(self)
	if IRF3.db.lockAlt and IsAltKeyDown() or not IRF3.db.lock then
		IRF3.dragging = self
		if isTankGroup(self) then 
			if IRF3.db.enableTankFrame then
			IRF3.tankheaders[0]:StartMoving()
			end
		elseif isPetGroup(self) or self:GetParent() == InvenRaidFrames3PreviewPet then
			IRF3.petHeader:StartMoving()
		else

			IRF3:StartMoving()
		end
	end
end

function InvenRaidFrames3Member_OnDragStop(self)
	if not IsAltKeyDown() or IRF3.dragging then
		IRF3.dragging = nil
--		IRF3:SetUserPlaced(nil)
		IRF3:StopMovingOrSizing()
--		IRF3.petHeader:SetUserPlaced(nil)
		IRF3.petHeader:StopMovingOrSizing()
--		IRF3.tankheaders[0]:SetUserPlaced(nil)
		IRF3.tankheaders[0]:StopMovingOrSizing()
		IRF3:SavePosition()
	end
end

function InvenRaidFrames3Member_UpdateHealth(self)

local health
local maxhealth

if self.displayedUnit then 

 
 
if     IRF3.libCLHealth and IRF3.db.enableInstantHealth   then --빠른체력적용을 했을 경우

	health = IRF3.libCLHealth.UnitHealth(self.displayedUnit)
	maxhealth = UnitHealthMax(self.displayedUnit)
 
else

	health = UnitHealth(self.displayedUnit)
	maxhealth = UnitHealthMax(self.displayedUnit)
end  
	self.healthBar:SetValue(health)
	self.health = health
	self.maxHealth = maxhealth
	self.lostHealth = maxhealth - health
	self.healthBar:SetMinMaxValues(0, maxhealth)
	self.myHealPredictionBar:SetMinMaxValues(0, maxhealth)
	self.myHoTPredictionBar:SetMinMaxValues(0, maxhealth)
	self.otherHealPredictionBar:SetMinMaxValues(0, maxhealth)
	self.otherHoTPredictionBar:SetMinMaxValues(0, maxhealth)
	self.absorbPredictionBar:SetMinMaxValues(0, maxhealth)

--prediction은 healcomm event에서 처리하지만, 만피일때 hot->heal comm event 발생안함->체력감소->즉시 hot반영안됨.따라서 여기서도 predict 호출
 InvenRaidFrames3Member_UpdateHealPrediction(self)


end
end

function InvenRaidFrames3Member_UpdatePetHealth(self)

local health
local maxhealth

if self.displayedUnit then 

 
 

	health = UnitHealth(self.displayedUnit)
	maxhealth = UnitHealthMax(self.displayedUnit)
 

	self.healthBar:SetValue(health)
	self.health = health
	self.maxHealth = maxhealth
	self.lostHealth = maxhealth - health
	self.healthBar:SetMinMaxValues(0, maxhealth)
	self.myHealPredictionBar:SetMinMaxValues(0, maxhealth)
	self.myHoTPredictionBar:SetMinMaxValues(0, maxhealth)
	self.otherHealPredictionBar:SetMinMaxValues(0, maxhealth)
	self.otherHoTPredictionBar:SetMinMaxValues(0, maxhealth)
	self.absorbPredictionBar:SetMinMaxValues(0, maxhealth)

--prediction은 healcomm event에서 처리하지만, 만피일때 hot->heal comm event 발생안함->체력감소->즉시 hot반영안됨.따라서 여기서도 predict 호출
 InvenRaidFrames3Member_UpdateHealPrediction(self)


end
end


local function InvenRaidFrames3Member_GetDisplayedPowerID(self)

--	local barType, minPower, startInset, endInset, smooth, hideFromOthers, showOnRaid, opaqueSpark, opaqueFlash, powerName, powerTooltip = UnitAlternatePowerInfo(self.displayedUnit)
--	if ( showOnRaid and (UnitInParty(self.unit) or UnitInRaid(self.unit)) ) then
--		return ALTERNATE_POWER_INDEX
--	else
		return (UnitPowerType(self.displayedUnit))
--	end
end

function InvenRaidFrames3Member_UpdateMaxPower(self)
	self.powerBar:SetMinMaxValues(0, UnitPowerMax(self.displayedUnit, InvenRaidFrames3Member_GetDisplayedPowerID(self)))
end

function InvenRaidFrames3Member_UpdatePower(self)
	self.powerBar:SetValue(UnitPower(self.displayedUnit, InvenRaidFrames3Member_GetDisplayedPowerID(self)))
end

--prediction은 healcomm event에서 처리
function InvenRaidFrames3Member_UpdateHealPrediction(self)

--	if  not libCHC then
if not self.optionTable.displayHealPrediction   then

		if self.healIcon and self.healIcon:IsShown() then
			self.healIcon:SetSize(0.001, 0.001)
			self.healIcon:Hide()
			self.healingtarget:Hide()
		end

		self.myHealPredictionBar:Hide()
		self.myHoTPredictionBar:Hide()
		self.otherHealPredictionBar:Hide()
		self.otherHoTPredictionBar:Hide()
		self.absorbPredictionBar:Hide()	
		self.overAbsorbGlow:Hide()	
		return
end

--classic에서 제외
--		self.overAbsorbGlow:Hide()
--		self.absorbPredictionBar:Hide()
	if self.optionTable.displayHealPrediction and not UnitIsDeadOrGhost(self.displayedUnit) then
		local myGUID = UnitGUID("player")
		local targetGUID = UnitGUID(self.displayedUnit)

local allIncomingHeal,allOverTimeHeal,myIncomingHeal ,otherIncomingHeal ,myOverTimeHeal ,otherOverTimeHeal,totalAbsorb ,totalPrediction  
 
----HealComm : HOT 구분

if IRF3.libCHC and IRF3.db.enableHealComm then

		allIncomingHeal = (IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.ALL_HEALS, nil, nil) or 0) * (IRF3.libCHC:GetHealModifier(targetGUID) or 1)
		allOverTimeHeal = (IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.OVERTIME_AND_BOMB_HEALS, nil, nil) or 0) * (IRF3.libCHC:GetHealModifier(targetGUID) or 1)
--libHealComm
--print(IRF3.isWOTLK)

		 myIncomingHeal = IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.CASTED_HEALS, nil, myGUID) or 0 --my Direct
		 otherIncomingHeal = IRF3.libCHC:GetOthersHealAmount(targetGUID, IRF3.libCHC.CASTED_HEALS, nil) or 0 --other direct

 



--print(myIncomingHeal)
--print(otherIncomingHeal)

		myOverTimeHeal = IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.OVERTIME_AND_BOMB_HEALS, nil, myGUID) or 0 --myHOT
		otherOverTimeHeal = IRF3.libCHC:GetOthersHealAmount(targetGUID, IRF3.libCHC.OVERTIME_AND_BOMB_HEALS, nil) or 0 --otherHoT

else --자체 함수 사용

	myIncomingHeal = UnitGetIncomingHeals(self.displayedUnit, "player") or 0
	allIncomingHeal = UnitGetIncomingHeals(self.displayedUnit) or 0
	otherIncomingHeal = allIncomingHeal - myIncomingHeal
	allOverTimeHeal = 0 --자체함수로 클래식에서 HoT인식안됨
	myOverTimeHeal = 0--자체함수로 클래식에서 HoT인식안됨
	otherOverTimeHeal = 0--자체함수로 클래식에서 HoT인식안됨
end
--		totalAbsorb = UnitGetTotalAbsorbs and UnitGetTotalAbsorbs(self.displayedUnit) or 0
		totalAbsorb = 0 --클래식에선 보호막 api없어서 막아둠
--		totalAbsorb = (IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.ABSORB_SHIELDS, nil, myGUID) or 0 )--+(IRF3.libCHC:GetOthersHealAmount(targetGUID, IRF3.libCHC.ABSORB_SHIELDS, nil, myGUID)  or 0)
--		totalPrediction = allIncomingHeal + totalAbsorb
--print(IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.ALL_HEALS, nil, myGUID))

local health
local maxhealth

if     IRF3.libCLHealth and IRF3.db.enableInstantHealth then
 
	health = IRF3.libCLHealth.UnitHealth(self.displayedUnit)
	maxhealth = UnitHealthMax(self.displayedUnit)	
else
 
	health = UnitHealth(self.displayedUnit)
	maxhealth = UnitHealthMax(self.displayedUnit)
end


		local lost = maxhealth - health

--Heal 아이콘
local healers =0
		if self.healIcon then
		

			if self.optionTable.healIcon and (myIncomingHeal or 0) > 0 then
				self.healIcon:SetVertexColor(self.optionTable.myHealPredictionColor[1], self.optionTable.myHealPredictionColor[2], self.optionTable.myHealPredictionColor[3])
				self.healIcon:SetSize(self.optionTable.healIconSize, self.optionTable.healIconSize)
				self.healIcon:Show()
				self.healingtarget:Show()
			elseif self.optionTable.healIconOther and (otherIncomingHeal or 0)  > 0 then

				self.healIcon:SetVertexColor(self.optionTable.otherHealPredictionColor[1], self.optionTable.otherHealPredictionColor[2], self.optionTable.otherHealPredictionColor[3])
				self.healIcon:SetSize(self.optionTable.healIconSize, self.optionTable.healIconSize)
				self.healIcon:Show()
				self.healingtarget:Show()
			elseif self.healIcon and self.healIcon:IsShown() then
				self.healIcon:SetSize(0.001, 0.001)
				self.healIcon:Hide()
				self.healingtarget:Hide()
			end
		end
--힐러수 계산
		if IRF3.db.units.showhealers then
			for _, header in pairs(IRF3.headers) do

				for _, member in pairs(header.members) do
					if healers>3 then return end

					if member.displayedUnit and self.healIcon:IsShown() then
						if member.displayedUnit and (UnitGetIncomingHeals(self.displayedUnit,member.displayedUnit) or 0) >0 then
							healers=healers+1
 
								if healers>3 then
									self.healingtarget:SetText(healers.."+")

								else 
									self.healingtarget:SetText(healers)
								end

 
							

						end

 
					end
				end
			end
		end


--		

		if lost > 0 then



--바길이/높이 계산을 위한 우선순위
--(1)myIncomingHeal : 바길이(높이) = health+myIncomingHeal
--(2)otherIncomingHeal : 바길이(높이) =  health + myIncomingHeal+otherIncomingHeal
--(3)myOverTimeHeal : 바길이(높이) = health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal
--(4)otherOverTimeHeal : 바길이(높이) = health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal+otherOverTimeHeal
 local varvalue
myIncomingHeal =  myIncomingHeal  or 0
otherIncomingHeal = otherIncomingHeal or 0
myOverTimeHeal = myOverTimeHeal    or 0
otherOverTimeHeal=otherOverTimeHeal or 0
totalAbsorb  =totalAbsorb  or 0

			if myIncomingHeal  > 0 then

				varvalue = min(maxhealth*2, health + myIncomingHeal)

				self.myHealPredictionBar:SetValue(varvalue)
				self.myHealPredictionBar:Show()


			else

				self.myHealPredictionBar:Hide()
			end

 
 
 
			if otherIncomingHeal   > 0 then
	

				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal)
				self.otherHealPredictionBar:SetValue(varvalue)
				self.otherHealPredictionBar:Show()

			else

				self.otherHealPredictionBar:Hide()
			end


			if myOverTimeHeal  >0 then

				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal)
				self.myHoTPredictionBar:SetValue(varvalue)
				self.myHoTPredictionBar:Show()				
			else

				self.myHoTPredictionBar:Hide()
			end



			if otherOverTimeHeal  > 0 then
				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal+otherOverTimeHeal)
				self.otherHoTPredictionBar:SetValue(varvalue)
				self.otherHoTPredictionBar:Show()
			else
				self.otherHoTPredictionBar:Hide()
			end
 
	 			if totalAbsorb  > 0 then
--lost가 있고 보호막이 있을 경우 
	 				varvalue = min(maxhealth, health + totalPrediction)




	 				self.absorbPredictionBar:SetValue(varvalue)
	 				self.absorbPredictionBar:Show()


	 			else
--lost가 있고 보호막이 없을 경우
	 				self.absorbPredictionBar:Hide()
	 			end
	 			self.overAbsorbGlow:Hide()
 
		else
 
--lost가 없고(만피) 보호막이 있을 경우는 glow
	 			if totalAbsorb   > 0 and totalPrediction >= lost then
	 				self.overAbsorbGlow:Show()
	 				self.overAbsorb = totalAbsorb

	 			else
 --lost가 없고(만피) 보호막이 없을 경우
	 				self.overAbsorbGlow:Hide()
	 				self.overAbsorb = 0
	 			end

			self.myHealPredictionBar:Hide()
			self.myHoTPredictionBar:Hide()
			self.otherHealPredictionBar:Hide()
			self.otherHoTPredictionBar:Hide()
			self.absorbPredictionBar:Hide()
--			self.overAbsorbGlow:Hide()
		end

	else--예측힐을 사용하지않거나 죽은 경우에는 다 hide
		if self.healIcon and self.healIcon:IsShown() then
			self.healIcon:SetSize(0.001, 0.001)
			self.healIcon:Hide()
			self.healingtarget:Hide()
		end

		self.myHealPredictionBar:Hide()
		self.myHoTPredictionBar:Hide()
		self.otherHealPredictionBar:Hide()
		self.otherHoTPredictionBar:Hide()
		self.absorbPredictionBar:Hide()
		self.overAbsorbGlow:Hide()
	end
--클래식에선 제외
--	self.overAbsorbGlow:Hide()
--	self.absorbPredictionBar:Hide()

end

local colorR, colorG, colorB

function InvenRaidFrames3Member_UpdateState(self)
if self.unit then
	_, self.class = UnitClass(self.displayedUnit)
 
	if UnitIsConnected(self.unit) then
		self.isOffline = nil
		if UnitIsGhost(self.displayedUnit) then
			self.isGhost = true
		elseif UnitIsDead(self.displayedUnit) then
			self.isDead = true
		elseif UnitIsAFK(self.unit) then
			self.isAFK = true
		else
			self.isGhost, self.isOffline, self.isDead, self.isAFK = nil, nil, nil, nil
		end
 


		if self.isGhost or self.isDead then
			colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
		elseif self.optionTable.useHarm and UnitCanAttack(self.displayedUnit, "player") then
			colorR, colorG, colorB = IRF3.db.colors.harm[1], IRF3.db.colors.harm[2], IRF3.db.colors.harm[3]
		elseif self.dispelType and IRF3.db.colors[self.dispelType] and self.optionTable.useDispelColor then
			colorR, colorG, colorB = IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3]
		elseif self.displayedUnit:find("pet") then
			if self.petButton then
				colorR, colorG, colorB = IRF3.db.colors.vehicle[1], IRF3.db.colors.vehicle[2], IRF3.db.colors.vehicle[3]
			else
				colorR, colorG, colorB = IRF3.db.colors.pet[1], IRF3.db.colors.pet[2], IRF3.db.colors.pet[3]
			end
		elseif self.optionTable.useClassColors and IRF3.db.colors[self.class] then
			colorR, colorG, colorB = IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3]
		else
			colorR, colorG, colorB = IRF3.db.colors.help[1], IRF3.db.colors.help[2], IRF3.db.colors.help[3]
		end
--		self.overAbsorbGlow:Show() 
		self.powerBar:Show()--online시 show
	else
		self.isOffline, self.isGhost, self.isDead, self.isAFK = true, nil, nil, nil
		colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
		self.overAbsorbGlow:Hide() --offline시 숨김
		self.powerBar:Hide()--offline시 숨김
	end
	self.healthBar:SetStatusBarColor(colorR, colorG, colorB)
	colorR, colorG, colorB = nil

end
end

local altR, altG, altB

function InvenRaidFrames3Member_UpdatePowerColor(self)
	if self.isOffline then
		colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
--	elseif select(7, UnitAlternatePowerInfo(self.displayedUnit)) then
--		colorR, colorG, colorB = 0.7, 0.7, 0.6
	else
		colorR, colorG, altR, altG, altB = UnitPowerType(self.displayedUnit)
		if IRF3.db.colors[colorG] then
			colorR, colorG, colorB = IRF3.db.colors[colorG][1], IRF3.db.colors[colorG][2], IRF3.db.colors[colorG][3]
		elseif PowerBarColor[colorR] then
			colorR, colorG, colorB = PowerBarColor[colorR].r, PowerBarColor[colorR].g, PowerBarColor[colorR].b
		elseif altR then
			colorR, colorG, colorB = altR, altG, altB
		else
			colorR, colorG, colorB = PowerBarColor[0].r, PowerBarColor[0].g, PowerBarColor[0].b
		end
	end
	self.powerBar:SetStatusBarColor(colorR, colorG, colorB)
	colorR, colorG, colorB, altR, altG, altB = nil
end

local roleType --HEALER DAMAGER TANK

function InvenRaidFrames3Member_UpdateRoleIcon(self)

--	if self.optionTable.displayRaidRoleIcon and self.optionTable.displayClassicRaidRoleIcon then

	if self.optionTable.displayRaidRoleIcon  then

	 roleType = "NONE"
    


	if not self.optionTable.displayRaidRoleIcon2  then -- 파티찾기 역할 표기일 경우(개인이 지정한 탱/딜/힐). 이 옵션이 체크면 공격대에서 지정된 방어전담/지원전담
	            roleType = UnitGroupRolesAssigned(self.unit) or "NONE"
		if self.optionTable.displayRaidRoleIconTank then --탱커만 표시
			if roleType ~="TANK" then roleType="NONE" end
		end
            
	else
		roleType= IRF3_UnitGroupRolesAssigned(self.unit) or "NONE"
	end


		--GetTexCoordsForRoleSmallCircle
    if roleType ~= "NONE" then
      if self.optionTable.roleIcontype == 1 then --블리자드 기본
        if roleType == "DAMAGER" then
          self.roleIcon:SetTexture("Interface\\AddOns\\InvenRaidFrames3\\Texture\\dps")
          self.roleIcon:SetTexCoord(0, 1, 0, 1)
        else
          self.roleIcon:SetTexture("Interface\\AddOns\\InvenRaidFrames3\\Texture\\RoleIcon_MiirGui")
          self.roleIcon:SetTexCoord(GetTexCoordsForRole(roleType))
          self.roleIcon:SetTexCoord(0, 1, 0, 1)
        end

      else--MiirGui
        self.roleIcon:SetTexture("Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES")
        local left, top, right, bottom = GetTexCoordsForRole(roleType);
        --self.roleIcon:SetTexCoord(GetTexCoordsForRole(roleType))
        self.roleIcon:SetTexCoord(left * 1.146, top * 1.146, right * 1.146, bottom * 1.30) -- DAMAGER
      end
      self.roleIcon:ClearAllPoints()
      self.roleIcon:SetPoint(self.optionTable.roleIconPos, self, self.optionTable.roleIconPos, 0, 0)
      self.roleIcon:SetSize(self.optionTable.roleIconSize * 1.1, self.optionTable.roleIconSize * 1.5)
      return self.roleIcon:Show()
    end
	end

	self.roleIcon:SetSize(0.001, 0.001)
	self.roleIcon:Hide()

end

local LeaderFlag
local SubLeaderFlag
function InvenRaidFrames3Member_UpdateLeaderIcon(self)

	if self.optionTable.useLeaderIcon then

		LeaderFlag = UnitIsGroupLeader(self.unit)

		if LeaderFlag then
		 	self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
			self.leaderIcon:SetTexCoord(0, 1, 0, 1)
			self.leaderIcon:SetSize(self.optionTable.leaderIconSize, self.optionTable.leaderIconSize)
		
			return self.leaderIcon:Show()
		end
		SubLeaderFlag = UnitIsGroupAssistant(self.unit)
		if SubLeaderFlag then
			self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
			self.leaderIcon:SetTexCoord(0, 1, 0, 1)
			self.leaderIcon:SetSize(self.optionTable.leaderIconSize, self.optionTable.leaderIconSize)
			return self.leaderIcon:Show()
		end
	end
	self.leaderIcon:SetSize(0.001, 0.001)
	self.leaderIcon:Hide()

end


function InvenRaidFrames3Member_UpdateLooterIcon (self)



 --전리품담당자 확인
index = UnitInRaid(self.unit)

if index ~= nil then

local _,_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ ,_ , loot = GetRaidRosterInfo(index)

	if self.optionTable.useLeaderIcon then --공대장표시 옵션 그대로 사용
 
		if loot == true  then

			self.looterIcon:SetTexCoord(0, 1, 0, 1)
			self.looterIcon:SetSize(self.optionTable.leaderIconSize, self.optionTable.leaderIconSize)
			return self.looterIcon:Show()
		
		end
	end
	self.looterIcon:SetSize(0.001, 0.001)
	self.looterIcon:Hide()
end

end


--copied from bliz source.
function InvenRaidFrames3Member_UpdateCenterStatusIcon(self)
	if not self.unit then return end
	if not self.centerStatusIcon then return end
	if self.optionTable.centerStatusIcon and self.unit and UnitInOtherParty(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\LFGFrame\\LFG-Eye")
		self.centerStatusIcon.texture:SetTexCoord(0.125, 0.25, 0.25, 0.5)
		self.centerStatusIcon.border:SetTexture("Interface\\Common\\RingBorder")
		self.centerStatusIcon.border:Show()
		self.centerStatusIcon.tooltip = PARTY_IN_PUBLIC_GROUP_MESSAGE
		self.centerStatusIcon:Show()
	elseif self.optionTable.centerStatusIcon and UnitHasIncomingResurrection(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez")
		self.centerStatusIcon.texture:SetTexCoord(0, 1, 0, 1)
		self.centerStatusIcon.border:Hide()
		self.centerStatusIcon.tooltip = nil
		self.centerStatusIcon:Show()
		self.resurrectStart = GetTime() * 1000
	elseif self.optionTable.centerStatusIcon and self.inDistance and not UnitInPhase(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\TargetingFrame\\UI-PhasingIcon")
		self.centerStatusIcon.texture:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
		self.centerStatusIcon.border:Hide()
		self.centerStatusIcon.tooltip = PARTY_PHASED_MESSAGE
		self.centerStatusIcon:Show()
	else

		self.centerStatusIcon:Hide()
	end
	if self.optionTable.useResurrectionBar then
		InvenRaidFrames3Member_UpdateResurrection(self)
	end
end

local tooltipUpdate = 0
function InvenRaidFrames3Member_CenterStatusIconOnUpdate(self, elapsed)

	if not IRF3.tootipState then return end
	tooltipUpdate = tooltipUpdate + elapsed
	if tooltipUpdate > 0.1 then
		tooltipUpdate = 0
		if self:IsMouseOver() and self.tooltip   then

if GameTooltip:GetOwner() ~= self then -- 타 tooltip애드온과 같이 사용시 setowner중복으로 인해 blink현상 발생하는 경우 있음. 이를 보정하기 위한 루틴 추가
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
end
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		elseif GameTooltip:IsOwned(self) then

			GameTooltip:Hide()
		end
	end
end

function InvenRaidFrames3Member_CenterStatusIconOnHide(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

function InvenRaidFrames3Member_UpdateOutline(self)
if self.optionTable.outline then
	if self.optionTable.outline.type == 1 then
		if self.dispelType and IRF3.db.colors[self.dispelType] then
			self.outline:SetBackdropBorderColor(IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3])
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 2 then
		if UnitIsUnit(self.displayedUnit, "target") then
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 3 then
		if UnitIsUnit(self.displayedUnit, "mouseover") then
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 4 then
		if not UnitIsDeadOrGhost(self.displayedUnit) and (self.health / self.maxHealth) <= self.optionTable.outline.lowHealth then
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 5 then
		if self.hasAggro then
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 6 then
		if self.optionTable.outline.raidIcon[GetRaidTargetIndex(self.displayedUnit)] then
			return self.outline:Show()
		end
	elseif self.optionTable.outline.type == 7 then
		if not UnitIsDeadOrGhost(self.displayedUnit) and self.maxHealth >= self.optionTable.outline.lowHealth2 and self.health < self.optionTable.outline.lowHealth2 then
			return self.outline:Show()
		end
 
	end
	self.outline:Hide()
end
end

--- 타이머에서 지속적으로 체크하는 거리 측정 함수
function InvenRaidFrames3Member_OnUpdate(self)

	-- 거리 측정 로직
	local prevRange = self.outRange
	if self.isOffline then
		self.outRange = false
	else
		local inRange, checkedRange = UnitInRange(self.displayedUnit)
		self.outRange = checkedRange and not inRange
	end
	-- 거리 측정을 해보니 거리가 바뀌었다면
	if prevRange ~= self.outRange then
		if self.outRange then  --시야 바깥일때는 체력바 업데이트 중지
			self:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)

			if not IRF3.db.units.outRangeName2 then --이름표에도 투명도 적용옵션체크.기본값(false)면 이름은 항상 표기
				self.name:SetAlpha(1)
			else
				self.name:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)
			end
--			self.healthBar:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)
--			self.powerBar:SetAlpha(self.optionTable.fadeOutOfRangePower and self.optionTable.fadeOutAlpha or 1)
			self.myHealPredictionBar:SetAlpha(0)
			self.myHoTPredictionBar:SetAlpha(0)
			self.otherHealPredictionBar:SetAlpha(0)
			self.otherHoTPredictionBar:SetAlpha(0)
			self.absorbPredictionBar:SetAlpha(0)

		
			self.hasAggro = false  --어그로먹은 상태에서 시야밖으로 벗어나면 초기화처리(애드후 멀리가서 소멸등)
			self.hasAggroValue = 0 --어그로먹은 상태에서 시야밖으로 벗어나면 초기화처리
--			self.overAbsorbGlow:SetAlpha(0)


		else --시야 안쪽일때 체력 바랑 기력 바 업데이트 시작

--			self.healthBar:SetAlpha(1)
--			self.powerBar:SetAlpha(1)
			self:SetAlpha(1)
			self.myHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
			self.myHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha) 
			self.otherHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
			self.otherHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
			self.absorbPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--			self.overAbsorbGlow:SetAlpha(0)
	


			InvenRaidFrames3Member_UpdateHealth(self)
			InvenRaidFrames3Member_UpdateMaxPower(self)
			InvenRaidFrames3Member_UpdatePower(self)
			InvenRaidFrames3Member_UpdatePowerColor(self)
		end
			--위치 변경이 될때마다 업데이트 할 항목->이벤트에서 처리
--   		InvenRaidFrames3Member_UpdateBuffs(self)
--		InvenRaidFrames3Member_UpdateAura(self)
--		InvenRaidFrames3Member_UpdateSpellTimer(self)
-- 		InvenRaidFrames3Member_UpdateSurvivalSkill(self)
--prediction은 healcomm event에서 처리
-- 		InvenRaidFrames3Member_UpdateHealPrediction(self)

 		InvenRaidFrames3Member_UpdateNameColor(self)
 		InvenRaidFrames3Member_UpdateDisplayText(self)

  end
	--거리 측정과 상관없이 타이머에서 지속적으로 갱신할 것들 (많이 추가하면 CPU 점유율 급증할 위험 있음)
	--IRF3:UpdateThreatSituation() --소멸 리셋등의 경우 어그로 표기 초기화가 안되서 수시 업데이트 필요(THREAT_SITUATION event로 감지안되는 경우 있음)
if self.displayedUnit:find("pet") then
 	InvenRaidFrames3Member_UpdatePetHealth(self) --소환수 잦은 소환/종료시 pet 목록이 바뀌면서 체력꼬임.오히려 팻만 주기적으로 업데이트
 
end
	InvenRaidFrames3Member_UpdateState(self)
 	InvenRaidFrames3Member_UpdateRaidIconTarget(self)
--	InvenRaidFrames3Member_UpdateSurvivalSkill(self) -- 전체도발을 대상에 대한 디버프이므로 UNIT_AURA:target으로 일어나야함->COMBAT_LOG수준의 부하가 우려되어 차라리 여기에서 0.5초 마다 수행->이벤트에서 처리
--prediction은 healcomm event에서 처리
--	InvenRaidFrames3Member_UpdateHealPrediction(self)
	-- 위상 업데이트
	local distance, checkedDistance = UnitDistanceSquared(self.displayedUnit)
	if checkedDistance then
		local inDistance = distance < 250*250
		if inDistance ~= self.inDistance then
			self.inDistance = inDistance
			InvenRaidFrames3Member_UpdateCenterStatusIcon(self)
		end
	end

end

--- 타이머에서 지속적으로 체크하지 않는 거리 측정 함수
function InvenRaidFrames3Member_OnUpdate2(self)

	if self.isOffline then
		self.outRange = false
	else
		local inRange, checkedRange = UnitInRange(self.displayedUnit)
		self.outRange = checkedRange and not inRange
	end
	if self.outRange then
		self:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)
--		self.name:SetIgnoreParentAlpha(true)




		if not IRF3.db.units.outRangeName2 then --이름표에도 투명도 적용옵션체크.기본값(false)면 이름은 항상 표기
			self.name:SetAlpha(1)
		else
			self.name:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)
		end
		--self.healthBar:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)
		--self.powerBar:SetAlpha(self.optionTable.fadeOutOfRangePower and self.optionTable.fadeOutAlpha or 1)
		self.myHealPredictionBar:SetAlpha(0)
		self.myHoTPredictionBar:SetAlpha(0)
		self.otherHealPredictionBar:SetAlpha(0)
		self.otherHoTPredictionBar:SetAlpha(0)
		self.absorbPredictionBar:SetAlpha(0)
--		self.overAbsorbGlow:SetAlpha(0)



	else

		self:SetAlpha(1)
--		self.healthBar:SetAlpha(1)
--		self.powerBar:SetAlpha(1)


		self.myHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
		self.myHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
		self.otherHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
		self.otherHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
		self.absorbPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--		self.overAbsorbGlow:SetAlpha(0)


	end


end

function InvenRaidFrames3Member_OnEvent(self, event, ...)
  
	eventHandler[event](self, ...)
 
end
 



-- 대부분의 인자를 즉시 업데이트 함
function InvenRaidFrames3Member_UpdateAll(self)

	if IRF3.db then


		InvenRaidFrames3Member_UpdateInVehicle(self)
		if UnitExists(self.displayedUnit or "") then

			InvenRaidFrames3Member_UpdateName(self)
			InvenRaidFrames3Member_UpdateState(self)
			InvenRaidFrames3Member_UpdateNameColor(self)
			InvenRaidFrames3Member_UpdateHealth(self)
--prediction은 healcomm event에서 처리
--			InvenRaidFrames3Member_UpdateHealPrediction(self)
			InvenRaidFrames3Member_UpdateMaxPower(self)
			InvenRaidFrames3Member_UpdatePower(self)
			InvenRaidFrames3Member_UpdatePowerColor(self)
			InvenRaidFrames3Member_UpdateCastingBar(self)
			InvenRaidFrames3Member_UpdatePowerBarAlt(self)
			InvenRaidFrames3Member_UpdateThreat(self)
			InvenRaidFrames3Member_UpdateRoleIcon(self)
			InvenRaidFrames3Member_UpdateLeaderIcon(self)
			InvenRaidFrames3Member_UpdateLooterIcon(self)
			InvenRaidFrames3Member_UpdateRaidIcon(self)
			InvenRaidFrames3Member_UpdateBuffs(self)
			InvenRaidFrames3Member_UpdateAura(self)
			InvenRaidFrames3Member_UpdateSpellTimer(self)
			InvenRaidFrames3Member_UpdateSurvivalSkill(self)
			InvenRaidFrames3Member_UpdateOutline(self)
			InvenRaidFrames3Member_OnUpdate2(self)
			InvenRaidFrames3Member_UpdateRaidIconTarget(self)
			InvenRaidFrames3Member_UpdateDisplayText(self)
			InvenRaidFrames3Member_UpdateCenterStatusIcon(self)
		end
	end
end

function InvenRaidFrames3Member_UpdateInVehicle(self)

	self.unit = SecureButton_GetUnit(self)
if self.unit then
	self.displayedUnit = self.unit and (SecureButton_GetModifiedUnit(self) or self.unit) or nil

	if self.petButton then
		if UnitExists(SecureButton_GetModifiedUnit(self.petButton) or "") then
			InvenRaidFrames3Pet_OnShow(self.petButton)
		else
			InvenRaidFrames3Pet_OnHide(self.petButton)
		end
	end
	if IRF3.onEnter == self then
		InvenRaidFrames3Member_OnEnter(self)
	end
end

end

function InvenRaidFrames3Member_OnAttributeChanged(self, name, value)
	if name == "unit" then

		InvenRaidFrames3Member_UpdateAll(self)
	end
end

eventHandler.PLAYER_ENTERING_WORLD =  InvenRaidFrames3Member_UpdateAll

eventHandler.GROUP_ROSTER_UPDATE =  InvenRaidFrames3Member_UpdateAll 
 
eventHandler.PLAYER_ROLES_ASSIGNED = InvenRaidFrames3Member_UpdateRoleIcon
eventHandler.PARTY_LEADER_CHANGED = InvenRaidFrames3Member_UpdateLeaderIcon
eventHandler.PARTY_LOOT_METHOD_CHANGED = InvenRaidFrames3Member_UpdateLooterIcon
eventHandler.RAID_TARGET_UPDATE = function(self)
	InvenRaidFrames3Member_UpdateRaidIcon(self)
	if self.optionTable.outline.type == 6 then
		InvenRaidFrames3Member_UpdateOutline(self)
	end
end
eventHandler.UNIT_NAME_UPDATE = function(self, unit)
	if (unit == self.unit or unit == self.displayedUnit) then
		InvenRaidFrames3Member_UpdateName(self)
		InvenRaidFrames3Member_UpdateNameColor(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
	end
end
eventHandler.UNIT_CONNECTION = function(self, unit)
	if (unit == self.unit or unit == self.displayedUnit) then
		InvenRaidFrames3Member_UpdateName(self)
		InvenRaidFrames3Member_UpdateNameColor(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
		InvenRaidFrames3Member_UpdatePowerColor(self)
	end
end
eventHandler.UNIT_FLAGS = function(self, unit)
	if (unit == self.unit or unit == self.displayedUnit) then
		InvenRaidFrames3Member_UpdateHealth(self)
		InvenRaidFrames3Member_UpdateLostHealth(self)
		InvenRaidFrames3Member_UpdateState(self)
		InvenRaidFrames3Member_UpdateNameColor(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
	end
end
eventHandler.PLAYER_FLAGS_CHANGED = eventHandler.UNIT_FLAGS
eventHandler.UNIT_HEALTH = function(self, unit)


	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateHealth(self)
		InvenRaidFrames3Member_UpdateLostHealth(self)
--prediction은 healcomm event에서 처리
--		InvenRaidFrames3Member_UpdateHealPrediction(self)
		InvenRaidFrames3Member_UpdateState(self)
		if self.optionTable.outline.type == 4 or self.optionTable.outline.type == 7 then
			InvenRaidFrames3Member_UpdateOutline(self)
		end
	end
end

eventHandler.COMBAT_LOG_EVENT_UNFILTERED = function(self)
 
end


eventHandler.UNIT_MAXHEALTH = eventHandler.UNIT_HEALTH
eventHandler.UNIT_HEALTH_FREQUENT = function(self, unit)

	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateHealth(self)
		InvenRaidFrames3Member_UpdateLostHealth(self)
	end
end
eventHandler.UNIT_MAXPOWER = function(self, unit, powerType)
	if unit == self.displayedUnit then
		if powerType == "ALTERNATE" then
			InvenRaidFrames3Member_UpdatePowerBarAlt(self)
		else
			InvenRaidFrames3Member_UpdateMaxPower(self)
			InvenRaidFrames3Member_UpdatePower(self)
		end
	end
end
eventHandler.UNIT_POWER_UPDATE = function(self, unit, powerType)
	if unit == self.displayedUnit then
		if powerType == "ALTERNATE" then
			InvenRaidFrames3Member_UpdatePowerBarAlt(self)
		else
			InvenRaidFrames3Member_UpdatePower(self)
		end
	end
end
eventHandler.UNIT_DISPLAYPOWER = function(self, unit)
	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateMaxPower(self)
		InvenRaidFrames3Member_UpdatePower(self)
		InvenRaidFrames3Member_UpdatePowerColor(self)
		InvenRaidFrames3Member_UpdatePowerBarAlt(self)
	end
end
eventHandler.UNIT_POWER_BAR_SHOW = eventHandler.UNIT_DISPLAYPOWER
eventHandler.UNIT_POWER_BAR_HIDE = eventHandler.UNIT_DISPLAYPOWER
eventHandler.UNIT_HEAL_PREDICTION = function(self, unit)
	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateHealth(self)
--prediction은 healcomm event에서 처리
		InvenRaidFrames3Member_UpdateHealPrediction(self)
	end
end
eventHandler.UNIT_ABSORB_AMOUNT_CHANGED = eventHandler.UNIT_HEAL_PREDICTION
--eventHandler.UNIT_AURA = function(self, unit)
eventHandler.UNIT_AURA = function(self, unit, isFullUpdate, updatedAuras)
	if (unit == self.unit or unit == self.displayedUnit ) then

--    		InvenRaidFrames3Member_UpdateBuffs(self)
		--버프체크는 최소1초간격으로만.부하 vs 중요도
 		if IRF3.db.enableClassBuff and (not self.aura_last_updated or self.aura_last_updated < GetTime()-1) then
 
		    	InvenRaidFrames3Member_UpdateBuffs(self, isFullUpdate, updatedAuras)
			self.aura_last_updated=GetTime()	
		end

--		InvenRaidFrames3Member_UpdateAura(self)
		InvenRaidFrames3Member_UpdateAura(self, isFullUpdate, updatedAuras)
--		InvenRaidFrames3Member_UpdateSpellTimer(self)
		InvenRaidFrames3Member_UpdateSpellTimer(self, isFullUpdate, updatedAuras)
--		InvenRaidFrames3Member_UpdateSurvivalSkill(self)
		InvenRaidFrames3Member_UpdateSurvivalSkill(self, isFullUpdate, updatedAuras)
		if self.optionTable.outline.type == 1 then
			InvenRaidFrames3Member_UpdateOutline(self)
		end
		if self.optionTable.useDispelColor then
			InvenRaidFrames3Member_UpdateState(self)
		end
	end
end
 

eventHandler.UNIT_THREAT_SITUATION_UPDATE = function(self,unit)
	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateThreat(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
		if self.optionTable.outline.type == 5 then
			InvenRaidFrames3Member_UpdateOutline(self)
		end
	end


 end
eventHandler.READY_CHECK_CONFIRM = function(self, unit)
	if unit == self.unit then
		InvenRaidFrames3Member_UpdateReadyCheck(self)
	end
end
eventHandler.UNIT_ENTERED_VEHICLE = function(self, unit)

	if unit == self.unit then
		InvenRaidFrames3Member_UpdateAll(self)
	end
end
eventHandler.UNIT_EXITED_VEHICLE = function(self, unit)
	if unit == self.unit then
		InvenRaidFrames3Member_UpdateAll(self)
		C_Timer.After(1, function()
			if UnitGUID(self.unit) then
				InvenRaidFrames3Member_UpdateHealth(self)
				InvenRaidFrames3Member_UpdateLostHealth(self)
			end
		end)
	end
end
eventHandler.UNIT_PET = eventHandler.UNIT_ENTERED_VEHICLE
eventHandler.UNIT_SPELLCAST_START = function(self, unit)
	if IRF3.db.units.useCastingBar and unit == self.displayedUnit then -- 클래식은 자신의 정보만 있음
		InvenRaidFrames3Member_UpdateCastingBar(self)
	end
end
eventHandler.UNIT_SPELLCAST_STOP = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_DELAYED = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_START = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_UPDATE = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_STOP = eventHandler.UNIT_SPELLCAST_START
eventHandler.PLAYER_TARGET_CHANGED = InvenRaidFrames3Member_UpdateOutline
eventHandler.UPDATE_MOUSEOVER_UNIT = InvenRaidFrames3Member_UpdateOutline
eventHandler.INCOMING_RESURRECT_CHANGED = function(self)
	InvenRaidFrames3Member_UpdateCenterStatusIcon(self)
end
eventHandler.UNIT_OTHER_PARTY_CHANGED = eventHandler.INCOMING_RESURRECT_CHANGED
eventHandler.UNIT_PHASE = eventHandler.INCOMING_RESURRECT_CHANGED

--"HEALER" "DAMAGER" "TANK"
--"WARRIOR", "DRUID", "PALADIN", "PRIEST", "SHAMAN", "ROGUE", "MAGE", "WARLOCK", "HUNTER"


function IRF3_UnitGroupRolesAssigned(unit)
--원래로직은 최대한 자동계산이었으나 이마저도 정확하지 않음(암사->힐러 판정등).
--또한 클래식 특성상 명시적으로 표기한 '방어전담'이 중요하므로, 명시적인 방어전담, 지원전담만 표기(공대 only)
	local isRaid = IsInRaid();
	--local isGroup = IsInGroup();

	local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, loot;
	if isRaid and GetRaidRosterInfo and UnitInRaid(unit) then
		name, rank, subgroup, level, class, fileName, zone, online, isDead, role, loot = GetRaidRosterInfo(UnitInRaid(unit));



		if role == "MAINTANK" then

			return "TANK";
		elseif role == "MAINASSIST"  and not IRF3.db.units.displayRaidRoleIconTank then  --지원전담이고, '탱커만표시' 옵션이 아닐때
			return "DAMAGER";
		end
	end
--	local tIntellect, tStrength, tAgility;
--	tStrength = UnitStat(unit, 1);
--	tAgility = UnitStat(unit, 2);
--	tIntellect = UnitStat(unit, 4);
	
--	local className, classType, classNumber = UnitClass(unit);

--	if classType == "WARRIOR" then
--				return "DAMAGER";
--	elseif classType == "PRIEST" then
--				return "HEALER";
--	elseif classType == "DRUID" then
--			if tAgility > tIntellect then
--				return "DAMAGER";
--			else
--				return "HEALER";
--			end
--	elseif classType == "PALADIN" then
--			if tStrength > tIntellect then
--				return "DAMAGER";
--			else
--				return "HEALER";
--			end
--	elseif classType == "SHAMAN" then
--			if tAgility > tIntellect then
--				return "DAMAGER";
--			else
--				return "HEALER";
--			end
--	end
--	return "DAMAGER"
end


 
