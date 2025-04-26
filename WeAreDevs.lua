-- RedzXHub Mobile - Dead Rails (Tema Azul)

loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/main/Redz%20hub.md"))()
local Window = Library:CreateWindow("RedzXHub - Dead Rails", {
    theme = "Custom",  -- Tema personalizado
    backgroundColor = Color3.fromRGB(30, 30, 60),  -- Cor de fundo (azul escuro)
    buttonColor = Color3.fromRGB(0, 122, 255),  -- Cor dos botões (azul claro)
    textColor = Color3.fromRGB(255, 255, 255),  -- Cor do texto (branco)
    outlineColor = Color3.fromRGB(0, 85, 255)  -- Cor da borda (azul mais claro)
})

-- Aba principal
local CombatTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visual")
local SettingsTab = Window:CreateTab("Settings")

local ESPEnabled = false
local AuraEnabled = false
local range = 15
local espList = {}

-- ESP Função
local function toggleESP(state)
    ESPEnabled = state
    for _, v in pairs(espList) do
        if v and v.Parent then
            v.Enabled = ESPEnabled
        end
    end
end

-- Kill Aura Loop
game:GetService("RunService").RenderStepped:Connect(function()
    if AuraEnabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist <= range then
                    local args = {[1] = v.Character}
                    game:GetService("ReplicatedStorage").DamageEvent:FireServer(unpack(args))
                end
            end
        end
    end
end)

-- Função ESP por jogador
local function addESP(player)
    player.CharacterAdded:Connect(function(char)
        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(0, 122, 255)  -- Cor azul para o ESP
        highlight.OutlineColor = Color3.fromRGB(0, 85, 255)  -- Cor azul claro para o contorno
        highlight.Enabled = ESPEnabled
        highlight.Parent = char
        table.insert(espList, highlight)
    end)
    if player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(0, 122, 255)  -- Cor azul para o ESP
        highlight.OutlineColor = Color3.fromRGB(0, 85, 255)  -- Cor azul claro para o contorno
        highlight.Enabled = ESPEnabled
        highlight.Parent = player.Character
        table.insert(espList, highlight)
    end
end

-- Adiciona ESP a todos os jogadores
for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        addESP(v)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        addESP(player)
    end
end)

-- Aba Combat
CombatTab:Toggle("Kill Aura", false, function(value)
    AuraEnabled = value
end)

CombatTab:Slider("Aura Range", {
    min = 5,
    max = 50,
    default = 15
}, function(value)
    range = value
end)

-- Aba Visual
VisualTab:Toggle("ESP", false, function(value)
    toggleESP(value)
end)

-- Aba Settings
SettingsTab:Button("Fechar GUI", function()
    Library:Destroy()
end)
