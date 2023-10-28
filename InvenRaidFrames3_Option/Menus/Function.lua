local IRF3 = InvenRaidFrames3
local Option = IRF3.optionFrame
local LBO = LibStub("LibBlueOption-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local pairs = _G.pairs
local SL = IRF3.GetSpellName

function Option:CreateAggroMenu(menu, parent)
	local function update(member)
		if member:IsVisible() and member.hasAggro then
			InvenRaidFrames3Member_UpdateDisplayText(member)
		end
	end



	menu.arrow = LBO:CreateWidget("CheckBox", parent, L["lime_func_1"], L["lime_func_desc_1"], nil, nil, true,
		function()
			return IRF3.db.units.useAggroArrow
		end,
		function(v)
			IRF3.db.units.useAggroArrow = v
			Option:UpdateMember(update)
		end
	)
	menu.arrow:SetPoint("TOPLEFT", 5, 5)

	menu.namecolor = LBO:CreateWidget("CheckBox", parent, L["lime_func_1_3"], L["lime_func_desc_1_2"], nil, nil, true,
		function()
			return IRF3.db.units.useAggroNameColor
		end,
		function(v)
			IRF3.db.units.useAggroNameColor = v
			Option:UpdateMember(update)
		end
	)
	menu.namecolor:SetPoint("TOPLEFT", menu.arrow, "TOPRIGHT", 5,0)


	menu.detailcolor = LBO:CreateWidget("CheckBox", parent, L["lime_func_1_1"], L["lime_func_desc_1_1"], nil, nil, true,
		function()
			return IRF3.db.units.aggroDetailColor
		end,
		function(v)
			IRF3.db.units.aggroDetailColor = v
			Option:UpdateMember(update)
		end
	)
	menu.detailcolor:SetPoint("BOTTOMLEFT", menu.arrow, 0, -30)

	menu.text = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	menu.text:SetText(L["lime_func_1_2"])
	menu.text:SetPoint("TOPLEFT", menu.detailcolor, "BOTTOMLEFT", 0 ,0)
	menu.text:SetJustifyH("LEFT")
	menu.text:SetJustifyV("TOP")


	local useList = { L["사용 안함"], L["항상"], L["파티 및 공격대"], L["공격대"] }
	menu.use = LBO:CreateWidget("DropDown", parent, L["lime_func_2"] , L["lime_func_desc_2"], nil, nil, true,
		function() return IRF3.db.units.aggroType, useList end,
		function(v)
			IRF3.db.units.aggroType = v
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", menu.text, "BOTTOMLEFT", 0, -20)
	local function disable()
		return IRF3.db.units.aggroType == 1
	end
	menu.gain = LBO:CreateWidget("Media", parent, L["lime_func_3"], L["lime_func_desc_3"] , nil, disable, true,
		function()
			return IRF3.db.units.aggroGain, "sound"
		end,
		function(v)
			IRF3.db.units.aggroGain = v
		end
	)
	menu.gain:SetPoint("TOP", menu.use, "BOTTOM", 0, -10)
	menu.lost = LBO:CreateWidget("Media", parent, L["lime_func_4"], L["lime_func_desc_4"], nil, disable, true,
		function()
			return IRF3.db.units.aggroLost, "sound"
		end,
		function(v)
			IRF3.db.units.aggroLost = v
		end
	)
	menu.lost:SetPoint("TOP", menu.gain, "TOP", 0, 0)
	menu.lost:SetPoint("RIGHT", -5, 0)

	 

end

function Option:CreateOutlineMenu(menu, parent)
	local function update(member)
		member:SetupOutline()
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateOutline(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Member_UpdateOutline(member.petButton)
			end
		end
	end
	local outlineList = { L["lime_func_button_1"], L["lime_func_button_2"], L["lime_func_button_3"], L["lime_func_button_4"], L["lime_func_button_5"], L["lime_func_button_6"], L["lime_func_button_7"], L["lime_func_button_8"]}
	menu.use = LBO:CreateWidget("DropDown", parent, L["lime_func_5"] ,L["lime_func_desc_5"], nil, nil, true,
		function()
			return IRF3.db.units.outline.type + 1, outlineList
		end,
		function(v)
			IRF3.db.units.outline.type = v - 1
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -5)
	local function disable()
		return IRF3.db.units.outline.type == 0
	end

	 


	menu.scale = LBO:CreateWidget("Slider", parent, L["lime_func_6"].."(%)", L["lime_func_desc_6"], nil, disable, true,
		function() return IRF3.db.units.outline.scale * 100, 50, 150, 1  end,
		function(v)
			IRF3.db.units.outline.scale = v / 100
			Option:UpdateMember(update)
		end
	)
	menu.scale:SetPoint("TOP", menu.use, "BOTTOM", 0, -10)
	menu.alpha = LBO:CreateWidget("Slider", parent, L["lime_func_7"].."(%)", L["lime_func_desc_7"], nil, disable, true,
		function() return IRF3.db.units.outline.alpha * 100, 10, 100, 1  end,
		function(v)
			IRF3.db.units.outline.alpha = v / 100
			Option:UpdateMember(update)
		end
	)
	menu.alpha:SetPoint("TOP", menu.scale, "TOP", 0, 0)
	menu.alpha:SetPoint("RIGHT", -5, 0)
	local function getColor(key)
		return IRF3.db.units.outline[key][1], IRF3.db.units.outline[key][2], IRF3.db.units.outline[key][3]
	end
	local function setColor(r, g, b, key)
		IRF3.db.units.outline[key][1], IRF3.db.units.outline[key][2], IRF3.db.units.outline[key][3] = r, g, b
		Option:UpdateMember(update)
	end
	menu.targetColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_8"], function() return IRF3.db.units.outline.type ~= 2 end, nil, true, getColor, setColor, "targetColor")
	menu.targetColor:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)
	menu.mouseoverColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_9"], function() return IRF3.db.units.outline.type ~= 3 end, nil, true, getColor, setColor, "mouseoverColor")
	menu.mouseoverColor:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)
	menu.aggroColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_10"], function() return IRF3.db.units.outline.type ~= 5 end, nil, true, getColor, setColor, "aggroColor")
	menu.aggroColor:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)

	local function isLowHealth()
		return IRF3.db.units.outline.type ~= 4
	end
	menu.lowHealthColor = LBO:CreateWidget("ColorPicker", parent,  L["lime_func_8"], L["lime_func_desc_11"], isLowHealth, nil, true, getColor, setColor, "lowHealthColor")
	menu.lowHealthColor:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)
	menu.lowHealth = LBO:CreateWidget("Slider", parent, L["lime_func_9"].."(%)", L["lime_func_desc_12"], isLowHealth, nil, true,
		function() return IRF3.db.units.outline.lowHealth * 100, 1, 99, 1  end,
		function(v)
			IRF3.db.units.outline.lowHealth = v / 100
			Option:UpdateMember(update)
		end
	)
	menu.lowHealth:SetPoint("TOP", menu.alpha, "BOTTOM", 0, -10)
	menu.aggro2Color = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_10"].."(2)", function() return IRF3.db.units.outline.type ~= 8 end, nil, true, getColor, setColor, "aggro2Color")
	menu.aggro2Color:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)

	local function isRaidIcon()
		return IRF3.db.units.outline.type ~= 6
	end
	menu.raidIconColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_13"], isRaidIcon, nil, true, getColor, setColor, "raidIconColor")
	menu.raidIconColor:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)
	local function getRaidIcon(icon)
		return IRF3.db.units.outline.raidIcon[icon]
	end
	local function setRaidIcon(v, icon)
		IRF3.db.units.outline.raidIcon[icon] = v
		Option:UpdateMember(update)
	end
	for i, text in ipairs(Option.dropdownTable["징표"]) do
		menu["raidIcon"..i] = LBO:CreateWidget("CheckBox", parent, text, text..L["lime_func_desc_14"], isRaidIcon, nil, true, getRaidIcon, setRaidIcon, i)
		if i == 1 then
			menu["raidIcon"..i]:SetPoint("TOP", menu.raidIconColor, "BOTTOM", 0, 0)
		elseif i == 2 then
			menu["raidIcon"..i]:SetPoint("TOP", menu.raidIcon1, 0, 0)
			menu["raidIcon"..i]:SetPoint("RIGHT", -5, 0)
		else
			menu["raidIcon"..i]:SetPoint("TOP", menu["raidIcon"..(i - 2)], "BOTTOM", 0, 14)
		end
	end
	local function isLowHealth2()
		return IRF3.db.units.outline.type ~= 7
	end
	menu.lowHealthColor2 = LBO:CreateWidget("ColorPicker", parent, L["lime_func_8"], L["lime_func_desc_11"], isLowHealth2, nil, true, getColor, setColor, "lowHealthColor2")
	menu.lowHealthColor2:SetPoint("TOP", menu.scale, "BOTTOM", 0, -10)
	menu.lowHealth2 = LBO:CreateWidget("Slider", parent, L["lime_func_9"], L["lime_func_desc_16"], isLowHealth2, nil, true,
		function() return IRF3.db.units.outline.lowHealth2, 1, 99999, 1  end,
		function(v)
			IRF3.db.units.outline.lowHealth2 = v
			Option:UpdateMember(update)
		end
	)
	menu.lowHealth2:SetPoint("TOP", menu.alpha, "BOTTOM", 0, -10)
end

function Option:CreateRangeMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_OnUpdate2(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Member_OnUpdate2(member.petButton)
			end
		end
	end

	local function updateName(member)
 
		if member:IsVisible() then
 
			InvenRaidFrames3Member_UpdateNameColor(member)
		end
	end

	menu.outrange = LBO:CreateWidget("Slider", parent, L["lime_func_16"].."(%)", L["lime_func_desc_17"], nil, nil, true,
		function()
			return IRF3.db.units.fadeOutAlpha * 100, 0, 100, 1 
		end,
		function(v)
			IRF3.db.units.fadeOutAlpha = v / 100
			Option:UpdateMember(updateName)

		end
	)
	menu.outrange:SetPoint("TOPLEFT", 5, -10)

--[[ 외형-이름-에 동일한 기능있음
	menu.outRangeName = LBO:CreateWidget("CheckBox", parent, L["lime_func_16_1"],L["lime_func_desc_16_1"] , nil, nil, true,
		function()
			return IRF3.db.units.outRangeName
		end,
		function(v)
			IRF3.db.units.outRangeName = v
			Option:UpdateMember(updateName)
			
		end
	)
	menu.outRangeName:SetPoint("TOP", menu.outrange, "BOTTOM", 0, -5)

--]]
	menu.mana = LBO:CreateWidget("CheckBox", parent, L["lime_func_17"], L["lime_func_desc_18"], nil, nil, true,
		function()
			return IRF3.db.units.fadeOutOfRangeHealth
		end,
		function(v)
			IRF3.db.units.fadeOutOfRangeHealth = v
			Option:UpdateMember(updateName) 
		end
	)
	menu.mana:SetPoint("TOP", menu.outrange, "BOTTOM", 0, 0)

	menu.outRangeName2 = LBO:CreateWidget("CheckBox", parent, L["lime_func_18"], L["lime_func_19"], nil, nil, true,
		function()
			return IRF3.db.units.outRangeName2
		end,
		function(v)
			IRF3.db.units.outRangeName2 = v
			Option:UpdateMember(updateName)

		end
	)
	menu.outRangeName2:SetPoint("TOP", menu.mana, "BOTTOM", 0, 0)

end

function Option:CreateLostHealthMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateDisplayText(member)
		end
	end
	local typeList = { L["lime_func_button_10"] , L["lime_func_button_11"] ,L["lime_func_button_12"], L["lime_func_button_13"], L["lime_func_button_14"] }
	menu.type = LBO:CreateWidget("DropDown", parent, L["표시 방식"], L["lime_func_desc_19"], nil, nil, true,
		function()
			return IRF3.db.units.healthType + 1, typeList
		end,
		function(v)
			IRF3.db.units.healthType = v - 1
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.type:SetPoint("TOPLEFT", 5, -5)
	local function disable()
		return IRF3.db.units.healthType == 0
	end
	local rangeList = { L["항상"], L["lime_func_button_15"], L["lime_func_button_16"]}
	menu.range = LBO:CreateWidget("DropDown", parent, L["lime_func_11"], L["lime_func_desc_20"], nil, disable, true,
		function()
			return IRF3.db.units.healthRange, rangeList
		end,
		function(v)
			IRF3.db.units.healthRange = v
			Option:UpdateMember(update)
		end
	)
	menu.range:SetPoint("TOPRIGHT", -5, -5)
	menu.short = LBO:CreateWidget("CheckBox", parent, L["lime_func_12"], L["lime_func_desc_21"] , nil, disable, true,
		function()
			return IRF3.db.units.shortLostHealth
		end,
		function(v)
			IRF3.db.units.shortLostHealth = v
			Option:UpdateMember(update)
		end
	)
	menu.short:SetPoint("TOP", menu.type, "BOTTOM", 0, -5)
	menu.nameEndl = LBO:CreateWidget("CheckBox", parent, L["lime_func_13"], L["lime_func_desc_22"], nil, disable, true,
		function()
			return IRF3.db.units.nameEndl
		end,
		function(v)
			IRF3.db.units.nameEndl = v
			Option:UpdateMember(IRF3.headers[0].members[1].SetupPowerBar)
			Option:UpdateMember(IRF3.tankheaders.members[1].SetupPowerBar)
			Option:UpdateMember(update)
			Option:UpdatePreview()
		end
	)
	menu.nameEndl:SetPoint("TOP", menu.range, "BOTTOM", 0, -5)
	menu.healthRed = LBO:CreateWidget("CheckBox", parent, L["lime_func_14"], L["lime_func_desc_23"], nil, disable, true,
		function()
			return IRF3.db.units.healthRed
		end,
		function(v)
			IRF3.db.units.healthRed = v
			Option:UpdateMember(update)
		end
	)
	menu.healthRed:SetPoint("TOP", menu.short, "BOTTOM", 0, -5)
	menu.showAbsorb = LBO:CreateWidget("CheckBox", parent, L["lime_func_15"], L["lime_func_desc_24"], nil, disable, true,
		function()
			return IRF3.db.units.showAbsorbHealth
		end,
		function(v)
			IRF3.db.units.showAbsorbHealth = v
			Option:UpdateMember(update)
		end
	)
	menu.showAbsorb:SetPoint("TOP", menu.healthRed, "BOTTOM", 0, -5)
end

function Option:UpdateIconPos()
	Option:UpdateMember(InvenRaidFrames3Member_SetupIconPos)
end

function Option:CreateBuffCheckMenu(menu, parent)
	local raidBuffs = {}
	for spellId in pairs(InvenRaidFrames3CharDB.classBuff2) do

-- print(IRF3.isWOTLK)  
--리분에서는 일부축복이 손길로 변경
if not IRF3.isWOTLK or (IRF3.isWOTLK and spellId~=1022 and spellId~=1038 and spellId ~=1044 and spellId~=6940 )then
		if type(spellId) == "number" and spellId > 0 and spellId == floor(spellId) and GetSpellInfo(spellId) and not IsPassiveSpell(spellId) then

			if not (IRF3.raidBuffData.link and IRF3.raidBuffData.link[spellId]) then
 
				table.insert(raidBuffs, spellId)
			end
		end
	end
end

	if #raidBuffs == 0 then
		menu.text = parent:GetParent():CreateFontString(nil, "OVERLAY", "GameFontNormal")
		menu.text:SetPoint("CENTER", 0, 0)
		menu.text:SetText("The function is currently unavailable.")
		return
	else
		table.sort(raidBuffs, function(a, b)
			local A, B = GetSpellInfo(a), GetSpellInfo(b)
			if A == B then
				return a < b
			else
				return A < B
			end
		end)
	end

	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_buff_2"], nil, nil, nil,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.buffIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.buffIconPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOPLEFT", 5, -10)
	local function updateSize(member)
		if member:IsVisible() then
			if member.buffIcon1:IsVisible() then
				member.buffIcon1:SetSize(IRF3.db.units.buffIconSize, IRF3.db.units.buffIconSize)
			end
			if member.buffIcon2:IsVisible() then
				member.buffIcon2:SetSize(IRF3.db.units.buffIconSize, IRF3.db.units.buffIconSize)
			end

			if member.buffIcon3:IsVisible() then
				member.buffIcon3:SetSize(IRF3.db.units.buffIconSize, IRF3.db.units.buffIconSize)
			end

			if member.buffIcon4:IsVisible() then
				member.buffIcon4:SetSize(IRF3.db.units.buffIconSize, IRF3.db.units.buffIconSize)
			end
		end
	end
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_buff_3"], nil, nil, nil,
		function()
			return IRF3.db.units.buffIconSize, 8, 20, 1
		end,
		function(v)
			IRF3.db.units.buffIconSize = v
			Option:UpdateMember(updateSize)
		end
	)
	menu.size:SetPoint("TOPRIGHT", -5, -10)
	
	--[==[
	local printedSpell = {}
	if IRF3.playerClass == "PALADIN" and IRF3.castableBuffs[1] and IRF3.castableBuffs[8] then
		printedSpell[IRF3.castableBuffs[1][1]] = 8
		printedSpell[IRF3.castableBuffs[8][1]] = true
	end
	]==]

	local buffTypeList = { L["lime_func_buff_4"] , L["lime_func_buff_5"], L["lime_func_buff_6"]}

	local function getBuff(spellId)
		local classBuff2 = InvenRaidFrames3CharDB.classBuff2[spellId] or 0
		if classBuff2 >2 then classBuff2 = classBuff2-2 end --기존에는 0~4였으나이제는 0~2로 변경했기 때문에 조정
		return classBuff2 + 1, buffTypeList
	end

	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateBuffs(member)
		end
	end
	
	local function setBuff(v, spellId)
		InvenRaidFrames3CharDB.classBuff2[spellId] = v - 1
		if IRF3.raidBuffData.link and IRF3.raidBuffData.link[spellId] then
--			InvenRaidFrames3CharDB.classBuff2[IRF3.raidBuffData.link[spellId]] = v - 1
		end
		Option:UpdateMember(update)
		 IRF3:SetupBuff()--버프사용여부 체크
	end

	local _, spellName, spellIcon, text

	for i, spellId in ipairs(raidBuffs) do
		spellName, _, spellIcon = GetSpellInfo(spellId)
		text = ("|T%s:0:0:0:-1|t %s"):format(spellIcon, spellName)
		if IRF3.raidBuffData.link then
			for p, v in pairs(IRF3.raidBuffData.link) do
				if v == spellId then
					spellName, _, spellIcon = GetSpellInfo(p)
					text = text..", "..("|T%s:0:0:0:-1|t %s"):format(spellIcon, spellName)
					break
				end
			end
		end
		menu["buff"..i] = LBO:CreateWidget("DropDown", parent, text, text..": "..L["lime_func_buff_7"], nil, nil, nil, getBuff, setBuff, spellId)
		if i == 1 then
			menu["buff"..i]:SetPoint("TOP", menu.pos, "BOTTOM", 0, -10)
		elseif i == 2 then
			menu["buff"..i]:SetPoint("TOP", menu.size, "BOTTOM", 0, -10)
		else
			menu["buff"..i]:SetPoint("TOP", menu["buff"..(i - 2)], "BOTTOM", 0, -10)
		end
	end
end

function Option:CreateSpellTimerMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateSpellTimer(member)
		end
	end
	local useList = { L["lime_func_button_17"], L["lime_func_button_18"], L["lime_func_button_19"], L["lime_func_button_20"], L["lime_func_button_21"] }
	local function getUse(id)
		return InvenRaidFrames3CharDB.spellTimer[id].use + 1, useList
	end
	local function setUse(v, id)
		InvenRaidFrames3CharDB.spellTimer[id].use = v - 1
		IRF3:BuildSpellTimerList()
		Option:UpdateMember(update)
		LBO:Refresh(parent)
		IRF3:UpdateSpellTimerFont()
		IRF3:SetupSpellTimerYn()--버프사용여부 체크
	end
	local function disable(id)
		return InvenRaidFrames3CharDB.spellTimer[id].use == 0
	end
	local function getPos(id)
		return Option.dropdownTable["아이콘변환"][InvenRaidFrames3CharDB.spellTimer[id].pos], Option.dropdownTable["아이콘"]
	end
	local function setPos(v, id)

		InvenRaidFrames3CharDB.spellTimer[id].pos = Option.dropdownTable["아이콘변환"][v]
		Option:UpdateIconPos()
	

	end
	local displayList = { L["lime_func_button_22"], L["lime_func_button_23"], L["lime_func_button_24"], L["lime_func_button_25"], L["lime_func_button_26"]  }
	local function getDisplay(id)

		return InvenRaidFrames3CharDB.spellTimer[id].display, displayList
	end
	local function setDisplay(v, id)

		InvenRaidFrames3CharDB.spellTimer[id].display = v
		Option:UpdateMember(update)
		IRF3:BuildSpellTimerList()
		IRF3:UpdateSpellTimerFont()

	end
	local function getfontsize(id)
		return InvenRaidFrames3CharDB.spellTimer[id].fontsize,5,20,1


	end
	local function setfontsize(v, id)

		InvenRaidFrames3CharDB.spellTimer[id].fontsize = v
		Option:UpdateMember(update)
		IRF3:BuildSpellTimerList()
		IRF3:UpdateSpellTimerFont()
	end

	local function getScale(id)
		return InvenRaidFrames3CharDB.spellTimer[id].scale * 100, 50, 150, 1
	end
	local function setScale(v, id)
		InvenRaidFrames3CharDB.spellTimer[id].scale = v / 100
		Option:UpdateMember(update)
		IRF3:BuildSpellTimerList()
		IRF3:UpdateSpellTimerFont()
	end


	local function getFadeIn(id)
		return InvenRaidFrames3CharDB.spellTimer[id].FadeIn
	end
	local function setFadeIn(v, id)
		InvenRaidFrames3CharDB.spellTimer[id].FadeIn=v

	end
	

	local function getSpellTimerType1(id)
		return InvenRaidFrames3CharDB.spellTimer[id].enableSpellTimerType1
	end
	local function setSpellTimerType1(v, id)
		InvenRaidFrames3CharDB.spellTimer[id].enableSpellTimerType1=v

	end


	local function getName(id)
		return InvenRaidFrames3CharDB.spellTimer[id].name or ""
	end
	local function setName(v, id)
		v = v:trim()
		InvenRaidFrames3CharDB.spellTimer[id].name = v ~= "" and v or nil
		Option:UpdateMember(update)
		IRF3:BuildSpellTimerList()
		IRF3:UpdateSpellTimerFont()

	end

--고급옵션
--[[개별설정으로 변경됨
	menu.enableFadeIn = LBO:CreateWidget("CheckBox", parent, L["주문 타이머 동적 표시"], L["주문 타이머 동적 표시desc"], nil, nil, true,
		function() return IRF3.db.enableFadeIn end,
		function(v)
			IRF3.db.enableFadeIn = v
			
		end
	)
	menu.enableFadeIn:SetPoint("TOPLEFT", 5, -5)
]]--
--	menu.enableFadeIn:SetPoint("TOP", menu.addonsLink, "BOTTOM", 0, 0)
--[[
	menu.FadeInFrequency = LBO:CreateWidget("Slider", parent, L["주문 타이머 주기"], L["주문 타이머 주기desc"], nil, nil, true,
		function() return IRF3.db.FadeInFrequency, 1, 10, 1, "" end,
		function(v)
			IRF3.db.FadeInFrequency = v

		end
	)
menu.FadeInFrequency:SetPoint("LEFT", menu.enableFadeIn, "RIGHT", 10, 0)

]]--


--[[
	menu.enableSpellTimerType1 = LBO:CreateWidget("CheckBox", parent, L["주문 타이머 폰트 겹치기"], L["주문 타이머 폰트 겹치기desc"], nil, nil, true,
		function() return IRF3.db.enableSpellTimerType1 end,
		function(v)
			IRF3.db.enableSpellTimerType1 = v
			IRF3:UpdateSpellTimerFont()
			IRF3:UpdateSpellTimerWidth()
		end
	)
--	menu.enableSpellTimerType1:SetPoint("TOPLEFT", menu.enableFadeIn, "TOPRIGHT", 0, 0)
	menu.enableSpellTimerType1:SetPoint("TOPLEFT", 5, -5)
]]--
	menu.SpellTimerFontColor = LBO:CreateWidget("ColorPicker", parent, L["주문 타이머 폰트 색상"], L["주문 타이머 폰트 색상desc"], nil, nil, true,
		function() return IRF3.db.units.SpellTimerFontColor[1], IRF3.db.units.SpellTimerFontColor[2], IRF3.db.units.SpellTimerFontColor[3] end,
		function(r, g, b)
			IRF3.db.units.SpellTimerFontColor[1], IRF3.db.units.SpellTimerFontColor[2], IRF3.db.units.SpellTimerFontColor[3] = r, g, b
			IRF3:UpdateSpellTimerFont()

		end
	)
--	menu.SpellTimerFontColor:SetPoint("TOP", menu.enableSpellTimerType1, "BOTTOM", 0, 0)
	menu.SpellTimerFontColor:SetPoint("TOPLEFT", 5, -5)

	menu.SpellTimerOtherFontColor = LBO:CreateWidget("ColorPicker", parent, L["주문 타이머 폰트 색상_타인"], L["주문 타이머 폰트 색상_타인desc"], nil, nil, true,
		function() return IRF3.db.units.SpellTimerOtherFontColor[1], IRF3.db.units.SpellTimerOtherFontColor[2], IRF3.db.units.SpellTimerOtherFontColor[3] end,
		function(r, g, b)
			IRF3.db.units.SpellTimerOtherFontColor[1], IRF3.db.units.SpellTimerOtherFontColor[2], IRF3.db.units.SpellTimerOtherFontColor[3] = r, g, b
			IRF3:UpdateSpellTimerFont()

		end
	)
	menu.SpellTimerOtherFontColor:SetPoint("LEFT", menu.SpellTimerFontColor, "RIGHT", 0, 0)



	menu.SpellTimerCountColor = LBO:CreateWidget("ColorPicker", parent, L["주문 타이머 중첩 색상"], L["주문 타이머 중첩 색상desc"], nil, nil, true,
		function() return IRF3.db.units.SpellTimerCountColor[1], IRF3.db.units.SpellTimerCountColor[2], IRF3.db.units.SpellTimerCountColor[3] end,
		function(r, g, b)
			IRF3.db.units.SpellTimerCountColor[1], IRF3.db.units.SpellTimerCountColor[2], IRF3.db.units.SpellTimerCountColor[3] = r, g, b
			IRF3:UpdateSpellTimerFont()

		end
	)
	menu.SpellTimerCountColor:SetPoint("LEFT", menu.SpellTimerOtherFontColor, "RIGHT", 0, 0)
 


--
	for i, info in ipairs(InvenRaidFrames3CharDB.spellTimer) do
		if i<16 then --16이상은 공대생존기 아이콘용으로 사용(hidden)
		menu["use"..i] = LBO:CreateWidget("DropDown", parent, L["lime_func_spelltimer_2"]..i, L["lime_func_spelltimer_2"]..i..L["lime_func_spelltimer_3"], nil, nil, true, getUse, setUse, i)
		if i == 1 then
--			menu["use"..i]:SetPoint("TOP", 0, -5)
			menu["use"..i]:SetPoint("TOP", menu.SpellTimerFontColor, "BOTTOM", 0, -10)
		else
			menu["use"..i]:SetPoint("TOP", menu["name"..(i - 1)], "BOTTOM", 0, -40)
		end
		menu["use"..i]:SetPoint("LEFT", 5, 0)
		menu["pos"..i] = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_spelltimer_2"]..i..L["lime_func_spelltimer_4"], nil, disable, true, getPos, setPos, i)
		menu["pos"..i]:SetPoint("TOPLEFT", menu["use"..i], "TOPRIGHT", 0, 0)
		menu["pos"..i]:SetWidth(100)
--		menu["pos"..i]:SetPoint("RIGHT", -100, 0)
		menu["display"..i] = LBO:CreateWidget("DropDown", parent, L["표시 방식"], L["lime_func_spelltimer_2"]..i..L["lime_func_spelltimer_5"], nil, disable, true, getDisplay, setDisplay, i)
--		menu["display"..i]:SetPoint("TOP", menu["use"..i], "BOTTOM", 0, -5)
		menu["display"..i]:SetPoint("TOPLEFT", menu["pos"..i], "TOPRIGHT", 0, 0)
		menu["scale"..i] = LBO:CreateWidget("Slider", parent, L["크기"].."(%)", L["lime_func_spelltimer_2"]..i..L["lime_func_spelltimer_6"], nil, disable, true, getScale, setScale, i)
--		menu["scale"..i]:SetPoint("TOPLEFT", menu["pos"..i], "TOPRIGHT", 0, -5)
		menu["scale"..i]:SetPoint("TOP", menu["use"..i], "BOTTOM", 0, -5)
		menu["scale"..i]:SetWidth(120)

		menu["fontsize"..i] = LBO:CreateWidget("Slider", parent, L["글꼴"]..L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_26_3"], nil, disable, true,getfontsize,setfontsize,i)
		menu["fontsize"..i]:SetPoint("TOPLEFT",menu["scale"..i],"TOPRIGHT",0,0)
		menu["fontsize"..i]:SetWidth(120)

		menu["fadein"..i] =  LBO:CreateWidget("CheckBox", parent, L["주문 타이머 동적 표시"], L["주문 타이머 동적 표시desc"], nil, disable, true,getFadeIn,setFadeIn,i)
--		menu["fadein"..i]:SetPoint("TOPLEFT",menu["display"..i],"TOPRIGHT",0,-5)
--		menu["fadein"..i]:SetPoint("TOPLEFT",menu["scale"..i],"TOPRIGHT",0,-5)
		menu["fadein"..i]:SetPoint("TOPLEFT",menu["fontsize"..i],"TOPRIGHT",0,-5)
		menu["fadein"..i]:SetWidth(100)

		menu["spelltimertype1"..i] =  LBO:CreateWidget("CheckBox", parent, L["주문 타이머 폰트 겹치기"], L["주문 타이머 폰트 겹치기desc"], nil, disable, true,getSpellTimerType1,setSpellTimerType1,i)
		menu["spelltimertype1"..i]:SetPoint("TOPLEFT",menu["fadein"..i],"TOPRIGHT",0,0)
		menu["spelltimertype1"..i]:SetWidth(100)

		menu["name"..i] = LBO:CreateWidget("EditBox", parent, L["버프/디버프 이름"], L["lime_func_spelltimer_2"]..i..L["lime_func_spelltimer_7"], nil, disable, true, getName, setName, i)
		menu["name"..i].title:ClearAllPoints()
		menu["name"..i].title:SetPoint("TOP", 0, -3)


		menu["name"..i].box:ClearAllPoints()
		menu["name"..i].box:SetPoint("TOP", menu["name"..i].title, "BOTTOM", 0, -7)
		menu["name"..i].box:SetPoint("LEFT", 0, 0)
		menu["name"..i].box:SetPoint("RIGHT", 0, 0)


		menu["name"..i]:SetPoint("TOP", menu["scale"..i], "BOTTOM", 0, -5)
		menu["name"..i]:SetPoint("LEFT", 5, 0)
		menu["name"..i]:SetPoint("RIGHT", -5, 0)
		end
	end
end

function Option:CreateSurvivalSkillMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateSurvivalSkill(member)
			InvenRaidFrames3Member_UpdateDisplayText(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["lime_func2_1"], L["lime_func2_desc_1"], nil, nil, true,
		function()
			return IRF3.db.units.useSurvivalSkill
		end,
		function(v)
			IRF3.db.units.useSurvivalSkill = v
			IRF3:BuildSpellTimerList()
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 0)
	menu.timer = LBO:CreateWidget("CheckBox", parent, L["lime_func2_2"], L["lime_func2_desc_2"], nil, function() return not IRF3.db.units.useSurvivalSkill end, true,
		function()
			return IRF3.db.units.showSurvivalSkillTimer
		end,
		function(v)
			IRF3.db.units.showSurvivalSkillTimer = v
			Option:UpdateMember(update)
		end
	)
	menu.timer:SetPoint("TOPRIGHT", -5, 0)



	menu.sub = LBO:CreateWidget("CheckBox", parent, L["lime_func2_3"], L["lime_func2_desc_3"], nil, function() return not IRF3.db.units.useSurvivalSkill end, true,
		function()
			return IRF3.db.units.showSurvivalSkillSub
		end,
		function(v)
			IRF3.db.units.showSurvivalSkillSub = v
			LBO:Refresh(parent)
			Option:UpdateMember(update)
		end
	)
	menu.sub:SetPoint("TOP", menu.use, "BOTTOM", 0, 5)

	menu.potion = LBO:CreateWidget("CheckBox", parent, L["lime_func2_4"], L["lime_func2_desc_4"], nil, function() return not IRF3.db.units.useSurvivalSkill end, true,
		function()
			return IRF3.db.units.showSurvivalSkillPotion
		end,
		function(v)
			IRF3.db.units.showSurvivalSkillPotion = v
			LBO:Refresh(parent)
			Option:UpdateMember(update)
		end
	)
	menu.potion:SetPoint("TOP", menu.timer, "BOTTOM", 0, 5)

	menu.showIcon = LBO:CreateWidget("CheckBox", parent, L["lime_func2_4_1"], L["lime_func2_desc_4_1"], nil, function() return not IRF3.db.units.useSurvivalSkill end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellTimer
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellTimer = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)
			IRF3:SetupSpellTimerYn()--버프사용여부 체크

		end
	)
	menu.showIcon:SetPoint("TOP", menu.sub, "BOTTOM", 0, 5)


	local function getPos(id)
		return Option.dropdownTable["아이콘변환"][InvenRaidFrames3CharDB.spellTimer[id].pos], Option.dropdownTable["아이콘"]
	end
	local function setPos(v, id)

		InvenRaidFrames3CharDB.spellTimer[id].pos = Option.dropdownTable["아이콘변환"][v]
		Option:UpdateIconPos()
	

	end
 

	local function getScale(id)
		return InvenRaidFrames3CharDB.spellTimer[id].scale * 100, 50, 150, 1
	end
	local function setScale(v, id)

		InvenRaidFrames3CharDB.spellTimer[id].scale = v / 100
		Option:UpdateMember(update)
		IRF3:BuildSpellTimerList()
		IRF3:UpdateSpellTimerFont()
	end

		menu["pos"] = LBO:CreateWidget("DropDown", parent, L["위치"], L["생존기 표시"]..L["lime_func_spelltimer_4"], nil, disable, true, getPos, setPos, 16)--16번째부터 생존기아이콘(주문타이머16)으로 사용하므로
		menu["pos"]:SetPoint("TOPLEFT", menu["showIcon"], "BOTTOMLEFT", 0, 0)

		menu["scale"] = LBO:CreateWidget("Slider", parent, L["크기"].."(%)", L["생존기 표시"]..L["lime_func_spelltimer_6"], nil, disable, true, getScale, setScale, 16)--16번째부터 생존기아이콘(주문타이머16)으로 사용하므로
		menu["scale"]:SetPoint("TOPLEFT", menu["pos"], "TOPRIGHT", 0, -5)

	
--방벽/최저/속도/마폭/그망/소멸/얼방/보축/희축/고억
--SL(871)..","..SL(12975)..","..SL(53908)..","..SL(53909)..","..SL(31224)..","..SL(11327)..","..SL(45438)..","..SL(1022)..","..SL(6940)..","..SL(33206)

--생본/껍질/대보/얼인/불굴/흡혈/수호/자극/무적
--SL(61336)..","..SL(22812)..","..SL(48707)..","..SL(48792)..","..SL(51271)..","..SL(55233)..","..SL(47788)..","..SL(29166)..","..SL(642)

--오숙(별도처리),오숙용 기타오라


--방벽 SL(871)
	menu.showIcon1 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("WARRIOR"))..SL(871),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[1]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[1] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon1:SetPoint("TOP", menu.pos, "BOTTOM", 0, 0)

--최저SL(12975)
	menu.showIcon2 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("WARRIOR"))..SL(12975),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[2]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[2] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon2:SetPoint("TOPLEFT", menu.showIcon1, "TOPRIGHT", 0, 0)


--그망SL(31224) 
	menu.showIcon3 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("ROGUE"))..SL(31224) ,"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[3]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[3] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon3:SetPoint("TOPLEFT", menu.showIcon2, "TOPRIGHT", 0, 0)

--소멸SL(11327)
	menu.showIcon4 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("ROGUE"))..SL(11327),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[4]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[4] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon4:SetPoint("TOPLEFT", menu.showIcon1, "BOTTOMLEFT", 0, 0)

--얼방SL(45438)
	menu.showIcon5 = LBO:CreateWidget("CheckBox", parent,"|c"..select(4,GetClassColor("MAGE")).. SL(45438),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[5]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[5] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon5:SetPoint("TOPLEFT", menu.showIcon4, "TOPRIGHT", 0, 0)


--보축SL(1022)
	menu.showIcon6 = LBO:CreateWidget("CheckBox", parent,"|c"..select(4,GetClassColor("PALADIN")).. SL(1022),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[6]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[6] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon6:SetPoint("TOPLEFT", menu.showIcon5, "TOPRIGHT", 0, 0)
--희축SL(6940)
	menu.showIcon7 = LBO:CreateWidget("CheckBox", parent,"|c"..select(4,GetClassColor("PALADIN")).. SL(6940),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[7]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[7] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon7:SetPoint("TOPLEFT", menu.showIcon4, "BOTTOMLEFT", 0, 0)
--천상의 보호막SL(642)
	menu.showIcon8 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PALADIN"))..SL(642),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[8]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[8] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon8:SetPoint("TOPLEFT", menu.showIcon7, "TOPRIGHT", 0, 0)
--천수SL(70940)
	menu.showIcon9 = LBO:CreateWidget("CheckBox", parent,"|c"..select(4,GetClassColor("PALADIN")).. SL(70940),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[9]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[9] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon9:SetPoint("TOPLEFT", menu.showIcon8, "TOPRIGHT", 0, 0)
--오숙SL(31821)

	menu.showIcon10 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PALADIN"))..SL(31821),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[10]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[10] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon10:SetPoint("TOPLEFT", menu.showIcon7, "BOTTOMLEFT", 0, 0)

--신의 가호SL(498) --23번
	menu.showIcon23 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PALADIN"))..SL(498),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[23]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[23] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon23:SetPoint("TOPLEFT", menu.showIcon10, "TOPRIGHT", 0, 0)


--고억SL(33206)
	menu.showIcon11 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PRIEST"))..SL(33206),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[11]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[11] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon11:SetPoint("TOPLEFT", menu.showIcon23, "TOPRIGHT", 0, 0)
--수호SL(47788)
	menu.showIcon12 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PRIEST"))..SL(47788),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[12]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[12] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon12:SetPoint("TOPLEFT", menu.showIcon10, "BOTTOMLEFT", 0, 0)

--천상의 찬가SL(64844)
	menu.showIcon24 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("PRIEST"))..SL(64844).."/"..SL(64904),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[24]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[24] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon24:SetPoint("TOPLEFT", menu.showIcon12, "TOPRIGHT", 0, 0)




--생본SL(61336)
	menu.showIcon13 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DRUID"))..SL(61336),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[13]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[13] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon13:SetPoint("TOPLEFT", menu.showIcon24, "TOPRIGHT", 0, 0)

--껍질SL(22812)
	menu.showIcon14 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DRUID"))..SL(22812),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[14]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[14] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon14:SetPoint("TOPLEFT", menu.showIcon12, "BOTTOMLEFT", 0, 0)

--자극SL(29166)
	menu.showIcon15 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DRUID"))..SL(29166),"", nil, function() return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[15]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[15] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon15:SetPoint("TOPLEFT", menu.showIcon14, "TOPRIGHT", 0, 0)


--대보SL(48707)
	menu.showIcon16 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DEATHKNIGHT"))..SL(48707),"", nil, function()   return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[16]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[16] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon16:SetPoint("TOPLEFT", menu.showIcon15, "TOPRIGHT", 0, 0)
--얼인SL(48792)
	menu.showIcon17 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DEATHKNIGHT"))..SL(48792),"", nil, function()   return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[17]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[17] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon17:SetPoint("TOPLEFT", menu.showIcon14, "BOTTOMLEFT", 0, 0)
--불굴SL(51271)
	menu.showIcon18 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DEATHKNIGHT"))..SL(51271),"", nil, function()   return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[18]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[18] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon18:SetPoint("TOPLEFT", menu.showIcon17, "TOPRIGHT", 0, 0)

--흡혈SL(55233)
	menu.showIcon19 = LBO:CreateWidget("CheckBox", parent, "|c"..select(4,GetClassColor("DEATHKNIGHT"))..SL(55233),"", nil, function()  return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[19]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[19] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon19:SetPoint("TOPLEFT", menu.showIcon18, "TOPRIGHT", 0, 0)
--속도SL(53908)
	menu.showIcon20 = LBO:CreateWidget("CheckBox", parent, SL(53908),"", nil, function()  return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[20]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[20] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon20:SetPoint("TOPLEFT", menu.showIcon17, "BOTTOMLEFT", 0, 0)
--마폭SL(53909)
	menu.showIcon21 = LBO:CreateWidget("CheckBox", parent, SL(53909),"", nil, function()  return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[21]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[21] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon21:SetPoint("TOPLEFT", menu.showIcon20, "TOPRIGHT", 0, 0)

--파괴불가능SL(53762)
	menu.showIcon22 = LBO:CreateWidget("CheckBox", parent, SL(53762),"", nil, function()  return not (IRF3.db.units.useSurvivalSkill and IRF3.db.units.showSurvivalAsSpellTimer) end, true,
		function()
			return IRF3.db.units.showSurvivalAsSpellIcon[22]
		end,
		function(v)
			IRF3.db.units.showSurvivalAsSpellIcon[22] = v
			IRF3:BuildSpellTimerList()			
			LBO:Refresh(parent)
			Option:UpdateMember(update)

		end
	)
	menu.showIcon22:SetPoint("TOPLEFT", menu.showIcon21, "TOPRIGHT", 0, 0)


end

function Option:CreateHealPredictionMenu(menu, parent)



	local function update(member)
		member.myHealPredictionBar:SetStatusBarColor(IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		member.myHoTPredictionBar:SetStatusBarColor(IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		member.otherHealPredictionBar:SetStatusBarColor(IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		member.otherHoTPredictionBar:SetStatusBarColor(IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3], IRF3.db.units.healPredictionAlpha)
		member.absorbPredictionBar:SetStatusBarColor(IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3], IRF3.db.units.healPredictionAlpha)

		if IRF3.db.units.AbsorbInClassictype ==2 then--우측바
			if (self.overAbsorb or 0 )>0 then 	member.overAbsorbGlow:Show() end
			if member.outlineAbsorb then
			member.outlineAbsorb:Hide()
			member.outlineAbsorb:SetAlpha(0)
			end
		elseif IRF3.db.units.AbsorbInClassictype ==3 then --테두리
			member.overAbsorbGlow:Hide()
			if member.outlineAbsorb and  (self.overAbsorb  or 0)>0 then 
			member.outlineAbsorb:Show()
			member.outlineAbsorb:SetAlpha(1)
			end
		else
			member.overAbsorbGlow:Hide()
			if member.outlineAbsorb then
			member.outlineAbsorb:Hide()
			member.outlineAbsorb:SetAlpha(0)
			end
		end


		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateHealPrediction(member)
		end
		if member.petButton then
			update(member.petButton)
		end


	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["lime_func2_5"], L["lime_func2_desc_5"], nil, nil, true,
		function()

			return IRF3.db.units.displayHealPrediction
		end,
		function(v)

			IRF3.db.units.displayHealPrediction = v
			LBO:Refresh(parent)
			Option:UpdateMember(update)
			IRF3:SetupLib()
			
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -5)

	local function disable()
		return not IRF3.db.units.displayHealPrediction
	end
	menu.alpha = LBO:CreateWidget("Slider", parent, L["lime_func2_6"].."(%)", L["lime_func2_desc_6"], nil, disable, true,
		function() return IRF3.db.units.healPredictionAlpha * 100, 0, 100, 1  end,
		function(v)
			IRF3.db.units.healPredictionAlpha = v / 100
			Option:UpdateMember(update)
		end
	)
	menu.alpha:SetPoint("TOPRIGHT", -5, -5)

-----치유 아이콘 제거(직접힐/hot 분기로 인해 가시성확보용)
	menu.myIcon = LBO:CreateWidget("CheckBox", parent, L["lime_func2_7"], L["lime_func2_desc_7"], nil, disable, true,
		function() return IRF3.db.units.healIcon end,
		function(v)
			IRF3.db.units.healIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.myIcon:SetPoint("TOP", menu.use, "BOTTOM", 0, 0)

	menu.otherIcon = LBO:CreateWidget("CheckBox", parent, L["lime_func2_8"], L["lime_func2_desc_8"], nil, disable, true,
		function() return IRF3.db.units.healIconOther end,
		function(v)
			IRF3.db.units.healIconOther = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.otherIcon:SetPoint("TOP", menu.alpha, "BOTTOM", 0, 0)


	menu.pos = LBO:CreateWidget("DropDown", parent, L["lime_func2_9"], L["lime_func2_desc_9"], nil, disable2, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.healIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.healIconPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOP", menu.myIcon, "BOTTOM", 0, 0)

	menu.size = LBO:CreateWidget("Slider", parent, L["lime_func2_10"].."(".. L["픽셀"] ..")", L["lime_func2_desc_10"], nil, disable2, true,
		function()
			return IRF3.db.units.healIconSize, 8, 20, 1 
		end,
		function(v)
			IRF3.db.units.healIconSize = v
			Option:UpdateMember(update)
		end
	)
menu.size:SetPoint("TOP", menu.otherIcon, "BOTTOM", 0, 0)

--[[
	menu.showhealers = LBO:CreateWidget("CheckBox", parent, L["lime_func2_18"], L["lime_func2_desc_18"], nil, disable, true,
		function() return IRF3.db.units.showhealers end,
		function(v)
			IRF3.db.units.showhealers = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.showhealers:SetPoint("TOP", menu.pos, "BOTTOM", 0, 0)
]]--

-----치유 아이콘 제거

	local function disable2()
		if disable() then
			return true
		else
			return not(IRF3.db.units.healIcon or IRF3.db.units.healIconOther)
		end
	end


	menu.myColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func2_11"], L["lime_func2_desc_11"] , nil, disable, true,
		function() return IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3] end,
		function(r, g, b)
			IRF3.db.units.myHealPredictionColor[1], IRF3.db.units.myHealPredictionColor[2], IRF3.db.units.myHealPredictionColor[3] = r, g, b
			Option:UpdateMember(update)
		end
	)
	menu.myColor:SetPoint("TOP", menu.pos, "BOTTOM", 0, 0)

	menu.otherColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func2_12"], L["lime_func2_desc_12"], nil, disable, true,
		function() return IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3] end,
		function(r, g, b)
			IRF3.db.units.otherHealPredictionColor[1], IRF3.db.units.otherHealPredictionColor[2], IRF3.db.units.otherHealPredictionColor[3] = r, g, b
			Option:UpdateMember(update)
		end
	)
	menu.otherColor:SetPoint("TOP", menu.myColor, "TOP", 0, 0)
	menu.otherColor:SetPoint("LEFT", menu.size, "LEFT", 0, 0)

---HOT---
	menu.myHoTColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func2_14"], L["lime_func2_desc_14"], nil, disable, true,
		function() return IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3] end,
		function(r, g, b)
			IRF3.db.units.myHoTPredictionColor[1], IRF3.db.units.myHoTPredictionColor[2], IRF3.db.units.myHoTPredictionColor[3] = r, g, b
			Option:UpdateMember(update)
		end
	)
	menu.myHoTColor:SetPoint("TOP", menu.myColor, "BOTTOM", 0, 0)

	menu.otherHoTColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func2_15"], L["lime_func2_desc_15"], nil, disable, true,
		function() return IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3] end,
		function(r, g, b)
			IRF3.db.units.otherHoTPredictionColor[1], IRF3.db.units.otherHoTPredictionColor[2], IRF3.db.units.otherHoTPredictionColor[3] = r, g, b

			Option:UpdateMember(update)

		end
	)
	menu.otherHoTColor:SetPoint("TOP", menu.otherColor, "BOTTOM", 0, 0)

-------
	menu.AbsorbColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func2_13"] , L["lime_func2_desc_13"], nil, disable, true,
		function() return IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3] end,
		function(r, g, b)
			IRF3.db.units.AbsorbPredictionColor[1], IRF3.db.units.AbsorbPredictionColor[2], IRF3.db.units.AbsorbPredictionColor[3] = r, g, b
			Option:UpdateMember(update)
		end
	)
	menu.AbsorbColor:SetPoint("TOP", menu.myHoTColor, "BOTTOM", 0, 0)


	menu.useAbsorbInClassic = LBO:CreateWidget("CheckBox", parent, L["lime_func2_19"], L["lime_func2_desc_19"], nil, disable, true,
		function()

			return IRF3.db.units.useAbsorbInClassic
		end,
		function(v)

			IRF3.db.units.useAbsorbInClassic = v
			LBO:Refresh(parent)
			Option:UpdateMember(update)
			IRF3:SetupLib()
			
		end
	)
	menu.useAbsorbInClassic:SetPoint("TOP", menu.otherHoTColor,"BOTTOM",0,0)
	local typeList = { L["사용 안함"],L["우측바"],L["외곽선"] }
	menu.AbsorbInClassictype = LBO:CreateWidget("DropDown", parent, L["lime_func2_20"] , L["lime_func2_desc_20"], nil, disable, true,
		function()
			return IRF3.db.units.AbsorbInClassictype, typeList
		end,
		function(v)
			IRF3.db.units.AbsorbInClassictype = v
			Option:UpdateMember(update)

		end
	)
	menu.AbsorbInClassictype:SetPoint("TOPLEFT", menu.useAbsorbInClassic, "BOTTOMLEFT", 0, 0)

 
	menu.library1 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	menu.library1:SetText(L["lime_func2_desc_16"])
	menu.library1:SetPoint("TOPLEFT", menu.AbsorbColor,"BOTTOMLEFT" , 0,-60)

	menu.library2 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	menu.library2:SetText(L["lime_func2_desc_17"] )
	menu.library2:SetPoint("TOPLEFT", menu.library1,"BOTTOMLEFT" , 0)

end

function Option:CreateIgnoreAuraMenu(menu, parent)
	local debuffs = {}
	menu.list = LBO:CreateWidget("List", parent, L["lime_func_aura_1"], nil, nil, nil, true,
		function()
			wipe(debuffs)
			for debuff in pairs(IRF3.ignoreAura) do
				if IRF3.db.ignoreAura[debuff] ~= false then
					local text = ("%s(%d)"):format(GetSpellInfo(debuff) or "", debuff)
					tinsert(debuffs, text)
				end
			end
			for debuff, v in pairs(IRF3.db.ignoreAura) do
				if v == true then
					if IRF3.ignoreAura[debuff] then
						IRF3.db.ignoreAura[debuff] = nil
					else
						local text
						if type(debuff) == "number" then
							text = ("%s(%d)"):format(GetSpellInfo(debuff) or "", debuff)
						else
							text = debuff
						end
						tinsert(debuffs, text)
					end
				end
			end
			sort(debuffs)
			return debuffs, true
		end,
		function(v)
			menu.delete:Update()
		end
	)
	menu.list:SetPoint("TOPLEFT", 5, -5)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateAura(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Pet_UpdateDebuffs(member.petButton)
			end
		end
	end
	menu.delete = LBO:CreateWidget("Button", parent, L["lime_func_aura_2"], L["lime_func_aura_3"], nil,
		function()
			if menu.list:GetValue() then
				menu.delete.title:SetFormattedText(L["lime_func_aura_4"], debuffs[menu.list:GetValue()])
				return nil
			else
				menu.delete.title:SetText(L["lime_func_aura_2"] )
				return true
			end
		end, nil,
		function()
			local name = debuffs[menu.list:GetValue()]
			IRF3:Message((L["lime_func_aura_5"]):format(name))
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end
			if IRF3.ignoreAura[name] then
				IRF3.db.ignoreAura[name] = false
			else
				IRF3.db.ignoreAura[name] = nil
			end
			menu.list:Setup()
			menu.reset:Update()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
		end
	)
	menu.delete:SetPoint("TOPLEFT", menu.list, "BOTTOMLEFT", 0, 12)
	menu.delete:SetPoint("TOPRIGHT", menu.list, "BOTTOMRIGHT", 0, 12)
	menu.editbox = LBO:CreateEditBox(parent, nil, "ChatFontNormal", nil, true)
	menu.editbox:SetPoint("TOPLEFT", menu.delete, "BOTTOMLEFT", 2, 6)
	menu.editbox:SetPoint("TOPRIGHT", menu.delete, "BOTTOMRIGHT", -60, 6)
	menu.editbox:SetScript("OnTextChanged", function() menu.add:Update() end)
	menu.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
	end)
	local function add()
		local text = (menu.editbox:GetText() or ""):trim()
		local spell
		if tonumber(text) then
			spell = tonumber(text)
			text = GetSpellInfo(text) or nil
		else
			spell = text
		end
		menu.editbox:SetText("")
		menu.editbox:ClearFocus()
		if not text then
			IRF3:Message((L["lime_func_aura_6"]):format(spell))
		elseif IRF3.db.ignoreAura[spell] or IRF3.db.ignoreAura[text] or (IRF3.ignoreAura[spell] and IRF3.db.ignoreAura[spell] ~= false) or (IRF3.ignoreAura[text] and IRF3.db.ignoreAura[text] ~= false) then
			IRF3:Message((L["lime_func_aura_7"]):format(text))
		else
			IRF3:Message((L["lime_func_aura_8"]):format(text))
			if IRF3.ignoreAura[spell] then
				IRF3.db.ignoreAura[spell] = nil
			else
				IRF3.db.ignoreAura[spell] = true
			end
			menu.list:Setup()
			menu.reset:Update()
			menu.delete:Update()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
		end
	end
	menu.editbox:SetScript("OnEnterPressed", function(self)
		if (self:GetText() or ""):trim() ~= "" then
			add()
		else
			self:SetText("")
			self:ClearFocus()
		end
	end)
	menu.add = LBO:CreateWidget("Button", parent, L["lime_func_aura_9"], L["lime_func_aura_10"], nil, function() return (menu.editbox:GetText() or ""):trim() == "" end, true, add)
	menu.add:SetPoint("TOPLEFT", menu.editbox, "TOPRIGHT", 2, 14)
	menu.add:SetPoint("RIGHT", menu.delete, "RIGHT", 0, 0)
	menu.reset = LBO:CreateWidget("Button", parent, L["lime_func_aura_11"], L["lime_func_aura_12"], nil, function() return not next(IRF3.db.ignoreAura) end, true,
		function()
			menu.editbox:SetText("")
			menu.editbox:ClearFocus()
			wipe(IRF3.db.ignoreAura)
			menu.list:Setup()
			menu.reset:Update()
			menu.delete:Update()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
			IRF3:Message(L["lime_func_aura_13"])
		end
	)
	menu.reset:SetPoint("TOP", menu.add, "BOTTOM", 0, 18)
	menu.reset:SetPoint("LEFT", menu.delete, "LEFT", 0, 0)
	menu.reset:SetPoint("RIGHT", menu.delete, "RIGHT", 0, 0)
end

function Option:CreateDebuffIconMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			
			InvenRaidFrames3Member_UpdateAura(member)
			InvenRaidFrames3Member_SetAuraFont(member)
		end
	end
	menu.num = LBO:CreateWidget("Slider", parent, L["lime_func_aura_14"] , L["lime_func_aura_15"], nil, disable, true,
		function()
			return IRF3.db.units.debuffIcon, 0, 10, 1 
		end,
		function(v)
			IRF3.db.units.debuffIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.num:SetPoint("TOPLEFT", 5, -5)
	local function disable()
		return IRF3.db.units.debuffIcon == 0
	end
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_aura_16"], nil, disable, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.debuffIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.debuffIconPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOPRIGHT", -5, -5)
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_aura_17"], nil, disable, true,
		function()
			return IRF3.db.units.debuffIconSize, 4, 20, 1 
		end,
		function(v)
			IRF3.db.units.debuffIconSize = v
			Option:UpdateMember(update)
		end
	)
	menu.size:SetPoint("TOP", menu.num, "BOTTOM", 0, -10)



	local typeList = { L["lime_func_button_27"], L["lime_func_button_23"], L["색상"] }
	menu.type = LBO:CreateWidget("DropDown", parent, L["lime_func_aura_18"], L["lime_func_aura_19"], nil, disable, true,
		function()
			return IRF3.db.units.debuffIconType, typeList
		end,
		function(v)
			IRF3.db.units.debuffIconType = v
--			Option:UpdateMember(IRF3.headers[0].members[1].SetupDebuffIcon)
--			Option:UpdateMember(IRF3.tankheaders.members[1].SetupDebuffIcon)
			Option:UpdateMember(update)

		end
	)
	menu.type:SetPoint("TOP", menu.pos, "BOTTOM", 0, -10)




	menu.fontsize = LBO:CreateWidget("Slider", parent, L["글꼴"]..L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_26_3"], nil, disable, true,
		function()
			return IRF3.db.units.debuffIconFontSize, 4, 20, 1 
		end,
		function(v)
			IRF3.db.units.debuffIconFontSize = v
			Option:UpdateMember(update)
		end
	)
	menu.fontsize:SetPoint("TOP", menu.size, "BOTTOM", 0, 0)


	local timertypeList = { L["lime_func_aura_39"], L["lime_func_button_29"] }
	menu.timertype = LBO:CreateWidget("DropDown", parent, L["lime_func_aura_18_1"], L["lime_func_aura_19_1"], nil, disable, true,
		function()
			return IRF3.db.units.debuffIconTimerType, timertypeList
		end,
		function(v)
			IRF3.db.units.debuffIconTimerType = v
			Option:UpdateMember(IRF3.headers[0].members[1].SetupDebuffIcon)
			Option:UpdateMember(IRF3.tankheaders.members[1].SetupDebuffIcon)
		end
	)
	menu.timertype:SetPoint("TOP", menu.type, "BOTTOM", 0, 0)

	local function getDebuff(debuff)
		return IRF3.db.units.debuffIconFilter[debuff]
	end
	local function setDebuff(v, debuff)
		IRF3.db.units.debuffIconFilter[debuff] = v
		Option:UpdateMember(update)
	end
	local colorList = { "Magic", "Curse", "Disease", "Poison", "none" }
	local colorLocale = { L["마법"], L["저주"], L["질병"], L["독"], L["무속성"] }
	for i, color in ipairs(colorList) do
		menu["color"..i] = LBO:CreateWidget("CheckBox", parent, colorLocale[i]..L["lime_func_aura_20"], colorLocale[i]..L["lime_func_aura_21"], nil, disable, true, getDebuff, setDebuff, color)
		if i == 1 then
			menu["color"..i]:SetPoint("TOP", menu.fontsize, "BOTTOM", 0, 0)
		elseif i == 2 then
			menu["color"..i]:SetPoint("TOP", menu.color1, 0, 0)
			menu["color"..i]:SetPoint("RIGHT", -5, 0)
		else
			menu["color"..i]:SetPoint("TOP", menu["color"..(i - 2)], "BOTTOM", 0, 14)
		end
	end

 

end

function Option:CreateDebuffHealthMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateState(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Member_UpdateState(member.petButton)
			end
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_22"], L["lime_func_aura_23"], nil, nil, true,
		function()
			return IRF3.db.units.useDispelColor
		end,
		function(v)
			IRF3.db.units.useDispelColor = v
			Option:UpdateMember(update)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -5)
	menu.sound = LBO:CreateWidget("Media", parent, L["lime_func_aura_24"], L["lime_func_aura_25"], nil, nil, true,
		function()
			return IRF3.db.units.dispelSound, "sound"
		end,
		function(v)
			IRF3.db.units.dispelSound = v
		end
	)
	menu.sound:SetPoint("TOPRIGHT", -5, -5)
end

function Option:CreateBossAuraMenu(menu, parent)
	local debuffs = {}

	menu.use = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_33"], L["lime_func_aura_34"], nil, nil, true,
		function() return IRF3.db.units.useBossAura end,
		function(v)
			IRF3.db.units.useBossAura = v
			Option:UpdateMember(update)
			menu.pos:Update()
			menu.size:Update()
			menu.alpha:Update()
			menu.timer:Update()
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -5)

	menu.timer = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_39"], L["lime_func_aura_40"], nil, disable, true,
		function()
			return IRF3.db.units.bossAuraTimer
		end,
		function(v)
			IRF3.db.units.bossAuraTimer = v
			Option:UpdateMember(update)
		end
	)
	menu.timer:SetPoint("TOPLEFT", menu.use, "TOPRIGHT", 20, 0)


	local function disable()
		return not IRF3.db.units.useBossAura
	end
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_aura_35"], nil, disable, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.bossAuraPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.bossAuraPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOPLEFT", menu.use, "BOTTOMLEFT", 0, -10)

	local timerTypes = { L["lime_func_button_17"], L["lime_func_button_24"], L["lime_func_button_26"] }
	menu.timerType = LBO:CreateWidget("DropDown", parent, L["lime_func_aura_41"], L["lime_func_aura_42"], nil, disable, true,
		function()
			return IRF3.db.units.bossAuraOpt + 1, timerTypes
		end,
		function(v)
			IRF3.db.units.bossAuraOpt = v - 1
			Option:UpdateIconPos()
			Option:UpdateMember(update)
		end
	)
	menu.timerType:SetPoint("TOPLEFT", menu.pos, "TOPRIGHT", 20, 0)


	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_aura_36"], nil, disable, true,
		function()
			return IRF3.db.units.bossAuraSize, 8, 60, 1 
		end,
		function(v)
			IRF3.db.units.bossAuraSize = v
			Option:UpdateMember(update)
		end
	)
	menu.size:SetPoint("TOPLEFT", menu.pos, "BOTTOMLEFT", 0, -10)

	local function updateAlpha(member)
		member.bossAura:SetAlpha(IRF3.db.units.bossAuraAlpha)
	end
	menu.alpha = LBO:CreateWidget("Slider", parent, L["lime_func_aura_37"].."(%)", L["lime_func_aura_38"], nil, disable, true,
		function()
			return IRF3.db.units.bossAuraAlpha * 100, 0, 100, 1 
		end,
		function(v)
			IRF3.db.units.bossAuraAlpha = v / 100
			Option:UpdateMember(updateAlpha)
		end
	)
	menu.alpha:SetPoint("TOPLEFT", menu.size, "TOPRIGHT", 20, 0)
	
	


--------------
	menu.list = LBO:CreateWidget("List", parent, L["lime_func_aura_26"], nil, nil, nil, true,
		function()
			wipe(debuffs)
			for debuff in pairs(IRF3.bossAura) do
				if IRF3.db.userAura[debuff] ~= false then
					local text = ("%s(%d)"):format(GetSpellInfo(debuff) or "", debuff)
				        tinsert(debuffs, text)
				end
			end
			for debuff, v in pairs(IRF3.db.userAura) do
				if v == true then
					if IRF3.bossAura[debuff] then
						IRF3.db.userAura[debuff] = nil
					else
						local text
						if type(debuff) == "number" then
							text = ("%s(%d)"):format(GetSpellInfo(debuff) or "", debuff)
						else
							text = debuff
						end
						if type(text) == "string" then
              tinsert(debuffs, text)
						end
					end
				end
			end
			sort(debuffs)
			return debuffs, true
		end,
		function(v)
			menu.delete:Update()
			menu.enableglow:Update()
			menu.glowColor:Update()
			menu.useeachbossAura:Update()
			menu.bossAuraAlertTimer:Update()
			menu.bossAuraSize:Update()
			menu.bossAuraAlpha:Update()
		end
	)
	menu.list:SetPoint("TOPLEFT", menu.size,"BOTTOMLEFT" , 0, -30)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_SetAuraFont(member)
			InvenRaidFrames3Member_UpdateAura(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Member_UpdateAura(member.petButton)
			end
		end
	end
--Edit box , Add
	local function add()
		local text = (menu.editbox:GetText() or ""):trim()
		local spell
		if tonumber(text) then
			spell = tonumber(text)
			text = GetSpellInfo(text) or nil
		else
			spell = text
		end
		menu.editbox:SetText("")
		menu.editbox:ClearFocus()
		if not text then
			IRF3:Message((L["lime_func_aura_28"]):format(spell))
		elseif IRF3.db.userAura[spell] or IRF3.db.userAura[spell] or (IRF3.bossAura[spell] and IRF3.db.userAura[spell] ~= false) or (IRF3.bossAura[text] and IRF3.db.userAura[text] ~= false) then
			IRF3:Message((L["lime_func_aura_29"]):format(text))
		else
			IRF3:Message((L["lime_func_aura_30"]):format(text))
			if IRF3.bossAura[spell] then
				IRF3.db.userAura[spell] = nil
			else
				IRF3.db.userAura[spell] = true
			end
			menu.list:Setup()
			menu.reset:Update()
			menu.delete:Update()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
		end
	end

	menu.editbox = LBO:CreateEditBox(parent, nil, "ChatFontNormal", nil, true)
	menu.editbox:SetPoint("TOPLEFT", menu.list, "BOTTOMLEFT", 2, -30)
	menu.editbox:SetPoint("TOPRIGHT", menu.list, "BOTTOMRIGHT", -60, -30)
	menu.editbox:SetScript("OnTextChanged", function() menu.add:Update() end)
	menu.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
	end)
	menu.editbox:SetScript("OnEnterPressed", function(self)
		if (self:GetText() or ""):trim() ~= "" then
			add()
		else
			self:SetText("")
			self:ClearFocus()
		end
	end)

	menu.add = LBO:CreateWidget("Button", parent, L["lime_func_aura_9"], L["lime_func_aura_10"], nil, function() return (menu.editbox:GetText() or ""):trim() == "" end, true, add)
	menu.add:SetPoint("TOPLEFT", menu.editbox, "TOPRIGHT", 2, 14)
	menu.add:SetPoint("RIGHT", menu.list, "RIGHT", 0, 0)


---Glow 효과
	menu.enableglow = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_10_13"], L["lime_func_aura_10_14"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not name end, true,
		function()
			local name = debuffs[menu.list:GetValue()]
	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end
			return IRF3.db.userAuraGlow[name]
	end
		end,
		function(v)

			local name = debuffs[menu.list:GetValue()]

	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			IRF3.db.userAuraGlow[name] = v
	end
		 	LBO:Refresh(parent)
		end
	)
	menu.enableglow:SetPoint("TOPLEFT", menu.list, "TOPRIGHT", 10, 0)

--Glow효과 색상
	menu.glowColor = LBO:CreateWidget("ColorPicker", parent, L["lime_func_aura_10_15"], L["lime_func_aura_10_16"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not IRF3.db.userAuraGlow[name] end, true,
		function() 
		local name = debuffs[menu.list:GetValue()]
if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

		if  IRF3.db.userAuraGlowColorR[name] and IRF3.db.userAuraGlowColorG[name] and IRF3.db.userAuraGlowColorB[name] then
			return IRF3.db.userAuraGlowColorR[name], IRF3.db.userAuraGlowColorG[name], IRF3.db.userAuraGlowColorB[name] 
		else --값이 없을때, alpha혼선을 위해 기본값 리턴
			return 1,0.25,0 
		end
end
		end,
		function(r, g, b)

		local name = debuffs[menu.list:GetValue()]  
			--주문ID로 등록된 경우 숫자만 발췌
if name then
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end


		IRF3.db.userAuraGlowColorR[name], IRF3.db.userAuraGlowColorG[name], IRF3.db.userAuraGlowColorB[name] = r, g, b

		end
end
	)

	menu.glowColor:SetPoint("TOPLEFT", menu.enableglow, "BOTTOMLEFT", 0, 18)



--개별 아이콘 사용 여부 지정
menu.useeachbossAura = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_10_1"], L["lime_func_aura_10_2"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not name end, true,
		function()
			local name = debuffs[menu.list:GetValue()]
	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end
			return IRF3.db.useeachbossAura[name]
	end
		end,
		function(v)

			local name = debuffs[menu.list:GetValue()]

	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			IRF3.db.useeachbossAura[name] = v
	end
		 	LBO:Refresh(parent)
		end
	)
	menu.useeachbossAura:SetPoint("TOPLEFT", menu.glowColor, "BOTTOMLEFT", 0, 18)

--폰트 강조시간 지정
	menu.bossAuraAlertTimer = LBO:CreateWidget("Slider", parent, L["lime_func_aura_10_3"], L["lime_func_aura_10_4"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not IRF3.db.useeachbossAura[name] end, true,
	    	      
		function()
			local name = debuffs[menu.list:GetValue()]
	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			return (IRF3.db.bossAuraAlertTimer[name] or 0), 0, 100, 1, ""
			
	end
		end,
		function(v)

			local name = debuffs[menu.list:GetValue()]

	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			IRF3.db.bossAuraAlertTimer[name] = v
	end
		 	Option:UpdateMember(update)
		end
	)
	menu.bossAuraAlertTimer:SetPoint("TOPLEFT", menu.useeachbossAura, "BOTTOMLEFT", 0, 0)

--개별 아이콘 사이즈
 
-----
	menu.bossAuraSize = LBO:CreateWidget("Slider", parent, L["lime_func_aura_10_5"].."(".. L["픽셀"] ..")", L["lime_func_aura_10_6"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not IRF3.db.useeachbossAura[name] end, true,
	    	      
		function()
			local name = debuffs[menu.list:GetValue()]
	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			return (IRF3.db.bossAuraSize1[name] or IRF3.db.units.bossAuraSize or 18), 8, 60, 1 

	end
		end,
		function(v)

			local name = debuffs[menu.list:GetValue()]

	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			IRF3.db.bossAuraSize1[name] = v


	end
		 	Option:UpdateMember(update)
		end
	)
	menu.bossAuraSize:SetPoint("TOP", menu.bossAuraAlertTimer, "BOTTOM", 0, 0)


---개별 투명도 --

  

	menu.bossAuraAlpha = LBO:CreateWidget("Slider", parent, L["lime_func_aura_10_7"].."(%)", L["lime_func_aura_10_8"], nil, function() local name = debuffs[menu.list:GetValue()] if name then for spellId in string.gmatch(name, "%d+") do name = tonumber(spellId) end end  return not IRF3.db.useeachbossAura[name] end, true,
	    	      
		function()
			local name = debuffs[menu.list:GetValue()]
	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			return (IRF3.db.bossAuraAlpha1[name] or IRF3.db.units.bossAuraAlpha or 1) * 100 ,0,100,1

	end
		end,
		function(v)

			local name = debuffs[menu.list:GetValue()]

	if name then
			--주문ID로 등록된 경우 숫자만 발췌
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end

			IRF3.db.bossAuraAlpha1[name] = v / 100


	end
		 	Option:UpdateMember(update)
		end
	)
	menu.bossAuraAlpha:SetPoint("TOP", menu.bossAuraSize, "BOTTOM", 0, 0)

----



---


 
---Delete
	menu.delete = LBO:CreateWidget("Button", parent, L["lime_func_aura_2"], L["lime_func_aura_3"], nil,
		function()
			if menu.list:GetValue() then
				menu.delete.title:SetFormattedText(L["lime_func_aura_4"] , debuffs[menu.list:GetValue()])
				return nil
			else
				menu.delete.title:SetText(L["lime_func_aura_2"])
				return true
			end
		end, nil,
		function()
			local name = debuffs[menu.list:GetValue()]
			IRF3:Message((L["lime_func_aura_27"]):format(name))
			for spellId in string.gmatch(name, "%d+") do
				name = tonumber(spellId)
			end
			IRF3.db.userAura[name] = false 
			IRF3.db.userAuraGlow[name] = false

			menu.reset:Update()
			menu.list:Setup()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
		end
	)

--	menu.delete:SetPoint("TOPLEFT", menu.add, "TOPRIGHT", 10, 0)
	menu.delete:SetPoint("BOTTOMLEFT", menu.editbox, "TOPLEFT", 0, -5)
	menu.delete:SetWidth(180)


--Reset
	menu.reset = LBO:CreateWidget("Button", parent, L["lime_func_aura_11"], L["lime_func_aura_31"], nil, function() return not next(IRF3.db.userAura) end, true,
		function()

			StaticPopupDialogs["IRFPROFILE"] = {
			text = L["lime_func_aura_47"],
			button1="Yes", button2="No", timeout=30, whileDead=1, showAlert=enable, hideOnEscape=1,
			OnAccept=function()   
			menu.editbox:SetText("")
			menu.editbox:ClearFocus()
			wipe(IRF3.db.userAura)
			menu.list:Setup()
			menu.reset:Update()
			menu.delete:Update()
			IRF3:BuildAuraList()
			Option:UpdateMember(update)
			IRF3:Message(L["lime_func_aura_32"])
			 end,
			OnCancel=function()   end
			}
			StaticPopup_Show("IRFPROFILE")



		end
	)
	menu.reset:SetPoint("TOPLEFT", menu.editbox, "TOPLEFT", 0, -10)
	menu.reset:SetWidth(180)
	 


----


end

function Option:CreateEnemyMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateState(member)
			if member.petButton and member.petButton:IsVisible() then
				InvenRaidFrames3Member_UpdateState(member.petButton)
			end
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_14"], nil, nil, true,
		function() return IRF3.db.units.useHarm end,
		function(v)
			IRF3.db.units.useHarm = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 5)
	menu.color = LBO:CreateWidget("ColorPicker", parent, L["색상"], L["lime_func_other_15"], nil, function() return not IRF3.db.units.useHarm end, true,
		function()
			return IRF3.db.colors.harm[1], IRF3.db.colors.harm[2], IRF3.db.colors.harm[3]
		end,
		function(r, g, b)
			IRF3.db.colors.harm[1], IRF3.db.colors.harm[2], IRF3.db.colors.harm[3] = r, g, b
			Option:UpdateMember(update)
		end
	)
	menu.color:SetPoint("TOPRIGHT", -5, 5)
end

function Option:CreateRaidTargetMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateRaidIcon(member)
			InvenRaidFrames3Member_UpdateRaidIconTarget(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_16"], nil, nil, true,
		function()
			return IRF3.db.units.useRaidIcon
		end,
		function(v)
			IRF3.db.units.useRaidIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 5)
	local function disable()
		return not IRF3.db.units.useRaidIcon
	end
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_other_17"], nil, disable, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.raidIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.raidIconPos = Option.dropdownTable["아이콘변환"][v]

			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOP", menu.use, "BOTTOM", 0, 10)
	menu.scale = LBO:CreateWidget("Slider", parent, L["lime_func_other_18"].."(".. L["픽셀"] ..")", L["lime_func_other_19"], nil, disable, true,
		function()
			return IRF3.db.units.raidIconSize, 8, 60, 1 
		end,
		function(v)
			IRF3.db.units.raidIconSize = v
			Option:UpdateMember(update)
		end
	)
	menu.scale:SetPoint("TOP", menu.pos, "TOP", 0, 0)
	menu.scale:SetPoint("RIGHT", -5, 0)
	menu.target = LBO:CreateWidget("CheckBox", parent, L["lime_func_other_20"], L["lime_func_other_21"], nil, disable, true,
		function()
			return IRF3.db.units.raidIconTarget
		end,
		function(v)
			IRF3.db.units.raidIconTarget = v
			Option:UpdateMember(update)
		end
	)
	menu.target:SetPoint("TOP", menu.pos, "BOTTOM", 0, -5)
	local function get(id)
		return IRF3.db.units.raidIconFilter[id]
	end
	local function set(v, id)
		IRF3.db.units.raidIconFilter[id] = v
		Option:UpdateMember(update)
	end
	for i, icon in ipairs(self.dropdownTable["징표"]) do
		menu["icon"..i] = LBO:CreateWidget("CheckBox", parent, icon..L["lime_func_aura_20"], icon..L["lime_func_other_22"], nil, disable, true, get, set, i)
		if i == 1 then
			menu.icon1:SetPoint("TOP", menu.target, "BOTTOM", 0, 0)
		elseif i == 2 then
			menu.icon2:SetPoint("TOP", menu.icon1, "TOP", 0, 0)
			menu.icon2:SetPoint("RIGHT", -5, 0)
		else
			menu["icon"..i]:SetPoint("TOP", menu["icon"..(i - 2)], "BOTTOM", 0, 15)
		end
	end
end

function Option:CreateCastingBarMenu(menu, parent)
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
	local function update(member)
		if member:IsVisible() then

			if IRF3.db.units.useCastingBar then
				key=getUnitPetOrOwner(member.unit)
				member:RegisterUnitEvent("UNIT_SPELLCAST_START", member.unit , key)
				member:RegisterUnitEvent("UNIT_SPELLCAST_STOP", member.unit, key)
				member:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", member.unit, key)
				member:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", member.unit, key)
				member:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", member.unit, key)
				member:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", member.unit, key)
				InvenRaidFrames3Member_UpdateCastingBar(member)

			else
				member:UnregisterEvent("UNIT_SPELLCAST_START")
				member:UnregisterEvent("UNIT_SPELLCAST_STOP")
				member:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
				member:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
				member:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
				member:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

			end

		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_23"], nil, nil, true,
		function()
			return IRF3.db.units.useCastingBar
		end,
		function(v)
			IRF3.db.units.useCastingBar = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 5)
	local disable = function() return not IRF3.db.units.useCastingBar end
	local function updateColor(member)
		member.castingBar:SetStatusBarColor(IRF3.db.units.castingBarColor[1], IRF3.db.units.castingBarColor[2], IRF3.db.units.castingBarColor[3])
	end
	menu.color = LBO:CreateWidget("ColorPicker", parent, L["색상"], L["lime_func_other_24"], nil, disable, true,
		function()
			return IRF3.db.units.castingBarColor[1], IRF3.db.units.castingBarColor[2], IRF3.db.units.castingBarColor[3]
		end,
		function(r, g, b)
			IRF3.db.units.castingBarColor[1], IRF3.db.units.castingBarColor[2], IRF3.db.units.castingBarColor[3] = r, g, b
			Option:UpdateMember(updateColor)
		end
	)
	menu.color:SetPoint("TOPRIGHT", -5, 5)
	local posList = { L["상단"], L["하단"], L["좌측"], L["우측"] }
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_other_25"], nil, disable, true,
		function()
			return IRF3.db.units.castingBarPos, posList
		end,
		function(v)
			IRF3.db.units.castingBarPos = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupCastingBarPos)
		end
	)
	menu.pos:SetPoint("TOP", menu.use, "BOTTOM", 0, 0)
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_26"], nil, disable, true,
		function()
			return IRF3.db.units.castingBarHeight, 1, 20, 1 
		end,
		function(v)
			IRF3.db.units.castingBarHeight = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupCastingBarPos)
		end
	)
	menu.size:SetPoint("TOP", menu.color, "BOTTOM", 0, 0)

	menu.showicon = LBO:CreateWidget("CheckBox", parent, L["lime_func_other_26_1"] , L["lime_func_other_26_2"] , nil, disable, true,
		function()
			return IRF3.db.units.useCastingBarIcon
		end,
		function(v)
			IRF3.db.units.useCastingBarIcon = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupCastingBarPos)
		end
	)
	menu.showicon:SetPoint("TOPLEFT", menu.pos,"BOTTOMLEFT", 5, 5)


	menu.fontsize = LBO:CreateWidget("Slider", parent, L["글꼴"]..L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_26_3"], nil, disable, true,
		function()
			return IRF3.db.units.castingBarFontSize, 5, 20, 1 
		end,
		function(v)
			IRF3.db.units.castingBarFontSize = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupCastingBarPos)
		end
	)
	menu.fontsize:SetPoint("TOP", menu.size, "BOTTOM", 0, 0)


end

function Option:CreatePowerBarAltMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdatePowerBarAlt(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_27"], nil, nil, true,
		function()
			return IRF3.db.units.usePowerBarAlt
		end,
		function(v)
			IRF3.db.units.usePowerBarAlt = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 5)
	local disable = function() return not IRF3.db.units.usePowerBarAlt end
	local posList = { L["상단"], L["하단"], L["좌측"], L["우측"] }
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_other_28"], nil, disable, true,
		function()
			return IRF3.db.units.powerBarAltPos, posList
		end,
		function(v)
			IRF3.db.units.powerBarAltPos = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupPowerBarAltPos)
		end
	)
	menu.pos:SetPoint("TOP", menu.use, "BOTTOM", 0, 0)
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_29"], nil, disable, true,
		function()
			return IRF3.db.units.powerBarAltHeight, 1, 5, 1 
		end,
		function(v)
			IRF3.db.units.powerBarAltHeight = v
			Option:UpdateMember(InvenRaidFrames3Member_SetupPowerBarAltPos)
		end
	)
	menu.size:SetPoint("TOP", menu.pos, "TOP", 0, 0)
	menu.size:SetPoint("RIGHT", -5, 0)
end

function Option:CreateResurrectionMenu(menu, parent)
	local function update(member)
		if member:IsVisible() and (member.isDead or member.isGhost) then
			InvenRaidFrames3Member_UpdateResurrection(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_30"], nil, nil, true,
		function()
			return IRF3.db.units.useResurrectionBar
		end,
		function(v)
			IRF3.db.units.useResurrectionBar = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, 5)
	local function updateColor(member)
		member.resurrectionBar:SetStatusBarColor(IRF3.db.units.resurrectionBarColor[1], IRF3.db.units.resurrectionBarColor[2], IRF3.db.units.resurrectionBarColor[3])
	end
	menu.color = LBO:CreateWidget("ColorPicker", parent, L["색상"], L["lime_func_other_31"], nil, function() return not IRF3.db.units.useResurrectionBar end, true,
		function()
			return IRF3.db.units.resurrectionBarColor[1], IRF3.db.units.resurrectionBarColor[2], IRF3.db.units.resurrectionBarColor[3]
		end,
		function(r, g, b)
			IRF3.db.units.resurrectionBarColor[1], IRF3.db.units.resurrectionBarColor[2], IRF3.db.units.resurrectionBarColor[3] = r, g, b
			Option:UpdateMember(updateColor)
		end
	)
	menu.color:SetPoint("TOPRIGHT", -5, 5)
end

function Option:CreateRaidRoleMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateRoleIcon(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_32"], nil, nil, true,
		function()
			return IRF3.db.units.displayRaidRoleIcon
		end,
		function(v)
			IRF3.db.units.displayRaidRoleIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -10)

	local function disable()
		return not IRF3.db.units.displayRaidRoleIcon
	end

	menu.useClassic = LBO:CreateWidget("CheckBox", parent, L["lime_func_other_32_1"], L["lime_func_other_32_2"], nil, nil, true,
		function()
--			return IRF3.db.units.displayClassicRaidRoleIcon
			return IRF3.db.units.displayRaidRoleIcon2
		end,
		function(v)
--			IRF3.db.units.displayClassicRaidRoleIcon = v
			IRF3.db.units.displayRaidRoleIcon2 = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.useClassic:SetPoint("TOP", menu.use, "TOP", 0, 0)
	menu.useClassic:SetPoint("RIGHT", 0, -5)


	menu.displayRaidRoleIconTank = LBO:CreateWidget("CheckBox", parent, L["lime_func_other_32_3"], L["lime_func_other_32_4"], nil, nil, true,
		function()
			return IRF3.db.units.displayRaidRoleIconTank
		end,
		function(v)
			IRF3.db.units.displayRaidRoleIconTank = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)

	menu.displayRaidRoleIconTank:SetPoint("TOPLEFT", menu.use,"BOTTOMLEFT" , 0)


	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_other_33"], nil, disable, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.roleIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.roleIconPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOP", menu.displayRaidRoleIconTank, "BOTTOM", 0, 5)
	local function updateSize(member)
		if member:IsVisible() and member.roleIcon:IsVisible() then
      member.roleIcon:ClearAllPoints()
      member.roleIcon:SetPoint(IRF3.db.units.roleIconPos, member, IRF3.db.units.roleIconPos, 0, 0)
			member.roleIcon:SetSize(IRF3.db.units.roleIconSize * 1.1, IRF3.db.units.roleIconSize * 1.5)
		end
	end
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_34"], nil, disable, true,
		function()
			return IRF3.db.units.roleIconSize, 8, 20, 1 
		end,
		function(v)
			IRF3.db.units.roleIconSize = v
			Option:UpdateMember(updateSize)
		end
	)
	menu.size:SetPoint("TOP", menu.pos, "TOP", 0, 0)
	menu.size:SetPoint("RIGHT", 0, -5)

	local pack = { "블리자드 기본", "MiirGui"}
	menu.pack = LBO:CreateWidget("DropDown", parent, L["lime_func_other_35"], L["lime_func_other_36"], nil, disable, true,
		function()
			return IRF3.db.units.roleIcontype + 1, pack
		end,
		function(v)
			IRF3.db.units.roleIcontype = v - 1
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.pack:SetPoint("TOP", menu.pos, "BOTTOM", 0, 5)
end

function Option:CreateCenterStatusIconMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateCenterStatusIcon(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_37"], nil, nil, true,
		function()
			return IRF3.db.units.centerStatusIcon
		end,
		function(v)
			IRF3.db.units.centerStatusIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -10)
end

function Option:CreateRaidCheckMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateRaidCheck(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["도핑 체크desc"], nil, nil, true,
		function()
			return IRF3.db.units.RaidCheck
		end,
		function(v)
			IRF3.db.units.RaidCheck = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -10)

	local disable = function() return not IRF3.db.units.RaidCheck end
	menu.alpha = LBO:CreateWidget("Slider", parent, L["lime_func_aura_10_9"], L["lime_func_aura_10_10"], nil, disable, true,
		function() return IRF3.db.units.foodFlags, 225, 375, 1  end,
		function(v)
			IRF3.db.units.foodFlags = v
			Option:UpdateMember(update)
		end
	)
	menu.alpha:SetPoint("TOPRIGHT", -5, -5)

--[[
	menu.beta = LBO:CreateWidget("CheckBox", parent, "증강의 룬 도핑 검사", "증강의 룬 도핑 검사를 합니다.", nil, disable, true,
		function()
			return IRF3.db.units.showRunes
		end,
		function(v)
			IRF3.db.units.showRunes = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.beta:SetPoint("TOP", menu.use, "BOTTOM", 0, 0)
]]--

	menu.de = LBO:CreateWidget("CheckBox", parent, L["lime_func_aura_10_11"], L["lime_func_aura_10_12"], nil, disable, true,
		function()
			return IRF3.db.units.RaidCheckAnn
		end,
		function(v)
			IRF3.db.units.RaidCheckAnn = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.de:SetPoint("TOP", menu.alpha, "BOTTOM", 0, 0)
end


function Option:CreateLeaderIconMenu(menu, parent)
	local function update(member)
		if member:IsVisible() then
			InvenRaidFrames3Member_UpdateLeaderIcon(member)
			InvenRaidFrames3Member_UpdateLooterIcon(member)
		end
	end
	menu.use = LBO:CreateWidget("CheckBox", parent, L["사용하기"], L["lime_func_other_38"], nil, nil, true,
		function()
			return IRF3.db.units.useLeaderIcon
		end,
		function(v)
			IRF3.db.units.useLeaderIcon = v
			Option:UpdateMember(update)
			LBO:Refresh(parent)
		end
	)
	menu.use:SetPoint("TOPLEFT", 5, -10)
	local function disable()
		return not IRF3.db.units.useLeaderIcon
	end
	menu.pos = LBO:CreateWidget("DropDown", parent, L["위치"], L["lime_func_other_39"], nil, disable, true,
		function()
			return Option.dropdownTable["아이콘변환"][IRF3.db.units.leaderIconPos], Option.dropdownTable["아이콘"]
		end,
		function(v)
			IRF3.db.units.leaderIconPos = Option.dropdownTable["아이콘변환"][v]
			IRF3.db.units.looterIconPos = Option.dropdownTable["아이콘변환"][v]
			Option:UpdateIconPos()
		end
	)
	menu.pos:SetPoint("TOP", menu.use, "BOTTOM", 0, 5)
	local function updateSize(member)
		if member:IsVisible() and member.leaderIcon:IsVisible() then
			member.leaderIcon:SetSize(IRF3.db.units.leaderIconSize, IRF3.db.units.leaderIconSize)
		end

		if member:IsVisible() and member.looterIcon:IsVisible() then
			member.looterIcon:SetPoint(IRF3.db.units.leaderIconPos , IRF3.db.units.leaderIconSize, 0)
			member.looterIcon:SetSize(IRF3.db.units.leaderIconSize, IRF3.db.units.leaderIconSize)
		end

	end
	menu.size = LBO:CreateWidget("Slider", parent, L["크기"].."(".. L["픽셀"] ..")", L["lime_func_other_40"], nil, disable, true,
		function()
			return IRF3.db.units.leaderIconSize, 8, 20, 1 
		end,
		function(v)
			IRF3.db.units.leaderIconSize = v
			Option:UpdateMember(updateSize)
--			IRF3.db.units.looterIcon:SetPoint(IRF3.db.unitsself.optionTable.looterIconPos ,self.optionTable.leaderIconSize , 0)
		end
	)
	menu.size:SetPoint("TOP", menu.pos, "TOP", 0, 0)
	menu.size:SetPoint("RIGHT", 0, -5)
end


function Option:CreateMemberSelectMenu(menu, parent)
	local typeList = { L["사용 안함"],L["대상"],SL(17),SL(139),SL(774),SL(33763)} --2:보호막 3:소생 4:회복 : 5피생

	local function disable()
		return (InvenRaidFrames3CharDB.memberselect or 0) < 2
	end

	local function update_handler()
		SecureHandlerUnwrapScript(IRF3PartyTarget,"OnClick")
		SecureHandlerWrapScript(IRF3PartyTarget,"OnClick",IRF3PartyTarget,[[
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


		SecureHandlerUnwrapScript(IRF3RaidTarget,"OnClick")
		SecureHandlerWrapScript(IRF3RaidTarget,"OnClick",IRF3RaidTarget,[[
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




	end


	menu.memberselect = LBO:CreateWidget("DropDown", parent, L["순차선택"], L["순차선택_desc"], nil, nil, true,
		function()

			return (InvenRaidFrames3CharDB.memberselect  or 0) + 1, typeList
		end,
		function(v)
			InvenRaidFrames3CharDB.memberselect = v - 1
--			Option:UpdateMember(update)
--			LBO:Refresh(parent)
			if InvenRaidFrames3CharDB.memberselect==0 then
				SecureHandlerUnwrapScript(IRF3PartyTarget,"OnClick")
				SecureHandlerUnwrapScript(IRF3RaidTarget,"OnClick")
			elseif InvenRaidFrames3CharDB.memberselect==1 then
				update_handler()
			elseif InvenRaidFrames3CharDB.memberselect>1 then
				IRF3:MemberSelect_Adjust()
			end
			LBO:Refresh(parent)
		end
	)
	menu.memberselect:SetPoint("TOPLEFT", 5, -10)


local excepttypeList = { L["사용 안함"],"방어전담만 제외","방어전담만 포함"}

	menu.memberselect_except = LBO:CreateWidget("DropDown", parent, L["순차선택 옵션"], L["순차선택 옵션_desc"], nil, disable, true,
		function(v)
			return (InvenRaidFrames3CharDB.memberselect_except   or 0) +1,excepttypeList
		end,
		function(v)
			InvenRaidFrames3CharDB.memberselect_except = v-1
--			Option:UpdateMember(update)
--			LBO:Refresh(parent)
			if InvenRaidFrames3CharDB.memberselect>1 then
				IRF3:MemberSelect_Adjust()
			end
		end
	)
	menu.memberselect_except:SetPoint("TOPLEFT", menu.memberselect,"TOPRIGHT",0,0)


 

	menu.text1 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	menu.text1:SetText(L["lime_func_20"])
	menu.text1:SetPoint("TOPLEFT", menu.memberselect, "BOTTOMLEFT", 0 ,-10)
	menu.text1:SetJustifyH("LEFT")
	menu.text1:SetJustifyV("TOP")

	menu.text2 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	menu.text2:SetText(L["lime_func_21"])
	menu.text2:SetPoint("TOPLEFT", menu.text1, "BOTTOMLEFT", 0 ,-10)
	menu.text2:SetJustifyH("LEFT")
	menu.text2:SetJustifyV("TOP")

--[[
	menu.text3 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	menu.text3:SetText(L["lime_func_22"])
	menu.text3:SetPoint("TOPLEFT", menu.text2, "BOTTOMLEFT", 0 ,-10)
	menu.text3:SetJustifyH("LEFT")
	menu.text3:SetJustifyV("TOP")

]]--
	
end