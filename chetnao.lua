git init
git add BloxFruitCompleteKavoUIScript.lua
git commit -m "-- Script chạy trong Roblox Studio: GUI hoàn chỉnh với Kavo UI, Hop Server, Farming và Auto Farm Bone
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")

-- Tải Kavo UI Library
local Kavo = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Blox Fruit Script", "DarkTheme")

-- Hàm tạo quái Bone giả lập
local function spawnBoneEnemy()
    local enemy = Instance.new("Model")
    enemy.Name = "BoneEnemy"
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 4, 2)
    part.Position = Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))
    part.BrickColor = BrickColor.new("White")
    part.Anchored = false
    part.CanCollide = true
    part.Parent = enemy

    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    humanoid.Parent = enemy
    enemy.PrimaryPart = part
    enemy.Parent = Workspace

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.Parent = part

    return enemy
end

-- Hàm di chuyển đến vị trí
local function moveToPosition(player, position)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoid = character.Humanoid
    local path = PathfindingService:CreatePath()
    path:ComputeAsync(character.HumanoidRootPart.Position, position)
    local waypoints = path:GetWaypoints()

    for _, waypoint in pairs(waypoints) do
        humanoid:MoveTo(waypoint.Position)
        humanoid.MoveToFinished:Wait()
    end
end

-- Hàm farm Bone
local function farmBone(player, boneLabel)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoid = character.Humanoid
    local rootPart = character.HumanoidRootPart
    local closestEnemy = nil
    local minDistance = math.huge

    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy.Name == "BoneEnemy" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (enemy.PrimaryPart.Position - rootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestEnemy = enemy
            end
        end
    end

    if closestEnemy then
        moveToPosition(player, closestEnemy.PrimaryPart.Position)
        closestEnemy.Humanoid.Health = 0
        closestEnemy:Destroy()
        spawnBoneEnemy() -- Tạo quái Bone mới
        local boneCount = player:GetAttribute("BoneCount") or 0
        boneCount = boneCount + 1
        player:SetAttribute("BoneCount", boneCount)
        boneLabel.Text = "Bones: " .. boneCount
        print("Thu thập " .. boneCount .. " Bones!")
        return true
    end
    return false
end

-- Xử lý người chơi
Players.PlayerAdded:Connect(function(player)
    player:SetAttribute("BoneCount", 0)
    player:SetAttribute("LegendarySword", false)
    player:SetAttribute("TrialV4Complete", false)

    -- Tab Hop Server
    local HopServerTab = Window:NewTab("Hop Server")
    local HopServerSection = HopServerTab:NewSection("Server Hop Features")

    local hopFeatures = {
        "Katakuri V2",
        "Indra",
        "Mirage",
        "Legendary Sword",
        "Full Moon"
    }

    for _, feature in pairs(hopFeatures) do
        HopServerSection:NewToggle("Auto Hop " .. feature, "Tìm server với " .. feature, function(state)
            print(player.Name .. " toggled Auto Hop " .. feature .. (state and " ON" or " OFF"))
            if state then
                print("Đang tìm server với " .. feature .. "...")
            end
        end)
    end

    -- Tab Farming
    local FarmingTab = Window:NewTab("Farming")
    local FarmingSection = FarmingTab:NewSection("Farming Features")
    local BoneLabel = FarmingSection:NewLabel("Bones: 0")

    FarmingSection:NewButton("Auto Kill Boss (Katakuri/Indra)", "Tấn công boss", function()
        print("Bắt đầu Auto Kill Boss...")
        local bossPos = Vector3.new(50, 10, 50)
        moveToPosition(player, bossPos)
        print("Đang tấn công boss Katakuri/Indra!")
    end)

    FarmingSection:NewButton("Auto Buy Legendary Sword", "Mua Legendary Sword", function()
        print("Đang mua Legendary Sword...")
        player:SetAttribute("LegendarySword", true)
        print("Đã mua Legendary Sword!")
    end)

    FarmingSection:NewButton("Auto Pull Lever", "Thực hiện kéo cần", function()
        print("Bắt đầu Auto Pull Lever...")
        local steps = {
            {pos = Vector3.new(0, 10, 0), msg = "Nhận nhiệm vụ kéo cần"},
            {pos = Vector3.new(100, 10, 100), msg = "Bay đến Mirage Island"},
            {pos = Vector3.new(100, 10, 100), msg = "Nhìn trăng"},
            {pos = Vector3.new(100, 10, 100), msg = "Bật tộc V3"},
            {pos = Vector3.new(150, 10, 150), msg = "Dịch chuyển đến bánh răng"}
        }
        for _, step in pairs(steps) do
            moveToPosition(player, step.pos)
            print(step.msg)
            wait(1)
        end
        print("Hoàn thành Auto Pull Lever!")
    end)

    FarmingSection:NewButton("Auto Trial V4", "Hoàn thành Trial V4", function()
        print("Bắt đầu Auto Trial V4...")
        print("Bật tộc V3 khi người chơi khác bật...")
        print("Hoàn thành trial...")
        local enemyPos = Vector3.new(200, 10, 200)
        moveToPosition(player, enemyPos)
        print("Đang kill player với skill...")
        player:SetAttribute("TrialV4Complete", true)
        print("Chọn gear và train...")
        print("Hoàn thành Auto Trial V4!")
    end)

    FarmingSection:NewToggle("Auto Farm Bone", "Tự động farm Bone", function(state)
        if state then
            spawnBoneEnemy() -- Tạo quái Bone mới nếu chưa có
            while state and player.Character do
                farmBone(player, BoneLabel)
                wait(0.5)
            end
        end
    end)
end)

-- Tạo quái Bone ban đầu
spawnBoneEnemy()"
git remote add origin <URL-repository>
git push -u origin main
