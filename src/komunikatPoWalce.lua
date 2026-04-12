local TEXT = script.parent:FindChildByName("UIText")

local messages = {
    "Dynie zdobyte, teraz czas je ugotować",
    "Do kuchni!"
}

local delay = 2.5

function ShowMessages()
    for _, msg in ipairs(messages) do
        TEXT.text = msg
        Task.Wait(delay)
    end

    TEXT.text = "" 
end

Events.Connect("ShowMessagesEvent", ShowMessages)
