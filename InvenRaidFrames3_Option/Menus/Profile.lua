local IRF3 = InvenRaidFrames3
local Option = IRF3.optionFrame
local LBO = LibStub("LibBlueOption-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local _G = _G
local pairs = _G.pairs
local ipairs = _G.ipairs
local unpack = _G.unpack
local InCombatLockdown = _G.InCombatLockdown
local UnitAffectingCombat = _G.UnitAffectingCombat



--https://gist.github.com/yuhanz/6688d474a3c391daa6d6

function tableToString(table)
	return "return"..serializeTable(table)
end

function stringToTable(str)
	local f = loadstring(str)
	return f()
end

function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    if name then 
    	if not string.match(name, "^[a-zA-z_][a-zA-Z0-9_]*$") then
    		name = string.gsub(name, "\"", "\\'")
    		name = "[\"".. name .. "\"]"
    	end
    	tmp = tmp .. name .. " = "
     end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end



 

local backdropInfo = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = true, edgeSize = 1, tileSize = 5,
}


function Option:CreateProfileMenu(menu, parent)
	local profiles = {}
	local function disable()
		return StaticPopup_Visible("INVENRAIDFRAMES3_NEW_PROFILE") or StaticPopup_Visible("INVENRAIDFRAMES3_DELETE_PROFILE") or StaticPopup_Visible("INVENRAIDFRAMES3_APPLY_PROFILE") 
	end
	local function getTargetProfile()
		if menu.list:GetValue() then
			menu.targetProfile = profiles[menu.list:GetValue()]
		else
			menu.targetProfile = nil
		end
		return menu.targetProfile
	end
	menu.current = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	menu.current:SetPoint("TOPLEFT", 5, -5)
	menu.current:SetText(L["lime_profile_current"]..(InvenRaidFrames3DB.profileKeys[IRF3.profileName] or L["기본값"]))
	menu.list = LBO:CreateWidget("List", parent, L["프로필 목록"], nil, nil, disable, nil,
		function()
			return Option:ConvertTable(InvenRaidFrames3DB.profiles, profiles), true
		end,
		function(v)
			getTargetProfile()
			menu.apply:Update()
			menu.delete:Update()
			menu.export:Update()

			menu.import:Update()

			menu.profile_1m:Update()
			menu.profile_5m:Update()
			menu.profile_10m:Update()
			menu.profile_25m:Update()
			menu.profile_40m:Update()
			menu.profile_spec1:Update()
			menu.profile_spec2:Update()
		end
	)
	menu.list:SetPoint("TOPLEFT", menu.current, "BOTTOMLEFT", 0, -10)
	menu.list:HookScript("OnHide", function()
		StaticPopup_Hide("INVENRAIDFRAMES3_NEW_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_DELETE_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_APPLY_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_EXPORT_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_IMPORT_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_CHAREXPORT_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_CHARIMPORT_PROFILE")
	end)
	menu.apply = LBO:CreateWidget("Button", parent, L["lime_profile_01"], L["lime_profile_desc_01"], nil,
		function()
			if disable() then
				return true
			elseif getTargetProfile() then
				if menu.targetProfile == IRF3.dbName then
					return true
				else
					return nil
				end
			else
				return true
			end
		end, true,
		function()

			StaticPopup_Show("INVENRAIDFRAMES3_APPLY_PROFILE", getTargetProfile())
		end
	)
	menu.apply:SetPoint("TOPLEFT", menu.list, "BOTTOMLEFT", 0, 12)
	menu.apply:SetPoint("TOPRIGHT", menu.list, "BOTTOMRIGHT", 0, 12)
	menu.create = LBO:CreateWidget("Button", parent, L["lime_profile_02"], L["lime_profile_desc_02"], nil, disable, true,
		function()
			getTargetProfile()
			StaticPopup_Show("INVENRAIDFRAMES3_NEW_PROFILE")
		end
	)
	menu.create:SetPoint("TOPLEFT", menu.apply, "BOTTOMLEFT", 0, 20)
	menu.create:SetPoint("TOPRIGHT", menu.apply, "BOTTOMRIGHT", 0, 20)

	menu.delete = LBO:CreateWidget("Button", parent, L["lime_profile_03"], L["lime_profile_desc_03"], nil,
		function()
			if disable() then
				return true
			elseif getTargetProfile() then
				if menu.targetProfile == L["기본값"] or menu.targetProfile == IRF3.dbName then
					return true
				else
					return nil
				end
			else
				return true
			end
		end, true,
		function()
			StaticPopup_Show("INVENRAIDFRAMES3_DELETE_PROFILE", getTargetProfile())
		end
	)
	menu.delete:SetPoint("TOPLEFT", menu.create, "BOTTOMLEFT", 0, 20)
	menu.delete:SetPoint("TOPRIGHT", menu.create, "BOTTOMRIGHT", 0, 20)

	menu.export = LBO:CreateWidget("Button", parent, L["profile_export"],L["profile_export2"], nil, 
	function()if disable() then
				return true
			elseif getTargetProfile() then
				if menu.targetProfile == L["기본값"] then --or menu.targetProfile == IRF3.dbName then
					return true
				else
					return nil
				end
			else
				return true
			end
		end
		, true,
		function()


			local scrollFrame = CreateFrame("ScrollFrame", nil, nil , "UIPanelScrollFrameTemplate")
			scrollFrame:SetSize(230, 400)
			scrollFrame:SetPoint("CENTER")


--			local editbox = CreateFrame("EditBox", nil, scrollFrame, "InputBoxScriptTemplate")
			local editbox = CreateFrame("EditBox", nil, scrollFrame,  "BackdropTemplate")
			editbox:SetBackdrop(backdropInfo)
			editbox:SetBackdropColor(0.25,0.25,0.5,1)
			editbox:SetMultiLine(true)
			editbox:SetAutoFocus(false)
			editbox:SetFontObject(ChatFontSmall)
			editbox:SetWidth(400)
--			editbox:SetPoint("TOPLEFT",scrollFrame,"TOPLEFT",0,0)
--			editbox:SetPoint("BOTTOMRIGHT",scrollFrame,"BOTTOMRIGHT",0,0)


			local export = tableToString(InvenRaidFrames3DB.profiles[menu.targetProfile])

			editbox:SetText(export)
			editbox:SetCursorPosition(0)
			scrollFrame:SetScrollChild(editbox)

			StaticPopup_Show("INVENRAIDFRAMES3_EXPORT_PROFILE", getTargetProfile(),nil,nil,scrollFrame)
		end
	)


	menu.export:SetPoint("TOPLEFT", menu.apply, "TOPRIGHT", 0, 0)

	local profile_to_import=""
	local profiletext_to_import=""
	local profiletext_to_charimport=""

	menu.editbox = LBO:CreateEditBox(parent, nil, "ChatFontNormal", nil, true)
	menu.editbox:SetPoint("TOPLEFT", menu.export, "TOPLEFT", 0,-37)
	menu.editbox:SetWidth(100)



 


	menu.editbox:SetScript("OnTextChanged", function() menu.import:Update()   end)
	menu.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
	end)




	local function disable2()

		if #menu.editbox:GetText() >0 then return false else return true end
	end



	menu.import = LBO:CreateWidget("Button", parent, ">"..L["profile_import"],L["profile_import2"], nil,   disable2, true,
		function()

			local scrollFrame = CreateFrame("ScrollFrame", nil, nil, "UIPanelScrollFrameTemplate")
			scrollFrame:SetSize(230, 400)
			scrollFrame:SetPoint("CENTER")


			local editbox = CreateFrame("EditBox", nil, scrollFrame,  "BackdropTemplate")
			editbox:SetBackdrop(backdropInfo)
			editbox:SetBackdropColor(0.25,0.25,0.5,1)

			editbox:SetMultiLine(true)
			editbox:SetAutoFocus(false)
			editbox:SetFontObject(ChatFontSmall)
			editbox:SetWidth(400)


			editbox:SetText("|c80808000\n\n--"..L["profile_import3"].."--return{\n--managerPos=3,\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n}|r")
			editbox:SetCursorPosition(0)

			editbox:SetScript("OnTextChanged", function() profiletext_to_import = editbox:GetText()   end)
			scrollFrame:SetScrollChild(editbox)



			if InvenRaidFrames3DB.profiles[menu.editbox:GetText()] then

				StaticPopup_Show("IRF_DUPLICATED_PROFILE")
				return
			end
				profile_to_import = menu.editbox:GetText()

--				print("진행",profile_to_import)
				StaticPopup_Show("INVENRAIDFRAMES3_IMPORT_PROFILE",nil,nil,nil,scrollFrame)
		end
	)
	menu.import:SetPoint("TOPLEFT", menu.create, "TOPRIGHT", 100, 0)
	menu.import:SetPoint("TOPRIGHT", menu.export, "BOTTOMRIGHT", 0, 0)
 

--[[ 캐릭터 정보(주문타이머,클릭캐스트는 만들어놓았으나 일단 제외 - 테스트 안함)
	menu.charexport = LBO:CreateWidget("Button", parent, "캐릭터 내보내기","", nil, nil
		, true,
		function()


			local scrollFrame = CreateFrame("ScrollFrame", nil, nil , "UIPanelScrollFrameTemplate")
			scrollFrame:SetSize(230, 400)
			scrollFrame:SetPoint("CENTER")


--			local editbox = CreateFrame("EditBox", nil, scrollFrame, "InputBoxScriptTemplate")
			local editbox = CreateFrame("EditBox", nil, scrollFrame,  "BackdropTemplate")
			editbox:SetBackdrop(backdropInfo)
			editbox:SetBackdropColor(0.25,0.25,0.5,1)
			editbox:SetMultiLine(true)
			editbox:SetAutoFocus(false)
			editbox:SetFontObject(ChatFontSmall)
			editbox:SetWidth(400)
--			editbox:SetPoint("TOPLEFT",scrollFrame,"TOPLEFT",0,0)
--			editbox:SetPoint("BOTTOMRIGHT",scrollFrame,"BOTTOMRIGHT",0,0)


			local charexport = tableToString(InvenRaidFrames3CharDB)

			editbox:SetText(charexport)
			editbox:SetCursorPosition(0)


			scrollFrame:SetScrollChild(editbox)

			StaticPopup_Show("INVENRAIDFRAMES3_CHAREXPORT_PROFILE", getTargetProfile(),nil,nil,scrollFrame)
		end
	)


	menu.charexport:SetPoint("TOPLEFT", menu.delete, "BOTTOMLEFT", 0, 0)


	menu.charimport = LBO:CreateWidget("Button", parent, "캐릭터 가져오기","", nil,   nil, true,
		function()

			local scrollFrame = CreateFrame("ScrollFrame", nil, nil, "UIPanelScrollFrameTemplate")
			scrollFrame:SetSize(230, 400)
			scrollFrame:SetPoint("CENTER")


			local editbox = CreateFrame("EditBox", nil, scrollFrame,  "BackdropTemplate")
			editbox:SetBackdrop(backdropInfo)
			editbox:SetBackdropColor(0.25,0.25,0.5,1)

			editbox:SetMultiLine(true)
			editbox:SetAutoFocus(false)
			editbox:SetFontObject(ChatFontSmall)
			editbox:SetWidth(400)


			editbox:SetText("|c80808000--"..L["profile_import3"].."--return{\n--managerPos=3,\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n--...\n}|r")
			editbox:SetCursorPosition(0)

			editbox:SetScript("OnTextChanged", function() profiletext_to_charimport = editbox:GetText()   end)
			scrollFrame:SetScrollChild(editbox)





--				print("진행",profiletext_to_charimport)
				StaticPopup_Show("INVENRAIDFRAMES3_CHARIMPORT_PROFILE",nil,nil,nil,scrollFrame)
		end
	)
	menu.charimport:SetPoint("TOPLEFT", menu.charexport, "TOPRIGHT", 100, 0)

 -- 캐릭터 정보(주문타이머,클릭캐스트는 만들어놓았으나 일단 제외 - 테스트 안함)
--]]


--profile


---profile 효과 
	menu.profile_1m = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_1m"], L["Lime_profile_1m"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()

			if InvenRaidFrames3CharDB.profile_1m and InvenRaidFrames3CharDB.profile_1m==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_1m=name
			else
				InvenRaidFrames3CharDB.profile_1m=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_1m:SetPoint("TOPLEFT", menu.list, "TOPRIGHT", 10, 0)

	menu.profile_5m = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_5m"], L["Lime_profile_5m"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_5m and InvenRaidFrames3CharDB.profile_5m==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_5m=name
			else
				InvenRaidFrames3CharDB.profile_5m=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_5m:SetPoint("TOPLEFT", menu.profile_1m, "TOPRIGHT", -70, 0)

	menu.profile_10m = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_10m"], L["Lime_profile_10m"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_10m and InvenRaidFrames3CharDB.profile_10m==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_10m=name
			else
				InvenRaidFrames3CharDB.profile_10m=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_10m:SetPoint("TOPLEFT", menu.profile_1m, "BOTTOMLEFT", 0, 10)


	menu.profile_25m = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_25m"], L["Lime_profile_25m"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_25m and InvenRaidFrames3CharDB.profile_25m==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_25m=name
			else
				InvenRaidFrames3CharDB.profile_25m=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_25m:SetPoint("TOPLEFT", menu.profile_10m, "TOPRIGHT",  -70, 0)


	menu.profile_40m = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_40m"], L["Lime_profile_40m"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_40m and InvenRaidFrames3CharDB.profile_40m==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_40m=name
			else
				InvenRaidFrames3CharDB.profile_40m=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_40m:SetPoint("TOPLEFT", menu.profile_10m, "BOTTOMLEFT", 0, 10)


	menu.profile_spec1 = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_spec1"], L["Lime_profile_spec1"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_spec1 and InvenRaidFrames3CharDB.profile_spec1==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_spec1=name
			else
				InvenRaidFrames3CharDB.profile_spec1=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_spec1:SetPoint("TOPLEFT", menu.profile_40m, "BOTTOMLEFT", 0, 10)

	menu.profile_spec2 = LBO:CreateWidget("CheckBox", parent, L["Lime_profile_spec2"], L["Lime_profile_spec2"], nil, function()
			if   getTargetProfile() then
				return nil
			else
				return true
			end
		end, true,
		function()
			local name = getTargetProfile()
			if InvenRaidFrames3CharDB.profile_spec2 and InvenRaidFrames3CharDB.profile_spec2==name then
				return true
			else
				return false
			end
 			
		end,
		function(v)
			
			local name = getTargetProfile()
 			if v then 
				InvenRaidFrames3CharDB.profile_spec2=name
			else
				InvenRaidFrames3CharDB.profile_spec2=nil
			end

		 	LBO:Refresh(parent)

		end
	)
	menu.profile_spec2:SetPoint("TOPLEFT", menu.profile_spec1, "TOPRIGHT",  -70, 0)







	local function togglePopup()
		menu.list:Update()
		menu.apply:Update()
		menu.delete:Update()
		menu.export:Update()
		menu.import:Update()
		menu.profile_1m:Update()
		LBO:Refresh(parent)
	end
	local function checkCombat(self)
		if UnitAffectingCombat("player") or InCombatLockdown() then
			self:Hide()
		end
	end

	StaticPopupDialogs["INVENRAIDFRAMES3_NEW_PROFILE"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["lime_profile_make"],
		button1 = OKAY, button2 = CANCEL, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, hasEditBox = 1, maxLetters = 32, showAlert = 1,
		OnUpdate = checkCombat, OnHide = togglePopup,
		OnAccept = function(self)
			local name = (self.editBox:GetText() or ""):trim()
			if name ~= "" then
				if InvenRaidFrames3DB.profiles[name] then
					IRF3:Message((L["lime_profile_make_message_01"]):format(name))
				elseif Option:NewProfile(name, menu.targetProfile) then
					if InvenRaidFrames3DB.profiles[name] then
						menu.current:SetText(L["현재 프로필"]..name)
						IRF3:Message((L["lime_profile_make_message_02"]):format(name))
					else
						IRF3:Message(L["lime_profile_make_message_03"])
					end
				else
					IRF3:Message(L["lime_profile_make_message_03"])
				end
			end
		end,
		OnShow = function(self)
		
			self.button1:Disable()
			self.button2:Enable()
			self.editBox:SetText("")
			self.editBox:SetFocus()
			togglePopup()
		end,
		EditBoxOnTextChanged = function(self)
			if (self:GetParent().editBox:GetText() or ""):trim() ~= "" then
				self:GetParent().button1:Enable()
			else
				self:GetParent().button1:Disable()
			end
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEnterPressed = function(self)
			if (self:GetParent().editBox:GetText() or ""):trim() ~= "" then
				self:GetParent().button1:Click()
			end
		end,
	}
	StaticPopupDialogs["INVENRAIDFRAMES3_DELETE_PROFILE"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["lime_profile_delete"],
		button1 = YES, button2 = NO, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, showAlert = 1,
		OnUpdate = checkCombat, OnShow = togglePopup, OnHide = togglePopup,
		OnAccept = function(self)
			InvenRaidFrames3DB.profiles[menu.targetProfile] = nil
			for p, v in pairs(InvenRaidFrames3DB.profileKeys) do
				if v == menu.targetProfile then
					InvenRaidFrames3DB.profileKeys[p] = nil
				end
			end
			IRF3:Message((L["lime_profile_delete_message_01"]):format(menu.targetProfile))
		end,
	}
	StaticPopupDialogs["INVENRAIDFRAMES3_APPLY_PROFILE"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["lime_profile_apply"],
		button1 = YES, button2 = NO, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, showAlert = 1,
		OnUpdate = checkCombat, OnShow = togglePopup, OnHide = togglePopup,
		OnAccept = function(self)
			menu.current:SetText(L["현재 프로필"]..(menu.targetProfile or L["기본값"]))

			IRF3:SetProfile(menu.targetProfile)
			IRF3:ApplyPorfile()
			IRF3:Message((L["lime_profile_apply_message_01"]):format(menu.targetProfile))
		end,
	}

	StaticPopupDialogs["INVENRAIDFRAMES3_EXPORT_PROFILE"] = {
			preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["profile_export3"],
		button1 = CLOSE, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, hasEditBox = false, showAlert = false,
		OnUpdate = checkCombat, OnHide = togglePopup,
		OnShow = function(self)

	 			

			self.button1:Disable()
			self.button2:Enable()
			self:SetSize(300,700)
			self.button1:Enable()
			
		end,
		 EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
 
	}

	StaticPopupDialogs["INVENRAIDFRAMES3_CHAREXPORT_PROFILE"] = {
			preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = "캐릭터 내보내기",
		button1 = CLOSE, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, hasEditBox = false, showAlert = false,
		OnUpdate = checkCombat, OnHide = togglePopup,
		OnShow = function(self)

	 			

			self.button1:Disable()
			self.button2:Enable()
			self:SetSize(300,700)
			self.button1:Enable()
			
		end,
 EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
 
	}


	StaticPopupDialogs["INVENRAIDFRAMES3_IMPORT_PROFILE"] = {
			preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["profile_import4"],
		button1 = OKAY, button2 = CANCEL, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, hasEditBox = false, showAlert = false,
		OnUpdate = checkCombat, OnShow = togglePopup, OnHide = togglePopup,
		OnAccept = function(self)

--print("0","return "..self.editBox:GetText())
--print(profile_to_import)
--print("00",   string.gsub(self.editBox:GetText(),"%-%- %[%d%]","") )


--print("1",loadstring( "return "..self.editBox:GetText()),type(InvenRaidFrames3DB.profiles),InvenRaidFrames3DB.profiles["ImportTest"])
--func, errorMessage = loadstring("return ".. self.editBox:GetText())
--print(menu.editbox:GetText())
--테스트 프로필명
--print(profiletext_to_import)
			if #profile_to_import > 0 and #profiletext_to_import then

			InvenRaidFrames3DB.profiles[profile_to_import]={}
		InvenRaidFrames3DB.profiles[profile_to_import] = stringToTable(profiletext_to_import)

				IRF3:Message((L["profile_import_msg1"]):format(name))
			else
				IRF3:Message((L["profile_import_msg2"]):format(name))
			end

		end,
		OnShow = function(self)
		
 
			self.button1:Disable()
			self.button2:Enable()

			self:SetSize(300,700)
			self.button1:Enable()
			self.button2:Enable()
		end,
 EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
 
	}

		StaticPopupDialogs["IRF_DUPLICATED_PROFILE"] = {
			text = L["profile_import_msg3"],
			button1="CLOSE", timeout=30, whileDead=1, showAlert=enable, hideOnEscape=1,
			OnAccept=function()   
			end,
			OnCancel=function()   end
			}

StaticPopupDialogs["INVENRAIDFRAMES3_CHARIMPORT_PROFILE"] = {
			preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = "캐릭터 가져오기",
		button1 = OKAY, button2 = CANCEL, hideOnEscape = 1, timeout = 0, exclusive = 1, whileDead = 1, hasEditBox = false, showAlert = false,
		OnUpdate = checkCombat, OnShow = togglePopup, OnHide = togglePopup,
		OnAccept = function(self)

 
print("chartext",profiletext_to_charimport)
		if  #profiletext_to_charimport and InvenRaidFrames3CharDB then


		InvenRaidFrames3CharDB = stringToTable(profiletext_to_charimport)

				IRF3:Message((L["profile_import_msg1"]):format(name))
			else
				IRF3:Message((L["profile_import_msg2"]):format(name))
			end

		end,

		OnShow = function(self)
		
 
			self.button1:Disable()
			self.button2:Enable()

			self:SetSize(300,700)
			self.button1:Enable()
			self.button2:Enable()
		end,
 EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide()
        end,
 
	}

end



function Option:NewProfile(profile1, profile2)
--print(table_to_string(InvenRaidFrames3DB.profiles[profile2]))
	if type(profile1) == "string" and not InvenRaidFrames3DB.profiles[profile1] then
		
		if type(profile2) == "string" and InvenRaidFrames3DB.profiles[profile2] then
			InvenRaidFrames3DB.profiles[profile1] = CopyTable(InvenRaidFrames3DB.profiles[profile2])
		end
		IRF3:SetProfile(profile1)
		IRF3:ApplyPorfile()
		return true
	end
	return nil
end

