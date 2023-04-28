-- Mod support, by Hypercycle
-- Note: scripting style is copied from early NoVR script and based on millions of if-else

-- TODO implement addon list ids checking?
local addonMaps = {
	-- Extra-Ordinary Value
	"youreawake",
	"seweroutskirts",
	"facilityredux",
	"helloagain",
	-- Levitation
	"01_intro",
	"02_notimelikenow",
	"03_metrodynamo",
	"04_hehungers",
	"05_pleasantville",
	"06_digdeep",
	"07_sectorx",
	"08_burningquestions",
	-- GoldenEye Alyx 007
	"goldeneye64_damver051",
	"goldeneye64dampart2_ver052_master",
	-- Resident Alyx: biohazard
	"lv8-zombies",
	"level_8_zombies_part2",
	"zombies_part_3",
	"zombies_part_4",
	"zombies_part_5",
	"catacombsfinal2",
	"zombies_part_6",
	-- Single good maps
	"mc1_higgue",
	"belomorskaya",
	"red_dust",
	-- Misc
	"back_alley",
	"e3_ship",
	"training_day",
}

local function IsValueInList(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function ModSupport_IsAddonMap(mapName)
	if IsValueInList(addonMaps, mapName) then
		return true
	else
		return false
	end
end

--
-- Addon-specific NoVR-ladders & teleports
--

function ModSupport_CheckForLadderOrTeleport()
	local map = GetMapName()
	local player = Entities:GetLocalPlayer()
	
    --
    -- Addon: Extra-Ordinary Value
	--
    if map == "youreawake" then
        if vlua.find(Entities:FindAllInSphere(Vector(-2953,409,-379), 20), player) then --1
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -2941 388 -145")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-2950,286,-148), 20), player) then --2
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -2981 323 51")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-2958,0,-153), 20), player) then --3
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -2983 19 51")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-3701,160,49), 20), player) then --4
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -3744 161 -152")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-5755,263,-379), 20), player) then -- 5
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -5796 263 -281")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-5867,265,-280), 20), player) then -- 6
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -5812 270 -185")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-5802,254,-185), 20), player) then -- 7
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -5799 202 -34")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-8124,-1080,-145), 20), player) then -- 8
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -8132 -1004 78")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-8128,-45,-5), 20), player) then -- 9
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -8172 -49 169")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-8742,-1596,181), 20), player) then -- 10
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -8757 -1592 -375")
        end
    end
    if map == "seweroutskirts" then
        if vlua.find(Entities:FindAllInSphere(Vector(559,-273,2), 20), player) then -- 1
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 478 -269 163")
        elseif vlua.find(Entities:FindAllInSphere(Vector(2828,-1395,-95), 8), player) then -- 2
            ClimbLadder(42)
        end
    end
    if map == "facilityredux" then
        if vlua.find(Entities:FindAllInSphere(Vector(-1757,-856,323), 20), player) then -- 1
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -1750.5 -883 55")
        end
    end
    if map == "helloagain" then
        if vlua.find(Entities:FindAllInSphere(Vector(430,-1092,-216), 8), player) then -- 1
            ClimbLadder(5)
        end
    end
	--
    -- Addon: Overcharge
	--
    if map == "mc1_higgue" then
        if vlua.find(Entities:FindAllInSphere(Vector(302,856,106), 20), player) then -- 1
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 305 810 170")
        elseif vlua.find(Entities:FindAllInSphere(Vector(302,520,243), 20), player) then -- window
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 341 521 200")
        elseif vlua.find(Entities:FindAllInSphere(Vector(2023,587,-151), 8), player) then -- 2
            ClimbLadder(-80)
        elseif vlua.find(Entities:FindAllInSphere(Vector(-179,-1320,104), 8), player) then -- 3
            ClimbLadder(135)
        elseif vlua.find(Entities:FindAllInSphere(Vector(-299,-1352,192), 8), player) then -- 4
            ClimbLadder(228)
        elseif vlua.find(Entities:FindAllInSphere(Vector(-531,-1374,296), 8), player) then -- 5
            ClimbLadder(331)
        end
    end
	--
    -- Addon: Levitation
	--
    if map == "01_intro" then
        if vlua.find(Entities:FindAllInSphere(Vector(-7617,6622,-3216), 20), player) then -- 1
            ClimbLadder(-3070)
        end
    end
    if map == "03_metrodynamo" then
        if vlua.find(Entities:FindAllInSphere(Vector(-13,-2719,-69), 3), player) then -- 1
            ClimbLadder(-20)
        end
    end
    if map == "04_hehungers" then
        --				if vlua.find(Entities:FindAllInSphere(Vector(44,-3456,-832), 20), player) then -- 1
        --					ClimbLadder(-510)
        if vlua.find(Entities:FindAllInSphere(Vector(86,-3506,-448), 5), player) then -- 2
            ClimbLadder(-380)
        elseif vlua.find(Entities:FindAllInSphere(Vector(109,-3559,-286), 5), player) then -- 3 non-straight ladder
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 67.597 -3547.483 -78")
        end
    end
    if map == "05_pleasantville" then
        if vlua.find(Entities:FindAllInSphere(Vector(905,-698,7790), 5), player) then -- 1
            ClimbLadder(7900)
        elseif vlua.find(Entities:FindAllInSphere(Vector(924,-698,7920), 10), player) then -- 1r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 894.993 -698.078 7740")
        elseif vlua.find(Entities:FindAllInSphere(Vector(613,-990,7756), 10), player) then -- 2 TODO: with lock
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 612.300 -1047.172 7891")
        elseif vlua.find(Entities:FindAllInSphere(Vector(613,-1040,7918), 10), player) then -- 2r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 613.590 -985.104 7705")
        elseif vlua.find(Entities:FindAllInSphere(Vector(672,-797,7964), 20), player) then -- huge jump
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 676.863 -597.481 7918")
        end
    end
    if map == "06_digdeep" then
        if vlua.find(Entities:FindAllInSphere(Vector(-913,1094,137), 8), player) then -- 1
            ClimbLadder(196)
        elseif vlua.find(Entities:FindAllInSphere(Vector(-356,716,664), 8), player) then -- 2r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact -355.712 753.690 415")
        elseif vlua.find(Entities:FindAllInSphere(Vector(-355,741,464), 8), player) then -- 2
            ClimbLadder(655)
        end
    end
    if map == "07_sectorx" then
        if vlua.find(Entities:FindAllInSphere(Vector(-689,255,-236), 8), player) then -- 1
            ClimbLadder(-232)
        end
    end
    if map == "08_burningquestions" then
        if vlua.find(Entities:FindAllInSphere(Vector(158,248,-9128), 8), player) then -- 1
            ClimbLadder(-8982)
        elseif vlua.find(Entities:FindAllInSphere(Vector(158,216,-8960), 10), player) then -- 1r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 159.402 252.582 -9184")
        end
    end
	--
    -- Addon: GoldenEye Alyx 007
	--
    if map == "goldeneye64_damver051" then
        if vlua.find(Entities:FindAllInSphere(Vector(-831,-138,121), 8), player) then -- 1
            ClimbLadder(260)
        end
    end
	--
    -- Addon: Training Day
	--
    if map == "training_day" then
        if vlua.find(Entities:FindAllInSphere(Vector(263,-187,67), 8), player) then -- 1
            ClimbLadder(160)
        end
    end
	--
    -- Addon: Resident Alyx biohazard
	--
    if map == "level_8_zombies_part2" then
        if vlua.find(Entities:FindAllInSphere(Vector(4791,-1756,119), 8), player) then -- 1
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 4764.518 -1756.295 203")
        elseif vlua.find(Entities:FindAllInSphere(Vector(4771,-1755,227), 8), player) then -- 1r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 4794.588 -1755.061 78")
        elseif vlua.find(Entities:FindAllInSphere(Vector(5178,-1974,140), 8), player) then -- 2
            ClimbLadder(250)
        elseif vlua.find(Entities:FindAllInSphere(Vector(5208,-1975,277), 8), player) then -- 2r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 5175.629 -1948.123 70")
        elseif vlua.find(Entities:FindAllInSphere(Vector(5377,-1578,115), 8), player) then -- 3
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 5348.315 -1579.341 -105")
        elseif vlua.find(Entities:FindAllInSphere(Vector(4922,-1385,-67), 8), player) then -- 4
            ClimbLadder(80)
        elseif vlua.find(Entities:FindAllInSphere(Vector(4951,-1384,84), 8), player) then -- 4r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 4915.526 -1385.336 -110")
        end
    end
    if map == "zombies_part_3" then
        if vlua.find(Entities:FindAllInSphere(Vector(4472,242,112), 8), player) then -- 1
            ClimbLadder(235)
        elseif vlua.find(Entities:FindAllInSphere(Vector(4499,241,239), 8), player) then -- 1r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 4453.573 243.033 65")
        end
    end
    if map == "zombies_part_4" then
        if vlua.find(Entities:FindAllInSphere(Vector(2586,-1313,105), 8), player) then -- 1
            ClimbLadder(250)
        elseif vlua.find(Entities:FindAllInSphere(Vector(2573,-1335,262), 8), player) then -- 1r
            ClimbLadderSound()
            SendToConsole("fadein 0.2")
            SendToConsole("setpos_exact 2594.707 -1299.625 50")
        end
    end
end

-- this trick allows to avoid game crash during Main Menu loading, by keeping current loaded addons
local function DoSafeMainMenuTrick()
	SendToConsole("bind " .. MAIN_MENU .. " \"addon_play startup\"")
end

--
-- Addon-specific map bootup scripts
--

function ModSupport_MapBootupScripts(isSaveLoaded)
	local player = Entities:GetLocalPlayer()
	local map = GetMapName()
	DoSafeMainMenuTrick()
	--
	-- Addon: Extra-Ordinary Value
	--
	-- skip map "helloagain"
	if map == "seweroutskirts" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight") -- too dark on some places
		if not isSaveLoaded then -- Start point is bugged here
			SendToConsole("setpos_exact -40 -496 105")
			SendToConsole("ent_create env_message { targetname text_flashlight message FLASHLIGHT }")
		end
		ent = Entities:FindByName(nil, "freds1v")
		ent:RedirectOutput("OnSoundFinished", "ModCommon_ShowFlashlightTutorial", ent)
	elseif map == "facilityredux" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then -- Start point is bugged here
			SendToConsole("setpos_exact -1734 -736 260")
		end
	elseif map == "helloagain" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		ent = Entities:FindByName(nil, "1001_doorfade")
		ent:RedirectOutput("OnBeginFade", "ModCommon_DisablePlayerActions", ent)
	--
	-- Addon: Overcharge
	--
	elseif map == "mc1_higgue" then
		SendToConsole("hl2_sprintspeed 180") -- pass jump on the end
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("r_drawviewmodel 0")
			SendToConsole("hidehud 96")
			SendToConsole("hlvr_addresources 10 0 0 10")
		end
		ent = Entities:FindByName(nil, "fightfinale_end_seqrelay")
		ent:RedirectOutput("OnTrigger", "ModCommon_DisablePlayerActions", ent)
	--
	-- Addon: Belomorskaya Station
	--
	elseif map == "belomorskaya" then
		Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 0)
		ent = Entities:FindByName(nil, "flare_trigger_01")
		if ent then
			ent:RedirectOutput("OnTrigger", "ModBelomorskaya_EquipFlare", ent)
		end
		ent = Entities:FindByName(nil, "flare_turn_off")
		ent:RedirectOutput("OnTrigger", "ModBelomorskaya_RemoveFlare", ent)
		ent = Entities:FindByName(nil, "ending_start")
		ent:RedirectOutput("OnTrigger", "ModCommon_DisablePlayerActions", ent)
	--
	-- Addon: Levitation
	--
	elseif map == "01_intro" then
		SendToConsole("r_drawviewmodel 0")
		SendToConsole("hidehud 96") -- hide hud for intro
		if not isSaveLoaded then
			SendToConsole("ent_fire player_speedmod ModifySpeed 0")
		end
		ent = Entities:FindByName(nil, "vo_alyx0b")
		ent:RedirectOutput("OnSoundFinished", "ModLevitation_AllowMovement", ent)
	elseif map == "02_notimelikenow" then
		if not isSaveLoaded then -- Start point collisions can be bugged here
			SendToConsole("setpos_exact -304.557 331.460 -761")
		end
	-- skip map "03_metrodynamo"
	elseif map == "04_hehungers" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		SendToConsole("ent_create env_message { targetname text_flashlight message FLASHLIGHT }")
		if not isSaveLoaded then -- Start point collisions can be bugged here
			SendToConsole("setpos_exact 0.472 442.295 -100")
			ModLevitation_SpawnWorkaroundBottlesForJeff()
		end
		ent = Entities:FindByName(nil, "introjoke_rus")
		ent:RedirectOutput("OnSoundFinished", "ModCommon_ShowFlashlightTutorial", ent)
		-- TODO: Hand covering mouth script required to be here!
	elseif map == "05_pleasantville" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then -- Start point is bugged here
			SendToConsole("setpos_exact 868.050 -2345.072 7560")
		end
	elseif map == "06_digdeep" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then -- Start point is bugged here
			SendToConsole("setpos_exact 504.324 -3157.083 631")
		end
		ent = Entities:FindByName(nil, "relay_vort_magic")
		ent:RedirectOutput("OnTrigger", "ModLevitation_Map6EndingTransition", ent)
	elseif map == "07_sectorx" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then -- Start point is misplaced
			SendToConsole("setpos_exact 1212.703 -2168.029 -230")
			SendToConsole("ent_create env_message { targetname text_vortenergy message VORTENERGY }")
			ModLevitation_Map7SpawnWorkaroundBattery()
			ModLevitation_Map7SpawnWorkaroundBattery2()
			ModLevitation_Map7SpawnWorkaroundJumpStructure()
		end
		ent = Entities:FindByName(nil, "airlock_ceilingdevices_start")
		if ent then
			ent:RedirectOutput("OnTrigger", "ModLevitation_Map7EnterCombineTrap", ent)
		end
		ent = Entities:FindByName(nil, "airlock_ceilingdevices_stop")
		if ent then
			ent:RedirectOutput("OnTrigger", "GiveVortEnergy", ent)
			ent:RedirectOutput("OnTrigger", "ShowVortEnergyTutorial", ent)
		end
		if not ent then -- vort powers is already given
			GiveVortEnergy()
			ShowVortEnergyTutorial()
		end
		ent = Entities:FindByName(nil, "ending")
		ent:RedirectOutput("OnBeginSequence", "ModLevitation_RemoveVortPowers", ent)
	elseif map == "08_burningquestions" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		SendToConsole("r_drawviewmodel 0")
		if not isSaveLoaded then -- Start point is misplaced
			SendToConsole("setpos_exact -465.745 -540.543 -9209")
			SendToConsole("ent_create env_message { targetname text_vortenergy message VORTENERGY }")
		end
		ent = Entities:FindByName(nil, "end_fight_relay")
		if ent then
			ent:RedirectOutput("OnTrigger", "GiveVortEnergy", ent)
			ent:RedirectOutput("OnTrigger", "ShowVortEnergyTutorial", ent)
		end
		ent2 = Entities:FindByName(nil, "finish_relay")
		if ent2 then
			ent2:RedirectOutput("OnTrigger", "ModLevitation_RemoveVortPowers", ent)
		end
		if not ent and ent2 then -- vort powers is already given
			GiveVortEnergy()
			ShowVortEnergyTutorial()
		end
		ent = Entities:FindByName(nil, "pre_finale_gman")
		ent:RedirectOutput("OnTrigger", "ModLevitation_Map8FinaleStopMove", ent)
	--
	-- Addon: Red Dust
	--
	elseif map == "red_dust" then
		if not isSaveLoaded then
			SendToConsole("give weapon_pistol") -- loadout as map intended
			SendToConsole("give weapon_shotgun")
			SendToConsole("give weapon_smg1")
			SendToConsole("hlvr_addresources 20 60 8 100")
		end
	--
	-- Addon: Back Alley
	--
	elseif map == "back_alley" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("hlvr_addresources 0 0 0 10")
		end
		-- ent_fire 91_cfence_relay_disable trigger
		-- bloodborne_ladder
		-- ladders
		-- ending elevator button
	--
	-- Addon: e3_ship
	--
	elseif map == "e3_ship" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("give weapon_pistol") -- loadout as map intended
			SendToConsole("give weapon_shotgun")
			SendToConsole("give weapon_smg1")
			SendToConsole("hlvr_addresources 20 30 6 10")
		end
	--
	-- Addon: GoldenEye Alyx 007
	--
	elseif map == "goldeneye64_damver051" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("give weapon_pistol") -- loadout as map intended
			SendToConsole("hlvr_addresources 40 0 0 5")
		else
			ModGoldenEyeDam1_PlayReplacementAmbient()
		end
		ent = Entities:FindByName(nil, "truck_door")
		ent:RedirectOutput("OnOpen", "ModGoldenEyeDam1_ShowHintIntro", ent)
		ent = Entities:FindByName(nil, "truck_door")
		ent:RedirectOutput("OnClose", "ModGoldenEyeDam1_PlayReplacementAmbient", ent)
		ent = Entities:FindByName(nil, "2981_button_center_pusher")
		ent:RedirectOutput("OnIn", "ModGoldenEyeDam1_ShowHintObj2", ent)
		ent = Entities:FindByName(nil, "obj2_powerdown")
		ent:RedirectOutput("OnSoundFinished", "ModGoldenEyeDam1_ShowHintObj3", ent)
		ent = Entities:FindByName(nil, "5043_button_center_pusher")
		ent:RedirectOutput("OnIn", "ModGoldenEyeDam1_ShowHintEasterEgg", ent)
		ent = Entities:FindByName(nil, "5088_button_center_pusher")
		ent:RedirectOutput("OnIn", "ModGoldenEyeDam1_ShowHintEasterEggRoom", ent)
		ent = Entities:FindByName(nil, "easter_egg_door")
		ent:RedirectOutput("OnFullyOpen", "ModGoldenEyeDam1_ShowHintEnd", ent)
		-- player must find a secret button to open easter egg room
		ent:RedirectOutput("OnLockedUse", "ModGoldenEyeDam1_ShowHintEnd", ent)

		ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(81, -14, 510), 25)
		ent:SetEntityName("novr_garage_switch")
		ent:RedirectOutput("OnCompletionA", "ModGoldenEyeDam1_ShowHintTripmines", ent)
		ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(155, -202, 976), 25)
		ent:SetEntityName("novr_tower_switch")
		ent:RedirectOutput("OnCompletionA", "ModGoldenEyeDam1_ShowHintObj4", ent)

		Convars:RegisterCommand("novr_goldeneye_dam1_leavecombinegun", function()
		SendToConsole("ent_fire player_speedmod ModifySpeed 1")
		SendToConsole("ent_fire 4423_combine_gun_mechanical ClearParent")
		SendToConsole("ent_fire 4424_combine_gun_mechanical ClearParent")
		SendToConsole("bind " .. PRIMARY_ATTACK .. " +customattack")
		local ent = Entities:FindByName(nil, "4423_combine_gun_mechanical")
		SendToConsole("ent_setpos " .. ent:entindex() .. " -87.649 82.855 493.961")
		SendToConsole("ent_setang " .. ent:entindex() .. " 14.999 354.999 0")
		local ent = Entities:FindByName(nil, "4424_combine_gun_mechanical")
		SendToConsole("ent_setpos " .. ent:entindex() .. " -12.135 -149.014 500.586")
		SendToConsole("ent_setang " .. ent:entindex() .. " 14.999 84.999 0")
		SendToConsole("r_drawviewmodel 1")
		end, "", 0)
	elseif map == "goldeneye64dampart2_ver052_master" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("hidehud 96") -- TODO find intro triggers
			SendToConsole("hlvr_addresources 40 0 0 0")
		end
		ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(-1226, 28, 540), 25)
		ent:SetEntityName("novr_starthangar_switch")
		-- TODO replace all generic weapon items!
		ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(3987, 33, 539), 25)
		ent:SetEntityName("novr_endhangar_switch")
	elseif map == "training_day" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("hlvr_addresources 30 0 0 0")
			Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 0)
		end
		ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(-934, -1562, 71), 25)
		ent:SetEntityName("novr_fence_switch")
		-- TODO replace plastic boxes (prop_physics_interactive) by collidable variants
	--
	-- Addon: Resident Alyx biohazard
	--
	elseif map == "lv8-zombies" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
	elseif map == "level_8_zombies_part2" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
	elseif map == "zombies_part_3" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("setpos_exact 4830.8001 -987.892 55")
		end
		ent = Entities:FindByName(nil, "14990_powerunit_relay_battery_inserted")
		ent:RedirectOutput("OnTrigger", "ModResidentAlyx_Lvl3BatteryInserted", ent)
		ent = Entities:FindByName(nil, "12228_powerunit_relay_battery_inserted")
		ent:RedirectOutput("OnTrigger", "ModResidentAlyx_Lvl3BatteryInserted", ent)
	elseif map == "zombies_part_4" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		ent = Entities:FindByName(nil, "15911_relay_unlock_controls")
		ent:RedirectOutput("OnTrigger", "ModResidentAlyx_Lvl4AllowToDetonateBarrels", ent)
	elseif map == "zombies_part_5" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
		if not isSaveLoaded then
			SendToConsole("setpos_exact 684.840 -1464.396 53")
			-- replace ending trap door by player-collidable
			ent = Entities:FindByName(nil, "graat")
			local angles = ent:GetAngles()
			local pos = ent:GetAbsOrigin()
			local child = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["CollisionGroupOverride"]=5, ["solid"]=6, ["renderamt"]=0, ["targetname"]=ent:GetName(), ["model"]=ent:GetModelName(), ["origin"]= pos.x .. " " .. pos.y .. " " .. pos.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z})
			child:SetParent(ent, "")
		end
	elseif map == "catacombsfinal2" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
	elseif map == "zombies_part_6" then
		SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
	--
	--
	--
	end
end

--
-- Addon-specific object interactions
--

function ModSupport_CheckUseObjectInteraction(thisEntity)
	local player = Entities:GetLocalPlayer()
	local map = GetMapName()
	local class = thisEntity:GetClassname()
	local name = thisEntity:GetName()
	local model = thisEntity:GetModelName()

	--
	-- Common mod stuff
	--
    if model == "models/weapons/vr_tripmine/tripmine.vmdl" then
        local ent = Entities:FindByClassnameNearest("info_hlvr_holo_hacking_plug", thisEntity:GetCenter(), 5)
        if ent and ent:Attribute_GetIntValue("used", 0) == 0 then
            ent:Attribute_SetIntValue("used", 1)
            DoEntFireByInstanceHandle(ent, "BeginHack", "", 0, nil, nil)
            ent:FireOutput("OnHackStarted", nil, nil, nil, 0)
            ent:FireOutput("OnHackSuccess", nil, nil, nil, 1.8)
            ent:FireOutput("OnPuzzleSuccess", nil, nil, nil, 1.8)
            ent:FireOutput("OnHackSuccessAnimationComplete", nil, nil, nil, 1.8)
            DoEntFireByInstanceHandle(ent, "EndHack", "", 1.8, nil, nil)
            --StartSoundEventFromPosition("HackingPuzzle.TripmineSuccess", player:EyePosition())
        end
    end
    if class == "hlvr_weapon_energygun" and map ~= "a1_intro_world_2" then
        SendToConsole("give weapon_pistol")
        SendToConsole("ent_remove weapon_bugbait")
        thisEntity:Kill()
    end
    if class == "item_hlvr_weapon_grabbity_glove" and map ~= "a1_intro_world_2" then
        player:Attribute_SetIntValue("gravity_gloves", 1)
        StartSoundEventFromPosition("Grabbity.HoverPing", player:EyePosition())
        thisEntity:Kill()
    end
	--
	-- Addon: Extra-Ordinary Value
	--
    if map == "youreawake" then
        if name == "1931_headset" then
            StartSoundEventFromPosition("RadioHeadset.PutOn", Entities:GetLocalPlayer():EyePosition())
            SendToConsole("ent_fire_output 1931_headset onputonheadset trigger")
            SendToConsole("ent_fire 1931_headset kill")
        end
    end
    if map == "facilityredux" then
        if name == "2461_inside_elevator_button" then -- UseElevator
            SendToConsole("ent_fire 2461_elev_button_elevator press")
        end
        if name == "2826_vetport" then
            SendToConsole("ent_fire 2826_vetport onplugrotated")
            SendToConsole("ent_fire_output 2826_final onpoweron")
        end
        if name == "2826_95_door_reset" then -- UseFenceDoorLever
            SendToConsole("ent_fire_output 2826_95_relay_flip_switch OnTrigger")
        end
    end
    if map == "helloagain" then
        if name == "" and class == "info_hlvr_holo_hacking_plug" then -- Generic hack plug unlock
            thisEntity:FireOutput("OnHackSuccess", nil, nil, nil, 0)
        end
        if name == "393_elev_button_elevator" then -- UseElevatorButton
            SendToConsole("ent_fire 393_elev_button_elevator press")
        end
        if name == "392_392_134_button_center" then
            SendToConsole("ent_fire_output 392_117_combine_door_open_relay ontrigger")
        end
    end
	--
	-- Addon: Belomorskaya Station
	--
    if map == "belomorskaya" then
        if name == "857_button_pusher_prop" then
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 857_button_center_pusher onin")
        end
        if name == "verticaldoor_wheel" then
            SendToConsole("ent_fire @verticaldoor setspeed 2")
            SendToConsole("ent_fire @verticaldoor open")
        end
    end
	--
	-- Addon: Overcharge
	--
    if map == "mc1_higgue" then
        if name == "introSEQ_button1_p" then -- StartUseElevatorButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output introseq_button1 onin")
            SendToConsole("hidehud 64")
            SendToConsole("r_drawviewmodel 1")
            SendToConsole("give weapon_pistol") -- Pistol on start
        end -- generic plugs workaround doesn't work here
        if name == "CmbnDoorLock0" or name == "CmbnDoorLock1" or name == "CmbnDoorLock2" then
            local ent = Entities:FindByClassnameNearest("info_hlvr_holo_hacking_plug", thisEntity:GetCenter(), 40)
            if ent then
                ent:FireOutput("OnHackSuccess", nil, nil, nil, 0)
                ent:FireOutput("OnPuzzleSuccess", nil, nil, nil, 0)
                DoEntFireByInstanceHandle(thisEntity, "use", "", 0, nil, nil)
            end
        end -- and lockers workaround doesn't work here too
        if name == "CmbnLocker_SHOT" then
            SendToConsole("ent_fire CmbnLocker_SHOT alpha 100")
            SendToConsole("ent_fire CmbnLocker_SHOT disablecollision")
        end
        if name == "CmbnLocker_LPUZZ" then
            SendToConsole("ent_fire CmbnLocker_LPUZZ alpha 100")
            SendToConsole("ent_fire CmbnLocker_LPUZZ disablecollision")
        end
        if name == "CmbnLocker_EATFRESH" then
            SendToConsole("ent_fire CmbnLocker_EATFRESH alpha 100")
            SendToConsole("ent_fire CmbnLocker_EATFRESH disablecollision")
        end
        if name == "CmbnLocker_SEWER" then
            SendToConsole("ent_fire CmbnLocker_SEWER alpha 100")
            SendToConsole("ent_fire CmbnLocker_SEWER disablecollision")
        end
        if class == "item_hlvr_weapon_shotgun" then
            local ent = Entities:FindByName(nil, "wep_shotgun_pickupmusic")
            DoEntFireByInstanceHandle(ent, "startsound", "", 0, nil, nil)
        end
        if model == "models/props_combine/combine_power/power_stake_a.vmdl" and name == "puzzle_wireNEWPort" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output toner_port_plug onhacksuccess")
            SendToConsole("ent_fire_output pathlmao_n onpoweron") -- npc spawn trigger
            SendToConsole("ent_fire_output pathe_n onpoweron")
        end
        if model == "models/props_combine/combine_power/power_stake_a.vmdl" and name == "puzzle_wirePort" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output toner_port_plug onhacksuccess")
            SendToConsole("ent_fire_output pathg onpoweron")
        end
        if name == "FightFInale_Entry_Button" then -- UseFinaleEntryButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output fightfinale_entry_button onin")
        end
        if name == "FightFInale_Lift_Button" then -- UseFinaleLiftButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output fightfinale_lift_button onin")
        end
        if name == "FightFinale_Lift_IntButton" then -- UseFinaleLiftIntButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output fightfinale_lift_intbutton onin")
        end
        if name == "FightFinale_End_button" then -- UseFinaleEndButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output fightfinale_end_button onin")
        end
    end
	--
	-- Addon: Levitation
	--
    if map == "02_notimelikenow" then
        if name == "TimeGearsValve" then
            SendToConsole("ent_fire_output timegearsvalve oncompletiona")
        end
        if name == "6061_toner_port" then
            SendToConsole("ent_fire 6061_toner_port onplugrotated")
            SendToConsole("ent_fire_output 6061_toner_path_9 onpoweron")
        end
        if name == "43250_button_pusher_prop" then -- PushUselessLiftButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
        end
        if name == "31397_mesh_combine_switch_box" then
            SendToConsole("ent_fire_output 31397_switch_box_hack_plug OnHackSuccess")
        end
        if name == "31397_prop_button" then
            SendToConsole("ent_fire_output 31397_handpose_combine_switchbox_button_press OnHandPosed")
        end
        if name == "tonerport" then
            SendToConsole("ent_fire_output simpleunlock_path2 onpoweron")
        end
    end
    if map == "03_metrodynamo" then
        if name == "toner_port" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire toner_port onplugrotated")
            SendToConsole("ent_fire_output toner_path_1 onpoweron")
            SendToConsole("ent_fire_output toner_path_2 onpoweron")
            SendToConsole("ent_fire_output toner_path_4 onpoweron")
            SendToConsole("ent_fire_output toner_path_5 onpoweron")
            SendToConsole("ent_fire_output toner_path_real onpoweron")
            SendToConsole("ent_fire_output toner_path_6 onpoweron")
            SendToConsole("ent_fire_output toner_path_8 onpoweron")
            SendToConsole("ent_fire_output toner_path_9 onpoweron")
            SendToConsole("ent_fire_output toner_path_real onpoweron") -- must be twice?
        end
        if name == "10200_126_button_pusher_prop" then -- PushWaterBottlesButton
            SendToConsole("ent_fire_output 10200_126_button_center_pusher onin")
        end
    end
    if map == "04_hehungers" then
        if name == "23711_combine_locker" or name == "23711_locker_hack_plug" then
            SendToConsole("ent_fire_output 23711_locker_hack_plug OnHackStarted") -- zombie awake
        end
        if name == "power_stake_1_start" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output toner_port_plug OnHackSuccess")
            SendToConsole("ent_fire_output toner_path_3 onpoweron")
            SendToConsole("ent_fire_output toner_path_4 onpoweron")
            SendToConsole("ent_fire_output toner_path_5 onpoweron")
            SendToConsole("ent_fire_output toner_path_6 onpoweron")
            SendToConsole("ent_fire_output toner_path_7 onpoweron")
            SendToConsole("ent_fire_output toner_path_11 onpoweron")
        end
        if name == "31397_mesh_combine_switch_box" then
            SendToConsole("ent_fire_output 31397_switch_box_hack_plug OnHackSuccess")
        end
        if name == "31397_prop_button" then
            SendToConsole("ent_fire_output 31397_handpose_combine_switchbox_button_press OnHandPosed")
        end
        if name == "43879_button_pusher_prop" then -- PushLiftButton
            SendToConsole("ent_fire_output 43879_button_center_pusher onin")
        end
    end
    if map == "05_pleasantville" then
        if name == "15708_mesh_combine_switch_box" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 15708_switch_box_hack_plug OnHackSuccess")
        end
        if name == "15708_prop_button" then
            SendToConsole("ent_fire_output 15708_handpose_combine_switchbox_button_press OnHandPosed")
            player:Attribute_SetIntValue("plug_lever", 1) -- workaround on current NoVR version, to allow player use crank switches later
        end
        if name == "29473_button_pusher_prop" then -- PushWaterBottlesButton
            SendToConsole("ent_fire_output 29473_button_center_pusher onin")
        end
        if name == "29494_button_pusher_prop" then -- PushSecretButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 29494_button_center_pusher onin")
        end
        if name == "32803_antlion_plug_crank_a" then
            SendToConsole("ent_fire_output 32803_antlion_plug_crank_a oncompletionc_forward")
        end
        if name == "32822_antlion_plug_crank_a" then
            SendToConsole("ent_fire_output 32822_antlion_plug_crank_a oncompletionc_forward")
        end
        if name == "32818_antlion_plug_crank_a" then
            SendToConsole("ent_fire_output 32818_antlion_plug_crank_a oncompletionc_forward")
        end
        if name == "32808_antlion_plug_crank_a" then
            SendToConsole("ent_fire_output 32808_antlion_plug_crank_a oncompletionc_forward")
        end
        if name == "32812_antlion_plug_crank_a" then
            SendToConsole("ent_fire_output 32812_antlion_plug_crank_a oncompletionc_forward")
        end
        if name == "29732_button_pusher_prop" then -- PushEndButton
            SendToConsole("ent_fire_output 29732_button_center_pusher onin")
        end
    end
    if map == "06_digdeep" then
        if name == "28212_button_pusher_prop" then -- PushElevatorButton
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 28212_button_center_pusher onin")
        end
        if name == "toner_port" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output toner_port_plug OnHackSuccess")
            SendToConsole("ent_fire_output toner_path_1 onpoweron")
            SendToConsole("ent_fire_output toner_path_4 onpoweron")
            SendToConsole("ent_fire_output toner_path_6 onpoweron")
            SendToConsole("ent_fire_output toner_path_9 onpoweron")
        end
        if name == "movelever" and Entities:FindByName(nil, "toner_port"):Attribute_GetIntValue("used", 0) == 1 then
            SendToConsole("ent_fire_output movelever oncompletiona")
        end
    end
    if map == "07_sectorx" then
        if name == "novr_workaround_battery" then -- PlayerTakeNoVRBattery
            SendToConsole("ent_fire 8621_powerunit_relay_reviver_removed trigger")
        end
        if name == "novr_workaround_battery2" then -- PlayerTakeNoVRBattery2
            SendToConsole("ent_fire 10554_powerunit_relay_reviver_removed trigger")
        end
        if name == "11919_mesh_combine_switch_box" then
            SendToConsole("ent_fire_output 11919_switch_box_hack_plug OnHackSuccess")
        end
        if name == "11919_prop_button" then
            SendToConsole("ent_fire_output 11919_handpose_combine_switchbox_button_press OnHandPosed")
        end
        if name == "30575_button_pusher_prop" then -- 1
            SendToConsole("ent_fire_output 30575_button_center_pusher onin")
        end
        if name == "30576_button_pusher_prop" then -- 2
            SendToConsole("ent_fire_output 30576_button_center_pusher onin")
        end
        if name == "30572_button_pusher_prop" then -- 3
            SendToConsole("ent_fire_output 30572_button_center_pusher onin")
        end
        if name == "30581_button_pusher_prop" then -- 4
            SendToConsole("ent_fire_output 30581_button_center_pusher onin")
        end
        if name == "30582_button_pusher_prop" then -- 5
            SendToConsole("ent_fire_output 30582_button_center_pusher onin")
        end
        if name == "30578_button_pusher_prop" then -- 6
            SendToConsole("ent_fire_output 30578_button_center_pusher onin")
        end
        if name == "30567_button_pusher_prop" then -- 7
            SendToConsole("ent_fire_output 30567_button_center_pusher onin")
        end
        if name == "30570_button_pusher_prop" then
            SendToConsole("ent_fire_output 30570_button_center_pusher onin")
        end
        if name == "30569_button_pusher_prop" then
            SendToConsole("ent_fire_output 30569_button_center_pusher onin")
        end
    end
	--
	-- Addon: GoldenEye Alyx 007
	--
    if map == "goldeneye64_damver051" then
        if name == "2981_button_pusher_prop" then
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 2981_button_center_pusher onin")
        end
        if name == "Obj2_Port" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire obj2_port onplugrotated")
            SendToConsole("ent_fire_output obj2_path5 onpoweron")
        end
        if name == "novr_garage_switch" then
            SendToConsole("ent_fire_output novr_garage_switch oncompletiona")
        end
        if name == "novr_tower_switch" then
            SendToConsole("ent_fire_output novr_tower_switch oncompletiona")
        end
        if name == "4423_combine_gun_mechanical" or name == "4424_combine_gun_mechanical" then
            SendToConsole("bind J novr_goldeneye_dam1_leavecombinegun")
            ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=3, ["x"]=-1, ["y"]=0.6})
            DoEntFireByInstanceHandle(ent, "SetText", "Press [J] to get out", 0, nil, nil)
            DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
            SendToConsole("play sounds/ui/beepclear.vsnd")
            SendToConsole("ent_fire player_speedmod ModifySpeed 0")
            local player_ang = player:EyeAngles()
            if name == "4423_combine_gun_mechanical" then
                SendToConsole("ent_fire 4423_combine_gun_grab_handle SetParent combine_gun_mechanical")
                SendToConsole("ent_fire 4423_combine_gun_interact Alpha 0")
                SendToConsole("ent_fire 4423_combine_gun_mechanical SetParent !player")
                thisEntity:SetAngles(player_ang.x - 30,player_ang.y - 180,0)
                SendToConsole("bind " .. PRIMARY_ATTACK .. " \"ent_fire 4423_relay_shoot_gun trigger\"")
                SendToConsole("r_drawviewmodel 0")
                thisEntity:Attribute_SetIntValue("used", 1)
            else
                SendToConsole("ent_fire 4424_combine_gun_grab_handle SetParent combine_gun_mechanical")
                SendToConsole("ent_fire 4424_combine_gun_interact Alpha 0")
                SendToConsole("ent_fire 4424_combine_gun_mechanical SetParent !player")
                thisEntity:SetAngles(player_ang.x - 30,player_ang.y - 180,0)
                SendToConsole("bind " .. PRIMARY_ATTACK .. " \"ent_fire 4424_relay_shoot_gun trigger\"")
                SendToConsole("r_drawviewmodel 0")
                thisEntity:Attribute_SetIntValue("used", 1)
            end
        end
        if name == "5088_button_pusher_prop" then
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 5088_button_center_pusher onin")
        end
        if name == "5043_button_pusher_prop" then
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 5043_button_center_pusher onin")
        end
    end
    if map == "goldeneye64dampart2_ver052_master" then
        if class == "item_hlvr_weapon_generic_pistol" then
            SendToConsole("hidehud 64")
            SendToConsole("give weapon_pistol")
            thisEntity:Kill()
        end
        if name == "novr_starthangar_switch" then
            SendToConsole("ent_fire_output novr_starthangar_switch oncompletiona")
        end
        -- station 1
        if name == "5520_cshield_station_1" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 5520_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "5520_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 5520_cshield_station_relay_button_pressed OnTrigger")
        end
        -- station 2
        if name == "5515_cshield_station_2" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 5515_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "5515_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 5515_cshield_station_relay_button_pressed OnTrigger")
        end
        -- station 3
        if name == "3196_cshield_station_3" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 3196_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "3196_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 3196_cshield_station_relay_button_pressed OnTrigger")
        end
        -- station 4
        if name == "3191_cshield_station_4" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 3191_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "3191_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 3191_cshield_station_relay_button_pressed OnTrigger")
        end
        -- station 5
        if name == "5516_cshield_station_5" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 5516_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "5516_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 5516_cshield_station_relay_button_pressed OnTrigger")
        end
        -- station 6
        if name == "3197_cshield_station_6" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 3197_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "3197_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 3197_cshield_station_relay_button_pressed OnTrigger")
        end
        if name == "novr_endhangar_switch" then
            SendToConsole("ent_fire_output novr_endhangar_switch oncompletiona")
            SendToConsole("r_drawviewmodel 0")
            SendToConsole("hidehud 4")
            SendToConsole("ent_fire player_speedmod ModifySpeed 0")
            SendToConsole("bind MOUSE1 \"\"")
        end
    end
	--
	-- Addon: Training Day
	--
    if map == "training_day" then
        -- station
        if name == "1022_cshield_station_1" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 1022_cshield_station_hack_plug OnHackSuccess")
        end
        if name == "1022_cshield_station_prop_button" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 1022_cshield_station_relay_button_pressed OnTrigger")
        end
        if name == "1088_door_reset" then
            SendToConsole("ent_fire_output 1088_relay_flip_switch ontrigger")
        end
        if name == "novr_fence_switch" then
            SendToConsole("ent_fire_output novr_fence_switch oncompletiona")
        end
        -- map bug: two different entities named the same
        if name == "1199_button_center" then
            StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
            SendToConsole("ent_fire_output 1199_relay_elevator_button_down ontrigger")
            SendToConsole("ent_fire_output 1199_relay_elevator_button_no_power ontrigger")
            ent = Entities:FindByName(nil, "final door")
            DoEntFireByInstanceHandle(ent, "Unlock", "", 2, nil, nil)
            ent = Entities:FindByName(nil, "template fonal room")
            DoEntFireByInstanceHandle(ent, "ForceSpawn", "", 4, nil, nil)
        end
    end
	--
	-- Addon: Resident Alyx biohazard
	--
    if map == "zombies_part_3" then
        if name == "16241_door_reset" then
            SendToConsole("ent_fire_output 16241_door_reset OnCompletionA_Forward")
        end
        -- garage plugs set
        if vlua.find(Entities:FindAllInSphere(Vector(3843,726,55), 20), player) then
            local ent = Entities:FindByNameNearest("391_locker_hack_plug", thisEntity:GetCenter(), 20)
            if ent and player:Attribute_GetIntValue("novr_zp3_391plug_used", 0) == 0 then
                player:Attribute_SetIntValue("novr_zp3_391plug_used", 1)
                ent:FireOutput("OnHackStarted", nil, nil, nil, 0)
                DoEntFireByInstanceHandle(ent, "BeginHack", "", 0, nil, nil)
                DoEntFireByInstanceHandle(ent, "EndHack", "", 1.8, nil, nil)
                ent:FireOutput("OnHackSuccess", nil, nil, nil, 1.8)
            end
        end
        if name == "15529_mesh_combine_switch_box" and player:Attribute_GetIntValue("novr_zp3_391plug_used", 0) == 1 and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 15529_switch_box_hack_plug OnHackSuccess")
        end
        if name == "15529_prop_button" and player:Attribute_GetIntValue("novr_zp3_391plug_used", 0) == 1 and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 15529_handpose_combine_switchbox_button_press OnHandPosed") -- in fact it must power on crafting station, but due to NoVR script constant updates, will left it as it is
        end
        -- two batteries lock set
        if name == "12270_mesh_combine_switch_box" and player:Attribute_GetIntValue("novr_zp3_batteries", 0) == 2 and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 12270_switch_box_hack_plug OnHackSuccess")
        end
        if name == "12270_prop_button" and player:Attribute_GetIntValue("novr_zp3_batteries", 0) == 2 and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            thisEntity:Attribute_SetIntValue("used", 1)
            SendToConsole("ent_fire_output 12270_handpose_combine_switchbox_button_press OnHandPosed")
        end
    end
    if map == "zombies_part_4" then
        if name == "15911_antlion_plug_crank_a" then -- unlock on map story moment
            SendToConsole("ent_fire_output 15911_antlion_plug_crank_a oncompletionc_forward")
        end
    end
end

--
-- Addon-specific script functions
--

local function ModCommon_ShowFlashlightTutorial()
    SendToConsole("ent_fire text_flashlight ShowMessage")
    SendToConsole("play play sounds/ui/beepclear.vsnd")
end

local function ModCommon_DisablePlayerActions(a, b)
    SendToConsole("r_drawviewmodel 0")
    SendToConsole("hidehud 4")
    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
    SendToConsole("bind MOUSE1 \"\"")
end

local function ModBelomorskaya_EquipFlare(a, b) -- TODO works bad
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    local viewmodel_ang = viewmodel:GetAngles()
    local viewmodel_pos = viewmodel:GetAbsOrigin()

    ent = Entities:FindByName(nil, "flare_01")
    if ent then
        ent:SetOrigin(Vector(viewmodel_pos.x + 35, viewmodel_pos.y + 35, viewmodel_pos.z + 35))
        ent:SetAngles(viewmodel_ang.x, viewmodel_ang.y + 180, viewmodel_ang.z)
    end
    DoEntFireByInstanceHandle(ent, "SetParent", "!player", 0, nil, nil)
    ent = Entities:FindByName(nil, "flare_trigger_01")
    if ent then
        ent:Kill()
    end
end

local function ModBelomorskaya_RemoveFlare(a, b)
    ent = Entities:FindByName(nil, "flare_01")
    if ent then
        ent:Kill()
    end
end

local function ModLevitation_AllowMovement(a, b)
    SendToConsole("ent_fire player_speedmod ModifySpeed 1")
end

local function ModLevitation_SpawnWorkaroundBottlesForJeff()
    SpawnEntityFromTableSynchronous("prop_physics", {["solid"]=6, ["model"]="models/props/beer_bottle_1.vmdl", ["origin"]="-102.158 -4415.675 -151"})
    SpawnEntityFromTableSynchronous("prop_physics", {["solid"]=6, ["model"]="models/props/beer_bottle_1.vmdl", ["origin"]="-102.158 -4410.675 -151"})
end

local function ModLevitation_Map5SpawnWorkaroundJumpStructure()
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/tanks/vertical_tank.vmdl", ["origin"]="685.276 -701.073 7780", ["angles"]="0 0 0"})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/industrial_small_tank_1.vmdl", ["origin"]="685.276 -701.073 7720", ["angles"]="0 0 0", ["skin"]=2})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/industrial_small_tank_1.vmdl", ["origin"]="685.276 -701.073 7723", ["angles"]="0 0 180", ["skin"]=2})
end

local function ModLevitation_Map6EndingTransition(a, b)
    SendToConsole("r_drawviewmodel 0")
    SendToConsole("hidehud 4")
    SendToConsole("bind MOUSE1 \"\"")
end

local function ModLevitation_Map7SpawnWorkaroundBattery()
    SpawnEntityFromTableSynchronous("item_hlvr_prop_battery", {["targetname"]="novr_workaround_battery", ["solid"]=6, ["origin"]="1121.042 -530.784 344"})
end

local function ModLevitation_Map7SpawnWorkaroundBattery2()
    SpawnEntityFromTableSynchronous("item_hlvr_prop_battery", {["targetname"]="novr_workaround_battery2", ["solid"]=6, ["origin"]="-666.762 493.066 -439.9"})
end

local function ModLevitation_Map7SpawnWorkaroundJumpStructure()
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-264.164 -1015.459 486", ["angles"]="0 0 0", ["skin"]=0})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-268.164 -1015.459 518.5", ["angles"]="0 21 0", ["skin"]=0})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-270.164 -1015.459 551", ["angles"]="0 7 0", ["skin"]=0})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-272.164 -1015.459 583.5", ["angles"]="0 -12 0", ["skin"]=0})
end

local function ModLevitation_Map7EnterCombineTrap()
    SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_smg1;ent_remove weapon_frag")
    SendToConsole("r_drawviewmodel 0")
end

local function ModLevitation_RemoveVortPowers(a, b)
    SendToConsole("bind MOUSE1 \"\"")
end

local function ModLevitation_Map8FinaleStopMove(a, b)
    SendToConsole("hidehud 4")
    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
end

-- music is supposed to be played, but it's resource file broken even in VR
local function ModGoldenEyeDam1_PlayReplacementAmbient(a, b)
    StartSoundEventFromPosition("Ambient.WindSystem", Entities:GetLocalPlayer():EyePosition())
end

local function ModGoldenEyeDam1_ShowHintIntro(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "This is where your mission begins, Agent Alyx Bond.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "SetText", "Objective 1: Find the remote access button to the guard tower bunker.", 4, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 4, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintObj2(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Objective 2: Enter the bunker and shut down the main power grid.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintObj3(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Objective 3: Reach the top of the tower and find the switch to the tunnel doors.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintObj4(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Objective 4: Enter the tunnel and get to the dam.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintTripmines(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Tip: Place the hoppers down as trip mines to set traps for your enemies.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintEasterEggRoom(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "You have opened the Secret Room.", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintEasterEgg(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Tip: GET OUT OF MY ROOM!", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModGoldenEyeDam1_ShowHintEnd(a, b)
    ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=4, ["x"]=-1, ["y"]=0.6})
    DoEntFireByInstanceHandle(ent, "SetText", "Congratulations for beating the level (Insert Playtester Name Here)!", 0, nil, nil)
    DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
end

local function ModResidentAlyx_Lvl3BatteryInserted(a, b)
    local player = Entities:GetLocalPlayer()
    local batteryCount = player:Attribute_GetIntValue("novr_zp3_batteries", 0)
    player:Attribute_SetIntValue("novr_zp3_batteries", batteryCount + 1)
end

local function ModResidentAlyx_Lvl4AllowToDetonateBarrels(a, b)
    Entities:GetLocalPlayer():Attribute_SetIntValue("plug_lever", 1) -- workaround on current NoVR version, to allow player use crank switches later
end

if isModActive then
    -- TODO remove after tests
    Convars:RegisterCommand("novr_multitool_test", function()
    local ent = Entities:FindByClassname(nil, "prop_hmd_avatar")
    if ent then
        local rightHand = ent:GetVRHand(1)
        local att = Entities:FindByClassname(nil, "hlvr_multitool")
        if att then
            att:SetEntityName("mtool")
            rightHand:SetHandAttachment(att)
        end
    end
    end, "", 0)
end

Convars:RegisterCommand("novr_viewmodel_test", function()
	local viewmodel = Entities:FindByClassname(nil, "viewmodel")
	viewmodel:ResetSequence("pickup")
	--SendToConsole("ent_fire viewmodel setsequence pickup")
end, "", 0)