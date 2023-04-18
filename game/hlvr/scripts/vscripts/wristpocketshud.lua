require "storage"
local class = thisEntity:GetClassname()

-- update wrist pockets slots on HUD
if class == "game_text" then
	local pocketSlot1Msg = "[ ]"
	local pocketSlot2Msg = "[ ]"
	local player = Entities:GetLocalPlayer()
	local itemsStrings = { "[z] He", "[x] Gr", "[c] Ba", "[c] It", "[c] Vi"  } -- starts from 1
	local itemsUniqueStrings = { "[c] Vo", "[a] Aa"  }
	local slot1ItemId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
	local slot2ItemId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
	if slot1ItemId ~= 0 then
		if slot1ItemId == 4 and Storage:LoadString("pocketslots_slot1_objmodel") == "models/props/distillery/bottle_vodka.vmdl" then
			pocketSlot1Msg = itemsUniqueStrings[1]
		else
			pocketSlot1Msg = itemsStrings[slot1ItemId]
		end
	end
	if slot2ItemId ~= 0 then
		if slot2ItemId == 4 and Storage:LoadString("pocketslots_slot2_objmodel") == "models/props/distillery/bottle_vodka.vmdl" then
			pocketSlot2Msg = itemsUniqueStrings[1]
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
