local _G = _G
local IRF3 = _G[...]
local GetTime = _G.GetTime
local UnitBuff = _G.UnitBuff
local UnitDebuff = _G.UnitDebuff
local PlaySoundFile = _G.PlaySoundFile
local SM = LibStub("LibSharedMedia-3.0")
local LRD = LibStub("LibRealDispel-1.0")
local glowinit ={}
local LCG = LibStub("LibCustomGlow-1.0") --Glow 효과용
local ignoreAuraId = {}
local ignoreAuraName = {}
local bossAuraId = {}
local bossAuraName = {}

local bossAurdGlow = {}
local bossAuraGlowColorR = {}
local bossAuraGlowColorG = {}
local bossAuraGlowColorB = {}
local specialdebuff ={ [72293]=true,[70157]=true,} --사울팽 징표,신드라고사 얼음무덤(힐안들어감)
 

IRF3.ignoreAura = {
	[6788] = true, [8326] = true, [11196] = true, [15822] = true, [21163] = true,
	[24360] = true, [24755] = true, [25771] = true, [26004] = true, [26013] = true,
	[26680] = true, [28504] = true, [29232] = true, [30108] = true,
	[30529] = true, [36032] = true, [36893] = true, [36900] = true, [36901] = true,
	[40880] = true, [40882] = true, [40883] = true, [40891] = true, [40896] = true,
	[40897] = true, [41292] = true, [41337] = true, [41350] = true, [41425] = true,
	[43681] = true, [55711] = true, [57723] = true, [57724] = true, [64805] = true,
	[64808] = true, [64809] = true, [64810] = true, [64811] = true, [64812] = true,
	[64813] = true, [64814] = true, [64815] = true, [64816] = true, [69127] = true,
	[69438] = true, [70402] = true, [71328] = true, [72144] = true, [72145] = true, [36895] = true, [71041] = true,
}

IRF3.bossAura = {

[45151] = true,  -- 브루탈루스
[45866] = true, [45665] = true, --지옥안개
[45342] = true, [45256] = true, [45270] = true, --쌍둥이
[45996] = true, --므우루
[45641] = true, [45885] = true, --킬제덴
--[106872] = true, [107268] = true, [111600] = true, [118961] = true, [145206] = true, [153795] = true, [155721] = true, [160029] = true, [185093] = true, [192048] = true, [192706] = true, [193069] = true, [193367] = true, [193783] = true, [194327] = true, [196068] = true, [197943] = true, [198006] = true, [198190] = true, [199063] = true, [201146] = true, [203096] = true, [203770] = true, [203774] = true, [204463] = true, [204517] = true, [204531] = true, [204611] = true, [204859] = true, [204895] = true, [204962] = true, [205201] = true, [205344] = true, [205649] = true, [205771] = true, [205984] = true, [206384] = true, [206480] = true, [206617] = true, [206651] = true, [206798] = true, [206936] = true, [208431] = true, [208929] = true, [209011] = true, [209158] = true, [209244] = true, [209598] = true, [209615] = true, [209973] = true, [210315] = true, [210863] = true, [210879] = true, [211471] = true, [211802] = true, [211939] = true, [212568] = true, [214167] = true, [214335] = true, [215449] = true,
-- [216040] = true, [217093] = true, [218304] = true, [218342] = true, [218350] = true, [218368] = true, [218809] = true, [219024] = true, [219025] = true, [219602] = true, [219610] = true, [219812] = true, [219964] = true, [219965] = true, [219966] = true, [221028] = true, [221246] = true, [221344] = true, [221606] = true, [221891] = true, [222178] = true, [222719] = true, [223511] = true, [223655] = true, [224188] = true, [225080] = true, [225105] = true, [227832] = true, [228029] = true, [228054] = true, [228248] = true, [228249] = true, [228253] = true, [228270] = true, [228280] = true, [228331] = true, [228883] = true, [228918] = true, [229159] = true, [230139] = true, [230201] = true, [230362] = true, [231363] = true, [231729] = true, [231998] = true, [232249] = true, [233272] = true, [233568] = true, [233570] = true, [233963] = true, [233983] = true, [234114] = true, [235117] = true, [235222] = true, [236283] = true, [236459] = true, [236494] = true, [236519] = true, [236550] = true, [236596] = true,
-- [236710] = true, [238018] = true, [238598] = true, [239264] = true, [239739] = true, [240447] = true, [240706] = true, [240735] = true, [243299] = true, [245509] = true, 
--리분
	[51121] = true, [55249] = true, [55550] = true, [56112] = true,
	[57975] = true, [58517] = true, [59265] = true, 
	[59847] = true, --전하충전

	[61888] = true, --압도적인 힘
	[64637] = true,--압도적인 힘

	[61903] = true, --융해의 주먹
	[63493] = true, --융해의 주먹

	 [61968] = true, --순간빙결(10,25)
	 [61969] = true,--순간빙결

	 [62130] = true,--혼란의 일격(10,25)


	[62331] = true,--꿰뚫기
	[62526] = true,--룬폭발
	 [62532] = true,--관리인의 손아귀
	 [62589] = true,--자연의 격노
	 [62661] = true,--이글거리는 불길(10,25)
	 [62717] = true,--용암재단지
	[63018] = true,--타오르는 빛(10)
	[65121] = true,--타오르는 빛(25)

	 [63276] = true, --얼굴없는 자의징표(10/25)
	[63355] = true,--방어구 씹기
	 [63498] = true,--고전압
	 [63666] = true,--네이팜탄(10)
	 [65026] = true,--네이팜탄(25)
	[63830] = true,--병든 정신(10/25)
	 [63024] = true,--중력폭탄(10)
	 [64234] = true,--중력폭탄(25)
	 [64292] = true,--바위 손아귀
	 [64396] = true,--무리수호자
	[64705] = true,--억제할수없는 불길
	[64771] = true,--방어구 융해

	 [65598] = true,--빛의 폭탄
	 [66013] = true,--냉기 관통
	[66869] = true, --불타는 담즙

	[67574] = true, [69065] = true,
	[69200] = true, [69240] = true, [69278] = true, [69409] = true, [69483] = true,
	[69674] = true, [70126] = true, [70337] = true, [70447] = true, [70541] = true,
	[70672] = true, [70867] = true, [71204] = true, [71289] = true, [71330] = true,
	[71340] = true, [72004] = true, [72219] = true, [72293] = true, [72385] = true,
	[72408] = true, [72451] = true,
	[27808] = true, [61912] = true,
}

local dispelTypes = { Magic = "Magic", Curse = "Curse", Disease = "Disease", Poison = "Poison" }
local lastTime =  0

local function hideIcon(icon)
	if icon and icon:IsShown() then
		icon:SetSize(0.001, 0.001)
		icon:Hide()
		if GameTooltip:IsOwned(icon) then
			GameTooltip:Hide()
		end
	end
end

local function bossAuraOnUpdate(self, opt)

	if opt == 1 then
--print(self.alertTimer)
--		if (self.endTime - GetTime()) > 2.5 then

		if (self.endTime - GetTime()) > self.alertTimer  then
		self.timerParent.text:SetFormattedText("%d", self.endTime - GetTime() + 0.1)
		else
			self.timerParent.text:SetFormattedText("|cffff0000%.1f|r", self.endTime - GetTime() + 0.1)

		end
	elseif opt == 2 then
		self.timerParent.text:SetFormattedText("%d", GetTime() - self.startTime)
--	else
--		self.timerParent.text:SetText("")
	end

end


local function debuffIconOnUpdate(self, opt)
	
	if opt == 1 and self.endTime and self.endTime >= GetTime() then

		if self.endTime - GetTime() > 3600 then --1시간이상이면
			self.timer:SetFormattedText("%d%s", (self.endTime - GetTime()+0.1)/3600 ,"h")
		elseif self.endTime - GetTime() > 60 then --1분이상이면
			self.timer:SetFormattedText("%d%s", (self.endTime - GetTime()+0.1)/60 ,"m")
		else
			self.timer:SetFormattedText("%d", self.endTime - GetTime()+0.1 )
		end
	elseif opt == 2 then
		self.timer:SetFormattedText("%d", GetTime() - self.startTime)
	else
		self.timer:SetText("")

	end
end



function IRF3:BuildAuraList()
	table.wipe(ignoreAuraId)
	table.wipe(ignoreAuraName)
	table.wipe(bossAuraId)
	table.wipe(bossAuraName)
	for spellid in pairs(IRF3.ignoreAura) do
		if IRF3.db.ignoreAura[spellid] ~= false then
			ignoreAuraId[spellid] = true
		end
	end
	for spell, v in pairs(IRF3.db.ignoreAura) do
		if v == true then
			if type(spell) == "number" then
				ignoreAuraId[spell] = true
			else
				ignoreAuraName[spell] = true
			end
		end
	end
	for spellid2 in pairs(IRF3.bossAura) do
		if (IRF3.db.userAura[spellid2] ~= false) and not ignoreAuraId[spellid2] then
			bossAuraId[spellid2] = true
		end
	end
	for spell2, v in pairs(IRF3.db.userAura) do
		if (v == true) and not ignoreAuraId[spell2] and not ignoreAuraName[spell2] then
			if type(spell2) == "number" then
				bossAuraId[spell2] = true
			else
				bossAuraName[spell2] = true
			end


		
		end
	end
end

function InvenRaidFrames3Member_SetAuraFont(self)
 
	self.bossAura.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.font.size, "THINOUTLINE")
	self.bossAura.count:SetShadowColor(0, 0, 0)
	self.bossAura.count:SetShadowOffset(1, -1)
	self.bossAura.timerParent.text:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.font.size, "THINOUTLINE")
	self.bossAura.timerParent.text:SetShadowColor(0, 0, 0)
	self.bossAura.timerParent.text:SetShadowOffset(1, -1)
	self.bossAura.timerParent.text:ClearAllPoints()
	self.bossAura.timerParent.text:SetPoint("CENTER", self.bossAura.icon, "CENTER", 0, 0)
 

	for i = 1, 10 do
		local debuffIcon = self["debuffIcon"..i]
		debuffIcon.count:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.units.debuffIconFontSize or 8, "THINOUTLINE")
		debuffIcon.count:SetShadowColor(0, 0, 0)
		debuffIcon.count:SetShadowOffset(1, -1)
		debuffIcon.timer:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.units.debuffIconFontSize or 8, "THINOUTLINE")
		debuffIcon.timer:SetShadowColor(0, 0, 0)
		debuffIcon.timer:SetShadowOffset(1, -1)
		debuffIcon.timer:ClearAllPoints()
		debuffIcon.count:ClearAllPoints()
		debuffIcon.timer:SetPoint("TOPLEFT", debuffIcon.icon, "TOPLEFT", 0, 2)
		debuffIcon.count:SetPoint("BOTTOMRIGHT", debuffIcon.icon, "BOTTOMRIGHT", 4, 0)

			if IRF3.db.units.debuffIconTimerType ==1 then

				debuffIcon.cooldown:Show()
				debuffIcon.timer:Hide()

			else

				


				debuffIcon.timer:Show()

				debuffIcon.cooldown:Hide()
			end

	end
end





function InvenRaidFrames3Member_UpdateAura(self,isFullUpdate,updatedAuras)

--if isFullUpdate ~= nil then 
--print("Debuff UNIT_AURA_check:")
--print(isFullUpdate)
--end

	local isDebuffUpdate = nil	
	local isBossUpdate = nil	

	if self.bossAura:IsShown() then	
		isBossUpdate = true	
	end	
		
	if not isBossUpdate and not isFullUpdate and updatedAuras then	
		for index = 1, updatedAuras and #updatedAuras or 0 do	
			if not isDebuffUpdate and updatedAuras[index].isHarmful then	
				isDebuffUpdate = true	
			end	
			if updatedAuras[index].isBossAura then	
				isBossUpdate = true	
				break;	
			end	
			if bossAuraId[updatedAuras[index].spellId] or bossAuraName[updatedAuras[index].name] then	
				isBossUpdate = true	
				break;	
			end	
		end	
		if not isDebuffUpdate and not isBossUpdate then	
			return	
		end	
	else	
		isDebuffUpdate = true	
		isBossUpdate = true	
	end


	self.numDebuffIcons = 0

	local baIndex, baIsBuff, baIcon, baCount, baDuration, baExpirationTime, baAlertTimer, baIconSize, baAlpha
	local dispelable, dispelType
	local v_specialdebuff

	for i = 1, 40 do

			local name, icon, count, debuffType, duration, expirationTime, _, _, _, spellId, _, isBossAura = UnitDebuff(self.displayedUnit, i)--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellId, _, isBossAura = UnitDebuff(self.displayedUnit, i) -- fix 8.0

if specialdebuff[spellId]  then --특수디버프 체크(신드라고사 얼음무덤등)
	v_specialdebuff = true
end
		-- 디버프 체크
		if name then

			if not ignoreAuraId[spellId] and not ignoreAuraName[name] then
 
				debuffType = dispelTypes[debuffType] or "none"
				if isBossAura and not bossAuraId[spellId] and not bossAuraName[name] and IRF3.db.userAura[spellId] ~= false and IRF3.db.userAura[name] ~= false then
 
					IRF3.db.userAura[spellId] = true
					bossAuraId[spellId] = true

					IRF3:Message("새로운 중요 디버프 \""..name.."\"|1을;를; 발견하여 중요 디버프 목록에 추가합니다.")
				end
				if IRF3.db.units.useBossAura and (not baIndex or baIsBuff) and (bossAuraId[spellId] or bossAuraName[name]) then--디버프는 항상 버프에 우선합니다.
					-- 중요 오라 내용 임시 테이블에 저장
 
					baIndex = i
					baIsBuff = false
					baIcon = icon
					baCount = count
					baDuration = duration
					baExpirationTime = expirationTime
 
					--glow 정보
 
					--spellID 반짝임 우선
 
					if IRF3.db.userAuraGlow[spellId] ==true and bossAuraId[spellId] then

						baUserGlow = true
						baUserGlowColorR =IRF3.db.userAuraGlowColorR[spellId]
						baUserGlowColorG =IRF3.db.userAuraGlowColorG[spellId]
						baUserGlowColorB =IRF3.db.userAuraGlowColorB[spellId]
						if IRF3.db.useeachbossAura[spellId] then--개별설정이면
							baAlertTimer = IRF3.db.bossAuraAlertTimer[spellId] or 0
						else
							baAlertTimer = 2.5
						end


 
					elseif IRF3.db.userAuraGlow[name] == true and bossAuraName[name] then
	 

						baUserGlow = true
						baUserGlowColorR =IRF3.db.userAuraGlowColorR[name]
						baUserGlowColorG =IRF3.db.userAuraGlowColorG[name]
						baUserGlowColorB =IRF3.db.userAuraGlowColorB[name]
						if IRF3.db.useeachbossAura[name] then--개별설정이면
							baAlertTimer = IRF3.db.bossAuraAlertTimer[name] or 0
						else
							baAlertTimer = 2.5
						end

 
					else

						--반짝임 효과 없을 경우 + 해제되어 사라질 경우
						if LCG  then LCG.PixelGlow_Stop(self) end
						baUserGlow = false
						if IRF3.db.useeachbossAura[spellId] then--개별설정이면
							baAlertTimer = IRF3.db.bossAuraAlertTimer[spellId] or 0
						elseif IRF3.db.useeachbossAura[name] then
							baAlertTimer = IRF3.db.bossAuraAlertTimer[name] or 0
						else
							baAlertTimer = 2.5
						end 

				


					end

						if not baUserGlowColorR and not baUserGlowColorG and not baUserGlowColorB  then
							baUserGlowColorR=1
							baUserGlowColorG=0
							baUserGlowColorB=0
						end

 
 

--개별 중요오라 사이즈,투명도 판정
						if bossAuraId[spellId] then
							if IRF3.db.useeachbossAura[spellId] then --개별값 사용이면
								baIconSize = IRF3.db.bossAuraSize1[spellId] or 18  -- 아이콘 크기를 전체->개별로 변경. 개별사이즈 or 기존의 전체사이즈 or default 18로 지정
								baAlpha = IRF3.db.bossAuraAlpha1[spellId] or 1 --투명토를 전체->개별로 변경. 개별 투명도 or 전체투명도 or default 1로 지정
							else --전체설정 사용이면
								baIconSize = IRF3.db.units.bossAuraSize or 18  -- 아이콘 크기를 전체->개별로 변경. 개별사이즈 or 기존의 전체사이즈 or default 18로 지정
								baAlpha =  IRF3.db.units.bossAuraAlpha or 1 --투명토를 전체->개별로 변경. 개별 투명도 or 전체투명도 or default 1로 지정
							end


						else

							if IRF3.db.useeachbossAura[spellId] then --개별값 사용이면
								baIconSize = IRF3.db.bossAuraSize1[name] or 18  -- 아이콘 크기를 전체->개별로 변경. 개별사이즈 or 기존의 전체사이즈 or default 18로 지정
								baAlpha = IRF3.db.bossAuraAlpha1[name] or 1 --투명토를 전체->개별로 변경. 개별 투명도 or 전체투명도 or default 1로 지정
							else --전체설정 사용이면
								baIconSize = IRF3.db.units.bossAuraSize or 18  -- 아이콘 크기를 전체->개별로 변경. 개별사이즈 or 기존의 전체사이즈 or default 18로 지정
								baAlpha =  IRF3.db.units.bossAuraAlpha or 1 --투명토를 전체->개별로 변경. 개별 투명도 or 전체투명도 or default 1로 지정
							end
							--baIconSize = IRF3.db.bossAuraSize1[name] or IRF3.db.units.bossAuraSize or 18 -- 아이콘 크기를 전체->개별로 변경. 개별사이즈 or 기존의 전체사이즈 or default 18로 지정
							--baAlpha = IRF3.db.bossAuraAlpha1[name] or IRF3.db.units.bossAuraAlpha or 1 --투명토를 전체->개별로 변경. 개별 투명도 or 전체투명도 or default 1로 지정
						end			
 
--중요오라가 아닌 일반 디버프일때


				elseif IRF3.db.units.debuffIconFilter and IRF3.db.units.debuffIconFilter[debuffType] and (IRF3.db.units.debuffIcon or 0) > (self.numDebuffIcons or 0) then

 

					-- 디버프 아이콘
					self.numDebuffIcons = self.numDebuffIcons + 1
					local debuffIcon = self["debuffIcon"..self.numDebuffIcons]
					if debuffIcon then
						debuffIcon:SetSize(IRF3.db.units.debuffIconSize, IRF3.db.units.debuffIconSize)
						debuffIcon:SetID(i)
						if IRF3.db.colors[debuffType] then
							debuffIcon.color:SetColorTexture(IRF3.db.colors[debuffType][1], IRF3.db.colors[debuffType][2], IRF3.db.colors[debuffType][3])
						else
							debuffIcon.color:SetColorTexture(0, 0, 0)
						end
						debuffIcon.icon:SetTexture(icon)
						debuffIcon.count:SetText(count and count > 1 and count or nil)

 

			debuffIcon.endTime = expirationTime
			debuffIcon.startTime = expirationTime - duration
			if IRF3.db.units.debuffIconTimerType ==1 then
				debuffIcon.cooldown:SetCooldown(expirationTime - duration, duration)


			else

				

				if debuffIcon.count:GetText() then 
					debuffIcon.timer:SetPoint("TOPLEFT", debuffIcon.icon, "TOPLEFT", 0, 2)
				else
					debuffIcon.timer:ClearAllPoints() debuffIcon.timer:SetPoint("CENTER", debuffIcon.icon, "CENTER", 0, 0)   					
				 end --중첩이 없으면 가운데표기


			end



			if not debuffIcon.ticker then
--opt적용해야함
				debuffIcon.ticker = C_Timer.NewTicker(0.1, function() debuffIconOnUpdate(debuffIcon, duration>0 and 1 or 3) end)
			end
			debuffIconOnUpdate(debuffIcon, duration>0 and 1 or 3) --duration이 있으면 시간표시,없으면 무표시


						debuffIcon:Show()
					end
				end

 
				if not dispelable and LRD:CheckHelpDispel(debuffType) then
					dispelable = true
					dispelType = debuffType
				end
			end
		end
		-- 버프 체크
--클래식에 보스오라 없음->중요오라는 디버프만
--		local nameB, iconB, countB, _, durationB, expirationTimeB, _, _, _, spellIdB, _, isBossAuraB = UnitBuff(self.displayedUnit, i)

--		if isBossAuraB and IRF3.db.units.useBossAura and not ignoreAuraId[spellIdB] and not ignoreAuraName[nameB] and not baIndex then--보스오라로 지정된 경우만 체크합니다. (cpu 사용량 문제)
--			if isBossAuraB and not bossAuraId[spellIdB] and not bossAuraName[nameB] and IRF3.db.userAura[spellIdB] ~= false and IRF3.db.userAura[nameB] ~= false then
--				IRF3.db.userAura[spellIdB] = true
--				bossAuraId[spellIdB] = true
--				IRF3:Message("새로운 중요 버프 \""..nameB.."\"|1을;를; 발견하여 중요 버프 목록에 추가합니다.")
--			end
--			if bossAuraId[spellIdB] or bossAuraName[nameB] then
--
--				-- 중요 오라 내용 임시 테이블에 저장
--				baIndex = i
--				baIsBuff = true
--				baIcon = iconB
--				baCount = countB
--				baDuration = durationB
--				baExpirationTime = expirationTimeB
--			end
--		end
--
--		if not name and not nameB then
		if not name  then

			break
		end
	end
	--특정보스 디버프일때 체력색상변경용(신드라고사 얼음무덤등-힐해봤자 무의미라)
	if v_specialdebuff == true then self.specialdebuff= true  else self.specialdebuff=false end

	if baIndex then
 
		-- 중요 오라 표시
-- 개별 크기로 변경
--		self.bossAura:SetSize(IRF3.db.units.bossAuraSize, IRF3.db.units.bossAuraSize)

		self.bossAura:SetSize(baIconSize or IRF3.db.units.bossAuraSize or 18,baIconSize or IRF3.db.units.bossAuraSize or 18) 

		self.bossAura:SetAlpha(baAlpha or 1)


		self.bossAura.icon:SetTexture(baIcon)
		self.bossAura.count:SetText(baCount and baCount > 1 and baCount or nil)
		self.bossAura:SetID(baIndex)
		if IRF3.db.units.bossAuraTimer and baDuration and (baDuration > 0) then
			self.bossAura.cooldown:SetCooldown(baExpirationTime - baDuration, baDuration)
			self.bossAura.cooldown:Show()
			self.bossAura.cooldown:SetSize(50, 50)
--print("1")
		else
			self.bossAura.cooldown:Hide()

		end

		self.bossAura:Show()


--glow 효과


if baUserGlow and type(baUserGlowColorR) == "number" and type(baUserGlowColorG) == "number" and type(baUserGlowColorB) == "number" then 


if    (glowinit[self.displayedUnit] or false)==false then --반짝임효과가 활성화안된상태에서만 표시. Glow_Stop에서 다시 true로 변경

--다수의 중요오라가 동시에 적용될 때, 색상이 정확하게 적용되지 않음

	if LCG then

	LCG.PixelGlow_Start(self,{baUserGlowColorR,baUserGlowColorG,baUserGlowColorB},8,0.2,nil,4,0,0,false)
	end
	glowinit[self.displayedUnit]=true --반복활성화되지않도록 false처리


end

--      lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key,frameLevel)
end
 
		if baDuration and baDuration > 0 and baExpirationTime then
			self.bossAura.endTime = baExpirationTime
			self.bossAura.startTime = baExpirationTime - baDuration
			self.bossAura.alertTimer = baAlertTimer
			if not self.bossAura.ticker then
				self.bossAura.ticker = C_Timer.NewTicker(0.1, function() bossAuraOnUpdate(self.bossAura, IRF3.db.units.bossAuraOpt) end)
			end
			bossAuraOnUpdate(self.bossAura, IRF3.db.units.bossAuraOpt)
		else
			if self.bossAura.ticker then
				self.bossAura.ticker:Cancel()
				self.bossAura.ticker = nil
			end
			self.bossAura.timerParent.text:SetText(nil)
		end
	else
 
		hideIcon(self.bossAura)
 --glow 효과 --ba index가 없어지면(디버프가끝나면) glow도 같이 종료

	if LCG   then LCG.PixelGlow_Stop(self) end
	glowinit[self.displayedUnit]=false
end 

	for i = self.numDebuffIcons + 1, 10 do
		hideIcon(self["debuffIcon"..i])

	end
	if dispelable then

		self.dispelType = dispelType
		if IRF3.db.units.dispelSound ~= "None" and (UnitInRange(self.displayedUnit) or self.displayedUnit=="player") then --거리내에 있거나 본인만
			if GetTime() > lastTime then
				lastTime = GetTime() + (IRF3.db.units.dispelSoundDelay or 0)
				PlaySoundFile(SM:Fetch("sound", IRF3.db.units.dispelSound))
			end
		end
	else
		self.dispelType = nil
	end
end


function InvenRaidFrames3Member_BossAuraOnLoad(self)

	self.cooldown.noOCC = true
	self.cooldown.noCooldownCount = true
	self.cooldown:SetHideCountdownNumbers(true)
end

function InvenRaidFrames3Member_debuffIconOnLoad(self)

	self.cooldown.noOCC = false
	self.cooldown.noCooldownCount = true
	self.cooldown:SetHideCountdownNumbers(true)
end

local tooltipUpdate = 0
function InvenRaidFrames3Member_AuraIconOnUpdate(self, elapsed)

	if not InvenRaidFrames3.tootipState then  return end
	tooltipUpdate = tooltipUpdate + elapsed
	if tooltipUpdate > 0.2 then

		tooltipUpdate = 0
		if self:IsMouseOver() then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
			GameTooltip:SetUnitDebuff(self:GetParent().displayedUnit, self:GetID())
		 
		elseif GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
end
