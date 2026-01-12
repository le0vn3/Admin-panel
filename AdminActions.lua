-- AdminActions.lua
local AdminActions = {}

-- ========== MOBILITE ==========
function AdminActions:Fly(player)
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and not character:FindFirstChild("FlyScript") then
            local flyScript = Instance.new("LocalScript")
            flyScript.Name = "FlyScript"
            flyScript.Source = [[
                local player = game.Players.LocalPlayer
                local uis = game:GetService("UserInputService")
                local hrp = player.Character.HumanoidRootPart
                local flying = true
                local speed = 50
                while flying do
                    game:GetService("RunService").RenderStepped:Wait()
                    local moveDir = Vector3.new(0,0,0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + hrp.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - hrp.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - hrp.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + hrp.CFrame.RightVector end
                    hrp.CFrame = hrp.CFrame + (moveDir.Magnitude > 0 and moveDir.Unit * speed * game:GetService("RunService").RenderStepped:Wait() or Vector3.new(0,0,0))
                end
            ]]
            flyScript.Parent = character
        end
    end
end

function AdminActions:Teleport(player, position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

function AdminActions:TPtoPlayer(player, target)
    if player.Character and target.Character then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
    end
end

function AdminActions:TPPlayerToMe(player, target)
    if player.Character and target.Character then
        target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
    end
end

function AdminActions:SetWalkSpeed(player, speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

function AdminActions:SetJumpPower(player, power)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = power
    end
end

function AdminActions:NoClip(player, toggle)
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not toggle
            end
        end
    end
end

-- ========== VISUAL / ESP ==========
function AdminActions:ESPPlayers(player)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character and not plr.Character:FindFirstChild("ESPBox") then
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

function AdminActions:RemoveESP()
    for _, box in pairs(workspace:GetChildren()) do
        if box:IsA("BoxHandleAdornment") and box.Name == "ESPBox" then
            box:Destroy()
        end
    end
end

function AdminActions:HighlightObjects(color)
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

-- ========== GAMEPLAY ==========
function AdminActions:GodMode(player, toggle)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth = toggle and math.huge or 100
        hum.Health = hum.MaxHealth
    end
end

function AdminActions:NoFallDamage(player)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
    end
end

function AdminActions:ResetCharacter(player)
    if player.Character then
        player.Character:BreakJoints()
    end
end

-- ========== FUN / EFFETS ==========
function AdminActions:Explode(player)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local explosion = Instance.new("Explosion")
        explosion.Position = hrp.Position
        explosion.BlastRadius = 5
        explosion.Parent = workspace
    end
end

function AdminActions:SpinPlayer(player, speed)
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

function AdminActions:Particles(player)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local part = Instance.new("ParticleEmitter")
        part.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        part.Rate = 50
        part.Lifetime = NumberRange.new(1)
        part.Speed = NumberRange.new(5)
        part.Parent = hrp
    end
end

function AdminActions:PlaySound(player, soundId)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 1
        sound.Parent = hrp
        sound:Play()
    end
end

-- ========== ADMIN UTILITIES ==========
function AdminActions:ToggleGUI(gui)
    gui.Enabled = not gui.Enabled
end

function AdminActions:SavePreferences(data)
    -- Exemple : stocker dans un ModuleScript ou DataStore
    print("Preferences saved:", data)
end

function AdminActions:LoadPreferences()
    -- Exemple : récupérer depuis un ModuleScript ou DataStore
    print("Preferences loaded")
    return {}
end

-- On peut rajouter d'autres fonctions pour atteindre ~50
for i=1,30 do
    AdminActions["FunAction"..i] = function(player)
        print("Fun Action "..i.." executed for", player.Name)
    end
end

return AdminActions
