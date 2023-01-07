--[[

    TacoTip Localization: ruRU

    Translators:

      - Iowerth (https://github.com/Iowerth)

--]]

if (GetLocale() ~= "ruRU") then return end
TACOTIP_LOCALE = {
["Player"] = "Игрок",
["Pet"] = "Питомец",
["Target"] = "Цель",
["None"] = "Нет",
["Self"] = "Игрок взял в цель себя",
["You"] = "Вы",
["Talents"] = "Таланты",
["Style"] = "Стиль",
["Guild"] = "Гильдия",
["Rank"] = "Звание",
["Level"] = "Уровень",
["Item Level"] = "iLvl\:",
["Left-Click"] = "ЛКМ",
["Middle-Click"] = "СКМ",
["Right-Click"] = "ПКМ",
["Drag to Move"] = "Перетащить для перемещения",
["Change Anchor"] = "Изменить точку прикрепления",
["Save Position"] = "Сохранить позицию",
[" the Kingslayer"] = ", свергнувший Короля",
["Undead"] = "Нежить",
["Unit Tooltips"] = "Всплывающая подсказка",
["Class Color"] = "Цвет класса",
["Color class names in tooltips"] = "Окрашивать имя игрока цветом класса во всплывающей подсказке",
["Title"] = "Звание игрока",
["Show player's title in tooltips"] = "Отображать звание игрока во всплывающей подсказке",
["Guild Name"] = "Гильдия",
["Show guild name in tooltips"] = "Отображать название гильдии во всплывающей подсказке",
["Guild Rank"] = "Звание",
["Show guild rank in tooltips"] = "Отображать гильдейское звание во всплывающей подсказке",
["Show talents and specialization in tooltips"] = "Отображать таланты и специализацию во всплывающей подсказке",
["Show player's GearScore in tooltips"] = "Отображать GearScore (очки экипировки) и средний iLvl (уровень экипировки) игрока во всплывающей подсказке",
["Show player's PawnScore in tooltips (may affect performance)"] = "Отображать PawnScore (очки экипировки аддона Pawn) игрока. Может влиять на производительность",
["requires Pawn"] = "нужен Pawn",
["Show unit's target in tooltips"] = "Отображать цель во всплывающей подсказке",
["Faction Icon"] = "Значок фракции",
["Show player's faction icon (Horde/Alliance) in tooltips"] = "Отображать значок фракции (Альянс/Орда) во всплывающей подсказке",
["PVP Icon"] = "Значок PVP",
["Show player's pvp flag status as icon instead of text"] = "Отображать PVP-статус значком вместо текста во всплывающей подсказке",
["Health Bar"] = "Полоса здоровья",
["Show unit's health bar under tooltip"] = "Отображать полосу здоровья под всплывающей подсказкой",
["Power Bar"] = "Полоса ресурса",
["Show unit's power bar under tooltip"] = "Отображать полосу ресурса под всплывающей подсказкой",
["Character Frame"] = "Окно персонажа",
["Show GearScore in character frame"] = "Отображать GearScore (очки экипировки) в окне персонажа",
["Average iLvl"] = "Средний iLvl",
["Show Average Item Level in character frame"] = "Отображать средний iLvl (уровень экипировки) в окне персонажа",
["Lock Position"] = "Блокировка",
["Lock GearScore and Average Item Level positions in character frame"] = "Заблокировать позиции GearScore (очки экипировки) и среднего iLvl (уровень экипировки) в окне персонажа",
["Extra"] = "Дополнительно",
["Show Item Level"] = "iLvl предмета",
["Display item level in the tooltip for certain items."] = "Отображать iLvl (уровень предмета) во всплывающей подсказке",
["Show Item GearScore"] = "GearScore предмета",
["Show GearScore in item tooltips"] = "Отображать GearScore (очки экипировки) предмета во всплывающей подсказке",
["Enhanced Tooltips"] = "Расширенные подсказки",
["Disable In Combat"] = "Выключить в бою",
["Disable gearscore & talents in combat"] = "Выключить отображение GearScore (очки экипировки) и талантов в бою",
["Chat Class Colors"] = "Цвета в чате",
["Color names by class in chat windows"] = "Окрашивать имена игроков цветом класса в чатах",
["Instant Fade"] = "Мгновенное затухание",
["Fade out unit tooltips instantly"] = "Мгновенное затухание всплывающей подсказки при убирании курсора",
["Custom Tooltip Position"] = "Позиционирование",
["Set a custom position for tooltips"] = "Установить позицию всплывающей подсказки вручную",
["Tooltip Style"] = "Стиль подсказки",
["FULL"] = "ПОЛНЫЙ",
["Always FULL"] = "Всегда ПОЛНЫЙ",
["COMPACT/FULL"] = "КОМПАКТ/ПОЛНЫЙ",
["Default COMPACT, hold SHIFT for FULL"] = "По умолчанию КОМПАКТ, зажмите Shift для ПОЛНЫЙ",
["COMPACT"] = "КОМПАКТ",
["Always COMPACT"] = "Всегда КОМПАКТ",
["MINI/FULL"] = "МИНИ/ПОЛНЫЙ",
["Default MINI, hold SHIFT for FULL"] = "По умолчанию МИНИ, зажмите Shift для ПОЛНЫЙ",
["MINI"] = "МИНИ",
["Always MINI"] = "Всегда МИНИ",
["Wide, Dual Spec, GearScore, Average iLvl"] = "Широкий, двойная спец., GS, средний iLvl",
["Narrow, Active Spec, GearScore"] = "Узкий, текущая спец., GS",
["Narrow, Active Spec, GearScore, Average iLvl"] = "Узкий, текущая спец., GS, средний iLvl",
["Reset configuration"] = "Сброс настроек",
["Configuration has been reset to default."] = "Настройки сброшены на значения по умолчанию.",
["Custom tooltip position enabled."] = "Ручное позиционирование включено.",
["Custom tooltip position disabled."] = "Ручное позиционирование выключено.",
["Custom position anchor set"] = "Точка прикрепления установлена",
["Anchor to Mouse"] = "Прикрепление к курсору",
["Anchor tooltips to mouse cursor"] = "Прикрепить всплывающую подсказку (игрок/NPC/объект) к курсору мыши",
["Only in WorldFrame"] = "Только вне группы/рейда",
["Anchor to mouse only in WorldFrame\nSkips raid / party frames"] = "Прикреплять всплывающую подсказку к курсору только вне группы или рейда",
["Anchor Spells to Mouse"] = "Прикрепление на панели",
["Anchor spell tooltips to mouse cursor"] = "Прикрепить всплывающую подсказку описания заклинаний и способностей на панели команд к курсору мыши",
["Show Achievement Points"] = "Очки достижений",
["Show total achievement points in tooltips"] = "Отображать количество очков достижений игрока во всплывающей подсказке",
["Mover"] = "Двигать",
["TEXT_OPT_DESC"] = "Улучшенные всплывающие подсказки об игроках:\nцвета классов, таланты и специализации,\nGearScore (GS/гирскор/очки экипировки), звания",
["TEXT_OPT_UBERTIPS"] = "Отображать расширенную информацию (описание заклинаний и способностей) во всплывающей подсказке",
["TEXT_HELP_MOVER_SHOWN"] = "Перетащите желтую точку для изменения позиции всплывающей подсказки. СКМ (средняя копка мыши) - изменить точку прикрепления. ПКМ (правая кнопка мыши) - сохранить позицию.",
["TEXT_HELP_MOVER_SAVED"] = "Вручную выставленная позиция сохранена. Наберите '/tacotip custom' для нового выставления позиции.",
["TEXT_HELP_ANCHOR"] = "Использование: /tacotip anchor ПРИКРЕПЛЕНИЕ. Значения для ПРИКРЕПЛЕНИЕ - TOPLEFT/TOPRIGHT/BOTTOMLEFT/BOTTOMRIGHT/CENTER - верхний левый/верхний правый/нижний левый/нижний правый/центр.",
["TEXT_HELP_WELCOME"] = "загружен (автор - kebabstorm). Путешествуйте безопасно!",
["TEXT_HELP_FIRST_LOGIN"] = "Наберите '/tacotip' для опций.",
["TEXT_DLG_CUSTOM_POS_CONFIRM"] = "\nВы хотите сохранить вручную выставленную позицию или сбросить на значение по умолчанию?\n\n",
["FORMAT_GUILD_RANK_1"] = "%s <%s>",
["CHARACTER_FRAME_GS_TITLE_FONT"] = "Fonts\\FRIZQT__.TTF",
["CHARACTER_FRAME_GS_TITLE_FONT_SIZE"] = 10,
["CHARACTER_FRAME_GS_TITLE_XPOS"] = 72,
["CHARACTER_FRAME_GS_TITLE_YPOS"] = 248,
["CHARACTER_FRAME_GS_VALUE_FONT"] = "Fonts\\FRIZQT__.TTF",
["CHARACTER_FRAME_GS_VALUE_FONT_SIZE"] = 10,
["CHARACTER_FRAME_GS_VALUE_XPOS"] = 72,
["CHARACTER_FRAME_GS_VALUE_YPOS"] = 260,
["CHARACTER_FRAME_ILVL_TITLE_FONT"] = "Fonts\\FRIZQT__.TTF",
["CHARACTER_FRAME_ILVL_TITLE_FONT_SIZE"] = 10,
["CHARACTER_FRAME_ILVL_TITLE_XPOS"] = 270,
["CHARACTER_FRAME_ILVL_TITLE_YPOS"] = 248,
["CHARACTER_FRAME_ILVL_VALUE_FONT"] = "Fonts\\FRIZQT__.TTF",
["CHARACTER_FRAME_ILVL_VALUE_FONT_SIZE"] = 10,
["CHARACTER_FRAME_ILVL_VALUE_XPOS"] = 270,
["CHARACTER_FRAME_ILVL_VALUE_YPOS"] = 260,
["INSPECT_FRAME_GS_TITLE_FONT"] = "Fonts\\FRIZQT__.TTF",
["INSPECT_FRAME_GS_TITLE_FONT_SIZE"] = 10,
["INSPECT_FRAME_GS_TITLE_XPOS"] = 72,
["INSPECT_FRAME_GS_TITLE_YPOS"] = 141,
["INSPECT_FRAME_GS_VALUE_FONT"] = "Fonts\\FRIZQT__.TTF",
["INSPECT_FRAME_GS_VALUE_FONT_SIZE"] = 10,
["INSPECT_FRAME_GS_VALUE_XPOS"] = 72,
["INSPECT_FRAME_GS_VALUE_YPOS"] = 153,
["INSPECT_FRAME_ILVL_TITLE_FONT"] = "Fonts\\FRIZQT__.TTF",
["INSPECT_FRAME_ILVL_TITLE_FONT_SIZE"] = 10,
["INSPECT_FRAME_ILVL_TITLE_XPOS"] = 270,
["INSPECT_FRAME_ILVL_TITLE_YPOS"] = 141,
["INSPECT_FRAME_ILVL_VALUE_FONT"] = "Fonts\\FRIZQT__.TTF",
["INSPECT_FRAME_ILVL_VALUE_FONT_SIZE"] = 10,
["INSPECT_FRAME_ILVL_VALUE_XPOS"] = 270,
["INSPECT_FRAME_ILVL_VALUE_YPOS"] = 153,
}