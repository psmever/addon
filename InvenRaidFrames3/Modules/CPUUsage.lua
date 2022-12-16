local _G = _G
local pairs = _G.pairs
local GetTime = _G.GetTime
local UnitBuff = _G.UnitBuff
local IRF3 = _G[...]

local SL = IRF3.GetSpellName
local testTime = GetTime()-0.00001
local afterCPU = 0
local afterTestCPU = 0
local updateFrequency = 1
local updateTimer = 0
local InvenRaidFrames3CPUUsage = nil

local function formatNumber(number,pattern)
	local isBig = number>=1000
  number = string.format(pattern,number)
	if isBig then
	  local subCount
	  repeat
		number,subCount = number:gsub("^(-?%d+)(%d%d%d)","%1,%2")
	  until subCount==0
	end
  return number
end

local function InitText()
  InvenRaidFrames3CPUUsage.TextTitle = {}
  InvenRaidFrames3CPUUsage.Text = {}
  InvenRaidFrames3CPUUsage.CPU = {}
  InvenRaidFrames3CPUUsage.CPUCount = {}
end

local nextIndex = 0
local function AddTextBar(index, text, JustifyH, PointV, PointX, PointY, addX)
	local StartTop = 173
	PointY = -12 * nextIndex
	InvenRaidFrames3CPUUsage.TextTitle[index] = InvenRaidFrames3CPUUsage:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	InvenRaidFrames3CPUUsage.TextTitle[index]:SetWidth(200)
	InvenRaidFrames3CPUUsage.TextTitle[index]:SetJustifyH(JustifyH)
	InvenRaidFrames3CPUUsage.TextTitle[index]:SetWordWrap(false)
	InvenRaidFrames3CPUUsage.TextTitle[index]:SetText(text)
	InvenRaidFrames3CPUUsage.TextTitle[index]:SetPoint(PointV, PointX, PointY + StartTop)
	InvenRaidFrames3CPUUsage.Text[index] = InvenRaidFrames3CPUUsage:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	InvenRaidFrames3CPUUsage.Text[index]:SetWidth(200)
	InvenRaidFrames3CPUUsage.Text[index]:SetJustifyH(JustifyH)
	InvenRaidFrames3CPUUsage.Text[index]:SetWordWrap(false)
	InvenRaidFrames3CPUUsage.Text[index]:SetText("")
	InvenRaidFrames3CPUUsage.Text[index]:SetPoint(PointV, PointX + addX, PointY + StartTop)
	InvenRaidFrames3CPUUsage.CPU[index] = 0
	InvenRaidFrames3CPUUsage.CPUCount[index] = 0

	nextIndex = nextIndex + 1
end

local function setBackgroundPoint(bg, context, inset, top, height)
	local minset = inset * (-1);
	bg:ClearAllPoints();
	bg:SetPoint("BOTTOMLEFT", context, "BOTTOMLEFT", minset, inset + top - height);
	bg:SetPoint("TOPLEFT", context, "TOPLEFT", minset, inset + top);
	bg:SetPoint("TOPRIGHT", context, "TOPRIGHT", inset, inset + top);
	bg:SetPoint("BOTTOMRIGHT", context, "BOTTOMRIGHT", inset, inset + top - height);
end

local function setBackgroundLevel(bg, context)
	local level = context:GetFrameLevel();
	bg:SetFrameLevel(level);
	context:SetFrameLevel(level+1);
end

local function setBackground(bg, frame, inset, top, height)
	setBackgroundPoint(bg, frame, inset, top, height)
	setBackgroundLevel(bg, frame);
end

local InvenRaidFrames3_ColorBorder = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileSize = 20,
	edgeSize = 15,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function setBackColor(frame, mode)
  if IRF3.db.disableLibAuras then
	mode = mode + 1
  else
	mode = mode + 3
  end
  if mode == 1 then
    frame:SetBackdropColor(.3, .3, .3, 1);  -- 비활성
	elseif mode == 2 then
    frame:SetBackdropColor(.4, .4, .4, 1);  -- 비활성 마우스오버
	elseif mode == 3 then
    frame:SetBackdropColor(.7, .7, .7, 1);  -- 활성화
	else
    frame:SetBackdropColor(.8, .8, .8, 1);  -- 활성화 마우스오버
	end
end

local function setColor(frame)
	frame:SetBackdropBorderColor(1, 1, 0, 1);
	setBackColor(frame, 1);
end

local function setBorder(frame)
	if (not WindActionPetConfig or WindActionPetConfig[6]) then
		frame:SetBackdrop(InvenRaidFrames3_ColorBorder);
		setColor(frame);
	else
		InvenRaidFrames3CPUUsage:SetBackdrop(nil);
	end
end

local function SetItem(index, func)
	if not func then
		InvenRaidFrames3CPUUsage.Text[index]:SetText(" ")
		InvenRaidFrames3CPUUsage.CPU[index] = nil
		InvenRaidFrames3CPUUsage.CPUCount[index] = nil
	else

		local rTime, rCount = GetFunctionCPUUsage(func, true)

		InvenRaidFrames3CPUUsage.Text[index]:SetText(formatNumber(rTime - InvenRaidFrames3CPUUsage.CPU[index],"%.2f\124cffffd200ms/s  ").. rCount - InvenRaidFrames3CPUUsage.CPUCount[index] .."/"..rCount.."회")
		InvenRaidFrames3CPUUsage.CPU[index] = rTime
		InvenRaidFrames3CPUUsage.CPUCount[index] = rCount
  end
end

local function updateTextColor()
	if not InvenRaidFrames3CPUUsage then
		return
	end
	if not IRF3.db.disableLibAuras then
		InvenRaidFrames3CPUUsage.TextTitle["탐색함수1"]:SetAlpha(0.5)
		InvenRaidFrames3CPUUsage.Text["탐색함수1"]:SetAlpha(0.5)
		InvenRaidFrames3CPUUsage.TextTitle["탐색함수2"]:SetAlpha(1)
		InvenRaidFrames3CPUUsage.Text["탐색함수2"]:SetAlpha(1)
	else
		InvenRaidFrames3CPUUsage.TextTitle["탐색함수1"]:SetAlpha(1)
		InvenRaidFrames3CPUUsage.Text["탐색함수1"]:SetAlpha(1)
		InvenRaidFrames3CPUUsage.TextTitle["탐색함수2"]:SetAlpha(0.5)
		InvenRaidFrames3CPUUsage.Text["탐색함수2"]:SetAlpha(0.5)
	end
end

local function InitUI()
  InitText()
  local x = -5
  AddTextBar("TITLE", "LibAuras ON", "CENTER", "TOP", 0, 0, 0)
  AddTextBar("MEM", "Mem : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("CPU", "CPU : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar(" ", " ", "LEFT", "TOP", x + 0, 0, 155)
  
  AddTextBar("탐색함수1", "탐색함수1 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("탐색함수2", "탐색함수2 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar(" ", " ", "LEFT", "TOP", x + 0, 0, 155)
  
  AddTextBar("주문타이머", "주문타이머 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("디버프", "디버프 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("공대버프", "공대버프 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("생존기", "생존기 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("UnitInPhase", "UnitInPhase : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar(" ", " ", "LEFT", "TOP", x + 0, 0, 155)
  
  AddTextBar("OnUpdate", "OnUpdate : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("OnUpdate2", "OnUpdate2 : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("UpdateState", "UpdateState : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("UpdateRaidIcon", "UpdateRaidIcon : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("UnitDistanceSquared", "UnitDistanceSquared : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar(" ", " ", "LEFT", "TOP", x + 0, 0, 155)
  
  AddTextBar("UpdateLostHealth", "UpdateLostHealth : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar("UpdateDisplayText", "UpdateDisplayText : ", "LEFT", "TOP", x + 0, 0, 155)
  AddTextBar(" ", " ", "LEFT", "TOP", x + 0, 0, 155)
  
  
  AddTextBar("OnEvent", "OnEvent : ", "LEFT", "TOP", x + 0, 0, 155)
  
--[[
  AddTextBar("UpdateHealth", "UpdateHealth : ", "LEFT", "TOP", x + 0, -186, 140)
  AddTextBar("UpdateMaxPower", "UpdateMaxPower : ", "LEFT", "TOP", x + 0, -198, 140)
  AddTextBar("UpdatePower", "UpdatePower : ", "LEFT", "TOP", x + 0, -210, 140)
  AddTextBar("UpdatePowerColor", "UpdatePowerColor : ", "LEFT", "TOP", x + 0, -222, 140)
  AddTextBar("UpdateHealPrediction", "UpdateHealPrediction : ", "LEFT", "TOP", x + 0, -234, 140)
  
  AddTextBar("OnSpellTimerHide", "OnSpellTimerHide : ", "LEFT", "TOP", x + 0, -248, 140)
  AddTextBar("OnDebuffHide", "OnDebuffHide : ", "LEFT", "TOP", x + 0, -260, 140)
  AddTextBar("OnEnter", "OnEnter : ", "LEFT", "TOP", x + 0, -272, 140)
  AddTextBar("OnLeave", "OnLeave : ", "LEFT", "TOP", x + 0, -284, 140)
--]]
			
  updateTextColor()
end
function InvenRaidFrames3CPUUsage_Click()
	if not IRF3.db.disableLibAuras then
		IRF3.db.disableLibAuras = true
		DEFAULT_CHAT_FRAME:AddMessage("IRF Aura Library OFF", 1,1,1);
		if InvenRaidFrames3CPUUsage ~= nil and InvenRaidFrames3CPUUsage:IsShown() then
			InvenRaidFrames3CPUUsage.TextTitle["TITLE"]:SetText("LibAuras OFF")
		end
		LibStub("IRFLibAuras"):Stop()
	else
		IRF3.db.disableLibAuras = false
		DEFAULT_CHAT_FRAME:AddMessage("IRF Aura Library ON", 1,1,1);
		if InvenRaidFrames3CPUUsage ~= nil and InvenRaidFrames3CPUUsage:IsShown() then
			InvenRaidFrames3CPUUsage.TextTitle["TITLE"]:SetText("LibAuras ON")
		end
		LibStub("IRFLibAuras"):Start()
	end
	updateTextColor()
end
function InvenRaidFrames3CPUUsage_Load()

	InvenRaidFrames3CPUUsage = CreateFrame("Button", "IRF_TEST", IRF3, BackdropTemplateMixin and "BackdropTemplate")-- and "SecureHandlerClickTemplate")
	InvenRaidFrames3CPUUsage:SetFrameStrata("MEDIUM")
	InvenRaidFrames3CPUUsage:SetMovable(true)
	InvenRaidFrames3CPUUsage:SetClampedToScreen(true)
	InvenRaidFrames3CPUUsage:RegisterForClicks("AnyUp")

	InvenRaidFrames3CPUUsagePopup = CreateFrame("Button", "IRF_TEST2", IRF3, BackdropTemplateMixin and "BackdropTemplate")-- and "SecureHandlerClickTemplate")
	InvenRaidFrames3CPUUsagePopup:SetFrameStrata("MEDIUM")
	InvenRaidFrames3CPUUsagePopup:SetMovable(true)
	InvenRaidFrames3CPUUsagePopup:SetWidth(10)
	InvenRaidFrames3CPUUsagePopup:SetHeight(10)
	InvenRaidFrames3CPUUsagePopup:SetClampedToScreen(true)
	InvenRaidFrames3CPUUsagePopup:RegisterForClicks("AnyUp")
	InvenRaidFrames3CPUUsagePopup:Hide()

	InitUI()
	
  InvenRaidFrames3CPUUsage:SetScript('OnClick', function(self, button, down)
	if button == "LeftButton" then
	  ResetCPUUsage()
	  afterCPU = 0
	  InvenRaidFrames3CPUUsage_Click()
--	  setBackColor(InvenRaidFrames3CPUUsage, 1)
	elseif button =="RightButton" then
--	  InvenRaidFrames3CPUUsage:Hide()
--	  InvenRaidFrames3CPUUsagePopup:Show()
	end
  end)
  InvenRaidFrames3CPUUsagePopup:SetScript('OnClick', function(self, button, down)
	InvenRaidFrames3CPUUsage:Show()
	InvenRaidFrames3CPUUsagePopup:Hide()
  end)

  InvenRaidFrames3CPUUsage:SetScript('OnEnter', function()
--	setBackColor(InvenRaidFrames3CPUUsage, 1)
  end)
  InvenRaidFrames3CPUUsage:SetScript('OnLeave', function()
--	setBackColor(InvenRaidFrames3CPUUsage, 0)
  end)

	InvenRaidFrames3CPUUsage:SetScript("OnUpdate", function(self, elapsed)

		updateTimer = updateTimer + elapsed
		if updateTimer > updateFrequency then
			updateTimer = updateTimer - updateFrequency
			local framerate = GetFramerate();
			UpdateAddOnMemoryUsage()
			UpdateAddOnCPUUsage()
			local mem = GetAddOnMemoryUsage("InvenRaidFrames3") / 1000
			local cpu = GetAddOnCPUUsage("InvenRaidFrames3")
			InvenRaidFrames3CPUUsage.Text["MEM"]:SetText(formatNumber(mem,"%.1f\124cffffd200MB  FPS: ".. floor(framerate)))
			InvenRaidFrames3CPUUsage.Text["CPU"]:SetText(formatNumber((cpu - afterCPU),"%.2f \124cffffd200ms/s"))
			afterCPU = cpu
			SetItem(" ", nil)


			SetItem("탐색함수1", InvenRaidFrames3Member_UnitAura1)
			SetItem("탐색함수2", InvenRaidFrames3Member_UnitAura2)
			SetItem(" ", nil)
			
			SetItem("주문타이머", InvenRaidFrames3Member_UpdateSpellTimer)			
			SetItem("디버프", InvenRaidFrames3Member_UpdateAura)
			SetItem("공대버프", InvenRaidFrames3Member_UpdateBuffs)
			SetItem("생존기", InvenRaidFrames3Member_UpdateSurvivalSkill)
			SetItem("UnitInPhase", UnitPhaseReason)
  
			SetItem(" ", nil)
			
			SetItem("OnUpdate", InvenRaidFrames3Member_OnUpdate)
			SetItem("OnUpdate2", InvenRaidFrames3Member_OnUpdate2)
			SetItem("UpdateState", InvenRaidFrames3Member_UpdateState)
			SetItem("UpdateRaidIcon", InvenRaidFrames3Member_UpdateRaidIconTarget)
			SetItem("UnitDistanceSquared", UnitDistanceSquared)
			SetItem(" ", nil)
			
			SetItem("UpdateLostHealth", InvenRaidFrames3Member_UpdateLostHealth)
			SetItem("UpdateDisplayText", InvenRaidFrames3Member_UpdateDisplayText)
			SetItem(" ", nil)
			
			SetItem("OnEvent", InvenRaidFrames3Member_OnEvent)
			
--[[			
			SetItem("UpdateHealth", InvenRaidFrames3Member_UpdateHealth)
			SetItem("UpdateMaxPower", InvenRaidFrames3Member_UpdateMaxPower)
			SetItem("UpdatePower", InvenRaidFrames3Member_UpdatePower)
			SetItem("UpdatePowerColor", InvenRaidFrames3Member_UpdatePowerColor)
			SetItem("UpdateHealPrediction", InvenRaidFrames3Member_UpdateHealPrediction)
			
			SetItem("OnSpellTimerHide", InvenRaidFrames3Member_OnSpellTimerHide)
			SetItem("OnDebuffHide", InvenRaidFrames3Member_OnDebuffHide)
			SetItem("OnEnter", InvenRaidFrames3Member_OnEnter)
			SetItem("OnLeave", InvenRaidFrames3Member_OnLeave)
--]]			
  
			
		end
	end)

	setBackground(InvenRaidFrames3CPUUsage, InvenRaidFrames3, 80, 35, 52)
--	setBorder(InvenRaidFrames3CPUUsage)
	setBackground(InvenRaidFrames3CPUUsagePopup, InvenRaidFrames3, 2, 80, 1)
--	setBorder(InvenRaidFrames3CPUUsagePopup)
	InvenRaidFrames3CPUUsagePopup:SetScale(0.3)


end

function InvenRaidFrames3CPUUsage_Toggle()
	local enable = InvenRaidFrames3DB.CPUUsage--GetCVar("scriptProfile")
	SetCVar("scriptProfile",enable and 1 or 0)
	ReloadUI()
--[[
	if InvenRaidFrames3CPUUsage then
		if InvenRaidFrames3CPUUsage:IsShown() then
			InvenRaidFrames3CPUUsage:Hide()
		else
			InvenRaidFrames3CPUUsage:Show()
		end
	else
		InvenRaidFrames3CPUUsage_Load()
	end
--]]	
end