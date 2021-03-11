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
`Creates a command with the given name. Callback parameters as as follows: (player, commandObj).`  

adminObj:ChangePrefix(prefix)  
`Changes the prefix.`  

adminObj:DelCommand(name[, silent])  
`Deletes command.  If silent is true, it will silence the error of the command not existing.`  

commandObj:Delete()  
`Deletes command.`

***

Crash Course:
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
