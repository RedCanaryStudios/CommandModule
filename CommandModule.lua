local commandsModule = {}

commandsModule.create = function(prefix)

    prefix = prefix or ":"

    local Hooked = {}

    local struct = {
        Data = {
            prefix = prefix;
            Thresholds = {};
            Threshold = function() return 0 end;
        };

        OnCommand = function(self, command, foo, threshold)
            
            threshold = threshold or 0
            
            assert(command, "Command name must exist.")
            assert(type(foo) == "function", "The given callback is not a function.")
            
            Hooked[command] = foo
            self.Data.Thresholds[command] = threshold

            return {
                Delete = function(self)
                    Hooked[command] = nil
                end;
            }
        end;

        DelCommand = function(self, command, sil)
            assert(command, "Command name must exist.")
            assert(sil or Hooked[command], "Attempted to delete non-existing command.")
            Hooked[command] = nil
        end;

        ChangePrefix = function(self, p)
            self.Data.prefix = p
        end;
        
        Threshold = function(self, f)
            self.Data.Threshold = f
        end;
    }

    local function disectMessage(m)
        local t = {}
        local curIter = 1
        for c in m:gmatch(".") do
            if t[curIter] == nil then
                t[curIter] = ""
            end

            if c == " " then
                curIter = curIter + 1
            else
                t[curIter] = t[curIter]..c
            end
        end

        t.GetRest = function(self, n)
            local s = ""
            for i = n, #self do
                s = s.." "..self[i]
            end
            return s
        end

        return t
    end

    local function registerChat(plr, m)
        for command, func in pairs(Hooked) do
            if m:sub(1, #struct.Data.prefix) == struct.Data.prefix and #m > 1 then
                local params = disectMessage(m:sub(2, #m))
                if params[1] == command and struct.Data.Threshold(plr) >= struct.Data.Thresholds[command] then
                    table.remove(params, 1)
                    func(plr, params)
                end
            end
        end
    end

    local players = game:GetService("Players")

    players.PlayerAdded:Connect(function(plr)
        plr.Chatted:Connect(function(message)
            registerChat(plr, message)
        end)
    end)

    for _, v in ipairs(players:GetPlayers()) do
        v.Chatted:Connect(function(message)
            registerChat(v, message)
        end)
    end

    return struct
end

return commandsModule
