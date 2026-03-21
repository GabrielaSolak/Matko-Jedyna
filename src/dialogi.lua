local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local PANEL = script:GetCustomProperty("DialogPanel"):WaitForObject()
local NPC_TEXT = script:GetCustomProperty("NpcText"):WaitForObject()
local BUTTON_A = script:GetCustomProperty("ButtonA"):WaitForObject()
local BUTTON_B = script:GetCustomProperty("ButtonB"):WaitForObject()
local BUTTON_A_TEXT = script:GetCustomProperty("ButtonAText"):WaitForObject()
local BUTTON_B_TEXT = script:GetCustomProperty("ButtonBText"):WaitForObject()
local TALK_HINT = script:GetCustomProperty("TalkHint"):WaitForObject()

local LOCAL_PLAYER = Game.GetLocalPlayer()
local currentNode = "start"
local playerInRange = false
local dialogOpen = false

local OPEN_ACTION = "Interact"
local CLOSE_ACTION = "CloseDialog"

local dialog = {
    start = {
        text = "Matka: Córeczko, gdzie byłaś tak długo?",
        aText = "Córka: Spacerowałam przy rzece.",
        bText = "Córka: Spotkałam przyjaciół.",
        aNext = "river",
        bNext = "friends"
    },

    river = {
        text = "Matka: Przy rzece? Sama?",
        aText = "Córka: Tak, chciałam pobyć sama.",
        bText = "Córka: Nie, był tam pies sąsiadów.",
        aNext = "alone",
        bNext = "dog"
    },

    friends = {
        text = "Matka: Mam nadzieję, że byli grzeczni.",
        aText = "Córka: Tak mamo, tylko rozmawialiśmy.",
        bText = "Córka: Trochę się wygłupialiśmy.",
        aNext = "finish",
        bNext = "finish"
    },

    alone = {
        text = "Matka: Rozumiem. Każdy czasem potrzebuje ciszy.",
        aText = "Córka: Dziękuję mamo.",
        bText = "",
        aNext = "finish",
        bNext = nil
    },

    dog = {
        text = "Matka: To pewnie Bruno. On jest bardzo miły.",
        aText = "Córka: Tak, chwilę się z nim bawiłam.",
        bText = "",
        aNext = "finish",
        bNext = nil
    },

    finish = {
        text = "Matka: Dobrze, chodź już do domu. Kolacja prawie gotowa.",
        aText = "Córka: Już idę!",
        bText = "",
        aNext = nil,
        bNext = nil
    }
}

local function LockPlayer()
    UI.SetCursorVisible(true)
    UI.SetCanCursorInteractWithUI(true)
end

local function UnlockPlayer()
    UI.SetCursorVisible(false)
    UI.SetCanCursorInteractWithUI(false)
end

local function HideDialog()
    dialogOpen = false
    PANEL.visibility = Visibility.FORCE_OFF
    UnlockPlayer()

    if playerInRange then
        TALK_HINT.visibility = Visibility.INHERIT
    else
        TALK_HINT.visibility = Visibility.FORCE_OFF
    end
end

local function ShowNode(nodeName)
    currentNode = nodeName
    local node = dialog[nodeName]

    if not node then
        HideDialog()
        return
    end

    dialogOpen = true
    PANEL.visibility = Visibility.INHERIT
    NPC_TEXT.text = node.text
    BUTTON_A_TEXT.text = node.aText or ""
    BUTTON_B_TEXT.text = node.bText or ""

    BUTTON_A.visibility = Visibility.INHERIT

    if node.bText == nil or node.bText == "" then
        BUTTON_B.visibility = Visibility.FORCE_OFF
    else
        BUTTON_B.visibility = Visibility.INHERIT
    end

    TALK_HINT.visibility = Visibility.FORCE_OFF
    LockPlayer()
end

BUTTON_A.clickedEvent:Connect(function()
    if not dialogOpen then return end
    local node = dialog[currentNode]
    if not node then return end

    if node.aNext then
        ShowNode(node.aNext)
    else
        HideDialog()
    end
end)

BUTTON_B.clickedEvent:Connect(function()
    if not dialogOpen then return end
    local node = dialog[currentNode]
    if not node then return end

    if node.bNext then
        ShowNode(node.bNext)
    else
        HideDialog()
    end
end)

TRIGGER.beginOverlapEvent:Connect(function(trigger, other)
    if other == LOCAL_PLAYER then
        playerInRange = true
        if not dialogOpen then
            TALK_HINT.visibility = Visibility.INHERIT
        end
    end
end)

TRIGGER.endOverlapEvent:Connect(function(trigger, other)
    if other == LOCAL_PLAYER then
        playerInRange = false
        TALK_HINT.visibility = Visibility.FORCE_OFF
        HideDialog()
    end
end)

Input.actionPressedEvent:Connect(function(player, actionName)
    if player ~= LOCAL_PLAYER then return end

    if actionName == OPEN_ACTION and playerInRange and not dialogOpen then
        ShowNode("start")
    elseif actionName == CLOSE_ACTION and dialogOpen then
        HideDialog()
    end
end)

PANEL.visibility = Visibility.FORCE_OFF
TALK_HINT.visibility = Visibility.FORCE_OFF
UI.SetCursorVisible(false)
UI.SetCanCursorInteractWithUI(false)