﻿local L = LibStub("AceLocale-3.0"):NewLocale("IRF3", "koKR", false)
if not L then return end

L["Lime_leftclick"] = "좌클릭: 환경설정"
L["Lime_rightclick"] = "우클릭: 메뉴"
L["Lime_applyprofile"] = "[|cff8080ff%s|r] 프로필이 현재 캐릭터에 적용되었습니다."
L["Lime_option_error"] = "전투중에는 인벤 레이드 프레임의 옵션 설정이 불가능합니다.\n전투 종료후 다시 시도해주세요."
L["Lime_option_error2"] = "전투중에는 활성/비활성화 설정을 할 수 없습니다."
L["Lime_profile_error1"] = "전투 중에는 프로필을 변경할 수 없습니다."
L["Lime_profile_error2"] = "[|cff8080ff%s|r] 프로필이 존재하지 않습니다."
L["Lime_profile_info"] = "프로필 이름을 지정해주세요. 명령어 사용법: /irf s [프로필 이름]"
L["Lime_Show"] = "공격대 창이 활성화되었습니다."
L["Lime_Hide"] = "공격대 창이 비활성화되었습니다."
L["Lime_Preference"] = "환경 설정"
L["Lime_ReadyCheck"] = "전투 준비 확인"
L["Lime_RoleCheck"] = "역할 확인"
L["Lime_Toggle"] = "사용 전환"
L["Lime_use"] = "사용"
L["Lime_lock"] = "고정"
L["Lime_CheckIncompatible"] = "|cffff6600[경고]|r 아군 이름표를 표시하면 Lime의 툴팁이 보이지 않게 됩니다."
L["default_font"]="기본 글꼴"
L["Lime_Manager"] = "파티 구성원"
L["Lime_Marker"] = "위치 표시기 메뉴"
L["Lime_Default"] = "기본값"
L["Lime_reset"] = "사용자 환경 설정에 이상이 발생하여, 사용자 환경을 초깃값으로 설정하였습니다."
L["Lime_partytag"] = "%d 파티"
L["Lime_my_partytag"] = "내 파티"
L["Lime_register_BossAura"] = " - 새로운 중요 디버프를 발견하여 중요 디버프 목록에 추가합니다."
L["Lime_register_BossAura2"] = " - 새로운 중요 버프를 발견하여 중요 버프 목록에 추가합니다."
L["Lime_offline"] = "오프"
L["Lime_ghost"] = "유령"
L["Lime_dead"] = "죽음"
L["Lime_afk"] = "자리"

L["library_1"] = ",Combat Log Health(빠른 체력바)"
L["library_2"] = ",HealComm(예측힐)"
L["library_3"] = " 외부 라이브러리 로드-"
L["library_4"] = " 외부 라이브러리 로드 없음"


L["Lime_EnableAddon_title_1"] = "IRF 오류: 블리자드 기본 공격대 애드온이 꺼져있으면 인벤 레이드 프레임을 사용 할 수 없습니다."
L["Lime_EnableAddon_sub_1"] = "\r\rBlizzard_CompactRaidFrames\rBlizzard_CUFProfiles\r\r강제로 활성화 하였습니다.\rUI reload 를 눌러주세요."
L["ClickCast_desc1"]="IRF3: Click Casting setting duplicated for two specialization."

L["lime_survival_얼인"] = "얼인"
L["lime_survival_흡혈"] = "흡혈"
L["lime_survival_춤룬"] = "춤룬"
L["lime_survival_대보"] = "대보"
L["lime_survival_룬전"] = "룬전"
L["lime_survival_탈태"] = "탈태"
L["lime_survival_영방"] = "영방"
L["lime_survival_황천"] = "황천"
L["lime_survival_리치"] = "리치"
L["lime_survival_흐릿"] = "흐릿"
L["lime_survival_생본"] = "생본"
L["lime_survival_껍질"] = "껍질"
L["lime_survival_화신"] = "화신"
L["lime_survival_죽척"] = "죽척"
L["lime_survival_위장"] = "위장"
L["lime_survival_거북"] = "거북"
L["lime_survival_얼방"] = "얼방"
L["lime_survival_투명"] = "투명"
L["lime_survival_상투"] = "상투"
L["lime_survival_강화"] = "강화"
L["lime_survival_마해"] = "마해"
L["lime_survival_업보"] = "업보"
L["lime_survival_민활"] = "민활"
L["lime_survival_강화"] = "강화"
L["lime_survival_해악"] = "해악"
L["lime_survival_무적"] = "무적"
L["lime_survival_가호"] = "가호"
L["lime_survival_헌수"] = "헌수"
L["lime_survival_고대"] = "고대"
L["lime_survival_오숙"] = "오숙"
L["lime_survival_눈"] = "눈"
L["lime_survival_성희"] = "성희"
L["lime_survival_저지"] = "저지"
L["lime_survival_광포"] = "광포"
L["lime_survival_불굴"] = "불굴"
L["lime_survival_주분"] = "주분"

L["lime_survival_구원"] = "구원"
L["lime_survival_분산"] = "분산"
L["lime_survival_흡선"] = "흡선"
L["lime_survival_소실"] = "소실"
L["lime_survival_희망"] = "희망"
L["lime_survival_회피"] = "회피"
L["lime_survival_그망"] = "그망"
L["lime_survival_소멸"] = "소멸"
L["lime_survival_반격"] = "반격"
L["lime_survival_영혼"] = "영혼"
L["lime_survival_고인"] = "고인"
L["lime_survival_에테"] = "에테"
L["lime_survival_결의"] = "결의"
L["lime_survival_방벽"] = "방벽"
L["lime_survival_최저"] = "최저"
L["lime_survival_투혼"] = "투혼"
L["lime_survival_주반"] = "주반"
L["lime_survival_격재"] = "격재"
L["lime_survival_쇠날"] = "쇠날"
L["lime_survival_보축"] = "보축"
L["lime_survival_수호"] = "수호"
L["lime_survival_고억"] = "고억"
L["lime_survival_희축"] = "희축"
L["lime_survival_무껍"] = "무껍"
L["lime_survival_고치"] = "고치"
L["lime_survival_자극"] = "자극"
L["lime_survival_여왕"] = "여왕"
L["lime_survival_주축"] = "주축"
L["lime_survival_민첩"] = "민첩"
L["lime_survival_힘"] = "힘"
L["lime_survival_체력"] = "체력"
L["lime_survival_지능"] = "지능"
L["lime_survival_죽음"] = "죽음"
L["lime_survival_방어도"] = "방어도"
L["lime_survival_피"] = "피"
L["lime_survival_마나"] = "마나"
L["lime_survival_쐐기"] = "쐐기"
L["lime_survival_교란"] = "교란"
L["lime_survival_약병"] = "약병"
L["lime_survival_명상"] = "명상"

L["lime_survival_희물"] = "희물"
L["lime_survival_총명"] = "총명"
L["lime_survival_퇴마"] = "퇴마"
L["lime_survival_집착"] = "집착"
L["lime_survival_도깨"] = "도깨"
L["lime_survival_각성"] = "각성"
L["lime_survival_투물"] = "투물"
L["lime_survival_군단"] = "군단물약"

L["lime_survival_어둠"] = "어둠" -- "어둠"

-- Lime Option
L["lime_a"] = "기본"
L["lime_b"] = "외형"
L["lime_c"] = "기능"

L["사용"] = "사용"
L["정렬 및 배치"] = "정렬 및 배치"
L["소환수"] = "소환수"
L["클릭 캐스팅"] = "클릭 캐스팅" 
L["프로필 관리"] = "프로필 관리"
L["고급"] = "고급"

L["사용desc"] = "애드온 사용에 관한 설정을 합니다."
L["정렬 및 배치desc"] = "공격대 그룹의 정렬과 배치에 관한 설정을 합니다. 미리보기 기능을 통해 보다 쉽게 해당 설정을 할 수 있습니다."
L["소환수desc"] = "각 공격대원 프레임의 하단에 있는 소환수 프레임을 설정합니다."
L["클릭 캐스팅desc"] = "각 공격대원 프레임에 마우스 버튼과 Alt, Shift, Ctrl의 조합으로 주문을 시전할 수 있는 클릭 캐스팅 설정을 합니다."
L["프로필 관리desc"] = "캐릭터 별로 자신이 설정한 프로필로 간단히 변경 가능하게 해줍니다."
L["고급desc"] = "추가 옵션을 설정합니다."

L["프레임"] = "프레임"
L["체력바 및 직업 색상"] = "체력바 및 직업 색상"
L["마나바"] = "마나바"
L["이름"] = "이름"
L["파티 이름표"] = "파티 이름표"
L["배경 테두리"] = "배경 테두리"
L["디버프 색상"] = "디버프 색상"

L["프레임desc"] = "각 공격대원 프레임의 외형을 설정합니다."
L["체력바 및 직업 색상desc"] = "각 공격대원 프레임의 체력바 외형과 직업 색상을 설정합니다."
L["마나바desc"] = "각 공격대원 프레임의 마나바 외형을 설정합니다."
L["이름desc"] = "각 공격대원 프레임의 이름 글자의 모양 및 스타일을 설정합니다."
L["파티 이름표desc"] = "공격대 각 파티의 이름표 표시 및 색상에 관한 설정을 합니다. 파티 이름표는 파티별 정렬 방식에서만 사용할 수 있습니다."
L["배경 테두리desc"] = "공격대 프레임 전체를 둘러싸는 테두리를 설정합니다."
L["디버프 색상desc"] = "디버프 색상을 설정합니다."


L["어그로"] = "어그로"
L["외곽선"] = "외곽선"
L["사정거리"] = "사정거리"
L["생명력 표시"] = "생명력 표시"
L["버프 확인"] = "버프 확인"
L["주문 타이머"] = "주문 타이머"
L["생존기 표시"] = "생존기 표시"
L["들어오는 치유/흡수"] = "들어오는 치유 및 흡수"
L["무시할 오라 설정"] = "무시할 오라 설정"
L["디버프 아이콘 표시"] = "디버프 아이콘 표시"
L["해제 가능한 디버프"] = "해제 가능한 디버프"
L["중요 오라 표시"] = "중요 오라 표시"
L["적대적인 대상 표시"] = "적대적인 대상 표시"
L["전술 목표 아이콘"] = "전술 목표 아이콘"
L["시전바"] = "시전바"
L["상황 표시바"] = "상황 표시바"
L["부활 시전바"] = "부활 시전바"
L["역할 아이콘"] = "역할 아이콘"
L["중앙 상태 아이콘"] = "중앙 상태 아이콘"
L["도핑 체크"] = "도핑 체크"

L["도핑 기준"] = "도핑 기준"
L["파티장 아이콘"] = "파티장 아이콘"

L["어그로desc"] = "위협 수준(어그로)을 획득한 플레이어의 이름 왼쪽에 붉은색 화살표를 표시 유무를 설정하거나 어그로 획득 소리의 재생유무를 설정합니다."
L["외곽선desc"] = "각 공격대원 프레임의 외곽선을 어떻게 표시할지에 대해 설정합니다."
L["사정거리desc"] = "사정 거리에 따른 프레임의 투명도를 설정합니다. 힐을 할 수 있는 범위인 40미터를 기준으로 투명도가 적용됩니다."
L["생명력 표시desc"] = "공격대 프레임에 생명력을 표시할 방법을 설정합니다."
L["버프 확인desc"] = "자신이 시전 할 수 있는 버프가 걸려 있는지 유무를 표시하는 방법을 설정합니다."
L["주문 타이머desc"] = "버프 및 디버프를 아이콘과 남은 시간으로 표시합니다. 버프/디버프 이름이나 주문 ID를 입력후 꼭 엔터키를 눌러야 변경 사항이 적용됩니다."
L["생존기 표시desc"] = "플레이어가 시전한 생존기의 주문 이름을 플레이어의 이름과 대체합니다."
L["들어오는 치유/흡수desc"] = "플레이어에게 들어오는 치유량 및 흡수량을 투명한 체력바로 보여주거나 아이콘으로 보여줍니다."
L["무시할 오라 설정desc"] = "표시 하지 않을 오라를 추가 하거나 삭제합니다."
L["디버프 아이콘 표시desc"] = "플레이어에게 걸린 디버프를 프레임에 표시합니다."
L["해제 가능한 디버프desc"] = "해제 가능한 디버프에 대한 설정을 합니다."
L["중요 오라 표시desc"] = "중요한 오라를 프레임에 크게 표시합니다(단, 버프는 블리자드가 중요 오라로 지정한 경우에만 작동합니다)."
L["적대적인 대상 표시desc"] = "정신 지배 등으로 적대적이된 플레이어의 체력바 색상을 변경합니다."
L["전술 목표 아이콘desc"] = "전술 목표 아이콘을 표시할 방법을 설정합니다."
L["시전바desc"] = "플레이어의 시전 바를 표시합니다."
L["상황 표시바desc"] = "상황 표시바를 설정합니다."
L["부활 시전바desc"] = "부활을 받고 있는 플레이어에게 부활 시전 바를 표시합니다. 제일 먼저 시전 완료될 시전바만 표시하며, 같은 파티가 아닌 플레이어가 시전한 경우 시전바는 표시되지 않습니다."
L["역할 아이콘desc"] = "플레이어에게 부여된 역할 아이콘을 표시합니다."
L["중앙 상태 아이콘desc"] = "다른 인스턴스 파티 또는 다른 위상에 있거나 부활중인 대상에게 아이콘을 표시합니다."
L["도핑 체크desc"] = "전투 준비 시 영약 및 음식등의 도핑이 되었는지 공대 창으로 알려주는 기능입니다."
L["파티장 아이콘desc"] = "파티장 또는 공격대장을 알려주는 아이콘을 표시합니다."

L["파티헤더"]="내 파티"
L["방어전담헤더"]="방어전담"

L["도핑 체크msg1"]="전원 도핑이 완료된 상태입니다."
L["도핑 체크msg2"]="도핑이 미흡한 사람이 있습니다."
L["도핑 체크msg3"]="음식 없음: "
L["도핑 체크msg4"]="영약/비약 없음: "


L["미리 보기 끄기"] = "미리 보기 끄기"
L["미리 보기 - 5인"] = "미리 보기 - 5인"
L["미리 보기 - 10인"] = "미리 보기 - 10인"
L["미리 보기 - 20인"] = "미리 보기 - 20인"
L["미리 보기 - 25인"] = "미리 보기 - 25인"
L["미리 보기 - 30인"] = "미리 보기 - 30인"
L["미리 보기 - 40인"] = "미리 보기 - 40인"
L["lime_previewDropdown"] = "미리 보기를 활성화 또는 비활성화합니다."

L["좌측 상단"] = "좌측 상단"
L["상단"] = "상단"
L["우측 상단"] = "우측 상단"
L["좌측"] = "좌측"
L["중앙"] = "중앙"
L["우측"] = "우측"
L["좌측 하단"] = "좌측 하단"
L["하단"] = "하단"
L["우측 하단"] = "우측 하단"

L["초"] = "초"
L["도"] = "도"

L["lime_advanced_01"] = "호환성 경고 메시지 표시"
L["lime_advanced_desc_01"] = "호환성에 문제가 있는 애드온이 감지되면 경고 메시지를 표시합니다."
L["lime_advanced_02"] = "정상 작동 여부"
L["lime_advanced_desc_02"] = "체크가 되어 있다면 정상적으로 애드온을 사용할 수 있습니다."
L["lime_advanced_03"] = "타이머"
L["lime_advanced_desc_03"] = "레이드 프레임을 반복적으로 새로 고치는 주기입니다. 주기를 수정하려면 LUA를 직접 편집해야 합니다."
L["lime_advanced_04"] = "탑승물 추적 여부"
L["lime_advanced_desc_04"] = "탑승물 추적 여부를 수정하려면 LUA를 직접 편집해야 합니다."
L["lime_advanced_05"] = "|cffff6600모든 경고 무시|r"
L["lime_advanced_desc_05"] = "호환성 경고를 무시하고 제한된 기능을 강제로 작동하도록 합니다. 이 기능은 상당히 위험한 기능이오니, 해당 기능을 잘 모른다면 체크를 하지 마세요."
L["lime_advanced_06"] = "|cffff6600아군 이름표를 표시하면 Lime의 툴팁 표시 기능이 비활성화됩니다. 모든 경고를 무시하도록 설정하면 툴팁 기능을 다시 사용할 수 있으나 심각한 충돌이 발생할 가능성이 높습니다.|r"
L["lime_advanced_07"] = "ALT키 이동"
L["lime_advanced_desc_07"] = "잠금 상태일 때 ALT를 이용하여 공격대 프레임을 드래그할 수 있습니다."
L["lime_advanced_09"] = "주문 ID를 툴팁에 표시"
L["lime_advanced_desc_09"] = "주문 ID를 툴팁에 표시합니다."
L["lime_advanced_10"] = "아이콘의 등장 연출을 비활성화 합니다."
L["lime_advanced_desc_10"] = "주문 타이머와 약화 효과의 점점 커지는 연출을 비활성화 합니다."
L["lime_advanced_11"] = "가짜 이름으로 애드온을 연결합니다."
L["lime_advanced_desc_11"] = "OmniCD 와 비슷한 기능의 애드온과 연동하기 위해 애드온 이름을 추가합니다.(해당 애드온이 꺼져 있어야 합니다.) 설정 후 수동으로 UI Load 가 필요합니다. 채팅창에 /reload 를 쳐주세요."
L["lime_advanced_12"] = " "
L["lime_advanced_desc_12"] = "|cffffffff( 변경 후 채팅창에 |cffffdd00/reload|cffffffff를 입력하세요. )"
L["lime_advanced_13"] = "주문 타이머의 숫자를 아이콘과 겹치게 합니다."
L["lime_advanced_desc_13"] = "주문 타이머의 숫자를 아이콘과 겹치게 합니다."


L["사용하기"] = "사용하기"
L["사용 안함"] = "사용 안함"

L["lime_basic_01"] = "사용"
L["lime_basic_desc_01"] = "공격대 창 사용 여부를 설정합니다."
L["lime_basic_02"] = "사용 조건"
L["lime_basic_desc_02"] = "해당 조건일 때 공격대 창을 보여줍니다."
L["lime_basic_03"] = "툴팁 표시"
L["lime_basic_desc_03"] = "툴팁 표시 여부를 설정합니다."
L["lime_basic_04"] = "창 고정"
L["lime_basic_desc_04"] = "공격대 창을 잠가 이동하지 못하게 고정합니다."
L["lime_basic_05"] = "미니맵 버튼 표시"
L["lime_basic_desc_05"] = "미니맵 버튼을 표시합니다."
L["lime_basic_06"] = "미니맵 버튼 고정"
L["lime_basic_desc_06"] = "미니맵 버튼을 고정합니다."
L["lime_basic_07"] = "기본 파티 창 숨기기"
L["lime_basic_desc_07"] = "월드 오브 워크래프트 파티 창의 표시 여부를 설정합니다."
L["lime_basic_08"] = "위치 초기화"
L["lime_basic_desc_08"] = "공격대 창의 위치를 초기화합니다."
L["lime_basic_09"] = "공격대 관리자 사용하기"
L["lime_basic_desc_09"] = "화면 좌측 상단에 공격대 관리자 창의 사용 여부를 설정합니다."
L["lime_basic_10"] = "공격대 관리자 위치"
L["lime_basic_desc_10"] = "공격대 관리자 창의 위치를 설정합니다."
L["lime_basic_11"] = "시전 표시기"
L["lime_basic_desc_11"] = "주문이 시전 되었을 때 효과를 줍니다."
L["lime_basic_12"] = "정렬 방식"
L["lime_basic_desc_12"] = "공격대 파티를 파티별 혹은 직업별로 정렬합니다."
L["lime_basic_13"] = "기준점"
L["lime_basic_desc_13"] = "공격대 배치 기준점을 설정합니다."
L["lime_basic_14"] = "가로 방향 파티 수"
L["lime_basic_desc_14"] = "가로 방향으로 배치할 공격대 파티 수를 설정합니다."
L["lime_basic_15"] = "파티원 배치 방향"
L["lime_basic_desc_15"] = "파티 내 구성원을 가로 혹은 세로로 배치합니다."
L["lime_basic_16"] = "파티 이름표 보기"
L["lime_basic_desc_16"] = "공격대 파티의 이름표를 표시합니다. 직업별로 배치하면 이름표는 표시되지 않습니다."
L["lime_basic_17"] = "이름 순 정렬"
L["lime_basic_desc_17"] = "공격대원을 이름 순으로 정렬합니다."
L["lime_basic_18"] = "버튼을 클릭하여 해당 파티를 보이거나 숨기게 합니다. 버튼을 드래그하여 파티의 정렬 순서를 정할 수 있습니다."

L["항상"] = "항상"
L["파티 및 공격대"] = "파티 및 공격대"
L["공격대"] = "공격대"
L["파티"] = "파티"
L["표시 안함"] = "표시 안함"
L["항상 표시"] = "항상 표시"
L["전투 중이 아닐 때만 표시"] = "전투 중이 아닐 때만 표시"
L["전투 중일 때만 표시"] = "전투 중일 때만 표시"
L["마우스를 올릴 때 표시"] = "마우스를 올릴 때 표시"
 

L["파티별"] = "파티별"
L["직업별"] = "직업별"
L["역할별"] = "역할별"
L["개 그룹"] = "개 그룹"
L["세로 방향"] = "세로 방향"
L["가로 방향"] = "가로 방향"

L["대상 선택"] = "대상 선택"
L["메뉴"] = "메뉴"
L["마법책 - "] = "마법책 - "
L["마법책"] = "마법책"
L["없음"] = "없음"
L["특성: %s"] = "특성: %s"
L["활성화특성"]= "현재 활성화된 특성: %s"

L["lime_profile_current"] = "현재 프로필: |cffffffff"
L["기본값"] = "기본값"
L["프로필 목록"] = "프로필 목록"
L["lime_profile_01"] = "현재 캐릭터에 프로필 적용"
L["lime_profile_desc_01"] = "현재 캐릭터에 선택된 프로필을 적용합니다."
L["lime_profile_02"] = "새 프로필 만들기"
L["lime_profile_desc_02"] = "현재 선택된 프로필을 복사하여 새 프로필을 생성하고 현재 캐릭터에 적용합니다. 프로필 선택하지 않았다면 초깃값 상태의 프로필을 생성합니다."
L["lime_profile_03"] = "프로필 삭제"
L["lime_profile_desc_03"] = "현재 선택된 프로필을 삭제합니다."
L["lime_profile_make"] ="새로운 프로필을 작성합니다.\n새 프로필 이름을 입력해주세요"
L["lime_profile_make_message_01"] = "[|cff8080ff%s|r] 이미 존재하는 프로필입니다."
L["lime_profile_make_message_02"] = "[|cff8080ff%s|r] 새로운 프로필이 생성되고 적용되었습니다."
L["lime_profile_make_message_03"] = "프로필 생성이 실패했습니다."
L["lime_profile_delete"] = "'%s' 프로필을 삭제합니다.\n정말 삭제하시겠습니까?"
L["lime_profile_delete_message_01"] = "[|cff8080ff%s|r] 프로필이 삭제되었습니다."
L["lime_profile_apply"] = "현재 캐릭터에 '%s' 프로필을 적용하시겠습니까?"
L["lime_profile_apply_message_01"] = "[|cff8080ff%s|r] 프로필이 현재 캐릭터에 적용되었습니다."
L["lime_profile_help"] = "Lime 명령어\n|cffa2e665/lime|r: 환경 설정을 엽니다.\n|cffa2e665/lime s [설정 이름]|r: 환경 설정을 [설정 이름]으로 바꿉니다. 전투 중에는 바꿀 수 없습니다.\n|cffa2e665/lime t|r: 공격대 창을 켜거나 끕니다.\n|cffa2e665/lime h|r: 전체 명령어 및 도움말을 보여줍니다."
L["현재 프로필"] = "현재 프로필: |cffffffff"
L["lime_layout_01"] = "바 텍스처"
L["lime_layout_desc_01"] = "바 텍스처를 설정합니다."
L["lime_layout_02"] = "크기"
L["lime_layout_desc_02"] = "프레임의 전체적인 크기를 조절합니다."
L["lime_layout_03"] = "너비"
L["lime_layout_desc_03"] = "프레임의 너비를 조절합니다."
L["lime_layout_04"] = "높이"
L["lime_layout_desc_04"] = "프레임의 높이를 조절합니다."
L["lime_layout_05"] = "간격"
L["lime_layout_desc_05"] = "각 플레이어 간의 간격을 조절합니다."
L["lime_layout_06"] = "하이라이트 투명도"
L["lime_layout_desc_06"] = "마우스를 올렸을 때 강조되는 텍스처의 투명도를 설정합니다. 0으로 설정하면 보이지 않습니다."
L["lime_layout_07"] = "배경 색상"
L["lime_layout_desc_07"] = "각 플레이어의 배경 색상 및 투명도를 설정합니다."
L["lime_layout_08"] = "체력바 방향"
L["lime_layout_desc_08"] = "체력바의 진행 방향을 설정합니다."
L["lime_layout_09"] = "직업별 체력바 색상"
L["lime_layout_desc_09"] = "직업별 색상에 따라 체력바 색상을 변경합니다."
L["lime_layout_10"] = "색상 초기화"
L["lime_layout_desc_10"] = "설정한 색상을 초기값으로 되돌립니다."
L["lime_layout_11"] = "의 색상을 변경합니다."
L["lime_layout_12"] = "마나바 위치"
L["lime_layout_desc_12"] = "마나바의 위치를 설정합니다."
L["lime_layout_13"] = "크기 비율"
L["lime_layout_desc_13"] = "마나바의 크기 비율을 설정합니다. 0%로 설정하면 마나바가 숨겨지며 100%로 설정하면 체력바가 숨겨집니다."
L["lime_layout_14"] = "색상 초기화"
L["lime_layout_desc_14"] = "설정한 색상을 초기값으로 되돌립니다."
L["lime_layout_15"] = "의 색상을 변경합니다."
L["lime_layout_16"] = "이름 글꼴 설정"
L["lime_layout_desc_16"] = "이름 글꼴을 변경합니다."
L["lime_layout_17"] = "직업별 이름 색상 사용"
L["lime_layout_desc_17"] = "이름 색상을 직업 색상으로 표시합니다."
L["lime_layout_18"] = "이름 색상"
L["lime_layout_desc_18"] = "이름 색상을 설정합니다. 직업별 색상 사용시 적용되지 않습니다."
L["lime_layout_19"] = "먼 사정거리 직업별 이름 색상 사용"
L["lime_layout_desc_19"] = "사정거리가 벗어난 플레이어의 이름 색상을 직업 색상으로 표시합니다."
L["lime_layout_20"] = "죽은 플레이어 직업별 이름 색상 사용"
L["lime_layout_desc_20"] = "죽거나 유령인 플레이어의 이름 색상을 직업별 색상으로 표시합니다."
L["lime_layout_21"] = "오프라인 플레이어 직업별 이름 색상 사용"
L["lime_layout_desc_21"] = "오프라인된 플레이어의 이름 색상을 직업별 색상으로 표시합니다."
L["lime_layout_22"] = "파티 이름표 보기"
L["lime_layout_desc_22"] = "공격대 파티의 이름표를 표시합니다."
L["lime_layout_23"] = "내 파티 이름표 색상"
L["lime_layout_desc_23"] = "자기 자신이 속한 파티의 이름표 배경 색상을 설정합니다."
L["lime_layout_24"] = "파티 이름표 색상"
L["lime_layout_desc_24"] = "파티의 이름표 배경 색상을 설정합니다."
L["lime_layout_25"] = "배경 테두리 보기"
L["lime_layout_desc_25"] = "공격대 창 전체를 둘러싸는 테두리를 보입니다."
L["lime_layout_26"] = "색상 초기화"
L["lime_layout_desc_26"] = "설정한 색상을 초깃값으로 되돌립니다."
L["lime_layout_27"] = "배경 테두리 내부 색상"
L["lime_layout_desc_27"] = "공격대 창 내부 테두리의 색상 및 투명도를 조절합니다."
L["lime_layout_28"] = "배경 테두리 색상"
L["lime_layout_desc_28"] = "공격대 창 전체를 둘러싸는 테두리의 색상 및 투명도를 조절합니다."
L["lime_layout_29"] = "색상 초기화"
L["lime_layout_desc_29"] = "설정한 색상을 초깃값으로 되돌립니다."
L["lime_layout_30"] = "디버프의 색상을 변경합니다."
L["lime_layout_31"] = "잃은 생명력 글꼴 설정"
L["lime_layout_desc_31"] = "잃은 생명력 글꼴을 변경합니다."
L["lime_layout_32"] = "테두리 스킨 변경"
L["lime_layout_desc_32"] = "테두리 스킨을 변경합니다."


L["우호적 대상"] = "우호적 대상"
L["적대적 대상"] = "적대적 대상"
L["탈것 탑승 시"] = "탈것 탑승 시"
L["오프라인일 때"] = "오프라인일 때"
L["전사"] = "전사"
L["도적"] = "도적"
L["사제"] = "사제"
L["마법사"] = "마법사"
L["흑마법사"] = "흑마법사"
L["사냥꾼"] = "사냥꾼"
L["드루이드"] = "드루이드"
L["주술사"] = "주술사"
L["성기사"] = "성기사"
L["죽음의 기사"] = "죽음의 기사"
L["수도사"] = "수도사"
L["악마사냥꾼"] = "악마사냥꾼"

L["마법"] = "마법"
L["저주"] = "저주"
L["질병"] = "질병"
L["독"] = "독"
L["무속성"] = "무속성"

L["가로"] = "가로"
L["세로"] = "세로"

L["lime_func_1"] = "어그로 화살표 보기"
L["lime_func_1_1"] = "화살표 색상 세분화"
L["lime_func_1_2"] ="|cffff0000▶ 현재 대상\n|cffffa500▶ 현재 대상이지만 어그로100%를 초과한 다른 플레이어가 있는 경우\n|cffffff00▶ 현재 대상이 아니지만 어그로100%를 초과하여 역전가능성이 높은 플레이어"

L["lime_func_2"] = "어그로 소리 재생 조건"
L["lime_func_3"] = "어그로 획득 시 소리"
L["lime_func_4"] = "어그로 손실 시 소리"
L["lime_func_5"] = "외곽선 동작"
L["lime_func_6"] = "외곽선 크기"
L["lime_func_7"] = "외곽선 투명도"
L["lime_func_8"] = "외곽선 색상"
L["lime_func_9"] = "체력 저하 경고 생명력"
L["lime_func_10"] = "표시 방식"
L["lime_func_11"] = "표시 조건"
L["lime_func_12"] = "생명력 짧게 표시"
L["lime_func_13"] = "두 줄로 표시"
L["lime_func_14"] = "생명력 색상 표시"
L["lime_func_15"] = "보호막 수치 표시"
L["lime_func_16"] = "사정거리 밖 투명도"
L["lime_func_16_1"] = "사정거리 밖 직업 색상"
L["lime_func_17"] = "사정거리 밖 마나바 투명도"

L["lime_func_desc_1"] = "어그로를 획득한 플레이어의 이름 왼쪽에 붉은색 화살표를 표시합니다."
L["lime_func_desc_1_1"] = "어그로에 따라 3가지 색상 화살표로 구분합니다."
L["lime_func_desc_2"] = "어그로 획득/손실 시 소리를 재생할 조건을 설정합니다."
L["lime_func_desc_3"] = "자신이 어그로를 획득했을 때 소리를 재생합니다. None으로 설정하시면 소리 재생 기능을 사용하지 않습니다."
L["lime_func_desc_4"] = "자신이 어그로를 잃었을 때 소리를 재생합니다. None으로 설정하시면 소리 재생 기능을 사용하지 않습니다."
L["lime_func_desc_5"] = "외곽선을 설정합니다."
L["lime_func_desc_6"] = "외곽선의 크기를 설정합니다."
L["lime_func_desc_7"] = "외곽선의 투명도를 설정합니다."
L["lime_func_desc_8"] = "대상을 선택했을 때 외곽선 색상을 설정합니다"
L["lime_func_desc_9"] = "마우스를 대상에 올렸을 때 외곽선 색상을 설정합니다"
L["lime_func_desc_10"] = "어그로를 획득한 대상의 외곽선 색상을 설정합니다"
L["lime_func_desc_11"] = "생명력이 낮은 대상의 외곽선 색상을 설정합니다"
L["lime_func_desc_12"] = "지정한 퍼센트 이하로 체력이 떨어지면 외곽선을 표시합니다."
L["lime_func_desc_13"] = "지정한 전술 목표 아이콘을 가진 대상의 외곽선 색상을 설정합니다"
L["lime_func_desc_14"] = "에 외곽선을 표시합니다."
L["lime_func_desc_15"] = "생명력이 낮은 대상의 외곽선 색상을 설정합니다"
L["lime_func_desc_16"] = "지정한 생명력 이하로 떨어지면 외곽선을 표시합니다."
L["lime_func_desc_16_1"] = "사정거리가 벗어난 플레이어의 이름 색상을 직업 색상으로 표시합니다. 사정거리를 벗어난 죽은 대상은 반투명한 이름으로 출력됩니다."
L["lime_func_desc_17"] = "사정거리가 벗어난 플레이어의 생명력 바 투명도를 조절합니다."
L["lime_func_desc_18"] = "사정거리를 벗어난 플레이어의 마나바를 투명하게 적용합니다."
L["lime_func_desc_19"] = "생명력을 표시할 방식을 설정합니다."
L["lime_func_desc_20"] = "생명력을 표시할 조건을 설정합니다."
L["lime_func_desc_21"] = "생명력 수치를 천 단위로 짧게 표시합니다. 예를 들어 3700의 표시할 생명력이 있다면 이를 3.7로 표시합니다. 또 퍼센트 방식의 표현일 경우 % 기호를 표시하지 않습니다."
L["lime_func_desc_22"] = "이름과 생명력/생존기를 두 줄로 표시합니다."
L["lime_func_desc_23"] = "생명력 글자에 색상을 표시합니다. (손실: 붉은색, 흡수: 파란색)"
L["lime_func_desc_24"] = "최대 체력 상태에서 보호막이 있을 경우 보호막 수치를 표시합니다."

L["lime_func_spelltimer_1"] = "[|cff8080ff%s|r] 주문이 주문 타이머에 저장되었습니다."
L["lime_func_spelltimer_2"] = "주문 타이머 "
L["lime_func_spelltimer_3"] = "의 사용 여부 및 버프/디버프 속성을 설정합니다."
L["lime_func_spelltimer_4"] = "의 위치를 설정합니다."
L["lime_func_spelltimer_5"] = "의 표시 방식을 설정합니다."
L["lime_func_spelltimer_6"] = "의 크기를 설정합니다."
L["lime_func_spelltimer_7"] = "로 사용할 버프 혹은 디버프의 이름이나 주문 번호(Spell ID)을 입력하세요. 입력 후 꼭 ENTER 키를 눌러야 변경 사항이 적용됩니다."

L["위치"] = "위치"
L["표시 방식"] = "표시 방식"
L["주문 ID"] = "주문 ID"
L["크기"] = "크기"
L["색상"] = "색상"
L["버프/디버프 이름"] ="버프/디버프 이름"
L["lime_func2_1"] = "생존기 보기"
L["lime_func2_desc_1"] = "플레이어가 시전한 생존기를 표시합니다."
L["lime_func2_2"] = "생존기 남은 시간 보기"
L["lime_func2_desc_2"] = "플레이어가 시전한 생존기의 남은 시간을 추가로 표시합니다."
L["lime_func2_3"] = "준생존기 보기"
L["lime_func2_desc_3"] = "재사용 대기시간이 짧은 준생존기도 함께 보여줍니다."
L["lime_func2_4"] = "물약 보기"
L["lime_func2_desc_4"] = "물약 섭취 여부를 보여줍니다."
L["lime_func2_5"] = "사용하기"
L["lime_func2_desc_5"] = "들어오는 치유/흡수 기능의 사용 여부를 설정합니다."
L["lime_func2_6"] = "들어오는 치유/흡수바 투명도"
L["lime_func2_desc_6"] = "플레이어에게 들어오는 치유량을 표시하는 바의 투명도를 설정합니다."
L["lime_func2_7"] = "내 치유 아이콘 표시"
L["lime_func2_desc_7"] = "내가 시전한 치유바와는 별도로 치유 받는 플레이어에게 네모 모양의 치유 아이콘을 표시합니다."
L["lime_func2_8"] = "타인 치유 아이콘 표시"
L["lime_func2_desc_8"] = "타인이 시전한 치유바와는 별도로 치유 받는 플레이어에게 네모 모양의 치유 아이콘을 표시합니다."
L["lime_func2_9"] = "치유/흡수 아이콘 위치"
L["lime_func2_desc_9"] = "치유/흡수 아이콘의 위치를 설정합니다."
L["lime_func2_10"] = "치유/흡수 아이콘 크기"
L["lime_func2_desc_10"] = "치유/흡수 아이콘의 크기를 설정합니다."
L["lime_func2_11"] = "내가 시전한 치유 색상"
L["lime_func2_desc_11"] = "내가 시전한 치유바 혹은 아이콘의 색상을 설정합니다."
L["lime_func2_12"] = "타인이 시전한 치유 색상"
L["lime_func2_desc_12"] = "다른 사람이 시전한 치유바 혹은 아이콘의 색상을 설정합니다."
L["lime_func2_13"] = "예상 흡수량 바 색상"
L["lime_func2_desc_13"] = "예상 흡수량 바의 색상을 설정합니다."
L["lime_func2_14"] = "내가 시전한 HoT 색상"
L["lime_func2_desc_14"] = "내가 시전한 Heal Over Time의 색상을 설정합니다."
L["lime_func2_15"] = "타인이 시전한 HoT 색상"
L["lime_func2_desc_15"] = "다른 사람이 시전한 Heal Over Time의 색상을 설정합니다."
L["lime_func2_desc_16"] ="외부 라이브러리 : HealComm을 사용하지 않을 경우"
L["lime_func2_desc_17"] ="블리자드 자체 함수를 사용하며, 이 때 HoT 정보는 표기되지 않습니다."
L["lime_func2_18"] = "시전중인 힐러수 표시"
L["lime_func2_desc_18"] = "치유 아이콘에 현재 직접힐을 시전중인 힐러 수를 표기합니다."

L["lime_func_aura_1"] = "무시할 오라 목록"
L["lime_func_aura_2"] = "삭제"
L["lime_func_aura_3"] = "선택된 오라를 목록에서 삭제합니다."
L["lime_func_aura_4"] = "\"%s\" 삭제"
L["lime_func_aura_5"] = "\"%s\"|1이;가; 무시할 오라 목록에서 삭제되었습니다."
L["lime_func_aura_6"] = "%d 주문은 존재하지 않는 주문 ID 입니다."
L["lime_func_aura_7"] = "\"%s\"|1은;는; 이미 무시할 오라 목록에 있습니다."
L["lime_func_aura_8"] = "\"%s\"|1이;가; 무시할 오라 목록에 추가되었습니다."
L["lime_func_aura_9"] = "추가"
L["lime_func_aura_10"] = "오라를 목록에 추가합니다."
L["lime_func_aura_11"] = "초기값 복원"
L["lime_func_aura_12"] = "무시할 오라 목록을 초기값으로 복원합니다."
L["lime_func_aura_13"] = "무시할 오라 목록이 초기값으로 복원되었습니다."

L["lime_func_aura_10_1"]="개별 설정"
L["lime_func_aura_10_2"]="해당 중요 오라의 개별 설정값을 사용합니다."
L["lime_func_aura_10_3"]="폰트 강조 시간(초)"
L["lime_func_aura_10_4"]="지정된 시간 도달시 폰트를 붉게 강조합니다(초)."
L["lime_func_aura_10_5"]="개별 아이콘 크기"
L["lime_func_aura_10_6"]="해당 중요 오라 아이콘의 크기를 설정합니다. 이 값은 전체 설정값보다 우선합니다."
L["lime_func_aura_10_7"]="개별 아이콘 투명도"
L["lime_func_aura_10_8"]="해당 중요 오라 아이콘의 투명도를 설정합니다. 이 값은 전체 설정값보다 우선합니다."
L["lime_func_aura_10_9"]="도핑 기준"
L["lime_func_aura_10_10"]="음식 도핑 여부를 체크하는 수치 기준입니다. 기준 : 클래식(225), 불성(300), 리분(375)"
L["lime_func_aura_10_11"]="채팅창에 도핑 결과 알리기"
L["lime_func_aura_10_12"]="채팅창 (공대창 또는 파티창)에 도핑 결과를 알려줍니다."


L["lime_func_aura_14"] = "표시될 디버프 수"
L["lime_func_aura_15"] = "공격대원 창에 표시할 디버프의 숫자를 설정합니다. 0으로 설정하면 표시하지 않습니다."
L["lime_func_aura_16"] = "디버프 아이콘이 위치할 곳을 설정합니다."
L["lime_func_aura_17"] = "디버프 아이콘의 크기를 설정합니다."
L["lime_func_aura_18"] = "표시 형식"
L["lime_func_aura_19"] = "디버프 아이콘의 표시 형식을 설정합니다."
L["lime_func_aura_20"] = " 보기"
L["lime_func_aura_21"] = " 계열의 디버프를 표시합니다."
L["lime_func_aura_22"] = "체력바 색상을 변경하기"
L["lime_func_aura_23"] = "해제 가능한 디버프에 걸린 플레이어의 체력바 색상을 변경합니다."
L["lime_func_aura_24"] = "소리 재생"
L["lime_func_aura_25"] = "해제 가능한 디버프에 걸린 플레이어가 있으면 소리를 재생합니다. None으로 설정하시면 소리 재생 기능을 사용하지 않습니다."
L["lime_func_aura_26"] = "중요 오라 목록"
L["lime_func_aura_27"] = "\"%s\"|1이;가; 중요 오라 목록에서 삭제되었습니다."
L["lime_func_aura_28"] = "%d 주문은 존재하지 않는 주문 ID 입니다."
L["lime_func_aura_29"] = "\"%s\"|1은;는; 이미 중요 오라 목록에 있습니다."
L["lime_func_aura_30"] = "\"%s\"|1이;가; 중요 오라 목록에 추가되었습니다."
L["lime_func_aura_31"] = "중요 오라 목록을 초기값으로 복원합니다."
L["lime_func_aura_32"] = "중요 오라 목록이 초기값으로 복원되었습니다."
L["lime_func_aura_33"] = "중요 오라 사용하기"
L["lime_func_aura_34"] = "중요 오라 아이콘 표시 기능을 사용합니다."
L["lime_func_aura_35"] = "중요 오라 아이콘을 표시할 위치를 설정합니다."
L["lime_func_aura_36"] = "중요 오라 아이콘의 크기를 설정합니다."
L["lime_func_aura_37"] = "투명도"
L["lime_func_aura_38"] = "중요 오라 아이콘의 투명도를 설정합니다."
L["lime_func_aura_39"] = "시계 텍스처 표시"
L["lime_func_aura_40"] = "중요 오라의 남은 시간을 시계 형식으로 표시합니다."
L["lime_func_aura_41"] = "시간 표시 방식"
L["lime_func_aura_42"] = "중요 오라의 시간 표시 방식을 설정합니다."
L["lime_func_aura_43"] = "해제 가능한 디버프만 보기"
L["lime_func_aura_44"] = "해제 가능한 디버프만 보기"
L["lime_func_aura_45"] = "남은 시간 표시"
L["lime_func_aura_46"] = "아이콘에 지속 시간을 표시 합니다."
L["lime_func_aura_47"] = "중요 오라 목록을 초기화하시겠습니까?"

L["lime_func_other_14"] = "정신 지배 등으로 적대적이 된 플레이어의 체력바 색상을 변경합니다."
L["lime_func_other_15"] = "적대적이 된 플레이어의 체력바 색상을 설정합니다."
L["lime_func_other_16"] = "전술 목표 아이콘을 표시합니다."
L["lime_func_other_17"] = "전술 목표 아이콘의 위치를 설정합니다."
L["lime_func_other_18"] = "전술 목표 아이콘 크기"
L["lime_func_other_19"] = "전술 목표 아이콘의 크기를 설정합니다."
L["lime_func_other_20"] = "대상이 선택한 대상의 전술 목표 아이콘 보기"
L["lime_func_other_21"] = "플레이어가 선택한 대상의 전술 목표 아이콘을 표시합니다."
L["lime_func_other_22"] = "를 표시합니다."
L["lime_func_other_23"] = "시전 바의 사용 여부를 설정합니다."
L["lime_func_other_24"] = "시전 바의 색상을 설정합니다."
L["lime_func_other_25"] = "시전 바의 위치를 설정합니다."
L["lime_func_other_26"] = "시전 바의 크기를 설정합니다."
L["lime_func_other_27"] = "상황 표시 바의 사용 여부를 설정합니다."
L["lime_func_other_28"] = "상황 표시 바의 위치를 설정합니다."
L["lime_func_other_29"] = "상황 표시 바의 크기를 설정합니다."
L["lime_func_other_30"] = "플레이어에게 시전되는 부활 바를 설정합니다."
L["lime_func_other_31"] = "부활 시전 바 색상을 설정합니다."
L["lime_func_other_32"] = "역할 아이콘의 표시 여부를 설정합니다."
L["lime_func_other_32_1"] = "공격대 역할정보 사용."
L["lime_func_other_32_2"] = "공대장이 지정한 역할(방어 전담, 지원 전담) 아이콘의 표시 여부를 설정합니다."
L["lime_func_other_32_3"] = "탱커만 표시"
L["lime_func_other_32_4"] = "탱커 혹은 방어전담만 표시합니다."
L["lime_func_other_33"] = "역할 아이콘을 표시할 위치를 설정합니다."
L["lime_func_other_34"] = "역할 아이콘의 크기를 설정합니다."
L["lime_func_other_35"] = "모양"
L["lime_func_other_36"] = "역할 아이콘의 모양을 변경합니다."
L["lime_func_other_37"] = "중앙에 표시되는 상태 아이콘의 표시 여부를 설정합니다."
L["lime_func_other_38"] = "파티장/공격대장 아이콘을 표시합니다."
L["lime_func_other_39"] = "파티장/공격대장 아이콘을 표시할 위치를 설정합니다."
L["lime_func_other_40"] = "파티장/공격대장 아이콘의 크기를 설정합니다."
L["lime_func_other_41"] = "딜러 아이콘만 감추기"
L["lime_func_other_42"] = "탱, 힐 아이콘만 표시합니다."

L["lime_func_button_1"] = "사용 안함"
L["lime_func_button_2"] = "해제 가능한 디버프"
L["lime_func_button_3"] = "대상"
L["lime_func_button_4"] = "마우스 오버"
L["lime_func_button_5"] = "체력 낮음 (퍼센트)"
L["lime_func_button_6"] = "어그로"
L["lime_func_button_7"] = "전술 목표 아이콘"
L["lime_func_button_8"] = "체력 낮음 (실수치)"
L["lime_func_button_9"] = "징표"

L["lime_func_button_10"] = "표시 안함"
L["lime_func_button_11"] = "손실 생명력"
L["lime_func_button_12"] = "손실 생명력 퍼센트"
L["lime_func_button_13"] = "남은 생명력"
L["lime_func_button_14"] = "남은 생명력 퍼센트"

L["lime_func_button_15"] = "사정거리 안"
L["lime_func_button_16"] = "사정거리 밖"

L["lime_func_buff_1"] = "설정할 수 있는 버프가 없습니다."
L["lime_func_buff_2"] = "버프 확인 아이콘을 표시할 위치를 설정합니다."
L["lime_func_buff_3"] = "버프 확인 아이콘의 크기를 설정합니다."
L["lime_func_buff_4"] = "표시 안함"
L["lime_func_buff_5"] = "버프가 없을 때 표시"
L["lime_func_buff_6"] = "버프가 있을 때 표시"
L["lime_func_buff_7"] = "버프의 표시 여부를 설정합니다."

L["lime_func_button_17"] = "사용 안함"
L["lime_func_button_18"] = "내가 시전한 버프"
L["lime_func_button_19"] = "내가 시전한 디버프"
L["lime_func_button_20"] = "모든 버프"
L["lime_func_button_21"] = "모든 디버프"

L["lime_func_button_22"] = "아이콘 + 남은 시간"
L["lime_func_button_23"] = "아이콘"
L["lime_func_button_24"] = "남은 시간"
L["lime_func_button_25"] = "아이콘 + 경과 시간"
L["lime_func_button_26"] = "경과 시간"
L["lime_func_button_27"] = "아이콘 + 색상"

L["lime_outRangeColorFlag_1"] = "색 변경 허용"
L["lime_outRangeColorFlag_2"] = "사정거리를 벗어난 사람의 체력 바 색상을 변경하도록 허용합니다."

L["lime_outRangeColorFlag_3"] = "사정거리를 벗어난 사람의 체력 바 색상을 변경합니다."

L["petDisplay1"]="표시 안함"
L["petDisplay2"]="일체형"
L["petDisplay3"]="분리형"
L["petDisplayType"]="소환수 표시 형식"
L["petDisplayTypedesc"]="소환수를 표시할 방식을 설정합니다."
L["petDisplay4"]="소환수 프레임 높이"
L["petDisplay5"]="소환수 프레임의 높이를 설정합니다."
L["petDisplay6"]="기준점"
L["petDisplay7"]="소환수들의 배치가 시작될 기준점을 설정합니다."
L["petDisplay8"]="소환수 한줄 수"
L["petDisplay9"]="한줄에 표시될 소환수 수를 설정합니다."
L["petDisplay10"]="세로 방향"
L["petDisplay11"]="가로 방향"
L["petDisplay12"]="배치 방향"
L["petDisplay13"]="소환수가 배치될 방향을 설정합니다."
L["petDisplay14"]="크기"
L["petDisplay15"]="소환수 프레임의 크기를 설정합니다."




L["주문 타이머 동적 표시"] = "주문 타이머 동적 표시"
L["주문 타이머 동적 표시desc"] = "주문 타이머와 약화 효과의 점점 커지는 연출을 활성화 합니다."
L["주문 타이머 주기"] = "동적 애니메이션 업데이트 주기(0.01초)"
L["주문 타이머 주기desc"]="단위가 짧을 수록 부드럽게 표현되나 성능에 영향을 미칠 수 있습니다."
L["주문 타이머 폰트 겹치기"] = "주문 타이머 폰트 겹치기"
L["주문 타이머 폰트 겹치기desc"]="주문 타이머의 아이콘과 타이머 폰트의 위치를 겹치게 합니다."
L["주문 타이머 폰트 색상"]="폰트 색상"
L["주문 타이머 폰트 색상desc"]="주문타이머의 폰트 색상을 지정합니다."
L["주문 타이머 폰트 색상_타인"]="폰트 색상(타인)"
L["주문 타이머 폰트 색상_타인desc"]="타인이 시전한 주문타이머의 폰트 색상을 지정합니다."
L["주문 타이머 중첩 색상"]="중첩 횟수 색상"
L["주문 타이머 중첩 색상desc"]="주문타이머의 스킬중첩 색상을 지정합니다. 폰트 겹치기 사용시 남은 시간과 중첩을 구별하는데 용이합니다."
L["방어전담 프레임"]="방어전담 프레임 표시"
L["방어전담 프레임desc"]= "방어전담으로 지정한 플레이어들을 별도 프레임에 표시합니다."
L["외부 라이브러리"]="외부 라이브러리 : 사용자 환경에 따라 게임 성능에 영향을 미칠 수 있습니다."
L["CombatLogHealthdesc"]="기본 블리자드 이벤트 이외에 전투로그를 반영하여 실시간 체력수치를 적용합니다.CPU사용량이 증가합니다."
L["HealComm"]="Heal Comm(예측힐)"
L["HealCommdesc"]="기본 블리자드 함수 대신 외부 라이브러리를 사용합니다. 더 정확한 예상힐량 및 HoT정보를 제공합니다."

L["클릭 캐스팅 사용"]="클릭 캐스팅 사용"
L["클릭 캐스팅 사용desc"]="클릭 캐스트 사용여부를 지정합니다."
L["클릭"] ="클릭"
L["Alt + 클릭"] ="Alt + 클릭"
L["Ctrl + 클릭"] ="Ctrl + 클릭"
L["Shift + 클릭"] ="Shift + 클릭"
L["Alt + Ctrl + 클릭"] ="Alt + Ctrl + 클릭"
L["Alt + Shift + 클릭"] ="Alt + Shift + 클릭"
L["Ctrl + Shift + 클릭"] = "Ctrl + Shift + 클릭"
L["픽셀"] = "픽셀"

L["Survival_속도"] ="속도"
L["Survival_마폭"] ="마폭"
L["Survival_석화"] ="석화"
L["Survival_의지"] ="의지"
L["Survival_가속"] ="가속"
L["Survival_파괴"]="파괴"
L["Survival_영웅"] ="영웅"
L["Survival_씨앗"] ="씨앗"
L["Survival_하투"] ="하투"
L["Survival_은폐"] ="은폐"
L["달라란의 지능"] = "달라란의 지능"
L["달라란의 총명함"] = "달라란의 총명함"


