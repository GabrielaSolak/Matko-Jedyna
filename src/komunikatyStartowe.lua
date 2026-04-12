local TEXT = script.parent:FindChildByName("StartText")


local messages = {
	"Witaj w grze",
    "To był spokojny dzień.. aż nagle..",
    "Dzwoni telefon...",
    "TO TEŚCIOWA",
    "Trzeba ją dobrze ugościć..",
    "Posprzątać dom, ugotować obiad",
    "Ale najpierw... zupa dyniowa",
    "Zostało mało czasu",
    "MATKO JEDYNA!",
    "",
    "Trzeba znalźć dynie na obiad.."
}

local delay = 2.5

function ShowMessages()
    for i, msg in ipairs(messages) do
        TEXT.text = msg
        Task.Wait(delay)
    end

    TEXT.text = "" -- znika na końcu
end

ShowMessages()