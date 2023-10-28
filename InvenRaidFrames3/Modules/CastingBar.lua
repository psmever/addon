local _G = _G
local GetTime = _G.GetTime
local UnitCastingInfo = _G.UnitCastingInfo
local UnitChannelInfo = _G.UnitChannelInfo
local IRF3 = _G[...]


function InvenRaidFrames3Member_SetupCastingBarPos(self)

	if IRF3.db.units.castingBarPos == 1 then
		self.castingBar:SetPoint("TOPLEFT", 0, 0)
		self.castingBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -IRF3.db.units.castingBarHeight)
		self.castingBar:SetOrientation("HORIZONTAL")

 

	
	elseif IRF3.db.units.castingBarPos == 2 then
		self.castingBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, IRF3.db.units.castingBarHeight)
		self.castingBar:SetPoint("BOTTOMRIGHT", 0, 0)
		self.castingBar:SetOrientation("HORIZONTAL")
 		self.castingBar.castname:Show() --상하에는 주문명 보여줌

 


	elseif IRF3.db.units.castingBarPos == 3 then
		self.castingBar:SetPoint("TOPLEFT", 0, 0)
		self.castingBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", IRF3.db.units.castingBarHeight, 0)
		self.castingBar:SetOrientation("VERTICAL")
 		self.castingBar.castname:Hide() --좌우에는 주문명숨김

	elseif IRF3.db.units.castingBarPos == 4 then
		self.castingBar:SetPoint("TOPLEFT", self, "TOPRIGHT", -IRF3.db.units.castingBarHeight, 0)
		self.castingBar:SetPoint("BOTTOMRIGHT", 0, 0)
		self.castingBar:SetOrientation("VERTICAL")
 		self.castingBar.castname:Hide() --좌우에는 주문명숨김
 
	else
		self.castingBar:Hide() 
	end 

--backdrop 생성
	if not self.castingBar.outline then
		self.castingBar.outline = CreateFrame("Frame", nil, self.castingBar, BackdropTemplateMixin and "BackdropTemplate")
		self.castingBar.outline:SetPoint("TOPLEFT", self.castingBar, "TOPLEFT", 0, 0);
		self.castingBar.outline:SetPoint("BOTTOMRIGHT", self.castingBar, "BOTTOMRIGHT", 0, 0);
		self.castingBar.outline:SetBackdrop({
--			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			bgFile = "UI-SliderBar-Background",
--			edgeFile = "Interface\\Addons\\InvenRaidFrames3\\Texture\\Border.tga",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			edgeSize = 4,
--			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})

	end



--아이콘 정보 사용하면 아이콘과 주문명 show

		if IRF3.db.units.useCastingBar and IRF3.db.units.useCastingBarIcon   then

	self.castingBar.icon:SetSize(IRF3.db.units.castingBarHeight or 5,IRF3.db.units.castingBarHeight or 5)
	self.castingBar.castname:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.units.castingBarFontSize or 5, IRF3.db.font.attribute)

	 		self.castingBar.icon:Show() 
			if IRF3.db.units.castingBarPos==1 or IRF3.db.units.castingBarPos==2 then --상하에만 주문명 표기(좌우는 자리없음)
		 		self.castingBar.castname:Show()			
			else
		 		self.castingBar.castname:Hide()			
			end
			
			--text/icon 세부조정(TOPLEFT는 template에 지정되어있는데, BOTTOMRIGHT가 설정따라 달라짐
			if IRF3.db.units.castingBarPos == 1 then
				self.castingBar.castname:SetPoint("TOPLEFT",self.castingBar.icon,"TOPRIGHT")
				self.castingBar.castname:SetPoint("BOTTOMRIGHT",self.castingBar,"TOPRIGHT",0,-IRF3.db.units.castingBarFontSize)
			elseif IRF3.db.units.castingBarPos == 2 then
				self.castingBar.castname:SetPoint("TOPLEFT",self.castingBar.icon,"BOTTOMRIGHT",0,IRF3.db.units.castingBarFontSize)
				self.castingBar.castname:SetPoint("BOTTOMRIGHT",self.castingBar,"BOTTOMRIGHT")
			else--3,4의 경우 주문명을 표기하지 않음
			end

			self.castingBar.background:SetColorTexture(0, 0, 0,0.8)--아이콘/주문명을 표시하면 배경지정
		else
	 		self.castingBar.icon:Hide()
	 		self.castingBar.castname:Hide()
			self.castingBar.background:SetColorTexture(0, 0, 0,0) --아이콘/주문명을 표시하지않으면 배경도 필요없음
			self.castingBar.outline:SetBackdrop(nil)
		end
 
	





 


end

function InvenRaidFrames3Member_CastingBarOnUpdate(self)

	self:SetValue(self.isChannel and ((self.endTime - GetTime()) * 1000) or ((GetTime() - self.startTime) * 1000))
end

function InvenRaidFrames3Member_UpdateCastingBar(self,spellID,stopflag)
local spellName,_,icon = GetSpellInfo(spellID)

--[[
if stopflag then 
	self.castingBar.castname:SetText("")
	self.castingBar.icon:SetTexture(nil)
else

	self.castingBar.castname:SetText(spellName)
	self.castingBar.icon:SetTexture(icon)

end
]]--

if not stopflag then
	self.castingBar.castname:SetText(spellName)
	self.castingBar.icon:SetTexture(icon)
end


	if IRF3.db.units.useCastingBar then
		self.castingBar.startTime, self.castingBar.endTime = select(4, UnitCastingInfo(self.displayedUnit))
		if self.castingBar.startTime then
			self.castingBar.startTime, self.castingBar.endTime, self.castingBar.isChannel = self.castingBar.startTime / 1000, self.castingBar.endTime / 1000, false
			self.castingBar:SetMinMaxValues(0, (self.castingBar.endTime - self.castingBar.startTime) * 1000)
			if not self.castingBar.ticker then
				self.castingBar.ticker = C_Timer.NewTicker(0.05, function() InvenRaidFrames3Member_CastingBarOnUpdate(self.castingBar) end)
			end
			InvenRaidFrames3Member_CastingBarOnUpdate(self.castingBar)
			return self.castingBar:Show()
		else
			self.castingBar.startTime, self.castingBar.endTime = select(4, UnitChannelInfo(self.displayedUnit))
			if self.castingBar.startTime then
				self.castingBar.startTime, self.castingBar.endTime, self.castingBar.isChannel = self.castingBar.startTime / 1000, self.castingBar.endTime / 1000, true
				self.castingBar:SetMinMaxValues(0, (self.castingBar.endTime - self.castingBar.startTime) * 1000)
				if not self.castingBar.ticker then
					self.castingBar.ticker = C_Timer.NewTicker(0.05, function() InvenRaidFrames3Member_CastingBarOnUpdate(self.castingBar) end)
				end
				InvenRaidFrames3Member_CastingBarOnUpdate(self.castingBar)
				return self.castingBar:Show()
			end
		end
	end
	if self.castingBar.ticker then -- 정상적인 캐스팅 완료 시
		self.castingBar.ticker:Cancel()
		self.castingBar.ticker = nil
	end
	self.castingBar.startTime, self.castingBar.endTime, self.castingBar.isChannel = nil
	self.castingBar:Hide()
end
