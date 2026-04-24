--[[
╔══════════════════════════════════════════════════════════╗
║   PROJECT : VD (Violence District) - PLATINUM            ║
║   VERSION : 8.0 — ESP FULL + GUI CLEAN                  ║
║   BY      : Saycho  |  Fix & Build : Claude              ║
╠══════════════════════════════════════════════════════════╣
║  CHANGES v8.0:                                           ║
║  - Semua fitur lama dihapus kecuali Settings             ║
║  - ESP Player BARU: Survivor (Hijau) vs Killer (Merah)  ║
║  - ESP Name, HP, Distance, Highlight per role            ║
║  - ESP Generator dengan progress %                       ║
║  - Pallet ESP (outline ungu)                             ║
║  - ensureGUI: GUI tidak hilang setelah respawn           ║
║  - GUI tetap pakai sistem v5.3 (arrow, dropdown, dll)   ║
╚══════════════════════════════════════════════════════════╝
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- SAFE PLAYERGUI (dari script referensi — lebih robust)
-- ============================================================
local function getPlayerGui()
    local ok, res = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 8) end)
    return (ok and res) or CoreGui
end
local PlayerGui = getPlayerGui()

-- ============================================================
-- CLEANUP
-- ============================================================
for _, parent in ipairs({CoreGui, PlayerGui}) do
    local old = parent:FindFirstChild("VD_Saycho_Official")
    if old then old:Destroy() end
end

-- ============================================================
-- SCREENGUI — coba CoreGui, fallback PlayerGui
-- ============================================================
local ScreenGui
local ok_cg = pcall(function()
    local sg = Instance.new("ScreenGui")
    sg.Name           = "VD_Saycho_Official"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 999
    sg.Parent         = CoreGui
    ScreenGui         = sg
end)
if not ok_cg or not ScreenGui or not ScreenGui.Parent then
    ScreenGui             = Instance.new("ScreenGui")
    ScreenGui.Name        = "VD_Saycho_Official"
    ScreenGui.ResetOnSpawn= false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder= 999
    ScreenGui.Parent      = PlayerGui
end

-- ============================================================
-- STATES
-- ============================================================
local States = {
    EspPlayerEnabled    = false,
    EspGeneratorEnabled = false,
    PalletEspEnabled    = false,
    EspName             = true,
    EspHP               = true,
    EspDistance         = true,
    EspBox              = true,
}

-- ============================================================
-- ROLE DETECTION
-- ============================================================
local function getRole(player)
    if player and player.Team then
        local t = player.Team.Name:lower()
        if t:find("killer") or t:find("maniac") or t:find("убийца") then
            return "Killer"
        end
    end
    return "Survivor"
end

-- ============================================================
-- WARNA ESP
-- ============================================================
local COLOR = {
    SURVIVOR = Color3.fromRGB(80, 220, 80),   -- Hijau
    KILLER   = Color3.fromRGB(220, 40,  40),  -- Merah
    GENERATOR= Color3.fromRGB(255, 200, 0),   -- Kuning
    GEN_DONE = Color3.fromRGB(0,   220, 100), -- Hijau (done)
    PALLET   = Color3.fromRGB(180, 80,  220), -- Ungu
    ORANGE   = Color3.fromRGB(255, 140, 0),
}

-- ============================================================
-- DRAGGING
-- ============================================================
local function MakeDraggable(obj, handle)
    local drag, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            drag=true; dragStart=i.Position; startPos=obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                     startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then drag=false end
    end)
end

-- ============================================================
-- FLOATING ICON
-- ============================================================
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Name             = "LynxxIcon"
OpenBtn.Size             = UDim2.new(0, 50, 0, 50)
OpenBtn.Position         = UDim2.new(0, 20, 0.5, -25)
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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TopGrip = Instance.new("Frame", MainFrame)
TopGrip.Size             = UDim2.new(0, 40, 0, 3)
TopGrip.Position         = UDim2.new(0.5, -20, 0, 8)
TopGrip.BackgroundColor3 = COLOR.ORANGE
TopGrip.BorderSizePixel  = 0
Instance.new("UICorner", TopGrip)
MakeDraggable(MainFrame, TopGrip)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundTransparency = 1

local LynxxTitle = Instance.new("TextLabel", Header)
LynxxTitle.Text = "Lynxx 🪐"; LynxxTitle.Position = UDim2.new(0,15,0,15)
LynxxTitle.Size = UDim2.new(0,90,0,22); LynxxTitle.TextColor3 = COLOR.ORANGE
LynxxTitle.Font = "GothamBold"; LynxxTitle.TextSize = 16
LynxxTitle.BackgroundTransparency = 1; LynxxTitle.TextXAlignment = "Left"

local Sep = Instance.new("Frame", Header)
Sep.Size = UDim2.new(0,1,0,20); Sep.Position = UDim2.new(0,110,0,18)
Sep.BackgroundColor3 = Color3.fromRGB(60,60,60); Sep.BorderSizePixel = 0

local GameTitle = Instance.new("TextLabel", Header)
GameTitle.Text = "Violence District"; GameTitle.Position = UDim2.new(0,120,0,15)
GameTitle.Size = UDim2.new(0,160,0,22); GameTitle.TextColor3 = Color3.fromRGB(140,140,140)
GameTitle.Font = "GothamMedium"; GameTitle.TextSize = 13
GameTitle.BackgroundTransparency = 1; GameTitle.TextXAlignment = "Left"

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,30,0,30); MinBtn.Position = UDim2.new(1,-42,0,10)
MinBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = "GothamBold"
MinBtn.TextSize = 16; MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

MinBtn.Activated:Connect(function() MainFrame.Visible=false; OpenBtn.Visible=true end)
OpenBtn.Activated:Connect(function() MainFrame.Visible=true; OpenBtn.Visible=false end)

-- Resize
local ResizeBtn = Instance.new("TextButton", MainFrame)
ResizeBtn.Size = UDim2.new(0,15,0,15); ResizeBtn.Position = UDim2.new(1,-20,1,-20)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); ResizeBtn.Text = ""
ResizeBtn.BorderSizePixel = 0
Instance.new("UICorner", ResizeBtn).CornerRadius = UDim.new(0,3)
local resizing = false
ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        local ss = MainFrame.Size; local sp = input.Position; local mc
        mc = UserInputService.InputChanged:Connect(function(mi)
            if resizing and (mi.UserInputType == Enum.UserInputType.MouseMovement
                or mi.UserInputType == Enum.UserInputType.Touch) then
                local d = mi.Position - sp
                MainFrame.Size = UDim2.new(0,math.max(450,ss.X.Offset+d.X),
                                           0,math.max(300,ss.Y.Offset+d.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function()
            resizing=false; if mc then mc:Disconnect() end
        end)
    end
end)

-- ============================================================
-- SIDEBAR & CONTAINER
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0,10,0,55); Sidebar.Size = UDim2.new(0,130,1,-65)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22); Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0,4)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,8)

local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0,150,0,55); Container.Size = UDim2.new(1,-160,1,-65)
Container.BackgroundTransparency = 1

-- ============================================================
-- PAGE & TAB SYSTEM
-- ============================================================
local Pages = {}
local TabButtons = {}

local function CreatePage(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name = name; pg.Size = UDim2.new(1,0,1,0)
    pg.BackgroundTransparency = 1; pg.Visible = false
    pg.ScrollBarThickness = 3
    pg.ScrollBarImageColor3 = COLOR.ORANGE
    pg.ScrollBarImageTransparency = 0.5
    pg.BorderSizePixel = 0; pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", pg)
    layout.Padding = UDim.new(0,8); layout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0,8)
    Pages[name] = pg; return pg
end

local function AddTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1,0,0,38); btn.BackgroundTransparency = 1
    btn.Text = "   "..name; btn.TextColor3 = Color3.fromRGB(130,130,130)
    btn.Font = "GothamMedium"; btn.TextSize = 13
    btn.TextXAlignment = "Left"; btn.BorderSizePixel = 0

    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0,3,0,18); ind.Position = UDim2.new(0,6,0.5,-9)
    ind.BackgroundColor3 = COLOR.ORANGE; ind.Visible = false
    ind.BorderSizePixel = 0; Instance.new("UICorner", ind)

    btn.Activated:Connect(function()
        for _,p in pairs(Pages) do p.Visible=false end
        for _,tb in pairs(TabButtons) do
            tb.btn.TextColor3=Color3.fromRGB(130,130,130); tb.ind.Visible=false
        end
        if Pages[name] then Pages[name].Visible=true end
        btn.TextColor3=Color3.new(1,1,1); ind.Visible=true
    end)
    table.insert(TabButtons,{btn=btn,ind=ind})
    return btn,ind
end

-- Buat pages
local EspPage = CreatePage("ESP")
local SetPage = CreatePage("Settings")

-- Buat tabs
local espBtn, espInd = AddTab("ESP")
AddTab("Settings")

-- Default ke ESP
EspPage.Visible=true; espBtn.TextColor3=Color3.new(1,1,1); espInd.Visible=true

-- ============================================================
-- UI HELPERS
-- ============================================================
local function SectionHeader(parent, text, order)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = text; lbl.Size = UDim2.new(1,-10,0,28)
    lbl.TextColor3 = COLOR.ORANGE; lbl.Font = "GothamBold"
    lbl.TextSize = 13; lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = "Left"; lbl.LayoutOrder = order
    return lbl
end

local function CreateToggle(parent, labelText, state, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-10,0,45); row.BackgroundColor3 = Color3.fromRGB(25,25,25)
    row.BorderSizePixel = 0; row.LayoutOrder = order or 0; Instance.new("UICorner", row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = "  "..labelText; lbl.Size = UDim2.new(1,-60,1,0)
    lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = "GothamMedium"; lbl.TextSize = 13
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = "Left"

    local track = Instance.new("TextButton", row)
    track.Size = UDim2.new(0,46,0,24); track.Position = UDim2.new(1,-56,0.5,-12)
    track.BackgroundColor3 = state and COLOR.ORANGE or Color3.fromRGB(50,50,50)
    track.Text = ""; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0,18,0,18)
    knob.Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local on = state
    track.Activated:Connect(function()
        on = not on
        TweenService:Create(track,TweenInfo.new(0.2),{
            BackgroundColor3 = on and COLOR.ORANGE or Color3.fromRGB(50,50,50)
        }):Play()
        TweenService:Create(knob,TweenInfo.new(0.2),{
            Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        }):Play()
        callback(on)
    end)
    return row
end

local function AddDropdownFeature(parent, title, options_table, order)
    local frame = Instance.new("TextButton", parent)
    frame.Size = UDim2.new(1,-10,0,45); frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.Text = ""; frame.BorderSizePixel = 0; frame.LayoutOrder = order or 0
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Text = "  "..title; label.Size = UDim2.new(1,-40,1,0)
    label.TextColor3 = Color3.new(1,1,1); label.Font = "GothamMedium"; label.TextSize = 13
    label.BackgroundTransparency = 1; label.TextXAlignment = "Left"

    local arrow = Instance.new("TextLabel", frame)
    arrow.Text = "▼  "; arrow.Size = UDim2.new(0,35,1,0); arrow.Position = UDim2.new(1,-35,0,0)
    arrow.TextColor3 = COLOR.ORANGE; arrow.BackgroundTransparency = 1
    arrow.TextXAlignment = "Right"; arrow.Font = "GothamBold"; arrow.TextSize = 13

    local isOpen = false
    local listFrame = Instance.new("Frame", parent)
    listFrame.Size = UDim2.new(1,-10,0,0); listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    listFrame.ClipsDescendants = true; listFrame.BorderSizePixel = 0
    listFrame.LayoutOrder = (order or 0)+0.5; Instance.new("UICorner", listFrame)
    local ll = Instance.new("UIListLayout", listFrame); ll.Padding = UDim.new(0,2)
    Instance.new("UIPadding", listFrame).PaddingTop = UDim.new(0,4)

    local itemCount = 0
    for _, opt in pairs(options_table) do
        itemCount = itemCount+1
        local b = Instance.new("TextButton", listFrame)
        b.Size = UDim2.new(1,0,0,34); b.BackgroundColor3 = Color3.fromRGB(35,35,35)
        b.Text = "  "..opt.Name; b.TextColor3 = Color3.fromRGB(180,180,180)
        b.Font = "Gotham"; b.TextSize = 12; b.TextXAlignment = "Left"; b.BorderSizePixel = 0
        local stateOn = false
        b.Activated:Connect(function()
            stateOn = not stateOn
            TweenService:Create(b,TweenInfo.new(0.15),{
                BackgroundColor3 = stateOn and Color3.fromRGB(50,35,10) or Color3.fromRGB(35,35,35)
            }):Play()
            b.TextColor3 = stateOn and COLOR.ORANGE or Color3.fromRGB(180,180,180)
            opt.Callback(stateOn)
        end)
    end

    local fullH = (itemCount*36)+8
    frame.Activated:Connect(function()
        isOpen = not isOpen
        TweenService:Create(listFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Size = isOpen and UDim2.new(1,-10,0,fullH) or UDim2.new(1,-10,0,0)
        }):Play()
        arrow.Text = isOpen and "▲  " or "▼  "
    end)
    return frame, listFrame
end

-- ============================================================
-- ESP PLAYER — SURVIVOR HIJAU / KILLER MERAH (dari referensi)
-- ============================================================
local espPlayerConnections = {}
local espPlayerLoopConn    = nil

local function aliveObj(obj)
    if not obj then return false end
    local ok = pcall(function() return obj.Parent end)
    return ok and obj.Parent ~= nil
end

local function makeBillboard(playerName, role)
    -- Nama (selalu tampil)
    local g = Instance.new("BillboardGui")
    g.Name = "ESP_Tag"; g.AlwaysOnTop = true
    g.Size = UDim2.new(0,200,0,60); g.StudsOffset = Vector3.new(0,3.2,0)

    local col = (role=="Killer") and COLOR.KILLER or COLOR.SURVIVOR

    -- Baris 1: Nama + Role
    local nameL = Instance.new("TextLabel", g)
    nameL.Name = "NameLabel"; nameL.BackgroundTransparency = 1
    nameL.Size = UDim2.new(1,0,0,18); nameL.Position = UDim2.new(0,0,0,0)
    nameL.Font = Enum.Font.GothamBold; nameL.TextSize = 13
    nameL.Text = playerName.." ["..role.."]"
    nameL.TextColor3 = col
    nameL.TextStrokeTransparency = 0; nameL.TextStrokeColor3 = Color3.new(0,0,0)

    -- Baris 2: HP
    local hpL = Instance.new("TextLabel", g)
    hpL.Name = "HpLabel"; hpL.BackgroundTransparency = 1
    hpL.Size = UDim2.new(1,0,0,16); hpL.Position = UDim2.new(0,0,0,20)
    hpL.Font = Enum.Font.Gotham; hpL.TextSize = 11
    hpL.Text = "HP: --"; hpL.TextColor3 = Color3.fromRGB(220,220,220)
    hpL.TextStrokeTransparency = 0; hpL.TextStrokeColor3 = Color3.new(0,0,0)

    -- Baris 3: Jarak
    local distL = Instance.new("TextLabel", g)
    distL.Name = "DistLabel"; distL.BackgroundTransparency = 1
    distL.Size = UDim2.new(1,0,0,14); distL.Position = UDim2.new(0,0,0,36)
    distL.Font = Enum.Font.Gotham; distL.TextSize = 10
    distL.Text = "0 m"; distL.TextColor3 = Color3.fromRGB(180,180,180)
    distL.TextStrokeTransparency = 0; distL.TextStrokeColor3 = Color3.new(0,0,0)

    return g
end

local function ensureHighlight(model, col)
    if not (model and model:IsA("Model") and aliveObj(model)) then return nil end
    local hl = model:FindFirstChild("ESP_HL")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "ESP_HL"; hl.Adornee = model
        hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = model
    end
    hl.FillColor = col; hl.OutlineColor = col
    return hl
end

local function applyOnePlayerESP(p)
    if p == LocalPlayer then return end
    local c = p.Character
    if not (c and aliveObj(c)) then return end

    local role = getRole(p)
    local col  = (role=="Killer") and COLOR.KILLER or COLOR.SURVIVOR

    -- Highlight
    if States.EspBox then ensureHighlight(c, col) end

    -- Billboard (nama, hp, jarak)
    local head = c:FindFirstChild("Head")
    if head and aliveObj(head) then
        local tag = head:FindFirstChild("ESP_Tag")
        if not tag then
            tag = makeBillboard(p.Name, role)
            tag.Parent = head
        end
        -- Update HP
        if States.EspHP then
            local hum = c:FindFirstChildOfClass("Humanoid")
            local hpL = tag:FindFirstChild("HpLabel")
            if hpL and hum and hum.Parent then
                hpL.Text = "HP: "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
                hpL.Visible = true
            end
        else
            local hpL = tag:FindFirstChild("HpLabel")
            if hpL then hpL.Visible = false end
        end
        -- Update Jarak
        if States.EspDistance then
            local myChar = LocalPlayer.Character
            local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local hrp    = c:FindFirstChild("HumanoidRootPart")
            local distL  = tag:FindFirstChild("DistLabel")
            if distL and myHRP and hrp and hrp.Parent then
                local dist = math.floor((hrp.Position - myHRP.Position).Magnitude)
                distL.Text = dist.." m"
                distL.Visible = true
            end
        else
            local distL = tag:FindFirstChild("DistLabel")
            if distL then distL.Visible = false end
        end
        -- Sembunyikan nama jika dimatikan
        local nameL = tag:FindFirstChild("NameLabel")
        if nameL then nameL.Visible = States.EspName end
    end
end

local function startESPPlayer()
    espPlayerLoopConn = RunService.Heartbeat:Connect(function()
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then pcall(applyOnePlayerESP, pl) end
        end
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            espPlayerConnections[p] = espPlayerConnections[p] or {}
            table.insert(espPlayerConnections[p], p.CharacterAdded:Connect(function()
                task.wait(0.5); pcall(applyOnePlayerESP, p)
            end))
        end
    end
end

local function stopESPPlayer()
    if espPlayerLoopConn then espPlayerLoopConn:Disconnect(); espPlayerLoopConn=nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            local c = pl.Character
            local hl = c:FindFirstChild("ESP_HL"); if hl then hl:Destroy() end
            local head = c:FindFirstChild("Head")
            if head then
                local tag = head:FindFirstChild("ESP_Tag"); if tag then tag:Destroy() end
            end
        end
    end
    for _, conns in pairs(espPlayerConnections) do
        for _, cn in pairs(conns) do pcall(function() cn:Disconnect() end) end
    end
    espPlayerConnections = {}
end

-- ============================================================
-- ESP GENERATOR (dari referensi — progress %)
-- ============================================================
local genHighlights     = {}
local genLoopConn       = nil

local function getGenProgress(gen)
    local v = gen:GetAttribute("RepairProgress")
    if v then
        return (v <= 1) and math.floor(v*100) or math.min(math.floor(v),100)
    end
    return 0
end

local function buildGenESP()
    for _,d in pairs(genHighlights) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end
    genHighlights = {}

    local map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Map1")
    if not map then return end

    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local prog  = getGenProgress(obj)
                local col   = prog>=100 and COLOR.GEN_DONE or COLOR.GENERATOR

                local hl = Instance.new("Highlight")
                hl.FillColor = col; hl.OutlineColor = col
                hl.FillTransparency = 0.6; hl.OutlineTransparency = 0
                hl.Adornee = obj; hl.Parent = obj

                local bb = Instance.new("BillboardGui")
                bb.Name="GenESP"; bb.AlwaysOnTop=true
                bb.Size=UDim2.new(0,150,0,40); bb.StudsOffset=Vector3.new(0,4,0)
                bb.Adornee=part; bb.Parent=part

                local lbl = Instance.new("TextLabel",bb)
                lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
                lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
                lbl.Text="Gen "..prog.."%"; lbl.TextColor3=col
                lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)

                genHighlights[obj] = {hl=hl, bb=bb, lbl=lbl}
            end
        end
    end
end

local function startESPGenerator()
    buildGenESP()
    genLoopConn = RunService.Heartbeat:Connect(function()
        for gen, d in pairs(genHighlights) do
            if gen and gen.Parent then
                local prog = getGenProgress(gen)
                local col  = prog>=100 and COLOR.GEN_DONE or COLOR.GENERATOR
                if d.hl then d.hl.FillColor=col; d.hl.OutlineColor=col end
                if d.lbl then d.lbl.Text="Gen "..prog.."%"; d.lbl.TextColor3=col end
            else
                pcall(function() if d.hl then d.hl:Destroy() end end)
                pcall(function() if d.bb then d.bb:Destroy() end end)
                genHighlights[gen]=nil
            end
        end
    end)
end

local function stopESPGenerator()
    if genLoopConn then genLoopConn:Disconnect(); genLoopConn=nil end
    for _,d in pairs(genHighlights) do
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
    end
    genHighlights={}
end

-- ============================================================
-- PALLET ESP (dari referensi)
-- ============================================================
local palletReg      = {}
local palletLoopConn = nil

local function findPallets()
    for _,e in pairs(palletReg) do
        pcall(function() if e.hl then e.hl:Destroy() end end)
    end
    palletReg = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name=="Palletwrong" or obj.Name:lower():find("pallet")) then
            if not palletReg[obj] then palletReg[obj]={model=obj,hl=nil} end
        end
    end
end

local function startPalletESP()
    findPallets()
    palletLoopConn = RunService.Heartbeat:Connect(function()
        for model, entry in pairs(palletReg) do
            if model and aliveObj(model) then
                if not entry.hl or not aliveObj(entry.hl) then
                    local h = Instance.new("Highlight")
                    h.Name="PalletESP_HL"; h.Adornee=model
                    h.FillTransparency=1; h.OutlineColor=COLOR.PALLET
                    h.OutlineTransparency=0
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent=model; entry.hl=h
                end
            else
                pcall(function() if entry.hl then entry.hl:Destroy() end end)
                palletReg[model]=nil
            end
        end
    end)

    -- Monitor pallet baru
    Workspace.DescendantAdded:Connect(function(d)
        if States.PalletEspEnabled and d:IsA("Model")
            and (d.Name=="Palletwrong" or d.Name:lower():find("pallet")) then
            if not palletReg[d] then palletReg[d]={model=d,hl=nil} end
        end
    end)
end

local function stopPalletESP()
    if palletLoopConn then palletLoopConn:Disconnect(); palletLoopConn=nil end
    for _,e in pairs(palletReg) do
        pcall(function() if e.hl then e.hl:Destroy() end end)
    end
    palletReg={}
end

-- ============================================================
-- ESP PAGE — UI
-- ============================================================
SectionHeader(EspPage, "👥  ESP Player", 1)

-- Info label survivor/killer warna
local infoRow = Instance.new("Frame", EspPage)
infoRow.Size = UDim2.new(1,-10,0,32); infoRow.BackgroundColor3 = Color3.fromRGB(22,22,22)
infoRow.BorderSizePixel = 0; infoRow.LayoutOrder = 2; Instance.new("UICorner", infoRow)

local survLabel = Instance.new("TextLabel", infoRow)
survLabel.Size = UDim2.new(0.5,0,1,0); survLabel.Position = UDim2.new(0,0,0,0)
survLabel.Text = "  🟢 Survivor"; survLabel.Font = "GothamBold"; survLabel.TextSize = 12
survLabel.TextColor3 = COLOR.SURVIVOR; survLabel.BackgroundTransparency = 1
survLabel.TextXAlignment = "Left"

local killerLabel = Instance.new("TextLabel", infoRow)
killerLabel.Size = UDim2.new(0.5,0,1,0); killerLabel.Position = UDim2.new(0.5,0,0,0)
killerLabel.Text = "🔴 Killer  "; killerLabel.Font = "GothamBold"; killerLabel.TextSize = 12
killerLabel.TextColor3 = COLOR.KILLER; killerLabel.BackgroundTransparency = 1
killerLabel.TextXAlignment = "Right"

CreateToggle(EspPage, "ESP Player (Highlight + Info)", false, function(s)
    States.EspPlayerEnabled = s
    if s then startESPPlayer() else stopESPPlayer() end
end, 3)

-- Sub-opsi ESP
AddDropdownFeature(EspPage, "🔧  Opsi ESP Player", {
    {Name="Tampilkan Nama",    Callback=function(s) States.EspName=s end},
    {Name="Tampilkan HP",      Callback=function(s) States.EspHP=s end},
    {Name="Tampilkan Jarak",   Callback=function(s) States.EspDistance=s end},
    {Name="Highlight (Box)",   Callback=function(s) States.EspBox=s
        if not s then
            -- hapus semua highlight saat ini
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl.Character then
                    local hl=pl.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    end},
}, 4)

SectionHeader(EspPage, "⚙️  ESP Generator", 10)

CreateToggle(EspPage, "ESP Generator (Progress %)", false, function(s)
    States.EspGeneratorEnabled = s
    if s then startESPGenerator() else stopESPGenerator() end
end, 11)

SectionHeader(EspPage, "🪵  Pallet ESP", 20)

CreateToggle(EspPage, "Pallet ESP (Outline Ungu)", false, function(s)
    States.PalletEspEnabled = s
    if s then startPalletESP() else stopPalletESP() end
end, 21)

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
local function CreateSettingDropdown(parent, title, icon, options_list, onSelect, order)
    local titleRow = Instance.new("Frame", parent)
    titleRow.Size = UDim2.new(1,-10,0,22); titleRow.BackgroundTransparency = 1
    titleRow.LayoutOrder = order

    local titleLbl = Instance.new("TextLabel", titleRow)
    titleLbl.Text = icon.."  "..title; titleLbl.Size = UDim2.new(1,0,1,0)
    titleLbl.TextColor3 = Color3.fromRGB(180,180,180); titleLbl.Font = "GothamMedium"
    titleLbl.TextSize = 12; titleLbl.BackgroundTransparency = 1; titleLbl.TextXAlignment = "Left"

    local optRow = Instance.new("Frame", parent)
    optRow.Size = UDim2.new(1,-10,0,38); optRow.BackgroundTransparency = 1
    optRow.LayoutOrder = order+0.5

    local optLayout = Instance.new("UIListLayout", optRow)
    optLayout.FillDirection = Enum.FillDirection.Horizontal
    optLayout.Padding = UDim.new(0,6); optLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local btnList = {}
    for i, opt in ipairs(options_list) do
        local b = Instance.new("TextButton", optRow)
        b.Size = UDim2.new(0,85,1,0)
        b.BackgroundColor3 = opt.default and COLOR.ORANGE or Color3.fromRGB(30,30,30)
        b.Text = opt.label; b.TextColor3 = opt.default and Color3.new(1,1,1) or Color3.fromRGB(160,160,160)
        b.Font = "GothamMedium"; b.TextSize = 12; b.BorderSizePixel = 0; b.LayoutOrder = i
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
        b.Activated:Connect(function()
            for _,tb in ipairs(btnList) do
                TweenService:Create(tb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(30,30,30)}):Play()
                tb.TextColor3 = Color3.fromRGB(160,160,160)
            end
            TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=COLOR.ORANGE}):Play()
            b.TextColor3 = Color3.new(1,1,1); onSelect(opt.value)
        end)
        table.insert(btnList, b)
    end

    local divider = Instance.new("Frame", parent)
    divider.Size = UDim2.new(1,-10,0,1); divider.BackgroundColor3 = Color3.fromRGB(35,35,35)
    divider.BorderSizePixel = 0; divider.LayoutOrder = order+0.9
    return optRow
end

local setHeader = Instance.new("TextLabel", SetPage)
setHeader.Text = "⚙️  UI Settings"; setHeader.Size = UDim2.new(1,-10,0,30)
setHeader.TextColor3 = COLOR.ORANGE; setHeader.Font = "GothamBold"; setHeader.TextSize = 14
setHeader.BackgroundTransparency = 1; setHeader.TextXAlignment = "Left"; setHeader.LayoutOrder = 0

CreateSettingDropdown(SetPage, "Icon Size", "📐", {
    {label="Small",  value="small",  default=false},
    {label="Medium", value="medium", default=true },
    {label="Large",  value="large",  default=false},
}, function(v)
    local s={small=35,medium=50,large=75}
    TweenService:Create(OpenBtn,TweenInfo.new(0.2),{Size=UDim2.new(0,s[v],0,s[v])}):Play()
end, 1)

CreateSettingDropdown(SetPage, "Icon Shape", "🔷", {
    {label="Circle",  value="circle",  default=true },
    {label="Square",  value="square",  default=false},
    {label="Rounded", value="rounded", default=false},
}, function(v)
    local r={circle=UDim.new(1,0),square=UDim.new(0,0),rounded=UDim.new(0,12)}
    LogoCorner.CornerRadius=r[v]
end, 3)

CreateSettingDropdown(SetPage, "Icon Color", "🎨", {
    {label="Dark",   value="dark",   default=true },
    {label="Orange", value="orange", default=false},
    {label="Purple", value="purple", default=false},
    {label="Blue",   value="blue",   default=false},
}, function(v)
    local c={dark=Color3.fromRGB(30,30,30),orange=Color3.fromRGB(200,90,0),
             purple=Color3.fromRGB(120,0,200),blue=Color3.fromRGB(0,100,220)}
    TweenService:Create(OpenBtn,TweenInfo.new(0.2),{BackgroundColor3=c[v]}):Play()
end, 5)

CreateSettingDropdown(SetPage, "Accent Color", "✨", {
    {label="Orange", value="orange", default=true },
    {label="Cyan",   value="cyan",   default=false},
    {label="Green",  value="green",  default=false},
}, function(v)
    local c={orange=Color3.fromRGB(255,140,0),cyan=Color3.fromRGB(0,200,230),green=Color3.fromRGB(50,200,80)}
    TopGrip.BackgroundColor3=c[v]
end, 7)

-- ============================================================
-- WATERMARK
-- ============================================================
local WaterMark = Instance.new("TextLabel", ScreenGui)
WaterMark.Size = UDim2.new(0,220,0,22); WaterMark.Position = UDim2.new(1,-230,0,8)
WaterMark.BackgroundColor3 = Color3.fromRGB(18,18,18); WaterMark.BackgroundTransparency = 0.3
WaterMark.Text = " 🪐 Lynxx VD v8.0 | Saycho"; WaterMark.TextColor3 = COLOR.ORANGE
WaterMark.Font = "GothamBold"; WaterMark.TextSize = 11; WaterMark.TextXAlignment = "Left"
WaterMark.ZIndex = 5; Instance.new("UICorner", WaterMark).CornerRadius = UDim.new(0,6)

-- ============================================================
-- ENSURE GUI — tidak hilang setelah respawn/teleport
-- ============================================================
local function ensureGUI()
    if not ScreenGui or not ScreenGui.Parent then
        ScreenGui.Parent = getPlayerGui()
    end
end

RunService.Heartbeat:Connect(ensureGUI)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1); ensureGUI()
    -- Restart ESP setelah respawn
    if States.EspPlayerEnabled then
        stopESPPlayer(); task.wait(0.1); startESPPlayer()
    end
    if States.EspGeneratorEnabled then
        stopESPGenerator(); task.wait(0.1); startESPGenerator()
    end
end)

-- Auto-scan pallet saat map baru muncul
Workspace.ChildAdded:Connect(function(child)
    if (child.Name=="Map" or child.Name=="Map1") and States.PalletEspEnabled then
        task.wait(3); findPallets()
    end
end)

task.delay(2, findPallets)

print("✅ VD v8.0 Loaded | ESP Full | Survivor Hijau | Killer Merah | By Saycho")
