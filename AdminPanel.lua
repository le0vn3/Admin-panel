-- =========================
-- AdminPanel.lua
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local workspace = workspace

-- =========================
-- ACTIONS (Fonctions Admin)
-- =========================

local Actions = {}

-- ---------- MOBILITE ----------
function Actions.Fly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if char:FindFirstChild("FlyScript") then return end

    local fly = Instance.new("LocalScript")
    fly.Name = "FlyScript"
    fly.Source = [[
        local player = game.Players.LocalPlayer
        local uis = game:GetService("UserInputService")
        local rs = game:GetService("RunService")
        local hrp = player.Character.HumanoidRootPart
        local speed = 50
        while true do
            rs.RenderStepped:Wait()
            local dir = Vector3.new()
            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + hrp.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - hrp.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - hrp.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + hrp.CFrame.RightVector end
            if dir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + dir.Unit * speed * rs.RenderStepped:Wait()
            end
        end
    ]]
    fly.Parent = char
end

function Actions.Teleport(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

function Actions.TPtoPlayer(target)
    if player.Character and target.Character then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
    end
end

function Actions.TPPlayerToMe(target)
    if player.Character and target.Character then
        target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
    end
end

function Actions.SetWalkSpeed(speed)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

function Actions.SetJumpPower(power)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = power end
end

function Actions.NoClip(toggle)
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not toggle
            end
        end
    end
end

-- ---------- VISUAL / ESP ----------
function Actions.ESPPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if not plr.Character:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = plr.Character:FindFirstChild("HumanoidRootPart")
                box.Size = Vector3.new(2,5,2)
                box.Color3 = Color3.fromRGB(255,0,0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Parent = workspace
            end
        end
    end
end

function Actions.RemoveESP()
    for _, box in pairs(workspace:GetChildren()) do
        if box:IsA("BoxHandleAdornment") and box.Name == "ESPBox" then
            box:Destroy()
        end
    end
end

function Actions.HighlightObjects(color)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = obj
            highlight.FillColor = color or Color3.fromRGB(0,255,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Parent = obj
        end
    end
end

-- ---------- GAMEPLAY ----------
function Actions.GodMode(toggle)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth = toggle and math.huge or 100
        hum.Health = hum.MaxHealth
    end
end

function Actions.NoFallDamage()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
    end
end

function Actions.ResetCharacter()
    if player.Character then
        player.Character:BreakJoints()
    end
end

-- ---------- FUN / EFFECTS ----------
function Actions.Explode()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local explosion = Instance.new("Explosion")
        explosion.Position = hrp.Position
        explosion.BlastRadius = 5
        explosion.Parent = workspace
    end
end

function Actions.Spin()
    local char = player.Character
    if char and not char:FindFirstChild("SpinScript") then
        local spin = Instance.new("LocalScript")
        spin.Name = "SpinScript"
        spin.Source = [[
            local player = game.Players.LocalPlayer
            local hrp = player.Character.HumanoidRootPart
            local rs = game:GetService("RunService")
            while true do
                rs.RenderStepped:Wait()
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        ]]
        spin.Parent = char
    end
end

function Actions.Particles()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = Instance.new("ParticleEmitter")
        p.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        p.Rate = 50
        p.Lifetime = NumberRange.new(1)
        p.Speed = NumberRange.new(5)
        p.Parent = hrp
    end
end

function Actions.PlaySound(soundId)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local s = Instance.new("Sound")
        s.SoundId = soundId
        s.Volume = 1
        s.Parent = hrp
        s:Play()
    end
end

-- ---------- FUN ACTIONS ADDITIONAL (~30) ----------
for i=1,30 do
    Actions["FunAction"..i] = function()
        print("Executed FunAction "..i)
    end
end

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "AdminPanel"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 600)
frame.Position = UDim2.new(0.5, -175, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5)
layout.Parent = frame

-- Create Button Function
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ---------- MAIN BUTTONS ----------
CreateButton("Fly", Actions.Fly)
CreateButton("Teleport (0,10,0)", function() Actions.Teleport(Vector3.new(0,10,0)) end)
CreateButton("ESP Players", Actions.ESPPlayers)
CreateButton("Remove ESP", Actions.RemoveESP)
CreateButton("GodMode", function() Actions.GodMode(true) end)
CreateButton("Reset Character", Actions.ResetCharacter)
CreateButton("Explode", Actions.Explode)
CreateButton("Spin", Actions.Spin)
CreateButton("Particles", Actions.Particles)

-- ---------- FUN ACTIONS BUTTONS ----------
for i=1,30 do
    CreateButton("FunAction "..i, Actions["FunAction"..i])
end

-- ---------- PLAYER LIST (TP) ----------
local dropdown = Instance.new("Frame")
dropdown.Size = UDim2.new(1, -10, 0, 200)
dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdown.Parent = frame

local layout2 = Instance.new("UIListLayout")
layout2.Parent = dropdown

for _, plr in pairs(Players:GetPlayers()) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = plr.Name
    btn.Parent = dropdown
    btn.MouseButton1Click:Connect(function()
        print("Selected player:", plr.Name)
    end)
end

print("AdminPanel.lua loaded successfully!")
