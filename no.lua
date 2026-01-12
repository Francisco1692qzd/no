-- Diretor de Coisas: Admin Hub v1.0
-- Alvo: Roblox / Ambiente: Luau (ExSer Executor)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Prefix = ";" -- Defina seu prefixo aqui

local Commands = {}

-- Funções Utilitárias
local function GetPlayer(Name)
    Name = Name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #Name) == Name then
            return player
        end
    end
end

-- --- REGISTRO DE COMANDOS ---

-- KILL: Tenta resetar o personagem (Client-side apenas para si, ou via Remote)
Commands.kill = function(args)
    local target = GetPlayer(args[1] or "")
    if target and target.Character then
        -- Nota: Sem RemoteEvent vulnerável, isso só funciona no seu próprio Char
        target.Character:BreakJoints()
        print("[*] Kill executado em: " .. target.Name)
    end
end

-- KICK: Só funcionará se você tiver permissão ou via vulnerabilidade de Remote
Commands.kick = function(args)
    local target = GetPlayer(args[1] or "")
    local reason = table.concat(args, " ", 2) or "Expulso pelo Diretor"
    if target then
        target:Kick(reason)
    end
end

-- SPEED: Altera a velocidade de caminhada
Commands.ws = function(args)
    local speed = tonumber(args[1]) or 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- RECON: Identifica RemoteEvents (Busca por brechas de Admin)
Commands.recon = function()
    print("[!] Iniciando varredura por RemoteEvents vulneráveis...")
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            print("Found Remote: " .. v:GetFullName())
        end
    end
end

-- --- CORE EXECUTION ---

local function ProcessCommand(msg)
    if msg:sub(1, #Prefix) == Prefix then
        local content = msg:sub(#Prefix + 1)
        local args = content:split(" ")
        local cmdName = table.remove(args, 1):lower()
        
        if Commands[cmdName] then
            Commands[cmdName](args)
        else
            warn("[-] Comando desconhecido: " .. cmdName)
        end
    end
end

-- Conexão com o Chat
LocalPlayer.Chatted:Connect(ProcessCommand)

print("--- Admin Hub Carregado ---")
print("Prefixo: " .. Prefix)
print("Comandos disponíveis: kill, kick, ws, recon")

-- no.
