local DOOR = script:GetCustomProperty("Door"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()

local closedRotation = DOOR:GetRotation()
local openRotation = closedRotation + Rotation.New(0, 0, 90)

local isOpen = false

local function OpenDoor()
    if isOpen then return end
    isOpen = true
    DOOR:RotateTo(openRotation, 0.4, true)
end

local function CloseDoor()
    if not isOpen then return end
    isOpen = false
    DOOR:RotateTo(closedRotation, 0.4, true)
end

TRIGGER.beginOverlapEvent:Connect(function(trigger, other)
    if other:IsA("Player") then
        OpenDoor()
    end
end)

TRIGGER.endOverlapEvent:Connect(function(trigger, other)
    if other:IsA("Player") then
        CloseDoor()
    end
end)