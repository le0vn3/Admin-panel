-- Local Admin Panel - 100% local
-- LocalScript à mettre dans StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Variables pour le No-Clip / GoMode
local noClip = false
local goMode = false
local flySpeed = 50

-- Crée le GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LocalAdminPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Local Admin Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = frame

-- Helper function pour créer des boutons
local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- Téléportation à un point
createButton("TP to 0,50,0", 70, function()
    hrp.CFrame = CFrame.new(0,50,0)
end)

createButton("TP to 0,100,0", 120, function()
    hrp.CFrame = CFrame.new(0,100,0)
end)

-- No-Clip toggle
createButton("Toggle No-Clip", 170, function()
    noClip = not noClip
end)

-- Go-Mode toggle (vol / super vitesse)
createButton("Toggle Go Mode", 220, function()
    goMode = not goMode
end)

-- Loop pour No-Clip et GoMode
RunService.RenderStepped:Connect(function()
    if noClip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    if goMode then
        local moveDir = Vector3.new(0,0,0)
        local keys = {
            W = Enum.KeyCode.W,
            S = Enum.KeyCode.S,
            A = Enum.KeyCode.A,
            D = Enum.KeyCode.D,
            Space = Enum.KeyCode.Space,
            LeftShift = Enum.KeyCode.LeftShift
        }
        local userInput = game:GetService("UserInputService")
        local velocity = Vector3.new(0,0,0)

        if userInput:IsKeyDown(keys.W) then velocity = velocity + hrp.CFrame.LookVector end
        if userInput:IsKeyDown(keys.S) then velocity = velocity - hrp.CFrame.LookVector end
        if userInput:IsKeyDown(keys.A) then velocity = velocity - hrp.CFrame.RightVector end
        if userInput:IsKeyDown(keys.D) then velocity = velocity + hrp.CFrame.RightVector end
        if userInput:IsKeyDown(keys.Space) then velocity = velocity + Vector3.new(0,1,0) end
        if userInput:IsKeyDown(keys.LeftShift) then velocity = velocity - Vector3.new(0,1,0) end

        hrp.Velocity = velocity.Unit * flySpeed
    end
end)

print("Local Admin Panel loaded!")
