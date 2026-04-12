local trigger = script.parent:FindChildByType("Trigger")

function OnBeginOverlap(trigger, other)
    if not other:IsA("Player") then return end

    local weapon = other.serverUserData.currentWeapon or other.serverUserData.weapon
    if weapon and weapon.Unequip then
        weapon:Unequip()
    end

    for _, equipment in ipairs(other:GetEquipment()) do
        if equipment.Unequip then
            equipment:Unequip()
        end

        if equipment.visibility ~= nil then
            equipment.visibility = Visibility.FORCE_OFF
        end

        for _, child in ipairs(equipment:GetChildren()) do
            if child.visibility ~= nil then
                child.visibility = Visibility.FORCE_OFF
            end
        end
    end

    Events.BroadcastToPlayer(other, "ShowMessagesEvent")
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)
