local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "ChetNaoHub - Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "ChetNaoHubConfig"})

-- Tab: Hợp Server
local TabHopServer = Window:MakeTab({Name = "Hợp Server", Icon = "rbxassetid://4483345998", PremiumOnly = false})

_G.AutoKatakuri = false
_G.AutoIndra = false
_G.AutoMirage = false
_G.AutoLegendarySword = false
_G.AutoFullMoon = false

function HopServer()
    local PlaceID = game.PlaceId
    local JobId = ""
    local HttpService = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Desc&limit=100"))
    for i,v in pairs(Servers.data) do
        if v.playing < v.maxPlayers then
            JobId = v.id
            break
        end
    end
    TPS:TeleportToPlaceInstance(PlaceID, JobId)
end

function CheckKatakuri()
    return workspace.Enemies:FindFirstChild("Cocoa Warrior [Lv. 2300]") ~= nil
end

function CheckRipIndra()
    return workspace.Enemies:FindFirstChild("rip_indra [Lv. 5000]") ~= nil
end

function CheckMirage()
    return workspace.Island and workspace.Island:FindFirstChild("Mirage Island") ~= nil
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

TabHopServer:AddToggle({
	Name = "Auto Hop Katakuri V2",
	Default = false,
	Callback = function(Value)
		_G.AutoKatakuri = Value
		while _G.AutoKatakuri do
			wait(5)
			if CheckKatakuri() then
				OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Katakuri V2!", Time=5})
				_G.AutoKatakuri = false
			else
				HopServer()
			end
		end
	end
})

TabHopServer:AddToggle({
	Name = "Auto Hop Rip Indra",
	Default = false,
	Callback = function(Value)
		_G.AutoIndra = Value
		while _G.AutoIndra do
			wait(5)
			if CheckRipIndra() then
				OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Rip Indra!", Time=5})
				_G.AutoIndra = false
			else
				HopServer()
			end
		end
	end
})

TabHopServer:AddToggle({
	Name = "Auto Hop Mirage Island",
	Default = false,
	Callback = function(Value)
		_G.AutoMirage = Value
		while _G.AutoMirage do
			wait(5)
			if CheckMirage() then
				OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Mirage Island!", Time=5})
				_G.AutoMirage = false
			else
				HopServer()
			end
		end
	end
})

TabHopServer:AddToggle({
	Name = "Auto Hop Legendary Sword",
	Default = false,
	Callback = function(Value)
		_G.AutoLegendarySword = Value
		while _G.AutoLegendarySword do
			wait(5)
			if CheckLegendarySword() then
				OrionLib:MakeNotification({Name="Thông báo", Content="Đã tìm thấy Legendary Sword Dealer!", Time=5})
				_G.AutoLegendarySword = false
			else
				HopServer()
			end
		end
	end
})

TabHopServer:AddToggle({
	Name = "Auto Hop Full Moon",
	Default = false,
	Callback = function(Value)
		_G.AutoFullMoon = Value
		while _G.AutoFullMoon do
			wait(5)
			if CheckFullMoon() then
				OrionLib:MakeNotification({Name="Thông báo", Content="Đã tới Full Moon!", Time=5})
				_G.AutoFullMoon = false
			else
				HopServer()
			end
		end
	end
})

-- OrionLib khởi động
OrionLib:Init()
local TabFarm = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

_G.AutoKillBoss = false
_G.AutoPullLever = false
_G.AutoTrialV4 = false
_G.AutoKillPlayerAfterTrial = false
_G.AutoUseSkillPvP = false
_G.AutoChooseGear = false
_G.AutoBuySword = false

TabFarm:AddToggle({
    Name = "Auto Kill Boss (Katakuri/Indra)",
    Default = false,
    Callback = function(Value)
        _G.AutoKillBoss = Value
        while _G.AutoKillBoss do
            task.wait()
            -- Code tìm và đánh boss ở đây
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Pull Lever (Gạt Cần)",
    Default = false,
    Callback = function(Value)
        _G.AutoPullLever = Value
        while _G.AutoPullLever do
            task.wait()
            -- Code bay ra Mirage, nhìn trăng, bật V3, lụm bánh răng
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Trial V4",
    Default = false,
    Callback = function(Value)
        _G.AutoTrialV4 = Value
        while _G.AutoTrialV4 do
            task.wait()
            -- Code tự làm Trial V4
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Kill Player After Trial",
    Default = false,
    Callback = function(Value)
        _G.AutoKillPlayerAfterTrial = Value
        while _G.AutoKillPlayerAfterTrial do
            task.wait()
            -- Code giết Player sau khi Trial
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Use Skill During PvP",
    Default = false,
    Callback = function(Value)
        _G.AutoUseSkillPvP = Value
        while _G.AutoUseSkillPvP do
            task.wait()
            -- Code tự động dùng kỹ năng khi đánh người
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Choose Gear After PvP",
    Default = false,
    Callback = function(Value)
        _G.AutoChooseGear = Value
        while _G.AutoChooseGear do
            task.wait()
            -- Code chọn Gear sau khi PvP
        end
    end
})

TabFarm:AddToggle({
    Name = "Auto Buy Legendary Sword (Sea 2)",
    Default = false,
    Callback = function(Value)
        _G.AutoBuySword = Value
        while _G.AutoBuySword do
            task.wait()
            -- Code tự mua kiếm Legendary
        end
    end
})
