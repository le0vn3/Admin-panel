-- AdminPanelGUI.lua
local AdminActions = require(script.Parent:WaitForChild("AdminActions"))

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Création du GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 600)
frame.Position = UDim2.new(0.5, -175, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,5)
uiList.Parent = frame

-- Fonction pour créer bouton
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

-- Liste de joueurs
local function CreatePlayerDropdown()
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, -10, 0, 200)
    dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
    dropdown.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Parent = dropdown

    for _, plr in pairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Text = plr.Name
        btn.Parent = dropdown
        btn.MouseButton1Click:Connect(function()
            print("Selected player:", plr.Name)
        end)
    end
end

-- Ajout des boutons principaux
CreateButton("Fly", function() AdminActions:Fly(player) end)
CreateButton("Teleport to (0,10,0)", function() AdminActions:Teleport(player, Vector3.new(0,10,0)) end)
CreateButton("ESP Players", function() AdminActions:ESPPlayers(player) end)
CreateButton("Remove ESP", function() AdminActions:RemoveESP() end)
CreateButton("GodMode", function() AdminActions:GodMode(player, true) end)
CreateButton("Reset Character", function() AdminActions:ResetCharacter(player) end)
CreateButton("Explode", function() AdminActions:Explode(player) end)
CreateButton("Spin", function() AdminActions:SpinPlayer(player, 10) end)
CreateButton("Particles", function() AdminActions:Particles(player) end)

-- Crée la liste de joueurs
CreatePlayerDropdown()

-- Ajout des fun actions dynamiques (~30)
for i=1,30 do
    CreateButton("Fun Action "..i, function()
        AdminActions["FunAction"..i](player)
    end)
end
