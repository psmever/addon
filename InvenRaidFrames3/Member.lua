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
local memberindexfrom =0
local memberindexto =0
local memberparty=0
local GetSpellName = _G.GetSpellName
IRF3 = _G[IRF3] 

local point, relativeTo, relativePoint, xOfs, yOfs
local point1, relativeTo1, relativePoint1, xOfs1, yOfs1
local point2, relativeTo2, relativePoint2, xOfs2, yOfs2
local last_point_check_time
local last_mouseover_member

IRF3.visibleMembers = {}
IRF3.visibleMembersByGUID = {}
IRF3.visibleMembersTankByGUID = {}
IRF3.ValanirGUID={}
IRF3.DivineAegisGUID={}
IRF3.AuraMasteryGUID={} --오라숙련 사용자
IRF3.AuraMasteryTargetGUID={} --오라숙련 받은 대상
IRF3.AuraMasteryTargetGUIDAura={} --오라숙련 받은 대상의 적용오라

local SL = IRF3.GetSpellName

--local InstantHealth = LibStub("LibInstantHealth-1.0")


--local libCLHealth = LibStub("LibCombatLogHealth-1.0")
local LibSmooth = LibStub("LibSmoothStatusBar-1.0")
local SmoothBar = select(2, ...)
local SmoothBarScript =LibSmooth.frame:GetScript("OnUpdate")

 

-- Enable LibSmooth on frame
function SmoothBar:OnEnable(frame)
	if frame.healthBar then LibSmooth:SmoothBar(frame.healthBar) end
--	if frame.powerBar then LibSmooth:SmoothBar(frame.powerBar) end

end

-- Disable LibSmooth on frame
function SmoothBar:OnDisable(frame)
	if frame.healthBar then LibSmooth:ResetBar(frame.healthBar) end
--	if frame.powerBar then LibSmooth:ResetBar(frame.powerBar) end
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
--주문타이머 및 직업버프 사용여부 감지

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

function IRF3:SetupSpellTimerYn()
--주문타이머 및 직업버프 사용여부 감지


IRF3.db.enableSpellTimer=false


	local i=0
	while IRF3.db.enableSpellTimer==false and i<18 do
		i=i+1
		if InvenRaidFrames3CharDB.spellTimer[i].use >0 then   IRF3.db.enableSpellTimer=true end
	end

end


function IRF3:SetupMemberSelect()


----original source from Cycle Arena. embeded only for party/raid selection 
-- create a secure button for each binding
for k,name in pairs({"IRF3Target","IRF3PartyTarget","IRF3RaidTarget","IRF3RaidTargetMelee"}) do
	
	local button = CreateFrame("Button",name,nil,"SecureActionButtonTemplate")
	-- set up persistent attributes to describe the button's behavior

	button:SetAttribute("maxUnits",k<=2 and 5 or 40)
	button:SetAttribute("unitType",k<=2 and "party" or "raid")
	button:SetAttribute("unitIndex",0)
	local targetType
	if name and name:find("Focus") then 

		targetType="focus"
	else

		targetType="target"
	end

local memberselectspell= InvenRaidFrames3CharDB.memberselectspell

	button:SetAttribute("type","macro")
--	button:SetAttribute("type1",targetType)
--	button:SetAttribute("type2",targetType)
--	button:SetAttribute("type","macro")
--	button:SetAttribute("type2","macro")
	button:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

	-- create a pre-click snippet to increment/decrement unit
 
InvenRaidFrames3CharDB.memberselect=InvenRaidFrames3CharDB.memberselect or 0
if InvenRaidFrames3CharDB.memberselect ==1  then --target

	SecureHandlerWrapScript(button,"OnClick",button,[[
		local maxUnits = self:GetAttribute("maxUnits") -- 5 for arena, 5 for party, 40 for raid
		local unitType = self:GetAttribute("unitType")
		local index = self:GetAttribute("unitIndex") -- number 0-X of last seen unit
		local direction = button=="RightButton" and -1 or 1


		for i=1,maxUnits do

			if maxUnits ==40  then --raid면	
				index = (index+direction)%40
			else
				index = (index+direction)%5 --파티/투기장은 최대5명
			end
			local unit = unitType..index+1
			if unit=="party5" then
				unit = "player" -- for party targeting, 5th unit is player
			end


			if UnitExists(unit) then
				self:SetAttribute("unitIndex",index)
				self:SetAttribute("unit",unit)
				self:SetAttribute("macrotext", "/target [@"..unit.."]")

				return
			end
		end
		self:SetAttribute("unit",nil) -- if no unit, don't target
	]])

elseif InvenRaidFrames3CharDB.memberselect >1 then --주문시전(보호막일때 ) --CastingSent이벤트에서 GCD딜레이를 보완함(글쿨때 반복클릭해도 다음 멤버로 넘어가지 않도록) 
--mouse wheeldown은 여러번 실행될수있음(스크롤 속도에 따라)


 	
	
		SecureHandlerWrapScript(button,"OnClick",button,[[

			local maxUnits = self:GetAttribute("maxUnits") -- 5 for arena, 5 for party, 40 for raid
			local unitType = self:GetAttribute("unitType")
			local index = self:GetAttribute("unitIndex") -- number 0-X of last seen unit
			local direction = button=="RightButton" and 1 or -1


			for i=1,maxUnits do
				if maxUnits ==40  then --raid면	
					index = (index+direction)%40
				else
					index = (index+direction)%5 --파티/투기장은 최대5명
				end

				local unit = unitType..index+1
				if unit=="party5" then

					unit = "player" -- for party targeting, 5th unit is player
				end

				if UnitExists(unit) then

					self:SetAttribute("unitIndex",index)
					self:SetAttribute("unit",unit)
 
					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 신의 권능: 보호막 ")--"..(self.GetAttribute("spell") or "" ))--신의 권능: 보호막


					return
				end
			end
			self:SetAttribute("unit",nil) -- if no unit, don't target
		]])
	 

	


end


end


end
 



function IRF3:SetupLib() --외부 라이브러리 로드

--1)CommbatLog Health

 
if IRF3.db.enableInstantHealth then

--print("Instant loaded")
	IRF3.libCLHealth.RegisterCallback(IRF3, "COMBAT_LOG_HEALTH", function (event, unit, eventType) 
local unitGUID 
if unit then unitGUID= UnitGUID(unit) end
if unitGUID then

--loop없이 로직변경
	if IRF3.visibleMembersByGUID[unitGUID] then
		InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersByGUID[unitGUID])
		InvenRaidFrames3Member_UpdateLostHealth(IRF3.visibleMembersByGUID[unitGUID]) 
--print("loghealth updated")
	end

	if IRF3.visibleMembersTankByGUID[unitGUID] then
		InvenRaidFrames3Member_UpdateHealth(IRF3.visibleMembersTankByGUID[unitGUID]) 
		InvenRaidFrames3Member_UpdateLostHealth(IRF3.visibleMembersTankByGUID[unitGUID]) 
--print("loghealth updated : tank",IRF3.visibleMembersTankByGUID[unitGUID])
	end
 end

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


if IRF3.db.units.useAbsorbInClassic then --보호막문양 흡수량 체크를 위한 전투로그 등록여부
	IRF3:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--	print("Combat log registered.")
else
	IRF3:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--	print("Combat log Unregistered.")
end

if self.db.castingSent >0 or (InvenRaidFrames3CharDB.memberselect or 0)>1 then --시전표시기를 사용하거나 순차공대원선택-주문을 사용하면(GCD체크때문에) 이벤트 추가

	IRF3:RegisterEvent("UNIT_SPELLCAST_SENT")
else

	IRF3:UnregisterEvent("UNIT_SPELLCAST_SENT")
end


  

local libtext=""
if IRF3.db.enableInstantHealth then libtext = libtext ..L["library_1"] end
if IRF3.db.enableHealComm then libtext=libtext .. L["library_2"] end
if IRF3.db.smootheffect then libtext=libtext .. L["library_3"] end

if #libtext > 0 then
	IRF3:Message(L["library_9"] .. string.sub(libtext,2,#libtext))
else
	IRF3:Message(L["library_10"])
end




end




function IRF3:SetupAll(update)
 
	for _, header in pairs(self.headers) do
		for _, member in pairs(header.members) do
			member:Setup()
		end
	end

if IRF3.db.enableTankFrame then

		for _, member in pairs(IRF3.tankheaders.members) do
			member:Setup()
		end

end


	for _, member in pairs(self.petHeader.members) do
		member:Setup()
	end

end


 


local statusBarTexture = "Interface\\RaidFrame\\Raid-Bar-Resource-Fill"

local function setupMemberTexture(self)

	statusBarTexture = SM:Fetch("statusbar", IRF3.db.units.texture)

	

	self.healthBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 1)
	self.powerBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 2)




	self.myHealPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", 0)

	self.myHealPredictionBar:SetStatusBarColor(IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)

	self.myHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -2)
	self.myHoTPredictionBar:SetStatusBarColor(IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.otherHealPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -1)
	self.otherHealPredictionBar:SetStatusBarColor(IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.otherHoTPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -3)
	self.otherHoTPredictionBar:SetStatusBarColor(IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
	self.absorbPredictionBar:SetStatusBarTexture(statusBarTexture, "OVERLAY", -4)
	self.absorbPredictionBar:SetStatusBarColor(IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3], IRF3.db.units.healPredictionAlpha*0.4)

	self.myHealPredictionBar:Hide()
	self.myHoTPredictionBar:Hide()
	self.otherHealPredictionBar:Hide()
	self.otherHoTPredictionBar:Hide()
	self.absorbPredictionBar:Hide()


	self.overAbsorbGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
	self.overAbsorbGlow:SetDrawLayer("OVERLAY", 4)
	self.overAbsorbGlow:SetBlendMode("BLEND")
	self.overAbsorbGlow:ClearAllPoints()
	self.overAbsorbGlow:SetPoint("BOTTOMRIGHT", self.healthBar, "BOTTOMRIGHT", 0, 0)
	self.overAbsorbGlow:SetPoint("TOPRIGHT", self.healthBar, "TOPRIGHT", 0, 0)
	self.overAbsorbGlow:SetWidth(9)
	self.overAbsorbGlow:SetAlpha(0.6)
	self.overAbsorbGlow:Hide()



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

		self.castingBar:SetStatusBarTexture(statusBarTexture, "BACKGROUND", 4)
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

local function checkMouseOver(self,elasped)


	self.outlineLastUpdate = (self.outlineLastUpdate or 0) + elasped
	if self.outlineLastUpdate > 1 then --interval 
--print("1",self:GetParent().displayedUnit,elasped)
		if not UnitIsUnit(self:GetParent().displayedUnit, "mouseover") then
	
			self:Hide()
		end
		self.outlineLastUpdate = 0
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
	self.outline:SetAlpha(0)

	if not self.outlineAbsorb then
		self.outlineAbsorb = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
		self.outlineAbsorb:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 1);
		self.outlineAbsorb:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -1);

		self.outlineAbsorb:SetBackdrop({
			--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Addons\\InvenRaidFrames3\\Texture\\Border.tga",
			--tile = true,
			--tileEdge = true,
			--tileSize = 16,
			edgeSize = 12,
			--insets = { left = -3, right = 2, top = -2, bottom = 3 },
		})
	else
	end
	
	self.outlineAbsorb:SetScript("OnUpdate", nil)
	self.outlineAbsorb:SetAlpha(0)



if not self:GetName():find("TankGroup") then -- 방어전담프레임은 제외
	self.outline:SetScale(IRF3.db.units.outline.scale)
	self.outline:SetAlpha(IRF3.db.units.outline.alpha)
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")

	if IRF3.db.units.outline.type == 2 then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.targetColor[1], IRF3.db.units.outline.targetColor[2], IRF3.db.units.outline.targetColor[3])
	elseif IRF3.db.units.outline.type == 3 then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.mouseoverColor[1], IRF3.db.units.outline.mouseoverColor[2], IRF3.db.units.outline.mouseoverColor[3])
--		self.outline:SetScript("OnUpdate", checkMouseOver)

	elseif IRF3.db.units.outline.type == 4 then
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.lowHealthColor[1], IRF3.db.units.outline.lowHealthColor[2], IRF3.db.units.outline.lowHealthColor[3])
	elseif IRF3.db.units.outline.type == 5 then
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.aggroColor[1], IRF3.db.units.outline.aggroColor[2], IRF3.db.units.outline.aggroColor[3])
	elseif IRF3.db.units.outline.type == 6 then
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.raidIconColor[1], IRF3.db.units.outline.raidIconColor[2], IRF3.db.units.outline.raidIconColor[3])
	elseif IRF3.db.units.outline.type == 7 then
		self.outline:SetBackdropBorderColor(IRF3.db.units.outline.lowHealthColor2[1], IRF3.db.units.outline.lowHealthColor2[2], IRF3.db.units.outline.lowHealthColor2[3])
	else
		self.outline:Hide()
	end
	self.outline:Hide()
end

	if self.petButton then
		setupMemberOutline(self.petButton)
	end

	self.outlineAbsorb:SetBackdropBorderColor(IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3])
end

local function setupMemberDebuffIcon(self)
	if IRF3.db.units.debuffIconType == 1 then
		for i = 1, 10 do
			self["debuffIcon"..i].color:ClearAllPoints()
			self["debuffIcon"..i].color:SetAllPoints()
			self["debuffIcon"..i].color:Show()
			self["debuffIcon"..i].icon:ClearAllPoints()
			self["debuffIcon"..i].icon:SetPoint("TOPLEFT", 1, -1)
			self["debuffIcon"..i].icon:SetPoint("BOTTOMRIGHT", -1, 1)
			self["debuffIcon"..i].icon:Show()
		end
	elseif IRF3.db.units.debuffIconType == 2 then
		for i = 1, 10 do
			self["debuffIcon"..i].color:Hide()
			self["debuffIcon"..i].icon:ClearAllPoints()
			self["debuffIcon"..i].icon:SetPoint("TOPLEFT", 1, -1)
			self["debuffIcon"..i].icon:SetPoint("BOTTOMRIGHT", -1, 1)
			self["debuffIcon"..i].icon:Show()
		end
	else
		for i = 1, 10 do
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
 
--	InvenRaidFrames3Member_SetOptionTable(self, IRF3.db.units)
	self.background:SetColorTexture(IRF3.db.units.backgroundColor[1], IRF3.db.units.backgroundColor[2], IRF3.db.units.backgroundColor[3], IRF3.db.units.backgroundColor[4])

	if self.petButton then
--		CompactUnitFrame_SetOptionTable(self.petButton, IRF3.db.units)
--		InvenRaidFrames3Member_SetOptionTable(self.petButton, IRF3.db.units) --CompactUnitFrame대신 IRF호출로 변경.전투중 block되서

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

			LibSmooth.frame:SetScript("OnUpdate",   SmoothBarScript)
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
			self:RegisterUnitEvent("UNIT_MAXHEALTH", value, key) --이벤트 발생시 healcomm에서 인지 못함
			self:RegisterUnitEvent("UNIT_HEALTH", value, key)--대미지 발생시 healcomm에서 인지 못함


			if IRF3.db then

				if  IRF3.db.enableHealComm or IRF3.db.enableInstantHealth then --Healcomm을 사용하는 경우에는 heal commevent에 의존. 혹은 combat log health를 사용하는 경우에는 frequent가 필요하지 않음
					self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
				else --healcomm을 사용하지않으면(해제하면) 자체 이벤트 사용
					self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", value, key)
				end


				if IRF3.db.units.displayHealPrediction  and not IRF3.db.enableHealComm then --healcomm사용시에는 이 이벤트에 의존하지 않음
					self:RegisterUnitEvent("UNIT_HEAL_PREDICTION", value, key)
				else

					self:UnregisterEvent("UNIT_HEAL_PREDICTION")
				end


			
			end
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
--	InvenRaidFrames3Member_SetOptionTable(self, noOption)
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
 
	return self:GetParent() == IRF3.tankheaders
end

local function memberOnAttributeChanged(self, key, value)
	if key == "unit" then
		if value then
			key = getUnitPetOrOwner(value)


			self:RegisterUnitEvent("READY_CHECK_CONFIRM", value, key)
			self:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", value, key)
			self:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", value, key)
			self:RegisterUnitEvent("UNIT_EXITED_VEHICLE", value, key) 
			self:RegisterUnitEvent("UNIT_EXITING_VEHICLE", value, key) 

			if IRF3.db and IRF3.db.units and IRF3.db.units.useCastingBar then
			self:RegisterUnitEvent("UNIT_SPELLCAST_START", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", value, key)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", value, key)
			end

			self:RegisterUnitEvent("UNIT_FLAGS", value, key)
		else
			self:UnregisterEvent("READY_CHECK_CONFIRM")
			self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
			self:UnregisterEvent("UNIT_ENTERED_VEHICLE") 
			self:UnregisterEvent("UNIT_ENTERING_VEHICLE") 
			self:UnregisterEvent("UNIT_EXITED_VEHICLE")
			self:UnregisterEvent("UNIT_EXITING_VEHICLE")
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
--	self.name:Show()

	if self.unit and self.unit:find("pet") then
		self.name:Hide()
	else
		self.name:Show()
	end 
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
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	else

		self:RegisterEvent("GROUP_ROSTER_UPDATE")
 
	end

	self:HookScript("OnAttributeChanged", memberOnAttributeChanged)
end

function InvenRaidFrames3Member_OnShow(self)


	if IRF3.db then
		self:SetScript("OnEvent", InvenRaidFrames3Member_OnEvent)
		if not self.ticker then--거리 체크함수는 주기 0.2초
			self.ticker = C_Timer.NewTicker(0.2, function() InvenRaidFrames3Member_OnUpdate(self) end) --전역 타이머 설정
		end

		if not self.ticker2 then --거리에 무관하게 수행되는것은 주기1초
			self.ticker2 = C_Timer.NewTicker(1, function() InvenRaidFrames3Member_OnUpdate2(self) end) --전역 타이머2 설정
		end



		self:GetParent().visible = self:GetParent().visible + 1
		InvenRaidFrames3Member_UpdateAll(self)
		
 
		if isPetGroup(self)   then

			if IRF3.db.border  then
--				self:GetParent().border:SetAlpha(1)
				self:GetParent().border:SetAlpha(IRF3.db.borderBackdropBorder[4] or 1)
			else
				self:GetParent().border:SetAlpha(0)			


			end

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

		if self.ticker2 then  -- 레이드 프레임이 보이지 않을 때 타이머 변수 삭제2
			self.ticker2:Cancel()
			self.ticker2 = nil
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
--		InvenRaidFrames3Member_OnDragStop(self)


		if isPetGroup(self) then
			self:GetParent().border:SetAlpha(self:GetParent().visible > 0 and self:GetParent().border:SetAlpha(IRF3.db.borderBackdropBorder[4] or 1) or 0)
		else
			IRF3:BorderUpdate()
		end



		table.wipe(self.nameTable)
		self.lostHealth, self.overAbsorb, self.hasAggro, self.isOffline, self.isAFK, self.color, self.class = 0, 0, nil, nil, nil, nil


--[[
visible members loop감소 테스트
1)unitid배정시 visibleMembersByGUID에 guid-frame mapping추가
vmbyGUID[guid][1]=frame
vmbyGUID[guid][2]=frame

2)onhide시 해당 guid의 프레임정보 제거
]]--
		if self.unitGUID then 


			if string.find(self:GetName(),"Tank") then 
--				print(self:GetName(),self.unit,"removed") 
				--Tank frame이면
				IRF3.visibleMembersTankByGUID[self.unitGUID]=nil  
			else  --일반 멤버면
--				print("member",self.unit,"tank removed") 
				IRF3.visibleMembersByGUID[self.unitGUID]=nil   
			end

		end

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


function InvenRaidFrames3MemberTag_OnEnter(self)
if not IRF3.db.shiftmove then return end
--if IsShiftKeyDown() then print(self.tex,self.subgroup)  end

	if IsShiftKeyDown() then memberparty = self.subgroup end
end

function InvenRaidFrames3MemberTag_OnLeave(self)
	memberparty = 0
--print(memberparty)
end

function InvenRaidFrames3Member_OnEnter(self)


if IRF3.db.shiftmove and IsShiftKeyDown() and self  and self.unit then   memberindexto = UnitInRaid(self.unit) or 0 end
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
	self.mouseoverEnter = true --OnUpdate대신 복합조건으로 MOUSEOVER_UPDATE이벤트에서 감지
end

function InvenRaidFrames3Member_OnLeave(self)
	IRF3.onEnter = nil
	self.highlight:Hide()

	GameTooltip:Hide()
	self.mouseoverEnter = false--OnUpdate대신 복합조건으로 MOUSEOVER_UPDATE이벤트에서 감지
 
end

function InvenRaidFrames3Member_OnDragStart(self)
if IRF3.db.shiftmove and IsShiftKeyDown() and self  and self.unit then  memberindexfrom = UnitInRaid(self.unit) or 0 end
--	if not self then return end
	if IRF3.db.lockAlt and IsAltKeyDown() or not IRF3.db.lock then


if IRF3.db.units.petframeautopos and InCombatLockdown() then 
	if (last_point_check_time or 0) < GetTime()-5 then
		IRF3:Message(L["프레임이동msg"])   
		last_point_check_time=GetTime()
	end

	return 
end


		IRF3.dragging = true
		if self and isTankGroup(self) and IRF3.db.enableTankFrame then 
			 
			IRF3.tankheaders:StartMoving()
			 

		elseif self and isPetGroup(self) or self:GetParent() == InvenRaidFrames3PreviewPet then
			if IRF3.db.units.petframeautopos  then
	
				point, relativeTo, relativePoint, xOfs, yOfs = IRF3.petHeader:GetPoint()
				IRF3.petHeader:StartMoving()
				point1, relativeTo1, relativePoint1, xOfs1, yOfs1 = IRF3.petHeader:GetPoint()
			else
	
				IRF3.petHeader:StartMoving()
			end
		else


			IRF3:StartMoving()
			IRF3.tankheaders:StartMoving()
			IRF3.petHeader:StartMoving()
		end
	end
end

function InvenRaidFrames3Member_OnDragStop(self)
--print(memberparty,memberindexfrom)
--시프트 공대원 이동일때
if IRF3.db.shiftmove then
	if InCombatLockdown()  then
		if memberparty ==0 and memberindexfrom>0 and memberindexto >0 then --shift드랍을 통한 공대원 이동일떄
			IRF3:Message(L["lime_layout_desc_09_4"])
		end
	else --전투중이 아닐때
		if IsShiftKeyDown() and self and self.unit and memberparty ==0 and memberindexfrom>0 and memberindexto >0 then 

			--같은 파티내 이동이면 안됨

			SwapRaidSubgroup(memberindexfrom,memberindexto) 
			memberindexfrom =0
			memberindexto= 0
		elseif memberparty>0 then --Tag지정을통한 파티추가인경우
			SetRaidSubgroup(memberindexfrom,memberparty)


		end
	end
end

 
--	if not self then return end

	if not IsAltKeyDown()  or IRF3.dragging then
		IRF3.dragging = false

		if  self and  isTankGroup(self) and IRF3.db.enableTankFrame then 
 
			IRF3.tankheaders:StopMovingOrSizing() 
 
		elseif self and isPetGroup(self) or (self and self:GetParent() == InvenRaidFrames3PreviewPet) then
 			if IRF3.db.units.petframeautopos  then
				point2, relativeTo2, relativePoint2, xOfs2, yOfs2 = IRF3.petHeader:GetPoint()

				IRF3.petHeader:StopMovingOrSizing()
				if self:GetParent() ~= InvenRaidFrames3PreviewPet and not InCombatLockdown() then
					IRF3.petHeader:ClearAllPoints()
					IRF3.petHeader:SetPoint(point,relativeTo,relativePoint,xOfs+((xOfs2 or 0)-(xOfs1 or 0)), yOfs +((yOfs2 or 0)-(yOfs1 or 0)))
				end
	
			else
				IRF3.petHeader:StopMovingOrSizing()

 	
			end
		else
			IRF3:StopMovingOrSizing()
			IRF3.petHeader:StopMovingOrSizing()
			IRF3.tankheaders:StopMovingOrSizing() 
		end

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
		if IRF3.db.units.outline and (IRF3.db.units.outline.type == 4 or IRF3.db.units.outline.type == 7) then

			InvenRaidFrames3Member_UpdateOutline(self)
		end


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
--icononly는 예측힐 아이콘 업데이트만을 처리하는 경우사용(주기적 업데이트시). 예측힐량은 UNIT_HEALTH로 처리됨
function InvenRaidFrames3Member_UpdateHealPrediction(self,icononly)

--classic에서 제외
--		self.overAbsorbGlow:Hide()
--		self.absorbPredictionBar:Hide()


	if IRF3.db.units.displayHealPrediction and not UnitIsDeadOrGhost(self.displayedUnit) then
		local myGUID = UnitGUID("player")
		local targetGUID = self.unitGUID

local allIncomingHeal,allOverTimeHeal,myIncomingHeal ,otherIncomingHeal ,myOverTimeHeal ,otherOverTimeHeal--,totalAbsorb ,totalPrediction  
 
----HealComm : HOT 구분

if IRF3.libCHC and IRF3.db.enableHealComm then

		allIncomingHeal = (IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.ALL_HEALS, nil, nil) or 0) * (IRF3.libCHC:GetHealModifier(targetGUID) or 1)
		allOverTimeHeal = (IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.OVERTIME_AND_BOMB_HEALS, nil, nil) or 0) * (IRF3.libCHC:GetHealModifier(targetGUID) or 1)
--libHealComm
--print(IRF3.isWOTLK)

		 myIncomingHeal = IRF3.libCHC:GetHealAmount(targetGUID, IRF3.libCHC.CASTED_HEALS, nil, myGUID) or 0 --my Direct
		 otherIncomingHeal = IRF3.libCHC:GetOthersHealAmount(targetGUID, IRF3.libCHC.CASTED_HEALS, nil) or 0 --other direct

 



--print(targetGUID,myIncomingHeal)
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
--		totalAbsorb = 0 --클래식에선 보호막 api없어서 막아둠
--		totalAbsorb = (self.PWSAbsorb or 0 )  + (self.ValanirAbsorb or 0)+ (self.DivineAegisAbsorb or 0)--신의권능 보호막 문양, 발아니르 감지, 신보

--print(totalAbsorb)
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
		

			if IRF3.db.units.healIcon and (myIncomingHeal or 0) > 0 then
				self.healIcon:SetVertexColor(IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3])
				self.healIcon:SetSize(IRF3.db.units.healIconSize, IRF3.db.units.healIconSize)
				self.healIcon:Show()
				self.healingtarget:Show()
			elseif IRF3.db.units.healIconOther and (otherIncomingHeal or 0)  > 0 then

				self.healIcon:SetVertexColor(IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3])
				self.healIcon:SetSize(IRF3.db.units.healIconSize, IRF3.db.units.healIconSize)
				self.healIcon:Show()
				self.healingtarget:Show()
			else --self.healIcon and self.healIcon:IsShown() then
				self.healIcon:SetSize(0.001, 0.001)
				self.healIcon:Hide()
				self.healingtarget:Hide()
			end
		end
 


--		

if icononly then  return  end --icononly가 true이면 아래 예측힐량 로직은 bypass


	self.myHealPredictionBar:Hide()
	self.myHoTPredictionBar:Hide()
	self.otherHealPredictionBar:Hide()
	self.otherHoTPredictionBar:Hide()


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
--totalAbsorb  =self.totalAbsorb  or 0

			if myIncomingHeal  > 0 then

				varvalue = min(maxhealth*2, health + myIncomingHeal)

				self.myHealPredictionBar:SetValue(varvalue)
				self.myHealPredictionBar:Show()

 
			end

 
 
 
			if otherIncomingHeal   > 0 then
	

				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal)
				self.otherHealPredictionBar:SetValue(varvalue)
				self.otherHealPredictionBar:Show()
 
			end


			if myOverTimeHeal  >0 then

				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal)

				self.myHoTPredictionBar:SetValue(varvalue)
				self.myHoTPredictionBar:Show()				
 
			end



			if otherOverTimeHeal  > 0 then
				varvalue = min(maxhealth*2, health + myIncomingHeal+otherIncomingHeal + myOverTimeHeal+otherOverTimeHeal)
				self.otherHoTPredictionBar:SetValue(varvalue)
				self.otherHoTPredictionBar:Show()
 
			end
 
	 			 

 
		end

	else--예측힐을 사용하지않거나 죽은 경우에는 다 hide
		if self.healIcon and self.healIcon:IsShown() then
			self.healIcon:SetSize(0.001, 0.001)
			self.healIcon:Hide()
			self.healingtarget:Hide()
		end

 
	end


if IRF3.db.units.displayHealPrediction and IRF3.db.units.useAbsorbInClassic then InvenRaidFrames3Member_UpdateHealPrediction_Absorb(self) end --보정로직수행필요

end


function InvenRaidFrames3Member_UpdateHealPrediction_Absorb(self)

local totalAbsorb
totalAbsorb= (self.PWSAbsorb or 0 )  + (self.ValanirAbsorb or 0)+ (self.DivineAegisAbsorb or 0)--신의권능 보호막 문양, 발아니르 감지, 신보
self.overAbsorb= totalAbsorb--(self.PWSAbsorb or 0 )  + (self.ValanirAbsorb or 0)+ (self.DivineAegisAbsorb or 0)--신의권능 보호막 문양, 발아니르 감지, 신보


	if IRF3.db.units.displayHealPrediction and not UnitIsDeadOrGhost(self.displayedUnit) then
		local myGUID = UnitGUID("player")
		local targetGUID = self.unitGUID

 

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

 
		if lost > 0 then


 
	 			if totalAbsorb  > 0 then
--lost가 있고 보호막이 있을 경우 
	 				varvalue = min(maxhealth, health + totalAbsorb)

	 				self.absorbPredictionBar:SetValue(varvalue)
	 				self.absorbPredictionBar:Show()
 

	 			else
--lost가 있고 보호막이 없을 경우
	 				self.absorbPredictionBar:Hide()
	 			end

				if IRF3.db.units.useAbsorbInClassic then
					if IRF3.db.units.AbsorbInClassictype ==2 then
			 			self.overAbsorbGlow:Hide()
						self.overAbsorbGlow:SetAlpha(0)
					elseif IRF3.db.units.AbsorbInClassictype ==3 then
						self.outlineAbsorb:Hide()
						self.outlineAbsorb:SetAlpha(0)
					end
				end



		else

  			if totalAbsorb > 0 then


				if IRF3.db.units.useAbsorbInClassic then
					if IRF3.db.units.AbsorbInClassictype ==2 then
						self.overAbsorbGlow:Show()
						self.overAbsorbGlow:SetAlpha(0.8)
					elseif IRF3.db.units.AbsorbInClassictype ==3 then
						self.outlineAbsorb:Show()
						self.outlineAbsorb:SetAlpha(1)
					end
				end


			else
				
				if IRF3.db.units.useAbsorbInClassic then
					if IRF3.db.units.AbsorbInClassictype ==2 then
						self.overAbsorbGlow:Hide()
						self.overAbsorbGlow:SetAlpha(0)
					elseif IRF3.db.units.AbsorbInClassictype ==3 then
						self.outlineAbsorb:Hide()
						self.outlineAbsorb:SetAlpha(0)
					end
				end

			end
			self.absorbPredictionBar:Hide() 
		end

	else--예측힐을 사용하지않거나 죽은 경우에는 다 hide

		self.absorbPredictionBar:Hide()
		
			if IRF3.db.units.useAbsorbInClassic then
				if IRF3.db.units.AbsorbInClassictype ==2 then
					self.overAbsorbGlow:Hide()
					self.overAbsorbGlow:SetAlpha(0)
				elseif IRF3.db.units.AbsorbInClassictype ==3 then
					self.outlineAbsorb:Hide()
					self.outlineAbsorb:SetAlpha(0)
				end
			end
	end
 

end



local colorR, colorG, colorB

function InvenRaidFrames3Member_UpdateState(self)
local ownerClass
if self.unit then

	_, self.class = UnitClass(self.displayedUnit)

	if UnitIsConnected(self.unit) then
		self.isOffline = nil

		if UnitIsGhost(self.displayedUnit) then
			self.isGhost = true
			self.PWSAbsorb ,self.ValanirAbsorb ,self.DivineAegisAbsorb =0,0,0
			self.overAbsorbGlow:Hide()
			self.outlineAbsorb:Hide()
			self.absorbPredictionBar:Hide()
			self.myHealPredictionBar:Hide()
			self.myHoTPredictionBar:Hide()
			self.otherHealPredictionBar:Hide()
			self.otherHoTPredictionBar:Hide()

		elseif UnitIsDead(self.displayedUnit) then
			self.isDead = true
			self.isGhost = false
			self.PWSAbsorb ,self.ValanirAbsorb ,self.DivineAegisAbsorb =0,0,0
			self.overAbsorbGlow:Hide()
			self.outlineAbsorb:Hide()
			self.absorbPredictionBar:Hide()
			self.myHealPredictionBar:Hide()
			self.myHoTPredictionBar:Hide()
			self.otherHealPredictionBar:Hide()
			self.otherHoTPredictionBar:Hide() 
		elseif UnitIsAFK(self.unit) then

			self.isAFK = true
		else
			self.isGhost, self.isOffline, self.isDead, self.isAFK = nil, nil, nil, nil
		end
 


		if self.isGhost or self.isDead then
			colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]

		elseif IRF3.db.units.useHarm and UnitCanAttack(self.displayedUnit, "player") then
			colorR, colorG, colorB = IRF3.db.colors.harm[1], IRF3.db.colors.harm[2], IRF3.db.colors.harm[3]
			--정배시에 흡수량 초기화

			self.PWSAbsorb =0 
			self.ValanirAbsorb =0
			self.DivineAegisAbsorb =0
		elseif self.dispelType and IRF3.db.colors[self.dispelType] and IRF3.db.units.useDispelColor then
			colorR, colorG, colorB = IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3]
		elseif self.displayedUnit:find("pet") then


			if self.petButton   then --displayedUnit이 pet일때(pet) + self.petButton이 있는것(player) = vehicle toggle인 플레이어란 뜻 ->탈것ui없는 캐릭은 누락됨 eg)파괴전차 보조석등
				colorR, colorG, colorB = IRF3.db.colors.vehicle[1], IRF3.db.colors.vehicle[2], IRF3.db.colors.vehicle[3]

			else

				_,ownerClass=UnitClass(getUnitPetOrOwner(self.unit))

				if ownerClass and IRF3.db.units.usePetClassColors then
					colorR, colorG, colorB = IRF3.db.colors[ownerClass][1], IRF3.db.colors[ownerClass][2], IRF3.db.colors[ownerClass][3]
				else
					colorR, colorG, colorB = IRF3.db.colors.pet[1], IRF3.db.colors.pet[2], IRF3.db.colors.pet[3]
				end
			end
		elseif UnitInVehicle(self.unit) then -->탈것ui없는 탈것일때 처리
			colorR, colorG, colorB = IRF3.db.colors.vehicle[1], IRF3.db.colors.vehicle[2], IRF3.db.colors.vehicle[3]
		elseif self.specialdebuff then

			colorR, colorG, colorB = IRF3.db.colors.specialdebuff[1], IRF3.db.colors.specialdebuff[2], IRF3.db.colors.specialdebuff[3]
		elseif IRF3.db.units.useClassColors and IRF3.db.colors[self.class] then

			colorR, colorG, colorB = IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3]

		else
			colorR, colorG, colorB = IRF3.db.colors.help[1], IRF3.db.colors.help[2], IRF3.db.colors.help[3]


		end


		self.powerBar:Show()--online시 show
 
	else

		self.isOffline, self.isGhost, self.isDead, self.isAFK = true, nil, nil, nil
		colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
		self.powerBar:Hide()--offline시 숨김

		if IRF3.db.units.useAbsorbInClassic then
			if IRF3.db.units.AbsorbInClassictype ==2 then
				self.overAbsorbGlow:Hide() --offline시 숨김
				self.overAbsorbGlow:SetAlpha(0)

			elseif IRF3.db.units.AbsorbInClassictype ==3 then
				self.outlineAbsorb:Hide()
				self.outlineAbsorb:SetAlpha(0)

			end
		end
--		InvenRaidFrames3Member_UpdateName(self) --losttext update


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

--	if IRF3.db.units.displayRaidRoleIcon and IRF3.db.units.displayClassicRaidRoleIcon then

	if IRF3.db.units.displayRaidRoleIcon  then

	 roleType = "NONE"
    
		if not IRF3.db.units.displayRaidRoleIcon2  then -- 파티찾기 역할 표기일 경우(개인이 지정한 탱/딜/힐). 이 옵션이 체크면 공격대에서 지정된 방어전담/지원전담
	        	roleType = UnitGroupRolesAssigned(self.unit) or "NONE"
			if IRF3.db.units.displayRaidRoleIconTank then --탱커만 표시
				if roleType ~="TANK" then roleType="NONE" end
			end
            
		else
			roleType= IRF3_UnitGroupRolesAssigned(self.unit) or "NONE"
		end


		--GetTexCoordsForRoleSmallCircle
   		if roleType ~= "NONE" then
  			if IRF3.db.units.roleIcontype == 1 then --블리자드 기본
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
     			self.roleIcon:SetPoint(IRF3.db.units.roleIconPos, self, IRF3.db.units.roleIconPos, 0, 0)
      			self.roleIcon:SetSize(IRF3.db.units.roleIconSize * 1.1, IRF3.db.units.roleIconSize * 1.5)

      			return self.roleIcon:Show()
 		   end
	end

	self.roleIcon:SetSize(0.001, 0.001)
	self.roleIcon:Hide()


end

local LeaderFlag
local SubLeaderFlag
function InvenRaidFrames3Member_UpdateLeaderIcon(self)

	if IRF3.db.units.useLeaderIcon then

		LeaderFlag = UnitIsGroupLeader(self.unit)

		if LeaderFlag then
		 	self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
			self.leaderIcon:SetTexCoord(0, 1, 0, 1)
			self.leaderIcon:SetSize(IRF3.db.units.leaderIconSize, IRF3.db.units.leaderIconSize)
		
			return self.leaderIcon:Show()
		end
		SubLeaderFlag = UnitIsGroupAssistant(self.unit)
		if SubLeaderFlag then
			self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
			self.leaderIcon:SetTexCoord(0, 1, 0, 1)
			self.leaderIcon:SetSize(IRF3.db.units.leaderIconSize, IRF3.db.units.leaderIconSize)
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

	if IRF3.db.units.useLeaderIcon then --공대장표시 옵션 그대로 사용
 
		if loot == true  then

			self.looterIcon:SetTexCoord(0, 1, 0, 1)
			self.looterIcon:SetSize(IRF3.db.units.leaderIconSize, IRF3.db.units.leaderIconSize)
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
	if IRF3.db.units.centerStatusIcon and self.unit and UnitInOtherParty(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\LFGFrame\\LFG-Eye")
		self.centerStatusIcon.texture:SetTexCoord(0.125, 0.25, 0.25, 0.5)
		self.centerStatusIcon.border:SetTexture("Interface\\Common\\RingBorder")
		self.centerStatusIcon.border:Show()
		self.centerStatusIcon.tooltip = PARTY_IN_PUBLIC_GROUP_MESSAGE
		self.centerStatusIcon:Show()
	elseif IRF3.db.units.centerStatusIcon and UnitHasIncomingResurrection(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez")
		self.centerStatusIcon.texture:SetTexCoord(0, 1, 0, 1)
		self.centerStatusIcon.border:Hide()
		self.centerStatusIcon.tooltip = nil
		self.centerStatusIcon:Show()
		self.resurrectStart = GetTime() * 1000
	elseif IRF3.db.units.centerStatusIcon and self.inDistance and not UnitInPhase(self.unit) then

		self.centerStatusIcon.texture:SetTexture("Interface\\TargetingFrame\\UI-PhasingIcon")
		self.centerStatusIcon.texture:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
		self.centerStatusIcon.border:Hide()
		self.centerStatusIcon.tooltip = PARTY_PHASED_MESSAGE
		self.centerStatusIcon:Show()
	else

		self.centerStatusIcon:Hide()
	end
	if IRF3.db.units.useResurrectionBar then
		InvenRaidFrames3Member_UpdateResurrection(self)
	end
end

local tooltipUpdate = 0
function InvenRaidFrames3Member_CenterStatusIconOnUpdate(self, elapsed)

	if not IRF3.tootipState then return end
	tooltipUpdate = tooltipUpdate + elapsed
	if tooltipUpdate > 0.2 then
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

if IRF3.db.units.outline then
	 


 


	if IRF3.db.units.outline.type == 1 then
		if self.dispelType and IRF3.db.colors[self.dispelType] then
			self.outline:SetBackdropBorderColor(IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3])
			return self.outline:Show()
		end
	elseif IRF3.db.units.outline.type == 2 then
		if UnitIsUnit(self.displayedUnit, "target") then
			return self.outline:Show()
		end
	elseif IRF3.db.units.outline.type == 3 then

		if UnitIsUnit(self.displayedUnit, "mouseover") and self.mouseoverEnter then
			return self.outline:Show()
		else
			 
			return self.outline:Hide()
		end
	elseif IRF3.db.units.outline.type == 4 then

		if not UnitIsDeadOrGhost(self.displayedUnit) and (self.health / self.maxHealth) <= IRF3.db.units.outline.lowHealth then
			return self.outline:Show()
		end
	elseif IRF3.db.units.outline.type == 5 then
		if self.hasAggro then
			return self.outline:Show()
		end
	elseif IRF3.db.units.outline.type == 6 then
		if IRF3.db.units.outline.raidIcon[GetRaidTargetIndex(self.displayedUnit)] then
			return self.outline:Show()
		end
	elseif IRF3.db.units.outline.type == 7 then
		if not UnitIsDeadOrGhost(self.displayedUnit) and self.maxHealth >= IRF3.db.units.outline.lowHealth2 and self.health < IRF3.db.units.outline.lowHealth2 then
			return self.outline:Show()
		end
 
	end



	end

	self.outline:Hide()
 
 
end
 



--- 타이머에서 지속적으로 체크하는 거리 측정 함수-0.2초 단위
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

	if self.outRange then

		self:SetAlpha(IRF3.db.units.fadeOutOfRangeHealth and IRF3.db.units.fadeOutAlpha or 1)

		if not IRF3.db.units.outRangeName2 then --이름표에도 투명도 적용옵션체크.기본값(false)면 이름은 항상 표기
			self.name:SetAlpha(1)
		else
			self.name:SetAlpha(IRF3.db.units.fadeOutOfRangeHealth and IRF3.db.units.fadeOutAlpha or 1)
		end

	--시야밖으로 나가면 잔여 보막이 어떻게 변하는지 알수없기 때문에 초기화
		if IRF3.db.units.displayHealPrediction and IRF3.db.units.useAbsorbInClassic then
			self.PWSAbsorb =0 
			self.ValanirAbsorb =0
			self.DivineAegisAbsorb =0
			self.overAbsorb= (self.PWSAbsorb or 0 )  + (self.ValanirAbsorb or 0)+ (self.DivineAegisAbsorb or 0)--신의권능 보호막 문양, 발아니르 감지, 신보

			if IRF3.db.units.AbsorbInClassictype ==2 then
				self.overAbsorbGlow:Hide()
				self.overAbsorbGlow:SetAlpha(0)
				InvenRaidFrames3Member_UpdateDisplayText(self) --losttext update
			elseif IRF3.db.units.AbsorbInClassictype ==3 then
				self.outlineAbsorb:Hide()
				self.outlineAbsorb:SetAlpha(0)
				InvenRaidFrames3Member_UpdateDisplayText(self) --losttext update


			end



		end
	else
	 
		self:SetAlpha(1)
--		self.healthBar:SetAlpha(0.6)
--		self.powerBar:SetAlpha(1)



		if  IRF3.db.units.outRangeName2  then --이름표에도 투명도 적용옵션체크.도중에 옵션이 변경되어을 수 있으므로
			self.name:SetAlpha(1)
		
		end


	--prediction은 healcomm event에서 처리하지만, updatehealth자체가 발생하지 않는 경우(풀피일때) heal icon이 제대로 반영되지 않은 경우가 있음. 
	--따라서 주기적인 healpredictoin은 처리(icononly=true로 수행)

		if IRF3.db.units.displayHealPrediction then
--			self.myHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--			self.myHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--			self.otherHealPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--			self.otherHoTPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)
--			self.absorbPredictionBar:SetAlpha(IRF3.db.units.healPredictionAlpha)

 
		end




	end

 

end

end

--- 타이머에서 지속적으로 체크하는 함수(거리에 무관)-1초 단위
function InvenRaidFrames3Member_OnUpdate2(self)


	--거리 측정과 상관없이 타이머에서 지속적으로 갱신할 것들 (많이 추가하면 CPU 점유율 급증할 위험 있음)


--[[
	if self.displayedUnit:find("pet") then
 		InvenRaidFrames3Member_UpdatePetHealth(self) --소환수 잦은 소환/종료시 pet 목록이 바뀌면서 체력꼬임.오히려 팻만 주기적으로 업데이트->UNIT_PET으로 이동
	end
]]--

	InvenRaidFrames3Member_UpdateState(self)
--	InvenRaidFrames3Member_UpdateDisplayText(self) 
 	InvenRaidFrames3Member_UpdateRaidIconTarget(self)



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
--
			InvenRaidFrames3Member_UpdateLeaderIcon(self)
			InvenRaidFrames3Member_UpdateLooterIcon(self)
			InvenRaidFrames3Member_UpdateRaidIcon(self)
			InvenRaidFrames3Member_UpdateBuffs(self)
			InvenRaidFrames3Member_UpdateAura(self)
			InvenRaidFrames3Member_UpdateSpellTimer(self)
			InvenRaidFrames3Member_UpdateSurvivalSkill(self)
			InvenRaidFrames3Member_UpdateOutline(self)
			InvenRaidFrames3Member_OnUpdate(self)
			InvenRaidFrames3Member_OnUpdate2(self)
			InvenRaidFrames3Member_UpdateRoleIcon(self)
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
	

	self.unitGUID=UnitGUID(self.unit)

--[[
visible members loop감소 테스트
1)unitid배정시 visibleMembersByGUID에 guid-frame mapping추가
vmbyGUID[guid][1]=frame
vmbyGUID[guid][2]=frame

2)onhide시 해당 guid의 프레임정보 제거
]]--
if self.unitGUID then
	if string.find(self:GetName(),"Tank") then 

		--Tank frame이면
		IRF3.visibleMembersTankByGUID[self.unitGUID] = self
	else  --일반 멤버면

		IRF3.visibleMembersByGUID[self.unitGUID] = self
	end
end


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

eventHandler.PLAYER_ENTERING_WORLD =  function(self,unit)

	IRF3:BuildSpellTimerList()	
	InvenRaidFrames3Member_UpdateAll(self)


	IRF3:AutoProfileReload()

--	IRF3:ToggleManager()--기본 레이드프레임 표기여부 수행(IRF를 사용안함일때)
	InvenRaidFrames3Member_Sort()--최초접속시 sort 지정

	if IRF3.db.units.displayHealPrediction and IRF3.db.units.useAbsorbInClassic then
		self.PWSAbsorb =0 
		self.ValanirAbsorb =0
		self.DivineAegisAbsorb =0
	end


end


 

--eventHandler.GROUP_ROSTER_UPDATE =  InvenRaidFrames3Member_UpdateAll 


function InvenRaidFrames3_ClearHealIcon()

					for member in pairs(IRF3.visibleMembers) do

						if member.healIcon:IsShown() then 
							member.healIcon:Hide()
						end
					end

end

function InvenRaidFrames3Member_Sort()



--공격대거나, 플레이어 정렬을 사용안함이면 skip
	if InCombatLockdown() then 
		IRF3.delayedAction=true --예약만 걸어둠. 전투끝나면 Core에 기술된 IRF3:dealyedFunc에 의해 수행
		return 
	end
	local inArena
inArena,_=IsActiveBattlefieldArena()

 

--print("A",UnitInRaid("player"),inArena)

	if (UnitInRaid("player") and not inArena) or IRF3.db.units.sortplayer==1 or IRF3.db.units.sortplayer==L["플레이어위치1"] then  --파티/투기장이 아닐거나 지정안함이면 원복
--			IRF3.headers[0]:SetAttribute("sortMethod","INDEX")
--			IRF3.headers[0]:SetAttribute("nameList",nil)
--			IRF3.headers[1]:SetAttribute("sortMethod","INDEX")
--			IRF3.headers[1]:SetAttribute("nameList",nil)
		return  --일반 레이드에서는 제외
	end

	--always bottom이면
	local nameList=""
	local unitName =""
	local playerName 



	playerName , _ =UnitName("player")
 

		 	for i=1,4 do

				unitName=GetUnitName("party"..i,true)
				if unitName then
					if #nameList==0 then
						nameList = unitName
					else
						nameList=nameList ..","..unitName
					end
				end

			end

			if #nameList==0 then return end

			if IRF3.db.units.sortplayer==2 or IRF3.db.units.sortplayer==L["플레이어위치2"] then --always top
				nameList= playerName  ..","..nameList
--				print("2",nameList)
				
			elseif  IRF3.db.units.sortplayer==3 or IRF3.db.units.sortplayer==L["플레이어위치3"] then --always bottom
--				nameList=strsub(nameList ..","..playerName,nameList:find(",")+1)
				nameList = nameList ..","..playerName

--				print("3",nameList)
				
			else

			end

	local inArena,_=IsActiveBattlefieldArena()
	if inArena then --0과 1 header에 모두 namelist지정하면 공격대/파티 변경시 group_roster_update unit이 꼬임
			IRF3.headers[1]:SetAttribute("groupBy", nil)
			IRF3.headers[1]:SetAttribute("groupFilter", nil)
			IRF3.headers[1]:SetAttribute("groupingOrder", nil)
			IRF3.headers[1]:SetAttribute("sortMethod","NAMELIST")
			IRF3.headers[1]:SetAttribute("nameList",nameList)
	else

			IRF3.headers[0]:SetAttribute("groupBy", nil)
			IRF3.headers[0]:SetAttribute("groupFilter", nil)
			IRF3.headers[0]:SetAttribute("groupingOrder", nil)
			IRF3.headers[0]:SetAttribute("sortMethod","NAMELIST")
			IRF3.headers[0]:SetAttribute("nameList",nameList)
	end

end



function IRF3:MemberSelect_Adjust()--raidonly

 
---순차보호막을 사용하는 경우, 방어전담은 제외(시작)

--1.예외 unitid작성 (비전투중,공대,순치보호막일때만)
if InCombatLockdown("player") then return end
local exception_unit,exception_unit_melee ="",""
if   UnitInRaid("player")   then
 

		if (InvenRaidFrames3CharDB.memberselect_except  or 0 )>0 then --예외조건(방어전담 포함/예외)일 경우


		
		for _, header in pairs(IRF3.headers) do
			for _, member in pairs(header.members) do
			

				if member.unit and UnitInRaid(member.unit) then
					name, rank, subgroup, level, class, fileName, zone, online, isDead, role, loot = GetRaidRosterInfo(UnitInRaid(member.unit));
					if role == "MAINTANK" then

						exception_unit= exception_unit ..member.unit..","
					end
 
					if class==GetClassInfo(3) or class==GetClassInfo(5) or class==GetClassInfo(7) or class==GetClassInfo(8) or class==GetClassInfo(9) or class==GetClassInfo(2) or class==GetClassInfo(11)  then --사냥꾼,사제,주술사,마법사,흑마법사,기사,드루도 제외
						exception_unit_melee= exception_unit_melee ..member.unit..","--제외할 유닛
					end
				end
			end
		end

		else
			exceptionUnit=""
		end

 
		IRF3RaidTarget:SetAttribute("exceptionUnit",exception_unit)
		IRF3RaidTarget:SetAttribute("exceptionType",InvenRaidFrames3CharDB.memberselect_except)

		IRF3RaidTargetMelee:SetAttribute("exceptionUnit",exception_unit)
		IRF3RaidTargetMelee:SetAttribute("exceptionUnit2",exception_unit_melee)
		IRF3RaidTargetMelee:SetAttribute("exceptionType",InvenRaidFrames3CharDB.memberselect_except)

	

end

 
local spelltocast =""
if InvenRaidFrames3CharDB.memberselect ==2 then spelltocast = SL(17) elseif InvenRaidFrames3CharDB.memberselect==3 then spelltocast = SL(139) elseif InvenRaidFrames3CharDB.memberselect==4 then spelltocast =SL(774) elseif InvenRaidFrames3CharDB.memberselect==5 then spelltocast = SL(33763) end
 
	IRF3PartyTarget:SetAttribute("spell",spelltocast ) --2:보호막 3:소생 4:회복 : 5피생
	IRF3RaidTarget:SetAttribute("spell",spelltocast ) --2:보호막 3:소생 4:회복 : 5피생
	IRF3RaidTargetMelee:SetAttribute("spell",spelltocast ) --2:보호막 3:소생 4:회복 : 5피생
 
if UnitInRaid("player") then --raid
---Handler 재생성(예외처리 추가)
		SecureHandlerUnwrapScript(IRF3RaidTarget,"OnClick")
		SecureHandlerWrapScript(IRF3RaidTarget,"OnClick",IRF3RaidTarget,[[

			local maxUnits = self:GetAttribute("maxUnits") -- 5 for arena, 5 for party, 40 for raid
			local unitType = self:GetAttribute("unitType")
			local index = self:GetAttribute("unitIndex") -- number 0-X of last seen unit
			local direction = button=="RightButton" and 1 or -1
			local delimiter = ","
			local exceptions1,exceptions2,exceptions3,exceptions4, exceptions5 --배열생성못해서 최대5명으로 가정
			exceptions1, exceptions2, exceptions3, exceptions4, exceptions5= delimiter:split(self:GetAttribute("exceptionUnit") or "")
			exceptions1, exceptions2, exceptions3, exceptions4, exceptions5 = exceptions1 or "", exceptions2 or "", exceptions3 or "", exceptions4 or "", exceptions5 or ""
			local exceptionType = self:GetAttribute("exceptionType")


			for i=1,maxUnits do
				if maxUnits ==40  then --raid면	
					index = (index+direction)%40
				else
					index = (index+direction)%5 --파티/투기장은 최대5명
				end

				local unit = unitType..index+1

				if unit=="party5" then

					unit = "player" -- for party targeting, 5th unit is player
				end


				if UnitExists(unit) and ( (exceptionType==1 and unit~=exceptions1 and unit~=exceptions2 and unit~=exceptions3 and unit~=exceptions4 and unit~=exceptions5 ) or  (exceptionType ==2 and (unit==exceptions1 or unit==exceptions2 or  unit==exceptions3 or unit==exceptions4 or unit==exceptions5) ) or (exceptionType==0) ) then
 
					self:SetAttribute("unitIndex",index)
					self:SetAttribute("unit",unit)
					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] " ..(self:GetAttribute("spell") or ""))
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 신의 권능: 보호막")
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 소생(1 레벨)")
--when spell is not reachable - out of sight, range but spell itself is available - it is counted.

 
					return
				 

				end
			end

			self:SetAttribute("unit",nil) -- if no unit, don't target
		]])



---Handler 재생성(예외처리 추가) --공대 밀리 프레임
		SecureHandlerUnwrapScript(IRF3RaidTargetMelee,"OnClick")

		SecureHandlerWrapScript(IRF3RaidTargetMelee,"OnClick",IRF3RaidTargetMelee,[[

			local maxUnits = self:GetAttribute("maxUnits") -- 5 for arena, 5 for party, 40 for raid
			local unitType = self:GetAttribute("unitType")
			local index = self:GetAttribute("unitIndex") -- number 0-X of last seen unit
			local direction = button=="RightButton" and 1 or -1
			local delimiter = ","
			local exceptions1,exceptions2,exceptions3,exceptions4, exceptions5 --배열생성못해서 최대5명으로 가정
			exceptions1, exceptions2, exceptions3, exceptions4, exceptions5= delimiter:split(self:GetAttribute("exceptionUnit") or "")
			exceptions1, exceptions2, exceptions3, exceptions4, exceptions5 = exceptions1 or "", exceptions2 or "", exceptions3 or "", exceptions4 or "", exceptions5 or ""
			exceptions2_1, exceptions2_2, exceptions2_3, exceptions2_4, exceptions2_5, exceptions2_6, exceptions2_7, exceptions2_8, exceptions2_9, exceptions2_10,exceptions2_11, exceptions2_12, exceptions2_13, exceptions2_14, exceptions2_15 = delimiter:split(self:GetAttribute("exceptionUnit2") or "")--range는 최대 15명으로 가정

			local exceptionType = self:GetAttribute("exceptionType")


			for i=1,maxUnits do
				if maxUnits ==40  then --raid면	
					index = (index+direction)%40
				else
					index = (index+direction)%5 --파티/투기장은 최대5명
				end

				local unit = unitType..index+1

				if unit=="party5" then

					unit = "player" -- for party targeting, 5th unit is player
				end


				if UnitExists(unit) and  (unit~=exceptions2_1 and unit~=exceptions2_2 and unit~=exceptions2_3 and unit~=exceptions2_4 and unit~=exceptions2_5 and unit~=exceptions2_6 and unit~=exceptions2_7 and unit~=exceptions2_8 and unit~=exceptions2_9 and unit~=exceptions2_10 and unit~=exceptions2_11 and unit~=exceptions2_12 and unit~=exceptions2_13 and unit~=exceptions2_14 and unit~=exceptions2_15) then

					self:SetAttribute("unitIndex",index)
					self:SetAttribute("unit",unit)
					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] " ..(self:GetAttribute("spell") or ""))
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 신의 권능: 보호막")
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 소생(1 레벨)")
--when spell is not reachable - out of sight, range but spell itself is available - it is counted.


					return
				 

				end
			end

			self:SetAttribute("unit",nil) -- if no unit, don't target
		]])





---순차보호막을 사용하는 경우, 방어전담은 제외(끝)

else --파티일때

---Handler 재생성(예외처리 추가)
		SecureHandlerUnwrapScript(IRF3PartyTarget,"OnClick")
		SecureHandlerWrapScript(IRF3PartyTarget,"OnClick",IRF3RaidTarget,[[

			local maxUnits = self:GetAttribute("maxUnits") -- 5 for arena, 5 for party, 40 for raid
			local unitType = self:GetAttribute("unitType")
			local index = self:GetAttribute("unitIndex") -- number 0-X of last seen unit
			local direction = button=="RightButton" and 1 or -1
			local delimiter = ","
 



			for i=1,maxUnits do
				if maxUnits ==40  then --raid면	
					index = (index+direction)%40
				else
					index = (index+direction)%5 --파티/투기장은 최대5명
				end

				local unit = unitType..index+1

				if unit=="party5" then

					unit = "player" -- for party targeting, 5th unit is player
				end

				if UnitExists(unit)    then

					self:SetAttribute("unitIndex",index)
					self:SetAttribute("unit",unit)
 
					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] " ..(self:GetAttribute("spell") or ""))
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 신의 권능: 보호막")
--					self:SetAttribute("macrotext", "/stopcasting\n/cast [@"..unit..",nodead] 소생(1 레벨)")


					return
				 

				end
			end
			self:SetAttribute("unit",nil) -- if no unit, don't target
		]])


 
---순차보호막을 사용하는 경우, 방어전담은 제외(끝)
 

end
 

end



eventHandler.GROUP_ROSTER_UPDATE =  function(self,unit)

--특이사항 : 공격대->파티전환시 파티멤버 unit이 꼬여서 전달되는 경우있음(eg:player2번, party1누락)->sort때문이네??->파티(sort적용)->공격대(sort풀림)->파티(sort미적용으로 인해 발생)


	InvenRaidFrames3Member_UpdateAll(self)
	IRF3:AutoProfileReload()
--	IRF3:ToggleManager()
--member sort script
	InvenRaidFrames3Member_Sort()
--	local inArena,_=IsActiveBattlefieldArena()
--	if inArena then
	--투기장 또는 공대/파티전환시 roster_update와의 딜레이가 있어 즉시 적용이 안됨. 1.5초 간격으로 사후 보정
		C_Timer.After(1.5,InvenRaidFrames3Member_Sort) -- adjustment for delay in western realms
		C_Timer.After(3,InvenRaidFrames3Member_Sort)-- adjustment for delay in western realms
--	end

	IRF3.AuraMasteryGUID={}--오라숙련 사용자 초기화
	IRF3.AuraMasteryTargetGUID={}--오라숙련 사용자 초기화
	IRF3.AuraMasteryTargetGUIDAura={}--오라숙련 사용자 초기화

	if InvenRaidFrames3CharDB.memberselect>1 then
		IRF3:MemberSelect_Adjust() --순차멤버 로직 보정
	end


end
 
eventHandler.PLAYER_ROLES_ASSIGNED = InvenRaidFrames3Member_UpdateRoleIcon
eventHandler.PARTY_LEADER_CHANGED = InvenRaidFrames3Member_UpdateLeaderIcon
eventHandler.PARTY_LOOT_METHOD_CHANGED = InvenRaidFrames3Member_UpdateLooterIcon




eventHandler.RAID_TARGET_UPDATE = function(self)
	InvenRaidFrames3Member_UpdateRaidIcon(self)


	if IRF3.db.units.outline and IRF3.db.units.outline.type == 6 then
		InvenRaidFrames3Member_UpdateOutline(self)
	end


end
eventHandler.UNIT_NAME_UPDATE = function(self, unit)

	if (unit == self.unit or unit == self.displayedUnit) then
		InvenRaidFrames3Member_UpdateName(self)
		InvenRaidFrames3Member_UpdateNameColor(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
	end
	InvenRaidFrames3Member_Sort()--unknown에서 업데이트시
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
		if IRF3.db.units.outline and (IRF3.db.units.outline.type == 4 or IRF3.db.units.outline.type == 7) then
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

	local interval = 2
	if unit == self.displayedUnit then


			--성능최적화를 위해 interval(2초)단위로 실행
			if not self.last_power_update_time or self.last_power_update_time <GetTime()-interval then

				if powerType == "ALTERNATE" then
					InvenRaidFrames3Member_UpdatePowerBarAlt(self)
				else
					InvenRaidFrames3Member_UpdatePower(self)
				end
--				print("executed",self.last_power_update_time)
				self.last_power_update_time = GetTime()
--			else
--				print("skipped",GetTime())
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
--		InvenRaidFrames3Member_UpdateHealPrediction(self)
	end
end
eventHandler.UNIT_ABSORB_AMOUNT_CHANGED = eventHandler.UNIT_HEAL_PREDICTION

--eventHandler.UNIT_AURA = function(self, unit)
eventHandler.UNIT_AURA = function(self, unit)
local spellName=""
--isFullUpdate added in 9.2.0 and removed again in 10.0.0. Not added in classic...
local interval = 1


	if (unit == self.unit or unit == self.displayedUnit ) then

		--오숙체크
		if self.class=="PALADIN" and IRF3.db.units.useSurvivalSkill then


			--생존기 아이콘 표기가 선택되어 있고, 오라 숙련이 체크된 경우
			if IRF3.db.units.showSurvivalAsSpellTimer and IRF3.db.units.showSurvivalAsSpellIcon[10] then
				local name, icon, count, _, duration, expirationTime, unitCaster, _, _, spellId = AuraUtil.FindAuraByName(SL(31821),self.unit) --오라숙련
				if name then
					IRF3.AuraMasteryGUID[self.unitGUID] = {true,icon,duration,expirationTime}
--					print("duration",duration)
--					print(IRF3.AuraMasteryGUID[self.unitGUID][3],IRF3.AuraMasteryGUID[self.unitGUID][4])
	--print("오라숙련 켜짐",self.unit)

				elseif IRF3.AuraMasteryGUID[self.unitGUID] and IRF3.AuraMasteryGUID[self.unitGUID][1]  then--오라숙련이 있었으면

					IRF3.AuraMasteryGUID[self.unitGUID] ={false,nil,nil,nil}
--				print(self.unit,IRF3.AuraMasteryGUID[self.unitGUID],"unregistered")
				--있던 오라숙련이 꺼지면, 다른 공대원들 다시 업데이트해줘야함.
				--print("오라숙련 꺼짐",self.unit)
				--print("오라숙련 대상자 초기화",self.unit,"-->")

				--추가 부하로직.해당 오라숙련을 받던 다른 공대원들의 주문타이머를 재갱신해야함(오라숙련은 별도 버프가 없음)
					for member in pairs(IRF3.visibleMembers) do
--print( IRF3.AuraMasteryTargetGUID[member.unitGUID], self.unitGUID)
							if IRF3.AuraMasteryTargetGUID[member.unitGUID] and IRF3.AuraMasteryTargetGUID[member.unitGUID]== self.unitGUID and member.unitGUID~=self.unitGUID then --대상목록에 있으면(단 ,시전자는 제외)
--							print("-->>",member.unit,IRF3.AuraMasteryTargetGUID[member.unitGUID],self.unitGUID)
--print("target 해제",member.unit)

											


--							InvenRaidFrames3Member_UpdateSpellTimer(member) --해당 대상 주문타이머 갱신(오라숙련 만료되면 표시지우기위해)
--							IRF3.AuraMasteryTargetGUID[member.unitGUID]=nil
--							IRF3.AuraMasteryTargetGUIDAura[member.unitGUID]=nil

							if member.AuraMasteryFrame then 
								setIcon(member.AuraMasteryFrame, 18) --remove용도
							member.AuraMasteryFrame = nil --초기화
							end
						end
					end
				end
			end
		end




		InvenRaidFrames3Member_UpdateSpellTimer(self) --survival spell과 spelltimer 통합(Unit_AURA당 한번만 처리하기위해)

--		if IRF3.db.units.useSurvivalSkill then 	InvenRaidFrames3Member_UpdateSurvivalSkill(self) end--이 소스는 이제 안씀

		InvenRaidFrames3Member_UpdateAura(self)

 		--버프체크 로직
		if IRF3.db.enableClassBuff then
			--성능최적화를 위해 interval(1)초단위로 실행하되, 누락을 없애기위해 단순스킵이 아니라 1초 후로 delay실행
			if (not self.unit_aura_planned_time or (self.unit_aura_planned_time or 0 )>GetTime() ) and  (self.last_executed_time or 0) < GetTime()-interval then
				InvenRaidFrames3Member_UpdateBuffs(self)
				self.last_executed_time=GetTime()
--				print("즉시실행됨",self.last_executed_time)
			elseif self.unit_aura_planned_time  then
--				print(self.unit_aura_planned_time,"이미 예약되어 skip")
			elseif self.last_executed_time >= GetTime()-interval and not self.unit_aura_planned_time then --예약은 하되 이미 예약된 건이 있으면 skip
--				self.unit_aura_planned_time= GetTime()+GetTime()+interval -self.last_executed_time
				self.unit_aura_planned_time= self.last_executed_time+interval
--	 			print("예약됨",self.unit_aura_planned_time-GetTime())

				C_Timer.After(self.unit_aura_planned_time-GetTime(), function()
					    	InvenRaidFrames3Member_UpdateBuffs(self)
						self.last_executed_time=GetTime()
--							print(">>>예약실행됨",GetTime())
						self.unit_aura_planned_time=nil

						



				end)
			else
--				print("skipped")	
			end
		end



		if IRF3.db.units.outline and IRF3.db.units.outline.type == 1 then
			InvenRaidFrames3Member_UpdateOutline(self)
		end
		if IRF3.db.units.useDispelColor then
			InvenRaidFrames3Member_UpdateState(self)
		end
	end

--[[
if IRF3.db.units.displayHealPrediction and IRF3.db.units.useAbsorbInClassic then --흡수량사용이면 발아니르 체크
--print(self.class)-
	if self.class =="PALADIN" or self.class=="SHAMAN" or self.class=="PRIEST" or self.class=="DRUID" then
	spellName ,_ =  GetSpellInfo(64411)
	if AuraUtil.FindAuraByName(spellName,self.displayedUnit) then
		IRF3.ValanirGUID[self.unitGUID] = true --발아니르 버프(고대왕의 축복)가 생기면 등록

	elseif IRF3.ValanirGUID[self.unitGUID] then
		IRF3.ValanirGUID[self.unitGUID]=false --발아니르 버프(고대왕의 축복)가 사라지면 등록해제
	end
	end


	

end
--]]

end
 

eventHandler.UNIT_THREAT_SITUATION_UPDATE = function(self,unit)

	if unit == self.displayedUnit then
		InvenRaidFrames3Member_UpdateThreat(self)
		InvenRaidFrames3Member_UpdateDisplayText(self)
		if IRF3.db.units.outline and IRF3.db.units.outline.type == 5 then
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

	if IRF3.db.units.displayHealPrediction and IRF3.db.units.useAbsorbInClassic then

		self.PWSAbsorb =0 
		self.ValanirAbsorb =0
		self.DivineAegisAbsorb =0
		
	end


end

eventHandler.UNIT_ENTERING_VEHICLE = eventHandler.UNIT_ENTERED_VEHICLE


eventHandler.UNIT_EXITED_VEHICLE = function(self, unit)
	if unit == self.unit then
		InvenRaidFrames3Member_UpdateAll(self)
		C_Timer.After(0.1, function()
			if self.unit and self.unitGUID then
				InvenRaidFrames3Member_UpdateHealth(self)
				InvenRaidFrames3Member_UpdateLostHealth(self)
			end
		end)
	end
	InvenRaidFrames3Member_OnDragStop(IRF3.petHeader)--이벤트호출시 강제 보정

end
 eventHandler.UNIT_EXITING_VEHICLE=eventHandler.UNIT_EXITED_VEHICLE
--eventHandler.UNIT_PET = eventHandler.UNIT_ENTERED_VEHICLE

eventHandler.UNIT_PET = function(self, unit) --owner의 unit이 리턴됨

 if self.displayedUnit and self.displayedUnit:find("pet") then

		InvenRaidFrames3Member_UpdateAll(self)

 end

end



eventHandler.UNIT_SPELLCAST_START = function(self, unit, castGUID, spellID)

	if IRF3.db.units.useCastingBar and unit == self.displayedUnit then -- 클래식은 자신의 정보만 있음
		InvenRaidFrames3Member_UpdateCastingBar(self,spellID)
	end
end
eventHandler.UNIT_SPELLCAST_STOP = function(self, unit, castGUID, spellID)
	if IRF3.db.units.useCastingBar and unit == self.displayedUnit then -- 클래식은 자신의 정보만 있음
		InvenRaidFrames3Member_UpdateCastingBar(self,spellID,true) --stop경우는 캐스트바 취소를 위한 flag가 true
	end
end
eventHandler.UNIT_SPELLCAST_DELAYED = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_START = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_UPDATE = eventHandler.UNIT_SPELLCAST_START
eventHandler.UNIT_SPELLCAST_CHANNEL_STOP = eventHandler.UNIT_SPELLCAST_STOP
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


 
