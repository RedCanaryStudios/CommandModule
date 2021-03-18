# CommandModule
<br>

Require:
```lua
local cmd = require(directory)
```

Example Script:
```lua
local microAdmin = cmd.create(":")

microAdmin:OnCommand("Kill", function(plr, params)
    game.Players[params[1]].Character.Humanoid.Health = 0
end)

microAdmin:OnCommand("ChangePrefix", function(plr, params)
    microAdmin:ChangePrefix(params[1])
end)
```
***

API:

module.create  
`Creates a set of admin commands. First parameter is prefix. Defaults to ':'. Returns adminObj.`  

adminObj:OnCommand(name, callback)  
`Creates a command with the given name. Callback parameters as as follows: (player, params). Returns commandObj.`  

adminObj:ChangePrefix(prefix)  
`Changes the prefix.`  

adminObj:DelCommand(name[, silent])  
`Deletes command.  If silent is true, it will silence the error of the command not existing.`  

commandObj:Delete()  
`Deletes command.`  

params  
`An array of parameters.`  

params:GetRest(pos)  
`Concatenates the table starting from a specific point.`

***

Quick Example:
```lua
local microAdmin = cmd.create(":") -- First parameter is command prefix. Defaults to ':'.

microAdmin:OnCommand("print", function(plr, params) -- will trigger when "print" is called
    
    for i, v in ipairs(params) do -- params is an array of parameters
        print(v)
    end
    
    print(params:GetRest(1)) -- alternatively, you can invoke GetRest to concatenate the rest of the array starting from a specified point
    
end)

microAdmin:ChangePrefix(";") -- change the prefix

microAdmin:DelCommand("print") -- delete commands

-- Alternatively, you can delete.

local cmdObj

cmdObj = microAdmin:OnCommand("TempCommand", function(plr, params)
    print("You can only use me once!")
    
    cmdObj:Delete()
end)
```
***


Update 3/17/2021  

# Thresholds  

You may now add thresholds to commands. Thresholds are defaulted to 0.

```lua
microAdmin:OnCommand("kill", function(plr, params)
    
end, 10)
```

If the plr's threshold is greater or equal to the third param, then the function will run.  

How do you set a threshold?  

You may use the `adminObj:Threshold(callback)` method to do so.  

```lua
microAdmin:Threshold(function(plr)
    if plr.Name == "xMicro_Canary" then
        return 1
    end
    return 0
end)
```

Once provided a callback, the callback will be given 1 parameter - player.  

The callback should return a numerical value, or else the script will error. This is how you provide the module a way to caculate the threshold of a player. For those who will create admin commands with group ranks, you may simply return the player's group rank to make it easy.  

```lua
microAdmin:Threshold(function(plr)
    return plr:GetRankInGroup(groupID)
end)
```

Example Product:

```lua
local cm = require(script.Parent)

local microAdmin = cm.create(":")

microAdmin:Threshold(function(plr)
    if plr.Name == "xMicro_Canary" then
        return 1
    end
    return 0
end)

microAdmin:OnCommand("Reset", function(plr, params)
    plr.Character.Humanoid.Health = 0
end) -- threshold by default is 0, so everyone can use it

microAdmin:OnCommand("Invincible", function(plr, params)
    plr.Character.Humanoid.MaxHealth = math.huge
    plr.Charater.Humanoid.Health = math.huge
end, 1) -- setting threshold to 1, so only I (xMicro_Canary) can use it.
```
