--[[
  VD (Violence District) — PLATINUM
  Version : 12.0
  Author  : Saycho
  Fixed   : MouseButton1Click → Activated (Delta/mobile fix)
  Added   : Auto Gen (SkillCheck), Invisibility, Gate/Hook/Window ESP,
            Mobile Detection, FPS Counter UI, Auto Leave Generator,
            Mobile Performance Optimizer
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui         = game:GetService("CoreGui")
local Players         = game:GetService("Players")
local UIS             = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local WS              = game:GetService("Workspace")
local Lighting        = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local RS              = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera      = WS.CurrentCamera

-- ============================================================
-- MOBILE DETECTION
-- ============================================================
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ============================================================
-- REMOTE SHORTCUTS (dari RemoteSpy)
-- ============================================================
local Remotes = RS:WaitForChild("Remotes", 10)
local function safeRemote(...)
    local path = {...}
    local ok, result = pcall(function()
        local node = Remotes
        for _, name in ipairs(path) do
            node = node:WaitForChild(name, 5)
        end
        return node
    end)
    return ok and result or nil
end

local R_RepairEvent    = safeRemote("Generator", "RepairEvent")
local R_SkillCheck     = safeRemote("Generator", "SkillCheckResultEvent")
local R_FastVault      = safeRemote("Window", "fastvault")
local R_HealReset      = safeRemote("Healing", "Reset")
local R_BasicAttack    = safeRemote("Attacks", "BasicAttack")
local R_Lunge          = safeRemote("Attacks", "Lunge")
local R_PowerDone      = safeRemote("Killers", "Killer", "PowerDoneDeactivating")
local R_EnableCollision= safeRemote("Collision", "EnableCollision")
local R_Chase          = safeRemote("Chase", "Runevent")
local R_UpdateLook     = safeRemote("Game", "UpdateCharacterLook")

-- ============================================================
-- PLAYERGUI FALLBACK
-- ============================================================
local function getPlayerGui()
    local ok, res = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 8) end)
    return (ok and res) or CoreGui
end
local PlayerGui = getPlayerGui()

-- ============================================================
-- CLEANUP
-- ============================================================
for _, p in ipairs({CoreGui, PlayerGui}) do
    for _, n in ipairs({"VD_Saycho_Official", "VD_Crosshair", "VD_FPS"}) do
        local old = p:FindFirstChild(n); if old then old:Destroy() end
    end
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local ScreenGui
pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "VD_Saycho_Official"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.DisplayOrder = 999
    sg.Parent = CoreGui; ScreenGui = sg
end)
if not ScreenGui or not ScreenGui.Parent then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VD_Saycho_Official"; ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui
end

-- ============================================================
-- STATES
-- ============================================================
local States = {
    -- ESP
    EspSurvivor = false, EspKiller = false, EspGenerator = false,
    PalletEsp = false, GateEsp = false, HookEsp = false, WindowEsp = false,
    EspName = true, EspHP = true, EspDist = true, EspBox = true,
    EspHeadDot = false, EspTracer = false, RainbowESP = false,
    -- Aimbot
    Aimbot = false, AimbotTeam = true, AimbotBone = "body", AimbotFOV = 100,
    -- Player
    WalkSpeedOn = false, WalkSpeed = 60, JumpPower = 50,
    NoClip = false, GodMode = false, FlyMode = false, InfJump = false,
    AntiKnock = false, Invisible = false,
    -- Survivor (Remote-based)
    AutoGenerator = false, AutoLeaveGen = false, LeaveDistance = 15,
    FastVaultAuto = false, AutoHealReset = false, AntiChase = false,
    -- Killer (Remote-based)
    AutoAttack = false, AutoLunge = false, PowerSkip = false,
    -- Visual
    FullBright = false, NoFog = false, Crosshair = false, Chams = false,
    -- Utility
    AntiAFK = false, FPSBoost = false, FPSCounter = false,
}

-- ============================================================
-- PALETTE
-- ============================================================
local C = {
    BG        = Color3.fromRGB(13,  13,  13),
    PANEL     = Color3.fromRGB(20,  20,  20),
    CARD      = Color3.fromRGB(26,  26,  26),
    CARD2     = Color3.fromRGB(32,  32,  32),
    ACCENT    = Color3.fromRGB(232, 137,  12),
    ACCENT_DIM= Color3.fromRGB( 80,  45,   5),
    SURVIVOR  = Color3.fromRGB( 72, 200,  90),
    KILLER    = Color3.fromRGB(210,  48,  48),
    GEN_A     = Color3.fromRGB(230, 190,  30),
    GEN_B     = Color3.fromRGB( 40, 200,  80),
    PALLET    = Color3.fromRGB(150,  80, 220),
    GATE      = Color3.fromRGB( 40, 160, 255),
    HOOK      = Color3.fromRGB(220, 100,  30),
    WINDOW    = Color3.fromRGB(100, 220, 200),
    TEXT_A    = Color3.fromRGB(240, 240, 240),
    TEXT_B    = Color3.fromRGB(140, 140, 140),
    TEXT_C    = Color3.fromRGB( 70,  70,  70),
    DIV       = Color3.fromRGB( 36,  36,  36),
    OFF       = Color3.fromRGB( 50,  50,  50),
}

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), props):Play()
end

-- ============================================================
-- ROLE DETECTION
-- ============================================================
local function getRole(pl)
    if pl and pl.Team then
        local n = pl.Team.Name:lower()
        if n:find("killer") or n:find("maniac") then return "Killer" end
    end
    return "Survivor"
end

-- ============================================================
-- DRAG ENGINE
-- ============================================================
local function MakeDraggable(obj, handle)
    local drag, ds, sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag=true; ds=i.Position; sp=obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then drag=false end
    end)
end

-- ============================================================
-- FLOATING ICON
-- ============================================================
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name             = "VD_FloatBtn"
OpenBtn.Size             = UDim2.new(0, 48, 0, 48)
OpenBtn.Position         = UDim2.new(0, 18, 0.5, -24)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
OpenBtn.Image            = "rbxassetid://15125301131"
OpenBtn.Visible          = false; OpenBtn.ZIndex = 20
local _oc = Instance.new("UICorner", OpenBtn); _oc.CornerRadius = UDim.new(1, 0)
local _os = Instance.new("UIStroke", OpenBtn)
_os.Color = C.ACCENT; _os.Thickness = 1.5; _os.Transparency = 0.4
MakeDraggable(OpenBtn, OpenBtn)

-- ============================================================
-- MAIN FRAME
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name             = "VD_Main"
MainFrame.BackgroundColor3 = C.BG
MainFrame.Size             = UDim2.new(0, 560, 0, 370)
MainFrame.Position         = UDim2.new(0.5, -280, 0.5, -185)
MainFrame.BorderSizePixel  = 0; MainFrame.ClipsDescendants = false
local _mc = Instance.new("UICorner", MainFrame); _mc.CornerRadius = UDim.new(0, 12)
local _ms = Instance.new("UIStroke", MainFrame); _ms.Color = C.DIV; _ms.Thickness = 1

-- Drag bar (full width, easy grab on mobile)
local DragBar = Instance.new("TextButton", MainFrame)
DragBar.Size = UDim2.new(1, -45, 0, 46); DragBar.BackgroundTransparency = 1
DragBar.Text = ""; DragBar.ZIndex = 2
MakeDraggable(MainFrame, DragBar)

local GripDot = Instance.new("Frame", DragBar)
GripDot.Size = UDim2.new(0, 32, 0, 3); GripDot.Position = UDim2.new(0.5, -16, 0, 8)
GripDot.BackgroundColor3 = C.DIV; GripDot.BorderSizePixel = 0
Instance.new("UICorner", GripDot).CornerRadius = UDim.new(1, 0)

local TitleLabel = Instance.new("TextLabel", DragBar)
TitleLabel.Text = "LYNXX"; TitleLabel.Position = UDim2.new(0, 16, 0, 14)
TitleLabel.Size = UDim2.new(0, 60, 0, 20); TitleLabel.TextColor3 = C.ACCENT
TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.TextSize = 15; TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubLabel = Instance.new("TextLabel", DragBar)
SubLabel.Text = "Violence District"; SubLabel.Position = UDim2.new(0, 82, 0, 16)
SubLabel.Size = UDim2.new(0, 130, 0, 16); SubLabel.TextColor3 = C.TEXT_C
SubLabel.Font = Enum.Font.Gotham; SubLabel.TextSize = 11; SubLabel.BackgroundTransparency = 1
SubLabel.TextXAlignment = Enum.TextXAlignment.Left

local VerLabel = Instance.new("TextLabel", DragBar)
VerLabel.Text = "v12.1"; VerLabel.Position = UDim2.new(1, -70, 0, 16)
VerLabel.Size = UDim2.new(0, 60, 0, 16); VerLabel.TextColor3 = C.TEXT_C
VerLabel.Font = Enum.Font.Gotham; VerLabel.TextSize = 11; VerLabel.BackgroundTransparency = 1
VerLabel.TextXAlignment = Enum.TextXAlignment.Right

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 28, 0, 28); MinBtn.Position = UDim2.new(1, -40, 0, 9)
MinBtn.BackgroundColor3 = C.CARD; MinBtn.Text = "—"; MinBtn.TextColor3 = C.TEXT_B
MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14; MinBtn.BorderSizePixel = 0; MinBtn.ZIndex = 5
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)

local HDiv = Instance.new("Frame", MainFrame)
HDiv.Size = UDim2.new(1, 0, 0, 1); HDiv.Position = UDim2.new(0, 0, 0, 46)
HDiv.BackgroundColor3 = C.DIV; HDiv.BorderSizePixel = 0

-- ✅ FIX: Minimize menyembunyikan SEMUA elemen (termasuk watermark)
local function minimizeAll()
    MainFrame.Visible = false
    OpenBtn.Visible   = true
    if WaterFrame then WaterFrame.Visible = false end
end
local function openAll()
    MainFrame.Visible = true
    OpenBtn.Visible   = false
    if WaterFrame then WaterFrame.Visible = true end
end
MinBtn.Activated:Connect(minimizeAll)
OpenBtn.Activated:Connect(openAll)

-- Resize corner
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0, 14, 0, 14); ResizeBtn.Position = UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundColor3 = C.CARD2; ResizeBtn.Text = ""; ResizeBtn.BorderSizePixel = 0
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 4)
do
    local rs = false
    ResizeBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            rs = true; local ss = MainFrame.Size; local sp2 = i.Position; local mc2
            mc2 = UIS.InputChanged:Connect(function(mi)
                if rs and (mi.UserInputType == Enum.UserInputType.MouseMovement or mi.UserInputType == Enum.UserInputType.Touch) then
                    local d = mi.Position - sp2
                    MainFrame.Size = UDim2.new(0, math.max(480, ss.X.Offset+d.X), 0, math.max(330, ss.Y.Offset+d.Y))
                end
            end)
            UIS.InputEnded:Connect(function() rs=false; if mc2 then mc2:Disconnect() end end)
        end
    end)
end

-- ============================================================
-- SIDEBAR
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 8, 0, 54); Sidebar.Size = UDim2.new(0, 120, 1, -62)
Sidebar.BackgroundColor3 = C.PANEL; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 2); SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop = UDim.new(0, 6); SidePad.PaddingLeft = UDim.new(0, 6); SidePad.PaddingRight = UDim.new(0, 6)

local SDiv = Instance.new("Frame", MainFrame)
SDiv.Size = UDim2.new(0, 1, 1, -70); SDiv.Position = UDim2.new(0, 136, 0, 54)
SDiv.BackgroundColor3 = C.DIV; SDiv.BorderSizePixel = 0

local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0, 144, 0, 52); Container.Size = UDim2.new(1, -152, 1, -60)
Container.BackgroundTransparency = 1

-- ============================================================
-- PAGE & TAB SYSTEM
-- ============================================================
local Pages = {}; local TabBtns = {}; local ActivePage = nil

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name = name; pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
    pg.Visible = false; pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = C.ACCENT
    pg.ScrollBarImageTransparency = 0.5; pg.BorderSizePixel = 0
    pcall(function() pg.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    local L = Instance.new("UIListLayout", pg)
    L.Padding = UDim.new(0, 6); L.SortOrder = Enum.SortOrder.LayoutOrder
    local P = Instance.new("UIPadding", pg)
    P.PaddingRight = UDim.new(0, 4); P.PaddingBottom = UDim.new(0, 10)
    Pages[name] = pg; return pg
end

local function AddTab(name, label)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 34); btn.BackgroundColor3 = C.PANEL; btn.Text = ""
    btn.TextColor3 = C.TEXT_C; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local bar = Instance.new("Frame", btn)
    bar.Size = UDim2.new(0, 3, 0, 16); bar.Position = UDim2.new(0, 0, 0.5, -8)
    bar.BackgroundColor3 = C.ACCENT; bar.BorderSizePixel = 0; bar.Visible = false
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -14, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = label; lbl.TextColor3 = C.TEXT_C
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- ✅ FIX: Activated
    btn.Activated:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, tb in ipairs(TabBtns) do
            tw(tb.btn, {BackgroundColor3 = C.PANEL}, 0.12)
            tb.bar.Visible = false; tb.lbl.TextColor3 = C.TEXT_C
        end
        if Pages[name] then Pages[name].Visible = true end
        tw(btn, {BackgroundColor3 = C.CARD2}, 0.12)
        bar.Visible = true; lbl.TextColor3 = C.TEXT_A; ActivePage = name
    end)

    table.insert(TabBtns, {btn=btn, bar=bar, lbl=lbl})
    return btn, bar, lbl
end

-- Pages
local EspPage = CreatePage("ESP");    local AimPage = CreatePage("Aimbot")
local SurPage = CreatePage("Surv");   local KilPage = CreatePage("Killer")
local PlrPage = CreatePage("Player"); local VisPage = CreatePage("Visual")
local UtlPage = CreatePage("Utility");local SetPage = CreatePage("Settings")

local espBtn, espBar, espLbl = AddTab("ESP",      "ESP")
AddTab("Aimbot",   "AIMBOT");  AddTab("Surv",    "SURVIVOR")
AddTab("Killer",   "KILLER");  AddTab("Player",  "PLAYER")
AddTab("Visual",   "VISUAL");  AddTab("Utility", "UTILITY"); AddTab("Settings", "SETTINGS")

-- Default active: ESP
EspPage.Visible = true; tw(espBtn, {BackgroundColor3 = C.CARD2}, 0)
espBar.Visible = true; espLbl.TextColor3 = C.TEXT_A

-- ============================================================
-- UI COMPONENT HELPERS
-- ============================================================
local function SectionLabel(parent, text, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 28); row.BackgroundTransparency = 1; row.LayoutOrder = order
    local bar = Instance.new("Frame", row)
    bar.Size = UDim2.new(0, 3, 0, 14); bar.Position = UDim2.new(0, 0, 0.5, -7)
    bar.BackgroundColor3 = C.ACCENT; bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", row)
    lbl.Text = text; lbl.Size = UDim2.new(1, -12, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.TextColor3 = C.ACCENT; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left
    return row
end

-- ✅ FIX: All toggle using Activated
local function CreateToggle(parent, label, initState, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 42); row.BackgroundColor3 = C.CARD
    row.BorderSizePixel = 0; row.LayoutOrder = order or 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = label; lbl.Size = UDim2.new(1, -70, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.TextColor3 = C.TEXT_A; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("TextButton", row)
    track.Size = UDim2.new(0, 44, 0, 23); track.Position = UDim2.new(1, -55, 0.5, -11)
    track.BackgroundColor3 = initState and C.ACCENT or C.OFF; track.Text = ""; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 17, 0, 17)
    knob.Position = initState and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = C.TEXT_A; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = initState
    -- ✅ FIX: Activated
    track.Activated:Connect(function()
        on = not on
        tw(track, {BackgroundColor3 = on and C.ACCENT or C.OFF})
        tw(knob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
        pcall(callback, on)
    end)
    return row, track, knob, function(v)
        on = v
        tw(track, {BackgroundColor3 = on and C.ACCENT or C.OFF})
        tw(knob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    end
end

local function CreateSlider(parent, label, minV, maxV, defV, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 54); row.BackgroundColor3 = C.CARD
    row.BorderSizePixel = 0; row.LayoutOrder = order or 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = label; lbl.Size = UDim2.new(0.6, 0, 0, 20); lbl.Position = UDim2.new(0, 14, 0, 6)
    lbl.TextColor3 = C.TEXT_A; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Text = tostring(defV); valLbl.Size = UDim2.new(0.35, 0, 0, 20)
    valLbl.Position = UDim2.new(0.63, 0, 0, 6); valLbl.TextColor3 = C.ACCENT
    valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 12
    valLbl.BackgroundTransparency = 1; valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -24, 0, 5); track.Position = UDim2.new(0, 12, 0, 36)
    track.BackgroundColor3 = C.OFF; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local pct = (defV - minV) / (maxV - minV)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(pct, 0, 1, 0); fill.BackgroundColor3 = C.ACCENT; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton", track)
    knob.Size = UDim2.new(0, 14, 0, 14); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct, 0, 0.5, 0); knob.BackgroundColor3 = C.TEXT_A
    knob.Text = ""; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sliding = false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local ap = track.AbsolutePosition.X; local as = track.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - ap) / as, 0, 1)
        local val = math.floor(minV + (maxV - minV) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0); knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valLbl.Text = tostring(val); pcall(callback, val)
    end)
    return row
end

-- ✅ FIX: Activated inside expand section
local function CreateExpandSection(parent, headerText, items, mode, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, 0, 0, 42); wrap.BackgroundColor3 = C.CARD
    wrap.BorderSizePixel = 0; wrap.LayoutOrder = order or 0; wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
    local wL = Instance.new("UIListLayout", wrap)
    wL.SortOrder = Enum.SortOrder.LayoutOrder; wL.Padding = UDim.new(0, 0)

    local hdr = Instance.new("TextButton", wrap)
    hdr.Size = UDim2.new(1, 0, 0, 42); hdr.BackgroundTransparency = 1
    hdr.Text = ""; hdr.BorderSizePixel = 0; hdr.LayoutOrder = 0
    local hdrLbl = Instance.new("TextLabel", hdr)
    hdrLbl.Text = headerText; hdrLbl.Size = UDim2.new(1, -46, 1, 0); hdrLbl.Position = UDim2.new(0, 14, 0, 0)
    hdrLbl.TextColor3 = C.TEXT_A; hdrLbl.Font = Enum.Font.GothamMedium; hdrLbl.TextSize = 12
    hdrLbl.BackgroundTransparency = 1; hdrLbl.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = Instance.new("TextLabel", hdr)
    arrow.Text = "v"; arrow.Size = UDim2.new(0, 30, 1, 0); arrow.Position = UDim2.new(1, -36, 0, 0)
    arrow.TextColor3 = C.TEXT_B; arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 12
    arrow.BackgroundTransparency = 1; arrow.TextXAlignment = Enum.TextXAlignment.Center
    local innerDiv = Instance.new("Frame", wrap)
    innerDiv.Size = UDim2.new(1, -24, 0, 1); innerDiv.BackgroundColor3 = C.DIV
    innerDiv.BorderSizePixel = 0; innerDiv.LayoutOrder = 1

    local itemBtns = {}; local itemStates = {}
    for idx, item in ipairs(items) do
        local ib = Instance.new("TextButton", wrap)
        ib.Size = UDim2.new(1, 0, 0, 36); ib.BackgroundTransparency = 1
        ib.Text = ""; ib.BorderSizePixel = 0; ib.LayoutOrder = idx + 1
        local dot = Instance.new("Frame", ib)
        dot.Size = UDim2.new(0, 7, 0, 7); dot.Position = UDim2.new(0, 14, 0.5, -3)
        dot.BackgroundColor3 = C.TEXT_C; dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local ibLbl = Instance.new("TextLabel", ib)
        ibLbl.Text = item.Name; ibLbl.Size = UDim2.new(1, -56, 1, 0); ibLbl.Position = UDim2.new(0, 28, 0, 0)
        ibLbl.TextColor3 = C.TEXT_B; ibLbl.Font = Enum.Font.Gotham; ibLbl.TextSize = 11
        ibLbl.BackgroundTransparency = 1; ibLbl.TextXAlignment = Enum.TextXAlignment.Left
        local badge = Instance.new("TextLabel", ib)
        badge.Size = UDim2.new(0, 28, 0, 16); badge.Position = UDim2.new(1, -36, 0.5, -8)
        badge.BackgroundColor3 = C.OFF; badge.Text = "OFF"; badge.TextColor3 = C.TEXT_C
        badge.Font = Enum.Font.GothamBold; badge.TextSize = 9; badge.BorderSizePixel = 0
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
        itemStates[idx] = item.Default or false
        if itemStates[idx] then
            dot.BackgroundColor3 = C.ACCENT; ibLbl.TextColor3 = C.TEXT_A
            badge.Text = "ON"; badge.BackgroundColor3 = C.ACCENT_DIM; badge.TextColor3 = C.ACCENT
        end
        table.insert(itemBtns, {btn=ib, dot=dot, lbl=ibLbl, badge=badge})
        -- ✅ FIX: Activated
        ib.Activated:Connect(function()
            if mode == "radio" then
                for i2, tb2 in ipairs(itemBtns) do
                    itemStates[i2] = false
                    tw(tb2.dot, {BackgroundColor3 = C.TEXT_C}); tb2.lbl.TextColor3 = C.TEXT_B
                    tb2.badge.Text = "OFF"; tb2.badge.BackgroundColor3 = C.OFF; tb2.badge.TextColor3 = C.TEXT_C
                    pcall(items[i2].Callback, false)
                end
                itemStates[idx] = true
                tw(dot, {BackgroundColor3 = C.ACCENT}); ibLbl.TextColor3 = C.TEXT_A
                badge.Text = "ON"; badge.BackgroundColor3 = C.ACCENT_DIM; badge.TextColor3 = C.ACCENT
                pcall(item.Callback, true)
            else
                itemStates[idx] = not itemStates[idx]; local st = itemStates[idx]
                tw(dot, {BackgroundColor3 = st and C.ACCENT or C.TEXT_C})
                ibLbl.TextColor3 = st and C.TEXT_A or C.TEXT_B
                badge.Text = st and "ON" or "OFF"
                badge.BackgroundColor3 = st and C.ACCENT_DIM or C.OFF
                badge.TextColor3 = st and C.ACCENT or C.TEXT_C
                pcall(item.Callback, st)
            end
        end)
    end

    local ITEM_H = 36; local closed_h = 42; local open_h = 42 + 1 + (#items * ITEM_H); local isOpen = false
    -- ✅ FIX: Activated
    hdr.Activated:Connect(function()
        isOpen = not isOpen
        tw(wrap, {Size = UDim2.new(1, 0, 0, isOpen and open_h or closed_h)}, 0.22)
        tw(arrow, {TextColor3 = isOpen and C.ACCENT or C.TEXT_B})
        arrow.Text = isOpen and "^" or "v"
    end)
    return wrap
end

local function CreateActionBtn(parent, label, callback, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundColor3 = C.CARD
    btn.Text = ""; btn.BorderSizePixel = 0; btn.LayoutOrder = order or 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = label; lbl.Size = UDim2.new(1, -14, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.TextColor3 = C.TEXT_A; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local arr = Instance.new("TextLabel", btn)
    arr.Text = ">"; arr.Size = UDim2.new(0, 24, 1, 0); arr.Position = UDim2.new(1, -28, 0, 0)
    arr.TextColor3 = C.ACCENT; arr.Font = Enum.Font.GothamBold; arr.TextSize = 13; arr.BackgroundTransparency = 1
    -- ✅ FIX: Activated
    btn.Activated:Connect(function()
        tw(btn, {BackgroundColor3 = C.CARD2}, 0.1)
        task.delay(0.15, function() tw(btn, {BackgroundColor3 = C.CARD}, 0.1) end)
        pcall(callback)
    end)
    return btn
end

local function CreatePillSelector(parent, label, options, callback, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, 0, 0, 64); wrap.BackgroundColor3 = C.CARD
    wrap.BorderSizePixel = 0; wrap.LayoutOrder = order or 0
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", wrap)
    lbl.Text = label; lbl.Size = UDim2.new(1, -14, 0, 22); lbl.Position = UDim2.new(0, 14, 0, 6)
    lbl.TextColor3 = C.TEXT_B; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local pillRow = Instance.new("Frame", wrap)
    pillRow.Size = UDim2.new(1, -14, 0, 26); pillRow.Position = UDim2.new(0, 7, 0, 32)
    pillRow.BackgroundTransparency = 1
    local pL = Instance.new("UIListLayout", pillRow)
    pL.FillDirection = Enum.FillDirection.Horizontal; pL.Padding = UDim.new(0, 5)
    local pills = {}
    for i, opt in ipairs(options) do
        local p = Instance.new("TextButton", pillRow)
        p.Size = UDim2.new(0, 68, 1, 0)
        p.BackgroundColor3 = opt.default and C.ACCENT or C.CARD2
        p.Text = opt.label; p.TextColor3 = opt.default and C.TEXT_A or C.TEXT_B
        p.Font = Enum.Font.GothamMedium; p.TextSize = 11; p.BorderSizePixel = 0
        Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)
        table.insert(pills, p)
        -- ✅ FIX: Activated
        p.Activated:Connect(function()
            for _, pp in ipairs(pills) do tw(pp, {BackgroundColor3 = C.CARD2}); pp.TextColor3 = C.TEXT_B end
            tw(p, {BackgroundColor3 = C.ACCENT}); p.TextColor3 = C.TEXT_A
            pcall(callback, opt.value)
        end)
    end
    return wrap
end

-- ============================================================
-- ════ GAME LOGIC ════
-- ============================================================
local function aliveObj(o)
    if not o then return false end
    local ok = pcall(function() return o.Parent end)
    return ok and o.Parent ~= nil
end

-- ─── ESP PLAYERS ────────────────────────────────────────────
local espConns = {}; local espLoop = nil; local rainbowT = 0

local function makeESPTag(plName, role)
    local col = (role == "Killer") and C.KILLER or C.SURVIVOR
    local g = Instance.new("BillboardGui")
    g.Name = "ESP_Tag"; g.AlwaysOnTop = true
    g.Size = UDim2.new(0, 200, 0, 52); g.StudsOffset = Vector3.new(0, 3.2, 0)
    local nameLbl = Instance.new("TextLabel", g)
    nameLbl.Name = "NL"; nameLbl.BackgroundTransparency = 1
    nameLbl.Size = UDim2.new(1, 0, 0, 18); nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 12
    nameLbl.TextColor3 = col; nameLbl.TextStrokeTransparency = 0; nameLbl.TextStrokeColor3 = Color3.new(0,0,0)
    -- ✅ Nama sekarang di atas, tidak tabrakan
    nameLbl.Text = plName
    local roleLbl = Instance.new("TextLabel", g)
    roleLbl.Name = "RL"; roleLbl.BackgroundTransparency = 1
    roleLbl.Size = UDim2.new(1, 0, 0, 14); roleLbl.Position = UDim2.new(0, 0, 0, 16)
    roleLbl.Font = Enum.Font.Gotham; roleLbl.TextSize = 10
    roleLbl.TextColor3 = Color3.fromRGB(180,180,180); roleLbl.TextStrokeTransparency = 0; roleLbl.TextStrokeColor3 = Color3.new(0,0,0)
    roleLbl.Text = "[" .. role .. "]"
    local hpLbl = Instance.new("TextLabel", g)
    hpLbl.Name = "HL"; hpLbl.BackgroundTransparency = 1
    hpLbl.Size = UDim2.new(1, 0, 0, 13); hpLbl.Position = UDim2.new(0, 0, 0, 28)
    hpLbl.Font = Enum.Font.Gotham; hpLbl.TextSize = 10
    hpLbl.TextColor3 = Color3.fromRGB(200,200,200); hpLbl.TextStrokeTransparency = 0; hpLbl.TextStrokeColor3 = Color3.new(0,0,0)
    hpLbl.Text = "HP --"
    local distLbl = Instance.new("TextLabel", g)
    distLbl.Name = "DL"; distLbl.BackgroundTransparency = 1
    distLbl.Size = UDim2.new(1, 0, 0, 12); distLbl.Position = UDim2.new(0, 0, 0, 40)
    distLbl.Font = Enum.Font.Gotham; distLbl.TextSize = 10
    distLbl.TextColor3 = Color3.fromRGB(160,160,160); distLbl.TextStrokeTransparency = 0; distLbl.TextStrokeColor3 = Color3.new(0,0,0)
    distLbl.Text = "0 m"
    return g
end

local function applyESP(pl)
    if pl == LocalPlayer then return end
    local c = pl.Character; if not (c and aliveObj(c)) then return end
    local role = getRole(pl); local isSurv = (role=="Survivor"); local isKill = (role=="Killer")
    local enabled = (isSurv and States.EspSurvivor) or (isKill and States.EspKiller)
    if not enabled then
        local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
        local head = c:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("ESP_Tag"); if tag then tag:Destroy() end
            local dot = head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
        end
        return
    end
    local col = States.RainbowESP and Color3.fromHSV(rainbowT%1,1,1) or (isKill and C.KILLER or C.SURVIVOR)
    if States.EspBox then
        local hl = c:FindFirstChild("ESP_HL")
        if not hl then
            hl = Instance.new("Highlight"); hl.Name = "ESP_HL"; hl.Adornee = c
            hl.FillTransparency = 0.55; hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = c
        end
        hl.FillColor = col; hl.OutlineColor = col
    else
        local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
    end
    local head = c:FindFirstChild("Head"); if not (head and aliveObj(head)) then return end
    if States.EspHeadDot then
        if not head:FindFirstChild("ESP_Dot") then
            local bb = Instance.new("BillboardGui"); bb.Name = "ESP_Dot"
            bb.AlwaysOnTop = true; bb.Size = UDim2.new(0,10,0,10)
            bb.StudsOffset = Vector3.new(0,0.7,0); bb.Parent = head
            local fr = Instance.new("Frame", bb)
            fr.Size = UDim2.new(1,0,1,0); fr.BackgroundColor3 = col; fr.BorderSizePixel = 0
            Instance.new("UICorner",fr).CornerRadius = UDim.new(1,0)
        end
    else
        local dot = head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
    end
    local tag = head:FindFirstChild("ESP_Tag")
    if not tag then tag = makeESPTag(pl.Name, role); tag.Parent = head end
    local nl = tag:FindFirstChild("NL"); if nl then nl.Visible = States.EspName; nl.TextColor3 = col end
    local rl = tag:FindFirstChild("RL"); if rl then rl.Visible = States.EspName end
    local hum = c:FindFirstChildOfClass("Humanoid")
    local hl2 = tag:FindFirstChild("HL")
    if hl2 then
        hl2.Visible = States.EspHP
        if hum and hum.Parent then hl2.Text = "HP  "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth) end
    end
    local myChar = LocalPlayer.Character; local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local hrp = c:FindFirstChild("HumanoidRootPart"); local dl = tag:FindFirstChild("DL")
    if dl then
        dl.Visible = States.EspDist
        if myHRP and hrp and hrp.Parent then dl.Text = math.floor((hrp.Position-myHRP.Position).Magnitude).." m" end
    end
    if States.EspTracer then
        pcall(function()
            if not rawget(_G,"Drawing") then return end
            local hrp2 = c:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
            local mh = myChar and myChar:FindFirstChild("HumanoidRootPart"); if not mh then return end
            local line = Drawing.new("Line")
            local fp = Camera:WorldToViewportPoint(mh.Position); local tp = Camera:WorldToViewportPoint(hrp2.Position)
            line.Visible=true; line.Color=col; line.Thickness=1
            line.From=Vector2.new(fp.X,fp.Y); line.To=Vector2.new(tp.X,tp.Y)
            task.delay(0.05, function() pcall(function() line:Remove() end) end)
        end)
    end
end

local function startESP()
    if espLoop then espLoop:Disconnect(); espLoop=nil end
    espLoop = RunService.Heartbeat:Connect(function(dt)
        rainbowT = rainbowT + dt * 0.4
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then pcall(applyESP, pl) end
        end
    end)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            espConns[pl] = espConns[pl] or {}
            table.insert(espConns[pl], pl.CharacterAdded:Connect(function()
                task.wait(0.5); pcall(applyESP, pl)
            end))
        end
    end
end

local function stopAllESP()
    if espLoop then espLoop:Disconnect(); espLoop=nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            local c = pl.Character
            local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
            local head = c:FindFirstChild("Head")
            if head then
                local tag = head:FindFirstChild("ESP_Tag"); if tag then tag:Destroy() end
                local dot = head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
            end
        end
    end
    for _, conns in pairs(espConns) do for _, cn in pairs(conns) do pcall(function() cn:Disconnect() end) end end
    espConns = {}
end

local function refreshESP()
    if States.EspSurvivor or States.EspKiller then startESP() else stopAllESP() end
end

-- ─── ESP GENERATOR ──────────────────────────────────────────
local genHL = {}; local genLoop = nil
local function getGenProg(gen)
    local v = gen:GetAttribute("RepairProgress")
    if v then return (v<=1) and math.floor(v*100) or math.min(math.floor(v),100) end
    return 0
end
local function buildGenESP()
    for _, d in pairs(genHL) do pcall(function() if d.hl then d.hl:Destroy() end end); pcall(function() if d.bb then d.bb:Destroy() end end) end
    genHL = {}
    local map = WS:FindFirstChild("Map") or WS:FindFirstChild("Map1"); if not map then return end
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local prog = getGenProg(obj); local col = prog>=100 and C.GEN_B or C.GEN_A
                local hl = Instance.new("Highlight")
                hl.FillColor=col; hl.OutlineColor=col; hl.FillTransparency=0.6; hl.OutlineTransparency=0
                hl.Adornee=obj; hl.Parent=obj
                local bb = Instance.new("BillboardGui")
                bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,130,0,30); bb.StudsOffset=Vector3.new(0,4,0)
                bb.Adornee=part; bb.Parent=part
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
                lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12
                lbl.Text="GEN  "..prog.."%"; lbl.TextColor3=col
                lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
                genHL[obj] = {hl=hl, bb=bb, lbl=lbl}
            end
        end
    end
end
local function startGenESP()
    buildGenESP()
    genLoop = RunService.Heartbeat:Connect(function()
        for gen, d in pairs(genHL) do
            if gen and gen.Parent then
                local prog = getGenProg(gen); local col = prog>=100 and C.GEN_B or C.GEN_A
                if d.hl then d.hl.FillColor=col; d.hl.OutlineColor=col end
                if d.lbl then d.lbl.Text="GEN  "..prog.."%"; d.lbl.TextColor3=col end
            else
                pcall(function() if d.hl then d.hl:Destroy() end end)
                pcall(function() if d.bb then d.bb:Destroy() end end)
                genHL[gen] = nil
            end
        end
    end)
end
local function stopGenESP()
    if genLoop then genLoop:Disconnect(); genLoop=nil end
    for _, d in pairs(genHL) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end
    genHL = {}
end

-- ─── ESP WORLD OBJECTS (Gate, Hook, Window, Pallet) ─────────
local worldESPObjs = {}
local function clearWorldESP(tag)
    for _, e in pairs(worldESPObjs) do
        if e.tag == tag then pcall(function() if e.hl then e.hl:Destroy() end end) end
    end
end

local function buildWorldESP(searchName, color, tag)
    clearWorldESP(tag)
    for _, obj in ipairs(WS:GetDescendants()) do
        local n = obj.Name:lower()
        if obj:IsA("Model") and n:find(searchName:lower()) then
            local hl = Instance.new("Highlight")
            hl.Adornee = obj; hl.FillTransparency = 1
            hl.OutlineColor = color; hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = obj
            table.insert(worldESPObjs, {hl=hl, tag=tag})
        end
    end
end

-- ─── PALLET ESP ─────────────────────────────────────────────
local palReg = {}; local palLoop = nil
local function findPallets()
    for _, e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name=="Palletwrong" or obj.Name:lower():find("pallet")) then
            if not palReg[obj] then palReg[obj] = {model=obj, hl=nil} end
        end
    end
end
local function startPalletESP()
    findPallets()
    palLoop = RunService.Heartbeat:Connect(function()
        for model, entry in pairs(palReg) do
            if model and aliveObj(model) then
                if not entry.hl or not aliveObj(entry.hl) then
                    local h = Instance.new("Highlight"); h.Adornee=model; h.FillTransparency=1
                    h.OutlineColor=C.PALLET; h.OutlineTransparency=0
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=model; entry.hl=h
                end
            else
                pcall(function() if entry.hl then entry.hl:Destroy() end end); palReg[model]=nil
            end
        end
    end)
end
local function stopPalletESP()
    if palLoop then palLoop:Disconnect(); palLoop=nil end
    for _, e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg = {}
end

-- ─── AIMBOT ─────────────────────────────────────────────────
local aimConn = nil; local fovCircle = nil
local function drawFOV(r)
    pcall(function()
        if fovCircle then fovCircle:Remove(); fovCircle=nil end
        if not r or r<=0 then return end
        if not rawget(_G,"Drawing") then return end
        fovCircle = Drawing.new("Circle"); fovCircle.Visible=true; fovCircle.Radius=r
        fovCircle.Color=C.ACCENT; fovCircle.Thickness=1; fovCircle.Filled=false; fovCircle.NumSides=64
        local vp = Camera.ViewportSize; fovCircle.Position=Vector2.new(vp.X/2, vp.Y/2)
    end)
end
local function getBodyPart(char, bone)
    if bone=="head" then return char:FindFirstChild("Head") end
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
end
local function startAimbot()
    aimConn = RunService.Heartbeat:Connect(function()
        if not States.Aimbot then return end
        local best=nil; local bestD=math.huge
        local vp=Camera.ViewportSize; local cx,cy=vp.X/2,vp.Y/2
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer and pl.Character then
                if not (States.AimbotTeam and getRole(pl)==getRole(LocalPlayer)) then
                    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, onSc = Camera:WorldToViewportPoint(hrp.Position)
                        if onSc then
                            local d = ((pos.X-cx)^2+(pos.Y-cy)^2)^0.5
                            if d<States.AimbotFOV and d<bestD then bestD=d; best=pl end
                        end
                    end
                end
            end
        end
        if best and best.Character then
            local part = getBodyPart(best.Character, States.AimbotBone)
            if part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
        end
    end)
end
local function stopAimbot()
    if aimConn then aimConn:Disconnect(); aimConn=nil end
    pcall(function() if fovCircle then fovCircle:Remove(); fovCircle=nil end end)
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then Camera.CameraSubject = hum end
    end
end

-- ─── PLAYER MODS ────────────────────────────────────────────
local noClipConn=nil; local flyConn=nil; local flyBV=nil
local godConn=nil; local antiKnockConn=nil; local infJumpConn=nil; local invisConn=nil

local function startNoClip()
    noClipConn = RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end)
end
local function stopNoClip()
    if noClipConn then noClipConn:Disconnect(); noClipConn=nil end
    local c=LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end
end

local function startFly()
    local c=LocalPlayer.Character; if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.PlatformStand=true
    flyBV=Instance.new("BodyVelocity",hrp); flyBV.Velocity=Vector3.new(0,0,0); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
    flyConn=RunService.Heartbeat:Connect(function()
        local dir=Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)      then dir=dir+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
        if flyBV and flyBV.Parent then flyBV.Velocity=(dir.Magnitude>0) and dir.Unit*50 or Vector3.new(0,0,0) end
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBV then flyBV:Destroy(); flyBV=nil end
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand=false end
end

local function startGod()
    godConn=RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.Health < hum.MaxHealth then hum.Health=hum.MaxHealth end
    end)
end
local function stopGod()
    if godConn then godConn:Disconnect(); godConn=nil end
end

local function startInfJump()
    infJumpConn=UIS.JumpRequest:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn=nil end
end

local function startAntiKnock()
    antiKnockConn=RunService.Heartbeat:Connect(function()
        local c=LocalPlayer.Character; if not c then return end
        local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X*0.1, hrp.AssemblyLinearVelocity.Y, hrp.AssemblyLinearVelocity.Z*0.1)
    end)
end
local function stopAntiKnock()
    if antiKnockConn then antiKnockConn:Disconnect(); antiKnockConn=nil end
end

-- Invisibility (from V2 - fade character parts)
local origTransparencies = {}
local function startInvisible()
    local c=LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
            origTransparencies[p] = p.Transparency; p.Transparency = 1
        end
        if p:IsA("Decal") then origTransparencies[p]=p.Transparency; p.Transparency=1 end
    end
end
local function stopInvisible()
    local c=LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if (p:IsA("BasePart") or p:IsA("Decal")) and origTransparencies[p] then
            p.Transparency=origTransparencies[p]; origTransparencies[p]=nil
        end
    end
end

local function applyWalkSpeed(v)
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed=States.WalkSpeedOn and v or 16
end
local function applyJumpPower(v)
    local c=LocalPlayer.Character; if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.JumpPower=v
end

-- ─── VISUAL ─────────────────────────────────────────────────
local origAmb=Lighting.Ambient; local origBri=Lighting.Brightness; local origFog=Lighting.FogEnd
local origFogStart=Lighting.FogStart; local origClock=Lighting.ClockTime; local origShadows=Lighting.GlobalShadows
local chamsConn=nil; local crosshairGui=nil

-- Simpan referensi Atmosphere agar bisa restore
local _origAtmo = {}
local function saveAtmosphere()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            _origAtmo[obj] = {Density=obj.Density,Offset=obj.Offset,Glare=obj.Glare,Haze=obj.Haze}
        end
    end
end
saveAtmosphere()

local function setFullBright(on)
    if on then
        Lighting.Ambient           = Color3.fromRGB(255,255,255)
        Lighting.Brightness        = 2
        Lighting.ClockTime         = 14      -- siang hari
        Lighting.GlobalShadows     = false   -- hapus bayangan
        -- Matikan efek Atmosphere
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then obj.Density=0; obj.Offset=0; obj.Glare=0; obj.Haze=0 end
        end
    else
        Lighting.Ambient       = origAmb
        Lighting.Brightness    = origBri
        Lighting.ClockTime     = origClock
        Lighting.GlobalShadows = origShadows
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") and _origAtmo[obj] then
                local d=_origAtmo[obj]; obj.Density=d.Density; obj.Offset=d.Offset; obj.Glare=d.Glare; obj.Haze=d.Haze
            end
        end
    end
end

local function setNoFog(on)
    if on then
        Lighting.FogEnd   = 1e6
        Lighting.FogStart = 1e6
        -- Matikan semua Atmosphere fog
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then obj.Density=0; obj.Haze=0 end
        end
    else
        Lighting.FogEnd   = origFog
        Lighting.FogStart = origFogStart
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") and _origAtmo[obj] then
                local d=_origAtmo[obj]; obj.Density=d.Density; obj.Haze=d.Haze
            end
        end
    end
end
local function setCrosshair(on)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui=nil end
    if not on then return end
    local sg=Instance.new("ScreenGui"); sg.Name="VD_Crosshair"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.Parent=PlayerGui
    crosshairGui=sg
    local ch=Instance.new("Frame",sg); ch.AnchorPoint=Vector2.new(0.5,0.5)
    ch.Position=UDim2.new(0.5,0,0.5,0); ch.Size=UDim2.new(0,22,0,22); ch.BackgroundTransparency=1
    local function L(w,h) local f=Instance.new("Frame",ch); f.AnchorPoint=Vector2.new(0.5,0.5)
        f.Position=UDim2.new(0.5,0,0.5,0); f.Size=UDim2.new(0,w,0,h); f.BackgroundColor3=C.ACCENT; f.BorderSizePixel=0
    end
    L(2,16); L(16,2)
end
local function setChams(on)
    if chamsConn then chamsConn:Disconnect(); chamsConn=nil end
    if on then
        chamsConn=RunService.Heartbeat:Connect(function()
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl~=LocalPlayer and pl.Character then
                    for _, p in ipairs(pl.Character:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Material=Enum.Material.Neon
                            p.Color=(getRole(pl)=="Killer") and C.KILLER or C.SURVIVOR
                        end
                    end
                end
            end
        end)
    end
end

-- ─── UTILITY ────────────────────────────────────────────────
local afkConn=nil; local fpsObjs={}; local fpsGui=nil

local function setAntiAFK(on)
    if afkConn then afkConn:Disconnect(); afkConn=nil end
    if on then
        local t=0
        afkConn=RunService.Heartbeat:Connect(function(dt)
            t=t+dt; if t>60 then t=0
                local c=LocalPlayer.Character; if not c then return end
                local hum=c:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.new(0.01,0,0)) end
            end
        end)
    end
end

local function setFPSBoost(on)
    if on then
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
            or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled=false; table.insert(fpsObjs, obj)
            end
        end
        Lighting.GlobalShadows=false
    else
        for _, obj in ipairs(fpsObjs) do pcall(function() obj.Enabled=true end) end
        fpsObjs={}; Lighting.GlobalShadows=true
    end
end

-- FPS Counter UI (dari V2)
local function setFPSCounter(on)
    if fpsGui then fpsGui:Destroy(); fpsGui=nil end
    if not on then return end
    local sg=Instance.new("ScreenGui"); sg.Name="VD_FPS"; sg.ResetOnSpawn=false; sg.DisplayOrder=1000; sg.Parent=PlayerGui
    fpsGui=sg
    local f=Instance.new("Frame",sg); f.Size=UDim2.new(0,80,0,22); f.Position=UDim2.new(0,5,0,5)
    f.BackgroundColor3=Color3.fromRGB(15,15,15); f.BackgroundTransparency=0.3; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local lbl=Instance.new("TextLabel",f); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.TextColor3=C.ACCENT; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=11; lbl.Text="FPS: --"
    local last=tick(); local frames=0
    RunService.RenderStepped:Connect(function()
        frames=frames+1
        if tick()-last>=1 then lbl.Text="FPS: "..frames; frames=0; last=tick() end
    end)
end

local function tpToPlayer(target)
    if not (target and target.Character) then return end
    local c=LocalPlayer.Character; if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart"); local thrp=target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and thrp then hrp.CFrame=thrp.CFrame*CFrame.new(0,0,3) end
end

local function serverHop()
    pcall(function()
        local id=game.PlaceId
        local ok,res=pcall(function()
            return game:GetService("HttpService"):JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..id.."/servers/Public?limit=10"))
        end)
        local servers={}
        if ok and res and res.data then
            for _, s in ipairs(res.data) do
                if s.id~=game.JobId and (s.maxPlayers-s.playing)>0 then table.insert(servers,s.id) end
            end
        end
        if #servers>0 then TeleportService:TeleportToPlaceInstance(id,servers[math.random(1,#servers)],LocalPlayer) end
    end)
end

local function rejoin()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

local specConn=nil
local function startSpectate(target)
    if specConn then specConn:Disconnect(); specConn=nil end
    if not target then pcall(function() Camera.CameraType=Enum.CameraType.Custom end); return end
    pcall(function() Camera.CameraType=Enum.CameraType.Scriptable end)
    specConn=RunService.Heartbeat:Connect(function()
        if not (target and target.Character) then
            pcall(function() Camera.CameraType=Enum.CameraType.Custom end); specConn:Disconnect(); return
        end
        local hrp=target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Camera.CFrame=CFrame.new(hrp.Position+Vector3.new(0,5,-8), hrp.Position) end
    end)
end

-- ─── AUTO GENERATOR (SkillCheck Blocker — dari script yang terbukti bekerja) ────────────────────
local skillExactNames = {
    SkillCheckPromptGui         = true,
    ["SkillCheckPromptGui-con"] = true,
    SkillCheckEvent             = true,
    SkillCheckFailEvent         = true,
    SkillCheckResultEvent       = true,
}
local guiWhitelistAG = {Rayfield=true,DevConsoleMaster=true,RobloxGui=true,PlayerList=true,Chat=true,BubbleChat=true,Backpack=true}

local function isExactSkill(inst)
    local n = inst and inst.Name; if not n then return false end
    if skillExactNames[n] then return true end
    return n:lower():find("skillcheck",1,true) ~= nil
end

local function hardDelete(obj)
    pcall(function()
        if obj:IsA("ProximityPrompt") then obj.Enabled=false; obj.HoldDuration=1e9 end
        if obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            if obj:IsA("ScreenGui") and guiWhitelistAG[obj.Name] then return end
            obj.Enabled=false; obj.Visible=false; obj.ResetOnSpawn=false; obj:Destroy()
        else obj:Destroy() end
    end)
end

local function nukeSkillOnce()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, g in ipairs(pg:GetChildren()) do if isExactSkill(g) then hardDelete(g) end end
        for _, d in ipairs(pg:GetDescendants()) do if isExactSkill(d) then hardDelete(d) end end
    end
    for _, g in ipairs(game:GetService("StarterGui"):GetChildren()) do if isExactSkill(g) then hardDelete(g) end end
    local rem = RS:FindFirstChild("Remotes")
    if rem then for _, d in ipairs(rem:GetDescendants()) do if isExactSkill(d) then hardDelete(d) end end end
end

local _hookInstalled = false
local function installSkillHook()
    if _hookInstalled then return end
    pcall(function()
        if typeof(hookmetamethod)=="function" and typeof(getnamecallmethod)=="function" then
            local old
            old = hookmetamethod(game,"__namecall",function(self,...)
                local m = getnamecallmethod()
                if States.AutoGenerator and typeof(self)=="Instance" and isExactSkill(self)
                    and (m=="FireServer" or m=="InvokeServer") then return nil end
                return old(self,...)
            end)
            _hookInstalled = true
        end
    end)
end

local _agConns = {}
local function startAutoGen()
    installSkillHook()
    nukeSkillOnce()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local c1=pg.ChildAdded:Connect(function(ch) if States.AutoGenerator and isExactSkill(ch) then hardDelete(ch) end end)
        local c2=pg.DescendantAdded:Connect(function(d) if States.AutoGenerator and isExactSkill(d) then hardDelete(d) end end)
        table.insert(_agConns,c1); table.insert(_agConns,c2)
    end
    local sg = game:GetService("StarterGui")
    local c3=sg.ChildAdded:Connect(function(ch) if States.AutoGenerator and isExactSkill(ch) then hardDelete(ch) end end)
    table.insert(_agConns,c3)
    local rem=RS:FindFirstChild("Remotes")
    if rem then
        local c4=rem.DescendantAdded:Connect(function(d) if States.AutoGenerator and isExactSkill(d) then hardDelete(d) end end)
        table.insert(_agConns,c4)
    end
    local c5=RS.DescendantAdded:Connect(function(d)
        if not States.AutoGenerator then return end
        if isExactSkill(d) then hardDelete(d) end
    end)
    table.insert(_agConns,c5)
    local c6=WS.DescendantAdded:Connect(function(d) if States.AutoGenerator and isExactSkill(d) then hardDelete(d) end end)
    table.insert(_agConns,c6)
end
local function stopAutoGen()
    for _, c in ipairs(_agConns) do pcall(function() c:Disconnect() end) end
    _agConns = {}
end

-- Loop untuk fitur-fitur Killer & lainnya
task.spawn(function()
    while task.wait(0.15) do
        if States.AutoAttack and R_BasicAttack then pcall(function() R_BasicAttack:FireServer(false) end) end
        if States.AutoLunge and R_Lunge then pcall(function() R_Lunge:FireServer(false) end) end
        if States.PowerSkip and R_PowerDone then pcall(function() R_PowerDone:FireServer() end) end
        if States.AutoHealReset and R_HealReset then pcall(function() R_HealReset:FireServer(LocalPlayer) end) end
        -- Auto Leave Generator (kalau killer deket, hentikan repair)
        if States.AutoLeaveGen and R_RepairEvent then
            pcall(function()
                local myChar=LocalPlayer.Character; if not myChar then return end
                local myHRP=myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl~=LocalPlayer and getRole(pl)=="Killer" and pl.Character then
                        local kHRP=pl.Character:FindFirstChild("HumanoidRootPart")
                        if kHRP and (kHRP.Position-myHRP.Position).Magnitude < States.LeaveDistance then
                            local map=WS:FindFirstChild("Map") or WS:FindFirstChild("Map1"); if not map then return end
                            for _, obj in ipairs(map:GetDescendants()) do
                                if obj:IsA("Model") and obj.Name=="Generator" then
                                    for _, pt in ipairs(obj:GetChildren()) do
                                        if pt.Name:find("GeneratorPoint") then
                                            pcall(function() R_RepairEvent:FireServer(pt,false) end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- ════════════ BUILD PAGES ════════════
-- ============================================================

-- ─── ESP PAGE ───────────────────────────────────────────────
SectionLabel(EspPage, "PLAYER ESP", 1)

-- Survivor toggle (warna hijau custom)
local function makeColorToggle(parent, label, textColor, strokeColor, order, callback)
    local row = Instance.new("Frame", parent)
    row.Size=UDim2.new(1,0,0,42); row.BackgroundColor3=C.CARD; row.BorderSizePixel=0; row.LayoutOrder=order
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",row); stroke.Color=strokeColor; stroke.Thickness=1; stroke.Transparency=0.5
    local lbl=Instance.new("TextLabel",row); lbl.Text=label; lbl.Size=UDim2.new(1,-70,1,0); lbl.Position=UDim2.new(0,14,0,0)
    lbl.TextColor3=textColor; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local track=Instance.new("TextButton",row); track.Size=UDim2.new(0,44,0,23); track.Position=UDim2.new(1,-55,0.5,-11)
    track.BackgroundColor3=C.OFF; track.Text=""; track.BorderSizePixel=0; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,17,0,17); knob.Position=UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=C.TEXT_A; knob.BorderSizePixel=0; Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    -- ✅ FIX: Activated
    track.Activated:Connect(function()
        local on = not (track.BackgroundColor3 == C.OFF)
        -- actually just toggle state directly
        local cur = (track.BackgroundColor3 ~= C.OFF and track.BackgroundColor3 ~= Color3.fromRGB(50,50,50))
        cur = not cur
        tw(track, {BackgroundColor3 = cur and textColor or C.OFF})
        tw(knob, {Position = cur and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
        callback(cur)
    end)
    return row
end

-- Simpler approach - just track state externally
local survOn, killOn = false, false
local survTrack, survKnob, killTrack, killKnob

do
    local row=Instance.new("Frame", EspPage)
    row.Size=UDim2.new(1,0,0,42); row.BackgroundColor3=Color3.fromRGB(18,30,20); row.BorderSizePixel=0; row.LayoutOrder=2
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local sk=Instance.new("UIStroke",row); sk.Color=C.SURVIVOR; sk.Thickness=1; sk.Transparency=0.5
    local l=Instance.new("TextLabel",row); l.Text="Survivor ESP"; l.Size=UDim2.new(1,-70,1,0); l.Position=UDim2.new(0,14,0,0)
    l.TextColor3=C.SURVIVOR; l.Font=Enum.Font.GothamBold; l.TextSize=12; l.BackgroundTransparency=1; l.TextXAlignment=Enum.TextXAlignment.Left
    survTrack=Instance.new("TextButton",row); survTrack.Size=UDim2.new(0,44,0,23); survTrack.Position=UDim2.new(1,-55,0.5,-11)
    survTrack.BackgroundColor3=C.OFF; survTrack.Text=""; survTrack.BorderSizePixel=0; Instance.new("UICorner",survTrack).CornerRadius=UDim.new(1,0)
    survKnob=Instance.new("Frame",survTrack); survKnob.Size=UDim2.new(0,17,0,17); survKnob.Position=UDim2.new(0,3,0.5,-8)
    survKnob.BackgroundColor3=C.TEXT_A; survKnob.BorderSizePixel=0; Instance.new("UICorner",survKnob).CornerRadius=UDim.new(1,0)
    survTrack.Activated:Connect(function()
        survOn=not survOn; States.EspSurvivor=survOn
        tw(survTrack,{BackgroundColor3=survOn and C.SURVIVOR or C.OFF})
        tw(survKnob,{Position=survOn and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
        refreshESP()
    end)
end

do
    local row=Instance.new("Frame", EspPage)
    row.Size=UDim2.new(1,0,0,42); row.BackgroundColor3=Color3.fromRGB(30,15,15); row.BorderSizePixel=0; row.LayoutOrder=3
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local sk=Instance.new("UIStroke",row); sk.Color=C.KILLER; sk.Thickness=1; sk.Transparency=0.5
    local l=Instance.new("TextLabel",row); l.Text="Killer ESP"; l.Size=UDim2.new(1,-70,1,0); l.Position=UDim2.new(0,14,0,0)
    l.TextColor3=C.KILLER; l.Font=Enum.Font.GothamBold; l.TextSize=12; l.BackgroundTransparency=1; l.TextXAlignment=Enum.TextXAlignment.Left
    killTrack=Instance.new("TextButton",row); killTrack.Size=UDim2.new(0,44,0,23); killTrack.Position=UDim2.new(1,-55,0.5,-11)
    killTrack.BackgroundColor3=C.OFF; killTrack.Text=""; killTrack.BorderSizePixel=0; Instance.new("UICorner",killTrack).CornerRadius=UDim.new(1,0)
    killKnob=Instance.new("Frame",killTrack); killKnob.Size=UDim2.new(0,17,0,17); killKnob.Position=UDim2.new(0,3,0.5,-8)
    killKnob.BackgroundColor3=C.TEXT_A; killKnob.BorderSizePixel=0; Instance.new("UICorner",killKnob).CornerRadius=UDim.new(1,0)
    killTrack.Activated:Connect(function()
        killOn=not killOn; States.EspKiller=killOn
        tw(killTrack,{BackgroundColor3=killOn and C.KILLER or C.OFF})
        tw(killKnob,{Position=killOn and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
        refreshESP()
    end)
end

CreateExpandSection(EspPage, "Display Options", {
    {Name="Show Name",    Default=true,  Callback=function(s) States.EspName=s end},
    {Name="Show HP",      Default=true,  Callback=function(s) States.EspHP=s end},
    {Name="Show Distance",Default=true,  Callback=function(s) States.EspDist=s end},
    {Name="Box Highlight",Default=true,  Callback=function(s) States.EspBox=s
        if not s then for _, pl in ipairs(Players:GetPlayers()) do if pl.Character then local hl=pl.Character:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end end end end
    end},
    {Name="Head Dot",     Default=false, Callback=function(s) States.EspHeadDot=s end},
    {Name="Tracer Line",  Default=false, Callback=function(s) States.EspTracer=s end},
    {Name="Rainbow Mode", Default=false, Callback=function(s) States.RainbowESP=s end},
}, "multi", 4)

SectionLabel(EspPage, "WORLD ESP", 10)
CreateToggle(EspPage, "Generator ESP  (progress %)", false, function(s) States.EspGenerator=s; if s then startGenESP() else stopGenESP() end end, 11)
CreateToggle(EspPage, "Pallet ESP", false, function(s) States.PalletEsp=s; if s then startPalletESP() else stopPalletESP() end end, 12)
CreateToggle(EspPage, "Gate ESP", false, function(s) States.GateEsp=s; if s then buildWorldESP("Gate",C.GATE,"gate") else clearWorldESP("gate") end end, 13)
CreateToggle(EspPage, "Hook ESP", false, function(s) States.HookEsp=s; if s then buildWorldESP("Hook",C.HOOK,"hook") else clearWorldESP("hook") end end, 14)
CreateToggle(EspPage, "Window ESP", false, function(s) States.WindowEsp=s; if s then buildWorldESP("Window",C.WINDOW,"window") else clearWorldESP("window") end end, 15)

-- ─── AIMBOT PAGE ─────────────────────────────────────────────
SectionLabel(AimPage, "AIM ASSIST", 1)
CreateToggle(AimPage, "Aimbot", false, function(s) States.Aimbot=s; if s then startAimbot() else stopAimbot() end end, 2)
CreateToggle(AimPage, "Team Check  (skip same team)", true, function(s) States.AimbotTeam=s end, 3)
CreateExpandSection(AimPage, "Target Bone", {
    {Name="Head",            Default=false, Callback=function(s) if s then States.AimbotBone="head" end end},
    {Name="Body  (default)", Default=true,  Callback=function(s) if s then States.AimbotBone="body" end end},
}, "radio", 4)
CreateExpandSection(AimPage, "FOV Circle", {
    {Name="Small  (60)",  Default=false, Callback=function(s) if s then States.AimbotFOV=60;  drawFOV(60)  end end},
    {Name="Medium (100)", Default=true,  Callback=function(s) if s then States.AimbotFOV=100; drawFOV(100) end end},
    {Name="Large  (200)", Default=false, Callback=function(s) if s then States.AimbotFOV=200; drawFOV(200) end end},
    {Name="Off",          Default=false, Callback=function(s) if s then drawFOV(0) end end},
}, "radio", 5)

-- ─── SURVIVOR PAGE ───────────────────────────────────────────
SectionLabel(SurPage, "AUTO FEATURES", 1)
CreateToggle(SurPage, "Auto Generator  (SkillCheck Blocker)", false, function(s)
    States.AutoGenerator=s
    if s then startAutoGen() else stopAutoGen() end
end, 2)
CreateToggle(SurPage, "Auto Leave Gen  (killer nearby)", false, function(s) States.AutoLeaveGen=s end, 3)
CreateSlider(SurPage, "Leave Distance", 5, 50, 15, function(v) States.LeaveDistance=v end, 4)
CreateToggle(SurPage, "Auto Heal Reset", false, function(s) States.AutoHealReset=s end, 5)
SectionLabel(SurPage, "MOVEMENT", 6)
CreateToggle(SurPage, "Fast Vault  (remote)", false, function(s)
    States.FastVaultAuto=s
    if s and R_FastVault then task.spawn(function() while States.FastVaultAuto do pcall(function() R_FastVault:FireServer(LocalPlayer) end); task.wait(0.3) end end) end
end, 7)
CreateToggle(SurPage, "Anti Chase", false, function(s)
    States.AntiChase=s
    if s and R_Chase then task.spawn(function() while States.AntiChase do pcall(function() R_Chase:FireServer(LocalPlayer.Character, false) end); task.wait(0.5) end end) end
end, 8)

-- ─── KILLER PAGE ─────────────────────────────────────────────
SectionLabel(KilPage, "AUTO ATTACK", 1)
CreateToggle(KilPage, "Auto Basic Attack", false, function(s) States.AutoAttack=s end, 2)
CreateToggle(KilPage, "Auto Lunge", false, function(s) States.AutoLunge=s end, 3)
CreateToggle(KilPage, "Power Cooldown Skip", false, function(s) States.PowerSkip=s end, 4)

-- ─── PLAYER PAGE ─────────────────────────────────────────────
SectionLabel(PlrPage, "CHARACTER", 1)

-- WalkSpeed block
local wsBlock=Instance.new("Frame",PlrPage); wsBlock.Size=UDim2.new(1,0,0,96); wsBlock.BackgroundColor3=C.CARD
wsBlock.BorderSizePixel=0; wsBlock.LayoutOrder=2; Instance.new("UICorner",wsBlock).CornerRadius=UDim.new(0,8)
local wsTogRow=Instance.new("Frame",wsBlock); wsTogRow.Size=UDim2.new(1,0,0,42); wsTogRow.BackgroundTransparency=1
local wsLbl=Instance.new("TextLabel",wsTogRow); wsLbl.Text="Walk Speed"; wsLbl.Size=UDim2.new(1,-70,1,0); wsLbl.Position=UDim2.new(0,14,0,0)
wsLbl.TextColor3=C.TEXT_A; wsLbl.Font=Enum.Font.GothamMedium; wsLbl.TextSize=12; wsLbl.BackgroundTransparency=1; wsLbl.TextXAlignment=Enum.TextXAlignment.Left
local wsTrack=Instance.new("TextButton",wsTogRow); wsTrack.Size=UDim2.new(0,44,0,23); wsTrack.Position=UDim2.new(1,-55,0.5,-11)
wsTrack.BackgroundColor3=C.OFF; wsTrack.Text=""; wsTrack.BorderSizePixel=0; Instance.new("UICorner",wsTrack).CornerRadius=UDim.new(1,0)
local wsKnob=Instance.new("Frame",wsTrack); wsKnob.Size=UDim2.new(0,17,0,17); wsKnob.Position=UDim2.new(0,3,0.5,-8)
wsKnob.BackgroundColor3=C.TEXT_A; wsKnob.BorderSizePixel=0; Instance.new("UICorner",wsKnob).CornerRadius=UDim.new(1,0)
-- ✅ FIX: Activated
wsTrack.Activated:Connect(function()
    States.WalkSpeedOn=not States.WalkSpeedOn; local on=States.WalkSpeedOn
    tw(wsTrack,{BackgroundColor3=on and C.ACCENT or C.OFF}); tw(wsKnob,{Position=on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    applyWalkSpeed(States.WalkSpeed)
end)
local wsDivider=Instance.new("Frame",wsBlock); wsDivider.Size=UDim2.new(1,-24,0,1); wsDivider.Position=UDim2.new(0,12,0,42)
wsDivider.BackgroundColor3=C.DIV; wsDivider.BorderSizePixel=0
local wsValLbl=Instance.new("TextLabel",wsBlock); wsValLbl.Text=tostring(States.WalkSpeed)
wsValLbl.Size=UDim2.new(0,40,0,20); wsValLbl.Position=UDim2.new(1,-54,0,50)
wsValLbl.TextColor3=C.ACCENT; wsValLbl.Font=Enum.Font.GothamBold; wsValLbl.TextSize=12; wsValLbl.BackgroundTransparency=1; wsValLbl.TextXAlignment=Enum.TextXAlignment.Right
local wsSLbl=Instance.new("TextLabel",wsBlock); wsSLbl.Text="Speed"; wsSLbl.Size=UDim2.new(0.4,0,0,20); wsSLbl.Position=UDim2.new(0,14,0,50)
wsSLbl.TextColor3=C.TEXT_B; wsSLbl.Font=Enum.Font.Gotham; wsSLbl.TextSize=11; wsSLbl.BackgroundTransparency=1; wsSLbl.TextXAlignment=Enum.TextXAlignment.Left
local wsST=Instance.new("Frame",wsBlock); wsST.Size=UDim2.new(1,-24,0,5); wsST.Position=UDim2.new(0,12,0,78)
wsST.BackgroundColor3=C.OFF; wsST.BorderSizePixel=0; Instance.new("UICorner",wsST).CornerRadius=UDim.new(1,0)
local wsDP=(States.WalkSpeed-4)/(200-4)
local wsSF=Instance.new("Frame",wsST); wsSF.Size=UDim2.new(wsDP,0,1,0); wsSF.BackgroundColor3=C.ACCENT; wsSF.BorderSizePixel=0; Instance.new("UICorner",wsSF).CornerRadius=UDim.new(1,0)
local wsSK=Instance.new("TextButton",wsST); wsSK.Size=UDim2.new(0,14,0,14); wsSK.AnchorPoint=Vector2.new(0.5,0.5)
wsSK.Position=UDim2.new(wsDP,0,0.5,0); wsSK.BackgroundColor3=C.TEXT_A; wsSK.Text=""; wsSK.BorderSizePixel=0; Instance.new("UICorner",wsSK).CornerRadius=UDim.new(1,0)
do local sl=false
    wsSK.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sl=true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sl=false end end)
    UIS.InputChanged:Connect(function(i)
        if not sl then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local rel=math.clamp((i.Position.X-wsST.AbsolutePosition.X)/wsST.AbsoluteSize.X,0,1)
        local val=math.floor(4+(200-4)*rel); States.WalkSpeed=val
        wsSF.Size=UDim2.new(rel,0,1,0); wsSK.Position=UDim2.new(rel,0,0.5,0); wsValLbl.Text=tostring(val)
        if States.WalkSpeedOn then applyWalkSpeed(val) end
    end)
end

CreateSlider(PlrPage, "Jump Power", 0, 200, 50, function(v) States.JumpPower=v; applyJumpPower(v) end, 3)
CreateToggle(PlrPage, "Infinite Jump", false, function(s) States.InfJump=s; if s then startInfJump() else stopInfJump() end end, 4)
CreateToggle(PlrPage, "No Clip", false, function(s) States.NoClip=s; if s then startNoClip() else stopNoClip() end end, 5)
CreateToggle(PlrPage, "Fly Mode  (W/A/S/D + Space/Ctrl)", false, function(s) States.FlyMode=s; if s then startFly() else stopFly() end end, 6)
CreateToggle(PlrPage, "God Mode", false, function(s) States.GodMode=s; if s then startGod() else stopGod() end end, 7)
CreateToggle(PlrPage, "Anti Knockback", false, function(s) States.AntiKnock=s; if s then startAntiKnock() else stopAntiKnock() end end, 8)
CreateToggle(PlrPage, "Invisible", false, function(s) States.Invisible=s; if s then startInvisible() else stopInvisible() end end, 9)

-- ─── VISUAL PAGE ─────────────────────────────────────────────
SectionLabel(VisPage, "LIGHTING", 1)
-- Day Bright Mode: FullBright + NoFog + Daytime sekaligus (dinding jadi terang polos)
do
    local dayBrightOn = false
    local row=Instance.new("Frame",VisPage); row.Size=UDim2.new(1,0,0,54); row.BackgroundColor3=Color3.fromRGB(28,25,10)
    row.BorderSizePixel=0; row.LayoutOrder=2; Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local sk=Instance.new("UIStroke",row); sk.Color=Color3.fromRGB(255,200,30); sk.Thickness=1; sk.Transparency=0.5
    local lbl=Instance.new("TextLabel",row); lbl.Text="☀  Day Bright Mode"; lbl.Size=UDim2.new(1,-70,0,24); lbl.Position=UDim2.new(0,14,0,6)
    lbl.TextColor3=Color3.fromRGB(255,210,60); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local sub=Instance.new("TextLabel",row); sub.Text="FullBright + NoFog + Siang + Hapus Bayangan"; sub.Size=UDim2.new(1,-14,0,14); sub.Position=UDim2.new(0,14,0,30)
    sub.TextColor3=Color3.fromRGB(120,110,60); sub.Font=Enum.Font.Gotham; sub.TextSize=10; sub.BackgroundTransparency=1; sub.TextXAlignment=Enum.TextXAlignment.Left
    local track=Instance.new("TextButton",row); track.Size=UDim2.new(0,44,0,23); track.Position=UDim2.new(1,-55,0.5,-11)
    track.BackgroundColor3=C.OFF; track.Text=""; track.BorderSizePixel=0; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,17,0,17); knob.Position=UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=C.TEXT_A; knob.BorderSizePixel=0; Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    track.Activated:Connect(function()
        dayBrightOn=not dayBrightOn
        setFullBright(dayBrightOn); setNoFog(dayBrightOn)
        States.FullBright=dayBrightOn; States.NoFog=dayBrightOn
        local col=Color3.fromRGB(255,200,30)
        tw(track,{BackgroundColor3=dayBrightOn and col or C.OFF})
        tw(knob,{Position=dayBrightOn and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    end)
end
CreateToggle(VisPage, "Full Bright",  false, function(s) States.FullBright=s; setFullBright(s) end, 3)
CreateToggle(VisPage, "No Fog",       false, function(s) States.NoFog=s;      setNoFog(s) end, 4)
CreateToggle(VisPage, "Crosshair",    false, function(s) States.Crosshair=s;  setCrosshair(s) end, 5)
CreateToggle(VisPage, "Chams",        false, function(s) States.Chams=s;      setChams(s) end, 6)
CreateExpandSection(VisPage, "Time of Day", {
    {Name="Day",  Default=false, Callback=function(s) if s then Lighting.ClockTime=14 end end},
    {Name="Night",Default=false, Callback=function(s) if s then Lighting.ClockTime=0  end end},
    {Name="Dusk", Default=false, Callback=function(s) if s then Lighting.ClockTime=18 end end},
}, "radio", 7)
CreateExpandSection(VisPage, "Field of View", {
    {Name="Normal (70)",  Default=false, Callback=function(s) if s then Camera.FieldOfView=70  end end},
    {Name="Wide   (100)", Default=false, Callback=function(s) if s then Camera.FieldOfView=100 end end},
    {Name="Super  (120)", Default=false, Callback=function(s) if s then Camera.FieldOfView=120 end end},
}, "radio", 7)

-- ─── UTILITY PAGE ────────────────────────────────────────────
SectionLabel(UtlPage, "TOOLS", 1)
CreateToggle(UtlPage, "Anti AFK",    false, function(s) States.AntiAFK=s;   setAntiAFK(s) end, 2)
CreateToggle(UtlPage, "FPS Boost",   false, function(s) States.FPSBoost=s;  setFPSBoost(s) end, 3)
CreateToggle(UtlPage, "FPS Counter", false, function(s) States.FPSCounter=s; setFPSCounter(s) end, 4)
CreateToggle(UtlPage, "Free Camera", false, function(s)
    Camera.CameraType = s and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end, 5)

SectionLabel(UtlPage, "TELEPORT", 6)

local tpKillBtn=Instance.new("TextButton",UtlPage)
tpKillBtn.Size=UDim2.new(1,0,0,38); tpKillBtn.BackgroundColor3=Color3.fromRGB(36,14,14)
tpKillBtn.Text=""; tpKillBtn.BorderSizePixel=0; tpKillBtn.LayoutOrder=7
Instance.new("UICorner",tpKillBtn).CornerRadius=UDim.new(0,8)
local tkStroke=Instance.new("UIStroke",tpKillBtn); tkStroke.Color=C.KILLER; tkStroke.Thickness=1; tkStroke.Transparency=0.5
local tkLbl=Instance.new("TextLabel",tpKillBtn); tkLbl.Text="Teleport to Killer"
tkLbl.Size=UDim2.new(1,-14,1,0); tkLbl.Position=UDim2.new(0,14,0,0)
tkLbl.TextColor3=C.KILLER; tkLbl.Font=Enum.Font.GothamBold; tkLbl.TextSize=12
tkLbl.BackgroundTransparency=1; tkLbl.TextXAlignment=Enum.TextXAlignment.Left
-- ✅ FIX: Activated
tpKillBtn.Activated:Connect(function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and getRole(pl)=="Killer" then tpToPlayer(pl); return end
    end
end)

CreateExpandSection(UtlPage, "Teleport to Player", (function()
    local list={}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            local cap=pl
            table.insert(list, {Name=pl.Name.."  ["..getRole(pl).."]", Callback=function(s) if s then tpToPlayer(cap) end end})
        end
    end
    if #list==0 then list={{Name="No other players", Callback=function() end}} end
    return list
end)(), "multi", 8)

CreateExpandSection(UtlPage, "Spectate Player", (function()
    local list={}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            local cap=pl
            table.insert(list, {Name=pl.Name, Callback=function(s) startSpectate(s and cap or nil) end})
        end
    end
    if #list==0 then list={{Name="No other players", Callback=function() end}} end
    return list
end)(), "radio", 9)

SectionLabel(UtlPage, "SERVER", 10)
CreateActionBtn(UtlPage, "Server Hop  (find new server)", serverHop, 11)
CreateActionBtn(UtlPage, "Rejoin", rejoin, 12)

-- ─── SETTINGS PAGE ───────────────────────────────────────────
SectionLabel(SetPage, "ICON", 1)
CreatePillSelector(SetPage, "Size", {
    {label="Small",  value="sm",  default=false},
    {label="Normal", value="md",  default=true },
    {label="Large",  value="lg",  default=false},
}, function(v) local s={sm=36,md=48,lg=68}; tw(OpenBtn,{Size=UDim2.new(0,s[v],0,s[v])}) end, 2)

CreatePillSelector(SetPage, "Shape", {
    {label="Circle",  value="circle",  default=true },
    {label="Rounded", value="rounded", default=false},
    {label="Square",  value="square",  default=false},
}, function(v) local r={circle=UDim.new(1,0),rounded=UDim.new(0,10),square=UDim.new(0,2)}; _oc.CornerRadius=r[v] end, 3)

CreatePillSelector(SetPage, "Color", {
    {label="Dark",   value="dk", default=true },
    {label="Orange", value="or", default=false},
    {label="Blue",   value="bl", default=false},
    {label="Purple", value="pu", default=false},
}, function(v)
    local c2={dk=Color3.fromRGB(22,22,22),["or"]=Color3.fromRGB(180,80,0),bl=Color3.fromRGB(0,90,210),pu=Color3.fromRGB(110,0,200)}
    tw(OpenBtn,{BackgroundColor3=c2[v] or Color3.fromRGB(22,22,22)})
end, 4)

SectionLabel(SetPage, "WINDOW", 5)
CreatePillSelector(SetPage, "Accent Color", {
    {label="Orange", value="or", default=true },
    {label="Cyan",   value="cy", default=false},
    {label="Green",  value="gr", default=false},
}, function(v)
    local c2={["or"]=Color3.fromRGB(232,137,12),cy=Color3.fromRGB(0,200,230),gr=Color3.fromRGB(60,200,80)}
    local newC=c2[v] or Color3.fromRGB(232,137,12)
    C.ACCENT=newC; _ms.Color=C.DIV; _os.Color=newC; TitleLabel.TextColor3=newC
end, 6)

-- Mobile info
if isMobile then
    SectionLabel(SetPage, "MOBILE", 7)
    CreateActionBtn(SetPage, "Apply FPS Optimization", function()
        setFPSBoost(true)
        pcall(function() game:GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01 end)
    end, 8)
end

-- ============================================================
-- WATERMARK (pojok kiri bawah)
-- ============================================================
local WaterFrame=Instance.new("Frame",ScreenGui)
WaterFrame.Size=UDim2.new(0,190,0,24); WaterFrame.Position=UDim2.new(0,8,1,-32)
WaterFrame.BackgroundColor3=Color3.fromRGB(13,13,13); WaterFrame.BackgroundTransparency=0.25
WaterFrame.BorderSizePixel=0; WaterFrame.ZIndex=5
Instance.new("UICorner",WaterFrame).CornerRadius=UDim.new(0,6)
local WaterText=Instance.new("TextLabel",WaterFrame)
WaterText.Text=" LYNXX VD v12.1  |  Saycho"; WaterText.Size=UDim2.new(1,0,1,0)
WaterText.TextColor3=C.ACCENT; WaterText.Font=Enum.Font.GothamBold; WaterText.TextSize=11
WaterText.BackgroundTransparency=1; WaterText.TextXAlignment=Enum.TextXAlignment.Left; WaterText.ZIndex=6

-- ============================================================
-- ENSURE GUI (survive respawn)
-- ============================================================
local function ensureGUI()
    if not ScreenGui or not ScreenGui.Parent then ScreenGui.Parent=getPlayerGui() end
end
RunService.Heartbeat:Connect(ensureGUI)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1); ensureGUI()
    local hum=char:WaitForChild("Humanoid",5)
    if hum then hum.WalkSpeed=States.WalkSpeedOn and States.WalkSpeed or 16; hum.JumpPower=States.JumpPower end
    if States.EspSurvivor or States.EspKiller then stopAllESP(); task.wait(0.1); startESP() end
    if States.EspGenerator then stopGenESP(); task.wait(0.1); startGenESP() end
    if States.GodMode   then stopGod();      task.wait(0.1); startGod()      end
    if States.InfJump   then stopInfJump();  task.wait(0.1); startInfJump()  end
    if States.AntiKnock then stopAntiKnock();task.wait(0.1); startAntiKnock() end
    if States.NoClip    then startNoClip() end
    if States.Invisible then task.wait(0.5); startInvisible() end
end)

WS.ChildAdded:Connect(function(child)
    if (child.Name=="Map" or child.Name=="Map1") and States.PalletEsp then task.wait(3); findPallets() end
end)
task.delay(2, findPallets)

print("[VD v12.1] Loaded — Saycho | Fixed: or-keyword bug + RepairEvent arg")
