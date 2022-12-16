local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local IRF3 = InvenRaidFrames3
local Option = IRF3.optionFrame
Option.loaded = true
Option:SetScript("OnShow", nil)
Option:UnregisterAllEvents()
Option:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
--Option:RegisterEvent("ADDON_LOADED")

local _G = _G
local type = _G.type
local pairs = _G.pairs
local ipairs = _G.ipairs
local sort = _G.table.sort
local twipe = _G.table.wipe
local tinsert = _G.table.insert
local tremove = _G.table.remove
local CreateFrame = _G.CreateFrame
local LBO = LibStub("LibBlueOption-1.0")
  
local lime_a, lime_b, lime_c = L["lime_a"], L["lime_b"], L["lime_c"]

local tabList = { lime_a, lime_b, lime_c }

--local tabList = { "기본", "외형", "기능" }
local menuOnClick = function(id) Option:ShowDetailMenu(id) end
local menuList = {
	[L["lime_a"]] = {
		{ name = L["사용"], desc = L["사용desc"], func = menuOnClick, create = "Use" },
		{ name = L["정렬 및 배치"], desc = L["정렬 및 배치desc"], func = menuOnClick, create = "Group" },
		{ name = L["소환수"], L["소환수desc"], func = menuOnClick, create = "Pet" },
		{ name = L["클릭 캐스팅"], desc = L["클릭 캐스팅desc"], func = menuOnClick, create = "ClickCasting", disableScroll = true },
		{ name = L["프로필 관리"], desc = L["프로필 관리desc"], func = menuOnClick, create = "Profile", disableScroll = true },
		{ name = L["고급"], desc = L["고급desc"], func = menuOnClick, create = "Advanced", disableScroll = true },
	},
	[L["lime_b"]] = {
		{ name = L["프레임"], desc = L["프레임desc"], func = menuOnClick, create = "Frame" },
		{ name = L["체력바 및 직업 색상"], desc = L["체력바 및 직업 색상desc"], func = menuOnClick, create = "HealthBar" },
		{ name = L["마나바"], desc = L["마나바desc"], func = menuOnClick, create = "ManaBar" },
		{ name = L["이름"], desc = L["이름desc"], func = menuOnClick, create = "Name" },
		{ name = L["파티 이름표"], desc = L["파티 이름표desc"], func = menuOnClick, create = "PartyTag" },
		{ name = L["배경 테두리"], desc = L["배경 테두리desc"], func = menuOnClick, create = "Border" },
		{ name = L["디버프 색상"], desc = L["디버프 색상desc"], func = menuOnClick, create = "DebuffColor" },
	},
	[L["lime_c"]] = {
		{ name = L["어그로"], desc = L["어그로desc"], func = menuOnClick, create = "Aggro" },
		{ name = L["외곽선"], desc = L["외곽선desc"], func = menuOnClick, create = "Outline" },
		{ name = L["사정거리"], desc = L["사정거리desc"], func = menuOnClick, create = "Range" },
		{ name = L["생명력 표시"], desc = L["생명력 표시desc"], func = menuOnClick, create = "LostHealth" },
		{ name = L["버프 확인"], desc = L["버프 확인desc"], func = menuOnClick, create = "BuffCheck" },
		{ name = L["주문 타이머"], desc = L["주문 타이머desc"], func = menuOnClick, create = "SpellTimer" },
		{ name = L["생존기 표시"], desc = L["생존기 표시desc"], func = menuOnClick, create = "SurvivalSkill" },
		{ name = L["들어오는 치유/흡수"], desc = L["들어오는 치유/흡수desc"], func = menuOnClick, create = "HealPrediction" },
		{ name = L["무시할 오라 설정"], desc = L["무시할 오라 설정desc"], func = menuOnClick, create = "IgnoreAura" },
		{ name = L["디버프 아이콘 표시"], desc = L["디버프 아이콘 표시desc"], func = menuOnClick, create = "DebuffIcon" },
		{ name = L["해제 가능한 디버프"], desc = L["해제 가능한 디버프desc"], func = menuOnClick, create = "DebuffHealth" },
		{ name = L["중요 오라 표시"], desc = L["중요 오라 표시desc"], func = menuOnClick, create = "BossAura" },
		{ name = L["적대적인 대상 표시"], desc = L["적대적인 대상 표시desc"], func = menuOnClick, create = "Enemy" },
		{ name = L["전술 목표 아이콘"], desc = L["전술 목표 아이콘desc"], func = menuOnClick, create = "RaidTarget" },
		{ name = L["시전바"], desc = L["시전바desc"], func = menuOnClick, create = "CastingBar" },
		{ name = L["상황 표시바"], desc = L["상황 표시바desc"], func = menuOnClick, create = "PowerBarAlt" },
		{ name = L["부활 시전바"], desc = L["부활 시전바desc"], func = menuOnClick, create = "Resurrection" },
		{ name = L["역할 아이콘"], desc = L["역할 아이콘desc"], func = menuOnClick, create = "RaidRole" },
		{ name = L["중앙 상태 아이콘"], desc = L["중앙 상태 아이콘desc"], func = menuOnClick, create = "CenterStatusIcon" },
		{ name = L["도핑 체크"], desc = L["도핑 체크desc"], func = menuOnClick, create = "RaidCheck" },
		{ name = L["파티장 아이콘"], desc = L["파티장 아이콘desc"], func = menuOnClick, create = "LeaderIcon" },
	},
}
 

Option.dropdownTable = {
	["아이콘"] = { L["좌측 상단"], L["상단"], L["우측 상단"], L["좌측"], L["중앙"], L["우측"], L["좌측 하단"], L["하단"], L["우측 하단"] },
	["아이콘변환"] = { [L["좌측 상단"]] = "TOPLEFT", [L["상단"]] = "TOP", [L["우측 상단"]] = "TOPRIGHT", [L["좌측"]] = "LEFT", [L["중앙"]] = "CENTER", [L["우측"]] = "RIGHT", [L["좌측 하단"]] = "BOTTOMLEFT", [L["하단"]] = "BOTTOM", [L["우측 하단"]] = "BOTTOMRIGHT", TOPLEFT = L["좌측 상단"], TOP = L["상단"], TOPRIGHT = L["우측 상단"], LEFT = L["좌측"], CENTER = L["중앙"], RIGHT = L["우측"], BOTTOMLEFT = L["좌측 하단"], BOTTOM = L["하단"], BOTTOMRIGHT = L["우측 하단"] }, 
	["징표"] = {},
}
for i = 1, 8 do
	Option.dropdownTable["징표"][i] = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0:0:0:-1|t %s"..L["lime_func_button_9"]):format(i, _G["RAID_TARGET_"..i])
end


if not Option.title then
	Option.title = Option:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	Option.title:SetText(Option.name)
	Option.title:SetPoint("TOPLEFT", 8, -12)
	Option.version = Option:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	Option.version:SetText(IRF3.version)
	Option.version:SetPoint("LEFT", Option.title, "RIGHT", 2, 0)
end
if Option.combatWarn then
	Option.combatWarn:Hide()
end
Option.mainBorder = CreateFrame("Frame", nil, Option, BackdropTemplateMixin and "BackdropTemplate")
Option.mainBorder:SetBackdrop({
	edgeFile = "Interface\\AddOns\\InvenRaidFrames3_Option\\Texture\\TooltipBorderNoneTop.tga",
	tile = true, edgeSize = 16,
	insets = { left = 5, right = 5, top = 5, bottom = 5 },
})
Option.mainBorder:SetPoint("TOPLEFT", Option.title, "BOTTOMLEFT", 1, -26)
Option.mainBorder:SetPoint("BOTTOMRIGHT", Option, "BOTTOMLEFT", 163, 39)


local previewList = { L["미리 보기 끄기"], L["미리 보기 - 5인"], L["미리 보기 - 10인"], L["미리 보기 - 20인"], L["미리 보기 - 25인"], L["미리 보기 - 30인"], L["미리 보기 - 40인"] }


Option.previewDropdown = LBO:CreateWidget("DropDown", Option, "", L["lime_previewDropdown"], nil, nil, true,
	function() return Option:GetPreviewState(), previewList end,
	function(v)
		Option:SetPreview(v > 1 and v or nil)
	end
)
Option.previewDropdown:SetPoint("TOP", Option.mainBorder, "BOTTOM", 0, 16)
Option.previewDropdown:SetWidth(154)

Option.mainTab, Option.mainScroll, Option.detailScroll = {}, {}, {}

local function tabOnClick(self)
	--PlaySound("igCharacterInfoTab") -- fix 8.0
	Option:SetMainTab(self:GetID())
end

local function menuCheck(menu)
	for p, v in pairs(menu) do
		if v.create and type(Option["Create"..v.create.."Menu"]) ~= "function" then
			tremove(menu, p)
			menuCheck(menu)
			break
		end
	end
end

for i, name in ipairs(tabList) do
	Option.mainTab[i] = CreateFrame("Button", Option:GetName().."Tab"..i, Option, "OptionsFrameTabButtonTemplate")
	Option.mainTab[i]:SetPoint("LEFT", Option.mainTab[i - 1], "RIGHT", -16, 0)
	Option.mainTab[i]:SetID(i)
	Option.mainTab[i]:SetText(name)
	Option.mainTab[i]:SetScript("OnClick", tabOnClick)
	Option.detailScroll[name] = {}
	if menuList[name] then
		--menuCheck(menuList[name])
	end
	PanelTemplates_TabResize(Option.mainTab[i], 0)
end
Option.mainTab[1]:ClearAllPoints()
Option.mainTab[1]:SetPoint("TOPLEFT", Option.title, "BOTTOMLEFT", 2, -3)
Option.mainTabLine1 = Option.mainBorder:CreateTexture(nil, "OVERLAY")
Option.mainTabLine1:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-Spacer")
Option.mainTabLine1:SetHeight(16)
Option.mainTabLine2 = Option.mainBorder:CreateTexture(nil, "OVERLAY")
Option.mainTabLine2:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-Spacer")
Option.mainTabLine2:SetHeight(16)
Option.detailBorder = CreateFrame("Frame", nil, Option, BackdropTemplateMixin and "BackdropTemplate")
Option.detailBorder:SetBackdrop({
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, edgeSize = 16,
	insets = { left = 5, right = 5, top = 5, bottom = 5 },
})
Option.detailBorder:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
Option.detailBorder:SetPoint("TOPLEFT", Option.mainBorder, "TOPRIGHT", 4, 0)
Option.detailBorder:SetPoint("BOTTOMRIGHT", Option, "BOTTOMRIGHT", -10, 10)
Option.detailDesc = Option:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
Option.detailDesc:SetHeight(36)
Option.detailDesc:SetJustifyH("LEFT")
Option.detailDesc:SetJustifyV("BOTTOM")
Option.detailDesc:SetNonSpaceWrap(true)
Option.detailDesc:SetPoint("BOTTOMLEFT", Option.detailBorder, "TOPLEFT", 12, 4)
Option.detailDesc:SetPoint("RIGHT", -18, 0)
PanelTemplates_SetNumTabs(Option, #tabList)

function Option:SetMainTab(id)
	self.openedTabName = tabList[id]
	PanelTemplates_Tab_OnClick(self.mainTab[id], self)
	PanelTemplates_UpdateTabs(self)
	self.mainTabLine1:ClearAllPoints()
	self.mainTabLine1:SetPoint("LEFT", self.mainBorder, "TOPLEFT", 8, 0)
	self.mainTabLine1:SetPoint("RIGHT", self.mainTab[id], "BOTTOMLEFT", 10, 1)
	self.mainTabLine2:ClearAllPoints()
	self.mainTabLine2:SetPoint("LEFT", self.mainTab[id], "BOTTOMRIGHT", -10, 1)
	self.mainTabLine2:SetPoint("RIGHT", self.mainBorder, "RIGHT", -8, 0)
	id = self.mainTab[id].name
	if not self.mainScroll[self.openedTabName] and type(menuList[self.openedTabName]) == "table" and #menuList[self.openedTabName] > 0 then
		self.mainScroll[self.openedTabName] = LBO:CreateWidget("Menu", self, menuList[self.openedTabName])
		self.mainScroll[self.openedTabName]:SetAllPoints(self.mainBorder)
		self.mainScroll[self.openedTabName]:SetBackdrop(nil)
		self.mainScroll[self.openedTabName]:SetValue(1)
	end
	for name, frame in pairs(self.mainScroll) do
		if name == self.openedTabName then
			frame:Show()
		else
			frame:Hide()
		end
	end
	self:ShowDetailMenu(self.mainScroll[self.openedTabName]:GetValue())
end

function Option:ShowDetailMenu(id)
	self.openedDetailName = menuList[self.openedTabName][id].name
	if not self.detailScroll[self.openedTabName][self.openedDetailName] then
		local menu
		if menuList[self.openedTabName][id].create and not menuList[self.openedTabName][id].disableScroll then
			menu = LBO:CreateWidget("ScrollFrame", self.mainScroll[self.openedTabName])
		else
			menu = CreateFrame("Frame", nil, self.mainScroll[self.openedTabName])
		end
		menu:Hide()
		menu.options = {}
		menu:SetPoint("TOPLEFT", self.detailBorder, "TOPLEFT", 5, -5)
		menu:SetPoint("BOTTOMRIGHT", self.detailBorder, "BOTTOMRIGHT", -5, 5)
		if menuList[self.openedTabName][id].create and self["Create"..menuList[self.openedTabName][id].create.."Menu"] then
			self["Create"..menuList[self.openedTabName][id].create.."Menu"](self, menu.options, menu.content or menu)
			self["Create"..menuList[self.openedTabName][id].create.."Menu"] = nil
		end
		menuList[self.openedTabName][id].create = nil
		self.detailScroll[self.openedTabName][self.openedDetailName] = menu
	end
	for name, frame in pairs(self.detailScroll[self.openedTabName]) do
		if name == self.openedDetailName then
			frame:Show()
		else
			frame:Hide()
		end
	end
	self.detailDesc:SetText(menuList[self.openedTabName][id].desc or "")
end

local optKey, optValue

function Option:SetOption(...)
	IRF3:SetAttribute("startupdate", nil)
	for i = 1, select("#", ...), 2 do
		optKey, optValue = select(i, ...)
		IRF3:SetAttribute(optKey, optValue or nil)
	end
	IRF3:SetAttribute("startupdate", true)
end

function Option:UpdateMember(func)
	if type(func) == "function" then
		for _, header in pairs(IRF3.headers) do
			for _, member in pairs(header.members) do
				func(member)
			end
		end

		for _, header in pairs(IRF3.tankheaders) do
			for _, member in pairs(header.members) do
				func(member)
			end
		end

 
 
			for _, member in pairs(IRF3.petHeader.members) do
				func(member)
			end
 

	end
end

function Option:ConvertTable(input, output)
	if type(input) == "table" then
		if type(output) == "table" then
			twipe(output)
		else
			output = {}
		end
		for p, v in pairs(input) do
			if v then
				tinsert(output, p)
			end
		end
		sort(output)
		return output
	else
		return nil
	end
end

Option:SetMainTab(1)