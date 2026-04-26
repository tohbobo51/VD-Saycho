-- ======================
local version = "1.2.0"
-- ======================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/polleserhub",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "dsc.gg/polleserhub",
        Text = "Your exploit does not support setfpscap.",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("Your exploit does not support setfpscap.")
end

-- Services
local RunService = game:GetService("RunService")
local Workspace = game.Workspace
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- WindUI (pinned to stable version 1.6.64-fix — avoid breaking changes from "latest")
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.64-fix/main.lua"))()
loadstring(game:HttpGet("https://pastefy.app/Wd15jL6J/raw", true))()
-- ====================== WINDOW ======================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b",
})

WindUI:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db",
})

WindUI:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd",
})

WindUI:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7",
})

WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})

WindUI:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd",
})

WindUI:SetNotificationLower(true)

local themes = {"Light", "Gray", "Blue", "Green", "Dark", "Purple"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "Polleser Hub",
    Icon = "rbxassetid://99240933011775", 
    Author = "Violence District",
    Folder = "PolleserHub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "Theme Changed",
                Content = "Switched to " .. newTheme .. " theme!",
                Duration = 2,
                Icon = "palette"
            })
            print("Switched to " .. newTheme .. " theme")
        end,
    },
})

Window:Tag({
    Title = version,
    Color = Color3.fromHex("#8B0000"),
    Radius = 12,
})

Window:SetToggleKey(Enum.KeyCode.V)

pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)
            
            WindUI:Notify({
                Title = "Transparency", 
                Content = "Transparency disabled",
                Duration = 3,
                Icon = "eye"
            })
            print("Transparency = false")
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)
            
            WindUI:Notify({
                Title = "Transparency",
                Content = "Transparency enabled", 
                Duration = 3,
                Icon = "eye-off"
            })
            print(" Transparency = true")
        end
        
        -- Debug: Print current state
        print("Debug - Current Transparency state:", getgenv().TransparencyEnabled)
    end, 990)
end)

Window:EditOpenButton({
    Title = "Polleser Hub",
    Icon = "rbxassetid://99240933011775",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})


-- Tabs
local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local Main1Divider = Window:Divider()
local SurTab = Window:Tab({ Title = "Survivor", Icon = "user-check" })
local killerTab = Window:Tab({ Title = "Killer", Icon = "swords" })
local GriefTab = Window:Tab({ Title = "Griefing", Icon = "skull" })
local Main2Divider = Window:Divider()
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local AimTab = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local SilentTab = Window:Tab({ Title = "Silent Aim", Icon = "ghost" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })

Window:SelectTab(1)

-- ====================== ESP SYSTEM ======================
-- Toggle values
local ESPSURVIVOR  = false
local ESPMURDER    = false
local ESPGENERATOR = false
local ESPGATE      = false
local ESPPALLET    = false
local ESPWINDOW    = false
local ESPPUMKIN    = false
local ESPHOOK      = false

-- Color config
local COLOR_SURVIVOR       = Color3.fromRGB(0,0,255)
local COLOR_MURDERER       = Color3.fromRGB(255,0,0)
local COLOR_GENERATOR      = Color3.fromRGB(255,255,255)
local COLOR_GENERATOR_DONE = Color3.fromRGB(0,255,0)
local COLOR_GATE           = Color3.fromRGB(255,255,255)
local COLOR_PALLET         = Color3.fromRGB(255,255,0)
local COLOR_PUMKIN         = Color3.fromRGB(255, 165, 0)
local COLOR_OUTLINE        = Color3.fromRGB(0,0,0)
local COLOR_WINDOW         = Color3.fromRGB(255,165,0)
local COLOR_HOOK           = Color3.fromRGB(255,0,0)

-- State flags
local espEnabled = false
local espSurvivor = false
local espMurder = false
local espGenerator = false
local espGate = false
local espHook = false
local espPallet = false
local espWindowEnabled = false
local espPumkin = false

-- Label toggles
local ShowName = true
local ShowDistance = true
local ShowHP = true
local ShowHighlight = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local espObjects = {}

-- ============================================================
-- CONFIG TABLE
-- ============================================================
local Config = {
    ESP = {
        ShowDistance        = true,
        MaxDistance         = 500,
        ShowOnlyClosestHook = false,
    },
    AutoFeatures = {
        AutoAttack  = false,
        AttackRange = 10,
    },
    Teleportation = {
        SafeTeleport   = true,
        TeleportOffset = 3,
    },
    Performance = {
        UpdateRate           = 0.5,
        UseDistanceCulling   = true,
        MaxESPObjects        = 100,
        DisableParticles     = false,
        LowerGraphics        = false,
        DisableShadows       = false,
        ReduceRenderDistance = false,
    },
}

-- ============================================================
-- CONFIG TABLE v1.2 — central settings, dipakai semua fitur
-- ============================================================
local Config = {
    ESP = {
        ShowDistance        = true,
        MaxDistance         = 500,        -- studs; objek lebih jauh = hide
        ShowOnlyClosestHook = false,      -- tampilkan 1 hook terdekat saja
    },
    Aimbot = {
        Enabled   = false,
        TeamCheck = true,                 -- skip teammate
        Bone      = "body",               -- "head" | "body"
        FOV       = 120,                  -- radius pixel dari tengah layar
        Range     = 150,                  -- studs max
    },
    SilentAim = {
        Enabled   = false,
        Bone      = "body",               -- "head" | "body"
        FOV       = 200,                  -- radius pixel dari tengah layar
        Range     = 80,                   -- studs max
        TeamCheck = true,                 -- skip teammate
    },
    AutoFeatures = {
        AutoAttack  = false,
        AttackRange = 10,
    },
    Teleportation = {
        SafeTeleport   = true,
        TeleportOffset = 3,
    },
    Performance = {
        UpdateRate           = 0.5,
        UseDistanceCulling   = true,
        MaxESPObjects        = 100,
        DisableParticles     = false,
        LowerGraphics        = false,
        DisableShadows       = false,
        ReduceRenderDistance = false,
    },
}

-- ─── AIMBOT STATE (terpisah agar toggle UI mudah) ─────────────
local aimConn = nil
local godConn = nil
local moonwalkConn = nil
local fpsGuiFrame = nil

-- Remove ESP from object
local function removeESP(obj)
    if espObjects[obj] then
        local data = espObjects[obj]
        if data.highlight then data.highlight:Destroy() end
        if data.nameLabel and data.nameLabel.Parent then
            data.nameLabel.Parent.Parent:Destroy()
        end
        espObjects[obj] = nil
    end
end

-- Create ESP
local function createESP(obj, baseColor)
    if not obj or obj.Name == "Lobby" then return end
    if espObjects[obj] then
        local data = espObjects[obj]
        if data.highlight then
            data.highlight.FillColor = baseColor
            data.highlight.OutlineColor = baseColor
            data.highlight.Enabled = ShowHighlight
        end
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = baseColor
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = baseColor
    highlight.OutlineTransparency = 0.1
    highlight.Enabled = ShowHighlight
    highlight.Parent = obj

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.Adornee = obj
    bill.AlwaysOnTop = true
    bill.Parent = obj

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.33,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = baseColor
    nameLabel.TextStrokeColor3 = COLOR_OUTLINE
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = obj.Name
    nameLabel.Visible = ShowName
    nameLabel.Parent = frame

    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1,0,0.33,0)
    hpLabel.Position = UDim2.new(0,0,0.33,0)
    hpLabel.BackgroundTransparency = 1
    hpLabel.Font = Enum.Font.SourceSansBold
    hpLabel.TextSize = 14
    hpLabel.TextColor3 = baseColor
    hpLabel.TextStrokeColor3 = COLOR_OUTLINE
    hpLabel.TextStrokeTransparency = 0
    hpLabel.Text = ""
    hpLabel.Parent = frame

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1,0,0.33,0)
    distLabel.Position = UDim2.new(0,0,0.66,0)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.TextSize = 14
    distLabel.TextColor3 = baseColor
    distLabel.TextStrokeColor3 = COLOR_OUTLINE
    distLabel.TextStrokeTransparency = 0
    distLabel.Text = ""
    distLabel.Parent = frame

    espObjects[obj] = {
        highlight = highlight,
        nameLabel = nameLabel,
        hpLabel = hpLabel,
        distLabel = distLabel,
        color = baseColor
    }
end

-- Get map folders
local function getMapFolders()
    local folders = {}
    local mainMap = workspace:FindFirstChild("Map")
    if mainMap then
        table.insert(folders, mainMap)
        if mainMap:FindFirstChild("Rooftop") then
            table.insert(folders, mainMap.Rooftop)
        end
    end
    return folders
end

-- Update Window ESP
local function updateWindowESP()
    if not espEnabled then return end
    for _, folder in pairs(getMapFolders()) do
        for _, windowModel in pairs(folder:GetChildren()) do
            if windowModel:IsA("Model") and windowModel.Name == "Window" then
                if espWindowEnabled then
                    createESP(windowModel, COLOR_WINDOW)
                else
                    removeESP(windowModel)
                end
            end
        end
    end
end

local function getPumkinFolders()
    local folders = {}
    -- ค้นหา Map และ Rooftop
    local mainMap = workspace:FindFirstChild("Map")
    local rooftop = workspace:FindFirstChild("Rooftop")

    -- ถ้ามี Map และในนั้นมีโฟลเดอร์ชื่อ Pumkin
    if mainMap and mainMap:FindFirstChild("Pumpkins") then
        table.insert(folders, mainMap.Pumpkins)
    end

    -- ถ้ามี Rooftop และในนั้นมีโฟลเดอร์ชื่อ Pumkin
    if rooftop and rooftop:FindFirstChild("Pumpkins") then
        table.insert(folders, rooftop.Pumpkins)
    end

    return folders
end

local function updatePumkinESP()
    if not espEnabled then return end
    for _, folder in pairs(getPumkinFolders()) do
        for _, pumkin in pairs(folder:GetChildren()) do
            -- ตรวจชื่อ Pumkin1, Pumkin2, Pumkin3, ...
            if pumkin:IsA("Model") and pumkin.Name:match("^Pumpkin%d+$") then
                if espPumkin then
                    createESP(pumkin, COLOR_PUMKIN)
                else
                    removeESP(pumkin)
                end
            end
        end
    end
end

-- Main update function
local lastUpdate = 0
local updateInterval = 0.5  -- akan disync ke Config.Performance.UpdateRate

-- ============================================================
-- SAFE TELEPORT
-- ============================================================
local function safeTeleport(targetCFrame, offset)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    offset = offset or Vector3.new(0, Config.Teleportation.TeleportOffset, 0)

    if Config.Teleportation.SafeTeleport then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    hrp.CFrame = targetCFrame + offset

    if Config.Teleportation.SafeTeleport then
        task.delay(0.5, function()
            if not char or not char.Parent then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end)
    end
    return true
end

-- ============================================================
-- PERFORMANCE SETTINGS
-- ============================================================
local function applyPerformanceSettings()
    local lighting  = game:GetService("Lighting")

    if Config.Performance.DisableParticles then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
        end
    end

    if Config.Performance.LowerGraphics then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    end

    if Config.Performance.DisableShadows then
        lighting.GlobalShadows = false
    end

    if Config.Performance.ReduceRenderDistance then
        pcall(function()
            Workspace.StreamingEnabled       = true
            Workspace.StreamingMinRadius     = 32
            Workspace.StreamingTargetRadius  = 64
        end)
    end
end

local function resetPerformanceSettings()
    local lighting = game:GetService("Lighting")
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = true
        end
    end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)
    lighting.GlobalShadows = true
end

-- ============================================================
-- TELEPORT TO PLAYER (Safe)
-- ============================================================
local function safeTeleportToPlayer(target)
    if not (target and target.Character) then return end
    local c   = LocalPlayer.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not (hrp and tHRP) then return end

    if Config.Teleportation.SafeTeleport then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, Config.Teleportation.TeleportOffset)

    if Config.Teleportation.SafeTeleport then
        task.delay(0.5, function()
            if not (c and c.Parent) then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.CanCollide = true
                end
            end
        end)
    end
end

-- ============================================================
-- FPS COUNTER  (compact, warna sinkron GUI, + Lock button)
-- ============================================================
local function setFPSCounter(on)
    if fpsGuiFrame and fpsGuiFrame.Parent then
        fpsGuiFrame.Parent.Parent:Destroy(); fpsGuiFrame = nil
    end
    if not on then return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "VD_FPS_Counter"; sg.ResetOnSpawn = false; sg.DisplayOrder = 999
    sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

    -- Outer wrapper untuk drag
    local wrapper = Instance.new("Frame", sg)
    wrapper.Size = UDim2.new(0, 148, 0, 28)
    wrapper.Position = UDim2.new(0, 10, 0, 10)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0

    -- Pill frame
    local frame = Instance.new("Frame", wrapper)
    frame.Size = UDim2.new(1, -30, 1, 0)   -- sisakan 28px untuk lock
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", frame)
    st.Color = Color3.fromRGB(168, 85, 247); st.Thickness = 1; st.Transparency = 0.35

    -- Label: "VD | 60fps | 34ms" (teks kecil rapi)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -8, 1, 0); lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.Text = "VD | --fps | --ms"
    lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Lock button (kanan)
    local lockBtn = Instance.new("TextButton", wrapper)
    lockBtn.Size = UDim2.new(0, 26, 0, 26)
    lockBtn.Position = UDim2.new(1, -26, 0.5, -13)
    lockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    lockBtn.Text = "🔓"; lockBtn.TextSize = 13
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    lockBtn.BorderSizePixel = 0
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
    local lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = Color3.fromRGB(80,80,80); lockStroke.Thickness = 1

    -- Drag logic (hanya aktif saat unlock)
    local locked = false
    local drag, ds, sp = false, nil, nil

    local function setLock(v)
        locked = v
        if locked then
            lockBtn.Text = "🔒"
            lockStroke.Color = Color3.fromRGB(168, 85, 247)
        else
            lockBtn.Text = "🔓"
            lockStroke.Color = Color3.fromRGB(80, 80, 80)
        end
    end

    lockBtn.MouseButton1Click:Connect(function() setLock(not locked) end)

    wrapper.InputBegan:Connect(function(i)
        if locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; sp = wrapper.Position
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            wrapper.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)

    fpsGuiFrame = wrapper
    local frames, lastT, pingMs, pingT = 0, tick(), 0, tick()
    game:GetService("RunService").RenderStepped:Connect(function()
        if not (fpsGuiFrame and fpsGuiFrame.Parent) then return end
        frames = frames + 1
        if tick() - pingT >= 2 then
            pcall(function() pingMs = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
            pingT = tick()
        end
        if tick() - lastT >= 1 then
            lbl.Text = string.format("VD | %dfps | %dms", frames, pingMs)
            frames = 0; lastT = tick()
        end
    end)
end

-- ============================================================
-- MOONWALK  (v18 fix — AutoRotate=false + RenderStepped override)
-- RenderStepped jalan SETELAH physics, jadi tidak bisa ditimpa
-- analog/movement controller lagi. AutoRotate=false mencegah
-- Roblox reset rotasi saat analog digerakkan.
-- ============================================================
local function startMoonwalk()
    if moonwalkConn then moonwalkConn:Disconnect(); moonwalkConn = nil end
    -- Matikan AutoRotate supaya analog tidak reset arah badan
    local c0 = LocalPlayer.Character
    if c0 then
        local hum0 = c0:FindFirstChildOfClass("Humanoid")
        if hum0 then hum0.AutoRotate = false end
    end
    -- RenderStepped = setelah physics → override tidak bisa dilawan analog
    moonwalkConn = game:GetService("RunService").RenderStepped:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        -- Pastikan AutoRotate tetap off tiap frame (game bisa reset-nya)
        if hum and hum.AutoRotate then hum.AutoRotate = false end
        local camLook = workspace.CurrentCamera.CFrame.LookVector
        local flat = Vector3.new(camLook.X, 0, camLook.Z)
        if flat.Magnitude > 0.001 then
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flat.Unit)
        end
    end)
end

local function stopMoonwalk()
    if moonwalkConn then moonwalkConn:Disconnect(); moonwalkConn = nil end
    local c = LocalPlayer.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

-- ============================================================
-- GOD MODE  (dari VD v17 — keep HP max setiap Heartbeat)
-- ============================================================
local function startGodMode()
    if godConn then godConn:Disconnect() end
    godConn = game:GetService("RunService").Heartbeat:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
end
local function stopGodMode()
    if godConn then godConn:Disconnect(); godConn = nil end
end

-- ============================================================
-- AIMBOT  (FOV circle fix + Silent Aim)
-- ============================================================
local fovCircle = nil
local fovUpdateConn = nil

local function drawFOVCircle(radius)
    -- Hentikan loop lama & hapus circle lama
    if fovUpdateConn then fovUpdateConn:Disconnect(); fovUpdateConn = nil end
    pcall(function() if fovCircle then fovCircle:Remove(); fovCircle = nil end end)
    if not radius or radius <= 0 then return end

    -- Langsung coba buat circle; kalau Drawing tidak support → warn saja
    local ok = pcall(function()
        fovCircle           = Drawing.new("Circle")
        fovCircle.Radius    = radius
        fovCircle.Color     = Color3.fromRGB(168, 85, 247)
        fovCircle.Thickness = 2
        fovCircle.Filled    = false
        fovCircle.NumSides  = 64
        -- Set posisi LANGSUNG supaya langsung kelihatan
        local vp = workspace.CurrentCamera.ViewportSize
        fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        fovCircle.Visible  = true
    end)
    if not ok then
        warn("[VD] Drawing.new gagal — executor mungkin tidak support Drawing API")
        fovCircle = nil
        return
    end
    -- Update posisi tiap frame supaya tetap di tengah saat rotate
    fovUpdateConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not fovCircle then return end
        pcall(function()
            local vp = workspace.CurrentCamera.ViewportSize
            fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        end)
    end)
end

-- ─── SILENT AIM ──────────────────────────────────────────────
-- Intercept FireServer → ganti arah tembak ke target terdekat
-- Cara kerja: hookmetamethod tangkap semua :FireServer call,
-- kalau nama remote mengandung kata serangan → swap argumen arah
local silentAimHook   = nil
local silentAimActive = false
local SILENT_AIM_RANGE = 80  -- studs

local function getNearestEnemy()
    local myChar = LocalPlayer.Character; if not myChar then return nil end
    local myHRP  = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return nil end
    local cam    = workspace.CurrentCamera
    local vp     = cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local range  = Config.SilentAim.Range or SILENT_AIM_RANGE
    local fovR   = Config.SilentAim.FOV or 200
    local best, bestD = nil, fovR

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            -- team check
            if Config.SilentAim.TeamCheck then
                local myTeam = LocalPlayer.Team
                if pl.Team and myTeam and pl.Team == myTeam then continue end
            end
            local bone
            if Config.SilentAim.Bone == "head" then
                bone = pl.Character:FindFirstChild("Head")
            end
            bone = bone or pl.Character:FindFirstChild("UpperTorso")
                       or pl.Character:FindFirstChild("Torso")
                       or pl.Character:FindFirstChild("HumanoidRootPart")
            if bone then
                local studs = (bone.Position - myHRP.Position).Magnitude
                if studs <= range then
                    local pos, onScreen = cam:WorldToViewportPoint(bone.Position)
                    if onScreen then
                        local screenDist = math.sqrt((pos.X-cx)^2 + (pos.Y-cy)^2)
                        if screenDist < bestD then bestD = screenDist; best = bone end
                    end
                end
            end
        end
    end
    return best, bestD
end

-- Daftar kata di nama remote yang mau di-intercept
local ATTACK_KEYWORDS = {"attack", "Attack", "BasicAttack", "Spearthrow", "spear", "Throw", "shoot", "Shoot"}

local function startSilentAim()
    if not rawget(_G, "hookmetamethod") then
        warn("[VD] hookmetamethod tidak tersedia — silent aim tidak bisa jalan")
        return
    end
    silentAimActive = true
    silentAimHook = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and silentAimActive then
            -- Cek apakah remote ini adalah remote serangan
            local name = pcall(function() return self.Name end) and self.Name or ""
            local isAttack = false
            for _, kw in ipairs(ATTACK_KEYWORDS) do
                if name:find(kw) then isAttack = true; break end
            end
            if isAttack then
                local tHRP, dist = getNearestEnemy()
                if tHRP then
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        local dir = (tHRP.Position - myHRP.Position).Unit
                        -- Swap argumen: replace Vector3/direction args dengan arah ke target
                        local args = {...}
                        for i, v in ipairs(args) do
                            if typeof(v) == "Vector3" then
                                -- Ganti vector pertama yang ketemu (biasanya arah tembak)
                                args[i] = Vector3.new(dir.X, dir.Y, dir.Z)
                                break
                            end
                        end
                        return self[method](self, table.unpack(args))
                    end
                end
            end
        end
        return self[method](self, ...)
    end)
end

local function stopSilentAim()
    silentAimActive = false
    -- Hook tetap terpasang tapi silentAimActive = false jadi bypass dimatikan
end

local function getAimPart(char)
    if Config.Aimbot.Bone == "head" then
        return char:FindFirstChild("Head")
    end
    return char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function isTeammate(pl)
    if not Config.Aimbot.TeamCheck then return false end
    local myTeam = LocalPlayer.Team
    return pl.Team and myTeam and pl.Team == myTeam
end

local function startAimbot()
    if aimConn then aimConn:Disconnect() end
    aimConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not Config.Aimbot.Enabled then return end
        local cam  = workspace.CurrentCamera
        local vp   = cam.ViewportSize
        local cx, cy = vp.X / 2, vp.Y / 2
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        local best, bestDist = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character and not isTeammate(pl) then
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local studs = (hrp.Position - myHRP.Position).Magnitude
                    if studs <= Config.Aimbot.Range then
                        local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local screenDist = math.sqrt((pos.X-cx)^2 + (pos.Y-cy)^2)
                            if screenDist < Config.Aimbot.FOV and screenDist < bestDist then
                                bestDist = screenDist
                                best = pl
                            end
                        end
                    end
                end
            end
        end

        if best and best.Character then
            local part = getAimPart(best.Character)
            if part then
                cam.CFrame = CFrame.new(cam.CFrame.Position, part.Position)
            end
        end
    end)
    drawFOVCircle(Config.Aimbot.FOV)
end

local function stopAimbot()
    if aimConn then aimConn:Disconnect(); aimConn = nil end
    if fovUpdateConn then fovUpdateConn:Disconnect(); fovUpdateConn = nil end
    pcall(function()
        if fovCircle then fovCircle:Remove(); fovCircle = nil end
    end)
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then cam.CameraSubject = hum end
end

local function updateESP(dt)
    if not espEnabled then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Player loop
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= LocalPlayer.Character and player.Character.Name ~= "Lobby" then
            local isMurderer = player.Character:FindFirstChild("Weapon") ~= nil
            local currentESP = espObjects[player.Character]

            if isMurderer then
                if espMurder then
                    if currentESP and currentESP.color ~= COLOR_MURDERER then removeESP(player.Character) end
                    createESP(player.Character, COLOR_MURDERER)
                else
                    removeESP(player.Character)
                end
            else
                if espSurvivor then
                    if currentESP and currentESP.color ~= COLOR_SURVIVOR then removeESP(player.Character) end
                    createESP(player.Character, COLOR_SURVIVOR)
                else
                    removeESP(player.Character)
                end
            end
        end
    end

    -- Object loop
    for _, folder in pairs(getMapFolders()) do
        for _, obj in pairs(folder:GetChildren()) do
            if obj.Name == "Generator" then
                if espGenerator then
                    local hitbox = obj:FindFirstChild("HitBox")
                    local pointLight = hitbox and hitbox:FindFirstChildOfClass("PointLight")
                    local color = COLOR_GENERATOR
                    if pointLight and pointLight.Color == Color3.fromRGB(126,255,126) then
                        color = COLOR_GENERATOR_DONE
                    end
                    createESP(obj, color)
                else
                    removeESP(obj)
                end

            elseif obj.Name == "Gate" then
                if espGate then
                    createESP(obj, COLOR_GATE)
                else
                    removeESP(obj)
                end

            elseif obj.Name == "Hook" then
                if espHook then
                    if Config.ESP.ShowOnlyClosestHook then
                        -- ShowOnlyClosestHook: hitung dulu, apply di luar loop
                        -- (handled di bawah setelah loop selesai)
                    else
                        local mdl = obj:FindFirstChild("Model")
                        if mdl then createESP(mdl, COLOR_HOOK) end
                    end
                else
                    local mdl = obj:FindFirstChild("Model")
                    if mdl then removeESP(mdl) end
                end

            elseif obj.Name == "Palletwrong" then
                if espPallet then
                    createESP(obj, COLOR_PALLET)
                else
                    removeESP(obj)
                end

            else
                if espObjects[obj] then
                    removeESP(obj)
                end
            end
        end
    end

    -- Show Only Closest Hook logic
    if espHook and Config.ESP.ShowOnlyClosestHook then
        local closestHook, closestDist = nil, math.huge
        for _, folder in pairs(getMapFolders()) do
            for _, obj in pairs(folder:GetChildren()) do
                if obj.Name == "Hook" then
                    local hookPart = obj:FindFirstChildWhichIsA("BasePart")
                    if hookPart then
                        local d = (hookPart.Position - hrp.Position).Magnitude
                        if d < closestDist then
                            closestDist = d
                            closestHook = obj
                        end
                    end
                end
            end
        end
        -- hapus semua hook esp dulu
        for _, folder in pairs(getMapFolders()) do
            for _, obj in pairs(folder:GetChildren()) do
                if obj.Name == "Hook" then
                    local mdl = obj:FindFirstChild("Model")
                    if mdl then removeESP(mdl) end
                end
            end
        end
        -- pasang hanya yang terdekat
        if closestHook then
            local mdl = closestHook:FindFirstChild("Model")
            if mdl then createESP(mdl, Color3.fromRGB(255, 255, 0)) end
        end
    end

    updateWindowESP()

    -- Update labels
    for obj, data in pairs(espObjects) do
        if obj and obj.Parent and obj.Name ~= "Lobby" then
            local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                local isPlayer = humanoid ~= nil

                -- Name label
                data.nameLabel.Position = UDim2.new(0,0,0,0)
                data.nameLabel.Visible = ShowName

                if isPlayer then
                    -- Player case

                    -- HP label
                    if ShowHP and humanoid then
                        data.hpLabel.Text = "[ "..math.floor(humanoid.Health).." HP ]"
                        data.hpLabel.Visible = true
                    else
                        data.hpLabel.Text = ""
                        data.hpLabel.Visible = false
                    end

                    -- Distance label
                    if ShowDistance and Config.ESP.ShowDistance then
                        local dist = math.floor((hrp.Position - targetPart.Position).Magnitude)
                        -- Distance culling
                        if Config.Performance.UseDistanceCulling and dist > Config.ESP.MaxDistance then
                            if data.highlight then data.highlight.Enabled = false end
                            data.nameLabel.Visible = false
                            data.hpLabel.Visible   = false
                            data.distLabel.Visible = false
                        else
                            if data.highlight then data.highlight.Enabled = ShowHighlight end
                            data.distLabel.Text    = "[ "..dist.." MM ]"
                            data.distLabel.Visible = true
                        end
                    else
                        data.distLabel.Text    = ""
                        data.distLabel.Visible = false
                    end

                    -- Adjust positions based on visibility
                    if data.hpLabel.Visible then
                        data.hpLabel.Position = UDim2.new(0,0,0.33,0)
                        data.distLabel.Position = UDim2.new(0,0,0.66,0)
                    else
                        data.distLabel.Position = UDim2.new(0,0,0.33,0)
                    end

                else
                    -- Object case (no HP)

                    data.hpLabel.Text = ""
                    data.hpLabel.Visible = false

                    if ShowDistance then
                        local dist = math.floor((hrp.Position - targetPart.Position).Magnitude)
                        data.distLabel.Text = "[ "..dist.." MM ]"
                        data.distLabel.Visible = true
                        data.distLabel.Position = UDim2.new(0,0,0.33,0)
                    else
                        data.distLabel.Text = ""
                        data.distLabel.Visible = false
                    end
                end

                -- Highlight
                if data.highlight then
                    data.highlight.Enabled = ShowHighlight
                end
            end
        else
            removeESP(obj)
        end
    end
end

-- Run every frame
RunService.RenderStepped:Connect(function(dt)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= Config.Performance.UpdateRate then
        lastUpdate = 0
        updateESP(dt)
    end
end)

-- Clean up on player leave
Players.PlayerRemoving:Connect(function(player)
    if player.Character then removeESP(player.Character) end
end)

-- GUI toggle callbacks (example, replace with your actual GUI lib if needed)
EspTab:Section({ Title = "Feature Esp", Icon = "eye" })
EspTab:Toggle({Title="Enable ESP", Value=false, Callback=function(v)
    espEnabled = v
    if not espEnabled then
        for obj,_ in pairs(espObjects) do removeESP(obj) end
    else
        updateESP(0)
        updateWindowESP()
    end
end})

EspTab:Section({ Title = "Esp Role", Icon = "user" })
EspTab:Toggle({Title="ESP Survivor", Value=false, Callback=function(v) espSurvivor=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Survivor",
    Color    = Color3.fromRGB(0, 0, 255),
    Callback = function(v)
        COLOR_SURVIVOR = v
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character and pl ~= LocalPlayer then
                if not pl.Character:FindFirstChild("Weapon") and espObjects[pl.Character] then
                    local d = espObjects[pl.Character]
                    if d.highlight then d.highlight.FillColor=v; d.highlight.OutlineColor=v end
                    if d.nameLabel then d.nameLabel.TextColor3=v end
                    if d.hpLabel then d.hpLabel.TextColor3=v end
                    if d.distLabel then d.distLabel.TextColor3=v end
                end
            end
        end
    end
})
EspTab:Toggle({Title="ESP Killer", Value=false, Callback=function(v) espMurder=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Killer",
    Color    = Color3.fromRGB(255, 0, 0),
    Callback = function(v)
        COLOR_MURDERER = v
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character and pl ~= LocalPlayer then
                if pl.Character:FindFirstChild("Weapon") and espObjects[pl.Character] then
                    local d = espObjects[pl.Character]
                    if d.highlight then d.highlight.FillColor=v; d.highlight.OutlineColor=v end
                    if d.nameLabel then d.nameLabel.TextColor3=v end
                    if d.hpLabel then d.hpLabel.TextColor3=v end
                    if d.distLabel then d.distLabel.TextColor3=v end
                end
            end
        end
    end
})

EspTab:Section({ Title = "Esp Engine", Icon = "biceps-flexed" })
EspTab:Toggle({Title="ESP Generator", Value=false, Callback=function(v) espGenerator=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Generator",
    Color    = Color3.fromRGB(255, 255, 255),
    Callback = function(v) COLOR_GENERATOR = v end
})
EspTab:Toggle({Title="ESP Gate", Value=false, Callback=function(v) espGate=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Gate",
    Color    = Color3.fromRGB(255, 255, 255),
    Callback = function(v) COLOR_GATE = v end
})

EspTab:Section({ Title = "Esp Object", Icon = "package" })
EspTab:Toggle({Title="ESP Pallet", Value=false, Callback=function(v) espPallet=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Pallet",
    Color    = Color3.fromRGB(255, 255, 0),
    Callback = function(v) COLOR_PALLET = v end
})
EspTab:Toggle({Title="ESP Hook", Value=false, Callback=function(v) espHook=v end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Hook",
    Color    = Color3.fromRGB(255, 0, 0),
    Callback = function(v) COLOR_HOOK = v end
})
EspTab:Toggle({Title="ESP Window", Value=false, Callback=function(v)
    espWindowEnabled=v
    updateWindowESP()
end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Window",
    Color    = Color3.fromRGB(255, 165, 0),
    Callback = function(v) COLOR_WINDOW = v end
})

EspTab:Section({ Title = "Esp Event", Icon = "candy" })
EspTab:Toggle({Title="ESP Pumkin", Value=false, Callback=function(v)
    espPumkin=v
    updatePumkinESP()
end})
EspTab:ColorPicker({
    Title    = "🎨 Warna Pumkin",
    Color    = Color3.fromRGB(255, 165, 0),
    Callback = function(v) COLOR_PUMKIN = v end
})

EspTab:Section({ Title = "Esp Settings", Icon = "settings" })
EspTab:Toggle({Title="Show Name", Value=ShowName, Callback=function(v) ShowName=v end})
EspTab:Toggle({Title="Show Distance", Value=ShowDistance, Callback=function(v) ShowDistance=v end})
EspTab:Toggle({Title="Show Health", Value=ShowHP, Callback=function(v) ShowHP=v end})
EspTab:Toggle({Title="Show Highlight", Value=ShowHighlight, Callback=function(v) ShowHighlight=v end})

-- ── ESP SETTINGS (Config-based) ─────────────────────────────────
EspTab:Section({ Title = "Esp Settings (Pro)", Icon = "sliders-horizontal" })

EspTab:Toggle({
    Title = "Show Distance",
    Value = Config.ESP.ShowDistance,
    Callback = function(v)
        Config.ESP.ShowDistance = v
        ShowDistance = v
    end
})

EspTab:Toggle({
    Title = "Use Distance Culling",
    Description = "Sembunyikan ESP di luar MaxDistance",
    Value = Config.Performance.UseDistanceCulling,
    Callback = function(v) Config.Performance.UseDistanceCulling = v end
})

EspTab:Toggle({
    Title = "Show Only Closest Hook",
    Description = "Tampilkan 1 hook terdekat saja (kuning)",
    Value = Config.ESP.ShowOnlyClosestHook,
    Callback = function(v) Config.ESP.ShowOnlyClosestHook = v end
})

EspTab:Slider({
    Title = "Max Distance",
    Description = "Jarak max ESP muncul (studs)",
    Value = { Min=50, Max=1000, Default=500 },
    Step = 50,
    Callback = function(v) Config.ESP.MaxDistance = v end
})

EspTab:Slider({
    Title = "Update Rate (detik x10)",
    Description = "Makin kecil = makin smooth tapi berat",
    Value = { Min=1, Max=20, Default=5 },
    Step = 1,
    Callback = function(v) Config.Performance.UpdateRate = v / 10 end
})

EspTab:Slider({
    Title = "Max ESP Objects",
    Description = "Batas objek yang di-render (hemat FPS)",
    Value = { Min=10, Max=200, Default=100 },
    Step = 10,
    Callback = function(v) Config.Performance.MaxESPObjects = v end
})


-- ====================== BYPASS GATE ======================
local bypassGateEnabled = false

-- ฟังก์ชันรวบรวมเกตทั้งหมด
local function gatherGates()
    local gates = {}
    for _, folder in pairs(getMapFolders()) do
        for _, gate in pairs(folder:GetChildren()) do
            if gate.Name == "Gate" then
                table.insert(gates, gate)
            end
        end
    end
    return gates
end

-- ฟังก์ชันตั้งค่าเกต
local function setGateState(enabled)
    local gates = gatherGates()
    for _, gate in pairs(gates) do
        local leftGate = gate:FindFirstChild("LeftGate")
        local rightGate = gate:FindFirstChild("RightGate")
        local leftEnd = gate:FindFirstChild("LeftGate-end")
        local rightEnd = gate:FindFirstChild("RightGate-end")
        local box = gate:FindFirstChild("Box")

        if enabled then
            -- เปิดฟีเจอร์: Left/Right Gate โปร่งใส + ทะลุได้
            if leftGate then
                leftGate.Transparency = 1
                leftGate.CanCollide = false
            end
            if rightGate then
                rightGate.Transparency = 1
                rightGate.CanCollide = false
            end

            -- Left/Right End ไม่โปร่งใส + ชนได้
            if leftEnd then
                leftEnd.Transparency = 0
                leftEnd.CanCollide = true
            end
            if rightEnd then
                rightEnd.Transparency = 0
                rightEnd.CanCollide = true
            end

            -- Box สามารถทะลุได้
            if box then
                box.CanCollide = false
            end
        else
            -- ปิดฟีเจอร์: คืนค่าเดิม
            if leftGate then
                leftGate.Transparency = 0
                leftGate.CanCollide = true
            end
            if rightGate then
                rightGate.Transparency = 0
                rightGate.CanCollide = true
            end
            if leftEnd then
                leftEnd.Transparency = 1
                leftEnd.CanCollide = true
            end
            if rightEnd then
                rightEnd.Transparency = 1
                rightEnd.CanCollide = true
            end
            if box then
                box.CanCollide = true
            end
        end
    end
end

-- UI Toggle
MainTab:Section({ Title = "Feature Bypass", Icon = "lock-open" })
MainTab:Toggle({
    Title = "Bypass Gate (Fixed)",
    Value = false,
    Callback = function(state)
        bypassGateEnabled = state
        setGateState(state)
    end
})

-- ====================== AUTO GENERATOR ======================
SurTab:Section({ Title = "Feature Survivor", Icon = "user" })

local autoparry = false

SurTab:Toggle({
    Title = "Auto Parry (Under Fixing)",
    Value = false,
    Callback = function(v)
        autoparry = v
        if autoparry then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Parrying Dagger"):WaitForChild("parry")

                while autoparry do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                if plr.Character:FindFirstChild("Weapon") then
                                    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if targetRoot then
                                        local dist = (root.Position - targetRoot.Position).Magnitude
                                        if dist <= 10 then
                                            remote:FireServer()
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.001)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Object", Icon = "zap" })

local autoGeneratorEnabled = false
local autoGeneratorEnablednotperfect = false

SurTab:Toggle({
    Title = "Auto SkillCheck (Perfect)",
    Value = false,
    Callback = function(v)
        autoGeneratorEnabled = v
        if autoGeneratorEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                while autoGeneratorEnabled do
                    -- ✅ ซ่อน GUI SkillCheckPromptGui.Check ถ้ามีขึ้น
                    local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                    if gui and gui:FindFirstChild("Check") then
                        gui.Check.Visible = false
                    end

                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local folders = getMapFolders()
                        local closestGen, closestDist = nil, 10

                        for _, folder in ipairs(folders) do
                            for _, gen in ipairs(folder:GetChildren()) do
                                if gen.Name == "Generator" and gen:IsA("Model") then
                                    local primary = gen:FindFirstChild("PrimaryPart") or gen:FindFirstChildWhichIsA("BasePart")
                                    if primary then
                                        local dist = (root.Position - primary.Position).Magnitude
                                        if dist <= closestDist then
                                            closestDist = dist
                                            closestGen = gen
                                        end
                                    end
                                end
                            end
                        end

                        if closestGen then
                            for i = 1, 4 do
                                local point = closestGen:FindFirstChild("GeneratorPoint" .. i)
                                if point then
                                    local args = {"success", 1, closestGen, point}
                                    remote:FireServer(unpack(args))
                                end
                            end
                        end
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})

SurTab:Toggle({
    Title = "Auto SkillCheck (Not Perfect)",
    Value = false,
    Callback = function(v)
        autoGeneratorEnablednotperfect = v
        if autoGeneratorEnablednotperfect then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
                local player = Players.LocalPlayer
                local playerGui = player:WaitForChild("PlayerGui")

                while autoGeneratorEnablednotperfect do
                    -- ✅ ซ่อน GUI SkillCheckPromptGui.Check ถ้ามีขึ้น
                    local gui = playerGui:FindFirstChild("SkillCheckPromptGui")
                    if gui and gui:FindFirstChild("Check") then
                        gui.Check.Visible = false
                    end

                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local folders = getMapFolders()
                        local closestGen, closestDist = nil, 10

                        for _, folder in ipairs(folders) do
                            for _, gen in ipairs(folder:GetChildren()) do
                                if gen.Name == "Generator" and gen:IsA("Model") then
                                    local primary = gen:FindFirstChild("PrimaryPart") or gen:FindFirstChildWhichIsA("BasePart")
                                    if primary then
                                        local dist = (root.Position - primary.Position).Magnitude
                                        if dist <= closestDist then
                                            closestDist = dist
                                            closestGen = gen
                                        end
                                    end
                                end
                            end
                        end

                        if closestGen then
                            for i = 1, 4 do
                                local point = closestGen:FindFirstChild("GeneratorPoint" .. i)
                                if point then
                                    local args = {"success", 1, closestGen, point}
                                    remote:FireServer(unpack(args))
                                end
                            end
                        end
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})

local autoLeverEnabled = false

SurTab:Toggle({
    Title = "Auto Lever (No Hold)",
    Value = false,
    Callback = function(v)
        autoLeverEnabled = v
        if autoLeverEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Exit"):WaitForChild("LeverEvent")
                local player = Players.LocalPlayer

                while autoLeverEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local folders = getMapFolders()
                        for _, folder in ipairs(folders) do
                            local gate = folder:FindFirstChild("Gate")
                            if gate and gate:FindFirstChild("ExitLever") then
                                local main = gate.ExitLever:FindFirstChild("Main")
                                if main then
                                    local dist = (root.Position - main.Position).Magnitude
                                    if dist <= 10 then
                                        remote:FireServer(main, true)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Heal", Icon = "cross" })

-- Auto Heal
local autoHealEnabled = false
SurTab:Toggle({
    Title = "Auto Heal (Under Fixing)",
    Value = false,
    Callback = function(v)
        autoHealEnabled = v
        if autoHealEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Healing"):WaitForChild("SkillCheckResultEvent")
                local player = Players.LocalPlayer

                while autoHealEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local closestTarget = nil
                        local closestDist = Config.AutoFeatures.AttackRange

                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= player and plr.Character then
                                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    local dist = (root.Position - targetRoot.Position).Magnitude
                                    if dist <= closestDist then
                                        closestDist = dist
                                        closestTarget = plr
                                    end
                                end
                            end
                        end

                        if closestTarget then
                            local args = {
                                "success",
                                1,
                                closestTarget.Character
                            }
                            remote:FireServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

SurTab:Section({ Title = "Feature Cheat", Icon = "bug" })

local NoFallEnabled = false

SurTab:Toggle({
    Title = "No Fall (Beta)",
    Value = false,
    Callback = function(v)
        NoFallEnabled = v

        if NoFallEnabled then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local FallRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Fall")

                while NoFallEnabled do
                    local args = { -100 }
                    pcall(function()
                        FallRemote:FireServer(unpack(args))
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

SurTab:Button({ 
    Title = "Fling Killer (Spam if killer doesn't fling)",  
    Callback = function(state)

        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        local Targets = {}

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                if plr.Character:FindFirstChild("Weapon") then
                    table.insert(Targets, plr.Name)
                end
            end
        end

        local AllBool = false

        local GetPlayer = function(Name)
            Name = Name:lower()
            if Name == "all" or Name == "others" then
                AllBool = true
                return
            elseif Name == "random" then
                local GetPlayers = Players:GetPlayers()
                if table.find(GetPlayers, Player) then
                    table.remove(GetPlayers, table.find(GetPlayers, Player))
                end
                return GetPlayers[math.random(#GetPlayers)]
            else
                for _,x in next, Players:GetPlayers() do
                    if x ~= Player then
                        if x.Name:lower():match("^"..Name) or x.DisplayName:lower():match("^"..Name) then
                            return x
                        end
                    end
                end
            end
        end

        local Message = function(_Title, _Text, Time)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
        end

        local SkidFling = function(TargetPlayer)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart

            local TCharacter = TargetPlayer.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")

            if Character and Humanoid and RootPart then
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end

                if THumanoid and THumanoid.Sit and not AllBool then
                    return Message("Error Occurred", "Targeting is sitting", 5)
                end

                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end

                if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end

                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0

                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle += 100
                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end

                workspace.FallenPartsDestroyHeight = 0/0

                local BV = Instance.new("BodyVelocity")
                BV.Name = "PolleserHub-YES"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e9, 9e9, 9e9)
                BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                if TRootPart and THead then
                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                        SFBasePart(THead)
                    else
                        SFBasePart(TRootPart)
                    end
                elseif TRootPart then
                    SFBasePart(TRootPart)
                elseif THead then
                    SFBasePart(THead)
                elseif Handle then
                    SFBasePart(Handle)
                else
                    return Message("Error Occurred", "Target is missing everything", 5)
                end

                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid

                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                    Humanoid:ChangeState("GettingUp")
                    for _, x in ipairs(Character:GetChildren()) do
                        if x:IsA("BasePart") then
                            x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                        end
                    end
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25

                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            else
                return Message("Error Ocurrido", "El Script A Fallado", 5)
            end
        end

        if not Welcome then Message("PolleserHub | FLING", "THANK FOR USING", 6) end
        getgenv().Welcome = true

        if AllBool then
            for _, x in next, Players:GetPlayers() do
                SkidFling(x)
            end
        end

        for _, x in next, Targets do
            local TPlayer = GetPlayer(x)
            if TPlayer and TPlayer ~= Player then
                if TPlayer.UserId ~= 4340578793 then
                    SkidFling(TPlayer)
                else
                    Message("ERROR FLING OWNER", "", 8)
                end
            elseif not TPlayer and not AllBool then
                Message("ERROR OWNER", "YOU CANT FLING OWNER", 8)
            end
        end
    end
})

SurTab:Button({
    Title = "Invisible (Skid by me)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mabdu21/kjandsaddjadbhahayenajhsjbdwa/refs/heads/main/INV.lua"))()
    end
})

-- ============================================================
-- SURVIVOR REMOTES  — Fast Vault toggle, Stop Emote, Heal
-- ============================================================
SurTab:Section({ Title = "Vault / Window", Icon = "wind" })

-- ─── Vault state & remotes ───────────────────────────────────
local fastVaultEnabled    = false
local instantVaultEnabled = false
local vaultTouchConns     = {}
local vaultMapConn        = nil
local remWindowCache      = nil

local function getWindowRemotes()
    if remWindowCache then return remWindowCache end
    local ok, r = pcall(function()
        local rem = ReplicatedStorage
            :WaitForChild("Remotes", 5)
            :WaitForChild("Window", 5)
        return {
            fastVault     = rem:WaitForChild("fastvault", 5),
            vaultEvent    = rem:WaitForChild("VaultEvent", 5),
            vaultComplete = rem:WaitForChild("VaultCompleteEvent", 5),
        }
    end)
    if ok then remWindowCache = r; return r end
    return nil
end

local function getAllVaultTriggers()
    local found = {}
    local map = workspace:FindFirstChild("Map")
    if not map then return found end
    for _, v in ipairs(map:GetDescendants()) do
        if v.Name == "VaultTrigger" and v:IsA("BasePart") then
            table.insert(found, v)
        end
    end
    return found
end

local function disconnectVaultConns()
    for _, c in ipairs(vaultTouchConns) do pcall(function() c:Disconnect() end) end
    vaultTouchConns = {}
end

local function hookOneVaultTrigger(trigger)
    local conn = trigger.Touched:Connect(function(part)
        if not (fastVaultEnabled or instantVaultEnabled) then return end
        local char = LocalPlayer.Character
        if not char then return end
        -- cek apakah part yang touch adalah bagian karakter kita
        local p = part
        local isOurs = false
        while p do
            if p == char then isOurs = true; break end
            p = p.Parent
        end
        if not isOurs then return end

        local rems = getWindowRemotes()
        if not rems then return end

        if instantVaultEnabled then
            pcall(function()
                rems.vaultEvent:FireServer(trigger, true)
                task.wait(0.03)
                rems.vaultComplete:FireServer(trigger, false)
            end)
        else -- fastVaultEnabled
            pcall(function()
                rems.fastVault:FireServer(LocalPlayer)
            end)
        end
    end)
    table.insert(vaultTouchConns, conn)
end

local function startVaultHook()
    disconnectVaultConns()
    for _, t in ipairs(getAllVaultTriggers()) do
        hookOneVaultTrigger(t)
    end
    -- tangkap VaultTrigger baru saat map loading
    local map = workspace:FindFirstChild("Map")
    if map then
        if vaultMapConn then vaultMapConn:Disconnect() end
        vaultMapConn = map.DescendantAdded:Connect(function(v)
            if v.Name == "VaultTrigger" and v:IsA("BasePart")
                and (fastVaultEnabled or instantVaultEnabled) then
                task.wait(0.1)
                hookOneVaultTrigger(v)
            end
        end)
    end
end

local function stopVaultHook()
    disconnectVaultConns()
    if vaultMapConn then vaultMapConn:Disconnect(); vaultMapConn = nil end
end

SurTab:Toggle({
    Title       = "Fast Vault  (auto saat lewat jendela)",
    Description = "Saat karakter touch VaultTrigger → fastvault otomatis fire",
    Value       = false,
    Callback    = function(v)
        fastVaultEnabled = v
        if v then
            instantVaultEnabled = false
            startVaultHook()
            WindUI:Notify({ Title="Vault", Content="Fast Vault aktif!", Duration=2, Icon="wind" })
        else
            if not instantVaultEnabled then stopVaultHook() end
        end
    end
})

SurTab:Toggle({
    Title       = "Instant Vault  (skip seluruh animasi)",
    Description = "Touch jendela → VaultEvent + VaultComplete langsung dikirim",
    Value       = false,
    Callback    = function(v)
        instantVaultEnabled = v
        if v then
            fastVaultEnabled = false
            startVaultHook()
            WindUI:Notify({ Title="Vault", Content="Instant Vault aktif!", Duration=2, Icon="zap" })
        else
            if not fastVaultEnabled then stopVaultHook() end
        end
    end
})

-- ─── Stop Emote ───────────────────────────────────────────────
SurTab:Section({ Title = "Emote", Icon = "smile" })

SurTab:Button({
    Title    = "Stop Emote",
    Callback = function()
        local ok, err = pcall(function()
            ReplicatedStorage
                :WaitForChild("Remotes", 5)
                :WaitForChild("EmoteHandler", 5)
                :FireServer("StopEmote")
        end)
        WindUI:Notify({
            Title   = "Emote",
            Content = ok and "Emote dihentikan!" or "Gagal: "..tostring(err),
            Duration = 2, Icon = ok and "smile" or "alert-circle"
        })
    end
})

-- ─── Heal ────────────────────────────────────────────────────
SurTab:Section({ Title = "Heal", Icon = "heart" })

local healRemote = nil
local healSkillRemote = nil

local function getHealRemote()
    if healRemote then return healRemote end
    local ok, r = pcall(function()
        return ReplicatedStorage
            :WaitForChild("Remotes", 5)
            :WaitForChild("Healing", 5)
            :WaitForChild("HealEvent", 5)
    end)
    if ok then healRemote = r; return r end
    return nil
end

-- Remote untuk instant heal (sama seperti trick auto-generator)
local function getHealSkillRemote()
    if healSkillRemote then return healSkillRemote end
    local ok, r = pcall(function()
        return ReplicatedStorage
            :WaitForChild("Remotes", 5)
            :WaitForChild("Healing", 5)
            :WaitForChild("SkillCheckResultEvent", 5)
    end)
    if ok then healSkillRemote = r; return r end
    return nil
end

-- Heal diri sendiri INSTAN (spoof: fire SkillCheckResultEvent ke character sendiri)
-- Teknik sama seperti Auto Generator — fire "success" berkali-kali = langsung full
SurTab:Button({
    Title       = "💊 Heal Diri Sendiri (Instant)",
    Description = "Fire SkillCheck success 20x → HP langsung full",
    Callback    = function()
        local ok, err = pcall(function()
            local char = LocalPlayer.Character
            if not char then error("Karakter tidak ada") end
            local rem = getHealSkillRemote()
            if not rem then error("Remote SkillCheck Heal tidak ditemukan") end
            for i = 1, 20 do
                rem:FireServer("success", 1, char)
            end
        end)
        WindUI:Notify({
            Title   = "Heal",
            Content = ok and "✅ Heal diri instan berhasil!" or "❌ Gagal: "..tostring(err),
            Duration = 2, Icon = ok and "heart" or "alert-circle"
        })
    end
})

-- Auto Heal diri sendiri INSTAN
local autoHealSelfEnabled = false
SurTab:Toggle({
    Title       = "Auto Heal Diri (Instant, loop 1s)",
    Value       = false,
    Callback    = function(v)
        autoHealSelfEnabled = v
        if v then
            task.spawn(function()
                while autoHealSelfEnabled do
                    pcall(function()
                        local char = LocalPlayer.Character
                        local rem  = getHealSkillRemote()
                        if char and rem then
                            for i = 1, 20 do
                                rem:FireServer("success", 1, char)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- Heal player lain INSTAN
do
    local healTargetName = ""

    local function buildHealList()
        local list = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then table.insert(list, pl.Name) end
        end
        return #list > 0 and list or {"(Tidak ada player lain)"}
    end

    local healDrop = SurTab:Dropdown({
        Title    = "Pilih Target Heal",
        Values   = buildHealList(),
        Value    = "",
        Callback = function(v) healTargetName = v end
    })

    SurTab:Button({
        Title    = "🔄 Refresh List Player",
        Callback = function()
            pcall(function() healDrop:Refresh(buildHealList(), false) end)
            healTargetName = ""
        end
    })

    SurTab:Button({
        Title       = "💊 Heal Player yang Dipilih (Instant)",
        Description = "Fire SkillCheck success 20x → HP target langsung full",
        Callback    = function()
            if healTargetName == "" or healTargetName:find("Tidak ada") then
                WindUI:Notify({ Title="Heal", Content="Pilih target dulu!", Duration=2, Icon="alert-circle" })
                return
            end
            local ok, err = pcall(function()
                local target = nil
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Name == healTargetName then target = pl; break end
                end
                if not target or not target.Character then error("Target tidak valid") end
                local rem = getHealSkillRemote()
                if not rem then error("Remote tidak ditemukan") end
                for i = 1, 20 do
                    rem:FireServer("success", 1, target.Character)
                end
            end)
            WindUI:Notify({
                Title   = "Heal",
                Content = ok and "✅ Heal Instan → "..healTargetName or "❌ Gagal: "..tostring(err),
                Duration = 2, Icon = ok and "heart" or "alert-circle"
            })
        end
    })
end

-- ====================== KILLER ======================
killerTab:Section({ Title = "Feature Killer", Icon = "swords" })

local killallEnabled = false

killerTab:Toggle({
    Title = "Kill All (Warning: Get Ban)",
    Value = false,
    Callback = function(v)
        killallEnabled = v
        if killallEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")

                -- บันทึกตำแหน่งเริ่มต้นของเรา
                local startCFrame = nil
                local index = 1

                while killallEnabled do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- บันทึกตำแหน่งก่อนเริ่มครั้งแรก
                        if not startCFrame then
                            startCFrame = root.CFrame
                        end

                        -- รวมเป้าหมายทุกคนยกเว้นตัวเอง
                        local targets = {}
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                                if targetRoot and humanoid then
                                    table.insert(targets, {player = plr, root = targetRoot, humanoid = humanoid})
                                end
                            end
                        end

                        -- ถ้ามีเป้าหมาย
                        if #targets > 0 then
                            -- ยิงใส่ทุกคนทีละคน
                            for _, entry in ipairs(targets) do
                                if not killallEnabled then break end
                                local targetRoot = entry.root
                                if targetRoot and targetRoot.Parent then
                                    -- วาร์ปไปใกล้เป้าหมาย
                                    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                                    -- ยิง Remote
                                    pcall(function()
                                        remote:FireServer()
                                    end)
                                    task.wait(0.15)
                                end
                            end

                            -- เช็คว่าผู้เล่นทุกคนเลือด <= 20 หรือไม่
                            local allLowHealth = true
                            for _, entry in ipairs(targets) do
                                if entry.humanoid.Health > 20 then
                                    allLowHealth = false
                                    break
                                end
                            end

                            -- ถ้าทุกคนเลือด <= 20 ให้กลับไปตำแหน่งเดิม
                            if allLowHealth and startCFrame then
                                root.CFrame = startCFrame
                                task.wait(1)
                            else
                                task.wait(0.2)
                            end
                        else
                            task.wait(0.5)
                        end
                    else
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
})

killerTab:Toggle({Title="Anti Parry (Soon)", Value=false, Callback=function(v) noFlashlightEnabled=v end})

killerTab:Section({ Title = "Feature No-Cooldown", Icon = "crown" })

local nocooldownskillEnabled = false

killerTab:Slider({
    Title = "Attack Range (studs)",
    Description = "Radius auto attack dari Config",
    Value = { Min=3, Max=50, Default=10 },
    Step = 1,
    Callback = function(v)
        Config.AutoFeatures.AttackRange = v
    end
})

killerTab:Toggle({
    Title = "Auto Attack (No Animation)",
    Value = false,
    Callback = function(v)
        nocooldownskillEnabled = v
        if nocooldownskillEnabled then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")

                while nocooldownskillEnabled do
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local closestTarget = nil
                        local closestDist = Config.AutoFeatures.AttackRange

                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character then
                                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    local dist = (root.Position - targetRoot.Position).Magnitude
                                    if dist <= closestDist then
                                        closestDist = dist
                                        closestTarget = plr.Character
                                    end
                                end
                            end
                        end

                        if closestTarget then
                            remote:FireServer()
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

killerTab:Section({ Title = "Feature Cheat", Icon = "bug" })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local noFlashlightEnabled = false

-- Toggle ของคุณ (ถ้ามี)
killerTab:Toggle({
    Title = "No Flashlight",
    Value = false,
    Callback = function(state)
        noFlashlightEnabled = state
    end
})

-- ฟังก์ชันสแกนทุก Descendant ที่ชื่อ "Blind"
local function removeBlindGui()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- สแกนทุก Descendant
    for _, descendant in pairs(playerGui:GetDescendants()) do
        if descendant:IsA("GuiObject") and descendant.Name == "Blind" then
            descendant:Destroy()
        end
    end
end

-- วน loop ทุก 0.5 วินาที
task.spawn(function()
    while true do
        task.wait(0.5)
        if noFlashlightEnabled then
            removeBlindGui()
        end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ปุ่มใน Killer Tab สำหรับ Reset กล้อง
killerTab:Button({ 
    Title = "Fix Cam (3rd Person Camera)", 
    Callback = function()
        -- รีเซ็ตกล้อง
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = humanoid

            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 400
            player.CameraMode = Enum.CameraMode.Classic

            -- เผื่อโดน Anchor หัวไว้
            local head = character:FindFirstChild("Head")
            if head then
                head.Anchored = false
            end
        end
    end
})

-- ====================== VISUAL ======================
local Lighting = game:GetService("Lighting")

local fullBrightEnabled = false
local noFogEnabled = false

MainTab:Section({ Title = "Feature Visual", Icon = "lightbulb" })
MainTab:Button({
    Title = "Ultra Fast Vault (Instant TP)",
    Description = "Lompat jendela instan tanpa animasi",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Cari VaultTrigger terdekat (maksimal jarak 15 studs)
            local targetTrigger = nil
            local maxDist = 15
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "VaultTrigger" and v:IsA("BasePart") then
                    local dist = (hrp.Position - v.Position).Magnitude
                    if dist < maxDist then
                        targetTrigger = v
                        maxDist = dist
                    end
                end
            end

            if targetTrigger then
                local remotes = game:GetService("ReplicatedStorage").Remotes.Window
                
                -- 1. Kirim sinyal mulai lompat
                remotes.VaultEvent:FireServer(targetTrigger, true)
                
                -- 2. Kirim sinyal Fast Vault
                remotes.fastvault:FireServer(player)
                
                -- 3. BYPASS ANIMASI (Ini kunci biar instan)
                -- Karakter dipaksa maju 8 studs menembus jendela
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -8) 
                
                -- 4. Kirim sinyal selesai lompat
                remotes.VaultCompleteEvent:FireServer(targetTrigger, false)
            else
                WindUI:Notify({
                    Title = "Vault Error",
                    Desc = "Tidak ada jendela di dekatmu!",
                    Duration = 3
                })
            end
        end
    end
})

-- ── PERFORMANCE SETTINGS ────────────────────────────────────────
MainTab:Section({ Title = "Performance Settings", Icon = "gauge" })

MainTab:Toggle({
    Title    = "FPS Counter  (draggable)",
    Value    = false,
    Callback = function(v) setFPSCounter(v) end
})

MainTab:Toggle({
    Title = "Disable Particles",
    Description = "Matikan efek partikel (FPS naik)",
    Value = false,
    Callback = function(v)
        Config.Performance.DisableParticles = v
        applyPerformanceSettings()
    end
})

MainTab:Toggle({
    Title = "Lower Graphics",
    Description = "Set kualitas grafik ke Level01",
    Value = false,
    Callback = function(v)
        Config.Performance.LowerGraphics = v
        applyPerformanceSettings()
    end
})

MainTab:Toggle({
    Title = "Disable Shadows",
    Description = "Matikan bayangan global",
    Value = false,
    Callback = function(v)
        Config.Performance.DisableShadows = v
        applyPerformanceSettings()
    end
})

MainTab:Toggle({
    Title = "Reduce Render Distance",
    Description = "Aktifkan StreamingEnabled (hemat memori)",
    Value = false,
    Callback = function(v)
        Config.Performance.ReduceRenderDistance = v
        applyPerformanceSettings()
    end
})

-- ── Feature Visual ───────────────────────────────────────────────

-- Full Bright
MainTab:Toggle({
    Title = "Full Bright",
    Value = false,
    Callback = function(v)
        fullBrightEnabled = v
        if v then
            task.spawn(function()
                while fullBrightEnabled do
                    if Lighting.Brightness ~= 2 then
                        Lighting.Brightness = 2
                    end
                    if Lighting.ClockTime ~= 14 then
                        Lighting.ClockTime = 14
                    end
                    if Lighting.Ambient ~= Color3.fromRGB(255,255,255) then
                        Lighting.Ambient = Color3.fromRGB(255,255,255)
                    end
                    task.wait(0.5)
                end
            end)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.Ambient = Color3.fromRGB(128,128,128)
        end
    end
})

-- No Fog
MainTab:Toggle({
    Title = "No Fog",
    Value = false,
    Callback = function(v)
        noFogEnabled = v
        if v then
            task.spawn(function()
                while noFogEnabled do
                    if Lighting:FindFirstChild("Atmosphere") then
                        if Lighting.Atmosphere.Density ~= 0 then
                            Lighting.Atmosphere.Density = 0
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if Lighting:FindFirstChild("Atmosphere") then
                Lighting.Atmosphere.Density = 0.5
            end
        end
    end
})

-- ====================== PLAYER ======================
local speedEnabled, flyNoclipSpeed = false, 3
local speedConnection, noclipConnection

PlayerTab:Section({ Title = "Feature Player", Icon = "rabbit" })
PlayerTab:Slider({ Title = "Set Speed Value", Value={Min=1,Max=50,Default=4}, Step=1, Callback=function(val) flyNoclipSpeed=val end })

PlayerTab:Toggle({ Title = "Enable Speed", Value=false, Callback=function(v)
    speedEnabled=v
    if speedEnabled then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection=RunService.RenderStepped:Connect(function()
            local char=LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.MoveDirection.Magnitude>0 then
                char.HumanoidRootPart.CFrame=char.HumanoidRootPart.CFrame+char.Humanoid.MoveDirection*flyNoclipSpeed*0.016
            end
        end)
    else
        if speedConnection then speedConnection:Disconnect() speedConnection=nil end
    end
end })

PlayerTab:Section({ Title = "Feature Power", Icon = "flame" })

-- Teleport to Player
PlayerTab:Section({ Title = "Teleport to Player", Icon = "map-pin" })
do
    local function refreshPlayerDropdown()
        local options = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then
                local role = (pl.Team and pl.Team.Name) or "?"
                table.insert(options, pl.Name .. " [" .. role .. "]")
            end
        end
        return #options > 0 and options or {"(Tidak ada player lain)"}
    end

    -- Dropdown TIDAK langsung teleport — hanya simpan pilihan.
    -- Teleport hanya terjadi kalau user tekan tombol "Teleport" secara eksplisit.
    -- Ini juga mencegah auto-teleport saat script pertama kali jalan
    -- atau saat Refresh dipanggil (Refresh tidak boleh trigger Callback).
    local selectedPlayerName = ""   -- simpan nama tanpa langsung teleport

    local tpDropdown = PlayerTab:Dropdown({
        Title    = "Pilih Player",
        Values   = refreshPlayerDropdown(),
        Value    = "",   -- kosong = tidak ada pilihan awal → callback init tidak triggered
        Callback = function(selected)
            -- Hanya simpan pilihan, JANGAN teleport di sini
            selectedPlayerName = selected
        end
    })

    PlayerTab:Button({
        Title    = "🚀 Teleport ke Player yang Dipilih",
        Callback = function()
            if selectedPlayerName == "" or selectedPlayerName == "(Tidak ada player lain)" then
                WindUI:Notify({
                    Title    = "Teleport",
                    Content  = "Pilih player dulu dari dropdown!",
                    Duration = 2,
                    Icon     = "alert-circle"
                })
                return
            end
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer and selectedPlayerName:find(pl.Name, 1, true) then
                    safeTeleportToPlayer(pl)
                    WindUI:Notify({
                        Title    = "Teleport",
                        Content  = "Teleport ke " .. pl.Name,
                        Duration = 2,
                        Icon     = "map-pin"
                    })
                    return
                end
            end
        end
    })

    PlayerTab:Button({
        Title    = "🔄 Refresh Player List",
        Callback = function()
            pcall(function()
                -- false = jangan reset value ke item pertama
                -- → Callback dropdown TIDAK terpicu saat refresh
                tpDropdown:Refresh(refreshPlayerDropdown(), false)
                selectedPlayerName = ""  -- reset pilihan supaya user pilih ulang
                WindUI:Notify({
                    Title    = "Refresh",
                    Content  = "Daftar player diperbarui.",
                    Duration = 1.5,
                    Icon     = "refresh-cw"
                })
            end)
        end
    })
end

-- God Mode (v17)
PlayerTab:Section({ Title = "God Mode (v17)", Icon = "shield" })
PlayerTab:Toggle({
    Title    = "God Mode  (HP selalu max)",
    Value    = false,
    Callback = function(v)
        if v then startGodMode() else stopGodMode() end
    end
})

-- Moonwalk (v17)
PlayerTab:Section({ Title = "Moonwalk (v17)", Icon = "footprints" })
PlayerTab:Toggle({
    Title       = "Moonwalk  (badan ikut kamera)",
    Description = "Gerakkan kamera untuk kontrol arah saat moonwalk",
    Value       = false,
    Callback    = function(v)
        if v then startMoonwalk() else stopMoonwalk() end
    end
})

PlayerTab:Toggle({ Title = "No Clip", Value=false, Callback=function(state)
    if state then
        noclipConnection=RunService.Stepped:Connect(function()
            local char=LocalPlayer.Character
            if char then
                for _,part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end
        local char=LocalPlayer.Character
        if char then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=true end
            end
        end
    end
end })

-- ============================================================
-- AIMBOT TAB  (logika dari VD v17, UI disesuaikan WindUI)
-- ============================================================
AimTab:Section({ Title = "Aimbot (v17)", Icon = "crosshair" })

AimTab:Toggle({
    Title       = "Enable Aimbot",
    Description = "Kamera otomatis mengunci ke target terdekat dalam FOV",
    Value       = false,
    Callback    = function(v)
        Config.Aimbot.Enabled = v
        if v then startAimbot() else stopAimbot() end
    end
})

AimTab:Toggle({
    Title       = "Team Check  (skip sesama tim)",
    Description = "Aimbot tidak akan kunci ke teammate sendiri",
    Value       = true,
    Callback    = function(v) Config.Aimbot.TeamCheck = v end
})

AimTab:Section({ Title = "Aim Target", Icon = "user" })

AimTab:Dropdown({
    Title    = "Target Bone",
    Values   = {"Head", "Body"},
    Value    = "Body",
    Callback = function(v)
        Config.Aimbot.Bone = v:lower()
    end
})

AimTab:Section({ Title = "Aim Range & FOV", Icon = "sliders-horizontal" })

AimTab:Slider({
    Title    = "FOV Radius  (pixel dari tengah layar)",
    Value    = { Min = 30, Max = 500, Default = 120 },
    Step     = 10,
    Callback = function(v)
        Config.Aimbot.FOV = v
        if Config.Aimbot.Enabled then drawFOVCircle(v) end
    end
})

AimTab:Slider({
    Title    = "Max Range  (studs)",
    Value    = { Min = 10, Max = 500, Default = 150 },
    Step     = 10,
    Callback = function(v) Config.Aimbot.Range = v end
})

-- ============================================================
-- SILENT AIM TAB  (tab terpisah, bukan bagian dari Aimbot)
-- ============================================================
local silentFovCircle     = nil
local silentFovUpdateConn = nil

local function drawSilentFOVCircle(radius)
    if silentFovUpdateConn then silentFovUpdateConn:Disconnect(); silentFovUpdateConn = nil end
    pcall(function() if silentFovCircle then silentFovCircle:Remove(); silentFovCircle = nil end end)
    if not radius or radius <= 0 then return end
    local ok = pcall(function()
        silentFovCircle           = Drawing.new("Circle")
        silentFovCircle.Radius    = radius
        silentFovCircle.Color     = Color3.fromRGB(255, 80, 80)  -- merah, beda dari aimbot
        silentFovCircle.Thickness = 2
        silentFovCircle.Filled    = false
        silentFovCircle.NumSides  = 64
        local vp = workspace.CurrentCamera.ViewportSize
        silentFovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        silentFovCircle.Visible  = true
    end)
    if not ok then
        warn("[VD] Drawing.new gagal — Silent Aim FOV circle tidak bisa ditampilkan")
        silentFovCircle = nil; return
    end
    silentFovUpdateConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not silentFovCircle then return end
        pcall(function()
            local vp = workspace.CurrentCamera.ViewportSize
            silentFovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        end)
    end)
end

local function removeSilentFOVCircle()
    if silentFovUpdateConn then silentFovUpdateConn:Disconnect(); silentFovUpdateConn = nil end
    pcall(function() if silentFovCircle then silentFovCircle:Remove(); silentFovCircle = nil end end)
end

SilentTab:Section({ Title = "Silent Aim (v18)", Icon = "ghost" })

SilentTab:Toggle({
    Title       = "Enable Silent Aim",
    Description = "Redirect tembakan ke target terdekat — kamera tidak bergerak",
    Value       = false,
    Callback    = function(v)
        Config.SilentAim.Enabled = v
        if v then
            startSilentAim()
            drawSilentFOVCircle(Config.SilentAim.FOV)
            WindUI:Notify({ Title = "Silent Aim", Content = "Silent Aim aktif!", Duration = 2, Icon = "ghost" })
        else
            stopSilentAim()
            removeSilentFOVCircle()
            WindUI:Notify({ Title = "Silent Aim", Content = "Silent Aim dimatikan.", Duration = 2, Icon = "ghost" })
        end
    end
})

SilentTab:Toggle({
    Title       = "Team Check  (skip sesama tim)",
    Description = "Silent Aim tidak redirect ke teammate",
    Value       = true,
    Callback    = function(v) Config.SilentAim.TeamCheck = v end
})

SilentTab:Section({ Title = "Target & Range", Icon = "user" })

SilentTab:Dropdown({
    Title    = "Target Bone",
    Values   = {"Head", "Body"},
    Value    = "Body",
    Callback = function(v) Config.SilentAim.Bone = v:lower() end
})

SilentTab:Slider({
    Title    = "FOV Radius  (pixel dari tengah layar)",
    Value    = { Min = 30, Max = 600, Default = 200 },
    Step     = 10,
    Callback = function(v)
        Config.SilentAim.FOV = v
        if Config.SilentAim.Enabled then drawSilentFOVCircle(v) end
    end
})

SilentTab:Slider({
    Title    = "Max Range  (studs)",
    Value    = { Min = 10, Max = 300, Default = 80 },
    Step     = 5,
    Callback = function(v) Config.SilentAim.Range = v end
})

Info = InfoTab

-- ============================================================
-- QUICK PANEL  — 3 tombol floating TERPISAH, masing-masing
--   punya toggle sendiri di MainTab. Setiap tombol bisa di-drag.
-- ============================================================

-- Helper: buat 1 tombol floating mandiri (draggable, tap = toggle)
local function makeFloatingBtn(name, icon, colOn, colStrokeOn, initPos, tapFn)
    local sg = Instance.new("ScreenGui")
    sg.Name = "VD_FB_" .. name
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 998
    sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

    local COL_OFF        = Color3.fromRGB(20,20,20)
    local COL_STROKE_OFF = Color3.fromRGB(80,80,80)

    local btn = Instance.new("TextButton", sg)
    btn.Size             = UDim2.new(0,48,0,48)
    btn.Position         = initPos
    btn.BackgroundColor3 = COL_OFF
    btn.Text             = icon
    btn.TextSize         = 20
    btn.Font             = Enum.Font.GothamBold
    btn.TextColor3       = Color3.fromRGB(160,160,160)
    btn.BorderSizePixel  = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local stk = Instance.new("UIStroke", btn)
    stk.Color = COL_STROKE_OFF; stk.Thickness = 1.5

    -- Label kecil di bawah tombol
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size            = UDim2.new(0,80,0,16)
    lbl.BackgroundTransparency = 1
    lbl.Font            = Enum.Font.GothamBold
    lbl.TextSize        = 10
    lbl.TextColor3      = Color3.fromRGB(200,200,200)
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.TextStrokeTransparency = 0
    lbl.Text            = name
    lbl.TextXAlignment  = Enum.TextXAlignment.Center

    local on    = false
    local drag  = false
    local ds, sp, moved = nil, nil, false

    local function setState(v)
        on = v
        if on then
            btn.BackgroundColor3 = colOn
            stk.Color            = colStrokeOn
            btn.TextColor3       = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = COL_OFF
            stk.Color            = COL_STROKE_OFF
            btn.TextColor3       = Color3.fromRGB(160,160,160)
        end
    end

    local UIS = game:GetService("UserInputService")

    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; moved = false
            ds = i.Position; sp = btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            if math.abs(d.X)>4 or math.abs(d.Y)>4 then moved = true end
            local nx = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
            btn.Position = nx
            -- Label ngikut
            lbl.Position = UDim2.new(nx.X.Scale, nx.X.Offset-16, nx.Y.Scale, nx.Y.Offset+50)
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
            if not moved then
                on = not on
                setState(on)
                tapFn(on)
            end
        end
    end)

    -- posisi awal label
    lbl.Position = UDim2.new(initPos.X.Scale, initPos.X.Offset-16, initPos.Y.Scale, initPos.Y.Offset+50)

    return sg, setState
end

-- State & refs untuk masing-masing tombol floating
local fbMoonGui, fbMoonSet = nil, nil
local fbAimGui,  fbAimSet  = nil, nil
local fbGodGui,  fbGodSet  = nil, nil

-- Toggle di Main tab — masing-masing tombol floating punya toggle sendiri
MainTab:Section({ Title = "Quick Panel", Icon = "zap" })

MainTab:Toggle({
    Title       = "🌙  Tombol Moonwalk",
    Description = "Tampilkan tombol floating Moonwalk di layar (bisa di-drag)",
    Value       = false,
    Callback    = function(v)
        if v then
            fbMoonGui, fbMoonSet = makeFloatingBtn(
                "Moonwalk", "🌙",
                Color3.fromRGB(40,20,80), Color3.fromRGB(168,85,247),
                UDim2.new(0, 12, 0.38, 0),
                function(on) if on then startMoonwalk() else stopMoonwalk() end end
            )
        else
            if fbMoonGui then fbMoonGui:Destroy(); fbMoonGui = nil end
        end
    end
})

MainTab:Toggle({
    Title       = "🎯  Tombol Aimbot",
    Description = "Tampilkan tombol floating Aimbot di layar (bisa di-drag)",
    Value       = false,
    Callback    = function(v)
        if v then
            fbAimGui, fbAimSet = makeFloatingBtn(
                "Aimbot", "🎯",
                Color3.fromRGB(20,50,20), Color3.fromRGB(80,200,80),
                UDim2.new(0, 12, 0.50, 0),
                function(on)
                    Config.Aimbot.Enabled = on
                    if on then startAimbot() else stopAimbot() end
                end
            )
        else
            if fbAimGui then fbAimGui:Destroy(); fbAimGui = nil end
        end
    end
})

MainTab:Toggle({
    Title       = "🛡  Tombol GodMode",
    Description = "Tampilkan tombol floating GodMode di layar (bisa di-drag)",
    Value       = false,
    Callback    = function(v)
        if v then
            fbGodGui, fbGodSet = makeFloatingBtn(
                "GodMode", "🛡",
                Color3.fromRGB(50,30,10), Color3.fromRGB(232,137,12),
                UDim2.new(0, 12, 0.62, 0),
                function(on) if on then startGodMode() else stopGodMode() end end
            )
        else
            if fbGodGui then fbGodGui:Destroy(); fbGodGui = nil end
        end
    end
})

-- ============================================================
-- CROSSHAIR SYSTEM  — berbagai style, warna & ukuran custom
-- ============================================================
local crosshairDrawings = {}
local crosshairUpdateConn = nil
local crosshairEnabled = false
local crosshairStyle  = "Cross"
local crosshairColor  = Color3.fromRGB(255, 255, 255)
local crosshairSize   = 12
local crosshairThick  = 1.5
local crosshairGap    = 4
local crosshairDot    = false

local function removeCrosshair()
    if crosshairUpdateConn then crosshairUpdateConn:Disconnect(); crosshairUpdateConn = nil end
    for _, d in pairs(crosshairDrawings) do pcall(function() d:Remove() end) end
    crosshairDrawings = {}
end

local function buildCrosshair()
    removeCrosshair()
    if not crosshairEnabled then return end

    local ok = pcall(function() Drawing.new("Line"):Remove() end)
    if not ok then warn("[VD] Drawing API tidak tersedia — crosshair tidak bisa ditampilkan"); return end

    local function line(x1,y1,x2,y2)
        local l = Drawing.new("Line")
        l.Color = crosshairColor; l.Thickness = crosshairThick; l.Visible = true
        l.From = Vector2.new(x1,y1); l.To = Vector2.new(x2,y2)
        table.insert(crosshairDrawings, l); return l
    end
    local function circle(r, filled)
        local c = Drawing.new("Circle")
        c.Color = crosshairColor; c.Thickness = crosshairThick
        c.Radius = r; c.Filled = filled or false
        c.NumSides = 32; c.Visible = true
        table.insert(crosshairDrawings, c); return c
    end
    local function dot()
        local c = Drawing.new("Circle")
        c.Color = crosshairColor; c.Filled = true
        c.Radius = crosshairThick + 1; c.Thickness = 1
        c.NumSides = 16; c.Visible = true
        table.insert(crosshairDrawings, c); return c
    end
    local function square(hw)
        local sq = Drawing.new("Square")
        sq.Color = crosshairColor; sq.Thickness = crosshairThick
        sq.Filled = false; sq.Visible = true
        table.insert(crosshairDrawings, sq); return sq
    end

    -- Build shapes (posisi dummy dulu, update loop yang set posisi)
    local s = crosshairStyle
    if s == "Cross" then
        line(0,0,0,0); line(0,0,0,0)   -- horizontal, vertical
    elseif s == "Cross + Gap" then
        line(0,0,0,0); line(0,0,0,0)   -- kiri, kanan
        line(0,0,0,0); line(0,0,0,0)   -- atas, bawah
    elseif s == "Dot" then
        dot()
    elseif s == "Circle" then
        circle(crosshairSize, false)
    elseif s == "Circle + Dot" then
        circle(crosshairSize, false); dot()
    elseif s == "Circle + Cross" then
        circle(crosshairSize, false)
        line(0,0,0,0); line(0,0,0,0)
    elseif s == "T-Shape" then
        line(0,0,0,0)   -- horizontal
        line(0,0,0,0)   -- bawah saja (T)
    elseif s == "X-Shape" then
        line(0,0,0,0); line(0,0,0,0)  -- diagonal \/
    elseif s == "Square" then
        square(crosshairSize)
    elseif s == "Square + Dot" then
        square(crosshairSize); dot()
    elseif s == "Sniper" then
        -- 4 garis panjang dari pinggir layar ke tengah dengan gap besar
        line(0,0,0,0); line(0,0,0,0); line(0,0,0,0); line(0,0,0,0)
    end

    -- Update posisi tiap frame
    crosshairUpdateConn = game:GetService("RunService").RenderStepped:Connect(function()
        if #crosshairDrawings == 0 then return end
        local vp = workspace.CurrentCamera.ViewportSize
        local cx, cy = vp.X/2, vp.Y/2
        local sz  = crosshairSize
        local gap = crosshairGap

        pcall(function()
            if s == "Cross" then
                crosshairDrawings[1].From = Vector2.new(cx-sz, cy)
                crosshairDrawings[1].To   = Vector2.new(cx+sz, cy)
                crosshairDrawings[2].From = Vector2.new(cx, cy-sz)
                crosshairDrawings[2].To   = Vector2.new(cx, cy+sz)
            elseif s == "Cross + Gap" then
                -- horizontal kiri
                crosshairDrawings[1].From = Vector2.new(cx-sz, cy)
                crosshairDrawings[1].To   = Vector2.new(cx-gap, cy)
                -- horizontal kanan
                crosshairDrawings[2].From = Vector2.new(cx+gap, cy)
                crosshairDrawings[2].To   = Vector2.new(cx+sz, cy)
                -- vertical atas
                crosshairDrawings[3].From = Vector2.new(cx, cy-sz)
                crosshairDrawings[3].To   = Vector2.new(cx, cy-gap)
                -- vertical bawah
                crosshairDrawings[4].From = Vector2.new(cx, cy+gap)
                crosshairDrawings[4].To   = Vector2.new(cx, cy+sz)
            elseif s == "Dot" then
                crosshairDrawings[1].Position = Vector2.new(cx, cy)
            elseif s == "Circle" then
                crosshairDrawings[1].Position = Vector2.new(cx, cy)
                crosshairDrawings[1].Radius   = sz
            elseif s == "Circle + Dot" then
                crosshairDrawings[1].Position = Vector2.new(cx, cy)
                crosshairDrawings[1].Radius   = sz
                crosshairDrawings[2].Position = Vector2.new(cx, cy)
            elseif s == "Circle + Cross" then
                crosshairDrawings[1].Position = Vector2.new(cx, cy)
                crosshairDrawings[1].Radius   = sz
                crosshairDrawings[2].From = Vector2.new(cx-sz, cy)
                crosshairDrawings[2].To   = Vector2.new(cx+sz, cy)
                crosshairDrawings[3].From = Vector2.new(cx, cy-sz)
                crosshairDrawings[3].To   = Vector2.new(cx, cy+sz)
            elseif s == "T-Shape" then
                crosshairDrawings[1].From = Vector2.new(cx-sz, cy)
                crosshairDrawings[1].To   = Vector2.new(cx+sz, cy)
                crosshairDrawings[2].From = Vector2.new(cx, cy)
                crosshairDrawings[2].To   = Vector2.new(cx, cy+sz)
            elseif s == "X-Shape" then
                crosshairDrawings[1].From = Vector2.new(cx-sz, cy-sz)
                crosshairDrawings[1].To   = Vector2.new(cx+sz, cy+sz)
                crosshairDrawings[2].From = Vector2.new(cx+sz, cy-sz)
                crosshairDrawings[2].To   = Vector2.new(cx-sz, cy+sz)
            elseif s == "Square" then
                crosshairDrawings[1].Size     = Vector2.new(sz*2, sz*2)
                crosshairDrawings[1].Position = Vector2.new(cx-sz, cy-sz)
            elseif s == "Square + Dot" then
                crosshairDrawings[1].Size     = Vector2.new(sz*2, sz*2)
                crosshairDrawings[1].Position = Vector2.new(cx-sz, cy-sz)
                crosshairDrawings[2].Position = Vector2.new(cx, cy)
            elseif s == "Sniper" then
                -- atas
                crosshairDrawings[1].From = Vector2.new(cx, 0)
                crosshairDrawings[1].To   = Vector2.new(cx, cy - gap*3)
                -- bawah
                crosshairDrawings[2].From = Vector2.new(cx, cy + gap*3)
                crosshairDrawings[2].To   = Vector2.new(cx, vp.Y)
                -- kiri
                crosshairDrawings[3].From = Vector2.new(0, cy)
                crosshairDrawings[3].To   = Vector2.new(cx - gap*3, cy)
                -- kanan
                crosshairDrawings[4].From = Vector2.new(cx + gap*3, cy)
                crosshairDrawings[4].To   = Vector2.new(vp.X, cy)
            end
        end)
    end)
end

-- ─── UI Crosshair di MainTab ─────────────────────────────────
MainTab:Section({ Title = "Crosshair", Icon = "crosshair" })

MainTab:Toggle({
    Title       = "Enable Crosshair",
    Description = "Tampilkan crosshair kustom di tengah layar",
    Value       = false,
    Callback    = function(v)
        crosshairEnabled = v
        buildCrosshair()
    end
})

MainTab:Dropdown({
    Title    = "Style",
    Values   = {"Cross", "Cross + Gap", "Dot", "Circle", "Circle + Dot", "Circle + Cross", "T-Shape", "X-Shape", "Square", "Square + Dot", "Sniper"},
    Value    = "Cross",
    Callback = function(v)
        crosshairStyle = v
        buildCrosshair()
    end
})

MainTab:Slider({
    Title    = "Ukuran",
    Value    = { Min = 4, Max = 50, Default = 12 },
    Step     = 1,
    Callback = function(v) crosshairSize = v; buildCrosshair() end
})

MainTab:Slider({
    Title    = "Ketebalan",
    Value    = { Min = 1, Max = 6, Default = 2 },
    Step     = 1,
    Callback = function(v) crosshairThick = v; buildCrosshair() end
})

MainTab:Slider({
    Title    = "Gap (jarak dari tengah)",
    Value    = { Min = 0, Max = 20, Default = 4 },
    Step     = 1,
    Callback = function(v) crosshairGap = v; buildCrosshair() end
})

MainTab:ColorPicker({
    Title    = "Warna Crosshair",
    Color    = Color3.fromRGB(255,255,255),
    Callback = function(v) crosshairColor = v; buildCrosshair() end
})

-- ============================================================
-- GRIEFING TAB CONTENT
-- ============================================================
GriefTab:Section({ Title = "Griefing Tools", Icon = "skull" })

GriefTab:Button({
    Title = "💥 Break All Generators",
    Description = "Kirim sinyal rusak ke semua generator di map",
    Callback = function()
        local found = false
        for _, folder in pairs(getMapFolders()) do
            for _, obj in pairs(folder:GetChildren()) do
                if obj.Name == "Generator" and obj:IsA("Model") then
                    found = true
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.Generator.BreakGenEvent:FireServer(obj)
                    end)
                end
            end
        end
        WindUI:Notify({
            Title   = "Griefing",
            Content = found and "✅ Semua Generator Rusak!" or "❌ Generator tidak ditemukan!",
            Duration = 3, Icon = "skull"
        })
    end
})

GriefTab:Button({
    Title = "💥 Destroy All Pallets",
    Description = "Hancurkan semua pallet di map",
    Callback = function()
        local found = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Pallet" or v.Name == "PalletStatic" then
                found = true
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Pallet.Jason["Destroy-Global"]:FireServer(Instance.new("Part"))
                end)
            end
        end
        WindUI:Notify({
            Title   = "Griefing",
            Content = found and "✅ Semua Pallet Hancur!" or "❌ Pallet tidak ditemukan!",
            Duration = 3, Icon = "skull"
        })
    end
})

-- ============================================================
-- END OF SCRIPT
-- ============================================================
Info:Label({
    Title = "Polleser Hub v1.3",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://99240933011775",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/9yAtRgpsua")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})
