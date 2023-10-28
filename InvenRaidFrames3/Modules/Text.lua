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
local aggrosymbol
if GetLocale()=="koKR" then
	aggrosymbol="▶"
else
	aggrosymbol=">"
end

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
	fontString.arrowWidth = getTextWidth(aggrosymbol)
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
			return ("+%.0f"):format(self.overAbsorb )
--			return ("+%.1f"):format(self.ValanirAbsorb/1000 ).."/"..("+%.1f"):format(self.DivineAegisAbsorb /1000).."/"..("+%.1f"):format(self.PWSAbsorb /1000)
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
	local absorbtext=""


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
  		text = ("<%s%s>"):format(self.survivalSkill, IRF3.db.units.showSurvivalSkillTimer and self.survivalSkillTimeLeft or "")
	elseif self.isAFK then
		prefix, postfix = "|cff9d9d9d<", ">|r"
		text = L["Lime_afk"]
	elseif (self.lostHealth > 0 or self.overAbsorb > 0) and IRF3.db.units.healthType ~= 0 and checkRange(self) then

		if IRF3.db.units.healthRed then
			if self.lostHealth > 0 then

				text = "|cffff0000"..getHealthText(self).."|r"

			else
				absorbtext=getHealthText2(self)
				if absorbtext=="" then
					text=""--보호막 수치를 안보여줄때는 값이 비었음
				else
					text = "|cff00d8ff"..getHealthText2(self).."|r" 
				end

			end
		else

			text = self.lostHealth > 0 and getHealthText(self) or getHealthText2(self)
		end

	else

		return "", 0
	end
 
	if bracket and (text ~= ""  ) then 

			text = "("..text..")"

		width = getTextWidth(text)
	else

		text = prefix..text..postfix
	end
	return text, width
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

function InvenRaidFrames3Member_UpdateDisplayText(self)

local textcolor=""
local textcolor_pre="" --어그로 이름색상 표기에 사용
local textcolor_post=""--어그로 이름색상 표기에 사용

--print(self.hasAggroShout) 
--print(self.displayedUnit)
--print(self.hasAggroValue)


--UnitThreatSituation--
--nil = unit is not on any other unit's threat table.
--0 = not tanking anything.
--1 = not tanking anything, but have higher threat than tank on at least one unit.
--2 = insecurely tanking at least one unit, but not securely tanking anything.
--3 = securely tanking at least one unit.

if IRF3.db.units.useAggroArrow or IRF3.db.units.useAggroNameColor then --어그로 화살표나 이름색상을 표기할 경우
	if IRF3.db.units.aggroDetailColor then--어그로 색상 구분을 할 경우
		if ( self.hasAggroValue ==1)   then -- 노랑일때는 현재 어그로대상이 아니므로 hasAggro조건제외
			textcolor_pre="|cffffff00"
			textcolor="|cffffff00"..aggrosymbol.."|r"
		elseif (self.hasAggro and self.hasAggroValue==2) then 
		--UNIT_THREAT_SITUATION값:2일떄 주황 화살표 표기
			textcolor_pre="|cffffa500"
			textcolor="|cffffa500"..aggrosymbol.."|r"
		
		elseif (self.hasAggro and self.hasAggroValue==3) then 
		--UNIT_THREAT_SITUATION값:3일떄 빨강 화살표 표기
			textcolor_pre="|cffff0000" 
			textcolor="|cffff0000"..aggrosymbol.."|r"  

		--본인이 전투중아니라서 감지는 안되지만 어그로 있는 공대원 빨강화살표(1)->UnitThreatSituation = nil만 체크
		--광역을 맞아 hasAggro가 체크되고, 기타어글이 없을경우도 빨갛게된다! hasAggro에 의존하면 안됨(2) ->unitThreatSituation=1인 오히려 제외해야함.
		--(이 값이 1이라는건 전투인식이 외고, 어글대상이 아니라는 뜻이니까. 다만 nil은 아예 전투인식이 안된 상태임)
		elseif self.hasAggro and not self.hasAggroValue  then  
			   textcolor_pre="|cffff0000"		
			   textcolor="|cffff0000"..aggrosymbol.."|r"				
		else -- self.hasAggro가 false이거나, 광역등으로 true지만 ThreatSituation이 0인 경우
			 textcolor_pre=""
			 textcolor=""
	
		end
	else -- 어그로 단일 색상일 경우

		 if (self.hasAggro and not self.hasAggroValue)  then 
		--UNIT_THREAT_SITUATION값:3일떄 빨강 화살표 표기
			textcolor_pre="|cffff0000"  
			textcolor="|cffff0000"..aggrosymbol.."|r"  
		elseif (self.hasAggro and self.hasAggroValue>=2 ) then 
			textcolor_pre="|cffff0000" 
			textcolor="|cffff0000"..aggrosymbol.."|r" 
		else
			 textcolor_pre=""
			 textcolor=""
	
		end

		if self.hasAggro then
			textcolor_pre="|cffff0000"  
			textcolor="|cffff0000"..aggrosymbol.."|r"  
		else
			 textcolor_pre=""
			textcolor=""
		end
	end
end 



 
if not IRF3.db.units.useAggroNameColor then --어그로 색상을 이름에 적용안할때
	textcolor_pre=""
	textcolor_post=""
else	
	--어그로 색상을 이름에 적용할
	textcolor_post="|r"
	
end
 
	if IRF3.db.units.nameEndl then --두줄로 표시일때
		self.name:SetFormattedText("%s%s",   (IRF3.db.units.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and textcolor or "",  string.gsub(textcolor_pre..getCuttingName(self.nameTable, IRF3.nameWidth - ((IRF3.db.units.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and fontString.arrowWidth or 0)- #textcolor-4 ),"중고재생","")..textcolor_post)



		InvenRaidFrames3Member_UpdateLostHealth(self)
	else --한줄로 표시일때
		self.losttext:SetText("")
		if self.survivalSkill then
			self.name:SetFormattedText("%s%s", (IRF3.db.units.useAggroArrow and (self.hasAggro  or self.hasAggroValue==1 )) and textcolor or "", string.gsub(textcolor_pre..getStatusText(self)..textcolor_post,"중고재생",""))

 
		else

			local statusText, statusWidth = getStatusText(self, true)
			
			self.name:SetFormattedText("%s%s%s", (IRF3.db.units.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and textcolor or "", string.gsub(textcolor_pre..getCuttingName(self.nameTable, IRF3.nameWidth - ((IRF3.db.units.useAggroArrow and (self.hasAggro or self.hasAggroValue==1)) and fontString.arrowWidth or 0) - statusWidth- #textcolor-4 ),"중고재생",""), statusText..textcolor_post)


--			Vehicle 이름 표기
--print(IRF3.db.usePet) jws

			if self.unit and (UnitInVehicle(self.unit) or UnitHasVehicleUI(self.unit)) and IRF3.db.usePet==3 and self.name:GetText()   then 

--					vehicle, _ =UnitName(  self.unit .."pet")
					vehicle, _ =UnitName(getUnitPetOrOwner(self.unit)) or ""
 					
					if #vehicle==0 then return end

					if vehicle   then

--					vehicle = string.gsub(string.gsub(vehicle," ",""),"중고재생","")
					vehicle = vehicle:gsub(" ", ""):gsub("중고재생","")
					if  vehicle:find("%w") then --팻소환사 이름이 영문일때
						self.name:SetText(self.name:GetText()  ..textcolor_pre.."\n<"..strsub(vehicle, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">"..textcolor_post)
					else

						namelen = ceil(IRF3.nameWidth/IRF3.db.font.size)
						namelenmod=namelen%3

						if namelenmod ==0 then
							self.name:SetText(self.name:GetText()   ..textcolor_pre.."\n<"..strsub(vehicle, 1,namelen+3)..">"..textcolor_post)
						elseif namelenmod == 1 then
							self.name:SetText(self.name:GetText()   ..textcolor_pre.."\n<"..strsub(vehicle, 1,namelen+2+3)..">"..textcolor_post)
						else
							self.name:SetText(self.name:GetText()   ..textcolor_pre.."\n<"..strsub(vehicle, 1,namelen+1+3)..">"..textcolor_post)
						end
					
 					end
 					end
 
				
 			end


--			팻소환사 이름 표기
			if self.unit and self.unit:find("pet") and IRF3.db.usePet==3 and not IRF3.db.units.hidepetName and self.name:GetText() then 

				petowner, _ =UnitName( (self.unit:gsub("pet", "")))
				if petowner then
					petowner = petowner.gsub(petowner," ","")
				else
					petowner="" --값못가져올 때 보정로직
				end


				if #petowner==0 then return end

				if petowner:find("%w") then --팻소환사 이름이 영문일때

					self.name:SetText(self.name:GetText()  ..textcolor_pre.."\n<"..strsub(petowner, 1,ceil(IRF3.nameWidth/IRF3.db.font.size))..">"..textcolor_post)
				else

					namelen = ceil(IRF3.nameWidth/IRF3.db.font.size)
					namelenmod=namelen%3

					if namelenmod ==0 then
						self.name:SetText((self.name:GetText() or "")  ..textcolor_pre.."\n<"..(strsub(petowner, 1,namelen) or "") ..">"..textcolor_post)
					elseif namelenmod == 1 then
						self.name:SetText((self.name:GetText() or "")  ..textcolor_pre.."\n<"..(strsub(petowner, 1,namelen+2) or "")..">"..textcolor_post)
					else
						self.name:SetText((self.name:GetText() or "")  ..textcolor_pre.."\n<"..(strsub(petowner, 1,namelen+1) or "")..">"..textcolor_post)
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


	if self.unit and self.unit:find("pet") and IRF3.db.units.hidepetName then
		unitName=" "
 
	end 


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

 
--두줄로 표기가 아니고 팻이름 숨김옵션이 아니면, 팻 소환자 추가 표기

	if  not IRF3.db.units.nameEndl and not IRF3.db.units.hidepetName then
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

	if IRF3.db.colors[self.class] and (IRF3.db.units.className or (self.isOffline and IRF3.db.units.offlineName) or (self.outRange and IRF3.db.units.outRangeName) or ((self.isGhost or self.isDead) and IRF3.db.units.deathName)) then 
	self.name:SetTextColor(IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3])
	elseif not IRF3.db.units.className then --직업색상 고정이면 처리할 필요 없음(위에서 inrange일때 이 조건으로 샘)
	self.name:SetTextColor(IRF3.db.colors.name[1], IRF3.db.colors.name[2], IRF3.db.colors.name[3])
	end

	if  self.outRange and (self.isGhost or self.isDead or IRF3.db.units.outRangeName2) then  
		self.name:SetAlpha(IRF3.db.units.fadeOutOfRangeHealth and IRF3.db.units.fadeOutAlpha or 1)

	else 
		self.name:SetAlpha(1)
	end


			 


end
