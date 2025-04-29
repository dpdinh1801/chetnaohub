git add BloxFruitsExploitGUI.lua
git commit -m "-- Khởi tạo thư viện
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tạo Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Tạo tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Galaxy Hub - Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Tạo Frame chứa các tab (bên trái)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 120, 1, -40)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabFrame.Parent = MainFrame

-- Danh sách các tab
local Tabs = {
    "Tab farming", "Tab hopping", "Tab setting", "Tab status"
}

-- Tạo Frame chứa nội dung (bên phải)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 280, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.Parent = MainFrame

-- Tạo các Frame cho từng tab
local TabContents = {}
for _, tabName in ipairs(Tabs) do
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentFrame
    TabContents[tabName] = tabContent
end

-- Tạo các nút tab
for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Position = UDim2.new(0, 0, 0, (i-1)*30)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Parent = TabFrame

    -- Xử lý khi nhấn tab (đổi màu tab và hiển thị nội dung)
    TabButton.MouseButton1Click:Connect(function()
        for _, button in pairs(TabFrame:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        TabContents[tabName].Visible = true
    end)
end

-- Biến trạng thái cho các tính năng
local Toggles = {
    AutoKillKatakuri = false,
    AutoKillIndra = false,
    AutoPullLever = false,
    AutoTrialV4 = false,
    AutoTrainV4 = false,
    AutoBuyLegendarySword = false,
    AutoHopKatakuri = false,
    AutoHopIndra = false,
    AutoHopMirage = false,
    AutoHopFullMoon = false,
    AutoHopLegendarySword = false,
    FastAttack = false,
    FPSBoost = false,
    TeleportMode = "Fly" -- Fly hoặc Teleport
}

-- Hàm tạo nút bật/tắt
local function CreateToggleButton(parent, name, positionY, toggleKey)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 200, 0, 30)
    ToggleButton.Position = UDim2.new(0.5, -100, 0, positionY)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.Text = name .. ": TẮT"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Parent = parent

    ToggleButton.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        ToggleButton.Text = name .. ": " .. (Toggles[toggleKey] and "BẬT" or "TẮT")
        ToggleButton.BackgroundColor3 = Toggles[toggleKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    end)
end

-- Tab Farming
CreateToggleButton(TabContents["Tab farming"], "Auto Kill Katakuri", 10, "AutoKillKatakuri")
CreateToggleButton(TabContents["Tab farming"], "Auto Kill Indra", 50, "AutoKillIndra")
CreateToggleButton(TabContents["Tab farming"], "Auto Pull Lever", 90, "AutoPullLever")
CreateToggleButton(TabContents["Tab farming"], "Auto Trial V4", 130, "AutoTrialV4")
CreateToggleButton(TabContents["Tab farming"], "Auto Train V4", 170, "AutoTrainV4")
CreateToggleButton(TabContents["Tab farming"], "Auto Buy Legendary Sword", 210, "AutoBuyLegendarySword")

-- Tab Hopping
CreateToggleButton(TabContents["Tab hopping"], "Auto Hop Katakuri", 10, "AutoHopKatakuri")
CreateToggleButton(TabContents["Tab hopping"], "Auto Hop Indra", 50, "AutoHopIndra")
CreateToggleButton(TabContents["Tab hopping"], "Auto Hop Mirage Island", 90, "AutoHopMirage")
CreateToggleButton(TabContents["Tab hopping"], "Auto Hop Full Moon", 130, "AutoHopFullMoon")
CreateToggleButton(TabContents["Tab hopping"], "Auto Hop Legendary Sword", 170, "AutoHopLegendarySword")

-- Tab Setting
CreateToggleButton(TabContents["Tab setting"], "Fast Attack", 10, "FastAttack")
CreateToggleButton(TabContents["Tab setting"], "FPS Boost", 50, "FPSBoost")

-- Dropdown cho Teleport Mode
local TeleportModeLabel = Instance.new("TextLabel")
TeleportModeLabel.Size = UDim2.new(0, 200, 0, 30)
TeleportModeLabel.Position = UDim2.new(0.5, -100, 0, 90)
TeleportModeLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportModeLabel.Text = "Teleport Mode: Fly"
TeleportModeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportModeLabel.TextSize = 14
TeleportModeLabel.Parent = TabContents["Tab setting"]

local TeleportModeButton = Instance.new("TextButton")
TeleportModeButton.Size = UDim2.new(0, 100, 0, 30)
TeleportModeButton.Position = UDim2.new(0.5, 0, 0, 90)
TeleportModeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TeleportModeButton.Text = "Switch"
TeleportModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportModeButton.TextSize = 14
TeleportModeButton.Parent = TabContents["Tab setting"]

TeleportModeButton.MouseButton1Click:Connect(function()
    Toggles.TeleportMode = Toggles.TeleportMode == "Fly" and "Teleport" or "Fly"
    TeleportModeLabel.Text = "Teleport Mode: " .. Toggles.TeleportMode
end)

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
        if Toggles.AutoKillKatakuri or Toggles.AutoKillIndra then
            local bossName = Toggles.AutoKillKatakuri and "Katakuri" or "Indra"
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
        if Toggles.AutoPullLever then
            -- Bay đến Mirage Island (giả lập tọa độ)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0) -- Tọa độ giả lập
            wait(2)
            -- Bật tộc V3 (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awaken")
            wait(2)
            -- Lượm bánh răng (giả lập)
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
        if Toggles.AutoTrialV4 then
            -- Bật tộc V3
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awaken")
            wait(2)
            -- Hoàn thành trial (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CompleteTrial")
            wait(2)
            -- Giết người chơi gần nhất
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                    break
                end
            end
            wait(2)
            -- Chọn gear (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ChooseGear")
        end
        wait(1)
    end
end)

-- Auto Train V4 (farm Katakuri V1, bật tộc V4, mua gear)
spawn(function()
    while true do
        if Toggles.AutoTrainV4 then
            -- Farm Katakuri V1
            for _, boss in pairs(workspace.Enemies:GetChildren()) do
                if boss.Name:find("Katakuri") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                end
            end
            wait(2)
            -- Bật tộc V4 (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakenV4")
            wait(2)
            -- Mua gear (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGear")
        end
        wait(1)
    end
end)

-- Auto Buy Legendary Sword (Shisui, Saddi, Wando)
spawn(function()
    while true do
        if Toggles.AutoBuyLegendarySword then
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
            -- Kiểm tra điều kiện (giả lập, vì không thể kiểm tra trực tiếp)
            TeleportService:TeleportToPlaceInstance(PlaceID, server.id, LocalPlayer)
            break
        end
    end
end

spawn(function()
    while true do
        if Toggles.AutoHopKatakuri then
            ServerHop("Katakuri V2")
        elseif Toggles.AutoHopIndra then
            ServerHop("Indra")
        elseif Toggles.AutoHopMirage then
            ServerHop("Mirage Island")
        elseif Toggles.AutoHopFullMoon then
            ServerHop("Full Moon")
        elseif Toggles.AutoHopLegendarySword then
            ServerHop("Legendary Sword")
        end
        wait(10)
    end
end)

-- Fast Attack
spawn(function()
    while true do
        if Toggles.FastAttack then
            -- Giảm thời gian chờ giữa các đòn đánh (giả lập)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AttackSpeed", 0.1)
        end
        wait(0.1)
    end
end)

-- FPS Boost
spawn(function()
    while true do
        if Toggles.FPSBoost then
            -- Tắt hiệu ứng và giảm chất lượng đồ họa
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
        if Toggles.TeleportMode == "Fly" and not flying then
            StartFly()
        elseif Toggles.TeleportMode == "Teleport" then
            StopFly()
            -- Teleport logic (giả lập: dịch chuyển tức thời đến tọa độ gần nhất)
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
        status = status .. "Full Moon: Unknown\n" -- Không thể kiểm tra trực tiếp
        status = status .. "Legendary Sword: Unknown\n" -- Không thể kiểm tra trực tiếp

        status = status .. "\nAccount Status:\n"
        status = status .. "Level: " .. (LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or "Unknown") .. "\n"
        status = status .. "Beli: " .. (LocalPlayer.Data.Beli and LocalPlayer.Data.Beli.Value or "Unknown") .. "\n"
        status = status .. "Fragments: " .. (LocalPlayer.Data.Fragments and LocalPlayer.Data.Fragments.Value or "Unknown") .. "\n"

        StatusText.Text = status
        wait(5)
    end
end)

-- Hiển thị tab đầu tiên mặc định
TabContents["Tab farming"].Visible = true
TabFrame:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(0, 120, 255)"
git push origin main
