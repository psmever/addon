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
		end
	)
	menu.list:SetPoint("TOPLEFT", menu.current, "BOTTOMLEFT", 0, -10)
	menu.list:HookScript("OnHide", function()
		StaticPopup_Hide("INVENRAIDFRAMES3_NEW_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_DELETE_PROFILE")
		StaticPopup_Hide("INVENRAIDFRAMES3_APPLY_PROFILE")
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
	local function togglePopup()
		menu.list:Update()
		menu.apply:Update()
		menu.delete:Update()
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
end

function Option:NewProfile(profile1, profile2)
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