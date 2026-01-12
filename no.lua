-- [[ DIRETOR DE COISAS - SS GUI ADMIN FIX ]]
-- Otimizado para ExSer (Server-Side)

local Players = game:GetService("Players")
local UserID = 10332395210 -- Seu ID fornecido

local function BuildInterface(targetPlayer)
    -- Garantir que o PlayerGui existe antes de prosseguir
    local pGui = targetPlayer:WaitForChild("PlayerGui", 10)
    if not pGui then return warn("[-] Falha crítica: PlayerGui não encontrado para " .. targetPlayer.Name) end

    -- Cleanup
    if pGui:FindFirstChild("ExSer_Admin") then pGui.ExSer_Admin:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "ExSer_Admin"
    sg.DisplayOrder = 999 -- Garante que fique acima de qualquer outra UI
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = pGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 320)
    frame.Position = UDim2.new(0.5, -130, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(0, 120, 215) -- Azul destaque
    title.Text = "DIRETOR SS HUB"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.Code
    title.Parent = frame

    local targetInput = Instance.new("TextBox")
    targetInput.Size = UDim2.new(0.9, 0, 0, 30)
    targetInput.Position = UDim2.new(0.05, 0, 0.15, 0)
    targetInput.PlaceholderText = "Nome do Alvo..."
    targetInput.Text = ""
    targetInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    targetInput.TextColor3 = Color3.new(1, 1, 1)
    targetInput.Parent = frame

    -- Função de ajuda para botões
    local function AddBtn(txt, pos, color, action)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.42, 0, 0, 35)
        b.Position = pos
        b.Text = txt
        b.BackgroundColor3 = color
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        b.Parent = frame
        b.MouseButton1Click:Connect(function()
            local t = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player.Name:lower():sub(1, #targetInput.Text) == targetInput.Text:lower() then
                    t = player
                    break
                end
            end
            action(t)
        end)
    end

    -- Comandos SS
    AddBtn("KILL", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(150, 0, 0), function(t) if t and t.Character then t.Character:BreakJoints() end end)
    AddBtn("KICK", UDim2.new(0.53, 0, 0.3, 0), Color3.fromRGB(150, 75, 0), function(t) if t then t:Kick("SS-KICK") end end)
    AddBtn("CRASH", UDim2.new(0.05, 0, 0.45, 0), Color3.fromRGB(0, 0, 0), function(t) 
        if t then 
            local ls = Instance.new("LocalScript", t.PlayerGui)
            ls.Source = "while true do end"
        end 
    end)
    AddBtn("FIRE", UDim2.new(0.53, 0, 0.45, 0), Color3.fromRGB(255, 100, 0), function(t)
        if t and t.Character then Instance.new("Fire", t.Character:FindFirstChild("HumanoidRootPart")) end
    end)
    AddBtn("NIL (INVISIBLE)", UDim2.new(0.05, 0, 0.6, 0), Color3.fromRGB(80, 80, 80), function(t)
        if t and t.Character then t.Character.Parent = game.Lighting end
    end)
    AddBtn("RE-ADMIN", UDim2.new(0.53, 0, 0.6, 0), Color3.fromRGB(0, 150, 0), function(t) BuildInterface(targetPlayer) end)

    print("[+] GUI Injetada com sucesso em " .. targetPlayer.Name)
end

-- Lógica de Execução Robusta
local p = Players:GetPlayerByUserId(UserID)
if p then
    BuildInterface(p)
else
    warn("[!] Você não está no servidor. Aguardando entrada do UserID: " .. UserID)
end

Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer.UserId == UserID then
        wait(2) -- Delay de segurança para replicação do PlayerGui
        BuildInterface(newPlayer)
    end
end)
