local _G = _G
local IRF3 = _G[...]
local UnitThreatSituation = _G.UnitThreatSituation
local GetNumGroupMembers = _G.GetNumGroupMembers
local GetNumSubgroupMembers = _G.GetNumSubgroupMembers
local PlaySoundFile = _G.PlaySoundFile
local SM = LibStub("LibSharedMedia-3.0")

local aggroUnits = {}

local function hasAggro(unit)
-- 	return (UnitThreatSituation(unit) or 0)  > 1
 	return (UnitThreatSituation(unit) or 0) 
 

end

function InvenRaidFrames3Member_UpdateThreat(self)
if UnitInBattleground(self.displayedUnit) then    return   end--전장에서는 과부하피하기 위해 pass

if self.displayedUnit then
--	self.hasAggro = hasAggro(self.displayedUnit) or aggroUnits[self]
--	self.hasAggroValue= UnitThreatSituation(self.displayedUnit) or 0

--UnitThreatSituaion 두번호출을 피하기 위해 hasAggro함수를 변경. ThreatSituaion값을 그대로 받아오고 이를 기준으로 hasAggro를 판정.	
	self.hasAggroValue = hasAggro(self.displayedUnit)
	if self.hasAggroValue > 1 then
		self.hasAggro = true
	else
		self.hasAggro = false
	end 

end

--부하감소를 위해 A 경보소리로직만 이쪽으로 이동. 동시에 함수호출을 제거(시작)
--aggro.timer, aggro.check1 = 0, false 
	if self.displayedUnit == "player" and IRF3.db and IRF3.db.units.aggroType ~= 1 then
--		self.check2 = self.check1
--		self.check1 = self.hasAggro 

		if IRF3.db.units.aggroType == 2 then
			self.trigger = true
		elseif IRF3.db.units.aggroType == 3 then
			self.trigger = IsInGroup()
		elseif IRF3.db.units.aggroType == 4 then
			self.trigger = IsInRaid()
		else
			self.trigger = nil
		end
		if self.trigger and self.hasAggro  ~= self.check1 then

			if self.hasAggro  then
				if IRF3.db.units.aggroGain ~= "None" then


					PlaySoundFile(SM:Fetch("sound", IRF3.db.units.aggroGain))
				end
			elseif   IRF3.db.units.aggroLost ~= "None" then

				PlaySoundFile(SM:Fetch("sound", IRF3.db.units.aggroLost))
			end
		end
		self.check1 = self.hasAggro 
	end
--부하감소를 위해 Aggro.lua에 있던 경보소리로직만 이쪽으로 이동. 동시에 함수호출을 제거(끝)




end
 	
  

 

 