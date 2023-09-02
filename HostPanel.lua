--- variables

local godmodeenabled = false

--- actuall code

AbilityService.createAbility("Faster Sprint",KeyCode.P,{
    maxProgress = 25,
    progressPerUse = 25,
    iconImage = "rbxthumb://type=Asset&id=14295443712&w=420&h=420"
})


AbilityService.createAbility("Disable Godmode",KeyCode.J,{
    maxProgress = 1,
    progressPerUse = 1,
    iconImage = "rbxthumb://type=Asset&id=12581152050&w=420&h=420"
})

AbilityService.createAbility("Enable Godmode",KeyCode.K,{
    maxProgress = 1,
    progressPerUse = 1,
    iconImage = "rbxthumb://type=Asset&id=12581152050&w=420&h=420"
})

AbilityService.createAbility("Give 100 Forge Points",KeyCode.U,{
    maxProgress = 1,
    progressPerUse = 1,
    iconImage = "rbxthumb://type=Asset&id=5143122701&w=420&h=420"
})
AbilityService.createAbility("Emerald Gear",KeyCode.M,{
    maxProgress = 1,
    progressPerUse = 1,
    iconImage = "rbxthumb://type=Asset&id=11425725303&w=420&h=420"
})
AbilityService.createAbility("Win Game",KeyCode.L,{
    maxProgress = 1,
    progressPerUse = 1,
    iconImage = "rbxthumb://type=Asset&id=4857633548&w=420&h=420"
})



for _, plr in pairs(PlayerService.getPlayers()) do
    AbilityService.enableAbility(plr,"Faster Sprint")
    if plr.name == MatchService.getHost().name then
        AbilityService.enableAbility(plr,"Disable Godmode")
        AbilityService.enableAbility(plr,"Enable Godmode")
        AbilityService.enableAbility(plr,"Give 100 Forge Points")
        AbilityService.enableAbility(plr,"Win Game")
    end
end

Events.UseAbility(function (event)
    local plr = event.entity:getPlayer()
    if event.abilityName == "Faster Sprint" then
        SoundService.playSoundForPlayer(event.entity:getPlayer(),SoundType.QUEUE_MATCH_FOUND)
        event.entity:getPlayer():registerSpeedMultiplier("Faster-Sprint",1.3)
        task.wait(4)
        event.entity:getPlayer():removeSpeedMultiplier("Faster-Sprint")
    end
    if event.abilityName == "Disable Godmode" then
        if godmodeenabled == false then
            MessageService.sendError(plr,"You already have godmode disabled.")
        end
        if godmodeenabled == true then
            MessageService.sendInfo(plr,"Successfully disabled godmode.")
            godmodeenabled = false
        end
    end
    if event.abilityName == "Enable Godmode" then
        if godmodeenabled == true then
            MessageService.sendError(plr,"You already have godmode enabled.")
        end
        if godmodeenabled == false then
            MessageService.sendInfo(plr,"Successfully enabled godmode.")
            godmodeenabled = true
        end
    end
    if event.abilityName == "Give 100 Forge Points" then
        ForgeService.givePoints(plr,100)
    end
    if event.abilityName == "Win Game" then
        MatchService.endMatch(TeamService.getTeam(plr))
    end
    if event.abilityName == "Emerald Gear" then
        InventoryService.giveItem(plr,ItemType.EMERALD_HELMET,1,false)
        InventoryService.giveItem(plr,ItemType.EMERALD_CHESTPLATE,1,false)
        InventoryService.giveItem(plr,ItemType.EMERALD_HELMET,1,false)
        InventoryService.giveItem(plr,ItemType.EMERALD_SWORD,1,false)
        InventoryService.giveItem(plr,ItemType.EMERALD,20,false)
    end
end)

Events.EntityDamage(function (event)
    if event.entity:getPlayer().name == MatchService:getHost().name then
        if (godmodeenabled == true) then
            local oldHealth = event.entity.getMaxHealth()
            event.entity:setMaxHealth(10000)
            CombatService.heal(event.entity,10000)
            task.wait(0.1)
            event.entity:setMaxHealth(oldHealth)
        end
        if (godmodeenabled == false) then
            print("ok")
        end
    end
end)

Events.PlayerChatted(function (event)
    if event.player.name == "freggist" or MatchService.getHost().name then
        local msg = string.lower(event.message)
        local split = string.split(msg," ")

        if split[2] == "giveforgepoint" then
            
            for _, plr in pairs(PlayerService:getPlayers()) do
                if string.lower(plr.name) == split[3] then
                    ForgeService.givePoints(plr,tonumber(split[4]))
                end
            end
            
        end
        if split[2] == "walkspeedmult" then
            for _, plr in pairs(PlayerService:getPlayers()) do
                if string.lower(plr.name) == split[3] then
                    plr:registerSpeedMultiplier("CommandSpeedMult",tonumber(split[4]))
                end
            end
        end
        if split[2] == "removewalkspeedmult" then
            for _, plr in pairs(PlayerService:getPlayers()) do
                if string.lower(plr.name) == split[3] then
                    plr:removeSpeedMultiplier("CommandSpeedMult")
                end
            end
        end
        if split[2] == "godmode" then
            if split[3] == "true" then
                godmodeenabled = true
                MessageService.sendInfo(event.player,"Successfully enabled godmode!")
            end
            if split[3] == "false" then
                godmodeenabled = false
                MessageService.sendInfo(event.player,"Successfully disabled godmode.")
                print(godmodeenabled)
            end
        end
    end
end)
