-- ============================================
-- ULTIMATE HUB V6.0 (TABBED UI, WORKING FEATURES, REWORKED DESIGN)
-- ============================================

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    StarterGui = game:GetService("StarterGui"),
    CoreGui = game:GetService("CoreGui"),
    VirtualUser = game:GetService("VirtualUser"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera

pcall(function()
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Ultimate Hub V6.0",
        Text = "Успешно загружен новый интерфейс!",
        Duration = 3
    })
end)

-- Очистка предыдущих версий
if Services.CoreGui:FindFirstChild("UltimateHubV6") then
    Services.CoreGui.UltimateHubV6:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHubV6"
ScreenGui.Parent = Services.CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ============================================
-- 1. ПЛАВАЮЩИЙ ИКОНКА-КВАДРАТ (Minimizable Button)
-- ============================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 26
OpenBtn.Active = true
OpenBtn.Draggable = true

local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0, 12)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(0, 210, 255)
OpenStroke.Thickness = 2

-- ============================================
-- 2. ОСНОВНОЕ ОКНО С ВКТАДКАМИ
-- ============================================
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Visible = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(35, 35, 50)
MainStroke.Thickness = 1.5

-- Переключение видимости
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Заголовок (Top Bar)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "   ⚡ ULTIMATE HUB  |  V6.0"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 6)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Боковая панель категорий (Sidebar)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.Size = UDim2.new(0, 125, 1, -38)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Sidebar.BorderSizePixel = 0

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)

-- Контейнер содержимого вкладок
local ContentArea = Instance.new("Frame", Main)
ContentArea.Position = UDim2.new(0, 130, 0, 42)
ContentArea.Size = UDim2.new(1, -135, 1, -47)
ContentArea.BackgroundTransparency = 1

-- Система переключения вкладок
local tabs = {}
local currentTab = nil

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.Size = UDim2.new(1, -8, 0, 34)
    tabBtn.Position = UDim2.new(0, 4, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    tabBtn.Text = " " .. icon .. " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 14
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local tabContainer = Instance.new("ScrollingFrame", ContentArea)
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Visible = false
    tabContainer.ScrollBarThickness = 3
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 350)

    local list = Instance.new("UIListLayout", tabContainer)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
            t.Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
            t.Container.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabContainer.Visible = true
    end)

    table.insert(tabs, {Btn = tabBtn, Container = tabContainer})
    if #tabs == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabContainer.Visible = true
    end

    return tabContainer
end

local function addToggle(container, name, default, callback)
    local state = default
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, -6, 0, 36)
    btn.BackgroundColor3 = state and Color3.fromRGB(35, 140, 70) or Color3.fromRGB(26, 26, 36)
    btn.Text = "  " .. name .. " — [" .. (state and "ВКЛ" or "ВЫКЛ") .. "]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(35, 140, 70) or Color3.fromRGB(26, 26, 36)
        btn.Text = "  " .. name .. " — [" .. (state and "ВКЛ" or "ВЫКЛ") .. "]"
        callback(state)
    end)
    return btn
end

-- Вкладки
local combatTab  = createTab("Бой", "🎯")
local visualsTab = createTab("Визуалы", "👁️")
local graphicsTab= createTab("Графика", "✨")
local miscTab    = createTab("Разное", "⚙️")

-- ============================================
-- 🎯 ВКЛАДКА: БОЙ (Combat)
-- ============================================
_G.Aimbot = false
addToggle(combatTab, "Aimbot (Зажать ПКМ)", false, function(active)
    _G.Aimbot = active
end)

Services.RunService.RenderStepped:Connect(function()
    if _G.Aimbot and Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, dist = nil, 300
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

-- ============================================
-- 👁️ ВКЛАДКА: ВИЗУАЛЫ (Visuals & Role ESP)
-- ============================================
local function getRoleColor(player)
    if not player then return Color3.fromRGB(0, 255, 0) end
    local hasKnife, hasGun = false, false

    local function checkTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        local n = tool.Name:lower()
        if n:find("knife") or n:find("blade") or n:find("dagger") or n:find("sword") then
            hasKnife = true
        elseif n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then
            hasGun = true
        end
    end

    if player:FindFirstChild("Backpack") then
        for _, t in pairs(player.Backpack:GetChildren()) do checkTool(t) end
    end
    if player.Character then
        for _, t in pairs(player.Character:GetChildren()) do checkTool(t) end
    end

    if hasKnife then return Color3.fromRGB(255, 30, 30) end    -- 🔴 Убийца
    if hasGun then return Color3.fromRGB(30, 130, 255) end     -- 🔵 Шериф
    return Color3.fromRGB(40, 255, 40)                         -- 🟢 Мирный
end

_G.PlayerESP = false
local function applyPlayerESP(player)
    if player == LocalPlayer then return end
    local function updateChar(char)
        if not char then return end
        local hl = char:FindFirstChild("V6PlayerESP") or Instance.new("Highlight")
        hl.Name = "V6PlayerESP"
        hl.Adornee = char
        hl.FillColor = getRoleColor(player)
        hl.FillTransparency = 0.3
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Enabled = _G.PlayerESP
        hl.Parent = char
    end
    if player.Character then updateChar(player.Character) end
    player.CharacterAdded:Connect(updateChar)
end

for _, p in pairs(Services.Players:GetPlayers()) do applyPlayerESP(p) end
Services.Players.PlayerAdded:Connect(applyPlayerESP)

Services.RunService.RenderStepped:Connect(function()
    if _G.PlayerESP then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("V6PlayerESP")
                if hl then
                    hl.FillColor = getRoleColor(p)
                    hl.Enabled = true
                end
            end
        end
    end
end)

addToggle(visualsTab, "Role ESP (🔴 Убийца / 🔵 Шериф / 🟢 Мирный)", false, function(active)
    _G.PlayerESP = active
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("V6PlayerESP") then
            p.Character.V6PlayerESP.Enabled = active
        end
    end
end)

_G.ItemESP = false
addToggle(visualsTab, "Item ESP (Подсветка оружия и монет)", false, function(active)
    _G.ItemESP = active
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
            local hl = obj:FindFirstChild("V6ItemESP")
            if active then
                if not hl then
                    hl = Instance.new("Highlight", obj)
                    hl.Name = "V6ItemESP"
                    hl.FillColor = Color3.fromRGB(255, 220, 0)
                end
                hl.Enabled = true
            elseif hl then
                hl.Enabled = false
            end
        end
    end
end)

-- ============================================
-- ✨ ВКЛАДКА: ГРАФИКАИ ШЕЙДЕРЫ (Graphics & Boost)
-- ============================================
local origAmbient = Services.Lighting.Ambient
addToggle(graphicsTab, "Макс. Яркость (Fullbright)", false, function(active)
    if active then
        Services.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Services.Lighting.Brightness = 2
    else
        Services.Lighting.Ambient = origAmbient
        Services.Lighting.Brightness = 1
    end
end)

local shaderFolder = nil
addToggle(graphicsTab, "Красивые Шейдеры (Bloom / SunRays)", false, function(active)
    if active then
        shaderFolder = Instance.new("Folder", Services.Lighting)
        shaderFolder.Name = "V6Shaders"
        
        local bloom = Instance.new("BloomEffect", shaderFolder)
        bloom.Intensity = 0.45
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

local savedMaterials, savedDecals, savedParticles = {}, {}, {}
addToggle(graphicsTab, "Оптимизация (FPS Boost)", false, function(active)
    if active then
        savedMaterials, savedDecals, savedParticles = {}, {}, {}
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
        -- ВОЗВРАТ НАСТРОЕК ГРАФИКИ
        for part, data in pairs(savedMaterials) do
            if part and part.Parent then part.Material = data.Mat part.Reflectance = data.Ref end
        end
        for decal, trans in pairs(savedDecals) do
            if decal and decal.Parent then decal.Transparency = trans end
        end
        for particle, enabled in pairs(savedParticles) do
            if particle and particle.Parent then particle.Enabled = enabled end
        end
        savedMaterials, savedDecals, savedParticles = {}, {}, {}
        Services.Lighting.GlobalShadows = true
    end
end)

-- ============================================
-- ⚙️ ВКЛАДКА: РАЗНОЕ (Misc)
-- ============================================
_G.AutoCoins = false
addToggle(miscTab, "Автосбор монет / Cash", false, function(active)
    _G.AutoCoins = active
end)

task.spawn(function()
    while true do
        task.wait(0.25)
        if _G.AutoCoins and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(Services.Workspace:GetDescendants()) do
                if _G.AutoCoins and (obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash") or obj.Name:lower():find("drop")) then
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

_G.AntiAFK = true
addToggle(miscTab, "Anti-AFK (Защита от вылета)", true, function(active)
    _G.AntiAFK = active
end)

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        Services.VirtualUser:Button2Down(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
        task.wait(1)
        Services.VirtualUser:Button2Up(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
    end
end)

addToggle(miscTab, "Скорость бега (Speed 50)", false, function(active)
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
