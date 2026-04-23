--[[
    PROJECT: VD (Violence District) - PLATINUM EDITION
    VERSION: 5.3 (Full Fix + Dropdown Settings + Complete UI)
    BY: Saycho
    FIXED BY: Claude
    - Fix: Tombol dropdown tidak bisa diklik (InputBegan -> Activated)
    - Fix: AddTab syntax error (bt -> btn)
    - Fix: SetPage tidak dibuat sebelum dipanggil
    - Add: Settings dengan dropdown pilihan (Icon Size, Shape, Color, dll)
    - Add: Minimize button & OpenBtn logic lengkap
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Cleanup sebelumnya
if CoreGui:FindFirstChild("VD_Saycho_Official") then
    CoreGui.VD_Saycho_Official:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VD_Saycho_Official"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- GLOBAL STATES
-- ==========================================
local States = {
    AutoHeal = false,
    Moonwalk = false,
    NoCD = false,
    EspEnabled = false,
    EspName = false,
    EspHP = false,
    AutoRepair = false,
    FastVault = false,
    FastGen = false,
    AutoLever = false,
    AutoGenerator = false,
    LockedDirection = Vector3.new(0, 0, 0)
}

-- ==========================================
-- UTILITY: DRAGGING
-- ==========================================
local function MakeDraggable(obj, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
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

-- ==========================================
-- FLOATING ICON (MINIMIZE BUTTON)
-- ==========================================
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name = "LynxxIcon"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Image = "rbxassetid://15125301131"
OpenBtn.Visible = false
OpenBtn.ZIndex = 10

local LogoCorner = Instance.new("UICorner", OpenBtn)
LogoCorner.CornerRadius = UDim.new(1, 0)

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN FRAME
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Grip (drag bar atas tengah)
local TopGrip = Instance.new("Frame", MainFrame)
TopGrip.Size = UDim2.new(0, 40, 0, 3)
TopGrip.Position = UDim2.new(0.5, -20, 0, 8)
TopGrip.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TopGrip.BorderSizePixel = 0
Instance.new("UICorner", TopGrip)
MakeDraggable(MainFrame, TopGrip)

-- Header area
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local LynxxTitle = Instance.new("TextLabel", Header)
LynxxTitle.Text = "Lynxx 🪐"
LynxxTitle.Position = UDim2.new(0, 15, 0, 15)
LynxxTitle.Size = UDim2.new(0, 90, 0, 22)
LynxxTitle.TextColor3 = Color3.fromRGB(255, 140, 0)
LynxxTitle.Font = "GothamBold"
LynxxTitle.TextSize = 16
LynxxTitle.BackgroundTransparency = 1
LynxxTitle.TextXAlignment = "Left"

local Sep = Instance.new("Frame", Header)
Sep.Size = UDim2.new(0, 1, 0, 20)
Sep.Position = UDim2.new(0, 110, 0, 18)
Sep.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Sep.BorderSizePixel = 0

local GameTitle = Instance.new("TextLabel", Header)
GameTitle.Text = "Violence District"
GameTitle.Position = UDim2.new(0, 120, 0, 15)
GameTitle.Size = UDim2.new(0, 160, 0, 22)
GameTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
GameTitle.Font = "GothamMedium"
GameTitle.TextSize = 13
GameTitle.BackgroundTransparency = 1
GameTitle.TextXAlignment = "Left"

-- Minimize Button
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -42, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = "GothamBold"
MinBtn.TextSize = 16
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

MinBtn.Activated:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.Activated:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Resize button (pojok kanan bawah)
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResizeBtn.Text = ""
ResizeBtn.BorderSizePixel = 0
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0, 3)

local resizing = false
ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        local startSize = MainFrame.Size
        local startPos = input.Position
        local moveCon
        moveCon = UserInputService.InputChanged:Connect(function(moveInput)
            if resizing and (
                moveInput.UserInputType == Enum.UserInputType.MouseMovement
                or moveInput.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = moveInput.Position - startPos
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

-- ==========================================
-- SIDEBAR & CONTAINER
-- ==========================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 10, 0, 55)
Sidebar.Size = UDim2.new(0, 130, 1, -65)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 4)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0, 150, 0, 55)
Container.Size = UDim2.new(1, -160, 1, -65)
Container.BackgroundTransparency = 1

-- ==========================================
-- PAGE & TAB SYSTEM
-- ==========================================
local Pages = {}
local TabButtons = {}

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name = name
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.ScrollBarThickness = 3
    pg.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
    pg.ScrollBarImageTransparency = 0.5
    pg.BorderSizePixel = 0
    pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", pg)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0, 8)
    Pages[name] = pg
    return pg
end

local function AddTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(130, 130, 130)
    btn.Font = "GothamMedium"
    btn.TextSize = 13
    btn.TextXAlignment = "Left"
    btn.BorderSizePixel = 0

    -- Indikator aktif (garis oranye kiri)
    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 3, 0, 18)
    ind.Position = UDim2.new(0, 6, 0.5, -9)
    ind.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    ind.Visible = false
    ind.BorderSizePixel = 0
    Instance.new("UICorner", ind)

    btn.Activated:Connect(function()
        -- Sembunyikan semua page
        for _, p in pairs(Pages) do p.Visible = false end
        -- Reset semua tab
        for _, tb in pairs(TabButtons) do
            tb.btn.TextColor3 = Color3.fromRGB(130, 130, 130)
            tb.ind.Visible = false
        end
        -- Aktifkan page & tab ini
        if Pages[name] then Pages[name].Visible = true end
        btn.TextColor3 = Color3.new(1, 1, 1)
        ind.Visible = true
    end)

    table.insert(TabButtons, { btn = btn, ind = ind })
    return btn, ind
end

-- Buat semua page
local SurPage  = CreatePage("Survivor")
local KilPage  = CreatePage("Killer")
local EspPage  = CreatePage("Esp")
local PlrPage  = CreatePage("Player")
local SetPage  = CreatePage("Settings")

-- Buat semua tab & aktifkan Survivor di awal
local surBtn, surInd = AddTab("Survivor")
AddTab("Killer")
AddTab("Esp")
AddTab("Player")
AddTab("Settings")

SurPage.Visible = true
surBtn.TextColor3 = Color3.new(1, 1, 1)
surInd.Visible = true

-- ==========================================
-- UI HELPER: TOGGLE BUTTON
-- ==========================================
local function CreateToggle(parent, labelText, state, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -10, 0, 45)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    Instance.new("UICorner", row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = "  " .. labelText
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = "GothamMedium"
    lbl.TextSize = 13
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = "Left"

    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0, 46, 0, 24)
    toggle.Position = UDim2.new(1, -56, 0.5, -12)
    toggle.BackgroundColor3 = state and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 50, 50)
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = state
    toggle.Activated:Connect(function()
        on = not on
        TweenService:Create(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 50, 50)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        callback(on)
    end)

    return row
end

-- ==========================================
-- UI HELPER: DROPDOWN FEATURE (FIXED)
-- ==========================================
local function AddDropdownFeature(parent, title, options_table, order)
    -- FIXED: Pakai TextButton bukan Frame agar bisa diklik
    local frame = Instance.new("TextButton", parent)
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Text = ""
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order or 0
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Text = "  " .. title
    label.Size = UDim2.new(1, -40, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = "GothamMedium"
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = "Left"

    local arrow = Instance.new("TextLabel", frame)
    arrow.Text = "▼  "
    arrow.Size = UDim2.new(0, 35, 1, 0)
    arrow.Position = UDim2.new(1, -35, 0, 0)
    arrow.TextColor3 = Color3.fromRGB(255, 140, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextXAlignment = "Right"
    arrow.Font = "GothamBold"
    arrow.TextSize = 13

    local isOpen = false
    local listFrame = Instance.new("Frame", parent)
    listFrame.Size = UDim2.new(1, -10, 0, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    listFrame.ClipsDescendants = true
    listFrame.BorderSizePixel = 0
    listFrame.LayoutOrder = (order or 0) + 0.5
    Instance.new("UICorner", listFrame)

    local ll = Instance.new("UIListLayout", listFrame)
    ll.Padding = UDim.new(0, 2)
    Instance.new("UIPadding", listFrame).PaddingTop = UDim.new(0, 4)

    local itemCount = 0

    for _, opt in pairs(options_table) do
        itemCount = itemCount + 1
        local b = Instance.new("TextButton", listFrame)
        b.Size = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        b.Text = "  " .. opt.Name
        b.TextColor3 = Color3.fromRGB(180, 180, 180)
        b.Font = "Gotham"
        b.TextSize = 12
        b.TextXAlignment = "Left"
        b.BorderSizePixel = 0

        local stateOn = false
        b.Activated:Connect(function()
            stateOn = not stateOn
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = stateOn and Color3.fromRGB(50, 35, 10) or Color3.fromRGB(35, 35, 35)
            }):Play()
            b.TextColor3 = stateOn and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(180, 180, 180)
            opt.Callback(stateOn)
        end)
    end

    local fullHeight = (itemCount * 36) + 8

    -- FIXED: Pakai Activated agar bisa diklik di mobile & PC
    frame.Activated:Connect(function()
        isOpen = not isOpen
        TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = isOpen and UDim2.new(1, -10, 0, fullHeight) or UDim2.new(1, -10, 0, 0)
        }):Play()
        arrow.Text = isOpen and "▲  " or "▼  "
    end)

    return frame, listFrame
end

-- ==========================================
-- SURVIVOR PAGE
-- ==========================================
local surHeader = Instance.new("TextLabel", SurPage)
surHeader.Text = "⚡ Survivor Features"
surHeader.Size = UDim2.new(1, -10, 0, 30)
surHeader.TextColor3 = Color3.fromRGB(255, 140, 0)
surHeader.Font = "GothamBold"
surHeader.TextSize = 14
surHeader.BackgroundTransparency = 1
surHeader.TextXAlignment = "Left"
surHeader.LayoutOrder = 0

AddDropdownFeature(SurPage, "⚙️  Generator Rush", {
    { Name = "Auto Generator Rush", Callback = function(state)
        States.AutoGenerator = state
        -- logic auto generator rush bisa ditambah di sini
    end },
    { Name = "Fast Generator", Callback = function(state)
        States.FastGen = state
    end },
    { Name = "Instant Progress", Callback = function(state)
        -- placeholder logic
    end },
}, 1)

AddDropdownFeature(SurPage, "🔧  Auto Lever", {
    { Name = "Auto Lever (All)", Callback = function(state)
        States.AutoLever = state
    end },
    { Name = "Fast Lever", Callback = function(state)
        -- placeholder
    end },
}, 2)

AddDropdownFeature(SurPage, "💊  Feature Heal", {
    { Name = "Auto Heal Self", Callback = function(state)
        States.AutoHeal = state
    end },
    { Name = "Auto Heal Others", Callback = function(state)
        -- placeholder
    end },
    { Name = "Instant Heal", Callback = function(state)
        -- placeholder
    end },
}, 3)

AddDropdownFeature(SurPage, "🏃  Movement Hacks", {
    { Name = "Fast Vault", Callback = function(state)
        States.FastVault = state
    end },
    { Name = "No Cooldown", Callback = function(state)
        States.NoCD = state
    end },
    { Name = "Moonwalk", Callback = function(state)
        States.Moonwalk = state
    end },
}, 4)

AddDropdownFeature(SurPage, "🛠️  Auto Repair", {
    { Name = "Auto Repair Objects", Callback = function(state)
        States.AutoRepair = state
    end },
}, 5)

-- ==========================================
-- KILLER PAGE
-- ==========================================
local kilHeader = Instance.new("TextLabel", KilPage)
kilHeader.Text = "🔪 Killer Features"
kilHeader.Size = UDim2.new(1, -10, 0, 30)
kilHeader.TextColor3 = Color3.fromRGB(255, 140, 0)
kilHeader.Font = "GothamBold"
kilHeader.TextSize = 14
kilHeader.BackgroundTransparency = 1
kilHeader.TextXAlignment = "Left"
kilHeader.LayoutOrder = 0

AddDropdownFeature(KilPage, "⚔️  Attack Features", {
    { Name = "Fast Attack", Callback = function(state) end },
    { Name = "One Hit (Experimental)", Callback = function(state) end },
    { Name = "No Attack Cooldown", Callback = function(state) end },
}, 1)

AddDropdownFeature(KilPage, "👁️  Tracking", {
    { Name = "Show Survivor Direction", Callback = function(state) end },
    { Name = "Snap Target (Beta)", Callback = function(state) end },
}, 2)

-- ==========================================
-- ESP PAGE
-- ==========================================
local espHeader = Instance.new("TextLabel", EspPage)
espHeader.Text = "👁️  ESP / Wallhack"
espHeader.Size = UDim2.new(1, -10, 0, 30)
espHeader.TextColor3 = Color3.fromRGB(255, 140, 0)
espHeader.Font = "GothamBold"
espHeader.TextSize = 14
espHeader.BackgroundTransparency = 1
espHeader.TextXAlignment = "Left"
espHeader.LayoutOrder = 0

CreateToggle(EspPage, "Enable ESP", false, function(state)
    States.EspEnabled = state
end, 1)

CreateToggle(EspPage, "Show Names", false, function(state)
    States.EspName = state
end, 2)

CreateToggle(EspPage, "Show HP Bar", false, function(state)
    States.EspHP = state
end, 3)

AddDropdownFeature(EspPage, "🎨  ESP Color Options", {
    { Name = "Survivors: Green", Callback = function(state) end },
    { Name = "Killers: Red", Callback = function(state) end },
    { Name = "Objects: Blue", Callback = function(state) end },
}, 4)

-- ==========================================
-- PLAYER PAGE
-- ==========================================
local plrHeader = Instance.new("TextLabel", PlrPage)
plrHeader.Text = "🧑  Player Features"
plrHeader.Size = UDim2.new(1, -10, 0, 30)
plrHeader.TextColor3 = Color3.fromRGB(255, 140, 0)
plrHeader.Font = "GothamBold"
plrHeader.TextSize = 14
plrHeader.BackgroundTransparency = 1
plrHeader.TextXAlignment = "Left"
plrHeader.LayoutOrder = 0

CreateToggle(PlrPage, "Infinite Stamina", false, function(state) end, 1)
CreateToggle(PlrPage, "Anti Stun", false, function(state) end, 2)
CreateToggle(PlrPage, "No Fall Damage", false, function(state) end, 3)
CreateToggle(PlrPage, "Speed Boost", false, function(state) end, 4)

-- ==========================================
-- SETTINGS PAGE (DROPDOWN PILIHAN)
-- ==========================================

-- Judul Settings
local setHeader = Instance.new("TextLabel", SetPage)
setHeader.Text = "⚙️  UI Settings"
setHeader.Size = UDim2.new(1, -10, 0, 30)
setHeader.TextColor3 = Color3.fromRGB(255, 140, 0)
setHeader.Font = "GothamBold"
setHeader.TextSize = 14
setHeader.BackgroundTransparency = 1
setHeader.TextXAlignment = "Left"
setHeader.LayoutOrder = 0

-- ========================================
-- DROPDOWN SETTINGS: ICON SIZE
-- ========================================
local function CreateSettingDropdown(parent, title, icon, options_list, onSelect, order)
    local titleRow = Instance.new("Frame", parent)
    titleRow.Size = UDim2.new(1, -10, 0, 22)
    titleRow.BackgroundTransparency = 1
    titleRow.LayoutOrder = order

    local titleLbl = Instance.new("TextLabel", titleRow)
    titleLbl.Text = icon .. "  " .. title
    titleLbl.Size = UDim2.new(1, 0, 1, 0)
    titleLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    titleLbl.Font = "GothamMedium"
    titleLbl.TextSize = 12
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = "Left"

    -- Container tombol-tombol pilihan (horizontal row)
    local optRow = Instance.new("Frame", parent)
    optRow.Size = UDim2.new(1, -10, 0, 38)
    optRow.BackgroundTransparency = 1
    optRow.LayoutOrder = order + 0.5

    local optLayout = Instance.new("UIListLayout", optRow)
    optLayout.FillDirection = Enum.FillDirection.Horizontal
    optLayout.Padding = UDim.new(0, 6)
    optLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local selectedBtn = nil
    local btnList = {}

    for i, opt in ipairs(options_list) do
        local b = Instance.new("TextButton", optRow)
        b.Size = UDim2.new(0, 85, 1, 0)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = opt.label
        b.TextColor3 = Color3.fromRGB(160, 160, 160)
        b.Font = "GothamMedium"
        b.TextSize = 12
        b.BorderSizePixel = 0
        b.LayoutOrder = i
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

        -- Pilih default
        if opt.default then
            b.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectedBtn = b
        end

        b.Activated:Connect(function()
            -- Reset semua
            for _, tb in ipairs(btnList) do
                TweenService:Create(tb, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play()
                tb.TextColor3 = Color3.fromRGB(160, 160, 160)
            end
            -- Aktifkan yang dipilih
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            }):Play()
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectedBtn = b
            onSelect(opt.value)
        end)

        table.insert(btnList, b)
    end

    -- Divider
    local divider = Instance.new("Frame", parent)
    divider.Size = UDim2.new(1, -10, 0, 1)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    divider.BorderSizePixel = 0
    divider.LayoutOrder = order + 0.9

    return optRow
end

-- ICON SIZE
CreateSettingDropdown(SetPage, "Icon Size", "📐", {
    { label = "Small",  value = "small",  default = false },
    { label = "Medium", value = "medium", default = true  },
    { label = "Large",  value = "large",  default = false },
}, function(value)
    if value == "small" then
        TweenService:Create(OpenBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
    elseif value == "medium" then
        TweenService:Create(OpenBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    elseif value == "large" then
        TweenService:Create(OpenBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 75, 0, 75)
        }):Play()
    end
end, 1)

-- ICON SHAPE
CreateSettingDropdown(SetPage, "Icon Shape", "🔷", {
    { label = "Circle", value = "circle", default = true  },
    { label = "Square", value = "square", default = false },
    { label = "Rounded", value = "rounded", default = false },
}, function(value)
    if value == "circle" then
        LogoCorner.CornerRadius = UDim.new(1, 0)
    elseif value == "square" then
        LogoCorner.CornerRadius = UDim.new(0, 0)
    elseif value == "rounded" then
        LogoCorner.CornerRadius = UDim.new(0, 12)
    end
end, 3)

-- ICON COLOR
CreateSettingDropdown(SetPage, "Icon Color", "🎨", {
    { label = "Dark",   value = "dark",   default = true  },
    { label = "Orange", value = "orange", default = false },
    { label = "Purple", value = "purple", default = false },
    { label = "Blue",   value = "blue",   default = false },
}, function(value)
    local colors = {
        dark   = Color3.fromRGB(30, 30, 30),
        orange = Color3.fromRGB(200, 90, 0),
        purple = Color3.fromRGB(120, 0, 200),
        blue   = Color3.fromRGB(0, 100, 220),
    }
    TweenService:Create(OpenBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = colors[value]
    }):Play()
end, 5)

-- THEME ACCENT
CreateSettingDropdown(SetPage, "Accent Color", "✨", {
    { label = "Orange", value = "orange", default = true  },
    { label = "Cyan",   value = "cyan",   default = false },
    { label = "Green",  value = "green",  default = false },
}, function(value)
    local accents = {
        orange = Color3.fromRGB(255, 140, 0),
        cyan   = Color3.fromRGB(0, 200, 230),
        green  = Color3.fromRGB(50, 200, 80),
    }
    TopGrip.BackgroundColor3 = accents[value]
end, 7)

-- ==========================================
-- NOTIFIKASI / WATERMARK
-- ==========================================
local WaterMark = Instance.new("TextLabel", ScreenGui)
WaterMark.Size = UDim2.new(0, 200, 0, 22)
WaterMark.Position = UDim2.new(1, -210, 0, 8)
WaterMark.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
WaterMark.BackgroundTransparency = 0.3
WaterMark.Text = " 🪐 Lynxx VD v5.3 | Saycho"
WaterMark.TextColor3 = Color3.fromRGB(255, 140, 0)
WaterMark.Font = "GothamBold"
WaterMark.TextSize = 11
WaterMark.TextXAlignment = "Left"
WaterMark.ZIndex = 5
Instance.new("UICorner", WaterMark).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- RUNNER (GAME LOOP)
-- ==========================================
RunService.Heartbeat:Connect(function()
    -- Auto Heal Logic
    if States.AutoHeal then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = math.min(hum.Health + 0.5, hum.MaxHealth)
            end
        end
    end

    -- Moonwalk Logic
    if States.Moonwalk then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
                States.LockedDirection = hum.MoveDirection
            end
        end
    end
end)

print("✅ VD Script v5.3 Loaded Successfully | By Saycho | Fixed by Claude")
