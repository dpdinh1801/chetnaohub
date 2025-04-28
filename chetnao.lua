-- Load OrionLib an toàn
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

if not success then
    return warn("Không thể tải OrionLib!")
end

-- Tạo cửa sổ giao diện
local Window = OrionLib:MakeWindow({
    Name = "ChetNaoHub - Blox Fruits",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ChetNaoHubConfig"
})

-- Tab Hợp Server
local TabHopServer = Window:MakeTab({Name = "Hợp Server", Icon = "rbxassetid://4483345998", PremiumOnly = false})

_G.AutoKatakuri = false
_G.AutoIndra = false
_G.AutoMirage = false
_G.AutoLegendarySword = false
_G.AutoFullMoon = false

function HopServer()
    local PlaceID = game.PlaceId
    local TPS = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Desc&limit=100"))
    for i,v in pairs(Servers.data) do
        if v.playing < v.maxPlayers then
            TPS:TeleportToPlaceInstance(PlaceID, v.id)
            break
        end
    end
end

function CheckKatakuri()
    return workspace.Enemies:FindFirstChild("Cocoa Warrior [Lv. 2300]") ~= nil
end

function CheckRipIndra()
    return workspace.Enemies:FindFirstChild("rip_indra [Lv. 5000]") ~= nil
end

function CheckMirage()
    return workspace:FindFirstChild("Island") and workspace.Island:FindFirstChild("Mirage Island") ~= nil
end

function CheckLegendarySword()
    for _,v in pairs(workspace.NPCs:GetChildren()) do
        if v.Name == "Legendary Sword Dealer" then
            return true
        end
    end
    return false
end

function CheckFullMoon()
    return game.Lighting.ClockTime > 18 or game.Lighting.ClockTime < 6
end

-- Các Toggle Auto Hop Server
TabHopServer:AddToggle({
    Name = "Auto Hop Katakuri V2",
    Default = false,
    Callback = function(Value)
        _G.AutoKatakuri = Value
        task.spawn(function()
            while _G.AutoKatakuri do
                task.wait(5)
                if CheckKatakuri() then
                    OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Katakuri!", Time=5})
                    _G.AutoKatakuri = false
                else
                    HopServer()
                end
            end
        end)
    end
})

TabHopServer:AddToggle({
    Name = "Auto Hop Rip Indra",
    Default = false,
    Callback = function(Value)
        _G.AutoIndra = Value
        task.spawn(function()
            while _G.AutoIndra do
                task.wait(5)
                if CheckRipIndra() then
                    OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Rip Indra!", Time=5})
                    _G.AutoIndra = false
                else
                    HopServer()
                end
            end
        end)
    end
})

TabHopServer:AddToggle({
    Name = "Auto Hop Mirage Island",
    Default = false,
    Callback = function(Value)
        _G.AutoMirage = Value
        task.spawn(function()
            while _G.AutoMirage do
                task.wait(5)
                if CheckMirage() then
                    OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Mirage Island!", Time=5})
                    _G.AutoMirage = false
                else
                    HopServer()
                end
            end
        end)
    end
})

TabHopServer:AddToggle({
    Name = "Auto Hop Legendary Sword",
    Default = false,
    Callback = function(Value)
        _G.AutoLegendarySword = Value
        task.spawn(function()
            while _G.AutoLegendarySword do
                task.wait(5)
                if CheckLegendarySword() then
                    OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Legendary Sword Dealer!", Time=5})
                    _G.AutoLegendarySword = false
                else
                    HopServer()
                end
            end
        end)
    end
})

TabHopServer:AddToggle({
    Name = "Auto Hop Full Moon",
    Default = false,
    Callback = function(Value)
        _G.AutoFullMoon = Value
        task.spawn(function()
            while _G.AutoFullMoon do
                task.wait(5)
                if CheckFullMoon() then
                    OrionLib:MakeNotification({Name="Thông báo", Content="Đã tới Full Moon!", Time=5})
                    _G.AutoFullMoon = false
                else
                    HopServer()
                end
            end
        end)
    end
})

-- Tab Farm
local TabFarm = Window:MakeTab({Name = "Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

_G.AutoKillBoss = false
_G.AutoPullLever = false
_G.AutoTrialV4 = false
_G.AutoKillPlayerAfterTrial = false
_G.AutoUseSkillPvP = false
_G.AutoChooseGear = false
_G.AutoBuySword = false

-- Các Toggle Auto Farm
TabFarm:AddToggle({
    Name = "Auto Kill Boss (Katakuri/Indra)",
    Default = false,
    Callback = function(Value)
        _G.AutoKillBoss = Value
        task.spawn(function()
            while _G.AutoKillBoss do
                task.wait(1)
                pcall(function()
                    -- Code tìm và đánh boss ở đây
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Pull Lever (Gạt Cần Mirage/V3)",
    Default = false,
    Callback = function(Value)
        _G.AutoPullLever = Value
        task.spawn(function()
            while _G.AutoPullLever do
                task.wait(1)
                pcall(function()
                    -- Code bay ra Mirage Island, bật V3, tìm bánh răng
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Trial V4 All Race",
    Default = false,
    Callback = function(Value)
        _G.AutoTrialV4 = Value
        task.spawn(function()
            while _G.AutoTrialV4 do
                task.wait(1)
                pcall(function()
                    -- Code tự vào Trial và hoàn thành
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Kill Player After Trial",
    Default = false,
    Callback = function(Value)
        _G.AutoKillPlayerAfterTrial = Value
        task.spawn(function()
            while _G.AutoKillPlayerAfterTrial do
                task.wait(1)
                pcall(function()
                    -- Code tự giết player sau khi hoàn thành trial
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Use Skill During PvP",
    Default = false,
    Callback = function(Value)
        _G.AutoUseSkillPvP = Value
        task.spawn(function()
            while _G.AutoUseSkillPvP do
                task.wait(1)
                pcall(function()
                    -- Code tự động dùng skill khi PvP
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Choose Gear After PvP",
    Default = false,
    Callback = function(Value)
        _G.AutoChooseGear = Value
        task.spawn(function()
            while _G.AutoChooseGear do
                task.wait(1)
                pcall(function()
                    -- Code tự động chọn Gear V4 sau khi giết player
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Auto Buy Legendary Sword (Sea 2)",
    Default = false,
    Callback = function(Value)
        _G.AutoBuySword = Value
        task.spawn(function()
            while _G.AutoBuySword do
                task.wait(1)
                pcall(function()
                    -- Code tự động mua Legendary Sword khi tìm thấy
                end)
            end
        end)
    end
})

-- Khởi động OrionLib UI
OrionLib:Init()
