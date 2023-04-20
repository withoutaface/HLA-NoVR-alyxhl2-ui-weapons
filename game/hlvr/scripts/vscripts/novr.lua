if GlobalSys:CommandLineCheck("-novr") then
    DoIncludeScript("bindings.lua", nil)
    DoIncludeScript("flashlight.lua", nil)
    DoIncludeScript("jumpfix.lua", nil)
	require "storage"
	local isModActive = false -- Mod support by Hypercycle

    if player_hurt_ev ~= nil then
        StopListeningToGameEvent(player_hurt_ev)
    end

    player_hurt_ev = ListenToGameEvent('player_hurt', function(info)
        -- Hack to stop pausing the game on death
        if info.health == 0 then
			if isModActive then
				SendToConsole("load quick") -- trick to avoid crashes with addons
			else
				SendToConsole("reload")
				SendToConsole("r_drawvgui 0")
			end
        end

        -- Kill on fall damage
        if GetPhysVelocity(Entities:GetLocalPlayer()).z < -450 then
            SendToConsole("ent_fire !player SetHealth 0")
        end
    end, nil)

    if entity_killed_ev ~= nil then
        StopListeningToGameEvent(entity_killed_ev)
    end

    entity_killed_ev = ListenToGameEvent('entity_killed', function(info)
        local player = Entities:GetLocalPlayer()
        player:SetThink(function()
            function GibBecomeRagdoll(classname)
                ent = Entities:FindByClassname(nil, classname)
                while ent do
                    if vlua.find(ent:GetModelName(), "models/creatures/headcrab_classic/headcrab_classic_gib") or vlua.find(ent:GetModelName(), "models/creatures/headcrab_armored/armored_hc_gib") then
                        DoEntFireByInstanceHandle(ent, "BecomeRagdoll", "", 0.01, nil, nil)
                    end
                    ent = Entities:FindByClassname(ent, classname)
                end
            end

            GibBecomeRagdoll("prop_physics")
            GibBecomeRagdoll("prop_ragdoll")
        end, "GibBecomeRagdoll", 0)

        local ent = EntIndexToHScript(info.entindex_killed):GetChildren()[1]
        if ent and ent:GetClassname() == "weapon_smg1" then
            ent:SetThink(function()
                if ent:GetMoveParent() then
                    return 0
                else
                    DoEntFireByInstanceHandle(ent, "BecomeRagdoll", "", 0.02, nil, nil)
                end
            end, "BecomeRagdollWhenNoParent", 0)
        end
    end, nil)

    if changelevel_ev ~= nil then
        StopListeningToGameEvent(changelevel_ev)
    end

    changelevel_ev = ListenToGameEvent('change_level_activated', function(info)
        SendToConsole("r_drawvgui 0")
    end, nil)

    if pickup_ev ~= nil then
        StopListeningToGameEvent(pickup_ev)
    end

    pickup_ev = ListenToGameEvent('physgun_pickup', function(info)
        local ent = EntIndexToHScript(info.entindex)
        local child = ent:GetChildren()[1]
        if child and child:GetClassname() == "prop_dynamic" then
            child:SetEntityName("held_prop_dynamic_override")
        end
        ent:Attribute_SetIntValue("picked_up", 1)
        ent:SetThink(function()
            ent:Attribute_SetIntValue("picked_up", 0)
        end, "", 0.45)
        DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
    end, nil)

    Convars:RegisterConvar("chosen_upgrade", "", "", 0)

    Convars:RegisterConvar("weapon_in_crafting_station", "", "", 0)

    Convars:RegisterCommand("chooseupgrade1", function()
        local t = {}
        Entities:GetLocalPlayer():GatherCriteria(t)

        if t.current_crafting_currency >= 10 then
            if Convars:GetStr("weapon_in_crafting_station") == "pistol" then
                Convars:SetStr("chosen_upgrade", "pistol_upgrade_aimdownsights")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -10")
            elseif Convars:GetStr("weapon_in_crafting_station") == "shotgun" then
                Convars:SetStr("chosen_upgrade", "shotgun_upgrade_doubleshot")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -10")
            elseif Convars:GetStr("weapon_in_crafting_station") == "smg" then
                Convars:SetStr("chosen_upgrade", "smg_upgrade_aimdownsights")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -10")
            end
        else
            SendToConsole("ent_fire text_resin SetText #HLVR_CraftingStation_NotEnoughResin")
            SendToConsole("ent_fire text_resin Display")
            SendToConsole("play sounds/common/wpn_denyselect.vsnd")
            SendToConsole("cancelupgrade")
        end
    end, "", 0)

    Convars:RegisterCommand("chooseupgrade2", function()
        local t = {}
        Entities:GetLocalPlayer():GatherCriteria(t)

        if t.current_crafting_currency >= 20 then
            if Convars:GetStr("weapon_in_crafting_station") == "pistol" then
                Convars:SetStr("chosen_upgrade", "pistol_upgrade_burstfire")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -20")
            elseif Convars:GetStr("weapon_in_crafting_station") == "shotgun" then
                Convars:SetStr("chosen_upgrade", "shotgun_upgrade_grenadelauncher")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -20")
            elseif Convars:GetStr("weapon_in_crafting_station") == "smg" then
                Convars:SetStr("chosen_upgrade", "smg_upgrade_fasterfirerate")
                SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
                SendToConsole("hlvr_addresources 0 0 0 -20")
            end
        else
            SendToConsole("ent_fire text_resin SetText #HLVR_CraftingStation_NotEnoughResin")
            SendToConsole("ent_fire text_resin Display")
            SendToConsole("play sounds/common/wpn_denyselect.vsnd")
            SendToConsole("cancelupgrade")
        end
    end, "", 0)

    Convars:RegisterCommand("cancelupgrade", function()
        Convars:SetStr("chosen_upgrade", "cancel")
        SendToConsole("ent_fire weapon_in_fabricator Kill")
        SendToConsole("ent_fire upgrade_ui kill")
        SendToConsole("weapon_in_crafting_station \"\"")
        -- TODO: Give weapon back, but don't fill magazine
        if Convars:GetStr("weapon_in_crafting_station") == "pistol" then
            SendToConsole("give weapon_pistol")
        elseif Convars:GetStr("weapon_in_crafting_station") == "shotgun" then
            SendToConsole("give weapon_shotgun")
        elseif Convars:GetStr("weapon_in_crafting_station") == "smg" then
            if Entities:GetLocalPlayer():Attribute_GetIntValue("smg_upgrade_fasterfirerate", 0) == 0 then
                SendToConsole("give weapon_ar2")
            else
                SendToConsole("give weapon_smg1")
            end
        end
        SendToConsole("ent_fire prop_hlvr_crafting_station_console RunScriptFile useextra")
    end, "", 0)

    Convars:RegisterCommand("slowgrenade", function()
		local player = Entities:GetLocalPlayer()
        player:SetThink(function()
            local viewmodel = Entities:FindByClassname(nil, "viewmodel")
            if viewmodel and viewmodel:GetModelName() == "models/grenade.vmdl" then
                local grenade = Entities:FindByClassname(nil, "item_hlvr_grenade_frag")
                grenade:ApplyAbsVelocityImpulse(-GetPhysVelocity(grenade) * 0.7)
            end
        end, "SlowGrenade", 0.04)
    end, "", 0)

    -- Custom attack 2

    Convars:RegisterCommand("+customattack2", function()
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local player = Entities:GetLocalPlayer()
        if viewmodel and viewmodel:GetModelName() ~= "models/grenade.vmdl" then
            if viewmodel:GetModelName() == "models/shotgun.vmdl" then
                if player:Attribute_GetIntValue("shotgun_upgrade_doubleshot", 0) == 1 then
                    SendToConsole("+attack2")
                end
            elseif viewmodel:GetModelName() == "models/pistol.vmdl" then
                if player:Attribute_GetIntValue("pistol_upgrade_aimdownsights", 0) == 1 then
                    SendToConsole("toggle_zoom")
                end
            elseif viewmodel:GetModelName() == "models/smg.vmdl" then
                if player:Attribute_GetIntValue("smg_upgrade_aimdownsights", 0) == 1 then
                    SendToConsole("toggle_zoom")
                end
            end
        end
    end, "", 0)

    Convars:RegisterCommand("-customattack2", function()
        SendToConsole("-attack")
        SendToConsole("-attack2")
    end, "", 0)


    -- Custom attack 3

    Convars:RegisterCommand("+customattack3", function()
        local viewmodel = Entities:FindByClassname(nil, "viewmodel")
        local player = Entities:GetLocalPlayer()
        if viewmodel then
            if viewmodel:GetModelName() == "models/shotgun.vmdl" then
                if player:Attribute_GetIntValue("shotgun_upgrade_grenadelauncher", 0) == 1 then
                    SendToConsole("use weapon_frag")
                    SendToConsole("+attack")
                    SendToConsole("ent_fire weapon_frag hideweapon")
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("-attack")
                    end, "StopAttack", 0.36)
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("use weapon_shotgun")
                    end, "BackToShotgun", 0.66)
                end
            elseif viewmodel:GetModelName() == "models/pistol.vmdl" then
                if player:Attribute_GetIntValue("pistol_upgrade_burstfire", 0) == 1 then
                    SendToConsole("sk_plr_dmg_pistol 9")
                    SendToConsole("+attack")
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("-attack")
                    end, "StopAttack", 0.02)
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("+attack")
                    end, "StartAttack2", 0.14)
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("-attack")
                    end, "StopAttack2", 0.16)
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("+attack")
                    end, "StartAttack3", 0.28)
                    Entities:GetLocalPlayer():SetThink(function()
                        SendToConsole("-attack")
                        SendToConsole("sk_plr_dmg_pistol 7")
                    end, "StopAttack3", 0.3)
                end
            end
        end
    end, "", 0)

    Convars:RegisterCommand("-customattack3", function()
    end, "", 0)


    Convars:RegisterCommand("shootadvisorvortenergy", function()
        local ent = SpawnEntityFromTableSynchronous("env_explosion", {["origin"]="886 -4111.625 -1188.75", ["explosion_type"]="custom", ["explosion_custom_effect"]="particles/vortigaunt_fx/vort_beam_explosion_i_big.vpcf"})
        DoEntFireByInstanceHandle(ent, "Explode", "", 0, nil, nil)
        StartSoundEventFromPosition("VortMagic.Throw", Vector(886, -4111.625, -1188.75))
        SendToConsole("bind " .. PRIMARY_ATTACK .. " \"\"")
        SendToConsole("ent_fire relay_advisor_dead Trigger")
    end, "", 0)

    Convars:RegisterCommand("shootvortenergy", function()
        local player = Entities:GetLocalPlayer()
        local startVector = player:EyePosition()
        local traceTable =
        {
            startpos = startVector;
            endpos = startVector + RotatePosition(Vector(0,0,0), player:GetAngles(), Vector(1000000, 0, 0));
            ignore = player;
            mask =  33636363
        }

        TraceLine(traceTable)

        if traceTable.hit then
            ent = SpawnEntityFromTableSynchronous("env_explosion", {["origin"]=traceTable.pos.x .. " " .. traceTable.pos.y .. " " .. traceTable.pos.z, ["explosion_type"]="custom", ["explosion_custom_effect"]="particles/vortigaunt_fx/vort_beam_explosion_i_big.vpcf"})
            DoEntFireByInstanceHandle(ent, "Explode", "", 0, nil, nil)
            SendToConsole("npc_kill")
            DoEntFire("!picker", "RunScriptFile", "vortenergyhit", 0, nil, nil)
            StartSoundEventFromPosition("VortMagic.Throw", startVector)
			local vortEnergyCell = Entities:FindByClassnameNearest("point_vort_energy", Vector(traceTable.pos.x,traceTable.pos.y,traceTable.pos.z), 20)
			if vortEnergyCell then
				vortEnergyCell:FireOutput("OnEnergyPulled", nil, nil, nil, 0)
			end
        end
    end, "", 0)

    Convars:RegisterCommand("useextra", function()
        local player = Entities:GetLocalPlayer()

        if not player:IsUsePressed() then
            DoEntFire("!picker", "RunScriptFile", "check_useextra_distance", 0, nil, nil)

            if GetMapName() == "a5_vault" then
                if vlua.find(Entities:FindAllInSphere(Vector(-468, 2902, -519), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos -486 2908 -420")
                end
            end

            if GetMapName() == "a4_c17_water_tower" then
                if vlua.find(Entities:FindAllInSphere(Vector(3314, 6048, 64), 10), player) then
                    ClimbLadder(142)
                elseif vlua.find(Entities:FindAllInSphere(Vector(2981, 5879, -303), 10), player) then
                    ClimbLadder(-57)
                elseif vlua.find(Entities:FindAllInSphere(Vector(2374, 6207, -177), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos 2342 6257 -153")
                elseif vlua.find(Entities:FindAllInSphere(Vector(2432, 6662, 160), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos 2431 6715 310")
                elseif vlua.find(Entities:FindAllInSphere(Vector(2848, 6130, 384), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos 2850 6186 550")
                end
            end

            if GetMapName() == "a4_c17_tanker_yard" then
                if vlua.find(Entities:FindAllInSphere(Vector(6980, 2591, 13), 10), player) then
                    ClimbLadder(260)
                elseif vlua.find(Entities:FindAllInSphere(Vector(6618, 2938, 334), 10), player) then
                    ClimbLadder(402)
                elseif vlua.find(Entities:FindAllInSphere(Vector(6069, 3902, 416), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos 6118 3903 686")
                elseif vlua.find(Entities:FindAllInSphere(Vector(5434, 5755, 273), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos 5450, 5714, 403")
                end
            end

            if GetMapName() == "a3_station_street" then
                if vlua.find(Entities:FindAllInSphere(Vector(934, 1883, -135), 20), player) then
                    SendToConsole("ent_fire_output 2_8127_elev_button_floor_1_call OnIn")
                end
            end

            if GetMapName() == "a3_hotel_interior_rooftop" then
                if vlua.find(Entities:FindAllInSphere(Vector(2381, -1841, 448), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 2339 -1839 560")
                elseif vlua.find(Entities:FindAllInSphere(Vector(2345, -1834, 758), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 2345 -1834 840")
                end
            end

            if GetMapName() == "a3_hotel_lobby_basement" then
                if vlua.find(Entities:FindAllInSphere(Vector(1059, -1475, 200), 20), player) then
                    SendToConsole("ent_fire_output elev_button_floor_1 OnIn")
                elseif vlua.find(Entities:FindAllInSphere(Vector(976, -1467, 208), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 975 -1507 280")
                end
            end

            if GetMapName() == "a2_headcrabs_tunnel" and vlua.find(Entities:FindAllInSphere(Vector(347,-242,-63), 20), player) then
                ClimbLadderSound()
                SendToConsole("fadein 0.2")
                SendToConsole("setpos_exact 347 -297 2")
            end

            if GetMapName() == "a2_hideout" then
                local startVector = player:EyePosition()
                local traceTable =
                {
                    startpos = startVector;
                    endpos = startVector + RotatePosition(Vector(0,0,0), player:GetAngles(), Vector(100, 0, 0));
                    ignore = player;
                    mask =  33636363
                }
            
                TraceLine(traceTable)
            
                if traceTable.hit 
                then
                    local ent = Entities:FindByClassnameNearest("func_physical_button", traceTable.pos, 10)
                    if ent then
                        ent:FireOutput("OnIn", nil, nil, nil, 0)
                        StartSoundEventFromPosition("Button_Basic.Press", player:EyePosition())
                    end
                end
            end

            if GetMapName() == "a3_c17_processing_plant" then
                if vlua.find(Entities:FindAllInSphere(Vector(-80, -2215, 760), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact -26 -2215 870")
                end

                if vlua.find(Entities:FindAllInSphere(Vector(-240,-2875,392), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact -241 -2823 410")
                end

                if vlua.find(Entities:FindAllInSphere(Vector(414,-2459,328), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 365 -2465 410")
                end

                if vlua.find(Entities:FindAllInSphere(Vector(-1392,-2471,115), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact -1415 -2485 410")
                end

                if vlua.find(Entities:FindAllInSphere(Vector(-1420,-2482,472), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact -1392 -2471 53")
                end
            end
			
			-- Mod support for Extra-Ordinary Value
			-- Ladders
			if GetMapName() == "youreawake" then
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
			if GetMapName() == "seweroutskirts" then
				if vlua.find(Entities:FindAllInSphere(Vector(559,-273,2), 20), player) then -- 1
					ClimbLadderSound()
					SendToConsole("fadein 0.2")
					SendToConsole("setpos_exact 478 -269 163")
				elseif vlua.find(Entities:FindAllInSphere(Vector(2828,-1395,-95), 8), player) then -- 2
					ClimbLadder(42)
				end
			end
			if GetMapName() == "facilityredux" then
				if vlua.find(Entities:FindAllInSphere(Vector(-1757,-856,323), 20), player) then -- 1
					ClimbLadderSound()
					SendToConsole("fadein 0.2")
					SendToConsole("setpos_exact -1750.5 -883 55")
				end
			end
			if GetMapName() == "helloagain" then
				if vlua.find(Entities:FindAllInSphere(Vector(430,-1092,-216), 8), player) then -- 1
					ClimbLadder(5)
				end
			end 
			-- Mod support for Overcharge
			if GetMapName() == "mc1_higgue" then
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
			-- Mod support for Levitation
			if GetMapName() == "01_intro" then
				if vlua.find(Entities:FindAllInSphere(Vector(-7617,6622,-3216), 20), player) then -- 1
					ClimbLadder(-3070)
				end
			end
			if GetMapName() == "03_metrodynamo" then
				if vlua.find(Entities:FindAllInSphere(Vector(-13,-2719,-69), 3), player) then -- 1
					ClimbLadder(-20)
				end
			end
			if GetMapName() == "04_hehungers" then 
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
			if GetMapName() == "05_pleasantville" then 
				if vlua.find(Entities:FindAllInSphere(Vector(905,-698,7790), 5), player) then -- 1
					ClimbLadder(7895)
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
			if GetMapName() == "06_digdeep" then 
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
			if GetMapName() == "07_sectorx" then 
				if vlua.find(Entities:FindAllInSphere(Vector(-689,255,-236), 8), player) then -- 1
					ClimbLadder(-232)
				end
			end
			if GetMapName() == "08_burningquestions" then 
				if vlua.find(Entities:FindAllInSphere(Vector(158,248,-9128), 8), player) then -- 1
					ClimbLadder(-8982)
				elseif vlua.find(Entities:FindAllInSphere(Vector(158,216,-8960), 10), player) then -- 1r
					ClimbLadderSound()
					SendToConsole("fadein 0.2")
					SendToConsole("setpos_exact 159.402 252.582 -9184") 
				end
			end
			-- GoldenEye remake maps
			if GetMapName() == "goldeneye64_damver051" then
				if vlua.find(Entities:FindAllInSphere(Vector(-831,-138,121), 8), player) then -- 1
					ClimbLadder(260)
--				elseif vlua.find(Entities:FindAllInSphere(Vector(158,216,-8960), 10), player) then
--					ClimbLadderSound()
--					SendToConsole("fadein 0.2")
--					SendToConsole("setpos_exact 159.402 252.582 -9184") 
				end
			end
			
			
            if GetMapName() == "a3_distillery" then
                if vlua.find(Entities:FindAllInSphere(Vector(20,-518,211), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 20 -471 452")
                end

                if vlua.find(Entities:FindAllInSphere(Vector(515,1595,578), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 577 1597 668")
                end
            end

            if GetMapName() == "a1_intro_world" then
                if vlua.find(Entities:FindAllInSphere(Vector(648,-1757,-141), 10), player) then
                    ClimbLadder(-64)
                elseif vlua.find(Entities:FindAllInSphere(Vector(530,-2331,-84), 20), player) then
                    ClimbLadderSound()
                    SendToConsole("fadein 0.2")
                    SendToConsole("setpos_exact 574 -2328 -130")
                    SendToConsole("ent_fire 563_vent_door DisablePickup")
                    SendToConsole("-use")
                end
            end

            if GetMapName() == "a1_intro_world_2" then
                if vlua.find(Entities:FindAllInSphere(Vector(-1268, 573, -63), 10), player) and Entities:FindByName(nil, "balcony_ladder"):GetSequence() == "idle_open" then
                    ClimbLadder(80)
                end
            end

            if GetMapName() == "a2_pistol" then
                if vlua.find(Entities:FindAllInSphere(Vector(439, 896, 454), 10), player) then
                    ClimbLadder(540)
                end
            end
        end
    end, "", 0)

    if player_spawn_ev ~= nil then
        StopListeningToGameEvent(player_spawn_ev)
    end

    player_spawn_ev = ListenToGameEvent('player_activate', function(info)
        if not IsServer() then return end

        local loading_save_file = false
        local ent = Entities:FindByClassname(ent, "player_speedmod")
        if ent then
            loading_save_file = true
        else
            SpawnEntityFromTableSynchronous("player_speedmod", nil)
        end

        SendToConsole("mouse_pitchyaw_sensitivity " .. MOUSE_SENSITIVITY)
        SendToConsole("snd_remove_soundevent HL2Player.UseDeny")

        if GetMapName() == "startup" then
            SendToConsole("sv_cheats 1")
            SendToConsole("hidehud 96")
            SendToConsole("mouse_disableinput 1")
            SendToConsole("bind " .. PRIMARY_ATTACK .. " +use")
            if not loading_save_file then
                SendToConsole("ent_fire player_speedmod ModifySpeed 0")
                SendToConsole("setpos 0 -6154 6.473839")
                ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="140 140 140", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=10, ["x"]=-1, ["y"]=2})
                DoEntFireByInstanceHandle(ent, "SetText", "NoVR by GB_2 Development Team", 0, nil, nil)
                DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
            else
                GoToMainMenu()
            end
            ent = Entities:FindByName(nil, "startup_relay")
            ent:RedirectOutput("OnTrigger", "GoToMainMenu", ent)
        else
            SendToConsole("binddefaults")
            SendToConsole("bind " .. JUMP .. " jumpfixed")
            SendToConsole("bind " .. INTERACT .. " \"+use;useextra\"")
            SendToConsole("bind " .. NOCLIP .. " noclip")
            SendToConsole("bind " .. QUICK_SAVE .. " \"save quick;play sounds/ui/beepclear.vsnd;ent_fire text_quicksave showmessage\"")
            SendToConsole("bind " .. QUICK_LOAD .. " \"load quick\"")
            SendToConsole("bind " .. MAIN_MENU .. " \"map startup\"")
            SendToConsole("bind " .. PRIMARY_ATTACK .. " +customattack")
            SendToConsole("bind " .. SECONDARY_ATTACK .. " +customattack2")
            SendToConsole("bind " .. TERTIARY_ATTACK .. " +customattack3")
            SendToConsole("bind " .. RELOAD .. " +reload")
            SendToConsole("bind " .. QUICK_SWAP .. " lastinv")
            SendToConsole("bind " .. COVER_MOUTH .. " +covermouth")
            SendToConsole("bind " .. MOVE_FORWARD .. " +iv_forward")
            SendToConsole("bind " .. MOVE_BACK .. " +iv_back")
            SendToConsole("bind " .. MOVE_LEFT .. " +iv_left")
            SendToConsole("bind " .. MOVE_RIGHT .. " +iv_right")
            SendToConsole("bind " .. CROUCH .. " +iv_duck")
            SendToConsole("bind " .. SPRINT .. " +iv_sprint")
            SendToConsole("bind " .. PAUSE .. " pause")
            SendToConsole("hl2_sprintspeed 140")
            SendToConsole("hl2_normspeed 140")
            SendToConsole("r_drawviewmodel 0")
            SendToConsole("fov_desired 90")
            SendToConsole("sv_infinite_aux_power 1")
            SendToConsole("cc_spectator_only 1")
            SendToConsole("sv_gameinstructor_disable 1")
            SendToConsole("hud_draw_fixed_reticle 0")
            SendToConsole("r_drawvgui 1")
            SendToConsole("ent_fire *_locker_door_* DisablePickup")
            SendToConsole("ent_fire *_hazmat_crate_lid DisablePickup")
            SendToConsole("ent_fire electrical_panel_*_door* DisablePickup")
            SendToConsole("ent_fire *_washing_machine_door DisablePickup")
            SendToConsole("ent_fire *_fridge_door_* DisablePickup")
            SendToConsole("ent_fire *_mailbox_*_door_* DisablePickup")
            SendToConsole("ent_fire *_dumpster_lid DisablePickup")
            SendToConsole("ent_fire *_portaloo_seat DisablePickup")
            SendToConsole("ent_fire *_drawer_* DisablePickup")
            SendToConsole("ent_fire *_firebox_door DisablePickup")
            SendToConsole("ent_fire *_trashbin02_lid DisablePickup")
            SendToConsole("ent_fire *_car_door_rear DisablePickup")
            SendToConsole("ent_fire *_antenna_* DisablePickup")
            SendToConsole("ent_fire ticktacktoe_* DisablePickup")
            SendToConsole("ent_remove player_flashlight")
            SendToConsole("hl_headcrab_deliberate_miss_chance 0")
            SendToConsole("headcrab_powered_ragdoll 0")
            SendToConsole("combine_grenade_timer 4")
            SendToConsole("sk_max_grenade 9999")
            SendToConsole("sk_auto_reload_time 9999")
            SendToConsole("sv_gravity 500")
            SendToConsole("alias -covermouth \"ent_fire !player suppresscough 0;ent_fire_output @player_proxy onplayeruncovermouth;ent_fire lefthand disable;viewmodel_offset_y 0\"")
            SendToConsole("alias +covermouth \"ent_fire !player suppresscough 1;ent_fire_output @player_proxy onplayercovermouth;ent_fire lefthand enable;viewmodel_offset_y -20\"")
            SendToConsole("alias -customattack \"-iv_attack;slowgrenade\"")
            SendToConsole("alias +customattack +iv_attack")
            SendToConsole("mouse_disableinput 0")
            SendToConsole("-attack")
            SendToConsole("-attack2")
            SendToConsole("sk_headcrab_runner_health 69")
            SendToConsole("sk_plr_dmg_pistol 7")
            SendToConsole("sk_plr_dmg_ar2 9")
            SendToConsole("sk_plr_dmg_smg1 5")
            SendToConsole("player_use_radius 60")
            SendToConsole("hlvr_physcannon_forward_offset 0")
            -- TODO: Lower this when picking up very low mass objects
            SendToConsole("player_throwforce 500")

            if Entities:FindByClassname(nil, "prop_hmd_avatar") then
                ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="VR_SAVE_NOT_SUPPORTED"})
                DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                SendToConsole("play sounds/ui/beepclear.vsnd")
            end

            if not loading_save_file then
                SendToConsole("ent_fire npc_barnacle AddOutput \"OnGrab>held_prop_dynamic_override>DisableCollision>>0>-1\"")
                SendToConsole("ent_fire npc_barnacle AddOutput \"OnRelease>held_prop_dynamic_override>EnableCollision>>0>-1\"")
                local collidable_props = {
                    "models/props_c17/oildrum001.vmdl",
                    "models/props/plastic_container_1.vmdl",
                    "models/industrial/industrial_board_01.vmdl",
                    "models/industrial/industrial_board_02.vmdl",
                    "models/industrial/industrial_board_03.vmdl",
                    "models/industrial/industrial_board_04.vmdl",
                    "models/industrial/industrial_board_05.vmdl",
                    "models/industrial/industrial_board_06.vmdl",
                    "models/industrial/industrial_board_07.vmdl",
                    "models/industrial/industrial_chemical_barrel_02.vmdl",
                    "models/props/barrel_plastic_1.vmdl",
                    "models/props/barrel_plastic_1_open.vmdl",
                }
                ent = Entities:FindByClassname(nil, "prop_physics")
                while ent do
                    local model = ent:GetModelName()
                    if vlua.find(collidable_props, model) ~= nil then
                        local angles = ent:GetAngles()
                        local pos = ent:GetAbsOrigin()
                        local child = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["CollisionGroupOverride"]=5, ["solid"]=6, ["renderamt"]=0, ["model"]=model, ["origin"]= pos.x .. " " .. pos.y .. " " .. pos.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z})
                        child:SetParent(ent, "")
                    end
                    ent = Entities:FindByClassname(ent, "prop_physics")
                end
            end

            ent = Entities:FindByName(nil, "lefthand")
            if not ent then
                -- Hand for covering mouth animation
                local viewmodel = Entities:FindByClassname(nil, "viewmodel")
                local viewmodel_ang = viewmodel:GetAngles()
                local viewmodel_pos = viewmodel:GetAbsOrigin() + viewmodel_ang:Forward() * 24 - viewmodel_ang:Up() * 4
                ent = SpawnEntityFromTableSynchronous("prop_dynamic", {["targetname"]="lefthand", ["model"]="models/hands/alyx_glove_left.vmdl", ["origin"]= viewmodel_pos.x .. " " .. viewmodel_pos.y .. " " .. viewmodel_pos.z, ["angles"]= viewmodel_ang.x .. " " .. viewmodel_ang.y - 90 .. " " .. viewmodel_ang.z })
                DoEntFire("lefthand", "SetParent", "!activator", 0, viewmodel, nil)
                DoEntFire("lefthand", "Disable", "", 0, nil, nil)
            end

            ent = Entities:GetLocalPlayer()
            if ent then
                local angles = ent:GetAngles()
                SendToConsole("setang " .. angles.x .. " " .. angles.y .. " 0")
				local look_delta = QAngle(0, 0, 0)
                local move_delta = Vector(0, 0, 0)
                ent:SetThink(function()
					local viewmodel = Entities:FindByClassname(nil, "viewmodel")
                    local player = Entities:GetLocalPlayer()

                    local view_bob_x = sin(Time() * 8 % 6.28318530718) * move_delta.y / 4000
                    local view_bob_y = sin(Time() * 8 % 6.28318530718) * move_delta.x / 4000
                    local angle = player:GetAngles()
                    angle = QAngle(0, -angle.y, 0)
                    move_delta = RotatePosition(Vector(0, 0, 0), angle, player:GetVelocity())

                    local weapon_sway_x = Lerp(0.01, cvar_getf("viewmodel_offset_x"), RotationDelta(look_delta, viewmodel:GetAngles()).y) * 0.95
                    local weapon_sway_y = Lerp(0.01, cvar_getf("viewmodel_offset_y"), RotationDelta(look_delta, viewmodel:GetAngles()).x) * 0.95
                    look_delta = viewmodel:GetAngles()

                    cvar_setf("viewmodel_offset_x", view_bob_x + weapon_sway_x)
                    cvar_setf("viewmodel_offset_y", view_bob_y + weapon_sway_y)
					
                    local shard = Entities:FindByClassnameNearest("shatterglass_shard", Entities:GetLocalPlayer():GetCenter(), 12)
                    if shard then
                        DoEntFireByInstanceHandle(shard, "Break", "", 0, nil, nil)
                    end

                    if Entities:GetLocalPlayer():GetBoundingMaxs().z == 36 then
                        SendToConsole("cl_forwardspeed 86;cl_backspeed 86;cl_sidespeed 86")
                    else
                        SendToConsole("cl_forwardspeed 46;cl_backspeed 46;cl_sidespeed 46")
                    end
                    return 0
                end, "FixCrouchSpeed", 0)
            end

            SendToConsole("ent_remove text_quicksave")
            SendToConsole("ent_create env_message { targetname text_quicksave message GAMESAVED }")

            SendToConsole("ent_remove text_pistol_upgrade_aimdownsights")
            SendToConsole("ent_create env_message { targetname text_pistol_upgrade_aimdownsights message PISTOL_UPGRADE_AIMDOWNSIGHTS }")

            SendToConsole("ent_remove text_pistol_upgrade_burstfire")
            SendToConsole("ent_create env_message { targetname text_pistol_upgrade_burstfire message PISTOL_UPGRADE_BURSTFIRE }")

            SendToConsole("ent_remove text_shotgun_upgrade_doubleshot")
            SendToConsole("ent_create env_message { targetname text_shotgun_upgrade_doubleshot message SHOTGUN_UPGRADE_DOUBLESHOT }")

            SendToConsole("ent_remove text_shotgun_upgrade_grenadelauncher")
            SendToConsole("ent_create env_message { targetname text_shotgun_upgrade_grenadelauncher message SHOTGUN_UPGRADE_GRENADELAUNCHER }")

            SendToConsole("ent_remove text_smg_upgrade_aimdownsights")
            SendToConsole("ent_create env_message { targetname text_smg_upgrade_aimdownsights message SMG_UPGRADE_AIMDOWNSIGHTS }")

            SendToConsole("ent_remove text_resin")
            SendToConsole("ent_create game_text { targetname text_resin effect 2 spawnflags 1 color \"255 220 0\" color2 \"92 107 192\" fadein 0 fadeout 0.15 fxtime 0.25 holdtime 5 x 0.02 y -0.16 }")
			
			-- Fake Wrist Pockets, by Hypercycle
			SendToConsole("ent_remove text_pocketslots")
			--pocketSlotsMsgEnt = SpawnEntityFromTableSynchronous("game_text", { ["targetname"]="text_pocketslots", ["effect"]=2, ["spawnflags"]=1, ["color"]="255 220 0", ["color2"]="92 107 192", ["fadein"]=0, ["fadeout"]=0.15, ["channel"]=4, ["fxtime"]=0.25, ["holdtime"]=9999, ["x"]=0.15, ["y"]=-0.04 } )
            SendToConsole("ent_create game_text { targetname text_pocketslots effect 0 spawnflags 1 color \"255 220 0\" color2 \"0 0 0\" fadein 0.2 fadeout 0 channel 4 fxtime 0 holdtime 9999 x 0.15 y -0.028 }")
			
			SendToConsole("ent_remove text_pocketslots_empty")
			--pocketSlotsMsgEmptyEnt = SpawnEntityFromTableSynchronous("game_text", { ["targetname"]="text_pocketslots_empty", ["effect"]=2, ["spawnflags"]=1, ["color"]="255 220 0", ["color2"]="92 107 192", ["fadein"]=0, ["fadeout"]=0.15, ["channel"]=4, ["fxtime"]=0.25, ["holdtime"]=0.5, ["x"]=0.15, ["y"]=-0.04 } )
			SendToConsole("ent_create game_text { targetname text_pocketslots_empty effect 0 spawnflags 1 color \"255 220 0\" color2 \"92 107 192\" fadein 0 fadeout 0 channel 4 fxtime 0 holdtime 0 x 0.15 y -0.028 }")
			
			SendToConsole("sk_max_grenade 1") -- force only 1 grenade on hands
			SendToConsole("bind z pocketslots_healthpen") -- use health pen
			SendToConsole("bind x pocketslots_grenade") -- add HL2 grenade as a weapon
			SendToConsole("bind c pocketslots_dropitem") -- drop item from one of slots
			local player = Entities:GetLocalPlayer()
			local slot1TypeId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
			local slot2TypeId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
			if slot1TypeId ~= 0 or slot2TypeId ~= 0 then
				if not loading_save_file then
					if not Storage:LoadBoolean("pocketslots_slot1_keepacrossmaps") then
						player:Attribute_SetIntValue("pocketslots_slot1", 0)
						Storage:SaveString("pocketslots_slot1_objname", "")
						Storage:SaveString("pocketslots_slot1_objmodel", "")
						Storage:SaveBoolean("pocketslots_slot1_keepacrossmaps", false)
						print("[WristPockets] Item in slot #1 cannot be carried across maps, removed.")
					end -- erase teleported items on level change
					if not Storage:LoadBoolean("pocketslots_slot2_keepacrossmaps") then
						player:Attribute_SetIntValue("pocketslots_slot2", 0)
						Storage:SaveString("pocketslots_slot2_objname", "")
						Storage:SaveString("pocketslots_slot2_objmodel", "")
						Storage:SaveBoolean("pocketslots_slot2_keepacrossmaps", false)
						print("[WristPockets] Item in slot #2 cannot be carried across maps, removed.")
					end
				end
				local tempPocketSlotsMsgEnt = SpawnEntityFromTableSynchronous("game_text", { ["targetname"]="text_pocketslots", ["effect"]=0, ["spawnflags"]=1, ["color"]="255 220 0", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0, ["channel"]=4, ["fxtime"]=0, ["holdtime"]=9999, ["x"]=0.15, ["y"]=-0.028 } ) -- awful trick to avoid error on map start
				DoEntFireByInstanceHandle(tempPocketSlotsMsgEnt, "RunScriptFile", "wristpocketshud", 0, nil, nil)
			end -- TODO display slots after level boots, somehow it doesn't work
			
			-- pocketslots_slot1-2 values: 
			-- 0 - empty, 1 - health pen, 2 - grenade, 3 - battery, 4 - quest item, 5 - health station vial
			Convars:RegisterCommand("pocketslots_healthpen", function()
				local isPlayerAtFullHP = player:GetHealth() == player:GetMaxHealth()
				local pocketSlotId = 0
				local slot1ItemId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
				local slot2ItemId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
				if slot1ItemId == 0 and slot2ItemId == 0 then
					DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots_empty"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
					print("[WristPockets] Player don't have any health pens on inventory.")
				else 
					if slot2ItemId == 1 then
						pocketSlotId = 2 -- use slot 2 first
					elseif slot1ItemId == 1 then
						pocketSlotId = 1
					end
					if pocketSlotId ~= 0 then
						if not isPlayerAtFullHP then
							player:SetHealth(min(player:GetHealth() + cvar_getf("hlvr_health_vial_amount"), player:GetMaxHealth()))
							StartSoundEventFromPosition("HealthPen.Stab", player:EyePosition())
							StartSoundEventFromPosition("HealthPen.Success01", player:EyePosition())
							player:Attribute_SetIntValue("pocketslots_slot" .. pocketSlotId .. "" , 0)
							print("[WristPockets] Health pen has been used from slot #" .. pocketSlotId .. ".")
							DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
						else
							StartSoundEventFromPosition("HealthStation.Deny", player:EyePosition())
							print("[WristPockets] Player already is on full health.")
						end
					end 
				end
			end, "Toggles the inventory health pen, if exists", 0)		
			
			Convars:RegisterCommand("pocketslots_grenade", function()
				local pocketSlotId = 0
				local slot1ItemId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
				local slot2ItemId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
				if slot1ItemId == 0 and slot2ItemId == 0 then
					DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots_empty"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
					print("[WristPockets] Player don't have any grenades on inventory.")
				else 
					if slot2ItemId == 2 then
						pocketSlotId = 2 -- use slot 2 first
					elseif slot1ItemId == 2 then
						pocketSlotId = 1
					end
					if pocketSlotId ~= 0 then -- TODO player can take out grenade even if one already on hands, it goes nowhere!
						player:Attribute_SetIntValue("pocketslots_slot" .. pocketSlotId .. "" , 0)
						SendToConsole("give weapon_frag")
						local viewmodel = Entities:FindByClassname(nil, "viewmodel")
						viewmodel:RemoveEffects(32)
						StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
						SendToConsole("use weapon_frag")
						print("[WristPockets] Grenade has been armed from slot #" .. pocketSlotId .. ".")
						DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
					end 
				end
			end, "Take the grenade in hands, if any exists on pockets", 0)		
			
			Convars:RegisterCommand("pocketslots_dropitem", function()
				local pocketSlotId = 0
				local slot1ItemId = player:Attribute_GetIntValue("pocketslots_slot1", 0)
				local slot2ItemId = player:Attribute_GetIntValue("pocketslots_slot2", 0)
				if slot1ItemId == 0 and slot2ItemId == 0 then
					DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots_empty"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
					print("[WristPockets] Player don't have any items to drop.")
				else 
					if slot2ItemId ~= 0 then
						pocketSlotId = 2 -- use slot 2 first
					elseif slot1ItemId ~= 0 then
						pocketSlotId = 1
					end
					if pocketSlotId ~= 0 then
						local itemTypeId = player:Attribute_GetIntValue("pocketslots_slot" .. pocketSlotId .. "", 0)
						local player_ang = player:EyeAngles()
						local startVector = player:EyePosition()
						local traceTable =
						{
							startpos = startVector;
							endpos = startVector + RotatePosition(Vector(0,0,0), player_ang, Vector(40, 0, 0));
							ignore = player;
							mask =  33636363
						}
						TraceLine(traceTable)
	
						if traceTable.hit then -- TODO under certain angle you still can drop item into wall
							StartSoundEventFromPosition("HealthStation.Deny", player:EyePosition())
							print("[WristPockets] Cannot drop item - too close to obstacle.")
						else
							local itemsClasses = { "item_healthvial", "item_hlvr_grenade_frag", "item_hlvr_prop_battery", "prop_physics", "item_hlvr_health_station_vial" } -- starts from 1
							if itemTypeId == 3 or itemTypeId == 4 or itemTypeId == 5 then
								local entName = Storage:LoadString("pocketslots_slot" .. pocketSlotId .. "_objname")
								if entName ~= "" and not Storage:LoadBoolean("pocketslots_slot" .. pocketSlotId .. "_keepacrossmaps") then
									ent = Entities:FindByName(nil, entName)
									ent:EnableMotion() -- put item back from void, solution by FrostEpex
									ent:SetOrigin(traceTable.pos)
									ent:SetAngles(0,player_ang.y,0)
									ent:ApplyAbsVelocityImpulse(-GetPhysVelocity(ent))
								else
									ent = SpawnEntityFromTableSynchronous(itemsClasses[itemTypeId], { ["origin"]= traceTable.pos.x .. " " .. traceTable.pos.y .. " " .. traceTable.pos.z, ["angles"]= player_ang, ["targetname"]= Storage:LoadString("pocketslots_slot" .. pocketSlotId .. "_objname"), ["model"]= Storage:LoadString("pocketslots_slot" .. pocketSlotId .. "_objmodel") })
								end
								Storage:SaveString("pocketslots_slot" .. pocketSlotId .. "_objname", "")
								Storage:SaveString("pocketslots_slot" .. pocketSlotId .. "_objmodel", "")
								Storage:SaveBoolean("pocketslots_slot" .. pocketSlotId .. "_keepacrossmaps", false)
								--Storage:SaveVector("pocketslots_slot" .. pocketSlotId .. "_objrendercolor", Vector(0,0,0))
								DoEntFireByInstanceHandle(ent, "Use", "", 0, player, player) -- pickup quest item
							else -- generic object
								ent = SpawnEntityFromTableSynchronous(itemsClasses[itemTypeId], {["origin"]= traceTable.pos.x .. " " .. traceTable.pos.y .. " " .. traceTable.pos.z, ["angles"]= player_ang })
							end
						
							player:Attribute_SetIntValue("pocketslots_slot" .. pocketSlotId .. "" , 0)
							print("[WristPockets] Player has dropped item (Type " .. itemTypeId .. ") from slot #" .. pocketSlotId .. ".")
							DoEntFireByInstanceHandle(Entities:FindByName(nil, "text_pocketslots"), "RunScriptFile", "wristpocketshud", 0, nil, nil)
						end
					end 
				end
			end, "Drop one item from pockets, if any exists", 0)

            if GetMapName() == "a1_intro_world" then
                if not loading_save_file then
                    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
                    SendToConsole("mouse_disableinput 1")
                    SendToConsole("give weapon_bugbait")
                    SendToConsole("hidehud 4")
                    SendToConsole("bind " .. COVER_MOUTH .. " \"\"")
                    SendToConsole("ent_fire tv_apartment_decoy_door DisableCollision")

                    ent = Entities:FindByName(nil, "relay_start_intro_text")
                    ent:RedirectOutput("OnTrigger", "DisableUICursor", ent)
                    ent = Entities:FindByName(nil, "relay_start_dossier")
                    ent:RedirectOutput("OnTrigger", "DisableUICursor", ent)

                    ent = Entities:FindByName(nil, "relay_teleported_to_refuge")
                    ent:RedirectOutput("OnTrigger", "MoveFreely", ent)

                    SendToConsole("ent_create env_message { targetname text_quicksave_tutorial message QUICKSAVE }")
                    ent = Entities:FindByClassnameNearest("trigger_once", Vector(-240, 1688, 208), 20)
                    ent:RedirectOutput("OnTrigger", "ShowQuickSaveTutorial", ent)

                    ent = Entities:FindByName(nil, "prop_dogfood")
                    local angles = ent:GetAngles()
                    ent:SetAngles(180,angles.y,angles.z)
                    ent:SetOrigin(ent:GetOrigin() + Vector(0,0,10))

                    ent = Entities:FindByName(nil, "relay_heist_monitors_callincoming")
                    ent:RedirectOutput("OnTrigger", "ShowInteractTutorial", ent)

                    SendToConsole("ent_create env_message { targetname text_ladder message LADDER }")
                    ent = Entities:FindByName(nil, "51_ladder_hint_trigger")
                    ent:RedirectOutput("OnTrigger", "ShowLadderTutorial", ent)
                else
                    MoveFreely()
                end
            elseif GetMapName() == "a1_intro_world_2" then
                if not loading_save_file then
                    ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER1_TITLE"})
                    DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                    SendToConsole("ent_create env_message { targetname text_crouchjump message CROUCHJUMP }")
                    SendToConsole("ent_create env_message { targetname text_sprint message SPRINT }")
                end

                ent = Entities:GetLocalPlayer()
                if ent:Attribute_GetIntValue("pistol", 0) == 0 then
                    if ent:Attribute_GetIntValue("gravity_gloves", 0) == 0 then
                        SendToConsole("hidehud 96")
                    else
                        SendToConsole("hidehud 0")
                        ent:SetThink(function()
                            SendToConsole("hidehud 1")
                        end, "", 0)
                    end
                    SendToConsole("give weapon_bugbait")
                else
                    SendToConsole("hidehud 64")
                    SendToConsole("r_drawviewmodel 1")
                end

                SendToConsole("combine_grenade_timer 7")

                if not loading_save_file then
                    ent = Entities:FindByName(nil, "trigger_post_gate")
                    ent:RedirectOutput("OnTrigger", "ShowSprintTutorial", ent)

                    ent = Entities:FindByName(nil, "gate_ammo_trigger")
                    local origin = ent:GetOrigin()
                    local angles = ent:GetAngles()
                    ent = SpawnEntityFromTableSynchronous("trigger_detect_bullet_fire", {["model"]="maps/a1_intro_world_2/entities/gate_ammo_trigger_621_2249_345.vmdl", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z})
                    ent:RedirectOutput("OnDetectedBulletFire", "CheckTutorialPistolEmpty", ent)

                    ent = Entities:FindByName(nil, "scavenge_trigger")
                    ent:RedirectOutput("OnTrigger", "ShowCrouchJumpTutorial", ent)

                    ent = Entities:FindByName(nil, "hint_crouch_trigger")
                    ent:RedirectOutput("OnStartTouch", "GetOutOfCrashedVan", ent)

                    ent = Entities:FindByName(nil, "relay_weapon_pistol_fakefire")
                    ent:RedirectOutput("OnTrigger", "RedirectPistol", ent)
                end
            else
                SendToConsole("hidehud 64")
                SendToConsole("r_drawviewmodel 1")
                Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 1)
				
				-- Mod support for Extra-Ordinary Value
				if GetMapName() == "youreawake" then
					isModActive = true
				elseif GetMapName() == "seweroutskirts" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight") -- too dark on some places
					if not loading_save_file then -- Start point is bugged here
						SendToConsole("setpos_exact -40 -496 105") 
						SendToConsole("ent_create env_message { targetname text_flashlight message FLASHLIGHT }")
					end
					ent = Entities:FindByName(nil, "freds1v")
					ent:RedirectOutput("OnSoundFinished", "ModCommon_ShowFlashlightTutorial", ent)
				elseif GetMapName() == "facilityredux" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then -- Start point is bugged here
						SendToConsole("setpos_exact -1734 -736 260") 
					end
				elseif GetMapName() == "helloagain" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					ent = Entities:FindByName(nil, "1001_doorfade")
					ent:RedirectOutput("OnBeginFade", "ModCommon_DisablePlayerActions", ent)
				-- Mod support for Overcharge
				elseif GetMapName() == "mc1_higgue" then
					isModActive = true
					SendToConsole("hl2_sprintspeed 180") -- pass jump on the end
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then
						SendToConsole("r_drawviewmodel 0")
						SendToConsole("hidehud 96")
					end
					ent = Entities:FindByName(nil, "fightfinale_end_seqrelay")
					ent:RedirectOutput("OnTrigger", "ModCommon_DisablePlayerActions", ent)
				-- Mod support for Belomorskaya Station
				elseif GetMapName() == "belomorskaya" then
					isModActive = true
					Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 0)
					ent = Entities:FindByName(nil, "flare_trigger_01")
					if ent then
						ent:RedirectOutput("OnTrigger", "ModBelomorskaya_EquipFlare", ent)
					end
					ent = Entities:FindByName(nil, "flare_turn_off")
					ent:RedirectOutput("OnTrigger", "ModBelomorskaya_RemoveFlare", ent)
					ent = Entities:FindByName(nil, "ending_start")
					ent:RedirectOutput("OnTrigger", "ModCommon_DisablePlayerActions", ent)
				-- Mod support for Levitation
				elseif GetMapName() == "01_intro" then
					isModActive = true
					SendToConsole("r_drawviewmodel 0")
					SendToConsole("hidehud 96") -- hide hud for intro
					if not loading_save_file then
						SendToConsole("ent_fire player_speedmod ModifySpeed 0")
					end
					ent = Entities:FindByName(nil, "vo_alyx0b")
					ent:RedirectOutput("OnSoundFinished", "ModLevitation_AllowMovement", ent)
				elseif GetMapName() == "02_notimelikenow" then
					isModActive = true
					if not loading_save_file then -- Start point collisions can be bugged here
						SendToConsole("setpos_exact -304.557 331.460 -761")
					end
				elseif GetMapName() == "03_metrodynamo" then
					isModActive = true
				elseif GetMapName() == "04_hehungers" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					SendToConsole("ent_create env_message { targetname text_flashlight message FLASHLIGHT }")
					if not loading_save_file then -- Start point collisions can be bugged here
						SendToConsole("setpos_exact 0.472 442.295 -100") 
						ModLevitation_SpawnWorkaroundBottlesForJeff()
					end
					ent = Entities:FindByName(nil, "introjoke_rus")
					ent:RedirectOutput("OnSoundFinished", "ModCommon_ShowFlashlightTutorial", ent)
					-- TODO: Hand covering mouth script required to be here!
				elseif GetMapName() == "05_pleasantville" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then -- Start point is bugged here
						SendToConsole("setpos_exact 868.050 -2345.072 7560") 
					end
				elseif GetMapName() == "06_digdeep" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then -- Start point is bugged here
						SendToConsole("setpos_exact 504.324 -3157.083 631") 
					end
					ent = Entities:FindByName(nil, "relay_vort_magic")
					ent:RedirectOutput("OnTrigger", "ModLevitation_Map6EndingTransition", ent)
				elseif GetMapName() == "07_sectorx" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then -- Start point is misplaced
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
				elseif GetMapName() == "08_burningquestions" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					SendToConsole("r_drawviewmodel 0")
					if not loading_save_file then -- Start point is misplaced
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
				elseif GetMapName() == "red_dust" then
					isModActive = true
					if not loading_save_file then
						SendToConsole("give weapon_pistol") -- loadout as map intended
						SendToConsole("give weapon_shotgun")
						SendToConsole("give weapon_smg1")
						SendToConsole("hlvr_addresources 20 60 8 100")
					end
				elseif GetMapName() == "back_alley" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then
						SendToConsole("hlvr_addresources 0 0 0 10")
					end
					-- ent_fire 91_cfence_relay_disable trigger
					-- bloodborne_ladder
					-- ladders
					-- ending elevator button
				elseif GetMapName() == "e3_ship" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then
						SendToConsole("give weapon_pistol") -- loadout as map intended
						SendToConsole("give weapon_shotgun")
						SendToConsole("give weapon_smg1")
						SendToConsole("hlvr_addresources 20 30 6 10")
					end
				elseif GetMapName() == "goldeneye64_damver051" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then
						SendToConsole("give weapon_pistol") -- loadout as map intended
						SendToConsole("hlvr_addresources 40 0 0 5")
					end
					ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(81, -14, 510), 25)
					ent:SetEntityName("novr_garage_switch")
					ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(155, -202, 976), 25)
					ent:SetEntityName("novr_tower_switch")
				elseif GetMapName() == "goldeneye64dampart2_ver052_master" then
					isModActive = true
					SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
					if not loading_save_file then
						SendToConsole("hidehud 96") -- TODO find intro triggers
						SendToConsole("hlvr_addresources 40 0 0 0")
					end
					ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(-1226, 28, 540), 25)
					ent:SetEntityName("novr_starthangar_switch")
					-- TODO replace all generic weapon items!
					ent = Entities:FindByClassnameNearest("prop_animinteractable", Vector(3987, 33, 539), 25)
					ent:SetEntityName("novr_endhangar_switch")
				elseif isModActive == false then -- Default NoVR-mod weapon rule
					SendToConsole("give weapon_pistol")
				end

                if GetMapName() == "a2_quarantine_entrance" then
                    if not loading_save_file then
                        ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER2_TITLE"})
                        DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)

                        SendToConsole("setpos 3215 2456 465")
                        SendToConsole("ent_fire traincar_border_trigger Disable")
                    end
                elseif GetMapName() == "a2_pistol" then
                    SendToConsole("ent_fire *_rebar EnablePickup")
                elseif GetMapName() == "a2_headcrabs_tunnel" then
                    if not loading_save_file then
                        ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER3_TITLE"})
                        DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                    end

                    ent = Entities:GetLocalPlayer()
                    if ent:Attribute_GetIntValue("has_flashlight", 0) == 1 then
                        SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
                    end
                elseif GetMapName() ~= "a2_hideout" then
                    if isModActive == false then --Default NoVR-mod weapon rule
						SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
						SendToConsole("give weapon_shotgun")
					end

                    if GetMapName() == "a2_drainage" then
                        SendToConsole("ent_fire wheel_socket SetScale 4")
                        SendToConsole("ent_fire wheel2_socket SetScale 4")
                        SendToConsole("ent_fire wheel_physics DisablePickup")
                        ent = Entities:FindByClassnameNearest("npc_barnacle", Vector(941, -1666, 255), 10)
                        DoEntFireByInstanceHandle(ent, "AddOutput", "OnRelease>wheel_physics>EnablePickup>>0>1", 0, nil, nil)
                    elseif GetMapName() == "a2_train_yard" then
                        if not loading_save_file then
                            ent = SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["renderamt"]=0, ["model"]="models/props/industrial_door_1_40_92_white_temp.vmdl", ["origin"]="-1080 3200 -350", ["angles"]="0 12 0", ["modelscale"]=5, ["targetname"]="elipreventfall"})
                            ent = Entities:FindByName(nil, "eli_rescue_3_relay")
                            ent:RedirectOutput("OnTrigger", "RemoveEliPreventFall", ent)
                        end
                    elseif GetMapName() == "a3_hotel_interior_rooftop" then
                        ent = Entities:FindByClassname(nil, "npc_headcrab_runner")
                        if not ent then
                            SendToConsole("ent_create npc_headcrab_runner { origin \"1657 -1949 710\" }")
                        end
                    elseif GetMapName() == "a3_station_street" then
                        if not loading_save_file then
                            ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER4_TITLE"})
                            DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                        end
                    elseif GetMapName() == "a3_hotel_lobby_basement" then
                        if not loading_save_file then
                            ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER5_TITLE"})
                            DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                        end
                    elseif GetMapName() == "a3_hotel_street" then
                        SendToConsole("ent_fire item_hlvr_weapon_tripmine OnHackSuccessAnimationComplete")
                        ent = Entities:FindByClassnameNearest("item_hlvr_weapon_tripmine", Vector(775, 1677, 248), 10)
                        if ent then
                            ent:Kill()
                        end
                        ent = Entities:FindByClassnameNearest("item_hlvr_weapon_tripmine", Vector(1440, 1306, 331), 10)
                        if ent then
                            ent:Kill()
                        end
                    elseif GetMapName() == "a3_c17_processing_plant" then
                        SendToConsole("ent_fire item_hlvr_weapon_tripmine OnHackSuccessAnimationComplete")

                        if not loading_save_file then
                            ent = SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["renderamt"]=0, ["model"]="models/props/construction/construction_yard_lift.vmdl", ["origin"]="-1984 -2456 154", ["angles"]="0 270 0", ["parentname"]="pallet_crane_platform"})

                            ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER6_TITLE"})
                            DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                        end

                        ent = Entities:FindByClassnameNearest("item_hlvr_weapon_tripmine", Vector(-896, -3768, 348), 10)
                        if ent then
                            ent:Kill()
                        end
                        ent = Entities:FindByClassnameNearest("item_hlvr_weapon_tripmine", Vector(-1165, -3770, 158), 10)
                        if ent then
                            ent:Kill()
                        end
                        ent = Entities:FindByClassnameNearest("item_hlvr_weapon_tripmine", Vector(-1105, -4058, 163), 10)
                        if ent then
                            ent:Kill()
                        end
                    elseif GetMapName() == "a3_distillery" then
                        ent = Entities:FindByName(nil, "exit_counter")
                        ent:RedirectOutput("OnHitMax", "EnablePlugLever", ent)

                        if not loading_save_file then
                            ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER7_TITLE"})
                            DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)

                            ent = Entities:FindByName(nil, "11578_2547_relay_koolaid_setup")
                            ent:RedirectOutput("OnTrigger", "FixJeffBatteryPuzzle", ent)

                            SendToConsole("ent_create env_message { targetname text_covermouth message COVERMOUTH }")
                            ent = Entities:FindByName(nil, "11632_223_cough_volume")
                            ent:RedirectOutput("OnStartTouch", "ShowCoverMouthTutorial", ent)
                        end
                    else
                        if GetMapName() == "a4_c17_zoo" then
                            if not loading_save_file then
                                ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER8_TITLE"})
                                DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                            end

                            ent = Entities:FindByName(nil, "relay_power_receive")
                            ent:RedirectOutput("OnTrigger", "MakeLeverUsable", ent)

                            ent = Entities:FindByClassnameNearest("trigger_multiple", Vector(5380, -1848, -117), 10)
                            ent:RedirectOutput("OnStartTouch", "CrouchThroughZooHole", ent)

                            SendToConsole("ent_fire port_health_trap Disable")
                            SendToConsole("ent_fire health_trap_locked_door Unlock")
                            SendToConsole("ent_fire 589_toner_port_5 Disable")
                            SendToConsole("ent_fire @prop_phys_portaloo_door DisablePickup")
                        elseif GetMapName() == "a4_c17_tanker_yard" then
                            SendToConsole("ent_fire elev_hurt_player_* Kill")

                            if not loading_save_file then
                                ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER9_TITLE"})
                                DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                            end
                        elseif GetMapName() == "a4_c17_water_tower" then
                            if not loading_save_file then
                                ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER10_TITLE"})
                                DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
                            end
                        elseif GetMapName() == "a4_c17_parking_garage" then
                            SendToConsole("ent_fire falling_cabinet_door DisablePickup")

                            ent = Entities:FindByName(nil, "relay_ufo_beam_surge")
                            ent:RedirectOutput("OnTrigger", "UnequipCombinGunMechanical", ent)

                            ent = Entities:FindByName(nil, "relay_enter_ufo_beam")
                            ent:RedirectOutput("OnTrigger", "EnterVaultBeam", ent)
                        elseif GetMapName() == "a5_vault" then
                            SendToConsole("ent_fire player_speedmod ModifySpeed 1")
                            SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_ar2")
                            SendToConsole("r_drawviewmodel 0")

                            if not loading_save_file then
                                ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="CHAPTER11_TITLE"})
                                DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)

                                SendToConsole("ent_create env_message { targetname text_vortenergy message VORTENERGY }")
                            end

                            ent = Entities:FindByName(nil, "longcorridor_outerdoor1")
                            ent:RedirectOutput("OnFullyClosed", "GiveVortEnergy", ent)
                            ent:RedirectOutput("OnFullyClosed", "ShowVortEnergyTutorial", ent)

                            ent = Entities:FindByName(nil, "longcorridor_innerdoor")
                            ent:RedirectOutput("OnFullyClosed", "RemoveVortEnergy", ent)

                            ent = Entities:FindByName(nil, "longcorridor_energysource_01_activate_relay")
                            ent:RedirectOutput("OnTrigger", "GiveVortEnergy", ent)
                        elseif GetMapName() == "a5_ending" then
                            SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_ar2")
                            SendToConsole("r_drawviewmodel 0")
                            SendToConsole("bind " .. FLASHLIGHT .. " \"\"")

                            ent = Entities:FindByName(nil, "relay_advisor_void")
                            ent:RedirectOutput("OnTrigger", "GiveAdvisorVortEnergy", ent)

                            ent = Entities:FindByName(nil, "relay_first_credits_start")
                            ent:RedirectOutput("OnTrigger", "StartCredits", ent)

                            ent = Entities:FindByName(nil, "vcd_ending_eli")
                            ent:RedirectOutput("OnTrigger3", "EndCredits", ent)
                        end
                    end
                end
            end
        end

        if INVERT_MOUSE_Y then
            SendToConsole("bind MOUSE_Y !iv_pitch")
        end
    end, nil)

    function GoToMainMenu(a, b)
        SendToConsole("setpos_exact 817 -80 -26")
        SendToConsole("setang_exact 0.4 0 0")
        SendToConsole("mouse_disableinput 0")
        SendToConsole("hidehud 96")
    end

    function MoveFreely(a, b)
        SendToConsole("mouse_disableinput 0")
        SendToConsole("ent_fire player_speedmod ModifySpeed 1")
        SendToConsole("hidehud 96")
        SendToConsole("bind " .. COVER_MOUTH .. " +covermouth")
    end

    function DisableUICursor(a, b)
        SendToConsole("ent_fire point_clientui_world_panel IgnoreUserInput")
    end

    function GetOutOfCrashedVan(a, b)
        SendToConsole("fadein 0.2")
        SendToConsole("setpos_exact -1408 2307 -104")
        SendToConsole("ent_fire 4962_car_door_left_front open")
    end

    function RedirectPistol(a, b)
        ent = Entities:FindByName(nil, "weapon_pistol")
        ent:RedirectOutput("OnPlayerPickup", "EquipPistol", ent)
    end

    function GivePistol(a, b)
        SendToConsole("ent_fire pistol_give_relay trigger")
    end

    function EquipPistol(a, b)
        SendToConsole("ent_fire_output weapon_equip_listener OnEventFired")
        SendToConsole("hidehud 64")
        SendToConsole("r_drawviewmodel 1")
        SendToConsole("ent_fire item_hlvr_weapon_energygun kill")
        Entities:GetLocalPlayer():Attribute_SetIntValue("pistol", 1)
    end

    function RemoveEliPreventFall(a, b)
        ent = Entities:FindByName(nil, "elipreventfall")
        ent:Kill()
    end

    function MakeLeverUsable(a, b)
        ent = Entities:FindByName(nil, "door_reset")
        ent:Attribute_SetIntValue("used", 0)
    end

    function CrouchThroughZooHole(a, b)
        SendToConsole("fadein 0.2")
        SendToConsole("setpos 5393 -1960 -125")
    end

    function ClimbLadder(height)
        local ent = Entities:GetLocalPlayer()
        local ticks = 0
        ent:SetThink(function()
            if ent:GetOrigin().z > height then
                ent:SetVelocity(Vector(ent:GetForwardVector().x, ent:GetForwardVector().y, 0):Normalized() * 150)
            else
                ent:SetVelocity(Vector(0, 0, 0))
                ent:SetOrigin(ent:GetOrigin() + Vector(0, 0, 2))
                ticks = ticks + 1
                if ticks == 25 then
                    SendToConsole("snd_sos_start_soundevent Step_Player.Ladder_Single")
                    ticks = 0
                end
                return 0
            end
        end, "ClimbUp", 0)
    end

    function ClimbLadderSound()
        local sounds = 0
        local player = Entities:GetLocalPlayer()
        player:SetThink(function()
            if sounds < 3 then
                SendToConsole("snd_sos_start_soundevent Step_Player.Ladder_Single")
                sounds = sounds + 1
                return 0.15
            end
        end, "LadderSound", 0)
    end

    function FixJeffBatteryPuzzle()
        SendToConsole("ent_fire @barnacle_battery kill")
        SendToConsole("ent_create item_hlvr_prop_battery { origin \"959 1970 427\" }")
        SendToConsole("ent_fire @crank_battery kill")
        SendToConsole("ent_create item_hlvr_prop_battery { origin \"1325 2245 435\" }")
        SendToConsole("ent_fire 11478_6233_math_count_wheel_installment SetHitMax 1")
    end

    function ShowInteractTutorial()
        ent = SpawnEntityFromTableSynchronous("env_message", {["message"]="INTERACT"})
        DoEntFireByInstanceHandle(ent, "ShowMessage", "", 0, nil, nil)
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function ShowLadderTutorial()
        SendToConsole("ent_fire text_ladder ShowMessage")
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function CheckTutorialPistolEmpty()
        local player = Entities:GetLocalPlayer()
        player:Attribute_SetIntValue("pistol_magazine_ammo", player:Attribute_GetIntValue("pistol_magazine_ammo", 0) - 1)
        if player:Attribute_GetIntValue("pistol_magazine_ammo", 0) % 10 == 0 then
            SendToConsole("ent_fire_output pistol_chambered_listener OnEventFired")
        end
    end

    function ShowSprintTutorial()
        SendToConsole("ent_fire text_sprint ShowMessage")
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function ShowCrouchJumpTutorial()
        SendToConsole("ent_fire text_crouchjump ShowMessage")
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function ShowCoverMouthTutorial()   
        if cvar_getf("viewmodel_offset_y") == 0 then
            SendToConsole("ent_fire text_covermouth ShowMessage")
            SendToConsole("play sounds/ui/beepclear.vsnd")
        end
    end

    function ShowQuickSaveTutorial()   
        SendToConsole("ent_fire text_quicksave_tutorial ShowMessage")
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function EnablePlugLever()
        Entities:GetLocalPlayer():Attribute_SetIntValue("plug_lever", 1)
    end

    function UnequipCombinGunMechanical()
        SendToConsole("ent_fire player_speedmod ModifySpeed 1")
        SendToConsole("ent_fire combine_gun_mechanical ClearParent")
        SendToConsole("bind " .. PRIMARY_ATTACK .. " +attack")
        local ent = Entities:FindByName(nil, "combine_gun_mechanical")
        SendToConsole("ent_setpos " .. ent:entindex() .. " 1479.722 385.634 964.917")
        SendToConsole("r_drawviewmodel 1")
    end

    function EnterVaultBeam()
        SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_ar2;ent_remove weapon_frag")
        SendToConsole("r_drawviewmodel 0")
        SendToConsole("hidehud 4")
        SendToConsole("ent_fire player_speedmod ModifySpeed 0")
    end

    function ShowVortEnergyTutorial()
        SendToConsole("ent_fire text_vortenergy ShowMessage")
        SendToConsole("play sounds/ui/beepclear.vsnd")
    end

    function GiveVortEnergy(a, b)
        SendToConsole("bind " .. PRIMARY_ATTACK .. " shootvortenergy")
        SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_ar2;ent_remove weapon_frag")
        SendToConsole("r_drawviewmodel 0")
    end

    function RemoveVortEnergy(a, b)
        SendToConsole("bind " .. PRIMARY_ATTACK .. " +attack")
        SendToConsole("r_drawviewmodel 1")
        SendToConsole("give weapon_frag")
    end

    function GiveAdvisorVortEnergy(a, b)
        SendToConsole("bind " .. PRIMARY_ATTACK .. " shootadvisorvortenergy")
    end

    function StartCredits(a, b)
        SendToConsole("mouse_disableinput 1")
    end

    function EndCredits(a, b)
        SendToConsole("mouse_disableinput 0")
    end
	
	function sin(x)
        local result = 0
        local sign = 1
        local term = x

        for i = 1, 10 do -- increase the number of iterations for more accuracy
          result = result + sign * term
          sign = -sign
          term = term * x * x / ((2 * i) * (2 * i + 1))
        end

        return result
    end
	
	function dump(o)
        if type(o) == 'table' then
           local s = '{ '
           for k,v in pairs(o) do
              if type(k) ~= 'number' then k = '"'..k..'"' end
              s = s .. '['..k..'] = ' .. dump(v) .. ','
           end
           return s .. '} '
        else
           return tostring(o)
        end
    end
	
	function ModCommon_ShowFlashlightTutorial()
        SendToConsole("ent_fire text_flashlight ShowMessage")
        SendToConsole("play play sounds/ui/beepclear.vsnd")
    end
	
	function ModCommon_DisablePlayerActions(a, b)
		SendToConsole("r_drawviewmodel 0")
		SendToConsole("hidehud 4")
		SendToConsole("ent_fire player_speedmod ModifySpeed 0")
		SendToConsole("bind MOUSE1 \"\"")
	end
	
	function ModBelomorskaya_EquipFlare(a, b) -- TODO works bad
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
	
	function ModBelomorskaya_RemoveFlare(a, b)
		ent = Entities:FindByName(nil, "flare_01")
		if ent then
			ent:Kill()
		end
	end
	
	function ModLevitation_AllowMovement(a, b)
		SendToConsole("ent_fire player_speedmod ModifySpeed 1")
	end
	
	function ModLevitation_SpawnWorkaroundBottlesForJeff()
		SpawnEntityFromTableSynchronous("prop_physics", {["solid"]=6, ["model"]="models/props/beer_bottle_1.vmdl", ["origin"]="-102.158 -4415.675 -151"})
		SpawnEntityFromTableSynchronous("prop_physics", {["solid"]=6, ["model"]="models/props/beer_bottle_1.vmdl", ["origin"]="-102.158 -4410.675 -151"})
	end
	
	function ModLevitation_Map5SpawnWorkaroundJumpStructure()
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/tanks/vertical_tank.vmdl", ["origin"]="685.276 -701.073 7780", ["angles"]="0 0 0"})
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/industrial_small_tank_1.vmdl", ["origin"]="685.276 -701.073 7720", ["angles"]="0 0 0", ["skin"]=2})
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["model"]="models/props/industrial_small_tank_1.vmdl", ["origin"]="685.276 -701.073 7723", ["angles"]="0 0 180", ["skin"]=2})
	end
	
	function ModLevitation_Map6EndingTransition(a, b)
		SendToConsole("r_drawviewmodel 0")
		SendToConsole("hidehud 4")
		SendToConsole("bind MOUSE1 \"\"")
	end
	
	function ModLevitation_Map7SpawnWorkaroundBattery()
		SpawnEntityFromTableSynchronous("item_hlvr_prop_battery", {["targetname"]="novr_workaround_battery", ["solid"]=6, ["origin"]="1121.042 -530.784 344"})
	end
	
	function ModLevitation_Map7SpawnWorkaroundBattery2()
		SpawnEntityFromTableSynchronous("item_hlvr_prop_battery", {["targetname"]="novr_workaround_battery2", ["solid"]=6, ["origin"]="-666.762 493.066 -439.9"})
	end
	
	function ModLevitation_Map7SpawnWorkaroundJumpStructure()
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-264.164 -1015.459 486", ["angles"]="0 0 0", ["skin"]=0})
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-268.164 -1015.459 518.5", ["angles"]="0 21 0", ["skin"]=0})
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-270.164 -1015.459 551", ["angles"]="0 7 0", ["skin"]=0})
		SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["alpha"]=0, ["model"]="models/props/plastic_container_1.vmdl", ["origin"]="-272.164 -1015.459 583.5", ["angles"]="0 -12 0", ["skin"]=0})
	end
	
	function ModLevitation_Map7EnterCombineTrap()
        SendToConsole("ent_remove weapon_pistol;ent_remove weapon_shotgun;ent_remove weapon_smg1;ent_remove weapon_frag")
        SendToConsole("r_drawviewmodel 0")
    end
	
	function ModLevitation_RemoveVortPowers(a, b)
		SendToConsole("bind MOUSE1 \"\"")
	end
	
	function ModLevitation_Map8FinaleStopMove(a, b)
		SendToConsole("hidehud 4")
		SendToConsole("ent_fire player_speedmod ModifySpeed 0")
	end
	
	Convars:RegisterCommand("novr_goldeneye_dam1_leavecombinegun", function()
		ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="aaa", ["dialog_layout_name"]="file://{resources}/layout/game_menus/game_menu_main.xml" })
        SendToConsole("ent_fire player_speedmod ModifySpeed 1")
        SendToConsole("ent_fire 4423_combine_gun_mechanical ClearParent")
		SendToConsole("ent_fire 4424_combine_gun_mechanical ClearParent")
        SendToConsole("bind " .. PRIMARY_ATTACK .. " +customattack")
        local ent = Entities:FindByName(nil, "4423_combine_gun_mechanical")
        SendToConsole("ent_setpos " .. ent:entindex() .. " -87.649 82.855 493.961")
        local ent = Entities:FindByName(nil, "4424_combine_gun_mechanical")
        SendToConsole("ent_setpos " .. ent:entindex() .. " -12.135 -149.014 500.586")
        SendToConsole("r_drawviewmodel 1")
    end, "", 0)
end
