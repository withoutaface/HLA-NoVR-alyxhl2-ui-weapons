require "storage"
local name = thisEntity:GetName()

-- update wrist pockets slots on HUD
if name == "text_pocketslots" then
	local pocketSlot1Msg = "[ ]"
	local pocketSlot2Msg = "[ ]"
	local player = Entities:GetLocalPlayer()
	local itemsStrings = { "[z] He", "[x] Gr", "[c] Ba", "[c] It", "[c] Vi"  } -- starts from 1
	local itemsUniqueStrings = { "[c] Vo", "[c] Ca"  }
	local slot1ItemId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
	local slot2ItemId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
	if slot1ItemId ~= 0 then
		if slot1ItemId == 4 then
			if Storage:LoadString("pocketslots_slot1_objmodel") == "models/props/distillery/bottle_vodka.vmdl" then
				pocketSlot1Msg = itemsUniqueStrings[1]
			elseif Storage:LoadString("pocketslots_slot1_objmodel") == "models/props/misc/keycard_001.vmdl" then
				pocketSlot1Msg = itemsUniqueStrings[2]
			end
		else
			pocketSlot1Msg = itemsStrings[slot1ItemId]
		end
	end
	if slot2ItemId ~= 0 then
		if slot2ItemId == 4 then
			if Storage:LoadString("pocketslots_slot2_objmodel") == "models/props/distillery/bottle_vodka.vmdl" then
				pocketSlot2Msg = itemsUniqueStrings[1]
			elseif Storage:LoadString("pocketslots_slot2_objmodel") == "models/props/misc/keycard_001.vmdl" then
				pocketSlot2Msg = itemsUniqueStrings[2]
			end
		else
			pocketSlot2Msg = itemsStrings[slot2ItemId]
		end
	end
	if slot1ItemId == 0 and slot2ItemId == 0 then -- hide text
		DoEntFireByInstanceHandle(thisEntity, "SetText", " ", 0, nil, nil)
	else
		DoEntFireByInstanceHandle(thisEntity, "SetText", "" .. pocketSlot2Msg .. "\n" .. pocketSlot1Msg .. "", 0, nil, nil)
	end
	DoEntFireByInstanceHandle(thisEntity, "Display", "", 0, nil, nil)
end

-- show empty fake slots
if name == "text_pocketslots_empty" then
	local pocketSlotNullMsg = "[ ]"
	DoEntFireByInstanceHandle(thisEntity, "SetText", "" .. pocketSlotNullMsg .. "\n" .. pocketSlotNullMsg .. "", 0, nil, nil)
	DoEntFireByInstanceHandle(thisEntity, "Display", "", 0, nil, nil)
end