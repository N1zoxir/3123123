-- ============================================
-- ULTIMATE HUB V5.1 (MM2 ROLE ESP & FIXES)
-- ============================================

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    StarterGui = game:GetService("StarterGui"),
    CoreGui = game:GetService("CoreGui"),
    VirtualUser = game:GetService("VirtualUser"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera

pcall(function()
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Ultimate Hub V5.1",
        Text = "Role ESP (MM2) добавлен!",
        Duration = 3
    })
end)

-- Очистка прошлых версий GUI
if Services.CoreGui:FindFirstChild("UltimateHubV5") then
    Services.CoreGui.UltimateHubV5:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHubV5"
ScreenGui.Parent = Services.CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ============================================
-- 1. КВАДРАТ ДЛЯ ОТКРЫТИЯ/ЗАКРЫТИЯ (Toggle Square)
-- ============================================
local OpenSquare = Instance.new("TextButton", ScreenGui)
OpenSquare.Name = "OpenSquare"
OpenSquare.Size = UDim2.new(0, 45, 0, 45)
OpenSquare.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenSquare.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
OpenSquare.Text = "⚡"
OpenSquare.TextColor3 = Color3.fromRGB(0, 210, 255)
OpenSquare.Font = Enum.Font.SourceSansBold
OpenSquare.TextSize = 24
OpenSquare.Active = true
OpenSquare.Draggable = true
Instance.new("UICorner", OpenSquare).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", OpenSquare)
UIStroke.Color = Color3.fromRGB(0, 210, 255)
UIStroke.Thickness = 2

-- Основное окно
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.Position = UDim2.new(0.35, 0, 0.18, 0)
Main.Size = UDim2.new(0, 310, 0, 420)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

OpenSquare.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Text = "  ⚡ ULTIMATE HUB V5.1"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Container
local Container = Instance.new("ScrollingFrame", Main)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.Size = UDim2.new(1, -20, 1, -58)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 0, 460)

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 7)

local function createToggle(name, default, callback)
    local state = default
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = state and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(28, 28, 40)
    btn.Text = "  " .. name .. ": " .. (state and "ВКЛ" or "ВЫКЛ")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(28, 28, 40)
        btn.Text = "  " .. name .. ": " .. (state and "ВКЛ" or "ВЫКЛ")
        callback(state)
    end)
    return btn
end

-- ============================================
-- 2. ОПРЕДЕЛЕНИЕ РОЛЕЙ И РОЛЕВОЙ ESP (MM2)
-- ============================================
local function getRoleColor(player)
    if not player then return Color3.fromRGB(0, 255, 0) end
    
    local hasKnife = false
    local hasGun = false

    local function checkTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        local n = tool.Name:lower()
        if n:find("knife") or n:find("blade") or n:find("dagger") or n:find("slash") or n:find("sword") then
            hasKnife = true
        elseif n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") or n:find("shotgun") then
            hasGun = true
        end
    end

    -- Проверка инвентаря
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do checkTool(tool) end
    end

    -- Проверка предметов в руках (в персе)
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do checkTool(tool) end
    end

    if hasKnife then
        return Color3.fromRGB(255, 30, 30)   -- 🔴 Убийца (Красный)
    elseif hasGun then
        return Color3.fromRGB(30, 120, 255)  -- 🔵 Шериф / Герой (Синий)
    else
        return Color3.fromRGB(30, 255, 30)   -- 🟢 Мирный (Зеленый)
    end
end

_G.PlayerESP = false

local function applyPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function updateChar(char)
        if not char then return end
        local hl = char:FindFirstChild("V5PlayerESP") or Instance.new("Highlight")
        hl.Name = "V5PlayerESP"
        hl.Adornee = char
        hl.FillColor = getRoleColor(player)
        hl.FillTransparency = 0.35
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.Enabled = _G.PlayerESP
        hl.Parent = char
    end

    if player.Character then updateChar(player.Character) end
    player.CharacterAdded:Connect(updateChar)
end

for _, p in pairs(Services.Players:GetPlayers()) do applyPlayerESP(p) end
Services.Players.PlayerAdded:Connect(applyPlayerESP)

-- Цикл непрерывного обновления цветов при смене ролей/оружия
Services.RunService.RenderStepped:Connect(function()
    if _G.PlayerESP then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("V5PlayerESP")
                if hl then
                    hl.FillColor = getRoleColor(p)
                    hl.Enabled = true
                end
            end
        end
    end
end)

createToggle("Role ESP (Красный/Синий/Зеленый)", false, function(active)
    _G.PlayerESP = active
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("V5PlayerESP") then
            p.Character.V5PlayerESP.Enabled = active
        end
    end
end)

-- ============================================
-- 3. ITEM ESP (Подсветка предметов/выпавшего пистолета)
-- ============================================
_G.ItemESP = false
createToggle("Item ESP (Предметы / Дроп)", false, function(active)
    _G.ItemESP = active
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and (obj.Name:lower():find("gun") or obj:FindFirstChild("Handle"))) then
            local hl = obj:FindFirstChild("V5ItemESP")
            if active then
                if not hl then
                    hl = Instance.new("Highlight", obj)
                    hl.Name = "V5ItemESP"
                    hl.FillColor = Color3.fromRGB(255, 220, 0)
                    hl.FillTransparency = 0.2
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end
        end
    end
end)

-- ============================================
-- 4. ОПТИМИЗАЦИЯ С ПОЛНЫМ ВОЗВРАТОМ
-- ============================================
local savedMaterials = {}
local savedDecals = {}
local savedParticles = {}

createToggle("Оптимизация (FPS Boost)", false, function(active)
    if active then
        savedMaterials = {}
        savedDecals = {}
        savedParticles = {}

        for _, v in pairs(Services.Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                savedMaterials[v] = {Mat = v.Material, Ref = v.Reflectance}
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                savedDecals[v] = v.Transparency
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                savedParticles[v] = v.Enabled
                v.Enabled = false
            end
        end
        Services.Lighting.GlobalShadows = false
    else
        -- ВОЗВРАТ ИСХОДНОЙ ГРАФИКИ
        for part, data in pairs(savedMaterials) do
            if part and part.Parent then
                part.Material = data.Mat
                part.Reflectance = data.Ref
            end
        end
        for decal, trans in pairs(savedDecals) do
            if decal and decal.Parent then
                decal.Transparency = trans
            end
        end
        for particle, enabled in pairs(savedParticles) do
            if particle and particle.Parent then
                particle.Enabled = enabled
            end
        end
        savedMaterials, savedDecals, savedParticles = {}, {}, {}
        Services.Lighting.GlobalShadows = true
    end
end)

-- ============================================
-- 5. АВТОСБОР МОНЕТ & ANTI-AFK
-- ============================================
_G.AutoCoins = false
createToggle("Автосбор монет", false, function(active)
    _G.AutoCoins = active
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoCoins and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(Services.Workspace:GetDescendants()) do
                if _G.AutoCoins and (obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash")) then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part and (part.Position - hrp.Position).Magnitude < 150 then
                        pcall(function()
                            firetouchinterest(hrp, part, 0)
                            firetouchinterest(hrp, part, 1)
                        end)
                    end
                end
            end
        end
    end
end)

createToggle("Anti-AFK", true, function(active)
    _G.AntiAFK = active
end)

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        Services.VirtualUser:Button2Down(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
        task.wait(1)
        Services.VirtualUser:Button2Up(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
    end
end)

-- ============================================
-- 6. СКОРОСТЬ, AIMBOT, ШЕЙДЕРЫ, BRIGHTNESS
-- ============================================
createToggle("Скорость (Speed 50)", false, function(active)
    _G.SpeedHack = active
    if not active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

Services.RunService.RenderStepped:Connect(function()
    if _G.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

_G.Aimbot = false
createToggle("Aimbot (Зажать ПКМ)", false, function(active)
    _G.Aimbot = active
end)

Services.RunService.RenderStepped:Connect(function()
    if _G.Aimbot and Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, dist = nil, 250
        local mousePos = Services.UserInputService:GetMouseLocation()
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if d < dist then dist = d; closest = head end
                end
            end
        end
        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end
end)

local shaderFolder = nil
createToggle("Красивые Шейдеры", false, function(active)
    if active then
        shaderFolder = Instance.new("Folder", Services.Lighting)
        shaderFolder.Name = "V5Shaders"
        
        local bloom = Instance.new("BloomEffect", shaderFolder)
        bloom.Intensity = 0.4
        bloom.Size = 24
        bloom.Threshold = 0.8

        local colorCorr = Instance.new("ColorCorrectionEffect", shaderFolder)
        colorCorr.Contrast = 0.15
        colorCorr.Saturation = 0.25

        local sunRays = Instance.new("SunRaysEffect", shaderFolder)
        sunRays.Intensity = 0.15
    else
        if shaderFolder then shaderFolder:Destroy() shaderFolder = nil end
    end
end)

local origAmbient = Services.Lighting.Ambient
createToggle("Макс. Яркость (Fullbright)", false, function(active)
    if active then
        Services.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Services.Lighting.Brightness = 2
    else
        Services.Lighting.Ambient = origAmbient
        Services.Lighting.Brightness = 1
    end
end)
