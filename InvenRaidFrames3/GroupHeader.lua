--[[
인벤 레이드 프레임 파티 구성 스크립트
이 스크립트는 파티 및 공격대 구성 및 정렬 순서를 조정할 수 있습니다.
]]

local IRF3 = _G[...]
IRF3.headers = {}
IRF3:Execute("HEADERS = newtable(); LIST = newtable();")

IRF3.tankheaders = {}
IRF3:Execute("TANKHEADERS = newtable(); TANKLIST = newtable();")

IRF3:SetAttribute("state-group", "solo")
IRF3:SetAttribute("state-grouptype", "1")
IRF3:SetAttribute("state-combat", "no")
RegisterStateDriver(IRF3, "group", "[group:raid]raid;[group:party]party;solo")
RegisterStateDriver(IRF3, "grouptype", "[@raid36]8;[@raid31]7;[@raid26]6;[@raid21]5;[@raid16]4;[@raid11]3;[@raid6]2;1")
RegisterStateDriver(IRF3, "combat", "[combat]yes;no")

local _G = _G
local select = _G.select




for i = 0, 8 do
	IRF3.headers[i] = CreateFrame("Frame", IRF3:GetName().."Group"..i, IRF3, "InvenRaidFrames3GroupHeaderTemplate")
	IRF3:SetFrameRef("header", IRF3.headers[i])
	IRF3:Execute("HEADERS["..i.."] = self:GetFrameRef('header')")
	IRF3.headers[i].index = i
	IRF3.headers[i].visible = 0
	IRF3.headers[i].members = {}
	IRF3.headers[i]:SetAttribute("groupindex", i)
	IRF3.headers[i]:Show()
	IRF3.headers[i]:SetAttribute("startingIndex", 1)
	IRF3.headers[i]:Hide()
	IRF3.headers[i].partyTag:SetParent(IRF3.headers[i].members[1])
	IRF3.headers[i].partyTag:RegisterForDrag("LeftButton", "RightButton")
	IRF3.headers[i]:SetScript("OnHide", InvenRaidFrames3Member_OnDragStop)
end



	IRF3.tankheaders = CreateFrame("Frame", IRF3:GetName().."TankGroup", IRF3, "InvenRaidFrames3GroupHeaderTemplate")
	IRF3:SetFrameRef("header", IRF3.tankheaders)
	IRF3:Execute("TANKHEADERS = self:GetFrameRef('header')")
	IRF3.tankheaders.index = i
	IRF3.tankheaders.visible = 0
	IRF3.tankheaders.members = {}
	IRF3.tankheaders:SetAttribute("groupindex", i)
	IRF3.tankheaders:Show()
	IRF3.tankheaders:SetAttribute("startingIndex", 1)
	IRF3.tankheaders:Hide()
	IRF3.tankheaders.partyTag:SetParent(IRF3.tankheaders.members[1])
	IRF3.tankheaders.partyTag:RegisterForDrag("LeftButton", "RightButton")
	IRF3.tankheaders:SetScript("OnHide", InvenRaidFrames3Member_OnDragStop)
	IRF3.tankheaders:SetMovable(true)





IRF3.petHeader = CreateFrame("Frame", IRF3:GetName().."PetGroup", IRF3, "SecureGroupPetHeaderTemplate")
IRF3:SetFrameRef("header", IRF3.petHeader)
IRF3:Execute("PETHEADER = self:GetFrameRef('header')")
IRF3.petHeader:SetFrameLevel(7)
IRF3.petHeader:SetMovable(true)
IRF3.petHeader:SetClampedToScreen(true)
IRF3.petHeader:Hide()
IRF3.petHeader.visible = 0
IRF3.petHeader.members = {}
IRF3.petHeader:SetAttribute("template", "InvenRaidFrames3MemberBaseTemplate")
IRF3.petHeader:SetAttribute("_childupdate", "self:ChildUpdate(scriptid, message)")
IRF3.petHeader:SetAttribute("showSolo", true)
IRF3.petHeader:SetAttribute("showPlayer", true)
IRF3.petHeader:SetAttribute("showParty", true)
IRF3.petHeader:SetAttribute("showRaid", true)
IRF3.petHeader:SetAttribute("useOwnerUnit", true)
--IRF3.petHeader:SetAttribute("unitsuffix", "pet")
IRF3.petHeader:SetAttribute("initialConfigFunction", "self:SetAttribute('useOwnerUnit', true) self:SetAttribute('unitsuffix', 'pet')")
IRF3.petHeader:SetAttribute("startingIndex", -39)
IRF3.petHeader:Show()
IRF3.petHeader:SetAttribute("startingIndex", 1)
IRF3.petHeader:Hide()
IRF3.petHeader:HookScript("OnAttributeChanged", IRF3.petHeader.StopMovingOrSizing)
IRF3.petHeader.border = CreateFrame("Frame", nil, IRF3.petHeader, BackdropTemplateMixin and "BackdropTemplate")
IRF3.petHeader.border:SetFrameLevel(6)
IRF3.petHeader.border:SetBackdrop(IRF3.border:GetBackdrop())
IRF3.petHeader.border:SetPoint("TOPLEFT", -5, 5)
IRF3.petHeader.border:SetPoint("TOPLEFT", -5, 5)
IRF3.petHeader.border:SetPoint("BOTTOMRIGHT", 5, -5)
IRF3.petHeader.border:SetAlpha(0)
IRF3.petHeader.border:SetPoint("BOTTOMRIGHT", 5, -5)
IRF3.petHeader.border:SetAlpha(0)
IRF3.petHeader:SetScript("OnHide", InvenRaidFrames3Member_OnDragStop)

IRF3:Hide()
IRF3:HookScript("OnAttributeChanged", IRF3.StopMovingOrSizing)
IRF3:SetAttribute("_childupdate-clearunit", "self:ChildUpdate(scriptid, message)")

IRF3:SetAttribute("_onattributechanged", [=[

	if name == "state-combat" and value == "yes" and self:GetAttribute("preview") then
		self:SetAttribute("preview", nil)
	elseif name == "preview" then
		if value then
			self:Hide()
		else
			self:SetAttribute("startupdate", nil)
			self:SetAttribute("startupdate", true)
		end
	elseif not self:GetAttribute("ready") or self:GetAttribute("preview") then
		return
	elseif name == "state-group" or (name == "startupdate" and value) or (name == "state-grouptype" and self:GetAttribute("groupby") == "CLASS") or name == "run" then

		self:Hide()
		PETHEADER:Hide()
		self:SetAttribute("startupdate", nil)
		local use = self:GetAttribute("use")
		local group = self:GetAttribute("state-group")
		if not self:GetAttribute("run") or use == 0 or (use > 1 and group == "solo") or (use == 2 and group == "solo") or (use == 3 and group ~= "raid") or (use == 4 and group ~= "party") then
			return self:ChildUpdate("clearunit")
		end
		local width = self:GetAttribute("width")
		local height = self:GetAttribute("height")
		local petwidth2 = self:GetAttribute("petwidth2")
		local petheight2 = self:GetAttribute("petheight2")
		local usePet = self:GetAttribute("usepet")
		local enableTankFrame = self:GetAttribute("enableTankFrame")
		local petheight = self:GetAttribute("petheight")
		local offset = self:GetAttribute("offset")
		local groupby = self:GetAttribute("groupby")
		local anchor = self:GetAttribute("anchor")
 
		local dir = self:GetAttribute("dir")
		local groupfilter = self:GetAttribute("groupfilter")
		local grouptype = tonumber(self:GetAttribute("state-grouptype"))
		local column = self:GetAttribute("column")
		local sortname = self:GetAttribute("sortname")
		self:SetWidth(width)
		self:SetHeight(height)
		local xOffset, yOffset = 0, 0
 
		if dir == 1 then

			yOffset = offset + (usePet and petheight or 0)

			if anchor:find("TOP") then
				yOffset = -yOffset
			end
		elseif anchor:find("LEFT") then
			xOffset = offset
		else
			xOffset = -offset
		end 

		local index
		local count = 0

		for i = 0, 8 do

			HEADERS[i]:Hide()
			HEADERS[i]:ChildUpdate("clearunit")

			if group == "raid" then

				if i == 0 then
				TANKHEADERS:Hide()
				TANKHEADERS:ChildUpdate("clearunit")
				TANKHEADERS:SetAttribute("showPlayer", false)
				TANKHEADERS:SetAttribute("showParty", false)
				TANKHEADERS:SetAttribute("showSolo", false)
				TANKHEADERS:SetAttribute("xOffset",0)
				TANKHEADERS:SetAttribute("yOffset", 0)
				TANKHEADERS:SetAttribute("roleFilter", "MT,MAINTANK")
				TANKHEADERS:SetAttribute("sortMethod", "INDEX")
				TANKHEADERS:ChildUpdate("width", width)
				TANKHEADERS:ChildUpdate("height", height)
--				TANKHEADERS:ChildUpdate("usepet", usePet)
--				TANKHEADERS:ChildUpdate("petheight", petheight)
				if enableTankFrame then
					TANKHEADERS:Show()
				else
					TANKHEADERS:Hide()
				end
				 
 


				end
				if i > 0 then
					index = i..""
					if groupby == "GROUP" then
						if groupfilter:find(index) then
							HEADERS[i]:SetAttribute("showRaid", true)
							HEADERS[i]:SetAttribute("xOffset", xOffset)
							HEADERS[i]:SetAttribute("yOffset", yOffset)
							HEADERS[i]:SetAttribute("groupBy", groupby)
							HEADERS[i]:SetAttribute("groupFilter", index)
							HEADERS[i]:SetAttribute("groupingOrder", index)
							HEADERS[i]:SetAttribute("startingIndex", 1)
							HEADERS[i]:SetAttribute("sortMethod", sortname and "NAME" or "INDEX")
							HEADERS[i]:SetAttribute("nameList", nil)

							HEADERS[i]:ChildUpdate("width", width)
							HEADERS[i]:ChildUpdate("height", height)
							HEADERS[i]:ChildUpdate("usepet", usePet)
							HEADERS[i]:ChildUpdate("petheight", petheight)
							HEADERS[i]:Show()

			
						end
					elseif i <= grouptype then

						HEADERS[i]:SetAttribute("showRaid", true)
						HEADERS[i]:SetAttribute("xOffset", xOffset)
						HEADERS[i]:SetAttribute("yOffset", yOffset)
						HEADERS[i]:SetAttribute("groupBy", groupby)
						HEADERS[i]:SetAttribute("groupFilter", groupfilter)
						HEADERS[i]:SetAttribute("groupingOrder", groupfilter)


						HEADERS[i]:SetAttribute("startingIndex", (i - 1) * 5 + 1)
						HEADERS[i]:SetAttribute("sortMethod", sortname and "NAME" or "INDEX")
						HEADERS[i]:SetAttribute("nameList",nil)
						HEADERS[i]:ChildUpdate("width", width)
						HEADERS[i]:ChildUpdate("height", height)
						HEADERS[i]:ChildUpdate("usepet", usePet)
						HEADERS[i]:ChildUpdate("petheight", petheight)
						HEADERS[i]:Show()

 

 
					end
				end
			elseif i == 0 and (group == "party" or self:GetAttribute("use") == 1) then
			--파티일때
				TANKHEADERS:ClearAllPoints()
				TANKHEADERS:SetPoint("TOPLEFT", self, "TOPLEFT", -100,-12)
				TANKHEADERS:Hide()
				HEADERS[i]:SetAttribute("showPlayer", true)
				HEADERS[i]:SetAttribute("showParty", true)
				HEADERS[i]:SetAttribute("showSolo", true)
				HEADERS[i]:SetAttribute("xOffset", xOffset)
				HEADERS[i]:SetAttribute("yOffset", yOffset)
				HEADERS[i]:SetAttribute("groupBy", groupby)
				HEADERS[i]:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
				HEADERS[i]:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")

	if HEADERS[i]:GetAttribute("nameList") and #HEADERS[i]:GetAttribute("nameList")>0  then
				HEADERS[i]:SetAttribute("sortMethod", "NAMELIST")
				HEADERS[i]:SetAttribute("nameList", HEADERS[i]:GetAttribute("nameList"))
	else
				HEADERS[i]:SetAttribute("sortMethod", "INDEX")
	end

				HEADERS[i]:ChildUpdate("width", width)
				HEADERS[i]:ChildUpdate("height", height)
				HEADERS[i]:ChildUpdate("usepet", usePet)
				HEADERS[i]:ChildUpdate("petheight", petheight)
				HEADERS[i]:Show()

 
 


			end

			if HEADERS[i]:IsShown() then
				count = count + 1
				HEADERS[i]:ChildUpdate("clearallpoints")
				if dir == 1 then
					HEADERS[i]:SetAttribute("point", anchor:find("TOP") and "TOP" or "BOTTOM")
				else
					HEADERS[i]:SetAttribute("point", anchor:find("LEFT") and "LEFT" or "RIGHT")
				end
			end

			if i==0 and TANKHEADERS:IsShown() then

				count = count + 1
				TANKHEADERS:ChildUpdate("clearallpoints")
				if dir == 1 then
					TANKHEADERS:SetAttribute("point", anchor:find("TOP") and "TOP" or "BOTTOM")
				else
					TANKHEADERS:SetAttribute("point", anchor:find("LEFT") and "LEFT" or "RIGHT")
				end
			end
		end


		PETHEADER:Hide()
		PETHEADER:ChildUpdate("clearunit")
		if self:GetAttribute("usepetgroup") and (HEADERS[0]:IsShown() or count > 0) then
			PETHEADER:ChildUpdate("clearallpoints")
			PETHEADER:ChildUpdate("width", self:GetAttribute("petwidth2"))
			PETHEADER:ChildUpdate("height", self:GetAttribute("petheight2"))
			if HEADERS[0]:IsShown() then
				PETHEADER:SetAttribute("groupBy", "CLASS")
				PETHEADER:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
				PETHEADER:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
				PETHEADER:SetAttribute("sortMethod", "INDEX")


			else
				PETHEADER:SetAttribute("groupFilter", groupfilter)
--				PETHEADER:SetAttribute("groupBy", "CLASS")
--				PETHEADER:SetAttribute("groupingOrder", groupfilter)
				PETHEADER:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
				PETHEADER:SetAttribute("sortMethod", "INDEX")
			end
 

			PETHEADER:SetAttribute("maxColumns", 25)
			PETHEADER:SetAttribute("unitsPerColumn", self:GetAttribute("petcolumn"))
			anchor = self:GetAttribute("petanchor")

			if anchor == "TOPLEFT" then
				if self:GetAttribute("petdir") == 1 then
					PETHEADER:SetAttribute("columnAnchorPoint", "LEFT")
					PETHEADER:SetAttribute("point", "TOP")

				else
					PETHEADER:SetAttribute("columnAnchorPoint", "TOP")
					PETHEADER:SetAttribute("point", "LEFT")
				end
				PETHEADER:SetAttribute("xOffset", offset)
				PETHEADER:SetAttribute("yOffset", -offset)
			elseif anchor == "TOPRIGHT" then
				if self:GetAttribute("petdir") == 1 then
					PETHEADER:SetAttribute("columnAnchorPoint", "TOP")
					PETHEADER:SetAttribute("point", "RIGHT")
				else
					PETHEADER:SetAttribute("columnAnchorPoint", "RIGHT")
					PETHEADER:SetAttribute("point", "TOP")
				end
				PETHEADER:SetAttribute("xOffset", offset)
				PETHEADER:SetAttribute("yOffset", -offset)
			elseif anchor == "BOTTOMLEFT" then
				if self:GetAttribute("petdir") == 1 then
					PETHEADER:SetAttribute("columnAnchorPoint", "LEFT")
					PETHEADER:SetAttribute("point", "BOTTOM")
				else
					PETHEADER:SetAttribute("columnAnchorPoint",  "BOTTOM")
					PETHEADER:SetAttribute("point", "LEFT")
				end
				PETHEADER:SetAttribute("xOffset", offset)
				PETHEADER:SetAttribute("yOffset", -offset)
			else
				if self:GetAttribute("petdir") == 1 then
					PETHEADER:SetAttribute("columnAnchorPoint", "RIGHT")
					PETHEADER:SetAttribute("point", "BOTTOM")
				else
					PETHEADER:SetAttribute("columnAnchorPoint",  "BOTTOM")
					PETHEADER:SetAttribute("point", "RIGHT")
				end
				PETHEADER:SetAttribute("xOffset", offset)
				PETHEADER:SetAttribute("yOffset", -offset)
			end
			PETHEADER:Show()
		end
		self:CallMethod("SetupAll")
		self:Show()

		self:SetAttribute("updateposition", not self:GetAttribute("updateposition"))
		PETHEADER:SetAttribute("updateposition", not self:GetAttribute("updateposition"))

	elseif name == "updateposition" then

		local offsetx = self:GetAttribute("offset") or 0
		local offsety = offsetx + (self:GetAttribute("usepet") and self:GetAttribute("petheight") or 0)
		local tag = self:GetAttribute("partytag")
		local column = self:GetAttribute("column")
		local anchor = self:GetAttribute("anchor")
		local width = self:GetAttribute("width")
		local height = self:GetAttribute("height")
		local petwidth = self:GetAttribute("petwidth")
		local petheight = self:GetAttribute("petheight")
		local tagx, tagy = 0, 0

		local petanchor = self:GetAttribute("petanchor")

		if self:GetAttribute("dir") == 1 then
			tagy = tag
			width = width + offsetx
			height = (height + offsety) * 5 + tag
		else
			tagx = tag
			width = (width + offsetx) * 5 + tag
			height = height + offsety
		end
 

		if HEADERS[0]:IsShown() then

			HEADERS[0]:ClearAllPoints()
			HEADERS[0]:SetPoint(anchor, self, anchor, anchor:find("RIGHT") and -tagx or tagx, anchor:find("TOP") and -tagy or tagy)
		else
			for i = 1, 8 do
				if HEADERS[i]:IsShown() then
					HEADERS[i]:ClearAllPoints()
					tinsert(LIST, HEADERS[i])
				end
			end
			if #LIST > 0 then
				if self:GetAttribute("groupby") == "GROUP" then
					for i = 1, #LIST do
						for j = 1, #LIST do
							if i ~= j then
								if self:GetAttribute("grouporder"..LIST[i]:GetAttribute("groupindex")) < self:GetAttribute("grouporder"..LIST[j]:GetAttribute("groupindex")) then
									LIST[i], LIST[j] = LIST[j], LIST[i]
								end
							end
						end
					end
				else
					tag = 0
				end
				local w, h = 0, 0
				if anchor == "TOPLEFT" then
					LIST[1]:SetPoint("TOPLEFT", self, "TOPLEFT", tagx, -tagy)
					for i = 2, #LIST do
						if column == 1 or i % column == 1 then
							w, h = 0, h - height
						else
							w = w + width
						end
						LIST[i]:SetPoint("TOPLEFT", LIST[1], "TOPLEFT", w, h)
					end
				elseif anchor == "TOPRIGHT" then
					LIST[1]:SetPoint("TOPRIGHT", self, "TOPRIGHT", -tagx, -tagy)
					for i = 2, #LIST do
						if column == 1 or i % column == 1 then
							w, h = 0, h - height
						else
							w = w - width
						end
						LIST[i]:SetPoint("TOPRIGHT", LIST[1], "TOPRIGHT", w, h)
					end
				elseif anchor == "BOTTOMLEFT" then
					LIST[1]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", tagx, tagy)
					for i = 2, #LIST do
						if column == 1 or i % column == 1 then
							w, h = 0, h + height
						else
							w = w + width
						end
						LIST[i]:SetPoint("BOTTOMLEFT", LIST[1], "BOTTOMLEFT", w, h)
					end
				elseif anchor == "BOTTOMRIGHT" then
					LIST[1]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -tagx, tagy)
					for i = 2, #LIST do
						if column == 1 or i % column == 1 then
							w, h = 0, h + height
						else
							w = w - width
						end
						LIST[i]:SetPoint("BOTTOMRIGHT", LIST[1], "BOTTOMRIGHT", w, h)
					end
				end
				wipe(LIST)
			end
		end
 
		self:CallMethod("UpdatePetGroup")
		self:CallMethod("BorderUpdate", true)

	end
]=])
 

