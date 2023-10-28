﻿local IRF3 = InvenRaidFrames3 
local Option = IRF3.optionFrame
local LBO = LibStub("LibBlueOption-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")

function Option:CreateAdvancedMenu(menu, parent)
	self.CreateAdvancedMenu = nil



	menu.enableTankFrame = LBO:CreateWidget("CheckBox", parent, L["방어전담 프레임"], L["방어전담 프레임desc"], nil, nil, true,
		function() return IRF3.db.enableTankFrame end,
		function(v)
			IRF3.db.enableTankFrame = v
			Option:SetOption("enableTankFrame", v)
 
			
		end
	)
--	menu.enableTankFrame:SetPoint("TOP", menu.SpellTimerFontColor, "BOTTOM", 0, 0)
	menu.enableTankFrame:SetPoint("TOPLEFT", 5, -5)


	menu.library1 = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	menu.library1:SetText(L["외부 라이브러리"])
	menu.library1:SetPoint("TOPLEFT", menu.enableTankFrame,"BOTTOMLEFT" , 0)


	--외부 라이브러리 : Combat Log Health
	menu.enableInstantHealth = LBO:CreateWidget("CheckBox", parent, "Combat Log Health", L["CombatLogHealthdesc"], nil, nil, true,
		function() return IRF3.db.enableInstantHealth end,
		function(v)
			IRF3.db.enableInstantHealth = v
			Option:SetOption("enableInstantHealth", v)
			IRF3:SetupLib()
		end
	)
	menu.enableInstantHealth:SetPoint("TOPLEFT", menu.library1, "BOTTOMLEFT", 0, 0)



	--외부 라이브러리 : HealComm
	menu.enableHealComm = LBO:CreateWidget("CheckBox", parent, L["HealComm"], L["HealCommdesc"], nil, nil, true,
		function() return IRF3.db.enableHealComm end,
		function(v)
			IRF3.db.enableHealComm = v
			Option:SetOption("enableHealComm", v)
			IRF3:SetupLib()
		end
	)
	menu.enableHealComm:SetPoint("TOPLEFT", menu.enableInstantHealth, "BOTTOMLEFT", 0, 0)

	--외부 라이브러리 : SmoothEffect
	menu.smootheffect  = LBO:CreateWidget("CheckBox", parent, L["Smoothbar"], L["Smoothbardesc"], nil, nil, true,
 		function() return IRF3.db.smootheffect end,
 
 		function(v)
 			IRF3.db.smootheffect = v
			Option:SetOption("smootheffect", v)
			IRF3:SetupLib()
 
 		end
 	) 
 	menu.smootheffect:SetPoint("TOPLEFT", menu.enableHealComm, "BOTTOMLEFT", 0, 0)


 



--	menu.CPUUsage = LBO:CreateWidget("CheckBox", parent, "CPU사용량 표시", "좌클릭: 라이브러리 사용/해제 , 우클릭: 감추기/열기", nil, nil, true,
--		function() return IRF3.db.CPUUsage end,
--		function(v)
--			IRF3.db.CPUUsage = v
-- 			InvenRaidFrames3CPUUsage_Toggle()
-- 		end
-- 	)
-- 	menu.CPUUsage:SetPoint("TOP", menu.reload , "BOTTOM", 0, 0)

end