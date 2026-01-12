-- [[ DIRETOR DE COISAS - SS GUI ADMIN ]]
-- Executor: ExSer (Server-Side)

local Players = game:GetService("Players")
local UserID = 10332395210 -- [[ SUBSTITUA PELO SEU USER ID AQUI ]]

local function CreateGUI(targetPlayer)
    -- Remover GUI antiga se existir
    local existing = targetPlayer.PlayerGui:FindFirstChild("ExSer_Admin")
    if existing then existing:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExSer_Admin"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = targetPlayer.PlayerGui

    -- Frame Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.Text = "EXSER SS ADMIN"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.Code
    Title.Parent = MainFrame

    -- Input do Nome do Alvo
    local TargetBox = Instance.new("TextBox")
    TargetBox.Size = UDim2.new(0.9, 0, 0, 35)
    TargetBox.Position = UDim2.new(0.05, 0, 0.15, 0)
    TargetBox.PlaceholderText = "Nome do Jogador..."
    TargetBox.Text = ""
    TargetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TargetBox.TextColor3 = Color3.new(1, 1, 1)
    TargetBox.Parent = MainFrame

    -- Layout de Botões
    local function CreateButton(text, pos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.4, 0, 0, 35)
        btn.Position = pos
        btn.Text = text
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.Parent = MainFrame
        btn.MouseButton1Click:Connect(function()
            local target = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p.Name:lower():sub(1, #TargetBox.Text) == TargetBox.Text:lower() then
                    target = p
                    break
                end
            end
            callback(target)
        end)
    end

    -- Definição das Ações SS
    CreateButton("KILL", UDim2.new(0.05, 0, 0.35, 0), Color3.fromRGB(180, 50, 50), function(t)
        if t and t.Character then t.Character:BreakJoints() end
    end)

    CreateButton("KICK", UDim2.new(0.55, 0, 0.35, 0), Color3.fromRGB(180, 100, 50), function(t)
        if t then t:Kick("Expulso pelo Diretor via SS GUI") end
    end)

    CreateButton("BAN", UDim2.new(0.05, 0, 0.5, 0), Color3.fromRGB(100, 0, 0), function(t)
        if t then 
            -- Lógica de Ban de Sessão
            local id = t.UserId
            t:Kick("Banido do Servidor.")
            Players.PlayerAdded:Connect(function(newP)
                if newP.UserId == id then newP:Kick("Banido.") end
            end)
        end
    end)

    CreateButton("FREEZE", UDim2.new(0.55, 0, 0.5, 0), Color3.fromRGB(50, 100, 180), function(t)
        if t and t.Character then
            for _, part in pairs(t.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = not part.Anchored end
            end
        end
    end)

    CreateButton("CRASH", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(0, 0, 0), function(t)
        if t then
            local s = Instance.new("LocalScript", t.PlayerGui)
            s.Source = "while true do end"
        end
    end)
    
    CreateButton("GIVE ADMIN", UDim2.new(0.55, 0, 0.65, 0), Color3.fromRGB(50, 180, 50), function(t)
        if t then CreateGUI(t) end -- Dá a interface para outro jogador
    end)

    print("[*] GUI injetada para " .. targetPlayer.Name)
end

-- Execução Inicial
local p = Players:GetPlayerByUserId(UserID)
if p then
    CreateGUI(p)
else
    -- Se você ainda não entrou, espera você entrar
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer.UserId == UserID then
            CreateGUI(newPlayer)
        end
    end)
end
