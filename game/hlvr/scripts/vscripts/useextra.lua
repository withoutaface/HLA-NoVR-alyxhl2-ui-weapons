DoIncludeScript("bindings.lua", nil)

local map = GetMapName()
local class = thisEntity:GetClassname()
local name = thisEntity:GetName()
local model = thisEntity:GetModelName()
local player = Entities:GetLocalPlayer()
-- Mod support by Hypercycle

if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
    thisEntity:Attribute_SetIntValue("toggle", 1)
else
    thisEntity:Attribute_SetIntValue("toggle", 0)
end

if not vlua.find(model, "doorhandle") and name ~= "@pod_shell" and name ~= "589_panel_switch" and name ~= "tc_door_control" and (class == "item_health_station_charger" or (class == "prop_animinteractable" and not vlua.find(name, "5628_2901_barricade_door")) or (class == "item_hlvr_combine_console_rack" and Entities:FindAllByClassnameWithin("baseanimating", thisEntity:GetCenter(), 3)[2]:GetCycle() == 1)) and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    if vlua.find(name, "plug") and player:Attribute_GetIntValue("plug_lever", 0) == 0 then
        return
    end

    if vlua.find(name, "slide_train_door") and Entities:FindByClassnameNearest("phys_constraint", thisEntity:GetCenter(), 20) then
        return
    end

    if name == "12712_shotgun_wheel" and Entities:FindByNameNearest("12712_shotgun_bar_for_wheel", thisEntity:GetCenter(), 20) then
        return
    end

    if name == "greenhouse_door" then
        if string.format("%.2f", thisEntity:GetCycle()) ~= "0.05" then
            return
        end
    end
    
    if class == "prop_animinteractable" and model == "models/props_subway/scenes/desk_lever.vmdl" then
        thisEntity:FireOutput("OnCompletionB", nil, nil, nil, 0)
    elseif name ~= "plug_console_starter_lever" then
        if name == "track_switch_lever" then
            SendToConsole("ent_fire track_switch_lever SetCompletionValue 0.35 10")
            SendToConsole("ent_fire train_switch_reset_relay Trigger 0 10")
            SendToConsole("ent_fire traincar_01_hackplug Alpha 0")
        else
            thisEntity:Attribute_SetIntValue("used", 1)
        end
    end

    if class == "item_health_station_charger" or class == "item_hlvr_combine_console_rack" then
        DoEntFireByInstanceHandle(thisEntity, "EnableOnlyRunForward", "", 0, nil, nil)
    end

    local count = 0
    local is_console = class == "prop_animinteractable" and model == "models/props_combine/combine_consoles/vr_console_rack_1.vmdl"
    if name == "" then
        thisEntity:SetEntityName("" .. thisEntity:GetEntityIndex())
    end
    thisEntity:SetThink(function()
        if not is_console then
            DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. count, 0, nil, nil)
        end

        if map == "a3_distillery" and name == "verticaldoor_wheel" then
            count = count + 0.001
        elseif name == "12712_shotgun_wheel" then
            count = count + 0.003
        else
            count = count + 0.01
        end

        if is_console then
            DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. count, 0, nil, nil)
        end

        if name == "12712_shotgun_wheel" then
            DoEntFireByInstanceHandle(thisEntity, "DisableReturnToCompletion", "" .. count, 0, nil, nil)
            SendToConsole("ent_fire_output " .. thisEntity:GetName() .. " Position " .. count / 2)
        end

        if model == "models/interaction/anim_interact/hand_crank_wheel/hand_crank_wheel.vmdl" then
            SendToConsole("ent_fire_output " .. thisEntity:GetName() .. " Position " .. count)
        end

        if count >= 1 then
            thisEntity:FireOutput("OnCompletionA_Forward", nil, nil, nil, 0)
            if name == "barricade_door_hook" then
                SendToConsole("ent_fire barricade_door SetReturnToCompletionStyle 0")
            end
            if name == "12712_shotgun_wheel" then
                local bar = Entities:FindByName(nil, "12712_shotgun_bar_for_wheel")
                bar:SetOrigin(Vector(711.395874, 1319.248047, -168.302490))
                bar:SetAngles(0.087952, 120.220528, 90.588112)
            end
            return nil
        else
            return 0
        end
    end, "AnimateCompletionValue", 0)
elseif name == "589_panel_switch" or name == "5628_2901_barricade_door_hook" then
    thisEntity:Attribute_SetIntValue("used", 1)

    local count = 0
    thisEntity:SetThink(function()
        DoEntFireByInstanceHandle(thisEntity, "SetCompletionValue", "" .. 1 - count, 0, nil, nil)
        count = count + 0.01
        if count >= 1 then
            thisEntity:FireOutput("OnCompletionA_Backward", nil, nil, nil, 0)
            return nil
        else
            return 0
        end
    end, "AnimateCompletionValue", 0)
end

if vlua.find(model, "doorhandle") then
    local ent = Entities:FindByClassnameNearest("prop_door_rotating_physics", thisEntity:GetOrigin(), 60)
    DoEntFireByInstanceHandle(ent, "Use", "", 0, player, player)
end

if vlua.find(name, "socket") then
    local ent = Entities:FindByClassname(thisEntity, "prop_physics") 
    DoEntFireByInstanceHandle(ent, "Use", "", 0, player, player)
end

if class == "prop_ragdoll" or class == "prop_ragdoll_attached" then
    for k, v in pairs(thisEntity:GetChildren()) do
        DoEntFireByInstanceHandle(v, "RunScriptFile", "useextra", 0, player, nil)
    end
end

if name == "falling_cabinet_door" then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1000,0))
end

if name == "falling_cabinet_door" then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1000,0))
end

if vlua.find(name, "_locker_door_") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,5000))
elseif vlua.find(name, "_hazmat_crate_lid") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-5000,0))
elseif vlua.find(name, "electrical_panel_") and vlua.find(name, "_door") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-5000))
elseif vlua.find(name, "_dumpster_lid") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,2000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-800,0))
    end
elseif vlua.find(name, "_portaloo_seat") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-3000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,2000,0))
    end
elseif vlua.find(name, "_drawer_") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyAbsVelocityImpulse(-thisEntity:GetForwardVector() * 100)
    else
        thisEntity:ApplyAbsVelocityImpulse(thisEntity:GetForwardVector() * 100)
    end
elseif vlua.find(name, "_trashbin02_lid") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1000,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-3000,0))
    end
elseif vlua.find(name, "_car_door_rear") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,1500,0))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,-2800,0))
    end
elseif vlua.find(name, "ticktacktoe_") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,RandomInt(1000, 3000),0))
end

if vlua.find(name, "_wooden_board") then
    DoEntFireByInstanceHandle(thisEntity, "Break", "", 0, nil, nil)
end

if class == "prop_door_rotating_physics" and vlua.find(name, "padlock_door") then
    DoEntFireByInstanceHandle(thisEntity, "Close", "", 0, nil, nil)
end


---------- a1_intro_world ----------

if name == "microphone" or name == "call_button_prop" or model == "maps/a1_intro_world/entities/unnamed_205_2961_1020.vmdl" then
    SendToConsole("ent_fire call_button_relay trigger")
end

if name == "205_2653_door" or name == "205_2653_door2" or name == "205_8018_button_pusher_prop" then
    SendToConsole("ent_fire debug_roof_elevator_call_relay trigger")
end

if name == "205_8032_button_pusher_prop" then
    SendToConsole("ent_fire debug_elevator_relay trigger")
end

if model == "models/props/interactive/washing_machine01a_door.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    end
end

if vlua.find(model, "models/props/c17/antenna01") then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
end

if name == "979_518_button_pusher_prop" then
    SendToConsole("ent_fire debug_choreo_start_relay trigger")
end


---------- a1_intro_world_2 ----------

if name == "russell_headset" then
    SendToConsole("ent_fire debug_relay_put_on_headphones trigger")
    SendToConsole("ent_fire 4962_car_door_left_front close")
end

if vlua.find(model, "car_sedan_a0") and (vlua.find(model, "glass") or vlua.find(model, "door")) then
    local ent = Entities:FindByClassnameNearest("prop_door_rotating_physics", thisEntity:GetOrigin(), 40)
    DoEntFireByInstanceHandle(ent, "Toggle", "", 0, nil, nil)
end

if name == "carousel" then
    SendToConsole("+attack")
    player:SetThink(function()
        SendToConsole("-attack")
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-500))
    end, "SpinCarousel", 0)
end

if vlua.find(name, "mailbox") and vlua.find(model, "door") then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2500))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2500))
    end
end

if name == "russell_entry_window" then
    SendToConsole("fadein 0.2")
    SendToConsole("ent_fire russell_entry_window SetCompletionValue 1")
    SendToConsole("setpos -1728 275 100")
end

if model == "models/props/fridge_1a_door2.vmdl" or model == "models/props/fridge_1a_door.vmdl" then
    if thisEntity:Attribute_GetIntValue("toggle", 0) == 0 then
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,-2000))
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,2000))
    end
end

if name == "621_6487_button_pusher_prop" then
    SendToConsole("ent_fire 621_6487_button_branch test")
end

if name == "glove_dispenser_brush" then
    SendToConsole("ent_fire relay_give_gravity_gloves trigger")
    SendToConsole("hidehud 1")
    Entities:GetLocalPlayer():Attribute_SetIntValue("gravity_gloves", 1)
end


---------- a2_pistol ----------

if model == "models/props/distillery/firebox_1_door_a.vmdl" then
    thisEntity:ApplyLocalAngularVelocityImpulse(Vector(0,0,200))
end


---------- a3_distillery ----------

if name == "cellar_ladder" then
    ClimbLadderSound()
    SendToConsole("ent_fire cellar_ladder SetCompletionValue 1")
    SendToConsole("fadein 0.2")
    SendToConsole("setpos_exact 1004 1775 546")
end

if name == "larry_ladder" then
    ClimbLadderSound()
    SendToConsole("ent_fire larry_ladder SetCompletionValue 1")
    SendToConsole("fadein 0.2")
    SendToConsole("ent_fire relay_debug_intro_trench trigger")
end


---------- a4_c17_parking_garage ----------

if name == "toner_sliding_ladder" then
    ClimbLadderSound()
    SendToConsole("ent_fire toner_sliding_ladder SetCompletionValue 1")
    SendToConsole("fadein 0.2")
    SendToConsole("setpos_exact -367 -416 150")
end


---------- Other ----------

if name == "prop_crowbar" then
    thisEntity:Kill()
end

if name == "l_candler" or name == "r_candler" then
    SendToConsole("ent_fire innervault_energize_event_relay Kill")
    SendToConsole("ent_fire_output g_release_hand1 OnHandPosed")
    SendToConsole("ent_fire_output g_release_hand2 OnHandPosed")
    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
    SendToConsole("hidehud 4")
end

if name == "combine_gun_mechanical" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    SendToConsole("ent_fire player_speedmod ModifySpeed 0")
    local angles = thisEntity:GetAngles()
    SendToConsole("ent_fire combine_gun_grab_handle SetParent combine_gun_mechanical")
    SendToConsole("ent_fire combine_gun_interact Alpha 0")
    SendToConsole("ent_fire combine_gun_mechanical SetParent !player")
    thisEntity:SetAngles(angles.x - 15, angles.y, angles.z)
    SendToConsole("bind " .. PRIMARY_ATTACK .. " \"ent_fire relay_shoot_gun trigger\"")
    SendToConsole("r_drawviewmodel 0")
    thisEntity:Attribute_SetIntValue("used", 1)
end

if name == "18918_5316_button_pusher_prop" then
    SendToConsole("ent_fire_output 18918_5316_button_center_pusher OnIn")
end

if name == "18918_5275_button_pusher_prop" then
    SendToConsole("ent_fire_output 18918_5275_button_center_pusher OnIn")
end

if name == "1489_4074_port_demux" then
    SendToConsole("ent_fire_output 1489_4074_path_demux_3_0 onpoweron")
    SendToConsole("ent_fire_output 1489_4074_path_demux_3_3 onpoweron")
    SendToConsole("ent_fire_output 1489_4074_path_demux_3_6 onpoweron")
end

if name == "bridge_crank" then
    SendToConsole("ent_fire driven_bridge SetPlaybackRate 1 1")
    SendToConsole("ent_fire drawbridge_brush Enable")
    local ent = Entities:FindByName(nil, "bridge_crank")
    ent:FireOutput("OnInteractStart", nil, nil, nil, 0)
    ent:FireOutput("OnInteractStop", nil, nil, nil, 2.8)
end

if name == "3_8223_prop_button" then
    SendToConsole("ent_fire_output 3_8223_handpose_combine_switchbox_button_press OnHandPosed")
end

if name == "3_8223_mesh_combine_switch_box" then
    SendToConsole("ent_fire_output 3_8223_switch_box_hack_plug OnHackSuccess")

end

if name == "589_test_outlet" then
    SendToConsole("ent_fire 589_vertical_door Open")
    SendToConsole("ent_fire_output 589_path_11 OnPowerOn")
end

if class == "item_combine_tank_locker" then
    if thisEntity:GetCycle() <= 0.5 then
        DoEntFireByInstanceHandle(thisEntity, "PlayAnimation", "combine_locker_standing", 0, nil, nil)

        ent = Entities:FindByClassname(nil, "item_hlvr_combine_console_tank")
        while ent do
            if ent:GetMoveParent() then
                DoEntFireByInstanceHandle(ent, "EnablePickup", "", 0, nil, nil)
            end
            ent = Entities:FindByClassname(ent, "item_hlvr_combine_console_tank")
        end
    end
end

if class == "item_hlvr_weapon_energygun" and map ~= "a1_intro_world_2" then
	SendToConsole("give weapon_pistol")
	SendToConsole("ent_remove weapon_bugbait")
	thisEntity:Kill()
end

if class == "item_hlvr_weapon_shotgun" then
    SendToConsole("give weapon_shotgun")
    SendToConsole("ent_fire 12712_relay_player_shotgun_is_ready Trigger")
    thisEntity:Kill()
end

if class == "item_hlvr_weapon_rapidfire" then
    SendToConsole("give weapon_ar2")
    thisEntity:Kill()
end

if class == "prop_dynamic" then
    if model == "models/props_combine/health_charger/combine_health_charger_vr_pad.vmdl" then
        local ent = Entities:FindByClassnameNearest("item_health_station_charger", thisEntity:GetOrigin(), 20)
        DoEntFireByInstanceHandle(ent, "RunScriptFile", "useextra", 0, nil, nil)
        if tostring(thisEntity:GetMaterialGroupMask()) == "5" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
            if player:GetHealth() == player:GetMaxHealth() then
                StartSoundEvent("HealthStation.Deny", player)
            else
                StartSoundEvent("HealthStation.Start", player)
                SendToConsole("ent_fire player_speedmod ModifySpeed 0")
                thisEntity:Attribute_SetIntValue("used", 1)
                thisEntity:SetThink(function()
                    StartSoundEvent("HealthStation.Loop", player)
                end, "Loop", .7)
                thisEntity:SetThink(function()
                    if player:GetHealth() < player:GetMaxHealth() then
                        player:SetHealth(player:GetHealth() + 1)
                        return 0.1
                    else
                        StopSoundEvent("HealthStation.Loop", player)
                        StartSoundEvent("HealthStation.Complete", player)
                        thisEntity:StopThink("Loop")
                        SendToConsole("ent_fire player_speedmod ModifySpeed 1")
                        thisEntity:Attribute_SetIntValue("used", 0)
                    end
                end, "Heal", 0)
            end
        end
    elseif model == "models/props/alyx_hideout/button_plate.vmdl" then
        SendToConsole("ent_fire 2_8127_elev_button_test_floor_" .. player:Attribute_GetIntValue("next_elevator_floor", 2) .. " Trigger")

        if player:Attribute_GetIntValue("next_elevator_floor", 2) == 2 then
            player:Attribute_SetIntValue("next_elevator_floor", 1)
        else
            player:Attribute_SetIntValue("next_elevator_floor", 2)
        end
    elseif model == "models/props_combine/combine_doors/combine_door_sm01.vmdl" or model == "models/props_combine/combine_lockers/combine_locker_doors.vmdl" then
        local ent = Entities:FindByClassnameNearest("info_hlvr_holo_hacking_plug", thisEntity:GetCenter(), 40)

        if ent and ent:Attribute_GetIntValue("used", 0) == 0 then
			DoEntFireByInstanceHandle(ent, "BeginHack", "", 0, nil, nil)
            ent:FireOutput("OnHackSuccess", nil, nil, nil, 1.8)
            ent:FireOutput("OnPuzzleSuccess", nil, nil, nil, 1.8)
			DoEntFireByInstanceHandle(ent, "EndHack", "", 1.8, nil, nil)
			ent:Attribute_SetIntValue("used", 1)
        end
    end
end

if map == "a3_hotel_interior_rooftop" and name == "window_sliding1" then
    SendToConsole("fadein 0.2")
    SendToConsole("setpos_exact 788 -1420 576")
    SendToConsole("-use")
    thisEntity:SetThink(function()
        SendToConsole("+use")
    end, "", 0)
end

if name == "2860_window_sliding1" then
    SendToConsole("fadein 0.2")
    SendToConsole("setpos_exact 1437 -1422 140")
end

if name == "power_stake_1_start" then
    SendToConsole("ent_fire_output toner_path_alarm_1 OnPowerOn")
    SendToConsole("ent_fire toner_path_6_relay_debug Trigger")
end

if name == "2_11128_cshield_station_prop_button" then
    SendToConsole("ent_fire 2_11128_cshield_station_relay_button_pressed Trigger")
end

if name == "2_11128_cshield_station_1" then
    SendToConsole("ent_fire_output 2_11128_cshield_station_hack_plug OnHackSuccess")
end

if name == "254_16189_combine_locker" then
    SendToConsole("ent_fire_output 254_16189_locker_hack_plug OnPuzzleSuccess")
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["renderamt"]=0, ["model"]="models/props/industrial_door_2_40_92_white.vmdl", ["origin"]="-2018 -1828 216", ["angles"]="0 270 0", ["parentname"]="scanner_return_clip_door"})
    SpawnEntityFromTableSynchronous("prop_dynamic", {["solid"]=6, ["renderamt"]=0, ["model"]="models/props/industrial_door_2_40_92_white.vmdl", ["origin"]="-1888 -1744 216", ["angles"]="0 180 0", ["parentname"]="scanner_return_clip", ["modelscale"]=10})
end

if name == "2_203_elev_button_floor_1" then
    SendToConsole("ent_fire_output 2_203_elev_button_floor_1_handpose onhandposed")
end

if name == "2_203_inside_elevator_button" then
    SendToConsole("ent_fire_output 2_203_elev_door_is_open onfalse")
    SendToConsole("+use")
    thisEntity:SetThink(function()
        SendToConsole("-use")
    end, "", 0)
end

if name == "inside_elevator_button" then
    SendToConsole("ent_fire elev_button_elevator unlock")
    SendToConsole("ent_fire_output elev_button_elevator_handpose onhandposed")
    SendToConsole("+use")
    thisEntity:SetThink(function()
        SendToConsole("-use")
    end, "", 0)
end

if name == "console_opener_prop_handle_interact" then
    SendToConsole("ent_fire_output console_opener_logic_isselected_1 ontrue")
    SendToConsole("ent_fire_output console_opener_logic_isselected_2 ontrue")
    SendToConsole("ent_fire_output console_opener_logic_isselected_3 ontrue")
    SendToConsole("ent_fire_output console_opener_logic_isselected_4 ontrue")
    SendToConsole("ent_fire_output console_opener_logic_isselected_5 ontrue")
end

if name == "@pod_shell" then
    SendToConsole("ent_fire @pod_shell unlock")
end

if name == "ChoreoPhysProxy" then
    SendToConsole("ent_fire eli_fall_relay Trigger")
end

if name == "traincar_01_hatch" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    thisEntity:Attribute_SetIntValue("used", 1)
    SendToConsole("ent_fire_output traincar_01_hackplug OnHackSuccess")
end

if name == "5325_4704_toner_port_train_gate" then
    SendToConsole("ent_fire_output 5325_4704_train_gate_path_20_to_end OnPowerOn")
    SendToConsole("ent_fire_output 5325_4704_train_gate_path_22_to_end OnPowerOn")
end

if name == "270_trip_mine_item_1" then
    SendToConsole("ent_fire 270_trip_mine_item_1 deactivatemine")
end

if class == "prop_hlvr_crafting_station_console" then
    local function AnimTagListener(sTagName, nStatus)
        if sTagName == 'Bootup Done' and nStatus == 2 then
            thisEntity:Attribute_SetIntValue("crafting_station_ready", 1)
        elseif sTagName == 'Crafting Done' and nStatus == 2 then
            if Convars:GetStr("chosen_upgrade") == "pistol_upgrade_aimdownsights" then
                player:Attribute_SetIntValue("pistol_upgrade_aimdownsights", 1)
                SendToConsole("give weapon_pistol")
                SendToConsole("ent_fire text_pistol_upgrade_aimdownsights ShowMessage")
                SendToConsole("play sounds/ui/beepclear.vsnd")
            elseif Convars:GetStr("chosen_upgrade") == "pistol_upgrade_burstfire" then
                player:Attribute_SetIntValue("pistol_upgrade_burstfire", 1)
                SendToConsole("give weapon_pistol")
                SendToConsole("ent_fire text_pistol_upgrade_burstfire ShowMessage")
                SendToConsole("play sounds/ui/beepclear.vsnd")
            elseif Convars:GetStr("chosen_upgrade") == "shotgun_upgrade_grenadelauncher" then
                player:Attribute_SetIntValue("shotgun_upgrade_grenadelauncher", 1)
                SendToConsole("give weapon_shotgun")
                SendToConsole("ent_fire text_shotgun_upgrade_grenadelauncher ShowMessage")
                SendToConsole("play sounds/ui/beepclear.vsnd")
            elseif Convars:GetStr("chosen_upgrade") == "shotgun_upgrade_doubleshot" then
                player:Attribute_SetIntValue("shotgun_upgrade_doubleshot", 1)
                SendToConsole("give weapon_shotgun")
                SendToConsole("ent_fire text_shotgun_upgrade_doubleshot ShowMessage")
                SendToConsole("play sounds/ui/beepclear.vsnd")
            elseif Convars:GetStr("chosen_upgrade") == "smg_upgrade_aimdownsights" then
                player:Attribute_SetIntValue("smg_upgrade_aimdownsights", 1)
                if player:Attribute_GetIntValue("smg_upgrade_fasterfirerate", 0) == 0 then
                    SendToConsole("give weapon_ar2")
                else
                    SendToConsole("give weapon_smg1")
                end
                SendToConsole("ent_fire text_smg_upgrade_aimdownsights ShowMessage")
                SendToConsole("play sounds/ui/beepclear.vsnd")
            elseif Convars:GetStr("chosen_upgrade") == "smg_upgrade_fasterfirerate" then
                player:Attribute_SetIntValue("smg_upgrade_fasterfirerate", 1)
                SendToConsole("ent_remove weapon_ar2")
                SendToConsole("give weapon_smg1")
            end
            SendToConsole("ent_fire point_clientui_world_panel Enable")
            SendToConsole("ent_fire weapon_in_fabricator Kill")
            thisEntity:SetGraphParameterBool("bCrafting", false)
        elseif sTagName == 'Trays Retracted' and nStatus == 2 then
            thisEntity:Attribute_SetIntValue("cancel_cooldown_done", 1)
        end
    end

    thisEntity:RegisterAnimTagListener(AnimTagListener)

    if thisEntity:GetGraphParameter("bBootup") == false then
        local ent = Entities:FindByClassnameNearest("prop_hlvr_crafting_station", thisEntity:GetOrigin(), 20)
        DoEntFireByInstanceHandle(ent, "OpenStation", "", 0, nil, nil)
    elseif thisEntity:Attribute_GetIntValue("crafting_station_ready", 0) == 1 then
        if thisEntity:GetGraphParameter("bCollectingResin") then
            if Convars:GetStr("chosen_upgrade") ~= "" then
                if Convars:GetStr("chosen_upgrade") == "cancel" then
                    thisEntity:SetGraphParameterBool("bCrafting", false)
                    SendToConsole("ent_fire point_clientui_world_panel Enable")
                    thisEntity:Attribute_SetIntValue("cancel_cooldown_done", 0)
                else
                    SendToConsole("ent_fire upgrade_ui kill")
                    -- TODO: ent_create point_clientui_world_movie_panel {src_movie "file://{resources}/videos/wupgrade_frabrication.webm" targetname test width 200 height 100 }
                end
                thisEntity:SetGraphParameterBool("bCollectingResin", false)
            end
        elseif thisEntity:Attribute_GetIntValue("cancel_cooldown_done", 1) == 1 and thisEntity:GetGraphParameter("bCrafting") == false then
            thisEntity:SetGraphParameterBool("bCollectingResin", true)
            thisEntity:SetGraphParameterBool("bCrafting", true)
            thisEntity:Attribute_GetIntValue("crafting_station_ready", 0)
            local viewmodel = Entities:FindByClassname(nil, "viewmodel")
            if viewmodel then
                if viewmodel:GetModelName() == "models/pistol.vmdl" then
                    SendToConsole("ent_fire weapon_pistol kill 0.02")
                    SendToConsole("impulse 200")
                    Convars:SetStr("weapon_in_crafting_station", "pistol")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="weapon_in_fabricator", ["model"]="models/weapons/vr_alyxgun/vr_alyxgun.vmdl", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")
                    ent = SpawnEntityFromTableSynchronous("prop_dynamic_override", {["targetname"]="weapon_in_fabricator", ["model"]="models/weapons/vr_alyxgun/vr_alyxgun_slide_anim_interact.vmdl", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_pistol.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_aimdownsights", 0) == 0 then
                            SendToConsole("chooseupgrade1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("pistol_upgrade_burstfire", 0) == 0 then
                            SendToConsole("chooseupgrade2")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("cancelupgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput2", "cancelupgrade", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                elseif viewmodel:GetModelName() == "models/shotgun.vmdl" then
                    SendToConsole("ent_fire weapon_shotgun kill 0.02")
                    SendToConsole("impulse 200")
                    Convars:SetStr("weapon_in_crafting_station", "shotgun")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("item_hlvr_weapon_shotgun", {["targetname"]="weapon_in_fabricator", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_shotgun.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_doubleshot", 0) == 0 then
                            SendToConsole("chooseupgrade1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("shotgun_upgrade_grenadelauncher", 0) == 0 then
                            SendToConsole("chooseupgrade2")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("cancelupgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput2", "cancelupgrade", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                elseif viewmodel:GetModelName() == "models/smg.vmdl" then
                    if player:Attribute_GetIntValue("smg_upgrade_fasterfirerate", 0) == 0 then
                        SendToConsole("ent_fire weapon_ar2 kill 0.02")
                    else
                        SendToConsole("ent_fire weapon_smg1 kill 0.02")
                    end
                    SendToConsole("impulse 200")
                    Convars:SetStr("weapon_in_crafting_station", "smg")
                    local console = Entities:FindByClassnameNearest("prop_hlvr_crafting_station_console", player:GetOrigin(), 100)
                    local ent = Entities:FindByClassnameNearest("trigger_crafting_station_object_placement", console:GetOrigin(), 40)
                    local angles = ent:GetAngles()
                    local origin = ent:GetCenter() - angles:Forward() * 1.5 - Vector(0,0,2.25)
                    ent = SpawnEntityFromTableSynchronous("item_hlvr_weapon_rapidfire", {["targetname"]="weapon_in_fabricator", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent:SetParent(console, "item_attach")

                    local ents = Entities:FindAllByClassname("point_clientui_world_panel")
                    DoEntFireByInstanceHandle(ents[1], "Disable", "", 0, nil, nil)
                    DoEntFireByInstanceHandle(ents[2], "Disable", "", 0, nil, nil)
                    local angles = ents[2]:GetAngles()
                    local origin = ents[2]:GetOrigin() + Vector(0,0,0.04)
                    ent = SpawnEntityFromTableSynchronous("point_clientui_world_panel", {["panel_dpi"]=60, ["height"]=12, ["width"]=21, ["targetname"]="upgrade_ui", ["dialog_layout_name"]="file://{resources}/layout/custom_game/crafting_station_smg.xml", ["origin"]= origin.x .. " " .. origin.y .. " " .. origin.z, ["angles"]= angles.x .. " " .. angles.y .. " " .. angles.z })
                    ent.upgrade1 = function()
                        if player:Attribute_GetIntValue("smg_upgrade_aimdownsights", 0) == 0 then
                            SendToConsole("chooseupgrade1")
                        end
                    end
                    ent.upgrade2 = function()
                        if player:Attribute_GetIntValue("smg_upgrade_fasterfirerate", 0) == 0 then
                            SendToConsole("chooseupgrade2")
                        end
                    end
                    ent.cancelupgrade = function()
                        SendToConsole("cancelupgrade")
                    end
                    ent:RedirectOutput("CustomOutput0", "upgrade1", ent)
                    ent:RedirectOutput("CustomOutput1", "upgrade2", ent)
                    ent:RedirectOutput("CustomOutput2", "cancelupgrade", ent)
                    SendToConsole("ent_fire upgrade_ui addcssclass HasObject")
                end
            end
        end
        if thisEntity:GetGraphParameter("bCrafting") == false then
            Convars:SetStr("chosen_upgrade", "")
        end
    end
end

if class == "item_hlvr_combine_console_tank" then
    if thisEntity:GetMoveParent() then
        DoEntFireByInstanceHandle(thisEntity, "ClearParent", "", 0, nil, nil)
    else
        thisEntity:ApplyLocalAngularVelocityImpulse(Vector(200,0,0))
    end
end

if name == "room1_lights_circuitbreaker_switch" then
    SendToConsole("ent_fire_output controlroom_circuitbreaker_relay ontrigger")
end

if map == "a4_c17_parking_garage" then
    if name == "toner_port" then
        SendToConsole("ent_fire_output toner_path_2 OnPowerOn")
        SendToConsole("ent_fire_output toner_path_8 OnPowerOn")
    end
end

if map == "a2_train_yard" then
    if class == "item_hlvr_combine_console_rack" and Entities:FindAllByClassnameWithin("baseanimating", thisEntity:GetCenter(), 3)[2]:GetCycle() == 1 then
        local ent = Entities:FindByName(nil, "5325_3947_combine_console")
        DoEntFireByInstanceHandle(ent, "RackOpening", "1", 0, thisEntity, thisEntity)
    end
end

if map == "a2_headcrabs_tunnel" then
    if name == "toner_start" then
        SendToConsole("ent_fire_output toner_path_2 OnPowerOff")
        SendToConsole("ent_fire_output toner_path_8 OnPowerOff")
    end

    if name == "flashlight" then
        SendToConsole("ent_fire_output flashlight OnAttachedToHand")
        SendToConsole("bind " .. FLASHLIGHT .. " inv_flashlight")
        player:Attribute_SetIntValue("has_flashlight", 1)
        SendToConsole("ent_remove flashlight")
    end
end

if map == "a2_quarantine_entrance" then
    if name == "toner_port" and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
        thisEntity:Attribute_SetIntValue("used", 1)
        SendToConsole("ent_fire_output toner_path_5 OnPowerOn")
        SendToConsole("ent_fire !picker OnPlugRotated")
    end

    if class == "item_hlvr_combine_console_rack" and Entities:FindAllByClassnameWithin("baseanimating", thisEntity:GetCenter(), 3)[2]:GetCycle() == 1 then
        local ent = Entities:FindByName(nil, "17670_combine_console")
        DoEntFireByInstanceHandle(ent, "RackOpening", "1", 0, thisEntity, thisEntity)
    end
    
    if name == "27788_combine_locker" then
        SendToConsole("ent_fire_output 27788_locker_hack_plug OnHackSuccess")
    end
end

if map == "a3_hotel_lobby_basement" then
    if name == "power_stake_1_start" then
        SendToConsole("ent_fire_output power_logic_enable_lights ontrigger")
        SendToConsole("ent_fire_output path_2_panel onpoweron")
        SendToConsole("ent_fire_output power_logic_enable_lift ontrigger")
    end
end

if name == "plug_console_starter_lever" then
    SendToConsole("ent_fire_output plug_console_starter_lever OnCompletionB_Forward")
end

if GetMapName() == "a3_distillery" then
    if name == "11578_2635_380_button_center" then
        SendToConsole("ent_fire_output 11578_2635_380_button_center_pusher onin")
    end

    if name == "intro_rollup_door" then
        SendToConsole("ent_fire_output intro_rollup_door oncompletiona_forward")
        SendToConsole("ent_fire door_xen_crust break")
        SendToConsole("ent_fire relay_door_xen_crust_c trigger")
        SendToConsole("ent_fire relay_door_xen_crust_d trigger")
        SendToConsole("ent_fire relay_door_xen_crust_e trigger")
    end

    if name == "barricade_door" then
        SendToConsole("ent_fire barricade_door setreturntocompletionamount 1")
    end

    if name == "tc_door_control" then
        SendToConsole("ent_fire tc_door_control setcompletionvalue 0")
        SendToConsole("ent_fire relay_close_compactor_doors trigger")
    end

    if name == "11478_6233_tutorial_wheel" then
        SendToConsole("ent_fire 11478_6233_verticaldoor_wheel_tutorial open")
    end

    if name == "verticaldoor_wheel" then
        SendToConsole("ent_fire @verticaldoor setspeed 10")
        SendToConsole("ent_fire @verticaldoor open")
    end

    if name == "11479_2385_button_pusher_prop" then
        SendToConsole("ent_fire_output 11479_2385_button_center_pusher onin")
    end

    if name == "11479_2386_button_pusher_prop" then
        SendToConsole("ent_fire_output 11479_2386_button_center_pusher onin")
    end

    if name == "freezer_toner_outlet_1" then
        SendToConsole("ent_fire_output freezer_toner_path_3 onpoweron")
        SendToConsole("ent_fire_output freezer_toner_path_6 onpoweron")
        SendToConsole("ent_remove debug_teleport_player_freezer_door")
        SendToConsole("ent_fire relay_debug_freezer_breakout trigger")
    end

    if name == "freezer_toner_outlet_2" then
        SendToConsole("ent_fire_output freezer_toner_path_7 onpoweron")
    end

    if name == "freezer_port_b_2" then
        SendToConsole("ent_fire_output freezer_toner_path_8 onpoweron")
    end

    if name == "11578_2420_181_antlion_plug_crank_a" then
        SendToConsole("ent_fire_output 11578_2420_181_antlion_plug_crank_a oncompletionc_forward")
    end

    if name == "11578_2420_183_antlion_plug_crank_a" then
        SendToConsole("ent_fire_output 11578_2420_183_antlion_plug_crank_a oncompletionc_forward")
    end

    if name == "antlion_plug_crank_c" then
        SendToConsole("ent_fire_output antlion_plug_crank_c oncompletionc_forward")
    end
end

if name == "lift_button_box" then
    if thisEntity:Attribute_GetIntValue("used", 0) == 1 then
        SendToConsole("ent_fire_output lift_button_down onin")
        thisEntity:Attribute_SetIntValue("used", 0)
    else
        SendToConsole("ent_fire_output lift_button_up onin")
        thisEntity:Attribute_SetIntValue("used", 1)
    end
end

if name == "1517_3301_lift_prop_animated" then
    SendToConsole("ent_fire_output lift_button_down onin")
end

if name == "shack_path_6_port_1" then
    SendToConsole("ent_fire_output pallet_panel_power_on ontrigger")
end

if name == "pallet_lever_vertical" then
    SendToConsole("ent_fire_output pallet_logic_phys_raise ontrigger")
end

if name == "pallet_lever" then
    SendToConsole("ent_fire_output pallet_logic_extend ontrigger")
end

if class == "item_hlvr_headcrab_gland" then
    SendToConsole("ent_fire achievement_squeeze_heart FireEvent")
end

-- Mod support for Extra-Ordinary Value
if map == "youreawake" then
	if name == "1931_headset" then 
		StartSoundEventFromPosition("RadioHeadset.PutOn", Entities:GetLocalPlayer():EyePosition())
		SendToConsole("ent_fire_output 1931_headset onputonheadset trigger")
		SendToConsole("ent_fire 1931_headset kill")
	end	
end
if map == "seweroutskirts" then
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		local ent = Entities:FindByClassnameNearest("info_hlvr_holo_hacking_plug", thisEntity:GetCenter(), 20)
        if ent and ent:Attribute_GetIntValue("used", 0) == 0 then
			DoEntFireByInstanceHandle(ent, "BeginHack", "", 0, nil, nil)
            ent:FireOutput("OnHackSuccess", nil, nil, nil, 1.8)
            ent:FireOutput("OnPuzzleSuccess", nil, nil, nil, 1.8)
			ent:FireOutput("OnHackSuccessAnimationComplete", nil, nil, nil, 1.8)
			DoEntFireByInstanceHandle(ent, "EndHack", "", 1.8, nil, nil)
			ent:Attribute_SetIntValue("used", 1)
        end
		--StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
	end	
end
if map == "facilityredux" then
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onpuzzlesuccess")
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onhacksuccessanimationcomplete")
	end	
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
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onpuzzlesuccess")
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onhacksuccessanimationcomplete")
	end	
	if name == "393_elev_button_elevator" then -- UseElevatorButton
		SendToConsole("ent_fire 393_elev_button_elevator press")
	end
	if name == "392_392_134_button_center" then
		SendToConsole("ent_fire_output 392_117_combine_door_open_relay ontrigger")
	end
end
-- Mod support for Belomorskaya Station
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
-- Mod support for Overcharge
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
-- Mod support for Levitation
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
	if name == "15708_mesh_combine_switch_box" then 
		SendToConsole("ent_fire_output 15708_switch_box_hack_plug OnHackSuccess")
	end
	if name == "15708_prop_button" then 
		SendToConsole("ent_fire_output 15708_handpose_combine_switchbox_button_press OnHandPosed")
	end	
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onpuzzlesuccess")
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onhacksuccessanimationcomplete")
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
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onpuzzlesuccess")
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onhacksuccessanimationcomplete")
	end	
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
	if model == "models/weapons/vr_tripmine/tripmine.vmdl" then 
		StartSoundEventFromPosition("HackingPlug.Connect", player:EyePosition())
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onpuzzlesuccess")
		SendToConsole("ent_fire_output *_tripmine_hacking_plug onhacksuccessanimationcomplete")
	end	
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
-- GoldenEye remake maps
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

if class == "baseanimating" and vlua.find(name, "Console") and thisEntity:Attribute_GetIntValue("used", 0) == 0 then
    thisEntity:Attribute_SetIntValue("used", 1)
    SendToConsole("ent_fire_output *_console_hacking_plug OnHackSuccess")
    local ents = Entities:FindAllByClassnameWithin("item_hlvr_combine_console_tank", thisEntity:GetCenter(), 20)
    for k, v in pairs(ents) do
        DoEntFireByInstanceHandle(v, "DisablePickup", "", 0, player, nil)
    end
    SendToConsole("ent_fire 5325_3947_combine_console AddOutput OnTankAdded>item_hlvr_combine_console_tank>DisablePickup>>0>1")
	SendToConsole("ent_fire 26976_combine_console AddOutput OnTankAdded>item_hlvr_combine_console_tank>DisablePickup>>0>1") -- Levitation mod
end

if class == "item_hlvr_grenade_xen" then
    thisEntity:SetThink(function()
        if GetPhysVelocity(thisEntity):Length() > 550 then
            DoEntFireByInstanceHandle(thisEntity, "ArmGrenade", "", 0, nil, nil)
        else
            return 0
        end
    end, "ArmOnHighVelocity", 0)
end

local item_pickup_params = { ["userid"]=player:GetUserID(), ["item"]=class, ["item_name"]=name }

if vlua.find(class, "item_hlvr_crafting_currency_") then
    if name == "currency_booby_trap" then
        thisEntity:FireOutput("OnPlayerPickup", nil, nil, nil, 0)
    end

    FireGameEvent("item_pickup", item_pickup_params)
    if vlua.find(class, "large") then
        SendToConsole("hlvr_addresources 0 0 0 5")
    else
        SendToConsole("hlvr_addresources 0 0 0 1")
    end
    StartSoundEventFromPosition("Inventory.BackpackGrabItemResin", player:EyePosition())
    
    -- Show resin count
    player:SetThink(function()
        local t = {}
        player:GatherCriteria(t)
        local ent = Entities:FindByName(nil, "text_resin")
        DoEntFireByInstanceHandle(ent, "SetText", "Resin: " .. t.current_crafting_currency, 0, nil, nil)
        DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
    end, "", 0)

    thisEntity:Kill()
elseif class == "item_hlvr_clip_energygun" or class == "item_hlvr_clip_generic_pistol" then
    FireGameEvent("item_pickup", item_pickup_params)
    if name == "pistol_clip_1" then
        SendToConsole("ent_remove weapon_bugbait")
        SendToConsole("give weapon_pistol")
        SendToConsole("ent_fire_output ammo_insert_listener OnEventFired")
    else
        SendToConsole("hlvr_addresources 10 0 0 0")
    end
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_energygun_multiple" or class == "item_hlvr_clip_generic_pistol_multiple" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 40 0 0 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_shotgun_multiple" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 0 4 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_shotgun_single" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 0 1 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_clip_rapidfire" then
    FireGameEvent("item_pickup", item_pickup_params)
    SendToConsole("hlvr_addresources 0 30 0 0")
    StartSoundEventFromPosition("Inventory.DepositItem", player:EyePosition())
    local viewmodel = Entities:FindByClassname(nil, "viewmodel")
    viewmodel:RemoveEffects(32)
    thisEntity:Kill()
elseif class == "item_hlvr_grenade_frag" then
    if thisEntity:GetSequence() == "vr_grenade_unarmed_idle" then
		-- player can hold 2 grenades on pockets, and one in hand
		-- for now, all grenades will go straight into pockets
		WristPockets_PickUpGrenade(player, thisEntity)
		FireGameEvent("item_pickup", item_pickup_params)
    end
elseif class == "item_healthvial" then
    if player:GetHealth() < player:GetMaxHealth() then
        player:SetContextNum("used_health_pen", 1, 10)
        player:SetHealth(min(player:GetHealth() + cvar_getf("hlvr_health_vial_amount"), player:GetMaxHealth()))
        FireGameEvent("item_pickup", item_pickup_params)
        StartSoundEventFromPosition("HealthPen.Stab", player:EyePosition())
        StartSoundEventFromPosition("HealthPen.Success01", player:EyePosition())
        StartSoundEventFromPosition("HealthPen.Success02", player:EyePosition())
        thisEntity:Kill()
    else
		WristPockets_PickUpHealthPen(player, thisEntity)
		FireGameEvent("item_pickup", item_pickup_params)
    end
end
