git add .
git commit -m "local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local TabContents = {}
for _, frame in pairs(game.Players.LocalPlayer.PlayerGui.BloxFruitGUI.MainFrame.ContentFrame:GetChildren()) do
    if frame:IsA("Frame") then
        TabContents[frame.Name] = frame
    end
end

-- Tab Status
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Loading status..."
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextSize = 14
StatusText.TextWrapped = true
StatusText.Parent = TabContents["Tab status"]

-- Logic cho các tính năng

-- Auto Kill Boss (Katakuri/Indra)
spawn(function()
    while true do
        if _G.Toggles.AutoKillKatakuri or _G.Toggles.AutoKillIndra then
            local bossName = _G.Toggles.AutoKillKatakuri and "Katakuri" or "Indra"
            for _, boss in pairs(workspace.Enemies:GetChildren()) do
                if boss.Name:find(bossName) and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                end
            end
        end
        wait(0.1)
    end
end)

-- Auto Pull Lever (giả lập: bay đến Mirage Island và bật tộc V3)
spawn(function()
    while true do
        if _G.Toggles.AutoPullLever then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
            wait(2)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awaken")
            wait(2)
            for _, gear in pairs(workspace:GetChildren()) do
                if gear.Name == "Gear" then
                    fireclickdetector(gear:FindFirstChildOfClass("ClickDetector"))
                end
            end
        end
        wait(1)
    end
end)

-- Auto Trial V4 (giả lập: bật tộc V3, hoàn thành trial, giết người chơi, chọn gear)
spawn(function()
    while true do
        if _G.Toggles.AutoTrialV4 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awaken")
            wait(2)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CompleteTrial")
            wait(2)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                    break
                end
            end
            wait(2)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ChooseGear")
        end
        wait(1)
    end
end)

-- Auto Train V4 (farm Katakuri V1, bật tộc V4, mua gear)
spawn(function()
    while true do
        if _G.Toggles.AutoTrainV4 then
            for _, boss in pairs(workspace.Enemies:GetChildren()) do
                if boss.Name:find("Katakuri") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                end
            end
            wait(2)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakenV4")
            wait(2)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGear")
        end
        wait(1)
    end
end)

-- Auto Buy Legendary Sword (Shisui, Saddi, Wando)
spawn(function()
    while true do
        if _G.Toggles.AutoBuyLegendarySword then
            local swords = {"Shisui", "Saddi", "Wando"}
            for _, sword in pairs(swords) do
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", sword)
                wait(1)
            end
        end
        wait(5)
    end
end)

-- Auto Hop Server (Katakuri, Indra, Mirage Island, Full Moon, Legendary Sword)
local function ServerHop(condition)
    local PlaceID = game.PlaceId
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, server.id, LocalPlayer)
            break
        end
    end
end

spawn(function()
    while true do
        if _G.Toggles.AutoHopKatakuri then
            ServerHop("Katakuri V2")
        elseif _G.Toggles.AutoHopIndra then
            ServerHop("Indra")
        elseif _G.Toggles.AutoHopMirage then
            ServerHop("Mirage Island")
        elseif _G.Toggles.AutoHopFullMoon then
            ServerHop("Full Moon")
        elseif _G.Toggles.AutoHopLegendarySword then
            ServerHop("Legendary Sword")
        end
        wait(10)
    end
end)

-- Fast Attack
spawn(function()
    while true do
        if _G.Toggles.FastAttack then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AttackSpeed", 0.1)
        end
        wait(0.1)
    end
end)

-- FPS Boost
spawn(function()
    while true do
        if _G.Toggles.FPSBoost then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end
        wait(5)
    end
end)

-- Teleport Mode (Fly hoặc Teleport)
local flying = false
local bodyVelocity, bodyGyro

local function StartFly()
    if not LocalPlayer.Character then return end
    flying = true
    local root = LocalPlayer.Character.HumanoidRootPart
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    spawn(function()
        while flying do
            local moveDirection = Vector3.new(0, 0, 0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Vector3.new(0, 0, -1)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection + Vector3.new(0, 0, 1)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection + Vector3.new(-1, 0, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Vector3.new(1, 0, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            bodyVelocity.Velocity = (root.CFrame * CFrame.new(moveDirection * 50)).p - root.Position
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            wait()
        end
    end)
end

local function StopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

spawn(function()
    while true do
        if _G.Toggles.TeleportMode == "Fly" and not flying then
            StartFly()
        elseif _G.Toggles.TeleportMode == "Teleport" then
            StopFly()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0))
        end
        wait(0.1)
    end
end)

-- Tab Status (Hiển thị trạng thái server và tài khoản)
spawn(function()
    while true do
        local status = "Server Status:\n"
        status = status .. "Katakuri: " .. (workspace.Enemies:FindFirstChild("Katakuri") and "Có" or "Không") .. "\n"
        status = status .. "Indra: " .. (workspace.Enemies:FindFirstChild("Indra") and "Có" or "Không") .. "\n"
        status = status .. "Mirage Island: " .. (workspace:FindFirstChild("Mirage Island") and "Có" or "Không") .. "\n"
        status = status .. "Full Moon: Unknown\n"
        status = status .. "Legendary Sword: Unknown\n"

        status = status .. "\nAccount Status:\n"
        status = status .. "Level: " .. (LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or "Unknown") .. "\n"
        status = status .. "Beli: " .. (LocalPlayer.Data.Beli and LocalPlayer.Data.Beli.Value or "Unknown") .. "\n"
        status = status .. "Fragments: " .. (LocalPlayer.Data.Fragments and LocalPlayer.Data.Fragments.Value or "Unknown") .. "\n"

        StatusText.Text = status
        wait(5)
    end
end)
"
git push origin main