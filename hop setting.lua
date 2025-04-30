git add .
git commit -m "-- Tab Hopping
local TabContents = {}
for _, frame in pairs(game.Players.LocalPlayer.PlayerGui.BloxFruitGUI.MainFrame.ContentFrame:GetChildren()) do
    if frame:IsA("Frame") then
        TabContents[frame.Name] = frame
    end
end

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
        _G.Toggles[toggleKey] = not _G.Toggles[toggleKey]
        ToggleButton.Text = name .. ": " .. (_G.Toggles[toggleKey] and "BẬT" or "TẮT")
        ToggleButton.BackgroundColor3 = _G.Toggles[toggleKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    end)
end

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
    _G.Toggles.TeleportMode = _G.Toggles.TeleportMode == "Fly" and "Teleport" or "Fly"
    TeleportModeLabel.Text = "Teleport Mode: " .. _G.Toggles.TeleportMode
end)
"
git push origin main