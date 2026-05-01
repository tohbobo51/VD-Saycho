-- ======================
local version = "2.0.0"
-- ======================

repeat task.wait() until game:IsLoaded()

-- FPS Unlock
if setfpscap then
    setfpscap(1000000)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Holic",
        Text = "FPS Unlocked!",
        Duration = 2,
        Button1 = "Okay"
    })
    warn("FPS Unlocked!")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Holic",
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

-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
pcall(function() loadstring(game:HttpGet("https://pastefy.app/Wd15jL6J/raw", true))() end)
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
    Title = "Holic",
    Icon = "rbxassetid://99240933011775", 
    Author = "Saycho",
    Folder = "Holic",
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

-- ── Tombol Rejoin (kiri Transparency, priority 988) ──────────
pcall(function()
    Window:CreateTopbarButton("RejoinBtn", "refresh-cw", function()
        WindUI:Notify({ Title = "Server", Content = "Rejoining...", Duration = 2, Icon = "refresh-cw" })
        task.wait(1)
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end, 988)
end)

-- ── Tombol Ganti Server (kiri Rejoin, priority 987) ──────────
pcall(function()
    Window:CreateTopbarButton("GantiServerBtn", "globe", function()
        WindUI:Notify({ Title = "Server", Content = "Mencari server baru...", Duration = 2, Icon = "globe" })
        task.spawn(function()
            local TeleportService = game:GetService("TeleportService")
            local placeId = game.PlaceId
            local ok, servers = pcall(function()
                return TeleportService:GetSortedGameInstances(placeId, {
                    SortOrder = Enum.SortOrder.Descending,
                    MaxRows   = 20,
                })
            end)
            if ok and servers and #servers > 0 then
                local current = game.JobId
                local picked  = nil
                for _, s in ipairs(servers) do
                    if s.JobId ~= current then picked = s; break end
                end
                if picked then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(placeId, picked.JobId, LocalPlayer)
                    end)
                else
                    pcall(function() TeleportService:Teleport(placeId, LocalPlayer) end)
                end
            else
                pcall(function() TeleportService:Teleport(placeId, LocalPlayer) end)
            end
        end)
    end, 987)
end)

Window:EditOpenButton({
    Title = "Holic",
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
local Main2Divider = Window:Divider()
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local EspTab = Window:Tab({ Title = "Esp", Icon = "eye" })
local AimTab = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local SilentTab = Window:Tab({ Title = "Silent Aim", Icon = "ghost" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local FlingTab = Window:Tab({ Title = "Fling", Icon = "zap" })

Window:SelectTab(1)

-- ============================================================
-- CORE HELPERS (GetRole, IsKiller, IsSurvivor, Root, Cache)
-- ============================================================
local function GetRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function IsKiller(pl)
    return pl and pl.Character and (
        pl.Character:FindFirstChild("Weapon") ~= nil or
        pl.Character:FindFirstChild("KillerTool") ~= nil or
        (pl.Team and (pl.Team.Name == "Killer" or pl.Team.Name == "Murderer"))
    )
end
local function IsSurvivor(pl)
    return pl and pl.Character and not IsKiller(pl)
end
local function GetRole()
    return IsKiller(LocalPlayer) and "Killer" or "Survivor"
end

-- VD config table (extends existing Config)
local VD = {
    -- Aimbot
    AIM_Enabled    = false, AIM_UseRMB = true, AIM_FOV = 120,
    AIM_Smooth     = 0.3,   AIM_VisCheck = true, AIM_Predict = true,
    AIM_ShowFOV    = true,  AIM_Crosshair = false,
    SPEAR_Aimbot   = false, SPEAR_Gravity = 50, SPEAR_Speed = 100,
    SPEAR_FOV      = 120,   SPEAR_Radius  = 80,
    -- Auto Parry
    AUTO_Parry         = false, AUTO_ParryRange = 15,
    AUTO_ParrySensitivity = 30, AUTO_ParryDelay = 0.5,
    -- Auto Wiggle
    SURV_AutoWiggle = false,
    -- Survivor survival
    SURV_NoFall    = false, AUTO_TeleAway = false, AUTO_TeleAwayDist = 40,
    BEAT_Survivor  = false,
    -- Killer combat
    AUTO_Attack    = false, AUTO_AttackRange = 12,
    HITBOX_Enabled = false, HITBOX_Size = 15,
    KILLER_DoubleTap      = false, KILLER_InfiniteLunge = false,
    KILLER_AutoHook       = false, KILLER_AntiBlind     = false,
    KILLER_NoPalletStun   = false, KILLER_NoSlowdown    = false,
    KILLER_DestroyPallets = false, KILLER_FullGenBreak  = false,
    BEAT_Killer    = false, _KillerTarget = nil,
    -- Fling
    FLING_Enabled  = false, FLING_Strength = 200,
    -- Radar
    RADAR_Enabled   = false, RADAR_Size = 120, RADAR_Circle = false,
    RADAR_Killer    = true,  RADAR_Survivor = true,
    RADAR_Generator = true,  RADAR_Pallet   = true,
    -- Camera
    CAM_ThirdPerson = false, CAM_ShiftLock = false,
    -- Generator auto-stop
    AUTO_StopOnKiller = false, AUTO_ReturnToGen = false,
    -- Misc
    Destroyed = false,
}

-- NEX_Cache: real-time object cache updated by scan loop
local NEX_Cache = {
    Generators = {}, Hooks = {}, Pallets = {}, Gates = {},
    ClosestHook = nil, ExitPos = nil,
}

-- Safe cache scan (every 3s)
task.spawn(function()
    while not VD.Destroyed do
        local map = workspace:FindFirstChild("Map")
        if map then
            -- Generators
            local gens = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if obj:IsA("BasePart") and
                   (obj.Name:find("Generator") or obj.Name:find("generator")) and
                   not obj.Name:find("Point") then
                    table.insert(gens, { part = obj, model = obj.Parent })
                end
            end
            NEX_Cache.Generators = gens

            -- Hooks
            local hooks = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if (obj.Name == "Hook" or obj.Name == "HookPoint" or
                    obj.Name == "HookHitbox") and obj:IsA("BasePart") then
                    table.insert(hooks, { part = obj, model = obj.Parent })
                end
            end
            NEX_Cache.Hooks = hooks

            -- Pallets
            local pallets = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if (obj.Name == "Pallet" or obj.Name == "PalletStatic") and obj:IsA("BasePart") then
                    table.insert(pallets, { part = obj, model = obj.Parent })
                end
            end
            NEX_Cache.Pallets = pallets

            -- Gates
            local gates = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if (obj.Name == "Gate" or obj.Name == "ExitGate") and obj:IsA("BasePart") then
                    table.insert(gates, { part = obj })
                end
            end
            NEX_Cache.Gates = gates

            -- Closest hook
            local root = GetRoot()
            if root and #hooks > 0 then
                local cl, cd = nil, math.huge
                for _, h in ipairs(hooks) do
                    if h.part then
                        local d = (h.part.Position - root.Position).Magnitude
                        if d < cd then cd = d; cl = h end
                    end
                end
                NEX_Cache.ClosestHook = cl
            end
        end
        task.wait(3)
    end
end)

-- Drawing availability
local DrawingAvailable = pcall(function() local t = Drawing.new("Square"); t:Remove() end)
local function SafeDrawing(type_)
    local ok, d = pcall(function() return Drawing.new(type_) end)
    return ok and d or nil
end

-- Teleport helper
local function NEX_TeleportToPosition(pos)
    local root = GetRoot()
    if root then
        pcall(function() root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end)
    end
end

-- ============================================================
-- FEATURE LOGIC FUNCTIONS
-- ============================================================

-- ── Auto Parry (working — fires Remotes.Items.ParryingDagger.parry) ──
local LastParryTime  = 0
local LastDebugParry = 0
local function NEX_AutoParry()
    if not VD.AUTO_Parry then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - LastParryTime < (VD.AUTO_ParryDelay or 0.5) then return end
    local root = GetRoot(); if not root then return end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsKiller(pl) and pl.Character then
            local kr = pl.Character:FindFirstChild("HumanoidRootPart")
            if kr then
                local dist = (kr.Position - root.Position).Magnitude
                if dist <= (VD.AUTO_ParryRange or 15) then
                    local dir = (kr.Position - root.Position).Unit
                    local dot = root.CFrame.LookVector:Dot(dir)
                    local ang = math.deg(math.acos(math.clamp(dot, -1, 1)))
                    local rp  = RaycastParams.new()
                    rp.FilterType = Enum.RaycastFilterType.Blacklist
                    rp.FilterDescendantsInstances = { LocalPlayer.Character, pl.Character, workspace.CurrentCamera }
                    local ray = workspace:Raycast(root.Position, kr.Position - root.Position, rp)
                    if ang <= (VD.AUTO_ParrySensitivity or 30) and not ray then
                        pcall(function()
                            local rem   = ReplicatedStorage:FindFirstChild("Remotes")
                            local items = rem and rem:FindFirstChild("Items")
                            local dagger = items and (
                                items:FindFirstChild("Parrying Dagger") or
                                items:FindFirstChild("Parry") or
                                items:FindFirstChild("Dagger")
                            )
                            local parry = dagger and (
                                dagger:FindFirstChild("parry") or
                                dagger:FindFirstChildWhichIsA("RemoteEvent")
                            )
                            if parry then
                                root.CFrame = CFrame.lookAt(root.Position,
                                    Vector3.new(kr.Position.X, root.Position.Y, kr.Position.Z))
                                parry:FireServer()
                                LastParryTime = tick()
                            end
                        end)
                        break
                    end
                end
            end
        end
    end
end

-- ── Auto Wiggle ──
local LastWiggleTime = 0
local function NEX_AutoWiggle()
    if not VD.SURV_AutoWiggle or GetRole() ~= "Survivor" then return end
    if tick() - LastWiggleTime < 0.3 then return end
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local c = r and r:FindFirstChild("Carry")
        local s = c and c:FindFirstChild("SelfUnHookEvent")
        if s then s:FireServer(); LastWiggleTime = tick() end
    end)
end

-- ── No Fall Damage ──
local AntiFallSetup = false
local function SetupNoFallDamage()
    if AntiFallSetup then return end; AntiFallSetup = true
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local m = r and r:FindFirstChild("Mechanics")
        local fe = m and m:FindFirstChild("Fall")
        if not (fe and fe:IsA("RemoteEvent")) then return end
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if not checkcaller() and VD.SURV_NoFall and self == fe then
                    if getnamecallmethod() == "FireServer" then return nil end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end
pcall(SetupNoFallDamage)

-- ── Flee Killer (Auto TeleAway) ──
local LastTeleAway = 0
local function NEX_TeleportAway()
    if not VD.AUTO_TeleAway then return end
    if GetRole() == "Killer" then return end
    if tick() - LastTeleAway < 3 then return end
    local root = GetRoot(); if not root then return end
    local killerDist, killerPos = math.huge, nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsKiller(pl) and pl.Character then
            local kr = pl.Character:FindFirstChild("HumanoidRootPart")
            if kr then
                local d = (kr.Position - root.Position).Magnitude
                if d < killerDist then killerDist = d; killerPos = kr.Position end
            end
        end
    end
    if killerDist > (VD.AUTO_TeleAwayDist or 40) then return end
    LastTeleAway = tick()
    local bestSpot, bestDist = nil, 0
    for _, gate in ipairs(NEX_Cache.Gates) do
        if gate.part and killerPos then
            local d = (gate.part.Position - killerPos).Magnitude
            if d > bestDist then bestDist = d; bestSpot = gate.part.Position end
        end
    end
    if not bestSpot then
        for _, gen in ipairs(NEX_Cache.Generators) do
            if gen.part and killerPos then
                local d = (gen.part.Position - killerPos).Magnitude
                if d > bestDist then bestDist = d; bestSpot = gen.part.Position end
            end
        end
    end
    if not bestSpot and killerPos then
        bestSpot = root.Position + (root.Position - killerPos).Unit * 80
    end
    if bestSpot then NEX_TeleportToPosition(bestSpot) end
end

-- ── Beat Survivor (auto escape) ──
local function NEX_BeatGameSurvivor()
    if not VD.BEAT_Survivor or GetRole() ~= "Survivor" then return end
    local root = GetRoot(); if not root then return end
    task.spawn(function()
        local exitPos = nil
        pcall(function()
            local map = workspace:FindFirstChild("Map")
            for _, g in ipairs(NEX_Cache.Gates) do
                if g.part then exitPos = g.part.Position + Vector3.new(0, 5, 0); break end
            end
        end)
        if not exitPos then return end
        for i = 1, 10 do
            if not GetRoot() then break end
            pcall(function()
                local ev = ReplicatedStorage:FindFirstChild("Remotes")
                    :FindFirstChild("Game"):FindFirstChild("PlayerActionEvent")
                if ev and ev:IsA("RemoteEvent") then ev:FireServer("ESCAPED", 200) end
            end)
            if i == 1 then
                pcall(function() root.CFrame = CFrame.new(exitPos) end)
            end
            task.wait(0.2)
        end
        VD.BEAT_Survivor = false
    end)
end

-- ── Auto Attack (Killer) ──
local function NEX_AutoAttack()
    if not VD.AUTO_Attack or GetRole() ~= "Killer" then return end
    local root = GetRoot(); if not root then return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
            local tr  = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.MaxHealth > 0 then
                local pct = hum.Health / hum.MaxHealth
                if pct > 0.25 and (tr.Position - root.Position).Magnitude <= VD.AUTO_AttackRange then
                    pcall(function()
                        local b = ReplicatedStorage:FindFirstChild("Remotes")
                            :FindFirstChild("Attacks"):FindFirstChild("BasicAttack")
                        if b then b:FireServer(false) end
                    end)
                    break
                end
            end
        end
    end
end

-- ── Hitbox Expand ──
local OriginalHitboxSizes = {}
local function NEX_UpdateHitboxes()
    local function restoreAll()
        for pl, sz in pairs(OriginalHitboxSizes) do
            if pl and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r then r.Size = sz; r.Transparency = 1; r.CanCollide = true end
            end
        end
        OriginalHitboxSizes = {}
    end
    if GetRole() ~= "Killer" or not VD.HITBOX_Enabled then restoreAll(); return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
            local root = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum  = pl.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                if not OriginalHitboxSizes[pl] then OriginalHitboxSizes[pl] = root.Size end
                local sz = VD.HITBOX_Size
                root.Size = Vector3.new(sz, sz, sz)
                root.CanCollide = false; root.Transparency = 0.7
            elseif root and OriginalHitboxSizes[pl] then
                root.Size = OriginalHitboxSizes[pl]
                root.Transparency = 1; root.CanCollide = true
                OriginalHitboxSizes[pl] = nil
            end
        end
    end
end

-- ── Double Tap ──
local LastDoubleTapTime = 0
local function NEX_DoubleTap()
    if not VD.KILLER_DoubleTap or GetRole() ~= "Killer" then return end
    if tick() - LastDoubleTapTime < 0.5 then return end
    pcall(function()
        local ba = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Attacks"):FindFirstChild("BasicAttack")
        if ba then
            ba:FireServer(false); task.wait(0.05); ba:FireServer(false)
            LastDoubleTapTime = tick()
        end
    end)
end

-- ── Infinite Lunge ──
local function NEX_InfiniteLunge()
    if not VD.KILLER_InfiniteLunge or GetRole() ~= "Killer" then return end
    local root = GetRoot()
    if root then
        pcall(function()
            root.Velocity = root.CFrame.LookVector * 100 + Vector3.new(0, 10, 0)
        end)
    end
end

-- ── Destroy Pallets ──
local LastPalletDestroy = 0
local function NEX_DestroyAllPallets()
    if not VD.KILLER_DestroyPallets or GetRole() ~= "Killer" then return end
    if tick() - LastPalletDestroy < 1.5 then return end
    LastPalletDestroy = tick()
    pcall(function()
        local j = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Pallet"):FindFirstChild("Jason")
        local dg = j and j:FindFirstChild("Destroy-Global")
        local d  = j and j:FindFirstChild("Destroy")
        if dg then pcall(function() dg:FireServer() end) end
        if d then
            for _, p in ipairs(NEX_Cache.Pallets) do
                if p.model then task.spawn(function() pcall(function() d:FireServer(p.model) end) end) end
            end
        end
    end)
end

-- ── Full Gen Break ──
local LastGenBreak = 0
local function NEX_FullGenBreak()
    if not VD.KILLER_FullGenBreak or GetRole() ~= "Killer" then return end
    if tick() - LastGenBreak < 0.8 then return end
    LastGenBreak = tick()
    pcall(function()
        local be = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Generator"):FindFirstChild("BreakGenEvent")
        if not be then return end
        local map = workspace:FindFirstChild("Map")
        if not map then return end
        for _, obj in ipairs(map:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:find("GeneratorPoint") then
                task.spawn(function() pcall(function() be:FireServer(obj) end) end)
            end
        end
    end)
end

-- ── Auto Hook ──
local IsAutoHooking = false
local function NEX_AutoHook()
    if not VD.KILLER_AutoHook or GetRole() ~= "Killer" then return end
    if IsAutoHooking then return end
    local root = GetRoot(); if not root then return end
    local closestDowned, closestDist = nil, math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
            local tr  = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum then
                local pct = (hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 0
                if pct <= 0.25 and pct > 0 then
                    local isHooked = false
                    for _, h in ipairs(NEX_Cache.Hooks) do
                        if h.part and (h.part.Position - tr.Position).Magnitude < 4.5 then
                            isHooked = true; break
                        end
                    end
                    if not isHooked then
                        local d = (tr.Position - root.Position).Magnitude
                        if d < closestDist then closestDist = d; closestDowned = tr end
                    end
                end
            end
        end
    end
    if closestDowned then
        local closestHook, hd = nil, math.huge
        for _, h in ipairs(NEX_Cache.Hooks) do
            if h.part then
                local d = (h.part.Position - closestDowned.Position).Magnitude
                if d < hd then hd = d; closestHook = h end
            end
        end
        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                pcall(function()
                    root.CFrame = CFrame.new(closestDowned.Position + Vector3.new(0, 3, 0), closestDowned.Position)
                end)
                task.wait(0.3)
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end)
                task.wait(0.8)
                if GetRoot() then
                    pcall(function() root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0)) end)
                    task.wait(0.3)
                    pcall(function()
                        local ev = ReplicatedStorage:FindFirstChild("Remotes")
                            :FindFirstChild("Carry"):FindFirstChild("HookEvent")
                        if ev then
                            local hp = closestHook.model and (
                                closestHook.model:FindFirstChild("HookPoint") or
                                closestHook.model:FindFirstChild("HookHitbox")
                            ) or closestHook.part
                            ev:FireServer(hp)
                        end
                    end)
                end
                task.wait(1); IsAutoHooking = false
            end)
        end
    end
end

-- ── No Pallet Stun (metamethod) ──
local NoPalletStunSetup = false
local function SetupNoPalletStun()
    if NoPalletStunSetup then return end; NoPalletStunSetup = true
    pcall(function()
        local j = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Pallet"):FindFirstChild("Jason")
        local stun     = j and j:FindFirstChild("Stun")
        local stunDrop = j and j:FindFirstChild("StunDrop")
        if not stun then return end
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if VD.KILLER_NoPalletStun and (self == stun or self == stunDrop) then
                    return nil
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end
pcall(SetupNoPalletStun)

-- ── Anti Blind (Flashlight) ──
local AntiBlindSetup = false
local function SetupAntiBlind()
    if AntiBlindSetup then return end; AntiBlindSetup = true
    pcall(function()
        local fl = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Items"):FindFirstChild("Flashlight")
        local gb = fl and fl:FindFirstChild("GotBlinded")
        if not gb then return end
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if not checkcaller() and VD.KILLER_AntiBlind and self == gb then
                    if getnamecallmethod() == "FireServer" and GetRole() == "Killer" then
                        return nil
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end
pcall(SetupAntiBlind)

-- ── No Slowdown ──
local NoSlowdownSetup = false
local function SetupNoSlowdown()
    if NoSlowdownSetup then return end; NoSlowdownSetup = true
    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if not checkcaller() and VD.KILLER_NoSlowdown and GetRole() == "Killer" then
                    local method = getnamecallmethod()
                    if method == "FireServer" then
                        local name = pcall(function() return self.Name end) and self.Name or ""
                        if name:find("Slow") or name:find("slow") then return nil end
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end
pcall(SetupNoSlowdown)

-- ── Beat Killer ──
local function NEX_BeatGameKiller()
    if not VD.BEAT_Killer or GetRole() ~= "Killer" then VD._KillerTarget = nil; return end
    local root = GetRoot(); if not root then return end
    local target = VD._KillerTarget
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local th = target.Character:FindFirstChildOfClass("Humanoid")
        if not (tr and th and th.Health > 0) then VD._KillerTarget = nil; target = nil end
    else
        VD._KillerTarget = nil; target = nil
    end
    if not target then
        local closest, closestDist = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
                local pr = pl.Character:FindFirstChild("HumanoidRootPart")
                local ph = pl.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > 0 then
                    local d = (pr.Position - root.Position).Magnitude
                    if d < closestDist then closestDist = d; closest = pl end
                end
            end
        end
        VD._KillerTarget = closest; target = closest
    end
    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    local th = target.Character:FindFirstChildOfClass("Humanoid")
    if not (tr and th and th.Health > 0) then VD._KillerTarget = nil; return end
    pcall(function()
        local dir = (root.Position - tr.Position).Unit
        if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1,0,0) end
        root.CFrame = CFrame.new(tr.Position + dir * 3 + Vector3.new(0,1,0), tr.Position)
        local ba = ReplicatedStorage:FindFirstChild("Remotes")
            :FindFirstChild("Attacks"):FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false) end
    end)
end

-- ── Fling ──
local function NEX_FlingNearest()
    if not VD.FLING_Enabled then return end
    local root = GetRoot(); if not root then return end
    local closest, closestDist = nil, math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local tr = pl.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (tr.Position - root.Position).Magnitude
                if d < closestDist then closestDist = d; closest = pl end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local orig = root.CFrame
            for _ = 1, 10 do
                pcall(function()
                    root.CFrame      = tr.CFrame
                    root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength/2, VD.FLING_Strength)
                    root.RotVelocity = Vector3.new(9999, 9999, 9999)
                end)
                task.wait()
            end
            pcall(function() root.CFrame = orig; root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero end)
        end
    end
end

local function NEX_FlingAll()
    if not VD.FLING_Enabled then return end
    local root = GetRoot(); if not root then return end
    local orig = root.CFrame
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local tr = pl.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for _ = 1, 5 do
                    pcall(function()
                        root.CFrame      = tr.CFrame
                        root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength/2, VD.FLING_Strength)
                        root.RotVelocity = Vector3.new(9999, 9999, 9999)
                    end)
                    task.wait()
                end
            end
        end
    end
    pcall(function() root.CFrame = orig; root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero end)
end

-- ── Improved Aimbot ──
local AimState = { AimTarget = nil, AimHolding = false }
local aimbotConnection = nil

local function AimbotGetTarget(cam)
    if not cam then return nil end
    local root = GetRoot(); if not root then return nil end
    local screenCenter = cam.ViewportSize / 2
    local closest, closestDist = nil, math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsKiller(pl) and pl.Character then
            local tr = pl.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local screen, onScreen = cam:WorldToViewportPoint(tr.Position)
                if onScreen or screen.Z > 0 then
                    local screenPos = Vector2.new(screen.X, screen.Y)
                    local dist2D    = (screenPos - screenCenter).Magnitude
                    if dist2D <= VD.AIM_FOV then
                        local passVis = true
                        if VD.AIM_VisCheck then
                            local rp = RaycastParams.new()
                            rp.FilterType = Enum.RaycastFilterType.Blacklist
                            rp.FilterDescendantsInstances = { cam, LocalPlayer.Character, pl.Character }
                            local ray = workspace:Raycast(cam.CFrame.Position, tr.Position - cam.CFrame.Position, rp)
                            passVis = (ray == nil)
                        end
                        if passVis and dist2D < closestDist then
                            closestDist = dist2D; closest = pl
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function AimbotUpdate(cam)
    if not VD.AIM_Enabled then AimState.AimTarget = nil; return end
    if VD.AIM_UseRMB and not AimState.AimHolding then AimState.AimTarget = nil; return end
    local target = AimbotGetTarget(cam)
    AimState.AimTarget = target
    if target and target.Character then
        local bone = target.Character:FindFirstChild("Head") or
                     target.Character:FindFirstChild("HumanoidRootPart")
        if bone then
            local pos = bone.Position
            if VD.AIM_Predict then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                if root then pos = pos + root.AssemblyLinearVelocity * 0.1 end
            end
            local cur    = cam.CFrame
            local smooth = math.clamp(VD.AIM_Smooth or 0.3, 0.05, 1)
            pcall(function() cam.CFrame = cur:Lerp(CFrame.new(cur.Position, pos), smooth) end)
        end
    end
end

-- Spear Aimbot (Veil Killer) — dengan FOV & Radius check
local spearFovCircle = nil
local spearFovConn = nil

local function drawSpearFOVCircle(radius)
    if spearFovConn then spearFovConn:Disconnect(); spearFovConn = nil end
    pcall(function() if spearFovCircle then spearFovCircle:Remove(); spearFovCircle = nil end end)
    if not radius or radius <= 0 then return end
    pcall(function()
        spearFovCircle           = Drawing.new("Circle")
        spearFovCircle.Radius    = radius
        spearFovCircle.Color     = Color3.fromRGB(255, 165, 0)  -- oranye, beda dari aimbot & silent
        spearFovCircle.Thickness = 2
        spearFovCircle.Filled    = false
        spearFovCircle.NumSides  = 64
        local vp = workspace.CurrentCamera.ViewportSize
        spearFovCircle.Position  = Vector2.new(vp.X / 2, vp.Y / 2)
        spearFovCircle.Visible   = true
        spearFovConn = game:GetService("RunService").RenderStepped:Connect(function()
            if not spearFovCircle then return end
            pcall(function()
                local vp2 = workspace.CurrentCamera.ViewportSize
                spearFovCircle.Position = Vector2.new(vp2.X / 2, vp2.Y / 2)
            end)
        end)
    end)
end

local function removeSpearFOVCircle()
    if spearFovConn then spearFovConn:Disconnect(); spearFovConn = nil end
    pcall(function() if spearFovCircle then spearFovCircle:Remove(); spearFovCircle = nil end end)
end

local function UpdateSpearAim()
    if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return end
    local root = GetRoot(); if not root then return end
    local cam = workspace.CurrentCamera
    local maxRadius = VD.SPEAR_Radius or 80
    local maxFov    = VD.SPEAR_FOV or 120
    local closest, closestScore = nil, math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
            local tr = pl.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (tr.Position - root.Position).Magnitude
                -- Radius check (3D distance in studs)
                if d <= maxRadius then
                    -- FOV check (screen-space pixel distance from center)
                    local screenPos, onScreen = cam:WorldToScreenPoint(tr.Position)
                    if onScreen then
                        local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if screenDist <= maxFov then
                            -- Score = prioritize closer to crosshair, then closer in 3D
                            local score = screenDist + (d * 0.5)
                            if score < closestScore then closestScore = score; closest = pl end
                        end
                    end
                end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local startPos = root.Position + Vector3.new(0, 2, 0)
            local dist     = (tr.Position - startPos).Magnitude
            local t        = dist / (VD.SPEAR_Speed or 100)
            local drop     = 0.5 * (VD.SPEAR_Gravity or 50) * t * t
            local aimPos   = tr.Position + Vector3.new(0, drop, 0)
            if cam then pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos) end) end
        end
    end
end

-- FOV Circle
local fovCircle = nil
local fovCircleConn = nil
local function drawFOVCircle(radius)
    if fovCircleConn then fovCircleConn:Disconnect(); fovCircleConn = nil end
    if fovCircle then pcall(function() fovCircle:Remove() end); fovCircle = nil end
    if not radius or radius <= 0 or not DrawingAvailable then return end
    pcall(function()
        fovCircle           = Drawing.new("Circle")
        fovCircle.Radius    = radius
        fovCircle.Color     = Color3.fromRGB(255, 200, 50)
        fovCircle.Thickness = 1.5
        fovCircle.Filled    = false
        fovCircle.NumSides  = 64
        local vp = workspace.CurrentCamera.ViewportSize
        fovCircle.Position  = Vector2.new(vp.X/2, vp.Y/2)
        fovCircle.Visible   = true
        fovCircleConn = game:GetService("RunService").RenderStepped:Connect(function()
            if not fovCircle then return end
            local vp2 = workspace.CurrentCamera.ViewportSize
            pcall(function() fovCircle.Position = Vector2.new(vp2.X/2, vp2.Y/2) end)
        end)
    end)
end

-- RMB input for aimbot
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimState.AimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimState.AimHolding = false
    end
end)

-- ── Radar ──
local Radar = {
    bg = nil, circleBg = nil, border = nil, circleBorder = nil,
    cross1 = nil, cross2 = nil, center = nil,
    dots = {}, objectDots = {}, palletSquares = {}
}

if DrawingAvailable then
    Radar.bg           = SafeDrawing("Square")
    Radar.circleBg     = SafeDrawing("Circle")
    Radar.border       = SafeDrawing("Square")
    Radar.circleBorder = SafeDrawing("Circle")
    Radar.cross1       = SafeDrawing("Line")
    Radar.cross2       = SafeDrawing("Line")
    Radar.center       = SafeDrawing("Triangle")
    if Radar.bg then Radar.bg.Filled = true; Radar.bg.Color = Color3.fromRGB(20,20,20); Radar.bg.Transparency = 0.8 end
    if Radar.circleBg then Radar.circleBg.Filled = true; Radar.circleBg.Color = Color3.fromRGB(20,20,20); Radar.circleBg.Transparency = 0.8; Radar.circleBg.NumSides = 64 end
    if Radar.border then Radar.border.Filled = false; Radar.border.Color = Color3.fromRGB(255,65,65); Radar.border.Thickness = 2 end
    if Radar.circleBorder then Radar.circleBorder.Filled = false; Radar.circleBorder.Color = Color3.fromRGB(255,65,65); Radar.circleBorder.Thickness = 2; Radar.circleBorder.NumSides = 64 end
    if Radar.cross1 then Radar.cross1.Color = Color3.fromRGB(40,40,40); Radar.cross1.Thickness = 1 end
    if Radar.cross2 then Radar.cross2.Color = Color3.fromRGB(40,40,40); Radar.cross2.Thickness = 1 end
    if Radar.center then Radar.center.Filled = true; Radar.center.Color = Color3.fromRGB(0,255,0) end
    for _ = 1, 80 do
        local d = SafeDrawing("Triangle")
        if d then d.Filled = true; d.Visible = false end
        table.insert(Radar.dots, d)
    end
    for _ = 1, 80 do
        local d = SafeDrawing("Circle")
        if d then d.Filled = true; d.Visible = false; d.NumSides = 16 end
        table.insert(Radar.objectDots, d)
    end
    for _ = 1, 80 do
        local d = SafeDrawing("Square")
        if d then d.Filled = true; d.Visible = false end
        table.insert(Radar.palletSquares, d)
    end
end

local function Radar_hideAll()
    if not DrawingAvailable then return end
    if Radar.bg then Radar.bg.Visible = false end
    if Radar.circleBg then Radar.circleBg.Visible = false end
    if Radar.border then Radar.border.Visible = false end
    if Radar.circleBorder then Radar.circleBorder.Visible = false end
    if Radar.center then Radar.center.Visible = false end
    if Radar.cross1 then Radar.cross1.Visible = false end
    if Radar.cross2 then Radar.cross2.Visible = false end
    for _, d in pairs(Radar.dots) do if d then d.Visible = false end end
    for _, d in pairs(Radar.objectDots) do if d then d.Visible = false end end
    for _, d in pairs(Radar.palletSquares) do if d then d.Visible = false end end
end

local function Radar_step(cam)
    if not DrawingAvailable then return end
    if not VD.RADAR_Enabled then Radar_hideAll(); return end
    local size   = VD.RADAR_Size
    local vp     = cam.ViewportSize
    local pos    = Vector2.new(vp.X - size - 20, 20)
    local center = pos + Vector2.new(size/2, size/2)
    if VD.RADAR_Circle then
        if Radar.bg then Radar.bg.Visible = false end
        if Radar.border then Radar.border.Visible = false end
        if Radar.circleBg then Radar.circleBg.Position = center; Radar.circleBg.Radius = size/2; Radar.circleBg.Visible = true end
        if Radar.circleBorder then Radar.circleBorder.Position = center; Radar.circleBorder.Radius = size/2; Radar.circleBorder.Visible = true end
    else
        if Radar.circleBg then Radar.circleBg.Visible = false end
        if Radar.circleBorder then Radar.circleBorder.Visible = false end
        if Radar.bg then Radar.bg.Position = pos; Radar.bg.Size = Vector2.new(size,size); Radar.bg.Visible = true end
        if Radar.border then Radar.border.Position = pos; Radar.border.Size = Vector2.new(size,size); Radar.border.Visible = true end
    end
    if Radar.cross1 then Radar.cross1.From = Vector2.new(center.X, pos.Y+10); Radar.cross1.To = Vector2.new(center.X, pos.Y+size-10); Radar.cross1.Visible = true end
    if Radar.cross2 then Radar.cross2.From = Vector2.new(pos.X+10, center.Y); Radar.cross2.To = Vector2.new(pos.X+size-10, center.Y); Radar.cross2.Visible = true end
    local myRoot = GetRoot()
    if not myRoot then Radar_hideAll(); return end
    local myAngle = math.atan2(-cam.CFrame.LookVector.X, -cam.CFrame.LookVector.Z)
    local cosA, sinA = math.cos(myAngle), math.sin(myAngle)
    local scale = (size/2 - 10) / 150
    local maxD  = size/2 - 8
    local function worldToRadar(px, pz)
        local rx, rz = px - myRoot.Position.X, pz - myRoot.Position.Z
        local d2 = math.sqrt(rx*rx + rz*rz)
        if d2 >= 150 then return nil end
        local rx2 = rx*cosA - rz*sinA
        local rz2 = rx*sinA + rz*cosA
        local rdx, rdy = rx2*scale, rz2*scale
        local rlen = math.sqrt(rdx*rdx + rdy*rdy)
        if rlen > maxD then rdx = rdx/rlen*maxD; rdy = rdy/rlen*maxD end
        return center + Vector2.new(rdx, rdy)
    end
    local idx, objIdx, pIdx = 1, 1, 1
    if VD.RADAR_Killer then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and IsKiller(pl) and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r and idx <= #Radar.dots then
                    local dp = worldToRadar(r.Position.X, r.Position.Z)
                    if dp then
                        local d = Radar.dots[idx]
                        if d then d.PointA=dp+Vector2.new(0,-5); d.PointB=dp+Vector2.new(-3,3); d.PointC=dp+Vector2.new(3,3); d.Color=Color3.fromRGB(255,65,65); d.Visible=true end
                        idx = idx + 1
                    end
                end
            end
        end
    end
    if VD.RADAR_Survivor then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and IsSurvivor(pl) and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r and idx <= #Radar.dots then
                    local dp = worldToRadar(r.Position.X, r.Position.Z)
                    if dp then
                        local d = Radar.dots[idx]
                        if d then d.PointA=dp+Vector2.new(0,-5); d.PointB=dp+Vector2.new(-3,3); d.PointC=dp+Vector2.new(3,3); d.Color=Color3.fromRGB(65,220,130); d.Visible=true end
                        idx = idx + 1
                    end
                end
            end
        end
    end
    if VD.RADAR_Generator then
        for _, gen in ipairs(NEX_Cache.Generators) do
            if gen.part and objIdx <= #Radar.objectDots then
                local dp = worldToRadar(gen.part.Position.X, gen.part.Position.Z)
                if dp then
                    local d = Radar.objectDots[objIdx]
                    if d then d.Position=dp; d.Radius=3; d.Color=Color3.fromRGB(255,180,50); d.Visible=true end
                    objIdx = objIdx + 1
                end
            end
        end
    end
    if VD.RADAR_Pallet then
        for _, p in ipairs(NEX_Cache.Pallets) do
            if p.part and pIdx <= #Radar.palletSquares then
                local dp = worldToRadar(p.part.Position.X, p.part.Position.Z)
                if dp then
                    local sq = Radar.palletSquares[pIdx]
                    if sq then sq.Position=dp-Vector2.new(2.5,2.5); sq.Size=Vector2.new(5,5); sq.Color=Color3.fromRGB(220,180,100); sq.Visible=true end
                    pIdx = pIdx + 1
                end
            end
        end
    end
    for i = idx, #Radar.dots do if Radar.dots[i] then Radar.dots[i].Visible = false end end
    for i = objIdx, #Radar.objectDots do if Radar.objectDots[i] then Radar.objectDots[i].Visible = false end end
    for i = pIdx, #Radar.palletSquares do if Radar.palletSquares[i] then Radar.palletSquares[i].Visible = false end end
    if Radar.center then
        Radar.center.PointA = center+Vector2.new(0,-8)
        Radar.center.PointB = center+Vector2.new(-4,4)
        Radar.center.PointC = center+Vector2.new(4,4)
        Radar.center.Visible = true
    end
end

-- ── Main feature loop ──
task.spawn(function()
    while not VD.Destroyed do
        pcall(NEX_AutoParry)
        pcall(NEX_AutoWiggle)
        pcall(NEX_AutoAttack)
        pcall(NEX_UpdateHitboxes)
        pcall(NEX_DestroyAllPallets)
        pcall(NEX_FullGenBreak)
        pcall(NEX_DoubleTap)
        pcall(NEX_InfiniteLunge)
        pcall(NEX_TeleportAway)
        pcall(NEX_BeatGameSurvivor)
        pcall(NEX_BeatGameKiller)
        pcall(NEX_AutoHook)
        task.wait(0.12)
    end
end)

-- ── RenderStepped for aimbot + radar ──
game:GetService("RunService").RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    pcall(AimbotUpdate, cam)
    pcall(UpdateSpearAim)
    pcall(Radar_step, cam)
end)
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

    -- Billboard lebih tinggi untuk generator (ada progress bar label)
    local isGenerator = obj.Name == "Generator"
    local bill = Instance.new("BillboardGui")
    bill.Size = isGenerator and UDim2.new(0, 200, 0, 65) or UDim2.new(0, 200, 0, 50)
    bill.Adornee = obj
    bill.AlwaysOnTop = true
    bill.Parent = obj

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Parent = bill

    -- Progress label — HANYA untuk generator, muncul di baris pertama
    local progressLabel = nil
    if isGenerator then
        progressLabel = Instance.new("TextLabel")
        progressLabel.Size = UDim2.new(1,0,0,18)
        progressLabel.Position = UDim2.new(0,0,0,0)
        progressLabel.BackgroundTransparency = 1
        progressLabel.Font = "GothamBold"
        progressLabel.TextSize = 13
        progressLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        progressLabel.TextStrokeColor3 = COLOR_OUTLINE
        progressLabel.TextStrokeTransparency = 0
        progressLabel.Text = "⚙ 0%"
        progressLabel.Parent = frame
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,18)
    nameLabel.Position = isGenerator and UDim2.new(0,0,0,18) or UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = "SourceSansBold"
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = baseColor
    nameLabel.TextStrokeColor3 = COLOR_OUTLINE
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = obj.Name
    nameLabel.Visible = ShowName
    nameLabel.Parent = frame

    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1,0,0,18)
    hpLabel.Position = isGenerator and UDim2.new(0,0,0,36) or UDim2.new(0,0,0,18)
    hpLabel.BackgroundTransparency = 1
    hpLabel.Font = "SourceSansBold"
    hpLabel.TextSize = 14
    hpLabel.TextColor3 = baseColor
    hpLabel.TextStrokeColor3 = COLOR_OUTLINE
    hpLabel.TextStrokeTransparency = 0
    hpLabel.Text = ""
    hpLabel.Parent = frame

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1,0,0,18)
    distLabel.Position = isGenerator and UDim2.new(0,0,0,54) or UDim2.new(0,0,0,36)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = "SourceSansBold"
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
        progressLabel = progressLabel,
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
    lbl.Font = "GothamBold"; lbl.TextSize = 11
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Lock button (kanan)
    local lockBtn = Instance.new("TextButton", wrapper)
    lockBtn.Size = UDim2.new(0, 26, 0, 26)
    lockBtn.Position = UDim2.new(1, -26, 0.5, -13)
    lockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    lockBtn.Text = "🔓"; lockBtn.TextSize = 13
    lockBtn.Font = "GothamBold"
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
            local skipTeam = false
            if Config.SilentAim.TeamCheck then
                local myTeam = LocalPlayer.Team
                if pl.Team and myTeam and pl.Team == myTeam then
                    skipTeam = true
                end
            end
            if not skipTeam then
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
            end -- end if not skipTeam
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
                    -- Object case (no HP) — bisa generator/hook/pallet/gate

                    data.hpLabel.Text = ""
                    data.hpLabel.Visible = false

                    -- Generator progress label
                    if data.progressLabel and obj.Name == "Generator" then
                        local pct = 0
                        pcall(function()
                            -- Method 1: Attribute "RepairProgress" (UTAMA — ini yang dipakai game VD)
                            local rp = obj:GetAttribute("RepairProgress")
                            if rp then
                                if rp <= 1 then
                                    pct = math.floor(rp * 100)
                                else
                                    pct = math.min(math.floor(rp), 100)
                                end
                            end

                            -- Method 2: Cek attribute lain yang mungkin dipakai
                            if pct == 0 then
                                local attrVal = obj:GetAttribute("Progress")
                                    or obj:GetAttribute("GeneratorProgress")
                                    or obj:GetAttribute("Percent")
                                    or obj:GetAttribute("Completion")
                                    or obj:GetAttribute("Value")
                                if attrVal then
                                    pct = math.clamp(math.floor(attrVal <= 1 and attrVal * 100 or attrVal), 0, 100)
                                end
                            end

                            -- Method 3: Cari NumberValue/IntValue di direct children
                            if pct == 0 then
                                local pv = nil
                                for _, child in ipairs(obj:GetChildren()) do
                                    if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("DoubleConstrainedValue") then
                                        if child.Name:find("Progress") or child.Name:find("progress")
                                           or child.Name:find("Value") or child.Name:find("Percent")
                                           or child.Name:find("Completion") or child.Name:find("Repair") then
                                            pv = child; break
                                        end
                                    end
                                end
                                if pv then
                                    local val = pv.Value
                                    pct = math.clamp(math.floor(val <= 1 and val * 100 or val), 0, 100)
                                end
                            end

                            -- Method 4: Cari di descendants lebih dalam (HitBox dll)
                            if pct == 0 then
                                for _, desc in ipairs(obj:GetDescendants()) do
                                    -- Cek attribute RepairProgress di child parts
                                    if desc:IsA("BasePart") then
                                        local aVal = desc:GetAttribute("RepairProgress")
                                            or desc:GetAttribute("Progress")
                                            or desc:GetAttribute("Percent")
                                            or desc:GetAttribute("Completion")
                                        if aVal then
                                            pct = math.clamp(math.floor(aVal <= 1 and aVal * 100 or aVal), 0, 100)
                                            break
                                        end
                                    end
                                    if (desc:IsA("NumberValue") or desc:IsA("IntValue")) and
                                       (desc.Name:find("Progress") or desc.Name:find("progress")
                                        or desc.Name:find("Percent") or desc.Name:find("Completion")
                                        or desc.Name:find("Repair")) then
                                        local val = desc.Value
                                        pct = math.clamp(math.floor(val <= 1 and val * 100 or val), 0, 100)
                                        break
                                    end
                                end
                            end

                            -- Method 5: Fallback PointLight warna (hijau = done)
                            if pct == 0 then
                                local hb = obj:FindFirstChild("HitBox")
                                local pl2 = hb and hb:FindFirstChildOfClass("PointLight")
                                if pl2 and pl2.Color == Color3.fromRGB(126,255,126) then
                                    pct = 100
                                end
                            end
                        end)
                        local bar = string.rep("█", math.floor(pct/10)) .. string.rep("░", 10 - math.floor(pct/10))
                        data.progressLabel.Text = "⚙ " .. pct .. "% " .. bar
                        -- Warna: hijau kalau selesai, kuning kalau progress, putih kalau 0
                        if pct >= 100 then
                            data.progressLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
                        elseif pct > 0 then
                            data.progressLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
                        else
                            data.progressLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                        data.progressLabel.Visible = true
                    end

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
EspTab:Toggle({
    Title = "ESP Survivor",
    Desc  = "Tampilkan highlight & info Survivor",
    Value = false,
    Callback = function(v) pcall(function() espSurvivor = v end) end
})
EspTab:Toggle({
    Title = "ESP Killer",
    Desc  = "Tampilkan highlight & info Killer",
    Value = false,
    Callback = function(v) pcall(function() espMurder = v end) end
})

EspTab:Section({ Title = "Esp Engine", Icon = "biceps-flexed" })
EspTab:Toggle({
    Title = "ESP Generator",
    Desc  = "Tampilkan highlight generator di map",
    Value = false,
    Callback = function(v) pcall(function() espGenerator = v end) end
})
EspTab:Toggle({
    Title = "ESP Gate",
    Desc  = "Tampilkan highlight pintu gerbang",
    Value = false,
    Callback = function(v) pcall(function() espGate = v end) end
})

EspTab:Section({ Title = "Esp Object", Icon = "package" })
EspTab:Toggle({
    Title = "ESP Pallet",
    Desc  = "Tampilkan highlight pallet",
    Value = false,
    Callback = function(v) pcall(function() espPallet = v end) end
})
EspTab:Toggle({
    Title = "ESP Hook",
    Desc  = "Tampilkan highlight hook",
    Value = false,
    Callback = function(v) pcall(function() espHook = v end) end
})
EspTab:Toggle({
    Title = "ESP Window",
    Desc  = "Tampilkan highlight jendela",
    Value = false,
    Callback = function(v)
        pcall(function()
            espWindowEnabled = v
            updateWindowESP()
        end)
    end
})

EspTab:Section({ Title = "Esp Event", Icon = "candy" })
EspTab:Toggle({
    Title = "ESP Pumkin",
    Desc  = "Tampilkan highlight labu event",
    Value = false,
    Callback = function(v)
        pcall(function()
            espPumkin = v
            updatePumkinESP()
        end)
    end
})

EspTab:Section({ Title = "Esp Settings", Icon = "settings" })
EspTab:Toggle({Title="Show Name",      Desc="Tampilkan nama player", Value=ShowName,      Callback=function(v) pcall(function() ShowName=v end) end})
EspTab:Toggle({Title="Show Distance",  Desc="Tampilkan jarak",       Value=ShowDistance,  Callback=function(v) pcall(function() ShowDistance=v end) end})
EspTab:Toggle({Title="Show Health",    Desc="Tampilkan bar HP",       Value=ShowHP,        Callback=function(v) pcall(function() ShowHP=v end) end})
EspTab:Toggle({Title="Show Highlight", Desc="Tampilkan highlight box",Value=ShowHighlight, Callback=function(v) pcall(function() ShowHighlight=v end) end})

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

-- ── ESP COLOR PICKER ─────────────────────────────────────────────
EspTab:Section({ Title = "ESP Color Picker", Icon = "palette" })

EspTab:Colorpicker({
    Title   = "Warna ESP Survivor",
    Desc    = "Ubah warna highlight & label Survivor",
    Default = Color3.fromRGB(0, 0, 255),
    Transparency = 0,
    Callback = function(v)
        pcall(function()
            COLOR_SURVIVOR = v
            -- Update semua ESP survivor yang sudah ada
            for obj, data in pairs(espObjects) do
                local pl = Players:GetPlayerFromCharacter(obj)
                if pl then
                    local team = pl.Team and pl.Team.Name:lower() or ""
                    local isKiller = team:find("killer") or team:find("maniac")
                    if not isKiller then
                        if data.highlight then
                            data.highlight.FillColor    = v
                            data.highlight.OutlineColor = v
                        end
                        if data.nameLabel  then data.nameLabel.TextColor3  = v end
                        if data.hpLabel    then data.hpLabel.TextColor3    = v end
                        if data.distLabel  then data.distLabel.TextColor3  = v end
                    end
                end
            end
        end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Killer",
    Desc    = "Ubah warna highlight & label Killer",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(v)
        pcall(function()
            COLOR_MURDERER = v
            for obj, data in pairs(espObjects) do
                local pl = Players:GetPlayerFromCharacter(obj)
                if pl then
                    local team = pl.Team and pl.Team.Name:lower() or ""
                    local isKiller = team:find("killer") or team:find("maniac")
                    if isKiller then
                        if data.highlight then
                            data.highlight.FillColor    = v
                            data.highlight.OutlineColor = v
                        end
                        if data.nameLabel  then data.nameLabel.TextColor3  = v end
                        if data.hpLabel    then data.hpLabel.TextColor3    = v end
                        if data.distLabel  then data.distLabel.TextColor3  = v end
                    end
                end
            end
        end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Generator",
    Desc    = "Warna highlight generator yang belum selesai",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_GENERATOR = v end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Generator (Done)",
    Desc    = "Warna highlight generator yang sudah selesai",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_GENERATOR_DONE = v end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Gate",
    Desc    = "Warna highlight pintu gerbang",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_GATE = v end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Pallet",
    Desc    = "Warna highlight pallet",
    Default = Color3.fromRGB(255, 255, 0),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_PALLET = v end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Hook",
    Desc    = "Warna highlight hook di map",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_HOOK = v end)
    end
})

EspTab:Colorpicker({
    Title   = "Warna ESP Window",
    Desc    = "Warna highlight jendela",
    Default = Color3.fromRGB(255, 165, 0),
    Transparency = 0,
    Callback = function(v)
        pcall(function() COLOR_WINDOW = v end)
    end
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

-- ── Auto Parry (v2.0 — fires actual Parrying Dagger remote with angle+raycast check) ──
SurTab:Toggle({
    Title       = "Auto Parry",
    Description = "Deteksi killer dalam jangkauan + cek sudut → fire parry remote otomatis",
    Value       = false,
    Callback    = function(v) VD.AUTO_Parry = v end
})
SurTab:Slider({
    Title = "Parry Range (studs)",
    Value = { Min = 5, Max = 30, Default = 15 }, Step = 1,
    Callback = function(v) VD.AUTO_ParryRange = v end
})
SurTab:Slider({
    Title = "Parry Angle Max (°) — hadap killer dulu",
    Value = { Min = 10, Max = 90, Default = 30 }, Step = 5,
    Callback = function(v) VD.AUTO_ParrySensitivity = v end
})
SurTab:Slider({
    Title = "Parry Cooldown (×0.1 detik)",
    Value = { Min = 1, Max = 30, Default = 5 }, Step = 1,
    Callback = function(v) VD.AUTO_ParryDelay = v * 0.1 end
})

SurTab:Section({ Title = "Auto Wiggle", Icon = "activity" })
SurTab:Toggle({
    Title = "Auto Wiggle (saat di-carry)",
    Value = false,
    Callback = function(v) VD.SURV_AutoWiggle = v end
})

SurTab:Section({ Title = "Survival Utility", Icon = "shield-check" })
SurTab:Toggle({
    Title = "No Fall Damage",
    Value = false,
    Callback = function(v) VD.SURV_NoFall = v end
})
SurTab:Toggle({
    Title       = "Flee Killer (Auto TP Menjauh)",
    Description = "TP ke tempat terjauh dari killer saat dia terlalu dekat",
    Value       = false,
    Callback    = function(v) VD.AUTO_TeleAway = v end
})
SurTab:Slider({
    Title = "Flee Trigger Distance (studs)",
    Value = { Min = 10, Max = 80, Default = 40 }, Step = 5,
    Callback = function(v) VD.AUTO_TeleAwayDist = v end
})

SurTab:Section({ Title = "Beat Game (Survivor)", Icon = "trophy" })
SurTab:Toggle({
    Title       = "Beat Survivor (Auto Escape)",
    Description = "TP ke exit gate dan fire ESCAPED event",
    Value       = false,
    Callback    = function(v) VD.BEAT_Survivor = v end
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

-- ════ SELF HEAL / REVIVE ═══
-- Game VD mechanics:
--   HP < 50  = KNOCKED (bisa di-carry, di-hook killer)
--   HP 50-100 = ALIVE (normal, bisa jalan/tembak)
--
-- Server-side heal sequence (dari RemoteSpy):
--   REVIVE dari KNOCK:
--     1. Collision.EnableCollision:FireServer()
--     2. EmoteHandler("StopEmote")
--     3. Healing.Reset(Player)
--
--   HEAL partial damage:
--     1. ChangeAttribute("Crouchingserver", false)
--     2. EmoteHandler("StopEmote")
--     3. Healing.Reset(Player)
--
--   Kita kirim SEMUA remote supaya cover kedua skenario.
--   Client-side HP set hanya visual, server-side HP = Healing.Reset.
--   Penting: kirim remote dengan urutan benar + delay kecil supaya server proses.
local autoSelfReviveEnabled = false

local function sendSelfHeal()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- ═══ Step 1: Stop healing yang sedang berjalan (kalau ada) ═══
    pcall(function() ReplicatedStorage.Remotes.Healing.Stophealing:FireServer() end)

    -- ═══ Step 2: Re-enable collision (WAJIB saat revive dari knock) ═══
    pcall(function() ReplicatedStorage.Remotes.Collision.EnableCollision:FireServer() end)

    -- ═══ Step 3: Hapus injured/crouching attribute ═══
    pcall(function() ReplicatedStorage.Remotes.Mechanics.Status.ChangeAttribute:FireServer("Crouchingserver", false) end)
    if root then
        pcall(function() root:SetAttribute("Crouchingserver", false) end)
    end

    -- ═══ Step 4: Stop emote sekarat ═══
    pcall(function() ReplicatedStorage.Remotes.EmoteHandler:FireServer("StopEmote") end)

    -- ═══ Step 5: Fix knock state di client ═══
    if hum then
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end

    -- ═══ Step 6: Healing animations (proses heal terlihat) ═══
    pcall(function() ReplicatedStorage.Remotes.Healing.HealAnim:FireServer() end)
    pcall(function() ReplicatedStorage.Remotes.Healing.HealAnimRec:FireServer() end)

    -- ═══ Step 7: Kirim SkillCheckResult (auto-pass skill check) ═══
    pcall(function() ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent:FireServer("neutral", 0, char) end)

    -- ═══ Step 8: Reset HP server-side (INI YANG BIKIN HP PENUH DI SERVER) ═══
    pcall(function() ReplicatedStorage.Remotes.Healing.Reset:FireServer(LocalPlayer) end)

    -- ═══ Step 9: Hapus efek darah di screen ═══
    pcall(function() ReplicatedStorage.Remotes.Healing.DisplayBlood:FireServer() end)

    -- ═══ Step 10: Set HP client-side (visual) ═══
    if hum then
        pcall(function() hum.Health = hum.MaxHealth end)
    end
end

-- Cek apakah player dalam state KNOCK
local function isKnocked()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health < 50 then return true end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.FallingDown
    or state == Enum.HumanoidStateType.PlatformStanding
    or state == Enum.HumanoidStateType.Dead then
        return true
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root:GetAttribute("Crouchingserver") == true then
        return true
    end
    return false
end

SurTab:Toggle({
    Title = "Auto Self Revive (saat knock)",
    Desc  = "Otomatis bangun saat knocked. Kirim remote lengkap ke server!",
    Value = false,
    Callback = function(v)
        autoSelfReviveEnabled = v
        if v then
            task.spawn(function()
                while autoSelfReviveEnabled do
                    if isKnocked() then
                        sendSelfHeal()
                        task.wait(0.3)
                        -- Burst ke-2 kalau masih knocked
                        if isKnocked() then sendSelfHeal() end
                    end
                    task.wait(0.5)
                end
            end)
            WindUI:Notify({Title = "Auto Revive", Content = "Aktif! Bangun otomatis saat knock.", Duration = 2, Icon = "heart"})
        else
            WindUI:Notify({Title = "Auto Revive", Content = "Dimatikan.", Duration = 2, Icon = "heart"})
        end
    end
})

SurTab:Button({
    Title = "Instant Full Heal (Self)",
    Desc  = "Heal lengkap: StopHealing + Collision + ChangeAttribute + Anim + SkillCheck + Reset + HP",
    Callback = function()
        if not LocalPlayer.Character then
            WindUI:Notify({Title = "Error", Content = "Karakter tidak ditemukan!", Duration = 2, Icon = "alert-circle"})
            return
        end
        sendSelfHeal()
        -- Burst ke-2 dan ke-3 dengan delay
        task.delay(0.3, function() sendSelfHeal() end)
        task.delay(0.6, function() sendSelfHeal() end)
        WindUI:Notify({Title = "Heal", Content = "3x Full Heal dikirim! HP harus penuh di server.", Duration = 2, Icon = "heart"})
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
                                Angle = Angle + 100
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
                BV.Name = "Holic-YES"
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

        if not Welcome then Message("Holic | FLING", "THANK FOR USING", 6) end
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
local vaultTouchConns     = {}
local vaultMapConn        = nil

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

-- Cari VaultTrigger terdekat dari posisi player
local function findNearestVaultTrigger()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, nearestDist = nil, 30 -- max 30 studs
    for _, t in ipairs(getAllVaultTriggers()) do
        local d = (t.Position - root.Position).Magnitude
        if d < nearestDist then
            nearestDist = d
            nearest = t
        end
    end
    return nearest
end

-- Fast vault: kirim semua remote dengan urutan yang benar
local function doFastVault(trigger)
    if not trigger then return end
    -- Sequence yang benar dari RemoteSpy:
    -- 1. VaultEvent(trigger, true) = mulai vault
    -- 2. fastvault(Player) = skip animasi, langsung selesai
    -- 3. VaultCompleteEvent(trigger, false) = selesai vault
    -- 4. VaultAnim = animasi vault (optional)
    -- 5. Vaultbindable = client-side vault trigger
    pcall(function() ReplicatedStorage.Remotes.Window.VaultEvent:FireServer(trigger, true) end)
    pcall(function() ReplicatedStorage.Remotes.Window.fastvault:FireServer(LocalPlayer) end)
    pcall(function() ReplicatedStorage.Remotes.Window.VaultAnim:FireServer() end)
    pcall(function() ReplicatedStorage.Remotes.Window.VaultCompleteEvent:FireServer(trigger, false) end)
    pcall(function() ReplicatedStorage.Remotes.Window.VaultCompleteEvent:FireServer(trigger, true) end)
    pcall(function()
        local vb = ReplicatedStorage.Remotes.Window:FindFirstChild("Vaultbindable")
        if vb then vb:FireServer() end
    end)
    pcall(function()
        local vp1 = ReplicatedStorage.Remotes.Window:FindFirstChild("VaultComplete Eventpart1")
        if vp1 then vp1:FireServer() end
    end)
end

local function hookOneVaultTrigger(trigger)
    local lastVaultTime = 0
    local conn = trigger.Touched:Connect(function(part)
        if not fastVaultEnabled then return end
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
        -- Debounce 1 detik supaya tidak double vault
        if tick() - lastVaultTime < 1 then return end
        lastVaultTime = tick()
        doFastVault(trigger)
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
            if v.Name == "VaultTrigger" and v:IsA("BasePart") and fastVaultEnabled then
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
    Title       = "Fast Vault",
    Description = "Saat lewat jendela, otomatis vault cepat tanpa animasi",
    Value       = false,
    Callback    = function(v)
        fastVaultEnabled = v
        if v then
            startVaultHook()
            WindUI:Notify({ Title="Vault", Content="Fast Vault aktif!", Duration=2, Icon="wind" })
        else
            stopVaultHook()
        end
    end
})

SurTab:Button({
    Title    = "Manual Fast Vault",
    Desc     = "Tekan untuk vault terdekat (max 30 studs). Gunakan kalau auto vault tidak jalan.",
    Callback = function()
        local trigger = findNearestVaultTrigger()
        if trigger then
            doFastVault(trigger)
            WindUI:Notify({Title = "Vault", Content = "Fast Vault dikirim!", Duration = 1.5, Icon = "wind"})
        else
            WindUI:Notify({Title = "Vault", Content = "Tidak ada vault terdekat! Mendekati jendela dulu.", Duration = 2, Icon = "alert-circle"})
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

-- ============================================================
-- HEAL PLAYER LAIN
-- ============================================================
-- HealEvent(HRP, false) = heal orang LAIN (server accept!)
-- HealEvent(HRP, true)  = revive dari knocked (orang lain)
-- ⚠️ TIDAK BISA untuk diri sendiri — server reject kalau HRP milik sendiri
SurTab:Section({ Title = "Heal Player Lain", Icon = "heart" })

local function refreshHealPlayerDropdown()
    local options = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local role = (pl.Team and pl.Team.Name) or "?"
            table.insert(options, pl.Name .. " [" .. role .. "]")
        end
    end
    return #options > 0 and options or {"(Tidak ada player lain)"}
end

local selectedHealPlayer = ""

local healPlayerDropdown = SurTab:Dropdown({
    Title    = "Pilih Player",
    Values   = refreshHealPlayerDropdown(),
    Value    = "",
    Callback = function(selected)
        selectedHealPlayer = selected
    end
})

-- helper: cari player object dari dropdown name
local function findPlayerFromDropdown(dropdownName)
    if dropdownName == "" or dropdownName == "(Tidak ada player lain)" then return nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and dropdownName:find(pl.Name, 1, true) then
            return pl
        end
    end
    return nil
end

-- helper: heal 1x ke player lain
local function healOtherPlayer(targetPl)
    if not targetPl or not targetPl.Character then return false end
    local tr = targetPl.Character:FindFirstChild("HumanoidRootPart")
    local th = targetPl.Character:FindFirstChildOfClass("Humanoid")
    if not tr or not th then return false end
    local isDowned = (th.Health / th.MaxHealth) < 0.5
    pcall(function() ReplicatedStorage.Remotes.Healing.HealEvent:FireServer(tr, isDowned) end)
    pcall(function() ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent:FireServer("neutral", 0, targetPl.Character) end)
    pcall(function() ReplicatedStorage.Remotes.Healing.HealAnim:FireServer() end)
    pcall(function() ReplicatedStorage.Remotes.Healing.HealAnimRec:FireServer() end)
    return true
end

SurTab:Button({
    Title = "Heal Player Pilihan (1x)",
    Desc  = "Heal/Revive player yang dipilih di dropdown.",
    Callback = function()
        local target = findPlayerFromDropdown(selectedHealPlayer)
        if not target then
            WindUI:Notify({Title = "Heal", Content = "Pilih player dulu dari dropdown!", Duration = 2, Icon = "alert-circle"})
            return
        end
        if healOtherPlayer(target) then
            WindUI:Notify({Title = "Heal", Content = "Heal dikirim ke " .. target.Name .. "!", Duration = 2, Icon = "heart"})
        else
            WindUI:Notify({Title = "Heal", Content = "Gagal heal " .. target.Name .. ". Karakter tidak ditemukan.", Duration = 2, Icon = "alert-circle"})
        end
    end
})

SurTab:Button({
    Title = "Heal Player Pilihan (30x)",
    Desc  = "Spam heal 30x ke player yang dipilih. Untuk knock yang bandel!",
    Callback = function()
        local target = findPlayerFromDropdown(selectedHealPlayer)
        if not target then
            WindUI:Notify({Title = "Heal", Content = "Pilih player dulu dari dropdown!", Duration = 2, Icon = "alert-circle"})
            return
        end
        task.spawn(function()
            local success = 0
            for i = 1, 30 do
                if healOtherPlayer(target) then
                    success = success + 1
                end
                if i < 30 then task.wait(0.05) end
            end
            WindUI:Notify({Title = "Heal 30x", Content = success .. "x heal dikirim ke " .. target.Name .. "!", Duration = 2, Icon = "heart"})
        end)
    end
})

SurTab:Button({
    Title = "Refresh Player List",
    Desc  = "Perbarui daftar player di dropdown.",
    Callback = function()
        pcall(function()
            healPlayerDropdown:Refresh(refreshHealPlayerDropdown(), false)
            selectedHealPlayer = ""
            WindUI:Notify({Title = "Refresh", Content = "Daftar player diperbarui.", Duration = 1.5, Icon = "refresh-cw"})
        end)
    end
})

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
-- AIMBOT TAB (v2.0 — FOV screen-space, Lerp smooth, RMB, predict)
-- ============================================================
AimTab:Section({ Title = "Camera Aimbot", Icon = "crosshair" })

AimTab:Toggle({
    Title       = "Enable Aimbot",
    Description = "Kamera Lerp ke target dalam FOV — target: Killer terdekat di layar",
    Value       = false,
    Callback    = function(v)
        VD.AIM_Enabled = v
        if not v then drawFOVCircle(0) end
    end
})
AimTab:Toggle({
    Title = "Hold RMB to Aim (tahan klik kanan)",
    Value = true,
    Callback = function(v) VD.AIM_UseRMB = v end
})
AimTab:Toggle({
    Title = "Show FOV Circle",
    Value = true,
    Callback = function(v)
        VD.AIM_ShowFOV = v
        if v then drawFOVCircle(VD.AIM_FOV) else drawFOVCircle(0) end
    end
})
AimTab:Toggle({
    Title = "Visibility Check (raycast)",
    Value = true,
    Callback = function(v) VD.AIM_VisCheck = v end
})
AimTab:Toggle({
    Title = "Prediction (lead target)",
    Value = true,
    Callback = function(v) VD.AIM_Predict = v end
})
AimTab:Slider({
    Title    = "FOV Radius (pixel dari tengah layar)",
    Value    = { Min = 30, Max = 500, Default = 120 },
    Step     = 10,
    Callback = function(v)
        VD.AIM_FOV = v
        if VD.AIM_ShowFOV then drawFOVCircle(v) end
    end
})
AimTab:Slider({
    Title    = "Smoothness (0.05=snappy, 1=instant)",
    Value    = { Min = 1, Max = 20, Default = 6 },
    Step     = 1,
    Callback = function(v) VD.AIM_Smooth = v / 20 end
})

AimTab:Section({ Title = "Spear Aimbot (Veil Killer)", Icon = "arrow-up-right" })
AimTab:Toggle({
    Title       = "Spear Aimbot",
    Description = "Auto-aim kamera dengan kompensasi gravitasi untuk spear Veil",
    Value       = false,
    Callback    = function(v)
        VD.SPEAR_Aimbot = v
        if v then
            drawSpearFOVCircle(VD.SPEAR_FOV)
        else
            removeSpearFOVCircle()
        end
    end
})
AimTab:Toggle({
    Title       = "Show Spear FOV Circle",
    Description = "Tampilkan lingkaran FOV untuk Spear Aimbot",
    Value       = true,
    Callback    = function(v)
        if v and VD.SPEAR_Aimbot then
            drawSpearFOVCircle(VD.SPEAR_FOV)
        else
            removeSpearFOVCircle()
        end
    end
})
AimTab:Slider({
    Title    = "Spear FOV (pixel dari tengah layar)",
    Value    = { Min = 30, Max = 500, Default = 120 },
    Step     = 10,
    Callback = function(v)
        VD.SPEAR_FOV = v
        if VD.SPEAR_Aimbot then drawSpearFOVCircle(v) end
    end
})
AimTab:Slider({
    Title    = "Spear Radius (studs)",
    Value    = { Min = 10, Max = 300, Default = 80 },
    Step     = 5,
    Callback = function(v) VD.SPEAR_Radius = v end
})
AimTab:Slider({
    Title    = "Spear Gravity",
    Value    = { Min = 10, Max = 200, Default = 50 },
    Step     = 5,
    Callback = function(v) VD.SPEAR_Gravity = v end
})
AimTab:Slider({
    Title    = "Spear Speed",
    Value    = { Min = 50, Max = 300, Default = 100 },
    Step     = 10,
    Callback = function(v) VD.SPEAR_Speed = v end
})

AimTab:Section({ Title = "Radar", Icon = "radar" })
AimTab:Toggle({ Title = "Enable Radar", Value = false, Callback = function(v) VD.RADAR_Enabled = v; if not v then Radar_hideAll() end end })
AimTab:Toggle({ Title = "Circle Shape", Value = false, Callback = function(v) VD.RADAR_Circle = v end })
AimTab:Slider({ Title = "Radar Size", Value = {Min=80,Max=250,Default=120}, Step=10, Callback = function(v) VD.RADAR_Size = v end })
AimTab:Section({ Title = "Radar Filters", Icon = "filter" })
AimTab:Toggle({ Title = "Show Killer",    Value = true,  Callback = function(v) VD.RADAR_Killer    = v end })
AimTab:Toggle({ Title = "Show Survivor",  Value = true,  Callback = function(v) VD.RADAR_Survivor  = v end })
AimTab:Toggle({ Title = "Show Generator", Value = true,  Callback = function(v) VD.RADAR_Generator = v end })
AimTab:Toggle({ Title = "Show Pallet",    Value = true,  Callback = function(v) VD.RADAR_Pallet    = v end })

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
-- INFORMATION TAB CONTENT
-- ============================================================
pcall(function()
    Info:Paragraph({
        Title = "Holic",
        Desc = "Dibuat oleh Saycho\nPada tanggal 01 Mei 2026\n\nScript khusus untuk Violence District\nFast Vault, ESP, Aimbot, Heal, dan lainnya.",
        Image = "rbxassetid://99240933011775",
        ImageSize = 40,
        Thumbnail = "",
        ThumbnailSize = 0,
        Locked = false,
        Buttons = {}
    })

    Info:Divider()

    Info:Paragraph({
        Title = "Discord",
        Desc = "Join server Discord untuk update, info, dan chat!",
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
end)

-- ============================================================
-- QUICK PANEL  — 3 tombol floating TERPISAH, masing-masing
--   punya toggle sendiri di MainTab. Setiap tombol bisa di-drag.
-- ============================================================

-- Helper: buat 1 tombol floating mandiri (draggable, tap = toggle)
local function makeFloatingBtn(name, icon, colOn, colStrokeOn, initPos, tapFn)
    local sg = Instance.new("ScreenGui")
    sg.Name = "Holic_FB_" .. name
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
    btn.Font             = "GothamBold"
    btn.TextColor3       = Color3.fromRGB(160,160,160)
    btn.BorderSizePixel  = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local stk = Instance.new("UIStroke", btn)
    stk.Color = COL_STROKE_OFF; stk.Thickness = 1.5

    -- Label kecil di bawah tombol
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size            = UDim2.new(0,80,0,16)
    lbl.BackgroundTransparency = 1
    lbl.Font            = "GothamBold"
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

MainTab:Colorpicker({
    Title    = "Warna Crosshair",
    Desc     = "Pilih warna untuk crosshair kustom",
    Default  = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Callback = function(v)
        pcall(function()
            crosshairColor = v
            buildCrosshair()
        end)
    end
})

-- ============================================================
-- ISI TAB FLING & DESTRUCTION
-- ============================================================
FlingTab:Section({ Title = "Fling Tools", Icon = "zap" })

FlingTab:Button({
    Title = "⚡ Fling Killer Terdekat",
    Desc  = "Lempar killer yang dekat ke luar map",
    Callback = function()
        pcall(NEX_FlingNearest)
        WindUI:Notify({Title = "Fling", Content = "Mengeksekusi Fling ke Killer!", Duration = 2})
    end,
})

FlingTab:Button({
    Title = "💥 Fling Semua Player",
    Desc  = "Lempar semua orang di server",
    Callback = function()
        pcall(NEX_FlingAll)
    end,
})

FlingTab:Section({ Title = "Map Destruction (Killer Mode)", Icon = "tool" })

FlingTab:Button({
    Title = "🔨 Break All Generator",
    Desc  = "Hancurkan semua generator instan",
    Callback = function()
        pcall(NEX_FullGenBreak)
        WindUI:Notify({Title = "Destroy", Content = "Semua Generator dihancurkan!", Duration = 2})
    end,
})

FlingTab:Button({
    Title = "🪵 Drop All Pallet",
    Desc  = "Jatuhkan semua pallet di map sekaligus",
    Callback = function()
        pcall(NEX_DestroyAllPallets)
        WindUI:Notify({Title = "Destroy", Content = "Semua Pallet dijatuhkan!", Duration = 2})
    end,
})

-- ============================================================
-- END OF SCRIPT
-- ============================================================
