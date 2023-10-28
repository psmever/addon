local _G = _G
local UnitExists = _G.UnitExists
local UnitIsUnit = _G.UnitIsUnit
local GetCursorPosition = _G.GetCursorPosition
local IRF3 = _G[...]

local cx, cy, uiScale

local function showPing(member, cursor)

	IRF3.ping:ClearAllPoints()

	if cursor then
		cx, cy = GetCursorPosition()
		uiScale = UIParent:GetEffectiveScale()
		IRF3.ping:SetPoint("CENTER", nil, "BOTTOMLEFT", cx / uiScale, cy / uiScale)
		cx, cy, uiScale = nil
	else
		IRF3.ping:SetPoint("CENTER", member, 0, 0)
	end
	IRF3.ping:Show()
end

function IRF3:UNIT_SPELLCAST_SENT(unit, target, _ , spell )
local _,GCDleft = GetSpellCooldown(61304)--global cooldown

--	IRF3PartyTarget:SetEnabled(false) --전투중안됨
--	IRF3RaidTarget:SetEnabled(false)

	IRF3PartyTarget:RegisterForClicks() 
	IRF3RaidTarget:RegisterForClicks()
	IRF3RaidTargetMelee:RegisterForClicks()

C_Timer.After(GCDleft,function() 
 
--for k,name in pairs({"IRF3Target","IRF3Focus","IRF3PartyTarget","IRF3PartyFocus","IRF3RaidTarget","IRF3RaidFocus"}) do
	IRF3PartyTarget:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
	IRF3RaidTarget:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
	IRF3RaidTargetMelee:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

--end


--시전성공하여 GCD가 돌면 그 다음까진 비활성화됨
--시전이 실패하여 GCD가 안돌면, 클릭시마다 계속 index가 증가됨(시야,거리,약화된 영혼 케이스등일때 다음 공대원으로 넘어가기 위해)


end)
	if target and UnitExists(target) then
	
		if self.db.castingSent ~= 0 then

			if self.onEnter and self.onEnter.displayedUnit and UnitIsUnit(self.onEnter.displayedUnit, target) then
				showPing(self.onEnter, true)
			elseif self.db.castingSent == 1 then
				for member in pairs(self.visibleMembers) do
					if member.displayedUnit and UnitIsUnit(member.displayedUnit, target) then
						showPing(member)
						break
					end
				end
			end
		end
	end
end

--IRF3:RegisterEvent("UNIT_SPELLCAST_SENT")
