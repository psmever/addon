local _G = _G
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local select = _G.select
local tonumber = _G.tonumber
local twipe = _G.table.wipe
local tinsert = _G.table.insert
local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitIsUnit = _G.UnitIsUnit
local GetRaidRosterInfo = _G.GetRaidRosterInfo
local IRF3 = _G[...]

local fontString = IRF3:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")

local function getTextWidth(text)
	fontString:SetText(text)
	return ceil(fontString:GetWidth())
end

function IRF3:UpdateFont()
	fontString:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
	fontString:SetShadowColor(0, 0, 0)

	if IRF3.db.font.shadow then
		fontString:SetShadowOffset(1, -1)
	else
		fontString:SetShadowOffset(0, 0)
	end
	fontString.arrowWidth = getTextWidth("▶")
end

local function getCuttingName(names, width)
	if not names then
		return ""
	end
	for i = 1, #names do
		if width >= getTextWidth(names[i]) then
			return names[i]
		end
	end
	return names[#names] or ""
end

local healthText

local function getHealthText(self)
	if IRF3.db.units.healthType == 1 then
		if IRF3.db.units.shortLostHealth then
			return ("-%.1f"):format(self.lostHealth / 1000)
		else
			return "-"..self.lostHealth
		end
	elseif IRF3.db.units.healthType == 2 then
		if IRF3.db.units.shortLostHealth then
			return ("-%.0f"):format(self.lostHealth / self.maxHealth * 100)
		else
			return ("-%.0f%%"):format(self.lostHealth / self.maxHealth * 100)
		end
	elseif IRF3.db.units.healthType == 3 then
		if IRF3.db.units.shortLostHealth then
			return ("%.1f"):format(self.health / 1000)
		else
			return self.health
		end
	elseif IRF3.db.units.healthType == 4 then
		if IRF3.db.units.shortLostHealth then
			return ("%.0f"):format(self.health / self.maxHealth * 100)
		else
			return ("%.0f%%"):format(self.health / self.maxHealth * 100)
		end
	else
		return ""
	end
end

local function getHealthText2(self)
	if not IRF3.db.units.showAbsorbHealth then
		return ""
	elseif IRF3.db.units.healthType == 1 then
		if IRF3.db.units.shortLostHealth then
			return ("+%.1f"):format(self.overAbsorb / 1000)
		else
			return "+"..self.overAbsorb
		end
	elseif IRF3.db.units.healthType == 2 then
		if IRF3.db.units.shortLostHealth then
			return ("+%.0f"):format(self.overAbsorb / self.maxHealth * 100)
		else
			return ("+%.0f%%"):format(self.overAbsorb / self.maxHealth * 100)
		end
	elseif IRF3.db.units.healthType == 3 then
		if IRF3.db.units.shortLostHealth then
			return ("+%.1f"):format(self.overAbsorb / 1000)
		else
			return self.health
		end
	elseif IRF3.db.units.healthType == 4 then
		if IRF3.db.units.shortLostHealth then
			return ("+%.0f"):format(self.overAbsorb / self.maxHealth * 100)
		else
			return ("+%.0f%%"):format(self.overAbsorb / self.maxHealth * 100)
		end
	else
		return ""
	end
end

local function checkRange(self)
	if IRF3.db.units.healthRange == 1 then
		return true
	elseif self.outRange then
		return IRF3.db.units.healthRange == 3
	else
		return IRF3.db.units.healthRange == 2
	end
end

local function getStatusText(self, bracket)

	local prefix = ""
	local postfix = ""
	local text = ""
	local width = 0
	local text1 = ""
	local text2 = ""
	local text1sub=""
	local text2sub=""
	
	if self.isOffline then
		prefix, postfix = "|cff9d9d9d<", ">|r"
		text = L["Lime_offline"]
	elseif self.isGhost then
		prefix, postfix = "|cff9d9d9d<", ">|r"
		text = L["Lime_ghost"]
	elseif self.isDead then
		prefix, postfix = "|cffff0000<", ">|r"
		text = L["Lime_dead"]
	elseif self.survivalSkill then
  		text = ("<%s%s>"):format(self.survivalSkill, self.survivalSkillTimeLeft or "")

	elseif (self.lostHealth > 0 or self.overAbsorb > 0) and IRF3.db.units.healthType ~= 0 and checkRange(self) then
		if self.optionTable.healthRed then
			if self.lostHealth > 0 then
				text = "|cffff0000"..getHealthText(self).."|r"
			else
				text = "|cff00d8ff"..getHealthText2(self).."|r"
			end
		else
			text = self.lostHealth > 0 and getHealthText(self) or getHealthText2(self)
		end
	elseif self.isAFK then
		prefix, postfix = "|cff9d9d9d<", ">|r"
		text = L["Lime_afk"]
	else
		return "", 0
	end
	if bracket and text ~= "" then
		text = "("..text..")"
		width = getTextWidth(text)
	else
		text = prefix..text..postfix
	end
	return text, width
end

function InvenRaidFrames3Member_UpdateDisplayText(self)

local textcolor=""

--print(self.hasAggroShout) 
--print(self.displayedUnit)
--print(self.hasAggroValue)


--UnitThreatSituation--
--nil = unit is not on any other unit's threat table.
--0 = not tanking anything.
--1 = not tanking anything, but have higher threat than tank on at least one unit.
--2 = insecurely tanking at least one unit, but not securely tanking anything.
--3 = securely tanking at least one unit.

if IRF3.db.units.useAggroArrow then --어그로 화살표 표기할 경우
	if IRF3.db.units.aggroDetailColor then--어그로 색상 구분을 할 경우
		if ( self.hasAggroValue ==1)   then -- 노랑일때는 현재 어그로대상이 아니므로 hasAggro조건제외
			textcolor="|cffffff00▶|r"
		elseif (self.hasAggro and self.hasAggroValue==2) then 
		--UNIT_THREAT_SITUATION값:2일떄 주황 화살표 표기
			textcolor="|cffffa500▶|r"
		
		elseif (self.hasAggro and self.hasAggroValue==3) then 
		--UNIT_THREAT_SITUATION값:3일떄 빨강 화살표 표기
			textcolor="|cffff0000▶|r"  

		--본인이 전투중아니라서 감지는 안되지만 어그로 있는 공대원 빨강화살표(1)->UnitThreatSituation = nil만 체크
		--광역을 맞아 hasAggro가 체크되고, 기타어글이 없을경우도 빨갛게된다! hasAggro에 의존하면 안됨(2) ->unitThreatSituation=1인 오히려 제외해야함.
		--(이 값이 1이라는건 전투인식이 외고, 어글대상이 아니라는 뜻이니까. 다만 nil은 아예 전투인식이 안된 상태임)
		elseif self.hasAggro and not self.hasAggroValue  then  
	

			   textcolor="|cffff0000▶|r"				
		else -- self.hasAggro가 false이거나, 광역등으로 true지만 ThreatSituation이 0인 경우
			 textcolor=""
	
		end
	else -- 어그로 단일 색상일 경우

		 if (self.hasAggro and not self.hasAggroValue)  then 
		--UNIT_THREAT_SITUATION값:3일떄 빨강 화살표 표기
			textcolor="|cffff0000▶|r"  
		elseif (self.hasAggro and self.hasAggroValue>=2 ) then 
			textcolor="|cffff0000▶|r" 
		else
			 textcolor=""
	
		end

		if self.hasAggro then
			textcolor="|cffff0000▶|r"  
		else
			textcolor=""
		end
	end
end 



--if (self.hasAggroShout and self.hasAggroShout>0) then -- 전투의 외침/포효중이면 강조표시
--
--textcolor="|cffff0000도전:" .. self.hasAggroShout .."|r"
--end

 






 
	if IRF3.db.units.nameEndl then --두줄로 표시일때
		self.name:SetFormattedText("%s%s", (self.optionTable.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and textcolor or "", getCuttingName(self.nameTable, IRF3.nameWidth - ((self.optionTable.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and fontString.arrowWidth or 0)- #textcolor-4))



		InvenRaidFrames3Member_UpdateLostHealth(self)
	else --한줄로 표시일때

		if self.survivalSkill then
			self.name:SetFormattedText("%s%s", (self.optionTable.useAggroArrow and (self.hasAggro  or self.hasAggroValue==1 )) and textcolor or "", getStatusText(self))
 
		else

			local statusText, statusWidth = getStatusText(self, true)
  			
			self.name:SetFormattedText("%s%s%s", (self.optionTable.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and textcolor or "", getCuttingName(self.nameTable, IRF3.nameWidth - ((self.optionTable.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and fontString.arrowWidth or 0) - statusWidth- #textcolor-4 ), statusText)

--			Vehicle 이름 표기
--print(IRF3.db.usePet)
			if self.unit and UnitInVehicle(self.unit) and IRF3.db.usePet==3  then 

					vehicle, _ =UnitName(  self.displayedUnit .."pet")
 
					if vehicle then
					vehicle = vehicle.gsub(vehicle," ","")
					if  vehicle:find("%w") then --팻소환사 이름이 영문일때
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(vehicle, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">")
					else

						namelen = ceil(IRF3.nameWidth/IRF3.db.font.size)
						namelenmod=namelen%3

						if namelenmod ==0 then
							self.name:SetText(self.name:GetText()   .."\n<"..strsub(vehicle, 1,namelen+3)..">")
						elseif namelenmod == 1 then
							self.name:SetText(self.name:GetText()   .."\n<"..strsub(vehicle, 1,namelen+2+3)..">")
						else
							self.name:SetText(self.name:GetText()   .."\n<"..strsub(vehicle, 1,namelen+1+3)..">")
						end
					
 					end
 					end
 
				
 			end


--			팻소환사 이름 표기
			if self.unit and self.unit:find("pet") and IRF3.db.usePet==3 then 

				petowner, _ =UnitName( (self.unit:gsub("pet", "")))
				if petowner then
				petowner = petowner.gsub(petowner," ","")
				end
				if petowner:find("%w") then --팻소환사 이름이 영문일때

					self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">")
				else

					namelen = ceil(IRF3.nameWidth/IRF3.db.font.size)
					namelenmod=namelen%3

					if namelenmod ==0 then
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen)..">")
					elseif namelenmod == 1 then
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen+2)..">")
					else
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen+1)..">")
					end

 				end
 
 
				
 			end
 
 
 
	

		end
	end
end


function InvenRaidFrames3Member_UpdateLostHealth(self)
	if IRF3.db.units.nameEndl then

		self.losttext:SetText(getStatusText(self))
	else
		InvenRaidFrames3Member_UpdateDisplayText(self)
		self.losttext:SetText("")
	end
end

local unitName, unitNameLen, prevPlayerGroup

function InvenRaidFrames3Member_UpdateName(self)
if IsInRaid() then --레이드 멤버면
	if self.unit and self.unit ~= "player" and UnitIsUnit("player", self.displayedUnit) and self:GetParent().partyTag then
		self:GetParent().partyTag.tex:SetColorTexture(unpack(IRF3.db.partyTagParty))

		IRF3.playerRaidIndex = self.unit:match("raid(%d+)")
		if IRF3.playerRaidIndex then
			IRF3.playerRaidIndex = tonumber(IRF3.playerRaidIndex)
			prevPlayerGroup = IRF3.playerGroup
			IRF3.playerGroup = select(3, GetRaidRosterInfo(IRF3.playerRaidIndex))

			if prevPlayerGroup and prevPlayerGroup ~= IRF3.playerGroup then
				IRF3.headers[prevPlayerGroup].partyTag.tex:SetColorTexture(unpack(IRF3.db.partyTagRaid))
			end
		end
	
	end
else --레이드가 아니면
	IRF3.playerGroup =1

end


	unitName = (self.unit and UnitName(self.unit) or UNKNOWNOBJECT):gsub(" ", "")

 

	if self.nameTable[1] ~= unitName then
		twipe(self.nameTable)
		unitNameLen = unitName:len()

		if unitNameLen % 3 == 0 then

			for i = unitNameLen, 3, -3 do
				tinsert(self.nameTable, unitName:sub(1, i))
			end
		else

			for i = unitNameLen, 1, -1 do
				tinsert(self.nameTable, unitName:sub(1, i))
			end
		end
	end
		self.name:SetText(unitName) 

 
--두줄로 표기가 아닐때에는 팻 소환자 표기
	if  not IRF3.db.units.nameEndl then
			if self.unit and self.unit:find("pet") then 
				petowner, _ =UnitName( (self.unit:gsub("pet", "")))

 
				if petowner:find("%w") then --팻소환사 이름이 영문일때
 
					self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">")
				else

					namelen = ceil(IRF3.nameWidth/IRF3.db.font.size)
					namelenmod=namelen%3

					if namelenmod ==0 then
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen)..">")
					elseif namelenmod == 1 then
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen+2)..">")
					else
						self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,namelen+1)..">")
					end
		--				self.name:SetText(self.name:GetText()  .."\n<"..strsub(petowner, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">")
 				end
			end
	end
end

function InvenRaidFrames3Member_UpdateNameColor(self)
	if IRF3.db.colors[self.class] and (self.optionTable.className or (self.isOffline and self.optionTable.offlineName) or (self.outRange and self.optionTable.outRangeName) or ((self.isGhost or self.isDead) and self.optionTable.deathName)) then 
	self.name:SetTextColor(IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3])
	else
	self.name:SetTextColor(IRF3.db.colors.name[1], IRF3.db.colors.name[2], IRF3.db.colors.name[3])
	end

	if self.outRange and (self.isGhost or self.isDead) then
	self.name:SetAlpha(IRF3.db.units.outRangeAlpha)
	else 
	self.name:SetAlpha(1)
	end
end
