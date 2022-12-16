local _G = _G
local IRF3 = _G[...]
local L = LibStub("AceLocale-3.0"):GetLocale("IRF3")
local IRF3_RaidCheck = CreateFrame("Frame")
local dataTable = {};  		-- 플레이어 데이터
local IRF3_Raidcheck_Save = {};	-- 저장데이터

local IRF3_Raidcheck_Food = {
	--리분 요리
	57399,--생선 통구이
	57294,--연회용 통구이
	57291, --코뿔소 핫도그
	57371,--용지느러이 살코기 요리
	57325, -- 커다란 매머드 구이
	57327,--연어 숯불구이
	57294,--달라란 조개 수프
	57332,--황제 쥐가오리 스테이크
	57367,--용지느러미 장작구이
	57327,--부드러운 뽀족엄니 스테이크
	57334,--매콤한 청어 튀김
	57360,--퉁돔 순살구이/검은늑대 육회
	44791,--귀족의 정원 초콜릿
	57358,--영양가 높은 코뿔소 고기
	57356,--코뿔소진미 벌레 스테이크
	57107,--절인 송곳니 청어 
	57288,--검은늑대 숯불 구이
	57100,--삶은 해파리	

	--불성 요리
	33257, --낚시꾼의 별미 
	35272, --탈부크 스테이크,모크나탈 갈비
	45245, --축제음료(따뜻한 사과맛 탄산수)
	33254, --독수리 꼬치,조개맛살,지옥꼬리퉁돔 별미
	33268, --황금어묵
	33263, --바실리스크 장작구이,바삭바삭 천둥매 튀김, 삶은 게르치
	33260, --칼날발톱 핫도그
	33261, --미꾸라지 구이,차원의 버거
	33256, --갈래발굽 숯불구이
	43764, --매콤한 양념 탈부크 구이
	43722, --해골물고기 수프
	33265, --포자물고기 장작구이
	45619, --피지느러미 구이
	43733, --번개구이
	
	225606, -- 375 화염 후추
	225603, -- 375 가속
	225602, -- 375 치명타
	225604, -- 375 특화
	225605, -- 375 유연성
	225601, -- Drogbar-Style Salmon (300)
	225598, -- Legion Haste (300)
	225597, -- Legion Crit (300)
	225599, -- Legion Mastery (300)
	225600, -- Legion Versatility (300)
	225613, -- Legion Crit (300) OPTIONAL WOWHEAD FOUND
	225614, -- Legion Haste (300) OPTIONAL WOWHEAD FOUND
	225615, -- Legion Mastery (300) OPTIONAL WOWHEAD FOUND
	225616, -- Legion Versatility (300) OPTIONAL WOWHEAD FOUND
	201332, -- Mastery 225
	201334, -- Versa 225
	201330, -- Haste 225
	201223, -- Crit 225
	201336, -- Spiced Rip Roast  (225)
	201637, -- 훈훈한 잔칫상
	201636, -- 훈훈한 잔칫상
	201635, -- 훈훈한 잔칫상
	201634, -- 훈훈한 잔칫상
	201641, -- 수라마르 잔칫상
	201640, -- 수라마르 잔칫상
	201639, -- 수라마르 잔칫상
	201638, -- 수라마르 잔칫상
};

local IRF3_Raidcheck_Flask = {
--리분 
53755,--서리고룡의 영약
53760,--끝없는 분노의 영약
67016,--극지의 영약
53758,--완전한 피의 영약
54212,--순수한 모조의 영약
53752,--하급 강인함의 영약
62380,--하급 저항의 영약
60346,--광속의비약
33721,--주문 강화의 비약
60345,--방어구 관통의 비약
28497,--강력한 민첩의 비약
60340,--적중의 비약
53751,--강력한 인내의 비약
53746,--격노의 비약
60344,--숙련 향상의 비약
60347,--강력한 사고의 비약
53749,--숙달의 비약
53748,--강력한 힘의 비약
53763,--보호의 비약
60343,--강력한 방어의 비약
53747,--정신력의 비약
53764,--강력한 마법사의 피 비약
60341,--치명적인 일격의 비약


--불성 영약
28518, -- 증강의 영약
28540, -- 순수한 죽음의 영약
28520, -- 가혹한 공격의 영약
28521, -- 눈부신 빛의 영약
28519, -- 강력한 마나 회복의 영약
42735, -- 오색 신비의 영약
41609, -- 증강의 샤트라스 영약
46837, -- 순수한 죽음의 샤트라스 영약
41608, -- 가혹한 공격의 샤트라스 영약
46839, -- 눈부신 빛의 샤트라스 영약
41610, -- 강력한 마나회복의 샤트라스 영약
41611, -- 강력한 마력의 샤트라스 영약
28503, -- 최상급 암흑 강화의 비약
38954, -- 타락한 힘의 비약
28497, -- 최상급 민첩의 비약
28501, -- 최상급 화염 강화의 비약
28493, -- 최상급 냉기 강화의 비약
28491, -- 치유력 강화의 비약
33726, -- 정통의 비약
28490, -- 최상급 힘의 비약
33721, -- 숙련의 비약
33720, -- 맹공의 비약
--클래식 비약/영약
11406, -- 악마사냥 전문화의 비약
24383, -- 잔자의 신속
24382, -- 잔자의 기백
17627, -- 순수한 지혜의 영약
17628, -- 강력한 마력의 영약
};

local IRF3_Raidcheck_Runes = {
	224001, -- 증강의 룬
};

local function getMemberCount()
	if(IsInRaid()) then
		return GetNumGroupMembers();
	elseif(IsInGroup())then
		return GetNumGroupMembers()-1;
	else
		return 0;
	end
end

local function getMemberName(index)
	local pName = "";
	if(IsInRaid()) then
		pName = GetUnitName("raid"..index, true);

	elseif(IsInGroup() and index > 0) then
		pName = GetUnitName("party"..index, true);

	elseif(index == 0) then
		pName = GetUnitName("player", true);

	end
	return pName;
end

local function getMemberIndex(index)
	local pName = "";
	if(IsInRaid()) then
		pName = "raid"..index

	elseif(IsInGroup() and index > 0) then
		pName = "party"..index

	elseif(index == 0) then
		pName = "player"

	end
	return pName;
end

local function getPlayerBuffs(index)
	local buffs = {};
	local duration = {};
	local buffName = {};
	local buffValue = {};
	local pclass = nil;

	local unitBuffTarget = "player";

	if(index > 0) then unitBuffTarget = getMemberIndex(index); end


	for i=1,40 do

		local spell, _, _, _, _,dur,_, _, _,spellId = UnitBuff(unitBuffTarget,i);


		if spell then
			buffs[i] 	= spellId;

			if(dur == 0) then
				duration[i] = math.floor(-1337);
			else
				duration[i] = math.floor((dur-GetTime())/60);
			end

--리분 요리
			if(buffs[i]==57399) then v2 = 375; end --생선 통구이
			if(buffs[i]==57294) then v2 = 375; end --연회용 통구이
			if(buffs[i]==57291) then v2 = 375; end  --코뿔소 핫도그
			if(buffs[i]==57371) then v2 = 375; end --용지느러이 살코기 요리
			if(buffs[i]==57325) then v2 = 375; end  -- 커다란 매머드 구이
			if(buffs[i]==57327) then v2 = 375; end --연어 숯불구이
			if(buffs[i]==57294) then v2 = 375; end --달라란 조개 수프
			if(buffs[i]==57332) then v2 = 375; end --황제 쥐가오리 스테이크
			if(buffs[i]==57367) then v2 = 375; end --용지느러미 장작구이
			if(buffs[i]==57327) then v2 = 375; end --부드러운 뽀족엄니 스테이크
			if(buffs[i]==57334) then v2 = 375; end --매콤한 청어 튀김
			if(buffs[i]==57360) then v2 = 375; end --퉁돔 순살구이/검은늑대 육회
			if(buffs[i]==57358) then v2 = 375; end --영양가 높은 코뿔소 고기
			if(buffs[i]==57356) then v2 = 375; end --코뿔소진미 벌레 스테이크
			if(buffs[i]==57107) then v2 = 375; end --절인 송곳니 청어
			if(buffs[i]==57288) then v2 = 375; end --검은늑대 숯불 구이
			if(buffs[i]==57100) then v2 = 375; end --삶은 해파리
--불성 요리
			if(buffs[i]==33257) then v2 = 300; end --낚시꾼의 별미 
			if(buffs[i]==35272) then v2 = 300; end  --탈부크 스테이크,모크나탈 갈비
			if(buffs[i]==45245) then v2 = 300; end  --축제음료(따뜻한 사과맛 탄산수)
			if(buffs[i]==33254) then v2 = 300; end  --독수리 꼬치,조개맛살,지옥꼬리퉁돔 별미
			if(buffs[i]==33268) then v2 = 300; end  --황금어묵
			if(buffs[i]==33263) then v2 = 300; end  --바실리스크 장작구이,바삭바삭 천둥매 튀김, 삶은 게르치
			if(buffs[i]==33260) then v2 = 300; end  --칼날발톱 핫도그
			if(buffs[i]==33261) then v2 = 300; end  --미꾸라지 구이,차원의 버거
			if(buffs[i]==33256) then v2 = 300; end  --갈래발굽 숯불구이
			if(buffs[i]==43764) then v2 = 300; end  --매콤한 양념 탈부크 구이
			if(buffs[i]==43722) then v2 = 300; end  --해골물고기 수프
			if(buffs[i]==33265) then v2 = 300; end  --포자물고기 장작구이
			if(buffs[i]==45619) then v2 = 300; end  --피지느러미 구이
			if(buffs[i]==43733) then v2 = 300; end  --번개구이

			if(buffs[i] == 201336) then v2 = 225; end

			if(buffs[i] == 225601) then v2 = 300; end
			if(buffs[i] == 225606) then v2 = 375; end
			if(buffs[i] == 201641) then v2 = 375; end
			if(buffs[i] == 201640) then v2 = 375; end
			if(buffs[i] == 201639) then v2 = 375; end
			if(buffs[i] == 201638) then v2 = 375; end
			if(buffs[i] == 201637) then v2 = 300; end
			if(buffs[i] == 201636) then v2 = 300; end
			if(buffs[i] == 201635) then v2 = 300; end
			if(buffs[i] == 201634) then v2 = 300; end
--리분 비약/영약

			if(buffs[i] == 53755) then v2 = 375; end--서리고룡의 영약
			if(buffs[i] == 53760) then v2 = 375; end--끝없는 분노의 영약
			if(buffs[i] == 67016) then v2 = 375; end--극지의 영약
			if(buffs[i] == 53758) then v2 = 375; end--완전한 피의 영약
			if(buffs[i] == 54212) then v2 = 375; end--순수한 모조의 영약
			if(buffs[i] == 53752) then v2 = 375; end--하급 강인함의 영약
			if(buffs[i] == 62380) then v2 = 375; end--하급 저항의 영약
			if(buffs[i] == 60346) then v2 = 375; end--광속의비약
			if(buffs[i] == 33721) then v2 = 375; end--주문 강화의 비약
			if(buffs[i] == 60345) then v2 = 375; end--방어구 관통의 비약
			if(buffs[i] == 28497) then v2 = 375; end--강력한 민첩의 비약
			if(buffs[i] == 60340) then v2 = 375; end--적중의 비약
			if(buffs[i] == 53751) then v2 = 375; end--강력한 인내의 비약
			if(buffs[i] == 53746) then v2 = 375; end--격노의 비약
			if(buffs[i] == 60344) then v2 = 375; end--숙련 향상의 비약
			if(buffs[i] == 60347) then v2 = 375; end--강력한 사고의 비약
			if(buffs[i] == 53749) then v2 = 375; end--숙달의 비약
			if(buffs[i] == 53748) then v2 = 375; end--강력한 힘의 비약
			if(buffs[i] == 53763) then v2 = 375; end--보호의 비약
			if(buffs[i] == 60343) then v2 = 375; end--강력한 방어의 비약
			if(buffs[i] == 53747) then v2 = 375; end--정신력의 비약
			if(buffs[i] == 53764) then v2 = 375; end--강력한 마법사의 피 비약
			if(buffs[i] == 60341) then v2 = 375; end--치명적인 일격의 비약


--불성 비약/영약
			if(buffs[i] == 28518) then v2 = 300; end -- 증강의 영약
			if(buffs[i] == 28540) then v2 = 300; end-- 순수한 죽음의 영약
			if(buffs[i] == 28520) then v2 = 300; end -- 가혹한 공격의 영약
			if(buffs[i] == 28521) then v2 = 300; end -- 눈부신 빛의 영약
			if(buffs[i] == 28519) then v2 = 300; end -- 강력한 마나 회복의 영약
			if(buffs[i] == 42735) then v2 = 300; end -- 오색 신비의 영약
			if(buffs[i] == 41609) then v2 = 300; end -- 증강의 샤트라스 영약
			if(buffs[i] == 46837) then v2 = 300; end -- 순수한 죽음의 샤트라스 영약
			if(buffs[i] == 41608) then v2 = 300; end -- 가혹한 공격의 샤트라스 영약
			if(buffs[i] == 46839) then v2 = 300; end -- 눈부신 빛의 샤트라스 영약
			if(buffs[i] == 41610) then v2 = 300; end -- 강력한 마나회복의 샤트라스 영약
			if(buffs[i] == 41611) then v2 = 300; end -- 강력한 마력의 샤트라스 영약
			if(buffs[i] == 28503) then v2 = 300; end -- 최상급 암흑 강화의 비약
			if(buffs[i] == 38954) then v2 = 300; end -- 타락한 힘의 비약
			if(buffs[i] == 28497) then v2 = 300; end -- 최상급 민첩의 비약
			if(buffs[i] == 28501) then v2 = 300; end -- 최상급 화염 강화의 비약
			if(buffs[i] == 28493) then v2 = 300; end -- 최상급 냉기 강화의 비약
			if(buffs[i] == 28491) then v2 = 300; end -- 치유력 강화의 비약
			if(buffs[i] == 33726) then v2 = 300; end -- 정통의 비약
			if(buffs[i] == 28490) then v2 = 300; end -- 최상급 힘의 비약
			if(buffs[i] == 33721) then v2 = 300; end -- 숙련의 비약
			if(buffs[i] == 33720) then v2 = 300; end -- 맹공의 비약
--클래식 비약/영약
			if(buffs[i] == 11406) then v2 = 300; end -- 악마사냥 전문화의 비약
			if(buffs[i] == 24383) then v2 = 300; end -- 잔자의 신속
			if(buffs[i] == 24382) then v2 = 300; end -- 잔자의 기백
			if(buffs[i] == 17627) then v2 = 300; end -- 순수한 지혜의 영약
			if(buffs[i] == 17628) then v2 = 300; end -- 강력한 마력의 영약
 
			if(buffs[i] == 25431) then v2 = 300; end--test
			if(buffs[i] == 10938) then v2 = 300; end --test




			if(v2) then
				buffValue[i] = v2;
			else
				buffValue[i] = 0;
			end

		end
	end

	return {buffs, duration, buffValue};
end

local function playerHasBuff(mode, index)
	local checkArr = {};
	local Flags;

	if(mode == "flask") then
		checkArr = IRF3_Raidcheck_Flask;
--		Flags = IRF3.db.units.flaskFlags;
		Flags = IRF3.db.units.foodFlags; --요리와 음식 기준을 동일하게 사용한다.

	end

	if(mode == "rune") then
		checkArr = IRF3_Raidcheck_Runes;
		Flags = IRF3.db.units.runeFlags;

	end

	if(mode == "food") then

		checkArr = IRF3_Raidcheck_Food;
		Flags = IRF3.db.units.foodFlags;

	end

	local data 		= getPlayerBuffs(index);

	local buffs 		= data[1];
	local duration 	= data[2];
	local value 		= data[3];
	local val;


	for id, spellID in pairs(checkArr) do


		for i=1,40 do

			if(buffs[i] and spellID and Flags) then

				if(value[i]) then val = value[i]; else val = 2; end



	
				if(buffs[i] == spellID and val >= Flags) then

					if(duration[i] == -1337) then
						return 3;
					elseif(duration[i] < 10) then
						return 2;
					else
						return 1;
					end
				end
			end
		end
	end

	return 0;
end

local function getPlayerClass(index)
	local unitBuffTarget = "player";
	if(index > 0) then unitBuffTarget = getMemberIndex(index); end
	local _,_,pclass = UnitClass(unitBuffTarget);

	return pclass;
end

local function loadData()
	dataTable = {};
	local x= 0;

	if(getMemberCount() == 0 or (IsInGroup() and IsInRaid() == false)) then
		dataTable[1] = {getMemberName(0), playerHasBuff("flask", 0), playerHasBuff("food", 0), getPlayerClass(0),playerHasBuff("rune", 0)};

		x = 1;
	end

	for i = 1, getMemberCount() do
		local name		= getMemberName(i);
		local hasFlask 	= playerHasBuff("flask", i);
		local hasFood 	= playerHasBuff("food", i);
		local hasRune 	= playerHasBuff("rune", i);
		dataTable[i+x] = {name, hasFlask, hasFood, getPlayerClass(i), hasRune};

	end
end

local function getNoRelamName(name)

	local ix = string.find(name, "-");
		if(ix) then return string.sub(name, 0, ix-1); else return name; end
end

local function announce()
	loadData();

	local nofood 	= "";
	local noflask = "";
	local norune  = "";

	local expfood 	= "";
	local expflask 	= "";
	local exprune 	= "";

	local issuesFood 	= true;
	local issuesFlask 	= true;
	local issuesRune 	= true;

	local FoodTreshold  = IRF3.db.units.foodFlags
	local FlaskTreshold = IRF3.db.units.flaskFlags

	local extensionFlask 	= "";
	local extensionFood 	= "";
	local extensionRune 	= "";

	local channel = "";
	local printnames = "";

	extensionFlask 	= " (+"..FlaskTreshold..")";
	extensionFood 	= " (+"..FoodTreshold..")";

	for i = 1, 40 do
		if(dataTable[i]) then
			local name = dataTable[i][1];

			name = getNoRelamName(name);
			local _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);

			if(dataTable[i][2] == 0) then noflask 	= noflask..""..name..", "; end
			if(dataTable[i][2] == 2) then expflask 	= expflask..""..name.."(만료 경고)"..", "; end

			if(dataTable[i][3] == 0) then nofood 	= nofood..""..name..", "; end
			if(dataTable[i][3] == 2) then expfood 	= expfood..""..name.."(만료 경고)"..", "; end

			if(dataTable[i][5] == 0) then norune 	= norune..""..name..", "; end
			if(dataTable[i][5] == 2) then exprune 	= exprune..""..name.."(만료 경고)"..", "; end
		end
	end

	if(IsInRaid()) 		then channel = "RAID";
	elseif(IsInGroup()) then channel = "PARTY";
	else channel = "SAY"; end

	--Print if everything is good
	if(IRF3.db.units.annFood and string.len(nofood) == 0 and string.len(expfood) == 0) then
		issuesFood = false;
	end

	if(IRF3.db.units.annFlask and string.len(noflask) == 0 and string.len(expflask) == 0) then
		issuesFlask = false;
	end

	if(IRF3.db.units.annRune and string.len(norune) == 0 and string.len(exprune) == 0) then
		issuesRune = false;
	end

	if(IRF3.db.units.annRune == false) then issuesRune = false; end
	if(IRF3.db.units.annFlask == false) then issuesFlask = false; end
	if(IRF3.db.units.annFood == false) then issuesFood = false; end

	if(issuesFood == false and issuesRune == false and issuesFlask == false)then
		if IRF3.db.units.RaidCheckAnn then
			SendChatMessage(L["도핑 체크msg1"], channel, nil, nil);
			else IRF3:Message(L["도핑 체크msg1"])
		end
	end

	if(IRF3.db.units.annFood) then
		if (issuesFood == true or issuesRune == true or issuesFlask == true) then
			if IRF3.db.units.RaidCheckAnn then
				SendChatMessage(L["도핑 체크msg2"], channel, nil, nil);
				else IRF3:Message(L["도핑 체크msg2"])
			end
		end
	end
	--Print warnings
	if(IRF3.db.units.annFood) then
		if(string.len(nofood) > 1 or string.len(expfood) > 1) then
			--Cut ending comma
			printnames = nofood..expfood;
			printnames = string.sub(printnames, 0, -3);
			if IRF3.db.units.RaidCheckAnn then
				SendChatMessage(L["도핑 체크msg3"]..printnames, channel, nil, nil);
				else IRF3:Message(L["도핑 체크msg3"]..printnames)
			end
		end
	end

	if(IRF3.db.units.annFlask) then
		if(string.len(noflask) > 1 or string.len(expflask) > 1) then
			--Cut ending comma
			printnames = noflask..expflask;
			printnames = string.sub(printnames, 0, -3);
			if IRF3.db.units.RaidCheckAnn then
				SendChatMessage(L["도핑 체크msg4"]..printnames, channel, nil, nil);
				else IRF3:Message(L["도핑 체크msg4"]..printnames)
			end
		end
	end

	if(IRF3.db.units.annRune) then
		if(IRF3.db.units.showRunes) then
			if(string.len(norune) > 1) then
				--Cut ending comma
				printnames = norune..exprune;
				printnames = string.sub(printnames, 0, -3);
				if IRF3.db.units.RaidCheckAnn then
					SendChatMessage("증강의 룬 없음: "..printnames, channel, nil, nil);
					else IRF3:Message("증강의 룬 없음: "..printnames)
				end
			end
		end
	end
end

IRF3_RaidCheck:RegisterEvent("READY_CHECK");

-- 전투준비시 자동알림
function IRF3_RaidCheck:OnEvent(event, addon)
	if event == "READY_CHECK" then
		if IRF3.db.units.RaidCheck then
			loadData();
			announce();
		end
	end
end


IRF3_RaidCheck:SetScript("OnEvent", IRF3_RaidCheck.OnEvent);

function InvenRaidFrames3Member_UpdateRaidCheck(self)
end

