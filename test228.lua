-- ============================================
-- ULTIMATE HUB V4.0 (Auto-Coins, Anti-AFK, Fullbright, Shaders, FPS Boost)
-- ============================================

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    StarterGui = game:GetService("StarterGui"),
    CoreGui = game:GetService("CoreGui"),
    VirtualUser = game:GetService("VirtualUser"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer

pcall(function()
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Ultimate Hub V4.0",
        Text = "Все функции успешно подгружены!",
        Duration = 3
    })
end)

-- Очистка старой версии GUI
if Services.CoreGui:FindFirstChild("UltimateHubV4") then
    Services.CoreGui.UltimateHubV4:Destroy()
end

-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHubV4"
ScreenGui.Parent = Services.CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.Position = UDim2.new(0.35, 0, 0.15, 0)
Main.Size = UDim2.new(0, 300, 0, 410)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)

-- Заголовок
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Text = "  ⚡ ULTIMATE HUB V4.0"
Title.Size = UDim2.new(0.65, 0, 1, 0)
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

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local CollapseBtn = Instance.new("TextButton", Header)
CollapseBtn.Size = UDim2.new(0, 26, 0, 26)
CollapseBtn.Position = UDim2.new(1, -64, 0, 7)
CollapseBtn.Text = "—"
CollapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 5)

local collapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    Main:TweenSize(collapsed and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 410), "Out", "Quad", 0.15, true)
end)

-- Контейнер
local Container = Instance.new("ScrollingFrame", Main)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.Size = UDim2.new(1, -20, 1, -58)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 0, 430)

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

-- 1. АНТИ-AFK (Защита от вылета)
local afkConnection
createToggle("Anti-AFK (Защита от кика)", true, function(active)
    if active then
        afkConnection = LocalPlayer.Idled:Connect(function()
            Services.VirtualUser:Button2Down(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
            task.wait(1)
            Services.VirtualUser:Button2Up(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
        end)
    else
        if afkConnection then afkConnection:Disconnect() end
    end
end)

-- 2. АВТОСБОР МОНЕТ
_G.AutoCoins = false
createToggle("Автосбор монет / Cash", false, function(active)
    _G.AutoCoins = active
end)

task.spawn(function()
    while true do
        task.wait(0.3)
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

-- 3. МАКСИМАЛЬНАЯ ЯРКОСТЬ (Fullbright)
local origAmbient = Services.Lighting.Ambient
local origOutdoor = Services.Lighting.OutdoorAmbient
local origBrightness = Services.Lighting.Brightness
local origFogEnd = Services.Lighting.FogEnd

createToggle("Макс. Яркость (Fullbright)", false, function(active)
    if active then
        Services.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Services.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Services.Lighting.Brightness = 2
        Services.Lighting.FogEnd = 1e10
        Services.Lighting.GlobalShadows = false
    else
        Services.Lighting.Ambient = origAmbient
        Services.Lighting.OutdoorAmbient = origOutdoor
        Services.Lighting.Brightness = origBrightness
        Services.Lighting.FogEnd = origFogEnd
        Services.Lighting.GlobalShadows = true
    end
end)

-- 4. РЕАЛИСТИЧНЫЕ ШЕЙДЕРЫ
local shaderFolder = nil
createToggle("Красивые Шейдеры", false, function(active)
    if active then
        shaderFolder = Instance.new("Folder", Services.Lighting)
        shaderFolder.Name = "HubShaders"

        local bloom = Instance.new("BloomEffect", shaderFolder)
        bloom.Intensity = 0.4
        bloom.Size = 24
        bloom.Threshold = 0.8

        local colorCorr = Instance.new("ColorCorrectionEffect", shaderFolder)
        colorCorr.Brightness = 0.05
        colorCorr.Contrast = 0.15
        colorCorr.Saturation = 0.25
        colorCorr.TintColor = Color3.fromRGB(255, 245, 230)

        local sunRays = Instance.new("SunRaysEffect", shaderFolder)
        sunRays.Intensity = 0.15
        sunRays.Spread = 0.8
    else
        if shaderFolder then
            shaderFolder:Destroy()
            shaderFolder = nil
        end
    end
end)

-- 5. ОПТИМИЗАЦИЯ ФПС (FPS Boost)
createToggle("Оптимизация (FPS Boost)", false, function(active)
    if active then
        for _, v in pairs(Services.Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        Services.Lighting.GlobalShadows = false
    end
end)

-- 6. ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ
createToggle("Player ESP", false, function(active)
    _G.PlayerESP = active
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("HubPlayerESP") or Instance.new("Highlight", p.Character)
            hl.Name = "HubPlayerESP"
            hl.FillColor = Color3.fromRGB(255, 50, 50)
            hl.Enabled = active
        end
    end
end)

createToggle("Скорость (Speed 50)", false, function(active)
    _G.SpeedHack = active
end)

Services.RunService.RenderStepped:Connect(function()
    if _G.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)
