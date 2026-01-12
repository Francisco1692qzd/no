-- [[ DIRETOR DE COISAS - ABDUCTION & PURGATORY ]]
-- Requer execução Server-Side (ExSer)

local Players = game:GetService("Players")
local MyUserID = 10332395210
local Me = Players:GetPlayerByUserId(MyUserID)

-- 1. CRIAR O PURGATÓRIO (Longe de tudo)
local function CreatePurgatory()
    local folder = Instance.new("Folder", workspace)
    folder.Name = "TheVoid_Purgatory"
    
    local pos = Vector3.new(0, -5000, 0) -- Profundidade extrema
    
    local box = Instance.new("Part", folder)
    box.Size = Vector3.new(20, 1, 20)
    box.Position = pos
    box.Anchored = true
    box.Color = Color3.new(0, 0, 0)
    box.Material = Enum.Material.Concrete
    
    -- Paredes invisíveis para impedir fuga
    local function Wall(size, offset)
        local w = Instance.new("Part", folder)
        w.Size = size
        w.Position = pos + offset
        w.Anchored = true
        w.Transparency = 1
        w.CanCollide = true
    end
    
    Wall(Vector3.new(20, 20, 1), Vector3.new(0, 10, 10))
    Wall(Vector3.new(20, 20, 1), Vector3.new(0, 10, -10))
    Wall(Vector3.new(1, 20, 20), Vector3.new(10, 10, 0))
    Wall(Vector3.new(1, 20, 20), Vector3.new(-10, 10, 0))
    Wall(Vector3.new(20, 1, 20), Vector3.new(0, 20, 0)) -- Teto
    
    return pos + Vector3.new(0, 3, 0)
end

local PurgatoryPos = CreatePurgatory()

-- 2. FUNÇÃO DE SEQUESTRO
local function Abduct(targetName)
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #targetName) == targetName:lower() then
            target = p
            break
        end
    end

    if target and target.Character then
        -- Desabilita ferramentas
        target.Backpack:ClearAllChildren()
        
        -- Efeito de som antes do sumiço
        local sound = Instance.new("Sound", target.Character.HumanoidRootPart)
        sound.SoundId = "rbxassetid://163619849" -- Som de "Glitch/Static"
        sound:Play()
        
        task.wait(0.5)
        
        -- Teleporte para o Purgatório
        target.Character.HumanoidRootPart.CFrame = CFrame.new(PurgatoryPos)
        
        -- Injeta escuridão local extrema no alvo
        local ls = Instance.new("LocalScript", target.PlayerGui)
        ls.Source = [[
            local l = game:GetService("Lighting")
            while true do
                l.Ambient = Color3.new(0,0,0)
                l.FogEnd = 10
                task.wait(1)
            end
        ]]
        
        print("[!] Alvo " .. target.Name .. " foi enviado ao Vazio.")
    end
end

-- 3. ESCUTA DE COMANDO NO CHAT
Me.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    if args[1] == ";abduct" then
        Abduct(args[2])
    elseif args[1] == ";bringvoid" then
        -- Traz você para o purgatório para encarar a vítima
        Me.Character.HumanoidRootPart.CFrame = CFrame.new(PurgatoryPos)
    end
end)

print("--- SISTEMA DE SEQUESTRO ATIVO ---")
print("Use: ;abduct [nome] ou ;bringvoid")
