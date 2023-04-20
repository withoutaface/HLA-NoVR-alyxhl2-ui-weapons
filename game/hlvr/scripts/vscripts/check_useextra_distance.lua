require "storage"

local class = thisEntity:GetClassname()
local player = Entities:GetLocalPlayer()
local startVector = player:EyePosition()
local eyetrace =
{
    startpos = startVector;
    endpos = startVector + RotatePosition(Vector(0,0,0), player:GetAngles(), Vector(60,0,0));
    ignore = player;
    mask =  33636363
}
TraceLine(eyetrace)

if thisEntity:Attribute_GetIntValue("picked_up", 0) == 0 then
    local ignore_props = {
        "models/props/hazmat/hazmat_crate_lid.vmdl",
        "models/props/electric_box_door_1_32_48_front.vmdl",
        "models/props/electric_box_door_1_32_96_front.vmdl",
        "models/props/electric_box_door_2_32_48_front.vmdl",
        "models/props/interactive/washing_machine01a_door.vmdl",
        "models/props/fridge_1a_door.vmdl",
        "models/props/fridge_1a_door2.vmdl",
        "models/props_c17/mailbox_01/mailbox_02_door_a.vmdl",
        "models/props_c17/mailbox_01/mailbox_02_door_b.vmdl",
        "models/props_c17/mailbox_01/mailbox_02_door_d.vmdl",
        "models/props_c17/mailbox_01/mailbox_01_door.vmdl",
        "models/props/interactive/dumpster01a_lid.vmdl",
        "models/props/construction/portapotty_toilet_seat.vmdl",
        "models/props/interactive/file_cabinet_a_interactive_drawer_1.vmdl",
        "models/props/interactive/file_cabinet_a_interactive_drawer_2.vmdl",
        "models/props/interactive/file_cabinet_a_interactive_drawer_3.vmdl",
        "models/props/interactive/file_cabinet_a_interactive_drawer_4.vmdl",
        "models/props/interior_furniture/interior_locker_001_door_a.vmdl",
        "models/props/interior_furniture/interior_locker_001_door_b.vmdl",
        "models/props/interior_furniture/interior_locker_001_door_c.vmdl",
        "models/props/interior_furniture/interior_locker_001_door_d.vmdl",
        "models/props/interior_furniture/interior_locker_001_door_e.vmdl",
    }
    if eyetrace.hit or thisEntity:GetName() == "ChoreoPhysProxy" then
        DoEntFireByInstanceHandle(thisEntity, "RunScriptFile", "useextra", 0, nil, nil)
    elseif vlua.find(ignore_props, thisEntity:GetModelName()) == nil and player:Attribute_GetIntValue("gravity_gloves", 0) == 1 and (class == "prop_physics" or class == "item_hlvr_health_station_vial" or class == "item_hlvr_grenade_frag" or class == "item_item_crate" or class == "item_healthvial" or class == "item_hlvr_crafting_currency_small" or class == "item_hlvr_crafting_currency_large" or class == "item_hlvr_clip_shotgun_single" or class == "item_hlvr_clip_shotgun_multiple" or class == "item_hlvr_clip_rapidfire" or class == "item_hlvr_clip_energygun_multiple" or class == "item_hlvr_clip_energygun" or class == "item_hlvr_grenade_xen" or class == "item_hlvr_prop_battery") and (thisEntity:GetMass() <= 15 or class == "item_hlvr_prop_battery") then
        local grabbity_glove_catch_params = { ["userid"]=player:GetUserID() }
        FireGameEvent("grabbity_glove_catch", grabbity_glove_catch_params)
        local direction = startVector - thisEntity:GetAbsOrigin()
        thisEntity:ApplyAbsVelocityImpulse(Vector(direction.x * 2, direction.y * 2, Clamp(direction.z * 3.8, -400, 400)))
        StartSoundEventFromPosition("Grabbity.HoverPing", startVector)
        StartSoundEventFromPosition("Grabbity.Grab", startVector)
        local delay = 0.35
        if VectorDistance(startVector, thisEntity:GetAbsOrigin()) > 350 then
            delay = 0.45
        end
        thisEntity:SetThink(function()
			local pickupItem = true
            local ents = Entities:FindAllInSphere(Entities:GetLocalPlayer():EyePosition(), 120)
            if vlua.find(ents, thisEntity) then
				-- fake wrist pockets for quest items
				if class == "item_hlvr_prop_battery" or thisEntity:GetModelName() == "models/props/misc/keycard_001.vmdl" or thisEntity:GetModelName() == "models/props/distillery/bottle_vodka.vmdl" or class == "item_hlvr_health_station_vial" then
					local itemId = 0
					if class == "item_hlvr_prop_battery" then
						itemId = 3
					elseif class == "prop_physics" then -- generic quest item
						itemId = 4
					elseif class == "item_hlvr_health_station_vial" then
						itemId = 5 -- valuable item, but usually without ent name
					end
					local pocketSlotId = 0
					if player:Attribute_GetIntValue("pocketslots_slot1", 0) == 0 then
						pocketSlotId = 1
					elseif player:Attribute_GetIntValue("pocketslots_slot2", 0) == 0 then
						pocketSlotId = 2
					end
					
					if pocketSlotId ~= 0 and itemId ~= 0 then
						pickupItem = false
						local keepItemInstance = true
						local keepAcrossMaps = false -- save item for later maps, always new instance
						if thisEntity:GetName() == "" then
							keepItemInstance = false -- can't do much with no-name entities
						end
						if thisEntity:GetModelName() == "models/props/distillery/bottle_vodka.vmdl" then
							keepItemInstance = false
							keepAcrossMaps = true
						end
						
						player:Attribute_SetIntValue("pocketslots_slot" .. pocketSlotId .. "", itemId)
						Storage:SaveString("pocketslots_slot" .. pocketSlotId .. "_objname", thisEntity:GetName())
						Storage:SaveString("pocketslots_slot" .. pocketSlotId .. "_objmodel", thisEntity:GetModelName())
						if keepItemInstance then
							thisEntity:DisableMotion() -- put valuable original item very far away, solution by FrostEpex
							thisEntity:SetOrigin(Vector(-15000,-15000,-15000))		
						else
							thisEntity:Kill() -- destroy original instance
						end
						Storage:SaveBoolean("pocketslots_slot" .. pocketSlotId .. "_keepacrossmaps", keepAcrossMaps)
						
						FireGameEvent("item_pickup", item_pickup_params)
						StartSoundEventFromPosition("Inventory.WristPocketGrabItem", player:EyePosition())
						print("[WristPockets] Item ID " .. itemId .. " acquired on slot #" .. pocketSlotId .. ".")
						DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
					end
				end
				if pickupItem then -- regular pickup action
					DoEntFireByInstanceHandle(thisEntity, "Use", "", 0, player, player)
				end
                if class == "item_hlvr_grenade_frag" then -- TODO can't pickup for some reason
                    DoEntFireByInstanceHandle(thisEntity, "RunScriptFile", "useextra", 0, player, player)
				end
            end
        end, "GrabItem", delay)
    end
end
