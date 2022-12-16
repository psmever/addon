--if GetLocale() ~= "koKR" then return end
-- 한국어 로컬 파일입니다. 애드온에서 직접 사용하는 문자열은 이 파일에서 정의합니다.

FP_C_TITLE = "파티 찾기 도우미 v"..GetAddOnMetadata("FindParty", "version")

FP_DEFAULT_PARTY_CHANNEL = "파티"
FP_DEFAULT_WHISPER = "%s %s 손이요~"

FP_TEXT_STOPPED = "(중단)"
FP_TEXT_EXCEPTION = "제외"
FP_TEXT_EXCEPTION_DELETE = "제외초기화"
FP_TEXT_WHISPER = "귓말창열기"
FP_TEXT_WHO = "파장누구지"
FP_TEXT_HELP = "도움말"
FP_TEXT_APPLY = "파티신청"
FP_TEXT_START_AD = "광고시작"
FP_TEXT_STOP_AD = "광고중단"
FP_TEXT_APPLY_FILTER = "필터적용"
FP_TEXT_IGNORE = "무시적용"
FP_TEXT_WH_LABEL = "귓속말 문구 : "
FP_TEXT_AD_LABEL = "광고글 문구 : "
FP_TEXT_FILTER_LABEL = "필터링 문구 : "
FP_TEXT_IGNORE_LABEL = "무시할 문구 : "
FP_TEXT_CLOSE = "닫기"
FP_TEXT_LIST_LABEL = "광고 문구"

FP_DUNGEONFILTER_RESETALL = "* 관심 던전 모두 삭제 *"
FP_DUNGEONFILTER_SINGLE = "던전: %s"
FP_DUNGEONFILTER_MULTI = "던전: %d개 선택"
FP_DUNGEONFILTER_NOT_FILTERED = "던전: 모두 보기"
FP_DUNGEONFILTER_NONE = "없음"

FP_TOOLTIP_CLOSE = "창 닫기"
FP_TOOLTIP_MAXMIZE = "창 최대화"
FP_TOOLTIP_MINIMIZE = "창 최소화"
FP_TOOLTIP_DECREASE = "줄 줄이기"
FP_TOOLTIP_INCREASE = "줄 늘리기"
FP_TOOLTIP_OPTION = "설정"
FP_TOOLTIP_SORT_TIME = "시간순으로 정렬"
FP_TOOLTIP_ACTIVATE_ON = "작동중\n클릭하면 비활성화"
FP_TOOLTIP_ACTIVATE_OFF = "비활성화됨\n클릭하면 다시 작동"
FP_TOOLTIP_POPUP_ON = "팝업 및 소리 작동중\n클릭하면 중단"
FP_TOOLTIP_POPUP_OFF = "팝업 및 소리 중단됨"
FP_TOOLTIP_DUNGEON_FILTER = "왼쪽 클릭 : 정렬/관심 던전 보기\n오른쪽 클릭 : 관심 던전 선택\n\n- 관심 던전 목록 -\n"
FP_TOOLTIP_CLASS_FILTER = "왼쪽 클릭 : 내 직업 골라냄\n오른쪽 클릭 : 관심 직업만 골라냄\n선택 : "
FP_TOOLTIP_SHORTCUT_ALT = "단축키 : Alt + 클릭"
FP_TOOLTIP_SHORTCUT_ALT_RIGHT = "단축키 : Alt + 우클릭"
FP_TOOLTIP_SHORTCUT_CTRL = "단축키 : Ctrl + 클릭"
FP_TOOLTIP_SHORTCUT_SHIFT = "단축키 : Shift + 클릭"
FP_TOOLTIP_IGNORE = "무시할 광고 문구를 ,로 구분해서 입력 후 엔터 또는 버튼 클릭"
FP_TOOLTIP_MINIMAP = {
	"파티 찾기 도우미 v"..GetAddOnMetadata("FindParty", "version"),
	"\n",
	"\n|cff00ff00왼쪽 클릭: |r파티 찾기 도우미 열기",
	"\n|cff00ff00오른쪽 클릭: |r설정",
	"\n|cff00ff00Alt + 클릭: |r아이콘 고정/해제";
	"\n|cff00ff00Shift + 왼쪽 클릭: |r애드온 작동/작동정지";
	"\n";
	"\n현재 상태:";
}
FP_TOOLTIP_MINIMAP_ON = " 작동중"
FP_TOOLTIP_MINIMAP_OFF = " 작동정지"
FP_TOOLTIP_MINIMAP_AD = " 광고중"
FP_TOOLTIP_MINIMAP_LOCK = " 아이콘고정"
FP_TOOLTIP_MINIMAP_NOLOCK = "\n아이콘 이동가능(왼쪽 드래그)"

FP_MESSAGE_NEWVERSION_RESET = "새로 설치 또는 구 버전에서 업그레이드 하셨습니다."
FP_MESSAGE_ACTIVE = "v%s - 파티 찾기 도우미를 활성화 합니다."
FP_MESSAGE_DEACTIVE = "v%s - 파티 찾기 도우미를 비활성화 합니다."
FP_MESSAGE_POPUP_ACTIVE = "파티 목록이 갱신될때 팝업 및 소리 알림을 표시합니다."
FP_MESSAGE_POPUP_DEACTIVE = "팝업 및 소리 알림 기능을 비활성화 합니다."
FP_MESSAGE_RESETALL = "설정 초기값을 불러옵니다."
FP_MESSAGE_DUNGEON_RESET = "관심 던전 목록을 모두 삭제하였습니다."
FP_MESSAGE_START_AD = "파티 광고를 시작합니다."
FP_MESSAGE_STOP_AD = "파티 광고를 중단합니다."
FP_MESSAGE_NO_AD_TEXT = "광고글을 입력하셔야 합니다."
FP_MESSAGE_EXCEPTION = "%s 님의 광고를 목록에서 제외합니다."
FP_MESSAGE_CLEAR_EXCEPTION = "제외 대상 목록을 초기화 하였습니다. 이제 모든 광고가 표시됩니다."
FP_MESSAGE_NOTARGET = "명령을 실행할 대상을 먼저 목록에서 선택하세요."
FP_MESSAGE_ICON_LOCK = "미니맵 아이콘을 이동할 수 없도록 고정합니다."
FP_MESSAGE_ICON_UNLOCK = "이제 미니맵 아이콘을 이동할 수 있습니다."
FP_MESSAGE_START_DUNGEON_FILTER = "관심 던전만 목록에 표시합니다."
FP_MESSAGE_STOP_DUNGEON_FILTER = "모든 던전을 목록에 표시합니다."
FP_MESSAGE_APPLY_CUSTOM_FILTER = "사용자 정의 필터링 문구를 적용합니다."
FP_MESSAGE_CUSTOM_IGNORE = "지정한 문구가 들어있는 광고를 표시하지 않습니다."
FP_MESSAGE_CUSTOM_IGNORE_RESET = "무시할 문구를 초기화 하였습니다. 이제 모든 광고가 표시됩니다."

FP_OPTIONS_CHANNEL = "파티찾기 채널 지정"
FP_OPTIONS_INTERVAL = "광고 주기"
FP_OPTIONS_VALID = "광고 유지 시간"
FP_OPTIONS_FONTSIZE = "글자 크기"
FP_OPTIONS_SCALE = "창 크기"
FP_OPTIONS_COLOR = "창 색상"
FP_OPTIONS_ICON = "미니맵 아이콘 보기"
FP_OPTIONS_ESC = "ESC로 창 닫기"
FP_OPTIONS_RIGHTBUTTON = "Ctrl+우클릭 파티 신청"
FP_OPTIONS_NORAID = "레이드 던전에 있을때 비활성화"
FP_OPTIONS_NOPVP = "전장에 있을때 비활성화"
FP_OPTIONS_RESET = "설정 초기화"
FP_OPTIONS_RESETPOS = "창 위치"
FP_OPTIONS_RESETSIZE = "창 크기"
FP_OPTIONS_RESETALL = "모든 설정 초기화"

FP_HELPS = {
	"|cffffff00---- 클래식 버전 제작자 : 엘나르핌 (Inven) aka Elnarfim (Curse)",
	"|cffffff00---- 원 제작자 : thenotfound (섬게이트)",
	"|cffffff00---- 섬게 버전 수정자 : 불성: Zimbal2 Tycho74 (섬게이트), 일분일초 (스톰레이지) / 리분: 유아원때일진 (헬스크림) / 드군, 군단: 일분일초 (스톰레이지)",
	"|cffffff00---- 인벤 버전 수정자 : 리분, 대격변, 판다, 드군: 법사세린 (아즈샤라) / 드군, 군단, 격아: 아리보리 (아즈샤라) / 격아, 어둠땅: 엘나르핌",
	"|cffffff00---- version |cffff0000"..GetAddOnMetadata("FindParty", "version").." Classic",
	"\n",
	"|cffffff00 사용법",
	"|cffffff00  * 목록",
	"|cffffff00    왼쪽 클릭 : 선택",
	"|cffffff00    Alt + 왼쪽 클릭 : 파티 신청",
	"|cffffff00    Shift + 왼쪽 클릭 : 파티장 정보 보기",
	"|cffffff00    오른쪽 아래 귀퉁이 클릭 : 크기조정",
	"\n",
	"|cffffff00  * 설정",
	"|cffffff00    광고유지시간 : 광고글 유지 시간(초)",
	"|cffffff00    글자 크기 : 목록 글자 크기",
	"|cffffff00    창 크기 : 전체 UI 크기",
	"|cffffff00    미니맵 아이콘 보기 : 미니맵 아이콘 표시",
	"|cffffff00     - 숨김 UI는 단축키 지정 또는 /fp 로 이용가능",
	"|cffffff00    ESC로 창 닫기 : ESC를 눌러서 UI 닫기",
	"|cffffff00    Ctrl + 우클릭 파티 신청",
	"|cffffff00     : 목록에서 Ctrl + 우클릭으로 대상에게 귓속말 가능",
	"|cffffff00    [] 있을때 비활성화",
	"|cffffff00     : [] 인스턴스 내부일때 애드온을 비활성화함",
	"|cffffff00     : 낮은 사양일 때 다소 성능향상이 있을수 있음",
	"\n",
	"|cffffff00  * 채널 설정 안내",
	"|cffffff00    설정의 파티찾기 채널 지정 메뉴에서 파티찾기 채널을 선택하세요.",
	"\n",
	"|cffffff00  * 기타",
	"|cffffff00    단축키 메뉴에 UI 표시 단축키를 지원합니다.",
}

BINDING_HEADER_FINDPARTY = "파티 찾기 도우미";
BINDING_NAME_FP_TOGGLE = "파티 찾기 도우미 열기";
