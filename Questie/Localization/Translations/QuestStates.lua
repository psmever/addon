---@type l10n
local l10n = QuestieLoader:ImportModule("l10n")

local questStateLocales = {
    ["Complete"] = {
        ["ptBR"] = "Concluída",
        ["ruRU"] = "Выполнено",
        ["deDE"] = "Abgeschlossen",
        ["koKR"] = "성공",
        ["esMX"] = "Completa",
        ["enUS"] = true,
        ["zhCN"] = "完成",
        ["zhTW"] = "完成",
        ["esES"] = "Completa",
        ["frFR"] = "Terminée",
    },
    ["Failed"] = {
        ["ptBR"] = "Fracassada",
        ["ruRU"] = "Провалено",
        ["deDE"] = "Fehlgeschlagen",
        ["koKR"] = "실패",
        ["esMX"] = "Fracasado",
        ["enUS"] = true,
        ["zhCN"] = "失败",
        ["zhTW"] = "失敗",
        ["esES"] = "Fracasado",
        ["frFR"] = "Échouée",
    },
    ["Available"] = {
        ["ptBR"] = "Disponível",
        ["ruRU"] = "Доступно",
        ["deDE"] = "Verfügbar",
        ["koKR"] = "수행가능",
        ["esMX"] = "Disponible",
        ["enUS"] = true,
        ["zhCN"] = "可接",
        ["zhTW"] = "可接",
        ["esES"] = "Disponible",
        ["frFR"] = "Disponible",
    },
    ["Active"] = {
        ["ptBR"] = "Ativa",
        ["ruRU"] = "Активно",
        ["deDE"] = "Aktiv",
        ["koKR"] = "활성화",
        ["esMX"] = "Activa",
        ["enUS"] = true,
        ["zhCN"] = "已有",
        ["zhTW"] = "已有",
        ["esES"] = "Activa",
        ["frFR"] = "Activée",
    },
    ["Event"] = {
        ["ptBR"] = "Evento",
        ["ruRU"] = "Игровое событие",
        ["deDE"] = "Event",
        ["koKR"] = "이벤트",
        ["esMX"] = "Evento",
        ["enUS"] = true,
        ["zhCN"] = "事件",
        ["zhTW"] = "事件",
        ["esES"] = "Evento",
        ["frFR"] = "Évènement",
    },
    ["Repeatable"] = {
        ["ptBR"] = "Repetível",
        ["ruRU"] = "Повторяемое",
        ["deDE"] = "Wiederholbar",
        ["koKR"] = "반복가능",
        ["esMX"] = "Repetible",
        ["enUS"] = true,
        ["zhCN"] = "可重复",
        ["zhTW"] = "可重複",
        ["esES"] = "Repetible",
        ["frFR"] = "Répétable",
    },
    ["PvP"] = {
        ["ptBR"] = false,
        ["ruRU"] = true,
        ["deDE"] = false,
        ["koKR"] = false,
        ["esMX"] = false,
        ["enUS"] = true,
        ["zhCN"] = true,
        ["zhTW"] = true,
        ["esES"] = false,
        ["frFR"] = false,
    },
}

for k, v in pairs(questStateLocales) do
    l10n.translations[k] = v
end
