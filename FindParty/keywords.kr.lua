-------------------------------------------
-- 최종수정 : 2022/10/09

-- 각종 필터링 정보를 담고 있는 파일입니다.
-- 패치로 새로운 던전이 추가되거나 난이도가 추가될 경우 이 파일에서 수정하시면 됩니다.
-- 난이도 추가시에는 FindParty.lua 파일에서 별도 처리가 필요할 수도 있습니다.

-- ===============================
-- 난이도 분류 키워드를 정의합니다.
-- dbname은 실제로 애드온에서 인식하는 명칭이며, name은 애드온에서 표시되는 부분입니다.
-- postfix를 입력할 경우 던전 이름 뒤에 입력한 글자가 추가로 표시됩니다.
-- color은 선택한 난이도를 어떤 색상으로 표시할지 정의하는 부분입니다.
-- keywords는 파티모집 문구에 해당 문자열이 있을 경우 해당 난이도로 분류할 수 있도록 정의하는 부분입니다.
-- 10인, 25인, 영웅 난이도는 별도로 처리 합니다.

--[[
	여분의 색상 rgb 코드
	보라 (법사세린 버전 신화 던전) 0.7, 0, 0.7
	분홍 (법사세린 버전 25인 영웅) 1, 0.7, 0.7
	청록 (법사세린 버전 10인 일반) 0, 1, 0.7
	빨강 (일분일초 버전 명예) 1, 0. 0
	파랑 (법사세린 버전 공찾) 0.2, 0.6, 0.8
	하늘색 (법사세린 버전 도전) 0, 1, 1
]]

FP_DIFFICULTY_KEYWORDS = {
	[1] = {
		name = "영웅",
		dbname = "heroic",
		postfix = " |cffff0000(H)",
		color = {0.5, 0.5, 0.8},
		keywords = {"영웅", "영던", "0던", "%(0%)", "%(영%)"},
	},
	[2] = {
		name = "일반",
		dbname = "normal",
		postfix = "",
		color = {0.5, 0.5, 0.8},
		keywords = {"일반", "일던", "%(1%)", "%(일%)"},
	},
	[3] = {
		name = "10인",
		dbname = "10normal",
		postfix = " |cff00e1ff(10)",
		color = {1, 0.7, 0.7},
		keywords = {"10"},
	},
	[4] = {
		name = "25인",
		dbname = "25normal",
		postfix = " |cff00e1ff(25)",
		color = {1, 0.5, 0},
		keywords = {"25", "20"},
	},
	[5] = {
		name = "10인 하드",
		dbname = "10heroic",
		postfix = " |cffff0000(10H)",
		color = {1, 0.7, 0.7},
		keywords = {},
	},
	[6] = {
		name = "25인 하드",
		dbname = "25heroic",
		postfix = " |cffff0000(25H)",
		color = {1, 0.5, 0},
		keywords = {},
	},
	[7] = {
		name = "구 레이드",
		dbname = "legacy",
		postfix = "",
		color = {1, 0.7, 0},
		keywords = {},
	},
	[8] = {
		name = "PvP",
		dbname = "pvp",
		postfix = "",
		color = {0, 1, 0},
		keywords = {},
	},
	[9] = {
		name = "퀘스트",
		dbname = "quest",
		postfix = "",
		color = {1, 1, 1},
		keywords = {},
	},
}

-- ==============================
-- 던전 분류 키워드를 정의합니다.
-- 아래 모든 필드가 있어야합니다.
-- category는 새로운 분류를 추가할 때 이용하시면 됩니다.
-- name은 던전 이름을 입력하며, 낮은 번호가 우선으로 인식됩니다. 번호가 중복되지 않도록 하여주시기 바랍니다.
-- difficulty는 해당 던전에 존재하는 난이도를 정의하는 부분입니다. 난이도 정의의 dbname에 맞게 입력하셔야 합니다.
-- keywords는 파티모집 문구에 해당 문자열이 있을 경우 해당 난이도로 분류할 수 있도록 정의하는 부분입니다.
-- heroickeywods는 던전 분류후 해당 문자열이 발견될 경우 영웅 난이도로 분류하도록 별도로 정의하는 부분입니다.
-- 시네스트라나 비룡팟등 기본 하드 진행인데, 하드로 분류되지 않는 경우를 대비하여 만들어 졌습니다. 하드 난이도에만 존재하는 네임드의 경우, 이 곳에 키워드를 적을 수 있습니다.
-- 단, 이 경우 던전 분류시 인식하지 않으므로 던전 분류에서 해당 키워드를 기재하여 우선 던전을 인식시키는 작업이 필요합니다. (울두아르를 참고하시기 바랍니다.)
-- excludekeywords는 던전으로 인식되지 않을 키워드를 정의합니다. 다른 던전과 키워드가 겹칠때 사용합니다.

FP_DUNGEON_KEYWORDS = {
	[1] = {
		category = "리치 왕의 분노 공격대",
		dungeon = {
			[1] = {
				name = "얼음왕관 성채",
				difficulty = {"10normal", "25normal", "10heroic", "25heroic"},
				keywords = {"얼음왕관", "얼왕", "얼성"},
				excludekeywords = {"투기장", "퀘"},
			},
			[2] = {
				name = "루비 성소",
				difficulty = {"10normal", "25normal", "10heroic", "25heroic"},
				keywords = {"루비", "성소", "할리", "할리온"},
				excludekeywords = {"흑요"},
			},
			[3] = {
				name = "아카본 석실",
				difficulty = {"10normal", "25normal"},
				keywords = {"아카본", "석실"},
			},
			[4] = {
				name = "십자군의 시험장",
				difficulty = {"10normal", "25normal", "10heroic", "25heroic"},
				keywords = {"십자군", "아눕", "시험장", "십자"},
				excludekeywords = {"붉은", "도서관", "수도원", "진홍", "무기고", "성당", "예배당", "1번", "2번", "3번", "4번"},
			},
			[5] = {
				name = "오닉시아의 둥지",
				difficulty = {"10normal", "25normal"},
				keywords = {"오닉"},
			},
			[6] = {
				name = "울두아르",
				difficulty = {"10normal", "25normal", "10heroic", "25heroic"},
				keywords = {"울두", "울드", "알갈", "요그", "미미"},
				heroickeywords = {"비룡", "미미"},
			},
			[7] = {
				name = "흑요석 성소",
				difficulty = {"10normal", "25normal", "10heroic", "25heroic"},
				keywords = {"흑요", "살타"},
				heroickeywords = {"1비룡", "2비룡", "3비룡", "1비", "2비", "3비", "1용", "2용", "3용"},
			},
			[8] = {
				name = "영원의 눈",
				difficulty = {"10normal", "25normal"},
				keywords = {"영눈", "영원", "말리"},
			},
			[9] = {
				name = "낙스라마스",
				difficulty = {"10normal", "25normal"},
				keywords = {"낙스", "켈투"},
			},
		},
	},
	[2] = {
		category = "리치 왕의 분노 던전",
		dungeon = {
			[1] = {
				name = "무작위 5인 던전",
				difficulty = {"heroic", "normal"},
				keywords = {"랜덤", "랜영", "무작던전", "무작영던", "무작영웅", "무작스핀", "12스핀"},
				heroickeywords = {"랜영", "무작영던", "무작영웅", "영던스핀", "12영던"},
			},
			[2] = {
				name = "영혼의 제련소",
				difficulty = {"heroic", "normal"},
				keywords = {"제련", "제련소", "영제"},
			},
			[3] = {
				name = "사론의 구덩이",
				difficulty = {"heroic", "normal"},
				keywords = {"사론", "샤론"},
			},
			[4] = {
				name = "투영의 전당",
				difficulty = {"heroic", "normal"},
				keywords = {"투영"},
			},
			[5] = {
				name = "용사의 시험장",
				difficulty = {"heroic", "normal"},
				keywords = {"용사", "마상", "시험장"},
				excludekeywords = {"천둥왕", "부른다"},
			},
			[6] = {
				name = "군드락",
				difficulty = {"heroic", "normal"},
				keywords = {"군드"},
			},
			[7] = {
				name = "돌의 전당",
				difficulty = {"heroic", "normal"},
				keywords = {"돌전", "돌의"},
			},
			[8] = {
				name = "드락타론 성채",
				difficulty = {"heroic", "normal"},
				keywords = {"드락타론", "드락"},
				excludekeywords = {"줄드락"},
			},
			[9] = {
				name = "마력의 눈",
				difficulty = {"heroic", "normal"},
				keywords = {"마눈", "마력의 눈", "마력의눈", "마력눈"},
			},
			[10] = {
				name = "마력의 탑",
				difficulty = {"heroic", "normal"},
				keywords = {"마탑", "마력의 탑", "마력의탑", "마력탑"},
			},
			[11] = {
				name = "번개의 전당",
				difficulty = {"heroic", "normal"},
				keywords = {"번개", "번전", "번던"},
			},
			[12] = {
				name = "보랏빛 요새",
				difficulty = {"heroic", "normal"},
				keywords = {"그런건없다", "요새", "보요"},
				excludekeywords = {"정복"},
			},
			[13] = {
				name = "아졸네룹",
				difficulty = {"heroic", "normal"},
				keywords = {"아졸", "아줄"},
			},
			[14] = {
				name = "안카헤트: 고대 왕국",
				difficulty = {"heroic", "normal"},
				keywords = {"안카"},
			},
			[15] = {
				name = "옛 스트라솔름",
				difficulty = {"heroic", "normal"},
				keywords = {"옛", "솔름 영웅", "옛솔름", "옛솔룸"},
				excludekeywords = {"힐스"},
			},
			[16] = {
				name = "우트가드 성채",
				difficulty = {"heroic", "normal"},
				keywords = {"우트가드 성채", "우트가드성채", "성채", "우트성채", "우투성채"},
				excludekeywords = {"얼음왕관", "얼왕", "드락타론", "드락", "그림자", "그송"},
			},
			[17] = {
				name = "우트가드 첨탑",
				difficulty = {"heroic", "normal"},
				keywords = {"우트가드 첨탑", "우트가드첨탑", "첨탑", "우트첨탑", "우투첨탑"},
				excludekeywords = {"검은바위", "하층", "상층"},
			},
		},
	},
	[3] = {
		category = "불타는 성전 공격대",
		dungeon = {
			[1] = {
				name = "태양샘 고원",
				difficulty = {"legacy"},
				keywords = {"태양샘", "태샘"},
			},
			[2] = {
				name = "검은 사원",
				difficulty = {"legacy"},
				keywords = {"검사"},
				excludekeywords = {"안퀴"},
			},
			[3] = {
				name = "하이잘 정상",
				difficulty = {"legacy"},
				keywords = {"하이잘"},
			},
			[4] = {
				name = "폭풍우 요새",
				difficulty = {"legacy"},
				keywords = {"폭요", "폭풍우"},
				excludekeywords = {"퀘"},
			},
			[5] = {
				name = "불뱀 제단",
				difficulty = {"legacy"},
				keywords = {"불뱀", "제단"},
				excludekeywords = {"퀘"},
			},
			[6] = {
				name = "그룰의 둥지",
				difficulty = {"legacy"},
				keywords = {"그룰", "그롤"},
				excludekeywords = {"대학살", "그룰록"},
			},
			[7] = {
				name = "마그테리돈의 둥지",
				difficulty = {"legacy"},
				keywords = {"마그"},
				excludekeywords = {"마그고크", "마그나타"},
			},
			[8] = {
				name = "줄아만",
				difficulty = {"legacy"},
				keywords = {"줄아만"},
			},
			[9] = {
				name = "카라잔",
				difficulty = {"legacy"},
				keywords = {"카라잔", "정문", "후문"},
				excludekeywords = {"솔름", "솔룸", "솔롬", "솔륨", "스솔", "퀘"},
			},
			[10] = {
				name = "필드보스 (불성)",
				difficulty = {"legacy"},
				keywords = {"카자크", "카작", "절단기"},
				excludekeywords = {"폭요", "폭풍우", "지옥절단기"},
			},
		},
	},
	[4] = {
		category = "불타는 성전 던전",
		dungeon = {
			[1] = {
				name = "마법학자의 정원",
				difficulty = {"heroic", "normal"},
				keywords = {"마법학자", "마정"},
				excludekeywords = {"신록", "켈도누스"},
			},
			[2] = {
				name = "메카나르",
				difficulty = {"heroic", "normal"},
				keywords = {"메카"},
			},
			[3] = {
				name = "알카트라즈",
				difficulty = {"heroic", "normal"},
				keywords = {"알카"},
			},
			[4] = {
				name = "신록의 정원",
				difficulty = {"heroic", "normal"},
				keywords = {"신록", "정원"},
				excludekeywords = {"마법학자"},
			},
			[5] = {
				name = "어둠의 미궁",
				difficulty = {"heroic", "normal"},
				keywords = {"미궁"},
			},
			[6] = {
				name = "세데크 전당",
				difficulty = {"heroic", "normal"},
				keywords = {"세데크", "세덱", "안주"},
			},
			[7] = {
				name = "아키나이 납골당",
				difficulty = {"heroic", "normal"},
				keywords = {"납골당", "납골"},
			},
			[8] = {
				name = "마나 무덤",
				difficulty = {"heroic", "normal"},
				keywords = {"마나", "무덤", "마나무덤"},
				excludekeywords = {"괴철로"},
			},
			[9] = {
				name = "증기 저장고",
				difficulty = {"heroic", "normal"},
				keywords = {"증기", "저장고", "저장소"},
			},
			[10] = {
				name = "지하 수렁",
				difficulty = {"heroic", "normal"},
				keywords = {"수렁"},
			},
			[11] = {
				name = "강제 노역소",
				difficulty = {"heroic", "normal"},
				keywords = {"노역소", "노역", "강노"},
			},
			[12] = {
				name = "으스러진 손의 전당",
				difficulty = {"heroic", "normal"},
				keywords = {"으스", "으손", "으스스"},
				excludekeywords = {"열쇠", "절단기"},
			},
			[13] = {
				name = "피의 용광로",
				difficulty = {"heroic", "normal"},
				keywords = {"피용", "용광로"},
			},
			[14] = {
				name = "지옥불 성루",
				difficulty = {"heroic", "normal"},
				keywords = {"지옥불", "성루"},
			},
			[15] = {
				name = "검은늪",
				difficulty = {"heroic", "normal"},
				keywords = {"검은늪", "검늪"},
			},
			[16] = {
				name = "옛 힐스브래드 구릉지",
				difficulty = {"heroic", "normal"},
				keywords = {"힐스", "옛힐스"},
			},
		},
	},
	[5] = {
		category = "클래식 공격대",
		dungeon = {
			[1] = {
				name = "안퀴라즈 사원",
				difficulty = {"legacy"},
				keywords = {"안퀴사원", "안퀴", "사원"},
				excludekeywords = {"폐허", "페허", "가라앉은", "검은"},
			},
			[2] = {
				name = "안퀴라즈 폐허",
				difficulty = {"legacy"},
				keywords = {"안퀴폐허", "폐허", "페허"},
			},
			[3] = {
				name = "줄구룹",
				difficulty = {"legacy"},
				keywords = {"줄구룹", "줄구릅", "줄구룸"},
			},
			[4] = {
				name = "검은날개 둥지",
				difficulty = {"legacy"},
				keywords = {"검둥"},
			},
			[5] = {
				name = "화산 심장부",
				difficulty = {"legacy"},
				keywords = {"화산", "화심"},
				excludekeywords = {"하실", "나락", "입장퀘"}, -- 입장퀘 필터링
			},
			[6] = {
				name = "필드보스 (클래식)",
				difficulty = {"legacy"},
				keywords = {"아주어고스", "4용", "녹용", "녹용팟", "레손", "이손드레", "에메리스", "타에라"},
			},
		},
	},
	[6] = {
		category = "클래식 던전",
		dungeon = {
			[1] = {
				name = "가시덩굴 구릉",
				difficulty = {"normal"},
				keywords = {"구릉", "구렁", "구룽"},
				excludekeywords = {"회색", "구릉지"},
			},
			[2] = {
				name = "가시덩굴 우리",
				difficulty = {"normal"},
				keywords = {"우리"},
				excludekeywords = {"마우리"},
			},
			[3] = {
				name = "검은심연의 나락",
				difficulty = {"normal"},
				keywords = {"심연", "검은심연", "검은심연의"},
				excludekeywords = {"바위", "심연의홀", "홀"},
			},
			[4] = {
				name = "검은바위 나락",
				difficulty = {"normal"},
				keywords = {"나락", "윈저"},
				excludekeywords = {"심연"},
			},
			[5] = {
				name = "검은바위 첨탑 하층",
				difficulty = {"normal"},
				keywords = {"하층"},
				excludekeywords = {"우트가드"},
			},
			[6] = {
				name = "검은바위 첨탑 상층",
				difficulty = {"normal"},
				keywords = {"상층", "드라키"},
				excludekeywords = {"우트가드"},
			},
			[7] = {
				name = "그림자송곳니 성채",
				difficulty = {"normal"},
				keywords = {"그송", "송곳니"},
				excludekeywords = {"우트", "드락", "얼음왕관"},
			},
			[8] = {
				name = "놈리건",
				difficulty = {"normal"},
				keywords = {"놈리"},
			},
			[9] = {
				name = "마라우돈",
				difficulty = {"normal"},
				keywords = {"마라우돈", "우동", "마라"},
			},
			[10] = {
				name = "붉은십자군 수도원",
				difficulty = {"normal"},
				keywords = {"수도원", "도서관", "무기고", "성당", "예배당", "1번", "2번", "3번", "4번"},
			},
			[11] = {
				name = "성난불길 협곡",
				difficulty = {"normal"},
				keywords = {"성난불길", "성불"},
			},
			[12] = {
				name = "스톰윈드 지하감옥",
				difficulty = {"normal"},
				keywords = {"감옥"},
			},
			[13] = {
				name = "스칼로맨스",
				difficulty = {"normal"},
				keywords = {"스칼", "교장"},
			},
			[14] = {
				name = "스트라솔름",
				difficulty = {"normal"},
				keywords = {"솔름", "솔룸", "솔륨", "솔롬", "스솔"},
				excludekeywords = {"옛", "영웅", "영던"},
			},
			[15] = {
				name = "아탈학카르 신전",
				difficulty = {"normal"},
				keywords = {"학카르", "학칼", "아탈", "가라앉은"},
			},
			[16] = {
				name = "울다만",
				difficulty = {"normal"},
				keywords = {"울다"},
			},
			[17] = {
				name = "죽음의 폐광",
				difficulty = {"normal"},
				keywords = {"폐광"},
			},
			[18] = {
				name = "줄파락",
				difficulty = {"normal"},
				keywords = {"줄파"},
			},
			[19] = {
				name = "통곡의 동굴",
				difficulty = {"normal"},
				keywords = {"통곡"},
			},
			[20] = {
				name = "혈투의 전장",
				difficulty = {"normal"},
				keywords = {"혈투", "혈장"},
			},
		},
	},
	[7] = {
		category = "PvP",
		dungeon = {
			[1] = {
				name = "투기장",
				difficulty = {"pvp"},
				keywords = {"투기장", "투기", "점먹", "8승", "10승", "2V2", "2VS2", "2대2", "3V3", "3VS3", "3대3","5V5", "5VS5", "5대5", "2:2", "3:3", "5:5"},
				excludekeywords = {"퀘", "쐐기", "길드", "투기장퀘", "나그란드", "나그", "줄드", "회색구릉지", "구릉", "퀘스트", "정복", "피의", "고뇌", "투기장:"},
			},
			[2] = {
				name = "전장",
				difficulty = {"pvp"},
				keywords = {"명점", "쟁", "전장", "아라시", "알방", "노래방", "토방", "룰방", "분지", "폭눈", "겨손", "겨울손아귀"},
				excludekeywords = {"퀘", "쐐기", "길드", "하실"},
			},
		},
	},
	[8] = {
		category = "퀘스트",
		dungeon = {
			[1] = {
				name = "퀘스트",
				difficulty = {"quest"},
				keywords = {"퀘", "하실", "입장퀘", "상급소환", "실리", "투기장", "나그", "나그란드"},
				excludekeywords = {"골팟", "올분", "참석", "길드", "하신", "명점", "쟁", "전장", "킬하실"},
			},
		},
	},
}

-- 하드 난이도를 위한 별도 처리 부분입니다. 던전 모집 문구에 해당 문자열이 포함되어 있을 경우 하드 난이도로 분류 합니다.
FP_HEROIC_KEYWORDS = {"영웅", "하드", "%d+H", "H%d+", "HARD", "HEROIC", "ALLH", "올H"}

-- 던전명 뒤에 아래 문제가 붙어 있을 경우 하드 난이도로 인식합니다. (순전히 용영H 등 같은것으로 인해 추가..)
FP_HEROIC_POSTFIX_KEYWORDS = {"H"}

-- 모든 무시 키워드는 각단계 별로 별도로 제거 됩니다.
-- 즉, 다른 단계에서 사용한 키워드가 있다면 해당 단계에서 제거하는 것이 좋습니다.
-- 던전명 인식시 해당 문자열을 제거한후 던전명을 인식합니다. 오인식이 자주되는 키워드 위주로 추가하면 좋습니다.
-- 이를테면 도적의 키워드가 "도" 이고, 난이도 인식시 사용하는 키워드가 "도전" 이면, 직업 필터링에 "도전"을 추가하면 
-- 도전 모드는 정상적으로 인식되며 "도전" 을 도적으로 오인식하는 경우가 줄어듭니다.
-- 영어 사용시 대문자로만 적으세요. (자동으로 대문자 변환함)
FP_DUNGEON_IGNORE_KEYWORDS = {
	"할줄아",--줄아만 오분류
	"얼마나",--마나 무덤 오분류
}

-- 던전 이름 뒤에 다음 문자열이 기록되어 있으면 무시합니다.
-- 운다손, 갈레온손 같은 경우를 제거하기 위함입니다.
FP_DUNGEON_IGNORE_POSTFIX_KEYWORDS = {
	"손",--운다 손
	"뜸",--운다 뜸
	"없",--운다 없나요?
	"ㅅ"--운다 ㅅㅅ
}

-- 난이도명 인식시 해당 문자열을 제거한후 난이도명을 인식합니다. 오인식이 자주되는 키워드 위주로 추가하면 좋습니다.
FP_DIFFICULTY_IGNORE_KEYWORDS = {
	--시간 관련 문자열들 제거
	"OR", "AND", "1탐", "2탐", "일시", "1시", "2시", "3시", "4시", "5시", "6시", "7시", "8시", "9시", "10시", "11시", "12시", "20시", "22시", "~1", "~10", ":33", "~33", "~20", "1~", "10~", "20~", "22:", "22~", ":55", "~55", "55분", "1:", "10:", "20:", ":0", ":1", "10월",
	--기타 오인식 문자열 제거
	"10/", "10렙", "10레벨", "250", "25일", "25렙", "25레벨", "1레벨", "1렙", "LV.25", "하드X", "10하드", "탄공이상",
}

-- 목록 툴팁에서 가독성에 영향을 주는 문자열을 사전 제거 합니다. 가능한 최소로 사용하세요.
FP_TOOLTIP_IGNORE_KEYWORDS = {
	-- 툴팁에는 이모티콘이 표시되지 않으므로 이모티콘 관련 문자들 제거
	"{해골}", "{별}", "{다이아몬드}", "{세모}", "{가위표}", "{동그라미}", "{달}", "{네모}", "{rt1}", "{rt2}", "{rt3}", "{rt4}", "{rt5}", "{rt6}", "{rt7}", "{rt8}"
}

-- 스팸 메시지 필터링 문자열
FP_GLOBAL_EXCLUDE_KEYWORDS = {
	"검사x",
	"길드에서",
	"길드원",
	"길드는",
	"길원",
	"친목",
	"함께",
	"렙업",
	"레벨업",
	"레벨링",
	"삽니다",
	"닌자",
	"먹튀",
}
