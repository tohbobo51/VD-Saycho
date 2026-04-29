--[[
╔══════════════════════════════════════════════════════════╗
║   PROJECT : VD (Violence District) - PLATINUM            ║
║   VERSION : 6.2 + SkillCheck — FULL COMBINED SCRIPT     ║
║   BY      : Saycho                                       ║
╠══════════════════════════════════════════════════════════╣
║  FIX v6.2 :                                              ║
║  [1] Semua tombol .Activated → .MouseButton1Click        ║
║  [2] AutoHeal   — cooldown 4s                            ║
║  [3] AntiChase  — cooldown 2s                            ║
║  [4] AutoGen    — interval 0.1s + cek jarak 10 studs     ║
║  [5] FastVault  — loop heartbeat 0.2s                    ║
║  [6] AutoRepair — cooldown 1s                            ║
║  [7] GetGen     — multi-path fallback (robust)           ║
║  [8] attackTimer— dipisah FastAttack vs AutoLunge        ║
║  [9] SkillCheck — ChildAdded listener, tidak hang        ║
╚══════════════════════════════════════════════════════════╝
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui             = game:GetService("CoreGui")
local Players             = game:GetService("Players")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Workspace           = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- CLEANUP
-- ============================================================
if CoreGui:FindFirstChild("VD_Saycho_Official") then
    CoreGui.VD_Saycho_Official:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name           = "VD_Saycho_Official"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- REMOTE REFERENCES
-- ============================================================
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Remote = {
    EmoteHandler    = Remotes:WaitForChild("EmoteHandler"),
    Chase           = Remotes:WaitForChild("Chase"):WaitForChild("Runevent"),
    HealReset       = Remotes:WaitForChild("Healing"):WaitForChild("Reset"),
    UpdateLook      = Remotes:WaitForChild("Game"):WaitForChild("UpdateCharacterLook"),
    BasicAttack     = Remotes:WaitForChild("Attacks"):WaitForChild("BasicAttack"),
    Lunge           = Remotes:WaitForChild("Attacks"):WaitForChild("Lunge"),
    PowerDeact      = Remotes:WaitForChild("Killers"):WaitForChild("Killer"):WaitForChild("PowerDoneDeactivating"),
    FastVault       = Remotes:WaitForChild("Window"):WaitForChild("fastvault"),
    EnableCollision = Remotes:WaitForChild("Collision"):WaitForChild("EnableCollision"),
    RepairEvent     = Remotes:WaitForChild("Generator"):WaitForChild("RepairEvent"),
}

local function SafeFire(remote, ...)
    if not remote then return end
    local ok, err = pcall(function() remote:FireServer(...) end)
    if not ok then warn("[VD v6.2] Remote error: " .. tostring(err)) end
end

-- ============================================================
-- GLOBAL STATES
-- ============================================================
local States = {
    AutoHeal      = false,
    DirLockActive = false,
    NoCD          = false,
    EspEnabled    = false,
    AutoRepair    = false,
    FastVault     = false,
    FastGen       = false,
    AutoLever     = false,
    AutoGenerator = false,
    NoStamina     = false,
    AntiChase     = false,
    FastAttack    = false,
    AutoLunge     = false,
}

local LockedLookVector = nil
local ESPObjects       = {}

-- ============================================================
-- TIMER COOLDOWNS
-- ============================================================
local Timers = {
    heal    = 0,   CD_heal    = 4.0,
    chase   = 0,   CD_chase   = 2.0,
    repair  = 0,   CD_repair  = 0.1,
    vault   = 0,   CD_vault   = 0.2,
    attack  = 0,   CD_attack  = 0.3,
    lunge   = 0,   CD_lunge   = 0.5,
    object  = 0,   CD_object  = 1.0,
}

-- ============================================================
-- DRAGGING UTILITY
-- ============================================================
local function MakeDraggable(obj, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ============================================================
-- FLOATING ICON
-- ============================================================
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name             = "LynxxIcon"
OpenBtn.Size             = UDim2.new(0, 55, 0, 55)
OpenBtn.Position         = UDim2.new(0, 15, 0.5, -27)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Image            = "rbxassetid://15125301131"
OpenBtn.Visible          = false
OpenBtn.ZIndex           = 10
local LogoCorner = Instance.new("UICorner", OpenBtn)
LogoCorner.CornerRadius  = UDim.new(1, 0)
MakeDraggable(OpenBtn, OpenBtn)

-- ============================================================
-- MAIN FRAME
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name             = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Size             = UDim2.new(0, 520, 0, 340)
MainFrame.Position         = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Drag Zone
local DragZone = Instance.new("TextButton", MainFrame)
DragZone.Size                   = UDim2.new(1, -50, 0, 50)
DragZone.Position               = UDim2.new(0, 0, 0, 0)
DragZone.BackgroundTransparency = 1
DragZone.Text                   = ""
DragZone.ZIndex                 = 1
MakeDraggable(MainFrame, DragZone)

-- Grip bar
local TopGrip = Instance.new("Frame", MainFrame)
TopGrip.Size             = UDim2.new(0, 60, 0, 4)
TopGrip.Position         = UDim2.new(0.5, -30, 0, 7)
TopGrip.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TopGrip.BorderSizePixel  = 0
TopGrip.ZIndex           = 2
Instance.new("UICorner", TopGrip)

-- Title
local LynxxTitle = Instance.new("TextLabel", MainFrame)
LynxxTitle.Text                   = "Lynxx 🪐"
LynxxTitle.Position               = UDim2.new(0, 15, 0, 16)
LynxxTitle.Size                   = UDim2.new(0, 90, 0, 22)
LynxxTitle.TextColor3             = Color3.fromRGB(255, 140, 0)
LynxxTitle.Font                   = "GothamBold"
LynxxTitle.TextSize               = 16
LynxxTitle.BackgroundTransparency = 1
LynxxTitle.TextXAlignment         = "Left"
LynxxTitle.ZIndex                 = 3

local Sep = Instance.new("Frame", MainFrame)
Sep.Size             = UDim2.new(0, 1, 0, 18)
Sep.Position         = UDim2.new(0, 110, 0, 20)
Sep.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Sep.BorderSizePixel  = 0
Sep.ZIndex           = 3

local GameTitle = Instance.new("TextLabel", MainFrame)
GameTitle.Text                   = "Violence District"
GameTitle.Position               = UDim2.new(0, 118, 0, 16)
GameTitle.Size                   = UDim2.new(0, 160, 0, 22)
GameTitle.TextColor3             = Color3.fromRGB(140, 140, 140)
GameTitle.Font                   = "GothamMedium"
GameTitle.TextSize               = 13
GameTitle.BackgroundTransparency = 1
GameTitle.TextXAlignment         = "Left"
GameTitle.ZIndex                 = 3

-- Minimize button
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size             = UDim2.new(0, 32, 0, 32)
MinBtn.Position         = UDim2.new(1, -44, 0, 9)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinBtn.Text             = "—"
MinBtn.TextColor3       = Color3.new(1, 1, 1)
MinBtn.Font             = "GothamBold"
MinBtn.TextSize         = 16
MinBtn.BorderSizePixel  = 0
MinBtn.ZIndex           = 5
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible   = true
    SafeFire(Remote.EmoteHandler, "StopEmote")
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible   = false
end)

-- Resize handle
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size             = UDim2.new(0, 18, 0, 18)
ResizeBtn.Position         = UDim2.new(1, -22, 1, -22)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResizeBtn.Text             = "⊡"
ResizeBtn.TextColor3       = Color3.fromRGB(90, 90, 90)
ResizeBtn.TextSize         = 11
ResizeBtn.BorderSizePixel  = 0
ResizeBtn.ZIndex           = 5
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 4)

local resizing = false
ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        local startSize = MainFrame.Size
        local startPos  = input.Position
        local moveCon
        moveCon = UserInputService.InputChanged:Connect(function(mi)
            if resizing and (
                mi.UserInputType == Enum.UserInputType.MouseMovement
                or mi.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = mi.Position - startPos
                MainFrame.Size = UDim2.new(
                    0, math.max(450, startSize.X.Offset + delta.X),
                    0, math.max(300, startSize.Y.Offset + delta.Y)
                )
            end
        end)
        UserInputService.InputEnded:Connect(function()
            resizing = false
            if moveCon then moveCon:Disconnect() end
        end)
    end
end)

-- ============================================================
-- SIDEBAR & CONTAINER
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position         = UDim2.new(0, 10, 0, 55)
Sidebar.Size             = UDim2.new(0, 130, 1, -65)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 4
Instance.new("UICorner", Sidebar)
local SL = Instance.new("UIListLayout", Sidebar)
SL.Padding = UDim.new(0, 4)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

local Container = Instance.new("Frame", MainFrame)
Container.Position               = UDim2.new(0, 150, 0, 55)
Container.Size                   = UDim2.new(1, -160, 1, -65)
Container.BackgroundTransparency = 1
Container.ZIndex                 = 4

-- ============================================================
-- PAGE & TAB SYSTEM
-- ============================================================
local Pages      = {}
local TabButtons = {}

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name                       = name
    pg.Size                       = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency     = 1
    pg.Visible                    = false
    pg.ScrollBarThickness         = 3
    pg.ScrollBarImageColor3       = Color3.fromRGB(255, 140, 0)
    pg.ScrollBarImageTransparency = 0.4
    pg.BorderSizePixel            = 0
    pg.AutomaticCanvasSize        = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", pg)
    layout.Padding   = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0, 10)
    Pages[name] = pg
    return pg
end

local function AddTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size                   = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 1
    btn.Text                   = "   " .. name
    btn.TextColor3             = Color3.fromRGB(120, 120, 120)
    btn.Font                   = "GothamMedium"
    btn.TextSize               = 13
    btn.TextXAlignment         = "Left"
    btn.BorderSizePixel        = 0
    btn.ZIndex                 = 5

    local ind = Instance.new("Frame", btn)
    ind.Size             = UDim2.new(0, 3, 0, 18)
    ind.Position         = UDim2.new(0, 6, 0.5, -9)
    ind.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ind.Visible          = false
    ind.BorderSizePixel  = 0
    Instance.new("UICorner", ind)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in ipairs(TabButtons) do
            t.btn.TextColor3 = Color3.fromRGB(120, 120, 120)
            t.ind.Visible    = false
        end
        if Pages[name] then Pages[name].Visible = true end
        btn.TextColor3 = Color3.new(1, 1, 1)
        ind.Visible    = true
    end)

    table.insert(TabButtons, { btn = btn, ind = ind })
    return btn, ind
end

local SurPage = CreatePage("Survivor")
local KilPage = CreatePage("Killer")
local EspPage = CreatePage("Esp")
local PlrPage = CreatePage("Player")
local SetPage = CreatePage("Settings")

local surBtn, surInd = AddTab("Survivor")
AddTab("Killer"); AddTab("Esp"); AddTab("Player"); AddTab("Settings")

SurPage.Visible   = true
surBtn.TextColor3 = Color3.new(1, 1, 1)
surInd.Visible    = true

-- ============================================================
-- UI HELPER: SECTION HEADER
-- ============================================================
local function SectionHeader(parent, text, order)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text                   = text
    lbl.Size                   = UDim2.new(1, -10, 0, 28)
    lbl.TextColor3             = Color3.fromRGB(255, 140, 0)
    lbl.Font                   = "GothamBold"
    lbl.TextSize               = 13
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment         = "Left"
    lbl.LayoutOrder            = order
    return lbl
end

-- ============================================================
-- UI HELPER: TOGGLE
-- ============================================================
local function CreateToggle(parent, labelText, defaultState, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, -10, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order
    Instance.new("UICorner", row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text                   = "  " .. labelText
    lbl.Size                   = UDim2.new(1, -62, 1, 0)
    lbl.TextColor3             = Color3.new(1, 1, 1)
    lbl.Font                   = "GothamMedium"
    lbl.TextSize               = 13
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment         = "Left"

    local track = Instance.new("TextButton", row)
    track.Size             = UDim2.new(0, 46, 0, 24)
    track.Position         = UDim2.new(1, -56, 0.5, -12)
    track.BackgroundColor3 = defaultState
        and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 50, 50)
    track.Text             = ""
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size             = UDim2.new(0, 18, 0, 18)
    knob.Position         = defaultState
        and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = defaultState
    track.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(track, TweenInfo.new(0.18), {
            BackgroundColor3 = on
                and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 50, 50)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18), {
            Position = on
                and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        callback(on)
    end)
    return row
end

-- ============================================================
-- UI HELPER: DROPDOWN FITUR
-- ============================================================
local function AddDropdownFeature(parent, title, options_table, order)
    local frame = Instance.new("TextButton", parent)
    frame.Size             = UDim2.new(1, -10, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Text             = ""
    frame.BorderSizePixel  = 0
    frame.LayoutOrder      = order
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Text                   = "  " .. title
    label.Size                   = UDim2.new(1, -38, 1, 0)
    label.TextColor3             = Color3.new(1, 1, 1)
    label.Font                   = "GothamMedium"
    label.TextSize               = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment         = "Left"

    local arrow = Instance.new("TextLabel", frame)
    arrow.Text                   = "▼  "
    arrow.Size                   = UDim2.new(0, 32, 1, 0)
    arrow.Position               = UDim2.new(1, -32, 0, 0)
    arrow.TextColor3             = Color3.fromRGB(255, 140, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextXAlignment         = "Right"
    arrow.Font                   = "GothamBold"
    arrow.TextSize               = 13

    local isOpen    = false
    local listFrame = Instance.new("Frame", parent)
    listFrame.Size             = UDim2.new(1, -10, 0, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    listFrame.ClipsDescendants = true
    listFrame.BorderSizePixel  = 0
    listFrame.LayoutOrder      = order + 1
    Instance.new("UICorner", listFrame)

    local ll = Instance.new("UIListLayout", listFrame)
    ll.Padding = UDim.new(0, 2)
    Instance.new("UIPadding", listFrame).PaddingTop = UDim.new(0, 4)

    for _, opt in ipairs(options_table) do
        local b = Instance.new("TextButton", listFrame)
        b.Size             = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        b.Text             = "  " .. opt.Name
        b.TextColor3       = Color3.fromRGB(175, 175, 175)
        b.Font             = "Gotham"
        b.TextSize         = 12
        b.TextXAlignment   = "Left"
        b.BorderSizePixel  = 0

        local stateOn = false
        b.MouseButton1Click:Connect(function()
            stateOn = not stateOn
            TweenService:Create(b, TweenInfo.new(0.12), {
                BackgroundColor3 = stateOn
                    and Color3.fromRGB(55, 38, 10) or Color3.fromRGB(33, 33, 33)
            }):Play()
            b.TextColor3 = stateOn
                and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(175, 175, 175)
            opt.Callback(stateOn)
        end)
    end

    local fullH = (#options_table * 36) + 8
    frame.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Size = isOpen
                and UDim2.new(1, -10, 0, fullH) or UDim2.new(1, -10, 0, 0)
        }):Play()
        arrow.Text = isOpen and "▲  " or "▼  "
    end)
    return frame, listFrame
end

-- ============================================================
-- UI HELPER: SETTING CHIPS
-- ============================================================
local function CreateSettingDropdown(parent, title, icon, options_list, onSelect, order)
    local baseOrder = order * 10

    local titleRow = Instance.new("Frame", parent)
    titleRow.Size                   = UDim2.new(1, -10, 0, 22)
    titleRow.BackgroundTransparency = 1
    titleRow.LayoutOrder            = baseOrder

    local tLbl = Instance.new("TextLabel", titleRow)
    tLbl.Text                   = icon .. "  " .. title
    tLbl.Size                   = UDim2.new(1, 0, 1, 0)
    tLbl.TextColor3             = Color3.fromRGB(180, 180, 180)
    tLbl.Font                   = "GothamMedium"
    tLbl.TextSize               = 12
    tLbl.BackgroundTransparency = 1
    tLbl.TextXAlignment         = "Left"

    local optRow = Instance.new("Frame", parent)
    optRow.Size                   = UDim2.new(1, -10, 0, 36)
    optRow.BackgroundTransparency = 1
    optRow.LayoutOrder            = baseOrder + 5
    local optL = Instance.new("UIListLayout", optRow)
    optL.FillDirection = Enum.FillDirection.Horizontal
    optL.Padding       = UDim.new(0, 6)
    optL.SortOrder     = Enum.SortOrder.LayoutOrder

    local btnList = {}
    for i, opt in ipairs(options_list) do
        local b = Instance.new("TextButton", optRow)
        b.Size             = UDim2.new(0, 80, 1, 0)
        b.BackgroundColor3 = opt.default
            and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(30, 30, 30)
        b.Text             = opt.label
        b.TextColor3       = opt.default
            and Color3.new(1, 1, 1) or Color3.fromRGB(155, 155, 155)
        b.Font             = "GothamMedium"
        b.TextSize         = 12
        b.BorderSizePixel  = 0
        b.LayoutOrder      = i
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

        b.MouseButton1Click:Connect(function()
            for _, tb in ipairs(btnList) do
                TweenService:Create(tb, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play()
                tb.TextColor3 = Color3.fromRGB(155, 155, 155)
            end
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            }):Play()
            b.TextColor3 = Color3.new(1, 1, 1)
            onSelect(opt.value)
        end)
        table.insert(btnList, b)
    end

    local div = Instance.new("Frame", parent)
    div.Size             = UDim2.new(1, -10, 0, 1)
    div.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    div.BorderSizePixel  = 0
    div.LayoutOrder      = baseOrder + 9
    return optRow
end

-- ============================================================
-- ESP SYSTEM
-- ============================================================
local function RemoveESP(player)
    if ESPObjects[player] then
        local objs = ESPObjects[player]
        if objs[1] and objs[1].Parent then objs[1]:Destroy() end
        if objs[2] and objs[2].Parent then objs[2]:Destroy() end
        if objs[3] then objs[3]:Disconnect() end
        ESPObjects[player] = nil
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    RemoveESP(player)

    local function applyToChar(char)
        if not char then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local hl = Instance.new("Highlight")
        hl.Name                = "VD_ESP_HL"
        hl.FillColor           = Color3.fromRGB(0, 100, 255)
        hl.FillTransparency    = 0.55
        hl.OutlineColor        = Color3.fromRGB(80, 160, 255)
        hl.OutlineTransparency = 0
        hl.Adornee             = char
        hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled             = States.EspEnabled
        hl.Parent              = char

        local bb = Instance.new("BillboardGui")
        bb.Name        = "VD_ESP_BB"
        bb.Size        = UDim2.new(0, 130, 0, 55)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 500
        bb.Enabled     = States.EspEnabled
        bb.Parent      = hrp

        local nameLbl = Instance.new("TextLabel", bb)
        nameLbl.Text                   = player.Name
        nameLbl.Size                   = UDim2.new(1, 0, 0, 18)
        nameLbl.Position               = UDim2.new(0, 0, 0, 0)
        nameLbl.TextColor3             = Color3.fromRGB(80, 180, 255)
        nameLbl.Font                   = "GothamBold"
        nameLbl.TextSize               = 13
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextStrokeTransparency = 0
        nameLbl.TextStrokeColor3       = Color3.new(0, 0, 0)

        local hpLbl = Instance.new("TextLabel", bb)
        hpLbl.Text                   = "[ 100 HP ]"
        hpLbl.Size                   = UDim2.new(1, 0, 0, 16)
        hpLbl.Position               = UDim2.new(0, 0, 0, 19)
        hpLbl.TextColor3             = Color3.fromRGB(255, 80, 80)
        hpLbl.Font                   = "GothamBold"
        hpLbl.TextSize               = 12
        hpLbl.BackgroundTransparency = 1
        hpLbl.TextStrokeTransparency = 0
        hpLbl.TextStrokeColor3       = Color3.new(0, 0, 0)

        local distLbl = Instance.new("TextLabel", bb)
        distLbl.Text                   = "[ 0 MM ]"
        distLbl.Size                   = UDim2.new(1, 0, 0, 14)
        distLbl.Position               = UDim2.new(0, 0, 0, 36)
        distLbl.TextColor3             = Color3.fromRGB(200, 200, 200)
        distLbl.Font                   = "Gotham"
        distLbl.TextSize               = 11
        distLbl.BackgroundTransparency = 1
        distLbl.TextStrokeTransparency = 0
        distLbl.TextStrokeColor3       = Color3.new(0, 0, 0)

        local conn = RunService.Heartbeat:Connect(function()
            if not States.EspEnabled then
                hl.Enabled = false; bb.Enabled = false; return
            end
            hl.Enabled = true; bb.Enabled = true
            if hum and hum.Parent then
                hpLbl.Text = "[ " .. math.floor(hum.Health) .. " HP ]"
            end
            local myHRP = LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent and myHRP then
                local dist = math.floor((hrp.Position - myHRP.Position).Magnitude)
                distLbl.Text = "[ " .. dist .. " MM ]"
            end
        end)

        ESPObjects[player] = { hl, bb, conn }
        char.AncestryChanged:Connect(function() RemoveESP(player) end)
    end

    applyToChar(player.Character)
    player.CharacterAdded:Connect(applyToChar)
end

local function ToggleESP(state)
    States.EspEnabled = state
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then CreateESP(plr) end
        end
    else
        for plr in pairs(ESPObjects) do RemoveESP(plr) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if States.EspEnabled then CreateESP(plr) end
end)
Players.PlayerRemoving:Connect(function(plr) RemoveESP(plr) end)

-- ============================================================
-- DIRECTION LOCK / MOONWALK
-- ============================================================
local DirLockFrame = Instance.new("Frame", ScreenGui)
DirLockFrame.Name                   = "DirLockFrame"
DirLockFrame.Size                   = UDim2.new(0, 110, 0, 110)
DirLockFrame.Position               = UDim2.new(1, -130, 0.5, -55)
DirLockFrame.BackgroundTransparency = 1
DirLockFrame.Visible                = false
DirLockFrame.ZIndex                 = 8
MakeDraggable(DirLockFrame, DirLockFrame)

local function MakeArrowBtn(symbol, posX, posY)
    local btn = Instance.new("TextButton", DirLockFrame)
    btn.Size                   = UDim2.new(0, 38, 0, 38)
    btn.Position               = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.25
    btn.Text                   = symbol
    btn.TextColor3             = Color3.new(1, 1, 1)
    btn.Font                   = "GothamBold"
    btn.TextSize               = 20
    btn.BorderSizePixel        = 0
    btn.ZIndex                 = 9
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local ArrowUp    = MakeArrowBtn("▲", 36, 0)
local ArrowDown  = MakeArrowBtn("▼", 36, 72)
local ArrowLeft  = MakeArrowBtn("◄", 0, 36)
local ArrowRight = MakeArrowBtn("►", 72, 36)

local ArrowCenter = Instance.new("TextButton", DirLockFrame)
ArrowCenter.Size                   = UDim2.new(0, 28, 0, 28)
ArrowCenter.Position               = UDim2.new(0, 41, 0, 41)
ArrowCenter.BackgroundColor3       = Color3.fromRGB(255, 140, 0)
ArrowCenter.BackgroundTransparency = 0.3
ArrowCenter.Text                   = "✕"
ArrowCenter.TextColor3             = Color3.new(1, 1, 1)
ArrowCenter.Font                   = "GothamBold"
ArrowCenter.TextSize               = 14
ArrowCenter.BorderSizePixel        = 0
ArrowCenter.ZIndex                 = 9
Instance.new("UICorner", ArrowCenter).CornerRadius = UDim.new(1, 0)

local function SetLockedDir(vec)
    LockedLookVector = vec
    for _, btn in ipairs({ArrowUp, ArrowDown, ArrowLeft, ArrowRight}) do
        btn.BackgroundTransparency = 0.25
        btn.TextColor3             = Color3.new(1, 1, 1)
    end
end

ArrowUp.MouseButton1Click:Connect(function()
    local cf = Camera.CFrame.LookVector
    SetLockedDir(Vector3.new(cf.X, 0, cf.Z).Unit)
    ArrowUp.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ArrowUp.BackgroundTransparency = 0
end)
ArrowDown.MouseButton1Click:Connect(function()
    local cf = Camera.CFrame.LookVector
    SetLockedDir(-Vector3.new(cf.X, 0, cf.Z).Unit)
    ArrowDown.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ArrowDown.BackgroundTransparency = 0
end)
ArrowLeft.MouseButton1Click:Connect(function()
    local rv = Camera.CFrame.RightVector
    SetLockedDir(-Vector3.new(rv.X, 0, rv.Z).Unit)
    ArrowLeft.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ArrowLeft.BackgroundTransparency = 0
end)
ArrowRight.MouseButton1Click:Connect(function()
    local rv = Camera.CFrame.RightVector
    SetLockedDir(Vector3.new(rv.X, 0, rv.Z).Unit)
    ArrowRight.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ArrowRight.BackgroundTransparency = 0
end)
ArrowCenter.MouseButton1Click:Connect(function()
    LockedLookVector = nil
    for _, btn in ipairs({ArrowUp, ArrowDown, ArrowLeft, ArrowRight}) do
        btn.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.25
    end
end)

-- ============================================================
-- GET GENERATORS (multi-path fallback)
-- ============================================================
local function GetGenerators()
    local list = {}
    local candidates = {
        Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Generator"),
        Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Generators"),
        Workspace:FindFirstChild("Generator"),
        Workspace:FindFirstChild("Generators"),
    }
    for _, folder in ipairs(candidates) do
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child.Name:lower():find("generator") or child.Name:lower():find("genpoint") then
                    table.insert(list, child)
                end
            end
            if #list > 0 then break end
        end
    end
    return list
end

-- ============================================================
-- MAIN HEARTBEAT LOOP
-- ============================================================
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    for key, _ in pairs(Timers) do
        if type(Timers[key]) == "number" and not key:find("CD_") then
            Timers[key] = Timers[key] + dt
        end
    end

    if States.AutoHeal and hum and hum.Health < hum.MaxHealth
        and Timers.heal >= Timers.CD_heal then
        Timers.heal = 0
        SafeFire(Remote.HealReset, LocalPlayer)
    end

    if States.NoStamina and hum then
        for _, vname in ipairs({"Stamina","stamina","SP","StaminaValue"}) do
            local val = char:FindFirstChild(vname) or hum:FindFirstChild(vname)
            if val and val:IsA("NumberValue") then val.Value = 100 end
        end
    end

    if States.DirLockActive and LockedLookVector and hrp then
        if hum then hum.AutoRotate = false end
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos, pos + LockedLookVector)
    elseif not States.DirLockActive and hum then
        hum.AutoRotate = true
    end

    if States.AntiChase and hrp and Timers.chase >= Timers.CD_chase then
        Timers.chase = 0
        SafeFire(Remote.Chase, char, false)
    end

    if States.FastAttack and Timers.attack >= Timers.CD_attack then
        Timers.attack = 0
        SafeFire(Remote.BasicAttack, false)
    end

    if States.AutoLunge and Timers.lunge >= Timers.CD_lunge then
        Timers.lunge = 0
        SafeFire(Remote.Lunge, false)
    end

    if (States.AutoGenerator or States.FastGen)
        and Timers.repair >= Timers.CD_repair and hrp then
        Timers.repair = 0
        pcall(function()
            local gens = GetGenerators()
            for _, gen in ipairs(gens) do
                local genPos = gen:IsA("Model")
                    and (gen.PrimaryPart and gen.PrimaryPart.Position or gen:GetPivot().Position)
                    or gen.Position
                local dist = (genPos - hrp.Position).Magnitude
                if dist <= 10 then
                    if States.FastGen then
                        SafeFire(Remote.RepairEvent, gen, false, 1.5)
                    else
                        SafeFire(Remote.RepairEvent, gen, false)
                    end
                end
            end
        end)
    end

    if States.FastVault and Timers.vault >= Timers.CD_vault then
        Timers.vault = 0
        SafeFire(Remote.FastVault, LocalPlayer)
    end

    if States.AutoRepair and Timers.object >= Timers.CD_object then
        Timers.object = 0
        SafeFire(Remote.EnableCollision)
    end
end)

-- ============================================================
-- SURVIVOR PAGE
-- ============================================================
SectionHeader(SurPage, "⚡  Survivor", 10)

AddDropdownFeature(SurPage, "⚙️  Generator Rush", {
    { Name = "Auto Generator Rush",       Callback = function(s) States.AutoGenerator = s end },
    { Name = "Fast Generator (Speed 1.5x)", Callback = function(s) States.FastGen = s end },
}, 20)

AddDropdownFeature(SurPage, "🔧  Auto Lever", {
    { Name = "Auto Lever  [Butuh Remote Lever]", Callback = function(s) States.AutoLever = s end },
    { Name = "Fast Lever  [Butuh Remote Lever]", Callback = function(s) end },
}, 40)

AddDropdownFeature(SurPage, "💊  Heal", {
    { Name = "Auto Heal Self",                    Callback = function(s) States.AutoHeal = s end },
    { Name = "Auto Heal Others  [Butuh Remote]",  Callback = function(s) end },
}, 60)

AddDropdownFeature(SurPage, "🏃  Movement", {
    { Name = "Fast Vault",    Callback = function(s) States.FastVault = s end },
    { Name = "No Cooldown",   Callback = function(s) States.NoCD = s end },
    { Name = "Direction Lock (Moonwalk)", Callback = function(s)
        States.DirLockActive = s
        DirLockFrame.Visible = s
        if not s then
            LockedLookVector = nil
            local c = LocalPlayer.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h.AutoRotate = true end
            end
        end
    end },
    { Name = "Anti Chase",    Callback = function(s) States.AntiChase = s end },
}, 80)

AddDropdownFeature(SurPage, "🛠️  Repair", {
    { Name = "Auto Repair Objects", Callback = function(s) States.AutoRepair = s end },
}, 100)

-- ============================================================
-- KILLER PAGE
-- ============================================================
SectionHeader(KilPage, "🔪  Killer", 10)

AddDropdownFeature(KilPage, "⚔️  Attack", {
    { Name = "Fast Attack",               Callback = function(s) States.FastAttack = s end },
    { Name = "Auto Lunge",                Callback = function(s) States.AutoLunge = s end },
    { Name = "Power Deactivate (1x fire)", Callback = function(s)
        if s then SafeFire(Remote.PowerDeact) end
    end },
}, 20)

AddDropdownFeature(KilPage, "👁️  Tracking", {
    { Name = "Survivor Aura  [Butuh Remote]",   Callback = function(s) end },
    { Name = "Snap Target (Beta)  [Butuh Remote]", Callback = function(s) end },
}, 40)

-- ============================================================
-- ESP PAGE
-- ============================================================
SectionHeader(EspPage, "👁️  ESP / Wallhack", 10)

CreateToggle(EspPage, "Enable ESP (Highlight + Info)", false, function(s)
    ToggleESP(s)
end, 20)

CreateToggle(EspPage, "Show Teammate Only", false, function(s) end, 30)
CreateToggle(EspPage, "Show Killer Only",   false, function(s) end, 40)

AddDropdownFeature(EspPage, "🎨  ESP Warna", {
    { Name = "Biru (Survivor default)", Callback = function(s) end },
    { Name = "Merah (Killer)",          Callback = function(s) end },
    { Name = "Hijau (Semua)",           Callback = function(s) end },
}, 60)

-- ============================================================
-- PLAYER PAGE
-- ============================================================
SectionHeader(PlrPage, "🧑  Player", 10)

CreateToggle(PlrPage, "No Stamina (Full Stamina)", false, function(s)
    States.NoStamina = s
end, 20)

CreateToggle(PlrPage, "Anti Stun      [Butuh Remote]", false, function(s) end, 30)
CreateToggle(PlrPage, "No Fall Damage [Butuh Remote]", false, function(s) end, 40)
CreateToggle(PlrPage, "Speed Boost    [Butuh Remote]", false, function(s) end, 50)

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
SectionHeader(SetPage, "⚙️  UI Settings", 10)

CreateSettingDropdown(SetPage, "Icon Size", "📐", {
    { label = "Small",  value = "small",  default = false },
    { label = "Medium", value = "medium", default = true  },
    { label = "Large",  value = "large",  default = false },
}, function(v)
    local sizes = { small = 35, medium = 55, large = 80 }
    TweenService:Create(OpenBtn, TweenInfo.new(0.2),
        { Size = UDim2.new(0, sizes[v], 0, sizes[v]) }):Play()
end, 2)

CreateSettingDropdown(SetPage, "Icon Shape", "🔷", {
    { label = "Circle",  value = "circle",  default = true  },
    { label = "Square",  value = "square",  default = false },
    { label = "Rounded", value = "rounded", default = false },
}, function(v)
    local r = { circle = UDim.new(1, 0), square = UDim.new(0, 0), rounded = UDim.new(0, 12) }
    LogoCorner.CornerRadius = r[v]
end, 4)

CreateSettingDropdown(SetPage, "Icon Color", "🎨", {
    { label = "Dark",   value = "dark",   default = true  },
    { label = "Orange", value = "orange", default = false },
    { label = "Purple", value = "purple", default = false },
    { label = "Blue",   value = "blue",   default = false },
}, function(v)
    local c = {
        dark   = Color3.fromRGB(30, 30, 30),
        orange = Color3.fromRGB(200, 90, 0),
        purple = Color3.fromRGB(120, 0, 200),
        blue   = Color3.fromRGB(0, 100, 220),
    }
    TweenService:Create(OpenBtn, TweenInfo.new(0.2), { BackgroundColor3 = c[v] }):Play()
end, 6)

CreateSettingDropdown(SetPage, "Accent Color", "✨", {
    { label = "Orange", value = "orange", default = true  },
    { label = "Cyan",   value = "cyan",   default = false },
    { label = "Green",  value = "green",  default = false },
}, function(v)
    local c = {
        orange = Color3.fromRGB(255, 140, 0),
        cyan   = Color3.fromRGB(0, 200, 230),
        green  = Color3.fromRGB(50, 200, 80),
    }
    TopGrip.BackgroundColor3 = c[v]
end, 8)

-- ============================================================
-- WATERMARK
-- ============================================================
local WaterMark = Instance.new("Frame", ScreenGui)
WaterMark.Size                   = UDim2.new(0, 220, 0, 26)
WaterMark.Position               = UDim2.new(0, 10, 1, -36)
WaterMark.BackgroundColor3       = Color3.fromRGB(18, 18, 18)
WaterMark.BackgroundTransparency = 0.25
WaterMark.BorderSizePixel        = 0
WaterMark.ZIndex                 = 5
Instance.new("UICorner", WaterMark).CornerRadius = UDim.new(0, 7)

local WaterText = Instance.new("TextLabel", WaterMark)
WaterText.Text                   = " 🪐 Lynxx VD v6.2 + SC  |  Saycho"
WaterText.Size                   = UDim2.new(1, 0, 1, 0)
WaterText.TextColor3             = Color3.fromRGB(255, 140, 0)
WaterText.Font                   = "GothamBold"
WaterText.TextSize               = 11
WaterText.BackgroundTransparency = 1
WaterText.TextXAlignment         = "Left"
WaterText.ZIndex                 = 6

-- ============================================================
-- SKILL CHECK AUTO (INTEGRATED)
-- FIX: pakai ChildAdded, tidak hang
-- ============================================================
local SC_HeartbeatConn = nil

local function SC_PressSpace()
    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Space, false, game)
    task.wait(0.01)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function SC_LineInGoal(Line, Goal)
    local lr = Line.Rotation % 360
    local gr = Goal.Rotation % 360
    local gs = (gr + 104) % 360
    local ge = (gr + 114) % 360
    if gs > ge then
        return lr >= gs or lr <= ge
    else
        return lr >= gs and lr <= ge
    end
end

local function SC_MakeHeartbeat(Line, Goal)
    return function()
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors" then
            if SC_LineInGoal(Line, Goal) then
                SC_PressSpace()
                if SC_HeartbeatConn then
                    SC_HeartbeatConn:Disconnect()
                    SC_HeartbeatConn = nil
                end
            end
        else
            if SC_HeartbeatConn then
                SC_HeartbeatConn:Disconnect()
                SC_HeartbeatConn = nil
            end
        end
    end
end

local function SC_OnCheckVisible(Check, Line, Goal)
    if LocalPlayer.Team and LocalPlayer.Team.Name ~= "Survivors" then
        if SC_HeartbeatConn then SC_HeartbeatConn:Disconnect(); SC_HeartbeatConn = nil end
        return
    end
    if Check.Visible then
        if SC_HeartbeatConn then SC_HeartbeatConn:Disconnect() end
        SC_HeartbeatConn = RunService.Heartbeat:Connect(SC_MakeHeartbeat(Line, Goal))
    else
        if SC_HeartbeatConn then SC_HeartbeatConn:Disconnect(); SC_HeartbeatConn = nil end
    end
end

local function SC_Setup(CheckGui)
    local Check = CheckGui:WaitForChild("Check", 10)
    if not Check then
        warn("[SkillCheck] 'Check' tidak ditemukan"); return
    end
    local Line = Check:WaitForChild("Line", 10)
    local Goal = Check:WaitForChild("Goal", 10)
    if not Line or not Goal then
        warn("[SkillCheck] 'Line'/'Goal' tidak ditemukan"); return
    end
    Check:GetPropertyChangedSignal("Visible"):Connect(function()
        SC_OnCheckVisible(Check, Line, Goal)
    end)
    print("[SkillCheck] ✅ Ready!")
end

-- Cek kalau GUI sudah ada
local existingSC = PlayerGui:FindFirstChild("SkillCheckPromptGui")
if existingSC then
    task.spawn(SC_Setup, existingSC)
end

-- Tunggu kalau belum ada
PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "SkillCheckPromptGui" then
        task.spawn(SC_Setup, child)
    end
end)

-- ============================================================
print("✅ VD v6.2 + SkillCheck Loaded | By Saycho")
print("   Semua tombol: MouseButton1Click | SkillCheck: ChildAdded listener")
