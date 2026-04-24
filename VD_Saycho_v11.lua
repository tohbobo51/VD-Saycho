--[[
  VD (Violence District) — PLATINUM
  Version : 11.0
  Author  : Saycho
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local UIS              = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local WS               = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera      = WS.CurrentCamera

-- ============================================================
-- PLAYERGUI — safe fallback
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
    local old = p:FindFirstChild("VD_Saycho_Official")
    if old then old:Destroy() end
    local old2 = p:FindFirstChild("VD_Crosshair")
    if old2 then old2:Destroy() end
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local ScreenGui
pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "VD_Saycho_Official"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    sg.Parent = CoreGui
    ScreenGui = sg
end)
if not ScreenGui or not ScreenGui.Parent then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VD_Saycho_Official"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui
end

-- ============================================================
-- STATES
-- ============================================================
local States = {
    EspSurvivor   = false,
    EspKiller     = false,
    EspGenerator  = false,
    PalletEsp     = false,
    EspName       = true,
    EspHP         = true,
    EspDist       = true,
    EspBox        = true,
    EspHeadDot    = false,
    EspTracer     = false,
    RainbowESP    = false,

    Aimbot        = false,
    AimbotTeam    = true,
    AimbotBone    = "body",
    AimbotFOV     = 100,

    WalkSpeedOn   = false,
    WalkSpeed     = 60,
    JumpPower     = 50,
    NoClip        = false,
    GodMode       = false,
    FlyMode       = false,
    InfJump       = false,
    AntiKnock     = false,

    FullBright    = false,
    NoFog         = false,
    Crosshair     = false,
    Chams         = false,

    AntiAFK       = false,
    FPSBoost      = false,
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
OpenBtn.Visible          = false
OpenBtn.ZIndex           = 20
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
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = false
local _mc = Instance.new("UICorner", MainFrame); _mc.CornerRadius = UDim.new(0, 12)
local _ms = Instance.new("UIStroke", MainFrame)
_ms.Color = C.DIV; _ms.Thickness = 1

-- Drag bar (top center grip)
local DragBar = Instance.new("TextButton", MainFrame)
DragBar.Size             = UDim2.new(1, 0, 0, 46)
DragBar.BackgroundTransparency = 1
DragBar.Text             = ""
DragBar.ZIndex           = 2
MakeDraggable(MainFrame, DragBar)

local GripDot = Instance.new("Frame", DragBar)
GripDot.Size             = UDim2.new(0, 32, 0, 3)
GripDot.Position         = UDim2.new(0.5, -16, 0, 8)
GripDot.BackgroundColor3 = C.DIV
GripDot.BorderSizePixel  = 0
Instance.new("UICorner", GripDot).CornerRadius = UDim.new(1, 0)

-- Header text
local TitleLabel = Instance.new("TextLabel", DragBar)
TitleLabel.Text            = "LYNXX"
TitleLabel.Position        = UDim2.new(0, 16, 0, 14)
TitleLabel.Size            = UDim2.new(0, 60, 0, 20)
TitleLabel.TextColor3      = C.ACCENT
TitleLabel.Font            = Enum.Font.GothamBold
TitleLabel.TextSize        = 15
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left

local SubLabel = Instance.new("TextLabel", DragBar)
SubLabel.Text              = "Violence District"
SubLabel.Position          = UDim2.new(0, 82, 0, 16)
SubLabel.Size              = UDim2.new(0, 130, 0, 16)
SubLabel.TextColor3        = C.TEXT_C
SubLabel.Font              = Enum.Font.Gotham
SubLabel.TextSize          = 11
SubLabel.BackgroundTransparency = 1
SubLabel.TextXAlignment    = Enum.TextXAlignment.Left

local VerLabel = Instance.new("TextLabel", DragBar)
VerLabel.Text              = "v11.0"
VerLabel.Position          = UDim2.new(1, -110, 0, 16)
VerLabel.Size              = UDim2.new(0, 60, 0, 16)
VerLabel.TextColor3        = C.TEXT_C
VerLabel.Font              = Enum.Font.Gotham
VerLabel.TextSize          = 11
VerLabel.BackgroundTransparency = 1
VerLabel.TextXAlignment    = Enum.TextXAlignment.Right

-- Minimize button
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size             = UDim2.new(0, 28, 0, 28)
MinBtn.Position         = UDim2.new(1, -40, 0, 9)
MinBtn.BackgroundColor3 = C.CARD
MinBtn.Text             = "—"
MinBtn.TextColor3       = C.TEXT_B
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.TextSize         = 14
MinBtn.BorderSizePixel  = 0
MinBtn.ZIndex           = 5
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)

-- Header divider
local HDiv = Instance.new("Frame", MainFrame)
HDiv.Size             = UDim2.new(1, 0, 0, 1)
HDiv.Position         = UDim2.new(0, 0, 0, 46)
HDiv.BackgroundColor3 = C.DIV
HDiv.BorderSizePixel  = 0

-- Resize corner
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size             = UDim2.new(0, 14, 0, 14)
ResizeBtn.Position         = UDim2.new(1, -18, 1, -18)
ResizeBtn.BackgroundColor3 = C.CARD2
ResizeBtn.Text             = ""
ResizeBtn.BorderSizePixel  = 0
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 4)

do
    local rs = false
    ResizeBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            rs = true
            local ss = MainFrame.Size; local sp2 = i.Position; local mc2
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

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible=false; OpenBtn.Visible=true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible=true; OpenBtn.Visible=false end)

-- ============================================================
-- SIDEBAR
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position         = UDim2.new(0, 8, 0, 54)
Sidebar.Size             = UDim2.new(0, 120, 1, -62)
Sidebar.BackgroundColor3 = C.PANEL
Sidebar.BorderSizePixel  = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding     = UDim.new(0, 2)
SideLayout.SortOrder   = Enum.SortOrder.LayoutOrder
local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop    = UDim.new(0, 6)
SidePad.PaddingLeft   = UDim.new(0, 6)
SidePad.PaddingRight  = UDim.new(0, 6)

-- Sidebar vertical divider
local SDiv = Instance.new("Frame", MainFrame)
SDiv.Size             = UDim2.new(0, 1, 1, -70)
SDiv.Position         = UDim2.new(0, 136, 0, 54)
SDiv.BackgroundColor3 = C.DIV
SDiv.BorderSizePixel  = 0

-- Container
local Container = Instance.new("Frame", MainFrame)
Container.Position         = UDim2.new(0, 144, 0, 52)
Container.Size             = UDim2.new(1, -152, 1, -60)
Container.BackgroundTransparency = 1

-- ============================================================
-- PAGE & TAB SYSTEM
-- ============================================================
local Pages      = {}
local TabBtns    = {}
local ActivePage = nil

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name                  = name
    pg.Size                  = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency= 1
    pg.Visible               = false
    pg.ScrollBarThickness    = 3
    pg.ScrollBarImageColor3  = C.ACCENT
    pg.ScrollBarImageTransparency = 0.5
    pg.BorderSizePixel       = 0
    pcall(function() pg.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    local L = Instance.new("UIListLayout", pg)
    L.Padding    = UDim.new(0, 6)
    L.SortOrder  = Enum.SortOrder.LayoutOrder
    local P = Instance.new("UIPadding", pg)
    P.PaddingRight  = UDim.new(0, 4)
    P.PaddingBottom = UDim.new(0, 10)
    Pages[name] = pg
    return pg
end

local function AddTab(name, label)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size             = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = C.PANEL
    btn.Text             = label
    btn.TextColor3       = C.TEXT_C
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.TextXAlignment   = Enum.TextXAlignment.Left
    btn.BorderSizePixel  = 0
    pcall(function() btn.AutomaticSize = Enum.AutomaticSize.None end)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Left accent bar
    local bar = Instance.new("Frame", btn)
    bar.Size             = UDim2.new(0, 3, 0, 16)
    bar.Position         = UDim2.new(0, 0, 0.5, -8)
    bar.BackgroundColor3 = C.ACCENT
    bar.BorderSizePixel  = 0
    bar.Visible          = false
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    -- Indent text
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size             = UDim2.new(1, -14, 1, 0)
    lbl.Position         = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text             = label
    lbl.TextColor3       = C.TEXT_C
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextSize         = 11
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    btn.Text             = ""

    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, tb in ipairs(TabBtns) do
            tw(tb.btn, {BackgroundColor3 = C.PANEL}, 0.12)
            tb.bar.Visible = false
            tb.lbl.TextColor3 = C.TEXT_C
        end
        if Pages[name] then Pages[name].Visible = true end
        tw(btn, {BackgroundColor3 = C.CARD2}, 0.12)
        bar.Visible   = true
        lbl.TextColor3 = C.TEXT_A
        ActivePage    = name
    end)

    table.insert(TabBtns, {btn=btn, bar=bar, lbl=lbl})
    return btn, bar, lbl
end

-- Create all pages
local EspPage = CreatePage("ESP")
local AimPage = CreatePage("Aimbot")
local PlrPage = CreatePage("Player")
local VisPage = CreatePage("Visual")
local UtlPage = CreatePage("Utility")
local SetPage = CreatePage("Settings")

-- Create tabs (no emojis, uppercase short labels)
local espBtn, espBar, espLbl = AddTab("ESP",      "ESP")
AddTab("Aimbot",   "AIMBOT")
AddTab("Player",   "PLAYER")
AddTab("Visual",   "VISUAL")
AddTab("Utility",  "UTILITY")
AddTab("Settings", "SETTINGS")

-- Default active tab
EspPage.Visible   = true
tw(espBtn, {BackgroundColor3 = C.CARD2}, 0)
espBar.Visible    = true
espLbl.TextColor3 = C.TEXT_A

-- ============================================================
-- UI COMPONENT HELPERS
-- ============================================================

-- Section header with left border style
local function SectionLabel(parent, text, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.LayoutOrder      = order

    local bar = Instance.new("Frame", row)
    bar.Size             = UDim2.new(0, 3, 0, 14)
    bar.Position         = UDim2.new(0, 0, 0.5, -7)
    bar.BackgroundColor3 = C.ACCENT
    bar.BorderSizePixel  = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text             = text
    lbl.Size             = UDim2.new(1, -12, 1, 0)
    lbl.Position         = UDim2.new(0, 10, 0, 0)
    lbl.TextColor3       = C.ACCENT
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextSize         = 11
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    return row
end

-- Toggle row
local function CreateToggle(parent, label, initState, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = C.CARD
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order or 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text             = label
    lbl.Size             = UDim2.new(1, -70, 1, 0)
    lbl.Position         = UDim2.new(0, 14, 0, 0)
    lbl.TextColor3       = C.TEXT_A
    lbl.Font             = Enum.Font.GothamMedium
    lbl.TextSize         = 12
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment   = Enum.TextXAlignment.Left

    -- Track
    local track = Instance.new("TextButton", row)
    track.Size             = UDim2.new(0, 44, 0, 23)
    track.Position         = UDim2.new(1, -55, 0.5, -11)
    track.BackgroundColor3 = initState and C.ACCENT or C.OFF
    track.Text             = ""
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size             = UDim2.new(0, 17, 0, 17)
    knob.Position         = initState and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = C.TEXT_A
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = initState
    track.MouseButton1Click:Connect(function()
        on = not on
        tw(track, {BackgroundColor3 = on and C.ACCENT or C.OFF})
        tw(knob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
        pcall(callback, on)
    end)
    return row, track, knob, function(v) -- external setter
        on = v
        tw(track, {BackgroundColor3 = on and C.ACCENT or C.OFF})
        tw(knob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    end
end

-- Slider row
local function CreateSlider(parent, label, minV, maxV, defV, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 54)
    row.BackgroundColor3 = C.CARD
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order or 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text             = label
    lbl.Size             = UDim2.new(0.6, 0, 0, 20)
    lbl.Position         = UDim2.new(0, 14, 0, 6)
    lbl.TextColor3       = C.TEXT_A
    lbl.Font             = Enum.Font.GothamMedium
    lbl.TextSize         = 12
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment   = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Text          = tostring(defV)
    valLbl.Size          = UDim2.new(0.35, 0, 0, 20)
    valLbl.Position      = UDim2.new(0.63, 0, 0, 6)
    valLbl.TextColor3    = C.ACCENT
    valLbl.Font          = Enum.Font.GothamBold
    valLbl.TextSize      = 12
    valLbl.BackgroundTransparency = 1
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size             = UDim2.new(1, -24, 0, 5)
    track.Position         = UDim2.new(0, 12, 0, 36)
    track.BackgroundColor3 = C.OFF
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local pct = (defV - minV) / (maxV - minV)
    local fill = Instance.new("Frame", track)
    fill.Size             = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = C.ACCENT
    fill.BorderSizePixel  = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton", track)
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint      = Vector2.new(0.5, 0.5)
    knob.Position         = UDim2.new(pct, 0, 0.5, 0)
    knob.BackgroundColor3 = C.TEXT_A
    knob.Text             = ""
    knob.BorderSizePixel  = 0
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
        local ap  = track.AbsolutePosition.X
        local as  = track.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - ap) / as, 0, 1)
        local val = math.floor(minV + (maxV - minV) * rel)
        fill.Size         = UDim2.new(rel, 0, 1, 0)
        knob.Position     = UDim2.new(rel, 0, 0.5, 0)
        valLbl.Text       = tostring(val)
        pcall(callback, val)
    end)
    return row
end

-- Expandable section with multi-select sub-items (toggle each independently)
-- mode: "multi" = each item is independent toggle
--       "radio" = only 1 item active at a time
local function CreateExpandSection(parent, headerText, items, mode, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size             = UDim2.new(1, 0, 0, 42)
    wrap.BackgroundColor3 = C.CARD
    wrap.BorderSizePixel  = 0
    wrap.LayoutOrder      = order or 0
    wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)

    local wrapLayout = Instance.new("UIListLayout", wrap)
    wrapLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wrapLayout.Padding   = UDim.new(0, 0)

    -- Header button
    local hdr = Instance.new("TextButton", wrap)
    hdr.Size             = UDim2.new(1, 0, 0, 42)
    hdr.BackgroundTransparency = 1
    hdr.Text             = ""
    hdr.BorderSizePixel  = 0
    hdr.LayoutOrder      = 0

    local hdrLbl = Instance.new("TextLabel", hdr)
    hdrLbl.Text          = headerText
    hdrLbl.Size          = UDim2.new(1, -46, 1, 0)
    hdrLbl.Position      = UDim2.new(0, 14, 0, 0)
    hdrLbl.TextColor3    = C.TEXT_A
    hdrLbl.Font          = Enum.Font.GothamMedium
    hdrLbl.TextSize      = 12
    hdrLbl.BackgroundTransparency = 1
    hdrLbl.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", hdr)
    arrow.Text           = "v"
    arrow.Size           = UDim2.new(0, 30, 1, 0)
    arrow.Position       = UDim2.new(1, -36, 0, 0)
    arrow.TextColor3     = C.TEXT_B
    arrow.Font           = Enum.Font.GothamBold
    arrow.TextSize       = 12
    arrow.BackgroundTransparency = 1
    arrow.TextXAlignment = Enum.TextXAlignment.Center

    -- Divider inside
    local innerDiv = Instance.new("Frame", wrap)
    innerDiv.Size             = UDim2.new(1, -24, 0, 1)
    innerDiv.BackgroundColor3 = C.DIV
    innerDiv.BorderSizePixel  = 0
    innerDiv.LayoutOrder      = 1

    -- Item buttons
    local itemBtns = {}
    local itemStates = {}

    for idx, item in ipairs(items) do
        local ib = Instance.new("TextButton", wrap)
        ib.Size             = UDim2.new(1, 0, 0, 36)
        ib.BackgroundTransparency = 1
        ib.Text             = ""
        ib.BorderSizePixel  = 0
        ib.LayoutOrder      = idx + 1

        local dot = Instance.new("Frame", ib)
        dot.Size             = UDim2.new(0, 7, 0, 7)
        dot.Position         = UDim2.new(0, 14, 0.5, -3)
        dot.BackgroundColor3 = C.TEXT_C
        dot.BorderSizePixel  = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local ibLbl = Instance.new("TextLabel", ib)
        ibLbl.Text           = item.Name
        ibLbl.Size           = UDim2.new(1, -56, 1, 0)
        ibLbl.Position       = UDim2.new(0, 28, 0, 0)
        ibLbl.TextColor3     = C.TEXT_B
        ibLbl.Font           = Enum.Font.Gotham
        ibLbl.TextSize       = 11
        ibLbl.BackgroundTransparency = 1
        ibLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- Status badge right side
        local badge = Instance.new("TextLabel", ib)
        badge.Size           = UDim2.new(0, 28, 0, 16)
        badge.Position       = UDim2.new(1, -36, 0.5, -8)
        badge.BackgroundColor3 = C.OFF
        badge.Text           = "OFF"
        badge.TextColor3     = C.TEXT_C
        badge.Font           = Enum.Font.GothamBold
        badge.TextSize       = 9
        badge.BorderSizePixel = 0
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)

        itemStates[idx] = item.Default or false
        if itemStates[idx] then
            dot.BackgroundColor3 = C.ACCENT
            ibLbl.TextColor3     = C.TEXT_A
            badge.Text           = "ON"
            badge.BackgroundColor3 = C.ACCENT_DIM
            badge.TextColor3     = C.ACCENT
        end

        table.insert(itemBtns, {btn=ib, dot=dot, lbl=ibLbl, badge=badge})

        ib.MouseButton1Click:Connect(function()
            if mode == "radio" then
                -- turn all off first
                for i2, tb2 in ipairs(itemBtns) do
                    itemStates[i2] = false
                    tw(tb2.dot,   {BackgroundColor3 = C.TEXT_C})
                    tb2.lbl.TextColor3       = C.TEXT_B
                    tb2.badge.Text           = "OFF"
                    tb2.badge.BackgroundColor3 = C.OFF
                    tb2.badge.TextColor3     = C.TEXT_C
                    pcall(items[i2].Callback, false)
                end
                -- activate this one
                itemStates[idx] = true
                tw(dot,   {BackgroundColor3 = C.ACCENT})
                ibLbl.TextColor3     = C.TEXT_A
                badge.Text           = "ON"
                badge.BackgroundColor3 = C.ACCENT_DIM
                badge.TextColor3     = C.ACCENT
                pcall(item.Callback, true)
            else -- multi
                itemStates[idx] = not itemStates[idx]
                local st = itemStates[idx]
                tw(dot, {BackgroundColor3 = st and C.ACCENT or C.TEXT_C})
                ibLbl.TextColor3     = st and C.TEXT_A or C.TEXT_B
                badge.Text           = st and "ON" or "OFF"
                badge.BackgroundColor3 = st and C.ACCENT_DIM or C.OFF
                badge.TextColor3     = st and C.ACCENT or C.TEXT_C
                pcall(item.Callback, st)
            end
        end)
    end

    local ITEM_H = 36
    local closed_h = 42
    local open_h   = 42 + 1 + (#items * ITEM_H)
    local isOpen   = false

    hdr.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        tw(wrap, {Size = UDim2.new(1, 0, 0, isOpen and open_h or closed_h)}, 0.22)
        tw(arrow, {TextColor3 = isOpen and C.ACCENT or C.TEXT_B})
        arrow.Text = isOpen and "^" or "v"
    end)

    return wrap
end

-- Action button (single click, no toggle state)
local function CreateActionBtn(parent, label, callback, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size             = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = C.CARD
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = order or 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Text             = label
    lbl.Size             = UDim2.new(1, -14, 1, 0)
    lbl.Position         = UDim2.new(0, 14, 0, 0)
    lbl.TextColor3       = C.TEXT_A
    lbl.Font             = Enum.Font.GothamMedium
    lbl.TextSize         = 12
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment   = Enum.TextXAlignment.Left

    local arr = Instance.new("TextLabel", btn)
    arr.Text             = ">"
    arr.Size             = UDim2.new(0, 24, 1, 0)
    arr.Position         = UDim2.new(1, -28, 0, 0)
    arr.TextColor3       = C.ACCENT
    arr.Font             = Enum.Font.GothamBold
    arr.TextSize         = 13
    arr.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        tw(btn, {BackgroundColor3 = C.CARD2}, 0.1)
        task.delay(0.15, function() tw(btn, {BackgroundColor3 = C.CARD}, 0.1) end)
        pcall(callback)
    end)
    return btn
end

-- Settings pill selector
local function CreatePillSelector(parent, label, options, callback, order)
    local wrap = Instance.new("Frame", parent)
    wrap.Size             = UDim2.new(1, 0, 0, 64)
    wrap.BackgroundColor3 = C.CARD
    wrap.BorderSizePixel  = 0
    wrap.LayoutOrder      = order or 0
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", wrap)
    lbl.Text             = label
    lbl.Size             = UDim2.new(1, -14, 0, 22)
    lbl.Position         = UDim2.new(0, 14, 0, 6)
    lbl.TextColor3       = C.TEXT_B
    lbl.Font             = Enum.Font.Gotham
    lbl.TextSize         = 11
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment   = Enum.TextXAlignment.Left

    local pillRow = Instance.new("Frame", wrap)
    pillRow.Size             = UDim2.new(1, -14, 0, 26)
    pillRow.Position         = UDim2.new(0, 7, 0, 32)
    pillRow.BackgroundTransparency = 1

    local pillLayout = Instance.new("UIListLayout", pillRow)
    pillLayout.FillDirection = Enum.FillDirection.Horizontal
    pillLayout.Padding       = UDim.new(0, 5)

    local pills = {}
    for i, opt in ipairs(options) do
        local p = Instance.new("TextButton", pillRow)
        p.Size             = UDim2.new(0, 68, 1, 0)
        p.BackgroundColor3 = opt.default and C.ACCENT or C.CARD2
        p.Text             = opt.label
        p.TextColor3       = opt.default and C.TEXT_A or C.TEXT_B
        p.Font             = Enum.Font.GothamMedium
        p.TextSize         = 11
        p.BorderSizePixel  = 0
        Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)
        table.insert(pills, p)
        p.MouseButton1Click:Connect(function()
            for _, pp in ipairs(pills) do
                tw(pp, {BackgroundColor3 = C.CARD2})
                pp.TextColor3 = C.TEXT_B
            end
            tw(p, {BackgroundColor3 = C.ACCENT})
            p.TextColor3 = C.TEXT_A
            pcall(callback, opt.value)
        end)
    end
    return wrap
end

-- ============================================================
-- ══════════ GAME LOGIC FUNCTIONS ══════════
-- ============================================================
local function aliveObj(o)
    if not o then return false end
    local ok = pcall(function() return o.Parent end)
    return ok and o.Parent ~= nil
end

-- ─── ESP ────────────────────────────────────────────────────
local espConns   = {}
local espLoop    = nil
local rainbowT   = 0

local function makeESPTag(plName, role)
    local col = (role == "Killer") and C.KILLER or C.SURVIVOR
    local g = Instance.new("BillboardGui")
    g.Name        = "ESP_Tag"
    g.AlwaysOnTop = true
    g.Size        = UDim2.new(0, 200, 0, 52)
    g.StudsOffset = Vector3.new(0, 3.2, 0)

    local nameLbl = Instance.new("TextLabel", g)
    nameLbl.Name  = "NL"
    nameLbl.BackgroundTransparency = 1
    nameLbl.Size  = UDim2.new(1, 0, 0, 18)
    nameLbl.Font  = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = col
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.new(0,0,0)
    nameLbl.Text  = plName .. "  [" .. role .. "]"

    local hpLbl = Instance.new("TextLabel", g)
    hpLbl.Name   = "HL"
    hpLbl.BackgroundTransparency = 1
    hpLbl.Size   = UDim2.new(1, 0, 0, 15)
    hpLbl.Position = UDim2.new(0, 0, 0, 19)
    hpLbl.Font   = Enum.Font.Gotham
    hpLbl.TextSize = 10
    hpLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    hpLbl.TextStrokeTransparency = 0
    hpLbl.TextStrokeColor3 = Color3.new(0,0,0)
    hpLbl.Text   = "HP --"

    local distLbl = Instance.new("TextLabel", g)
    distLbl.Name  = "DL"
    distLbl.BackgroundTransparency = 1
    distLbl.Size  = UDim2.new(1, 0, 0, 14)
    distLbl.Position = UDim2.new(0, 0, 0, 36)
    distLbl.Font  = Enum.Font.Gotham
    distLbl.TextSize = 10
    distLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    distLbl.TextStrokeTransparency = 0
    distLbl.TextStrokeColor3 = Color3.new(0,0,0)
    distLbl.Text  = "0 m"

    return g
end

local function applyESP(pl)
    if pl == LocalPlayer then return end
    local c = pl.Character
    if not (c and aliveObj(c)) then return end

    local role   = getRole(pl)
    local isSurv = (role == "Survivor")
    local isKill = (role == "Killer")

    -- Check if this role's ESP is enabled
    local enabled = (isSurv and States.EspSurvivor) or (isKill and States.EspKiller)

    if not enabled then
        -- Remove any existing ESP for this player
        local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
        local head = c:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("ESP_Tag"); if tag then tag:Destroy() end
            local dot = head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
        end
        return
    end

    local col
    if States.RainbowESP then
        col = Color3.fromHSV(rainbowT % 1, 1, 1)
    else
        col = isKill and C.KILLER or C.SURVIVOR
    end

    -- Highlight / box
    if States.EspBox then
        local hl = c:FindFirstChild("ESP_HL")
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name     = "ESP_HL"
            hl.Adornee  = c
            hl.FillTransparency   = 0.55
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent   = c
        end
        hl.FillColor    = col
        hl.OutlineColor = col
    else
        local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
    end

    local head = c:FindFirstChild("Head")
    if not (head and aliveObj(head)) then return end

    -- Head dot
    if States.EspHeadDot then
        if not head:FindFirstChild("ESP_Dot") then
            local bb = Instance.new("BillboardGui"); bb.Name = "ESP_Dot"
            bb.AlwaysOnTop = true; bb.Size = UDim2.new(0,10,0,10)
            bb.StudsOffset = Vector3.new(0,0.7,0); bb.Parent = head
            local fr = Instance.new("Frame", bb)
            fr.Size = UDim2.new(1,0,1,0); fr.BackgroundColor3 = col
            fr.BorderSizePixel = 0; Instance.new("UICorner",fr).CornerRadius=UDim.new(1,0)
        end
    else
        local dot = head:FindFirstChild("ESP_Dot"); if dot then dot:Destroy() end
    end

    -- Info tag
    local tag = head:FindFirstChild("ESP_Tag")
    if not tag then tag = makeESPTag(pl.Name, role); tag.Parent = head end

    local nl = tag:FindFirstChild("NL")
    if nl then nl.Visible = States.EspName; nl.TextColor3 = col end

    local hum = c:FindFirstChildOfClass("Humanoid")
    local hl2 = tag:FindFirstChild("HL")
    if hl2 then
        hl2.Visible = States.EspHP
        if hum and hum.Parent then
            hl2.Text = "HP  " .. math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
        end
    end

    local myChar = LocalPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local hrp    = c:FindFirstChild("HumanoidRootPart")
    local dl     = tag:FindFirstChild("DL")
    if dl then
        dl.Visible = States.EspDist
        if myHRP and hrp and hrp.Parent then
            dl.Text = math.floor((hrp.Position - myHRP.Position).Magnitude) .. " m"
        end
    end

    -- Tracer
    if States.EspTracer then
        pcall(function()
            if not rawget(_G, "Drawing") then return end
            local hrp2 = c:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
            local mh   = myChar and myChar:FindFirstChild("HumanoidRootPart"); if not mh then return end
            local line = Drawing.new("Line")
            local fp   = Camera:WorldToViewportPoint(mh.Position)
            local tp   = Camera:WorldToViewportPoint(hrp2.Position)
            line.Visible = true; line.Color = col; line.Thickness = 1
            line.From = Vector2.new(fp.X, fp.Y)
            line.To   = Vector2.new(tp.X, tp.Y)
            task.delay(0.05, function() pcall(function() line:Remove() end) end)
        end)
    end
end

local function startESP()
    if espLoop then espLoop:Disconnect(); espLoop = nil end
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
    if espLoop then espLoop:Disconnect(); espLoop = nil end
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
    for _, conns in pairs(espConns) do
        for _, cn in pairs(conns) do pcall(function() cn:Disconnect() end) end
    end
    espConns = {}
end

local function refreshESP()
    local anyESP = States.EspSurvivor or States.EspKiller
    if anyESP then
        startESP()
    else
        stopAllESP()
    end
end

-- ─── ESP GENERATOR ──────────────────────────────────────────
local genHL = {}; local genLoop = nil

local function getGenProg(gen)
    local v = gen:GetAttribute("RepairProgress")
    if v then return (v<=1) and math.floor(v*100) or math.min(math.floor(v),100) end
    return 0
end

local function buildGenESP()
    for _, d in pairs(genHL) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end
    genHL = {}
    local map = WS:FindFirstChild("Map") or WS:FindFirstChild("Map1")
    if not map then return end
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local prog = getGenProg(obj)
                local col  = prog >= 100 and C.GEN_B or C.GEN_A
                local hl   = Instance.new("Highlight")
                hl.FillColor = col; hl.OutlineColor = col
                hl.FillTransparency = 0.6; hl.OutlineTransparency = 0
                hl.Adornee = obj; hl.Parent = obj
                local bb = Instance.new("BillboardGui")
                bb.AlwaysOnTop = true; bb.Size = UDim2.new(0,130,0,30)
                bb.StudsOffset = Vector3.new(0,4,0); bb.Adornee = part; bb.Parent = part
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
                lbl.Text = "GEN  " .. prog .. "%"; lbl.TextColor3 = col
                lbl.TextStrokeTransparency = 0; lbl.TextStrokeColor3 = Color3.new(0,0,0)
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
                local prog = getGenProg(gen)
                local col  = prog >= 100 and C.GEN_B or C.GEN_A
                if d.hl  then d.hl.FillColor = col; d.hl.OutlineColor = col end
                if d.lbl then d.lbl.Text = "GEN  " .. prog .. "%"; d.lbl.TextColor3 = col end
            else
                pcall(function() if d.hl then d.hl:Destroy() end end)
                pcall(function() if d.bb then d.bb:Destroy() end end)
                genHL[gen] = nil
            end
        end
    end)
end

local function stopGenESP()
    if genLoop then genLoop:Disconnect(); genLoop = nil end
    for _, d in pairs(genHL) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end
    genHL = {}
end

-- ─── PALLET ESP ─────────────────────────────────────────────
local palReg = {}; local palLoop = nil

local function findPallets()
    for _, e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg = {}
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "Palletwrong" or obj.Name:lower():find("pallet")) then
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
                    local h = Instance.new("Highlight")
                    h.Adornee = model; h.FillTransparency = 1
                    h.OutlineColor = C.PALLET; h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = model; entry.hl = h
                end
            else
                pcall(function() if entry.hl then entry.hl:Destroy() end end)
                palReg[model] = nil
            end
        end
    end)
end

local function stopPalletESP()
    if palLoop then palLoop:Disconnect(); palLoop = nil end
    for _, e in pairs(palReg) do pcall(function() if e.hl then e.hl:Destroy() end end) end
    palReg = {}
end

-- ─── AIMBOT ─────────────────────────────────────────────────
local aimConn = nil; local fovCircle = nil

local function drawFOV(r)
    pcall(function()
        if fovCircle then fovCircle:Remove(); fovCircle = nil end
        if not r or r <= 0 then return end
        if not rawget(_G, "Drawing") then return end
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true; fovCircle.Radius = r
        fovCircle.Color = C.ACCENT; fovCircle.Thickness = 1
        fovCircle.Filled = false; fovCircle.NumSides = 64
        local vp = Camera.ViewportSize
        fovCircle.Position = Vector2.new(vp.X/2, vp.Y/2)
    end)
end

local function getBodyPart(char, bone)
    if bone == "head" then return char:FindFirstChild("Head") end
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
end

local function startAimbot()
    aimConn = RunService.Heartbeat:Connect(function()
        if not States.Aimbot then return end
        local best = nil; local bestD = math.huge
        local vp = Camera.ViewportSize; local cx, cy = vp.X/2, vp.Y/2
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character then
                if States.AimbotTeam and getRole(pl) == getRole(LocalPlayer) then
                    -- skip teammates
                else
                    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, onSc = Camera:WorldToViewportPoint(hrp.Position)
                        if onSc then
                            local d = ((pos.X-cx)^2 + (pos.Y-cy)^2)^0.5
                            if d < States.AimbotFOV and d < bestD then bestD = d; best = pl end
                        end
                    end
                end
            end
        end
        if best and best.Character then
            local part = getBodyPart(best.Character, States.AimbotBone)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end)
end

local function stopAimbot()
    if aimConn then aimConn:Disconnect(); aimConn = nil end
    pcall(function() if fovCircle then fovCircle:Remove(); fovCircle = nil end end)
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then Camera.CameraSubject = hum end
    end
end

-- ─── PLAYER MODS ────────────────────────────────────────────
local noClipConn = nil; local flyConn = nil; local flyBV = nil
local godConn = nil; local antiKnockConn = nil; local infJumpConn = nil

local function startNoClip()
    noClipConn = RunService.Heartbeat:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end
local function stopNoClip()
    if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
    local c = LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = true end
    end
end

local function startFly()
    local c = LocalPlayer.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.PlatformStand = true
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.Velocity = Vector3.new(0,0,0); flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyConn = RunService.Heartbeat:Connect(function()
        local dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl)  then dir = dir - Vector3.new(0,1,0) end
        if flyBV and flyBV.Parent then
            flyBV.Velocity = (dir.Magnitude > 0) and dir.Unit * 50 or Vector3.new(0,0,0)
        end
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV   then flyBV:Destroy(); flyBV = nil end
    local c = LocalPlayer.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand = false end
end

local function startGod()
    godConn = RunService.Heartbeat:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
end
local function stopGod()
    if godConn then godConn:Disconnect(); godConn = nil end
end

local function startInfJump()
    infJumpConn = UIS.JumpRequest:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
end

local function startAntiKnock()
    antiKnockConn = RunService.Heartbeat:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.AssemblyLinearVelocity = Vector3.new(
            hrp.AssemblyLinearVelocity.X * 0.1,
            hrp.AssemblyLinearVelocity.Y,
            hrp.AssemblyLinearVelocity.Z * 0.1)
    end)
end
local function stopAntiKnock()
    if antiKnockConn then antiKnockConn:Disconnect(); antiKnockConn = nil end
end

local function applyWalkSpeed(v)
    local c = LocalPlayer.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed = States.WalkSpeedOn and v or 16
end
local function applyJumpPower(v)
    local c = LocalPlayer.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.JumpPower = v
end

-- ─── VISUAL ─────────────────────────────────────────────────
local origAmb  = Lighting.Ambient
local origBri  = Lighting.Brightness
local origFog  = Lighting.FogEnd
local chamsConn = nil
local crosshairGui = nil

local function setFullBright(on)
    if on then Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.Brightness=2
    else       Lighting.Ambient=origAmb; Lighting.Brightness=origBri end
end
local function setNoFog(on) Lighting.FogEnd = on and 1e6 or origFog end
local function setCrosshair(on)
    if crosshairGui then crosshairGui:Destroy(); crosshairGui=nil end
    if not on then return end
    local sg = Instance.new("ScreenGui")
    sg.Name="VD_Crosshair"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.Parent=PlayerGui
    crosshairGui = sg
    local ch = Instance.new("Frame",sg)
    ch.AnchorPoint=Vector2.new(0.5,0.5); ch.Position=UDim2.new(0.5,0,0.5,0)
    ch.Size=UDim2.new(0,22,0,22); ch.BackgroundTransparency=1
    local function L(w,h)
        local f=Instance.new("Frame",ch); f.AnchorPoint=Vector2.new(0.5,0.5)
        f.Position=UDim2.new(0.5,0,0.5,0); f.Size=UDim2.new(0,w,0,h)
        f.BackgroundColor3=C.ACCENT; f.BorderSizePixel=0
    end
    L(2,16); L(16,2)
end
local function setChams(on)
    if chamsConn then chamsConn:Disconnect(); chamsConn=nil end
    if on then
        chamsConn = RunService.Heartbeat:Connect(function()
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer and pl.Character then
                    for _, p in ipairs(pl.Character:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Material = Enum.Material.Neon
                            p.Color = (getRole(pl)=="Killer") and C.KILLER or C.SURVIVOR
                        end
                    end
                end
            end
        end)
    end
end

-- ─── UTILITY ────────────────────────────────────────────────
local afkConn = nil; local fpsObjs = {}

local function setAntiAFK(on)
    if afkConn then afkConn:Disconnect(); afkConn=nil end
    if on then
        local t=0
        afkConn = RunService.Heartbeat:Connect(function(dt)
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
                obj.Enabled = false; table.insert(fpsObjs, obj)
            end
        end
        Lighting.GlobalShadows = false
    else
        for _, obj in ipairs(fpsObjs) do pcall(function() obj.Enabled=true end) end
        fpsObjs = {}; Lighting.GlobalShadows = true
    end
end

local function tpToPlayer(target)
    if not (target and target.Character) then return end
    local c = LocalPlayer.Character; if not c then return end
    local hrp  = c:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and thrp then hrp.CFrame = thrp.CFrame * CFrame.new(0,0,3) end
end

local function serverHop()
    pcall(function()
        local id = game.PlaceId
        local ok, res = pcall(function()
            return game:GetService("HttpService"):JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..id.."/servers/Public?limit=10"))
        end)
        local servers = {}
        if ok and res and res.data then
            for _, s in ipairs(res.data) do
                if s.id ~= game.JobId and (s.maxPlayers-s.playing) > 0 then
                    table.insert(servers, s.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(id, servers[math.random(1,#servers)], LocalPlayer)
        end
    end)
end

local function rejoin()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

local specConn = nil
local function startSpectate(target)
    if specConn then specConn:Disconnect(); specConn=nil end
    if not target then pcall(function() Camera.CameraType=Enum.CameraType.Custom end); return end
    pcall(function() Camera.CameraType = Enum.CameraType.Scriptable end)
    specConn = RunService.Heartbeat:Connect(function()
        if not (target and target.Character) then
            pcall(function() Camera.CameraType=Enum.CameraType.Custom end)
            specConn:Disconnect(); return
        end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then Camera.CFrame = CFrame.new(hrp.Position+Vector3.new(0,5,-8), hrp.Position) end
    end)
end

-- ============================================================
-- ══════════════ BUILD ESP PAGE ══════════════
-- ============================================================
SectionLabel(EspPage, "PLAYER ESP", 1)

-- Survivor ESP (separate toggle)
local survivorRow = Instance.new("Frame", EspPage)
survivorRow.Size             = UDim2.new(1, 0, 0, 42)
survivorRow.BackgroundColor3 = Color3.fromRGB(18, 30, 20)
survivorRow.BorderSizePixel  = 0
survivorRow.LayoutOrder      = 2
Instance.new("UICorner", survivorRow).CornerRadius = UDim.new(0, 8)
local survStroke = Instance.new("UIStroke", survivorRow)
survStroke.Color = C.SURVIVOR; survStroke.Thickness = 1; survStroke.Transparency = 0.5

local survL = Instance.new("TextLabel", survivorRow)
survL.Text          = "Survivor ESP"
survL.Size          = UDim2.new(1,-70,1,0); survL.Position = UDim2.new(0,14,0,0)
survL.TextColor3    = C.SURVIVOR; survL.Font = Enum.Font.GothamBold; survL.TextSize = 12
survL.BackgroundTransparency = 1; survL.TextXAlignment = Enum.TextXAlignment.Left

local survTrack = Instance.new("TextButton", survivorRow)
survTrack.Size             = UDim2.new(0,44,0,23); survTrack.Position = UDim2.new(1,-55,0.5,-11)
survTrack.BackgroundColor3 = C.OFF; survTrack.Text = ""; survTrack.BorderSizePixel = 0
Instance.new("UICorner", survTrack).CornerRadius = UDim.new(1,0)
local survKnob = Instance.new("Frame", survTrack)
survKnob.Size = UDim2.new(0,17,0,17); survKnob.Position = UDim2.new(0,3,0.5,-8)
survKnob.BackgroundColor3 = C.TEXT_A; survKnob.BorderSizePixel = 0
Instance.new("UICorner", survKnob).CornerRadius = UDim.new(1,0)

survTrack.MouseButton1Click:Connect(function()
    States.EspSurvivor = not States.EspSurvivor
    local on = States.EspSurvivor
    tw(survTrack, {BackgroundColor3 = on and C.SURVIVOR or C.OFF})
    tw(survKnob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    refreshESP()
end)

-- Killer ESP (separate toggle)
local killerRow = Instance.new("Frame", EspPage)
killerRow.Size             = UDim2.new(1, 0, 0, 42)
killerRow.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
killerRow.BorderSizePixel  = 0
killerRow.LayoutOrder      = 3
Instance.new("UICorner", killerRow).CornerRadius = UDim.new(0, 8)
local killStroke = Instance.new("UIStroke", killerRow)
killStroke.Color = C.KILLER; killStroke.Thickness = 1; killStroke.Transparency = 0.5

local killL = Instance.new("TextLabel", killerRow)
killL.Text          = "Killer ESP"
killL.Size          = UDim2.new(1,-70,1,0); killL.Position = UDim2.new(0,14,0,0)
killL.TextColor3    = C.KILLER; killL.Font = Enum.Font.GothamBold; killL.TextSize = 12
killL.BackgroundTransparency = 1; killL.TextXAlignment = Enum.TextXAlignment.Left

local killTrack = Instance.new("TextButton", killerRow)
killTrack.Size             = UDim2.new(0,44,0,23); killTrack.Position = UDim2.new(1,-55,0.5,-11)
killTrack.BackgroundColor3 = C.OFF; killTrack.Text = ""; killTrack.BorderSizePixel = 0
Instance.new("UICorner", killTrack).CornerRadius = UDim.new(1,0)
local killKnob = Instance.new("Frame", killTrack)
killKnob.Size = UDim2.new(0,17,0,17); killKnob.Position = UDim2.new(0,3,0.5,-8)
killKnob.BackgroundColor3 = C.TEXT_A; killKnob.BorderSizePixel = 0
Instance.new("UICorner", killKnob).CornerRadius = UDim.new(1,0)

killTrack.MouseButton1Click:Connect(function()
    States.EspKiller = not States.EspKiller
    local on = States.EspKiller
    tw(killTrack, {BackgroundColor3 = on and C.KILLER or C.OFF})
    tw(killKnob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    refreshESP()
end)

-- ESP display options (multi-select)
CreateExpandSection(EspPage, "Display Options", {
    {Name="Show Name",    Default=true,  Callback=function(s) States.EspName=s end},
    {Name="Show HP",      Default=true,  Callback=function(s) States.EspHP=s end},
    {Name="Show Distance",Default=true,  Callback=function(s) States.EspDist=s end},
    {Name="Box Highlight",Default=true,  Callback=function(s) States.EspBox=s
        if not s then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl.Character then
                    local hl = pl.Character:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
                end
            end
        end
    end},
    {Name="Head Dot",     Default=false, Callback=function(s) States.EspHeadDot=s end},
    {Name="Tracer Line",  Default=false, Callback=function(s) States.EspTracer=s end},
    {Name="Rainbow Mode", Default=false, Callback=function(s) States.RainbowESP=s end},
}, "multi", 4)

SectionLabel(EspPage, "WORLD ESP", 10)

CreateToggle(EspPage, "Generator ESP  (progress %)", false, function(s)
    States.EspGenerator = s
    if s then startGenESP() else stopGenESP() end
end, 11)

CreateToggle(EspPage, "Pallet ESP", false, function(s)
    States.PalletEsp = s
    if s then startPalletESP() else stopPalletESP() end
end, 12)

-- ============================================================
-- ══════════════ BUILD AIMBOT PAGE ══════════════
-- ============================================================
SectionLabel(AimPage, "AIM ASSIST", 1)

CreateToggle(AimPage, "Aimbot", false, function(s)
    States.Aimbot = s
    if s then startAimbot() else stopAimbot() end
end, 2)

CreateToggle(AimPage, "Team Check  (skip same team)", true, function(s)
    States.AimbotTeam = s
end, 3)

-- Target bone — radio (only 1)
CreateExpandSection(AimPage, "Target Bone", {
    {Name="Head",         Default=false, Callback=function(s) if s then States.AimbotBone="head" end end},
    {Name="Body  (default)",Default=true,Callback=function(s) if s then States.AimbotBone="body" end end},
}, "radio", 4)

-- FOV — radio
CreateExpandSection(AimPage, "FOV Circle", {
    {Name="Small   (60)",  Default=false, Callback=function(s) if s then States.AimbotFOV=60;  drawFOV(60)  end end},
    {Name="Medium  (100)", Default=true,  Callback=function(s) if s then States.AimbotFOV=100; drawFOV(100) end end},
    {Name="Large   (200)", Default=false, Callback=function(s) if s then States.AimbotFOV=200; drawFOV(200) end end},
    {Name="Off",           Default=false, Callback=function(s) if s then drawFOV(0) end end},
}, "radio", 5)

-- ============================================================
-- ══════════════ BUILD PLAYER PAGE ══════════════
-- ============================================================
SectionLabel(PlrPage, "CHARACTER", 1)

-- WalkSpeed: toggle + slider in one block
local wsBlock = Instance.new("Frame", PlrPage)
wsBlock.Size             = UDim2.new(1, 0, 0, 96)
wsBlock.BackgroundColor3 = C.CARD
wsBlock.BorderSizePixel  = 0
wsBlock.LayoutOrder      = 2
Instance.new("UICorner", wsBlock).CornerRadius = UDim.new(0, 8)

-- Toggle row inside block
local wsToggleRow = Instance.new("Frame", wsBlock)
wsToggleRow.Size             = UDim2.new(1, 0, 0, 42)
wsToggleRow.BackgroundTransparency = 1

local wsLbl = Instance.new("TextLabel", wsToggleRow)
wsLbl.Text          = "Walk Speed"
wsLbl.Size          = UDim2.new(1,-70,1,0); wsLbl.Position = UDim2.new(0,14,0,0)
wsLbl.TextColor3    = C.TEXT_A; wsLbl.Font = Enum.Font.GothamMedium; wsLbl.TextSize = 12
wsLbl.BackgroundTransparency = 1; wsLbl.TextXAlignment = Enum.TextXAlignment.Left

local wsTrack = Instance.new("TextButton", wsToggleRow)
wsTrack.Size             = UDim2.new(0,44,0,23); wsTrack.Position = UDim2.new(1,-55,0.5,-11)
wsTrack.BackgroundColor3 = C.OFF; wsTrack.Text = ""; wsTrack.BorderSizePixel = 0
Instance.new("UICorner", wsTrack).CornerRadius = UDim.new(1,0)
local wsKnob = Instance.new("Frame", wsTrack)
wsKnob.Size = UDim2.new(0,17,0,17); wsKnob.Position = UDim2.new(0,3,0.5,-8)
wsKnob.BackgroundColor3 = C.TEXT_A; wsKnob.BorderSizePixel = 0
Instance.new("UICorner", wsKnob).CornerRadius = UDim.new(1,0)

wsTrack.MouseButton1Click:Connect(function()
    States.WalkSpeedOn = not States.WalkSpeedOn
    local on = States.WalkSpeedOn
    tw(wsTrack, {BackgroundColor3 = on and C.ACCENT or C.OFF})
    tw(wsKnob,  {Position = on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,3,0.5,-8)})
    applyWalkSpeed(States.WalkSpeed)
end)

-- Divider
local wsDivider = Instance.new("Frame", wsBlock)
wsDivider.Size             = UDim2.new(1,-24,0,1)
wsDivider.Position         = UDim2.new(0,12,0,42)
wsDivider.BackgroundColor3 = C.DIV; wsDivider.BorderSizePixel = 0

-- Slider inside block
local wsValLbl = Instance.new("TextLabel", wsBlock)
wsValLbl.Text         = tostring(States.WalkSpeed)
wsValLbl.Size         = UDim2.new(0,40,0,20); wsValLbl.Position = UDim2.new(1,-54,0,50)
wsValLbl.TextColor3   = C.ACCENT; wsValLbl.Font = Enum.Font.GothamBold; wsValLbl.TextSize = 12
wsValLbl.BackgroundTransparency = 1; wsValLbl.TextXAlignment = Enum.TextXAlignment.Right

local wsSLbl = Instance.new("TextLabel", wsBlock)
wsSLbl.Text         = "Speed"
wsSLbl.Size         = UDim2.new(0.4,0,0,20); wsSLbl.Position = UDim2.new(0,14,0,50)
wsSLbl.TextColor3   = C.TEXT_B; wsSLbl.Font = Enum.Font.Gotham; wsSLbl.TextSize = 11
wsSLbl.BackgroundTransparency = 1; wsSLbl.TextXAlignment = Enum.TextXAlignment.Left

local wsSliderTrack = Instance.new("Frame", wsBlock)
wsSliderTrack.Size             = UDim2.new(1,-24,0,5); wsSliderTrack.Position = UDim2.new(0,12,0,78)
wsSliderTrack.BackgroundColor3 = C.OFF; wsSliderTrack.BorderSizePixel = 0
Instance.new("UICorner", wsSliderTrack).CornerRadius = UDim.new(1,0)
local wsDefPct = (States.WalkSpeed - 4) / (200 - 4)
local wsSliderFill = Instance.new("Frame", wsSliderTrack)
wsSliderFill.Size = UDim2.new(wsDefPct,0,1,0); wsSliderFill.BackgroundColor3 = C.ACCENT
wsSliderFill.BorderSizePixel = 0; Instance.new("UICorner", wsSliderFill).CornerRadius = UDim.new(1,0)
local wsSliderKnob = Instance.new("TextButton", wsSliderTrack)
wsSliderKnob.Size = UDim2.new(0,14,0,14); wsSliderKnob.AnchorPoint = Vector2.new(0.5,0.5)
wsSliderKnob.Position = UDim2.new(wsDefPct,0,0.5,0); wsSliderKnob.BackgroundColor3 = C.TEXT_A
wsSliderKnob.Text = ""; wsSliderKnob.BorderSizePixel = 0
Instance.new("UICorner", wsSliderKnob).CornerRadius = UDim.new(1,0)

do
    local sliding = false
    wsSliderKnob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local rel = math.clamp((i.Position.X - wsSliderTrack.AbsolutePosition.X) / wsSliderTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(4 + (200-4)*rel)
        States.WalkSpeed = val
        wsSliderFill.Size = UDim2.new(rel,0,1,0)
        wsSliderKnob.Position = UDim2.new(rel,0,0.5,0)
        wsValLbl.Text = tostring(val)
        if States.WalkSpeedOn then applyWalkSpeed(val) end
    end)
end

CreateSlider(PlrPage, "Jump Power", 0, 200, 50, function(v)
    States.JumpPower = v; applyJumpPower(v)
end, 3)

CreateToggle(PlrPage, "Infinite Jump", false, function(s)
    States.InfJump = s
    if s then startInfJump() else stopInfJump() end
end, 4)

CreateToggle(PlrPage, "No Clip", false, function(s)
    States.NoClip = s
    if s then startNoClip() else stopNoClip() end
end, 5)

CreateToggle(PlrPage, "Fly Mode  (W/A/S/D + Space/Ctrl)", false, function(s)
    States.FlyMode = s
    if s then startFly() else stopFly() end
end, 6)

CreateToggle(PlrPage, "God Mode", false, function(s)
    States.GodMode = s
    if s then startGod() else stopGod() end
end, 7)

CreateToggle(PlrPage, "Anti Knockback", false, function(s)
    States.AntiKnock = s
    if s then startAntiKnock() else stopAntiKnock() end
end, 8)

-- ============================================================
-- ══════════════ BUILD VISUAL PAGE ══════════════
-- ============================================================
SectionLabel(VisPage, "VISUALS", 1)

CreateToggle(VisPage, "Full Bright", false, function(s) States.FullBright=s; setFullBright(s) end, 2)
CreateToggle(VisPage, "Remove Fog",  false, function(s) States.NoFog=s;      setNoFog(s) end, 3)
CreateToggle(VisPage, "Crosshair",   false, function(s) States.Crosshair=s;  setCrosshair(s) end, 4)
CreateToggle(VisPage, "Chams",       false, function(s) States.Chams=s;      setChams(s) end, 5)

-- Time mode — radio
CreateExpandSection(VisPage, "Time of Day", {
    {Name="Day",     Default=false, Callback=function(s) if s then Lighting.ClockTime=14 end end},
    {Name="Night",   Default=false, Callback=function(s) if s then Lighting.ClockTime=0  end end},
    {Name="Dusk",    Default=false, Callback=function(s) if s then Lighting.ClockTime=18 end end},
}, "radio", 6)

-- FOV preset — radio
CreateExpandSection(VisPage, "Field of View", {
    {Name="Normal  (70)",  Default=false, Callback=function(s) if s then Camera.FieldOfView=70  end end},
    {Name="Wide    (100)", Default=false, Callback=function(s) if s then Camera.FieldOfView=100 end end},
    {Name="Super   (120)", Default=false, Callback=function(s) if s then Camera.FieldOfView=120 end end},
}, "radio", 7)

-- ============================================================
-- ══════════════ BUILD UTILITY PAGE ══════════════
-- ============================================================
SectionLabel(UtlPage, "TOOLS", 1)

CreateToggle(UtlPage, "Anti AFK",    false, function(s) States.AntiAFK=s;   setAntiAFK(s)  end, 2)
CreateToggle(UtlPage, "FPS Boost",   false, function(s) States.FPSBoost=s;  setFPSBoost(s) end, 3)
CreateToggle(UtlPage, "Free Camera", false, function(s)
    Camera.CameraType = s and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end, 4)

SectionLabel(UtlPage, "TELEPORT", 5)

-- TP to Killer (direct button)
local tpKillBtn = Instance.new("TextButton", UtlPage)
tpKillBtn.Size             = UDim2.new(1, 0, 0, 38)
tpKillBtn.BackgroundColor3 = Color3.fromRGB(36, 14, 14)
tpKillBtn.Text             = ""
tpKillBtn.BorderSizePixel  = 0
tpKillBtn.LayoutOrder      = 6
Instance.new("UICorner", tpKillBtn).CornerRadius = UDim.new(0, 8)
local tkStroke = Instance.new("UIStroke", tpKillBtn)
tkStroke.Color = C.KILLER; tkStroke.Thickness = 1; tkStroke.Transparency = 0.5
local tkLbl = Instance.new("TextLabel", tpKillBtn)
tkLbl.Text = "Teleport to Killer"
tkLbl.Size = UDim2.new(1,-14,1,0); tkLbl.Position = UDim2.new(0,14,0,0)
tkLbl.TextColor3 = C.KILLER; tkLbl.Font = Enum.Font.GothamBold; tkLbl.TextSize = 12
tkLbl.BackgroundTransparency = 1; tkLbl.TextXAlignment = Enum.TextXAlignment.Left
tpKillBtn.MouseButton1Click:Connect(function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and getRole(pl) == "Killer" then tpToPlayer(pl); return end
    end
end)

-- TP to player list
CreateExpandSection(UtlPage, "Teleport to Player", (function()
    local list = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local cap = pl
            table.insert(list, {Name=pl.Name .. "  [" .. getRole(pl) .. "]",
                Callback=function(s) if s then tpToPlayer(cap) end end})
        end
    end
    if #list == 0 then list = {{Name="No other players", Callback=function() end}} end
    return list
end)(), "multi", 7)

-- Spectate
CreateExpandSection(UtlPage, "Spectate Player", (function()
    local list = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local cap = pl
            table.insert(list, {Name=pl.Name,
                Callback=function(s) startSpectate(s and cap or nil) end})
        end
    end
    if #list == 0 then list = {{Name="No other players", Callback=function() end}} end
    return list
end)(), "radio", 8)

SectionLabel(UtlPage, "SERVER", 10)
CreateActionBtn(UtlPage, "Server Hop  (find new server)", serverHop, 11)
CreateActionBtn(UtlPage, "Rejoin",                         rejoin,    12)

-- ============================================================
-- ══════════════ BUILD SETTINGS PAGE ══════════════
-- ============================================================
SectionLabel(SetPage, "ICON", 1)

CreatePillSelector(SetPage, "Size", {
    {label="Small",  value="sm",  default=false},
    {label="Normal", value="md",  default=true },
    {label="Large",  value="lg",  default=false},
}, function(v)
    local s = {sm=36, md=48, lg=68}
    tw(OpenBtn, {Size = UDim2.new(0,s[v],0,s[v])})
end, 2)

CreatePillSelector(SetPage, "Shape", {
    {label="Circle",  value="circle",  default=true },
    {label="Rounded", value="rounded", default=false},
    {label="Square",  value="square",  default=false},
}, function(v)
    local r = {circle=UDim.new(1,0), rounded=UDim.new(0,10), square=UDim.new(0,2)}
    _oc.CornerRadius = r[v]
end, 3)

CreatePillSelector(SetPage, "Color", {
    {label="Dark",   value="dk", default=true },
    {label="Orange", value="or", default=false},
    {label="Blue",   value="bl", default=false},
    {label="Purple", value="pu", default=false},
}, function(v)
    local cols = {dk=Color3.fromRGB(22,22,22), or_=Color3.fromRGB(180,80,0), bl=Color3.fromRGB(0,90,210), pu=Color3.fromRGB(110,0,200)}
    local map  = {dk="dk", or_="or", bl="bl", pu="pu"}
    local c2   = {dk=Color3.fromRGB(22,22,22), or=Color3.fromRGB(180,80,0), bl=Color3.fromRGB(0,90,210), pu=Color3.fromRGB(110,0,200)}
    tw(OpenBtn, {BackgroundColor3 = c2[v] or Color3.fromRGB(22,22,22)})
end, 4)

SectionLabel(SetPage, "WINDOW", 8)

CreatePillSelector(SetPage, "Accent Color", {
    {label="Orange", value="or", default=true },
    {label="Cyan",   value="cy", default=false},
    {label="Green",  value="gr", default=false},
}, function(v)
    local cols = {or_=Color3.fromRGB(232,137,12), cy=Color3.fromRGB(0,200,230), gr=Color3.fromRGB(60,200,80)}
    local c2   = {or=Color3.fromRGB(232,137,12),  cy=Color3.fromRGB(0,200,230), gr=Color3.fromRGB(60,200,80)}
    local newC = c2[v] or Color3.fromRGB(232,137,12)
    C.ACCENT = newC
    _ms.Color = C.DIV; _os.Color = newC
    TitleLabel.TextColor3 = newC
end, 9)

-- ============================================================
-- ENSURE GUI (survive respawn/teleport)
-- ============================================================
local function ensureGUI()
    if not ScreenGui or not ScreenGui.Parent then ScreenGui.Parent = getPlayerGui() end
end
RunService.Heartbeat:Connect(ensureGUI)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1); ensureGUI()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = States.WalkSpeedOn and States.WalkSpeed or 16
        hum.JumpPower = States.JumpPower
    end
    if States.EspSurvivor or States.EspKiller then
        stopAllESP(); task.wait(0.1); startESP()
    end
    if States.EspGenerator then stopGenESP(); task.wait(0.1); startGenESP() end
    if States.GodMode      then stopGod();    task.wait(0.1); startGod()    end
    if States.InfJump      then stopInfJump();task.wait(0.1); startInfJump()end
    if States.AntiKnock    then stopAntiKnock();task.wait(0.1);startAntiKnock() end
    if States.NoClip       then startNoClip() end
end)

WS.ChildAdded:Connect(function(child)
    if (child.Name=="Map" or child.Name=="Map1") and States.PalletEsp then
        task.wait(3); findPallets()
    end
end)
task.delay(2, findPallets)

print("[VD v11.0] Loaded — Saycho")
