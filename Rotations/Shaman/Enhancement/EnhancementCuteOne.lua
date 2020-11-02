local rotationName = "CuteOne"
local br = _G["br"]

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.windstrike},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.crashLightning},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.stormstrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healingSurge}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.feralSpirit},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.feralSpirit},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.feralSpirit}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
            br.ui:createCheckbox(section,"Ghost Wolf")
            -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
            -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
            -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")
            -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
            -- Weapon Imbues
            br.ui:createCheckbox(section,"Windfury Weapon")
            br.ui:createCheckbox(section,"Flametongue Weapon")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- Flask Up Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- Ascendance
            br.ui:createDropdownWithout(section,"Ascendance", alwaysCdNever, 1, "|cffFFFFFFWhen to use Ascendance.")
            -- Earth Elemental Totem
            br.ui:createDropdownWithout(section,"Earth Elemental", alwaysCdNever, 1, "|cffFFFFFFWhen to use Earth Elemental.")
            -- Feral Spirit
            br.ui:createDropdownWithout(section,"Feral Spirit", alwaysCdNever, 1, "|cffFFFFFFWhen to use Feral Spirit.")
            -- Stormkeeper
            br.ui:createDropdownWithout(section,"Stormkeeper", alwaysCdNever, 1, "|cffFFFFFFWhen to use Stormkeeper.") 
            -- Sundering
            br.ui:createDropdownWithout(section,"Sundering", alwaysCdNever, 1, "|cffFFFFFFWhen to use Sundering.")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Cleanse Spirit
            br.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Earth Shield
            br.ui:createCheckbox(section, "Earth Shield")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Healing Surge OoC",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lightning Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Purge
            br.ui:createCheckbox(section,"Purge")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
            -- Hex
            br.ui:createCheckbox(section,"Hex")
            -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local debuff
local enemies
local essence
local module
local talent
local ui
local unit
local units
local var

-- General API Locals
local actionList = {}

local function canLightning(aoe)
    local level = unit.level()
    if level < 20 or unit.moving() or buff.maelstromWeapon.stack() > 0 then return false end
    local timeTillLightning = (aoe and level >= 24) and cast.time.chainLightning() or cast.time.lightningBolt()
    local flameShock = cd.flameShock.remain() -- Level 3
    local lavaLash  = cd.lavaLash.remain() -- Level 11
    local frostShock = cd.frostShock.remain() -- Level 17
    local stormstrike = cd.stormstrike.remain() or 99 -- Level 20
    local elementalBlast = talent.elementalBlast and cd.elementalBlast.remain() or 99 -- Level 25 - Talent
    local iceStrike = talent.iceStrike and cd.iceStrike.remain() or 99 -- Level 25 - Talent
    local fireNova = talent.fireNova and cd.fireNova.remain() or 99 -- Level 35 - Talent
    local crashLightning = level >= 38 and cd.crashLightning.remain() or 99 -- Level 38
    local earthenSpike = talent.earthenSpike and cd.earthenSpike.remain() or 99 -- Level 50 - Talent
    return math.min(flameShock,lavaLash,frostShock,stormstrike,elementalBlast,iceStrike,fireNova,crashLightning,earthenSpike) > timeTillLightning
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                StopAttack()
                ClearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Ghost Wolf
    if ui.checked("Ghost Wolf") and cast.able.ghostWolf() and not (unit.mounted() or unit.flying()) then
        if ((#enemies.yards20 == 0 and not unit.inCombat()) or (#enemies.yards10 == 0 and unit.inCombat())) and unit.moving("player") and not buff.ghostWolf.exists() then
            if cast.ghostWolf("player") then ui.debug("Casting Ghost Wolf") return true end
        end
    end
    -- Purge
    if ui.checked("Purge") and cast.able.purge() and cast.dispel.purge("target") and not unit.isBoss() and unit.exists("target") then
        if cast.purge() then ui.debug("Casting Purge") return true end
    end
    -- Spirit Walk
    if ui.checked("Spirit Walk") and cast.able.spiritWalk() and cast.noControl.spiritWalk() then
        if cast.spiritWalk("player") then ui.debug("Casting Spirit Walk") return true end
    end
    -- Water Walking
    if unit.fallTime() > 1.5 and buff.waterWalking.exists() then
        if buff.waterWalking.cancel() then ui.debug("Canceled Water Walking [Falling]") return true end
    end
    if ui.checked("Water Walking") and cast.able.waterWalking() and not unit.inCombat() and unit.swimming() and not buff.waterWalking.exists() then
        if cast.waterWalking("player") then ui.debug("Casting Water Walking") return true end
    end
end -- End Action List - Extras
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Ancestral Spirit
        if ui.checked("Ancestral Spirit") then
            if ui.value("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target") and unit.player("target") then
                if cast.ancestralSpirit("target","dead") then ui.debug("Casting Ancestral Spirit [Target]") return true end
            end
            if ui.value("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover") and unit.player("mouseover") then
                if cast.ancestralSpirit("mouseover","dead") then ui.debug("Casting Ancestral Spirit [Mouseover]") return true end
            end
        end
        -- Astral Shift
        if ui.checked("Astral Shift") and cast.able.astralShift() and unit.hp() <= ui.value("Astral Shift") and unit.inCombat() then
            if cast.astralShift("player") then ui.debug("Casting Astral Shift") return true end
        end
        -- Capacitor Totem
        if ui.checked("Capacitor Totem - HP") and cast.able.capacitorTotem() and cd.capacitorTotem.ready()
            and unit.hp() <= ui.value("Capacitor Totem - HP") and unit.inCombat() and #enemies.yards5 > 0
        then
            if cast.capacitorTotem("player","ground") then ui.debug("Casting Capacitor Totem [Low HP]") return true end
        end
        if ui.checked("Capacitor Totem - AoE") and cast.able.capacitorTotem() and cd.capacitorTotem.ready()
            and #enemies.yards5 >= ui.value("Capacitor Totem - AoE") and unit.inCombat()
        then
            if cast.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) then ui.debug("Casting Capacitor Totem [AOE]") return true end
        end
        -- Cleanse Spirit
        if ui.checked("Cleanse Spirit") then
            if ui.value("Cleanse Spirit")==1 and cast.able.cleanseSpirit("player") and cast.dispel.cleanseSpirit("player") then
                if cast.cleanseSpirit("player") then ui.debug("Casting Cleanse Spirit [Player]") return true end
            end
            if ui.value("Cleanse Spirit")==2 and cast.able.cleanseSpirit("target") and cast.dispel.cleanseSpirit("target") then
                if cast.cleanseSpirit("target") then ui.debug("Casting Cleanse Spirit [Target]") return true end
            end
            if ui.value("Cleanse Spirit")==3 and cast.able.cleanseSpirit("mouseover") and cast.dispel.cleanseSpirit("mouseover") then
                if cast.cleanseSpirit("mouseover") then ui.debug("Casting Cleanse Spirit [Mouseover]") return true end
            end
        end
        -- Earth Shield
        if ui.checked("Earth Shield") and cast.able.earthShield() and not buff.earthShield.exists() then
            if cast.earthShield() then ui.debug("Casting Earth Shield") return true end
        end
        -- Healing Surge
        if ui.checked("Healing Surge") and cast.able.healingSurge() and not unit.moving() then
            if unit.player("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Surge") then
                if cast.healingSurge("target") then ui.debug("Casting Healing Surge on "..unit.name("target")) return true end
            elseif unit.hp("player") <= ui.value("Healing Surge") or (not unit.inCombat() and unit.hp() < ui.value("Healing Surge OoC")) then
                if cast.healingSurge("player") then ui.debug("Casting Healing Surge on "..unit.name("player")) return true end
            end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Wind Shear
                -- wind_shear
                if ui.checked("Wind Shear") and cast.able.windShear(thisUnit) then
                    if cast.windShear(thisUnit) then ui.debug("Casting Wind Sheer") return true end
                end
                -- Hex
                if ui.checked("Hex") and cast.able.hex(thisUnit) then
                    if cast.hex(thisUnit) then ui.debug("Casting Hex") return true end
                end
                -- Capacitor Totem
                if ui.checked("Capacitor Totem") and cast.able.capacitorTotem(thisUnit)
                    and cd.capacitorTotem.ready() and cd.windShear.remain() > unit.gcd(true)
                then
                    if unit.threat(thisUnit) and not unit.moving(thisUnit) and unit.ttd(thisUnit) > 7 then
                        if cast.capacitorTotem(thisUnit,"ground") then ui.debug("Casting Capacitor Totem [Interrupt]") return true end
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts
-- Action List - Heart Essence
actionList.HeartEssence = function()
    if ui.checked("Use Essence") and unit.distance("target") < 5 then
        -- Heart Essence - Worldvein Resonance
        -- worldvein_resonance
        if cast.able.worldveinResonance() then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- Heart Essence - Guardian of Azeroth
        -- guardian_of_azeroth
        if ui.useCDs() and cast.able.guardianOfAzeroth() then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- Heart Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams
        if ui.useCDs() and cast.able.memoryOfLucidDreams() then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Heart Essence - Blood of the Enemy
        -- blood_of_the_enemy
        if ui.useCDs() and cast.able.bloodOfTheEnemy() then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
        end
        -- Heart Essence - The Unbound Force
        if cast.able.theUnboundForce() and (buff.recklessForce.exists() or unit.combatTime() < 5)
        then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Heart Essence - Focused Azerite Beam
        if cast.able.focusedAzeriteBeam() then
            local minCount = ui.useCDs() and 1 or 3
            if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then ui.debug("Casting Heart Essence: Focused Azerite Beam") return true end
        end
        -- Heart Essence - Purifying Blast
        if cast.able.purifyingBlast() then
            if cast.purifyingBlast("best", nil, 3, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        -- Heart Essence - Concentrated Flame
        if cast.able.concentratedFlame() and not cd.concentratedFlame.exists() then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flames") return true end
        end
        -- Heart Essence - Reaping Flames
        if cast.able.reapingFlames() then
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40f[i]
                if ((essence.reapingFlames.rank >= 2 and unit.hp(thisUnit) > 80) or unit.hp(thisUnit) <= 20 or unit.ttd(thisUnit,20) > 30) then
                    if cast.reapingFlames(thisUnit) then ui.debug("Casting Reaping Flames") return true end
                end
            end
        end
    end
end -- End Action List - Heart Essence
-- Action List - AOE
actionList.AOE = function()
    -- Frost Shock
    -- frost_shock,if=buff.hailstorm.up
    if cast.able.frostShock() and buff.hailstorm.exists() then
        if cast.frostShock() then ui.debug("Casting Frost Shock [AOE Hailstorm]") return true end
    end
    -- Fire Nova
    -- fire_nova,if=active_dot.flame_shock>=3
    if cast.able.fireNova() and debuff.flameShock.count() >= 3 then
        if cast.fireNova("player","aoe",1,8) then ui.debug("Casting Fire Nova [AOE 3+ Flame Shock]") return true end
    end
    -- Flame Shock
    -- flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled|covenant.necrolord
    if talent.fireNova and cast.able.flameShock() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if debuff.flameShock.refresh(thisUnit) then
                if cast.flameShock(thisUnit) then ui.debug("Casting Flame Shock [AOE Fire Nova / Covenant]") return true end
            end
        end
    end
    -- Primodial Wave
    -- primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up&(!talent.stormkeeper.enabled|buff.stormkeeper.up)
    -- TODO
    -- Vesper Totem
    -- vesper_totem
    -- if cast.able.vesperTotem() then
    --     if cast.vesperTotem() then ui.debug("Casting Vesper Totem [AOE]") return true end
    -- end
    -- Lightning Bolt
    -- lightning_bolt,if=buff.primordial_wave.up&buff.maelstrom_weapon.stack>=5
    -- if cast.able.lightningBolt() and buff.primordialWave.exists() and buff.maelstromWeapon.stack() >= 5 then
    --     if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [AOE Primordial Wave]") return true end
    -- end
    -- Crash Lightning
    -- crash_lightning
    if cast.able.crashLightning() then
        if cast.crashLightning(nil,"cone",1,8) then ui.debug("Casting Crash Lightning [AOE]") return true end
    end
    -- Chain Lightning
    -- chain_lightning,if=buff.stormkeeper.up&buff.maelstrom_weapon.stack>=5
    if cast.able.chainLightning() and buff.stormkeeper.exists() and buff.maelstromWeapon.stack() >= 5 then
        if cast.chainLightning() then ui.debug("Casting Chain Lightning [AOE Stormkeeper]") return true end
    end
    -- Chain Harvest
    -- chain_harvest,if=buff.maelstrom_weapon.stack>=5
    -- if cast.able.chainHarvest() and buff.maelstromWeapon.stack() >= 5 then
    --     if cast.chainHarvest() then ui.debug("Casting Chain Harvest [AOE]") return true end
    -- end
    -- Elemental Blast
    -- elemental_blast,if=buff.maelstrom_weapon.stack>=5&active_enemies!=3
    if cast.able.elementalBlast() and buff.maelstromWeapon.stack() >= 5 and #enemies.yards40f ~= 3 then
        if cast.elementalBlast() then ui.debug("Casting Elemental Blast [AOE Not 3 Enemy]") return true end
    end
    -- Stormkeeper
    -- stormkeeper,if=buff.maelstrom_weapon.stack>=5
    if ui.alwaysCdNever("Stormkeeper") and cast.able.stormkeeper() and buff.maelstromWeapon.stack() >= 5 then
        if cast.stormkeeper() then ui.debug("Casting Stormkeeper [AOE]") return true end
    end
    -- Chain Lightning
    -- chain_lightning,if=buff.maelstrom_weapon.stack=10
    if cast.able.chainLightning() and buff.maelstromWeapon.stack() == 10 then
        if cast.chainLightning() then ui.debug("Casting Chain Lightning [AOE 10 Maelstrom]") return true end
    end
    -- Flame Shock
    -- flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled
    if talent.fireNova and cast.able.flameShock() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if debuff.flameShock.refresh(thisUnit) then
                if cast.flameShock(thisUnit) then ui.debug("Casting Flame Shock [AOE Fire Nova]") return true end
            end
        end
    end
    -- Sundering
    -- sundering
    if ui.alwaysCdNever("Sundering") and cast.able.sundering() then
        if cast.sundering(nil,"rect",1,11) then ui.debug("Casting Sundering [AOE]") return true end
    end
    -- Stormstrike
    -- stormstrike
    if cast.able.stormstrike() and unit.level() >= 20 then
        if cast.stormstrike() then ui.debug("Casting Stormstrike [AOE]") return true end
    end
    -- Lava lash
    -- lava_lash
    if cast.able.lavaLash() then
        if cast.lavaLash() then ui.debug("Casting Lava Lash [AOE]") return true end
    end
    -- Flame Shock
    -- flame_shock,target_if=refreshable,cycle_targets=1
    if cast.able.flameShock() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if debuff.flameShock.refresh(thisUnit) then
                if cast.flameShock(thisUnit) then ui.debug("Casting Flame Shock [AOE]") return true end
            end
        end
    end
    -- Elemental Blast
    -- elemental_blast,if=buff.maelstrom_weapon.stack>=5&active_enemies=3
    if cast.able.elementalBlast() and buff.maelstromWeapon.stack() >= 5 and #enemies.yards40f == 3 then
        if cast.elementalBlast() then ui.debug("Casting Elemental Blast [AOE 3 Enemy]") return true end
    end
    -- Fae Trasfusion
    -- fae_transfusion
    -- if cast.able.faeTransfusion() then
    --     if cast.faeTransfusion() then ui.debug("Casting Fae Transfusion [AOE]") return true end
    -- end
    -- Frost Shock
    -- frost_shock
    if cast.able.frostShock() then
        if cast.frostShock() then ui.debug("Casting Frost Shock [AOE]") return true end
    end
    -- Ice Strike
    -- ice_strike
    if cast.able.iceStrike() then
        if cast.iceStrike() then ui.debug("Casting Ice Strike [AOE]") return true end
    end
    -- Chain Lightning
    -- chain_lightning,if=buff.maelstrom_weapon.stack>=5
    if cast.able.chainLightning() then
        if buff.maelstromWeapon.stack() >= 5 then
            if cast.chainLightning() then ui.debug("Casting Chain Lightning [AOE 5+ Maelstrom]") return true end
        end
        if unit.distance("target") > 5 and not unit.moving() then
            if cast.chainLightning() then ui.debug("Casting Chain Lightning [AOE Out of Range]") return true end
        end
    end
    -- Fire Nova
    -- fire_nova,if=active_dot.flame_shock>1
    if cast.able.fireNova() and debuff.flameShock.count() > 1 then
        if cast.fireNova("player","aoe",1,8) then ui.debug("Casting Fire Nova [AOE 2+ Flame Shock]") return true end
    end
    -- Earthen Spike
    -- earthen_spike
    if cast.able.earthenSpike() then
        if cast.earthenSpike() then ui.debug("Casting Earthen Spike [AOE]") return true end
    end
    -- Earth Elemental
    -- earth_elemental
    if ui.alwaysCdNever("Earth Elemental") and cast.able.earthElemental() then
        if cast.earthElemental() then ui.debug("Casting Earth Elemental [AOE]") return true end
    end
    -- Windfury Totem
    -- windfury_totem,if=buff.windfury_totem.remains<30
    if cast.able.windfuryTotem() and buff.windfuryTotem.remains() < 30 then
        if cast.windfuryTotem() then ui.debug("Casting Windfury Totem [AOE]") return true end
    end
    -- Primal Strike
    if cast.able.primalStrike() and unit.level() < 20 then
        if cast.primalStrike() then ui.debug("Casting Primal Strike [AOE]") return true end
    end
    -- Chain Lightning / Lightning Bolt
    if cast.able.chainLightning() and unit.level() >= 24 and canLightning(true) then
        if cast.chainLightning() then var.fillLightning = true ui.debug("Casting Chain Lightning [AOE - Filler]") return true end
    end
    if cast.able.lightningBolt() and unit.level() < 24 and canLightning() then
        if cast.lightningBolt() then var.fillLightning = true ui.debug("Casting Lightning Bolt [AOE - Filler]") return true end
    end
end -- End Action List - AOE
-- Action List - Single
actionList.Single = function()
    -- Primordial Wave
    -- primordial_wave,if=!buff.primordial_wave.up&(!talent.stormkeeper.enabled|buff.stormkeeper.up)
    -- if not buff.primordialWave.exists() and (not talent.sotrmkeeper or buff.stormkeeper.exists()) then
    --     if cast.primordialWave() then ui.debug("Casting Primordial Wave [ST]") return true end
    -- end
    -- Flame Shock
    -- flame_shock,if=!ticking
    if cast.able.flameShock() and not debuff.flameShock.exists(units.dyn40) then
        if cast.flameShock() then ui.debug("Casting Flame Shock [ST No Exist]") return true end
    end
    -- Vesper Totem
    -- vesper_totem
    -- if cast.able.vesperTotem() then
    --     if cast.vesperTotem() then ui.debug("Casting Vesper Totem [ST]") return true end
    -- end
    -- Frost Shock
    -- frost_shock,if=buff.hailstorm.up
    if cast.able.frostShock() and buff.hailstorm.exists() then
        if cast.frostShock() then ui.debug("Casting Frost Shock [ST Hailstorm]") return true end
    end
    -- Earthen Spike
    -- earthen_spike
    if cast.able.earthenSpike() then
        if cast.earthenSpike() then ui.debug("Casting Earthen Spike [ST]") return true end
    end
    -- Fae Transfusion
    -- fae_transfusion
    -- if cast.able.faeTransfusion() then
    --     if cast.faeTransfusion() then ui.debug("Casting Fae Transfusion [ST]") return true end
    -- end
    -- Lightning Bolt
    -- lightning_bolt,if=buff.stormkeeper.up&buff.maelstrom_weapon.stack>=5
    if cast.able.lightningBolt() and buff.stormkeeper.exists() and buff.maelstromWeapon.stack() >= 5 then
        if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [ST Stormkeeper]") return true end
    end
    -- Elemental Blast
    -- elemental_blast,if=buff.maelstrom_weapon.stack>=5
    if cast.able.elementalBlast() and buff.maelstromWeapon.stack() >= 5 then
        if cast.elementalBlast() then ui.debug("Casting Elemental Blast [ST]") return true end
    end
    -- Chain Harvest
    -- chain_harvest,if=buff.maelstrom_weapon.stack>=5
    -- if cast.able.chainHarvest() and buff.maelstromWeapon.stack() >= 5 then
    --     if cast.chainHarvest() then ui.debug("Casting Chain Harvest [ST]") return true end
    -- end
    -- Lightning Bolt
    -- lightning_bolt,if=buff.maelstrom_weapon.stack=10
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() == 10 then
        if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [ST 10 Maelstrom]") return true end
    end
    -- Lava Lash
    -- lava_lash,if=buff.hot_hand.up
    if cast.able.lavaLash() and buff.hotHand.exists() then
        if cast.lavaLash() then ui.debug("Casting Lava Lash [ST Hot Hand]") return true end
    end
    -- Stormstrike
    -- stormstrike
    if cast.able.stormstrike() and unit.level() >= 20 then
        if cast.stormstrike() then ui.debug("Casting Stormstrike [ST]") return true end
    end
    -- Stormkeeper
    -- stormkeeper,if=buff.maelstrom_weapon.stack>=5
    if ui.alwaysCdNever("Stormkeeper") and cast.able.stormkeeper() and buff.maelstromWeapon.stack() >= 5 then
        if cast.stormkeeper() then ui.debug("Casting Stormkeeper [ST]") return true end
    end
    -- Lava Lash
    -- lava_lash
    if cast.able.lavaLash() then
        if cast.lavaLash() then ui.debug("Casting Lava Lash [ST]") return true end
    end
    -- Crash Lightning
    -- crash_lightning
    if cast.able.crashLightning() then
        if cast.crashLightning(nil,"cone",1,8) then ui.debug("Casting Crash Lightning [ST]") return true end
    end
    -- Flame Shock
    -- flame_shock,target_if=refreshable
    if cast.able.flameShock() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if debuff.flameShock.refresh(thisUnit) then
                if cast.flameShock(thisUnit) then ui.debug("Casting Flame Shock [ST Refresh]") return true end
            end
        end
    end
    -- Frost Shock
    -- frost_shock
    if cast.able.frostShock() then
        if cast.frostShock() then ui.debug("Casting Frost Shock [ST]") return true end
    end
    -- Ice Strike
    -- ice_strike
    if cast.able.iceStrike() then
        if cast.iceStrike() then ui.debug("Casting Ice Strike [ST]") return true end
    end
    -- Sundering
    -- sundering
    if ui.alwaysCdNever("Sundering") and cast.able.sundering() then
        if cast.sundering(nil,"rect",1,11) then ui.debug("Casting Sundering [ST]") return true end
    end
    -- Fire Nova
    -- fire_nova,if=active_dot.flame_shock
    if cast.able.fireNova() and debuff.flameShock.count() > 1 then
        if cast.fireNova("player","aoe",1,8) then ui.debug("Casting Fire Nova [ST]") return true end
    end
    -- Lightning Bolt
    -- lightning_bolt,if=buff.maelstrom_weapon.stack>=5
    if cast.able.lightningBolt() then
        if buff.maelstromWeapon.stack() >= 5 then
            if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [ST 5+ Maelstrom]") return true end
        end
        if unit.distance("target") > 5 and not unit.moving() then
            if cast.lightningBolt() then ui.debug("Casting Lightning Bolt [ST Out of Range]") return true end
        end
    end
    -- Earth Elemental
    -- earth_elemental
    if ui.alwaysCdNever("Earth Elemental") and cast.able.earthElemental() and not unit.moving() then
        if cast.earthElemental() then ui.debug("Casting Earth Elemental [ST]") return true end
    end
    -- Windfury Totem
    -- windfury_totem,if=buff.windfury_totem.remains<30
    if cast.able.windfuryTotem() and not unit.moving() and buff.windfuryTotem.remains() < 30 then
        if cast.windfuryTotem() then ui.debug("Casting Windfury Totem [ST]") return true end
    end
    -- Primal Strike
    if cast.able.primalStrike() and unit.level() < 20 then
        if cast.primalStrike() then ui.debug("Casting Primal Strike [ST]") return true end
    end
    -- Lightning Bolt
    if cast.able.lightningBolt() and canLightning() then
        if cast.lightningBolt() then var.fillLightning = true ui.debug("Casting Lightning Bolt [ST - Filler]") return true end
    end
end -- End Action List - Single
-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Flask Up Module
        -- flask
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        -- Windfury Weapon
        -- windfury_weapon
        if ui.checked("Windfury Weapon") and cast.able.windfuryWeapon() and not unit.weaponImbue.exists(5401) then
            if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon [Main Hand]") return true end
        end
        -- Flametongue Weapon
        -- flametongue_weapon
        if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and not unit.weaponImbue.exists(5400,true) then
            if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon [Off Hand]") return true end
        end
        -- Lightning Shield
        -- lightning_shield
        if cast.able.lightningShield() and not buff.lightningShield.exists() then
            if cast.lightningShield("player") then ui.debug("Casting Lightning Shield") return true end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Stormkeeper
            -- stormkeeper,if=talent.stormkeeper.enabled
            if ui.alwaysCdNever("Stormkeeper") and talent.stormkeeper and cast.able.stormkeeper() then
                if cast.stormkeeper() then ui.debug("Casting Stormkeeper [Pre-Combat]") return true end
            end
            -- Potion
            -- potion
            -- if ui.checked("Potion") and canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- Feral Lunge
            if ui.checked("Feral Lunge") and cast.able.feralLunge() then
                if cast.feralLunge("target") then ui.debug("Casting Feral Lunge [Pull]") return true end
            end
            -- Lightning Bolt
            if ui.checked("Lightning Bolt Out of Combat") and cast.able.lightningBolt() and not unit.moving()
                and unit.distance("target") >= 10 and (not ui.checked("Feral Lunge") or not talent.feralLunge
                    or cd.feralLunge.remain() > unit.gcd(true) or not cast.able.feralLunge())
                -- and (not ui.checked("Ghost Wolf") or unit.distance("target") <= 20 or not buff.ghostWolf.exists())
            then
                if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt [Pull]") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                unit.startAttack("target")
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    essence                                       = br.player.essence
    module                                        = br.player.module
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables

    -- Dynamic Units
    -- units.get(5)
    -- units.get(8)
    -- units.get(20)
    units.get(40)

    -- Enemies Lists
    enemies.get(5)
    -- enemies.get(5,"player",false,true)
    -- enemies.get(8)
    enemies.get(10)
    -- enemies.yards11r = getEnemiesInRect(10,11,false) or 0
    enemies.get(20)
    enemies.get(30)
    enemies.get(40,"player",false,true)

    if var.fillLightning == nil then var.fillLightning = false end
    if unit.distance("target") < 5 and buff.maelstromWeapon.stack() < 5 and not var.fillLightning then
        -- Cancel Lightning Bolt in Melee
        if cast.current.lightningBolt() and not canLightning() then
            if cast.cancel.lightningBolt() then ui.debug("Canceled Lightning Bolt Cast [Melee Range]") end
        end
        -- Cancel Chain Lightning Bolt in Melee
        if cast.current.chainLightning() and not canLightning(true) then
            if cast.cancel.chainLightning() then ui.debug("Canceled Chain Lightning Cast [Melee Range]") end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop and not cast.current.focusedAzeriteBeam() then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then  return true end
            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Feral Lunge
            if ui.checked("Feral Lunge") and cast.able.feralLunge() and unit.distance("target") > 10 then
                if cast.feralLunge("target") then ui.debug("Casting Feral Lunge") return true end
            end
            -- Start Attack
            if unit.distance("target") <= 5 then
                unit.startAttack("target")
            end
            -- Windstrike
            -- windstrike
            if cast.able.windstrike() and buff.ascendance.exists() then
                if cast.windstrike() then ui.debug("Casting Windstrike") return true end
            end
            -- Heart Essence
            -- heart_essence
            if actionList.HeartEssence() then return true end
            -- Basic Trinkets Module
            module.BasicTrinkets()
            -- Racials
            -- blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
            -- berserking,if=!talent.ascendance.enabled|buff.ascendance.up
            -- fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
            -- ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
            -- bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
            if ((unit.race() == "Orc" or unit.race() == "DarkIronDwarf" or unit.race() == "MagharOrc") and (not talent.ascenance or buff.ascendance.exists() or cd.ascendance.remains() > 50))
                or (unit.race() == "Troll" and (not talent.ascenance or buff.ascendance.exists()))
            then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
            -- Feral Spirit
            -- feral_spirit
            if ui.alwaysCdNever("Feral Spirits") and cast.able.feralSpirit() then
                if cast.feralSpirit() then ui.debug("Casting Feral Spirit") return true end
            end
            -- Ascendance
            -- ascendance
            if ui.alwaysCdNever("Ascendance") and cast.able.ascendance() then
                if cast.ascendance() then ui.debug("Casting Ascendance") return true end
            end
            -- Call Action List - Single
            -- call_action_list,name=single,if=active_enemies=1
            if ui.useST(8,2) then
                if actionList.Single() then return true end
            end
            -- Call Action List - AOE
            -- call_action_list,name=aoe,if=active_enemies>1
            if ui.useAOE(8,2) then
                if actionList.AOE() then return true end
            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 263
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
