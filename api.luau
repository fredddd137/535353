local ModernUI = {
    Options = {},
    Folder  = "ModernUI",
}

function ModernUI.GetService(service)
    return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
end

local TweenService      = ModernUI.GetService("TweenService")
local RunService        = ModernUI.GetService("RunService")
local UserInputService  = ModernUI.GetService("UserInputService")
local Players           = ModernUI.GetService("Players")

local LocalPlayer   = Players.LocalPlayer
local currentTab    = nil
local tabs          = {}
local visible       = true

local THEMES = {
    Light = {
        bg          = Color3.fromRGB(250, 250, 250),
        topbar      = Color3.fromRGB(255, 255, 255),
        section     = Color3.fromRGB(255, 255, 255),
        sectionStroke = Color3.fromRGB(235, 235, 235),
        divider     = Color3.fromRGB(230, 230, 230),
        profile     = Color3.fromRGB(245, 245, 245),
        tabActive   = Color3.fromRGB(30, 30, 30),
        tabActiveText = Color3.fromRGB(255, 255, 255),
        tabIdle     = Color3.fromRGB(240, 240, 240),
        tabIdleText = Color3.fromRGB(100, 100, 100),
        textPrimary = Color3.fromRGB(30, 30, 30),
        textSec     = Color3.fromRGB(60, 60, 60),
        textMuted   = Color3.fromRGB(120, 120, 120),
        inputBg     = Color3.fromRGB(248, 248, 248),
        checkBg     = Color3.fromRGB(220, 220, 220),
        checkOn     = Color3.fromRGB(80, 80, 80),
        accent      = Color3.fromRGB(80, 80, 80),
        btnBg       = Color3.fromRGB(248, 248, 248),
        btnHover    = Color3.fromRGB(238, 238, 238),
        contextBg   = Color3.fromRGB(255, 255, 255),
        notifBg     = Color3.fromRGB(255, 255, 255),
    },
    Dark = {
        bg          = Color3.fromRGB(22, 22, 24),
        topbar      = Color3.fromRGB(28, 28, 30),
        section     = Color3.fromRGB(32, 32, 35),
        sectionStroke = Color3.fromRGB(50, 50, 55),
        divider     = Color3.fromRGB(50, 50, 55),
        profile     = Color3.fromRGB(38, 38, 42),
        tabActive   = Color3.fromRGB(200, 200, 200),
        tabActiveText = Color3.fromRGB(15, 15, 15),
        tabIdle     = Color3.fromRGB(40, 40, 44),
        tabIdleText = Color3.fromRGB(140, 140, 150),
        textPrimary = Color3.fromRGB(230, 230, 230),
        textSec     = Color3.fromRGB(190, 190, 195),
        textMuted   = Color3.fromRGB(120, 120, 130),
        inputBg     = Color3.fromRGB(40, 40, 44),
        checkBg     = Color3.fromRGB(60, 60, 66),
        checkOn     = Color3.fromRGB(200, 200, 210),
        accent      = Color3.fromRGB(180, 180, 190),
        btnBg       = Color3.fromRGB(40, 40, 44),
        btnHover    = Color3.fromRGB(52, 52, 58),
        contextBg   = Color3.fromRGB(32, 32, 35),
        notifBg     = Color3.fromRGB(32, 32, 35),
    },
}

local currentTheme = "Light"
local themeListeners = {}

local function onThemeChange(fn)
    table.insert(themeListeners, fn)
end

local function applyTheme(name)
    currentTheme = name
    for _, fn in ipairs(themeListeners) do
        pcall(fn, THEMES[name])
    end
end

local function T()
    return THEMES[currentTheme]
end

local function GetGui()
    local gui               = Instance.new("ScreenGui")
    gui.ScreenInsets        = Enum.ScreenInsets.None
    gui.ResetOnSpawn        = false
    gui.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder        = 2147483647
    gui.IgnoreGuiInset      = true

    local parent = RunService:IsStudio()
        and LocalPlayer:FindFirstChild("PlayerGui")
        or (gethui and gethui())
        or ModernUI.GetService("CoreGui")

    gui.Parent = parent
    return gui
end

local function Tween(instance, info, props)
    return TweenService:Create(instance, info, props)
end

local bindContextGui = nil

local function showBindContext(element, onBound)
    if bindContextGui then
        bindContextGui:Destroy()
        bindContextGui = nil
    end

    local screenGui         = Instance.new("ScreenGui")
    screenGui.ScreenInsets  = Enum.ScreenInsets.None
    screenGui.DisplayOrder  = 2147483648
    screenGui.ResetOnSpawn  = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = RunService:IsStudio()
        and LocalPlayer:FindFirstChild("PlayerGui")
        or (gethui and gethui())
        or ModernUI.GetService("CoreGui")

    bindContextGui = screenGui

    local overlay           = Instance.new("TextButton")
    overlay.Size            = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Text            = ""
    overlay.BorderSizePixel = 0
    overlay.ZIndex          = 10
    overlay.Parent          = screenGui

    local box               = Instance.new("Frame")
    box.AnchorPoint         = Vector2.new(0.5, 0.5)
    box.Position            = UDim2.fromScale(0.5, 0.5)
    box.Size                = UDim2.fromOffset(260, 110)
    box.BackgroundColor3    = T().contextBg
    box.BorderSizePixel     = 0
    box.ZIndex              = 11
    box.Parent              = screenGui

    local boxCorner         = Instance.new("UICorner")
    boxCorner.CornerRadius  = UDim.new(0, 12)
    boxCorner.Parent        = box

    local boxStroke         = Instance.new("UIStroke")
    boxStroke.Color         = T().sectionStroke
    boxStroke.Thickness     = 1
    boxStroke.Parent        = box

    local label             = Instance.new("TextLabel")
    label.AnchorPoint       = Vector2.new(0.5, 0)
    label.Position          = UDim2.fromOffset(130, 18)
    label.Size              = UDim2.fromOffset(220, 22)
    label.BackgroundTransparency = 1
    label.Text              = "Bind:  " .. element
    label.Font              = Enum.Font.GothamBold
    label.TextSize          = 14
    label.TextColor3        = T().textPrimary
    label.ZIndex            = 12
    label.Parent            = box

    local sub               = Instance.new("TextLabel")
    sub.AnchorPoint         = Vector2.new(0.5, 0)
    sub.Position            = UDim2.fromOffset(130, 44)
    sub.Size                = UDim2.fromOffset(220, 18)
    sub.BackgroundTransparency = 1
    sub.Text                = "Press any key or mouse button..."
    sub.Font                = Enum.Font.Gotham
    sub.TextSize            = 12
    sub.TextColor3          = T().textMuted
    sub.ZIndex              = 12
    sub.Parent              = box

    local cancelBtn         = Instance.new("TextButton")
    cancelBtn.AnchorPoint   = Vector2.new(0.5, 1)
    cancelBtn.Position      = UDim2.new(0.5, 0, 1, -12)
    cancelBtn.Size          = UDim2.fromOffset(80, 26)
    cancelBtn.BackgroundColor3 = T().btnBg
    cancelBtn.BorderSizePixel = 0
    cancelBtn.Text          = "Cancel"
    cancelBtn.Font          = Enum.Font.GothamMedium
    cancelBtn.TextSize      = 12
    cancelBtn.TextColor3    = T().textSec
    cancelBtn.AutoButtonColor = false
    cancelBtn.ZIndex        = 12
    cancelBtn.Parent        = box

    local cancelCorner      = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent     = cancelBtn

    local unbindBtn         = Instance.new("TextButton")
    unbindBtn.AnchorPoint   = Vector2.new(0.5, 1)
    unbindBtn.Position      = UDim2.new(0.5, 95, 1, -12)
    unbindBtn.Size          = UDim2.fromOffset(80, 26)
    unbindBtn.BackgroundColor3 = T().btnBg
    unbindBtn.BorderSizePixel = 0
    unbindBtn.Text          = "Unbind"
    unbindBtn.Font          = Enum.Font.GothamMedium
    unbindBtn.TextSize      = 12
    unbindBtn.TextColor3    = T().textMuted
    unbindBtn.AutoButtonColor = false
    unbindBtn.ZIndex        = 12
    unbindBtn.Parent        = box

    local unbindCorner      = Instance.new("UICorner")
    unbindCorner.CornerRadius = UDim.new(0, 6)
    unbindCorner.Parent     = unbindBtn

    box.Size = UDim2.fromOffset(0, 0)
    Tween(box, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(260, 110)
    }):Play()

    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local key = input.KeyCode
        local btn = input.UserInputType

        local isMouse = btn == Enum.UserInputType.MouseButton1
            or btn == Enum.UserInputType.MouseButton2
            or btn == Enum.UserInputType.MouseButton3

        local isKey = key ~= Enum.KeyCode.Unknown and key ~= Enum.KeyCode.W
            and not isMouse

        if isMouse or isKey then
            conn:Disconnect()
            local bound = isMouse and btn or key
            onBound(bound)
            screenGui:Destroy()
            bindContextGui = nil
        end
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        conn:Disconnect()
        screenGui:Destroy()
        bindContextGui = nil
    end)

    unbindBtn.MouseButton1Click:Connect(function()
        conn:Disconnect()
        onBound(nil)
        screenGui:Destroy()
        bindContextGui = nil
    end)

    overlay.MouseButton1Click:Connect(function()
        conn:Disconnect()
        screenGui:Destroy()
        bindContextGui = nil
    end)
end

function ModernUI:Window(Settings)
    local WindowFunctions   = { Settings = Settings }
    local gui               = GetGui()
    gui.Name                = "ModernUI"

    local main                      = Instance.new("Frame")
    main.Name                       = "Main"
    main.AnchorPoint                = Vector2.new(0.5, 0.5)
    main.Position                   = UDim2.fromScale(0.5, 0.5)
    main.Size                       = Settings.Size or UDim2.fromOffset(820, 540)
    main.BackgroundColor3           = T().bg
    main.BorderSizePixel            = 0
    main.Parent                     = gui

    local mainCorner                = Instance.new("UICorner")
    mainCorner.CornerRadius         = UDim.new(0, 16)
    mainCorner.Parent               = main

    local shadow                    = Instance.new("ImageLabel")
    shadow.AnchorPoint              = Vector2.new(0.5, 0.5)
    shadow.Position                 = UDim2.fromScale(0.5, 0.5)
    shadow.Size                     = UDim2.fromScale(1, 1) + UDim2.fromOffset(50, 50)
    shadow.BackgroundTransparency   = 1
    shadow.Image                    = "rbxassetid://5554236805"
    shadow.ImageColor3              = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency        = 0.75
    shadow.ScaleType                = Enum.ScaleType.Slice
    shadow.SliceCenter              = Rect.new(23, 23, 277, 277)
    shadow.ZIndex                   = -1
    shadow.Parent                   = main

    local topbar                    = Instance.new("Frame")
    topbar.Name                     = "Topbar"
    topbar.Size                     = UDim2.new(1, 0, 0, 70)
    topbar.BackgroundColor3         = T().topbar
    topbar.BorderSizePixel          = 0
    topbar.Parent                   = main

    local topbarCorner              = Instance.new("UICorner")
    topbarCorner.CornerRadius       = UDim.new(0, 16)
    topbarCorner.Parent             = topbar

    local topbarBottomCover         = Instance.new("Frame")
    topbarBottomCover.AnchorPoint   = Vector2.new(0, 1)
    topbarBottomCover.Position      = UDim2.fromScale(0, 1)
    topbarBottomCover.Size          = UDim2.new(1, 0, 0, 16)
    topbarBottomCover.BackgroundColor3 = T().topbar
    topbarBottomCover.BorderSizePixel = 0
    topbarBottomCover.Parent        = topbar

    local topbarDivider             = Instance.new("Frame")
    topbarDivider.AnchorPoint       = Vector2.new(0, 1)
    topbarDivider.Position          = UDim2.fromScale(0, 1)
    topbarDivider.Size              = UDim2.new(1, 0, 0, 1)
    topbarDivider.BackgroundColor3  = T().divider
    topbarDivider.BorderSizePixel   = 0
    topbarDivider.Parent            = topbar

    local titleFrame                = Instance.new("Frame")
    titleFrame.Position             = UDim2.fromOffset(24, 0)
    titleFrame.Size                 = UDim2.new(0.28, 0, 1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent               = topbar

    local titleLabel                = Instance.new("TextLabel")
    titleLabel.AnchorPoint          = Vector2.new(0, 0.5)
    titleLabel.Position             = UDim2.fromScale(0, 0.5)
    titleLabel.AutomaticSize        = Enum.AutomaticSize.XY
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text                 = Settings.Title or "ModernUI"
    titleLabel.Font                 = Enum.Font.GothamBold
    titleLabel.TextSize             = 18
    titleLabel.TextColor3           = T().textPrimary
    titleLabel.TextXAlignment       = Enum.TextXAlignment.Left
    titleLabel.Parent               = titleFrame

    local navBar                    = Instance.new("Frame")
    navBar.Name                     = "NavBar"
    navBar.AnchorPoint              = Vector2.new(0.5, 0.5)
    navBar.Position                 = UDim2.fromScale(0.5, 0.5)
    navBar.AutomaticSize            = Enum.AutomaticSize.X
    navBar.Size                     = UDim2.new(0, 0, 0, 40)
    navBar.BackgroundTransparency   = 1
    navBar.Parent                   = topbar

    local navBarLayout              = Instance.new("UIListLayout")
    navBarLayout.FillDirection      = Enum.FillDirection.Horizontal
    navBarLayout.Padding            = UDim.new(0, 8)
    navBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navBarLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
    navBarLayout.Parent             = navBar

    local profileFrame              = Instance.new("Frame")
    profileFrame.AnchorPoint        = Vector2.new(1, 0.5)
    profileFrame.Position           = UDim2.new(1, -20, 0.5, 0)
    profileFrame.Size               = UDim2.fromOffset(186, 44)
    profileFrame.BackgroundColor3   = T().profile
    profileFrame.BorderSizePixel    = 0
    profileFrame.Parent             = topbar

    local profileCorner             = Instance.new("UICorner")
    profileCorner.CornerRadius      = UDim.new(1, 0)
    profileCorner.Parent            = profileFrame

    local profilePadding            = Instance.new("UIPadding")
    profilePadding.PaddingLeft      = UDim.new(0, 6)
    profilePadding.PaddingRight     = UDim.new(0, 14)
    profilePadding.Parent           = profileFrame

    local profileLayout             = Instance.new("UIListLayout")
    profileLayout.FillDirection     = Enum.FillDirection.Horizontal
    profileLayout.Padding           = UDim.new(0, 10)
    profileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    profileLayout.Parent            = profileFrame

    local avatarImg                 = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    )

    local avatar                    = Instance.new("ImageLabel")
    avatar.Size                     = UDim2.fromOffset(32, 32)
    avatar.BackgroundColor3         = Color3.fromRGB(200, 200, 200)
    avatar.BorderSizePixel          = 0
    avatar.Image                    = avatarImg
    avatar.Parent                   = profileFrame

    local avatarCorner              = Instance.new("UICorner")
    avatarCorner.CornerRadius       = UDim.new(1, 0)
    avatarCorner.Parent             = avatar

    local userInfo                  = Instance.new("Frame")
    userInfo.AutomaticSize          = Enum.AutomaticSize.XY
    userInfo.BackgroundTransparency = 1
    userInfo.LayoutOrder            = 1
    userInfo.Parent                 = profileFrame

    local userInfoLayout            = Instance.new("UIListLayout")
    userInfoLayout.Padding          = UDim.new(0, 2)
    userInfoLayout.SortOrder        = Enum.SortOrder.LayoutOrder
    userInfoLayout.Parent           = userInfo

    local dispName                  = Instance.new("TextLabel")
    dispName.AutomaticSize          = Enum.AutomaticSize.XY
    dispName.BackgroundTransparency = 1
    dispName.Text                   = LocalPlayer.DisplayName
    dispName.Font                   = Enum.Font.GothamMedium
    dispName.TextSize               = 13
    dispName.TextColor3             = T().textPrimary
    dispName.TextXAlignment         = Enum.TextXAlignment.Left
    dispName.Parent                 = userInfo

    local userName                  = Instance.new("TextLabel")
    userName.AutomaticSize          = Enum.AutomaticSize.XY
    userName.BackgroundTransparency = 1
    userName.Text                   = "@" .. LocalPlayer.Name
    userName.Font                   = Enum.Font.Gotham
    userName.TextSize               = 11
    userName.TextColor3             = T().textMuted
    userName.TextXAlignment         = Enum.TextXAlignment.Left
    userName.LayoutOrder            = 1
    userName.Parent                 = userInfo

    local content                   = Instance.new("Frame")
    content.Name                    = "Content"
    content.Position                = UDim2.fromOffset(0, 70)
    content.Size                    = UDim2.new(1, 0, 1, -70)
    content.BackgroundTransparency  = 1
    content.ClipsDescendants        = true
    content.Parent                  = main

    onThemeChange(function(th)
        main.BackgroundColor3           = th.bg
        topbar.BackgroundColor3         = th.topbar
        topbarBottomCover.BackgroundColor3 = th.topbar
        topbarDivider.BackgroundColor3  = th.divider
        titleLabel.TextColor3           = th.textPrimary
        profileFrame.BackgroundColor3   = th.profile
        dispName.TextColor3             = th.textPrimary
        userName.TextColor3             = th.textMuted
    end)

    local dragging, dragInput, dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging    = true
            dragStart   = input.Position
            startPos    = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            visible = not visible

            if visible then
                main.Visible    = true
                main.Size       = Settings.Size or UDim2.fromOffset(820, 540)
                main.Position   = UDim2.fromScale(0.5, 0.5)

                Tween(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = Settings.Size or UDim2.fromOffset(820, 540)
                }):Play()
            else
                local t = Tween(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Size = UDim2.fromOffset(820, 0)
                })
                t:Play()
                t.Completed:Connect(function()
                    if not visible then
                        main.Visible = false
                        main.Size    = Settings.Size or UDim2.fromOffset(820, 540)
                    end
                end)
            end
        end
    end)

    function WindowFunctions:SetTheme(name)
        if THEMES[name] then
            applyTheme(name)
        end
    end

    function WindowFunctions:SetTitle(text)
        titleLabel.Text = text
    end

    function WindowFunctions:Notify(Settings)
        local holder = gui:FindFirstChild("NotifHolder")

        if not holder then
            holder                      = Instance.new("Frame")
            holder.Name                 = "NotifHolder"
            holder.AnchorPoint          = Vector2.new(1, 1)
            holder.Position             = UDim2.new(1, -20, 1, -20)
            holder.Size                 = UDim2.fromOffset(310, 0)
            holder.AutomaticSize        = Enum.AutomaticSize.Y
            holder.BackgroundTransparency = 1
            holder.Parent               = gui

            local hl                    = Instance.new("UIListLayout")
            hl.Padding                  = UDim.new(0, 8)
            hl.SortOrder                = Enum.SortOrder.LayoutOrder
            hl.VerticalAlignment        = Enum.VerticalAlignment.Bottom
            hl.Parent                   = holder
        end

        local n                         = Instance.new("Frame")
        n.Size                          = UDim2.new(1, 0, 0, 0)
        n.AutomaticSize                 = Enum.AutomaticSize.Y
        n.BackgroundColor3              = T().notifBg
        n.BorderSizePixel               = 0
        n.Position                      = UDim2.fromOffset(40, 0)
        n.BackgroundTransparency        = 1
        n.Parent                        = holder

        local nc                        = Instance.new("UICorner")
        nc.CornerRadius                 = UDim.new(0, 12)
        nc.Parent                       = n

        local ns                        = Instance.new("UIStroke")
        ns.Color                        = T().sectionStroke
        ns.Thickness                    = 1
        ns.Parent                       = n

        local np                        = Instance.new("UIPadding")
        np.PaddingTop                   = UDim.new(0, 13)
        np.PaddingBottom                = UDim.new(0, 13)
        np.PaddingLeft                  = UDim.new(0, 16)
        np.PaddingRight                 = UDim.new(0, 16)
        np.Parent                       = n

        local nl                        = Instance.new("UIListLayout")
        nl.Padding                      = UDim.new(0, 4)
        nl.SortOrder                    = Enum.SortOrder.LayoutOrder
        nl.Parent                       = n

        local nt                        = Instance.new("TextLabel")
        nt.AutomaticSize                = Enum.AutomaticSize.XY
        nt.BackgroundTransparency       = 1
        nt.Text                         = Settings.Title or "Notification"
        nt.Font                         = Enum.Font.GothamBold
        nt.TextSize                     = 14
        nt.TextColor3                   = T().textPrimary
        nt.TextXAlignment               = Enum.TextXAlignment.Left
        nt.Parent                       = n

        local nd                        = Instance.new("TextLabel")
        nd.Size                         = UDim2.new(1, 0, 0, 0)
        nd.AutomaticSize                = Enum.AutomaticSize.Y
        nd.BackgroundTransparency       = 1
        nd.Text                         = Settings.Description or ""
        nd.Font                         = Enum.Font.Gotham
        nd.TextSize                     = 12
        nd.TextColor3                   = T().textMuted
        nd.TextXAlignment               = Enum.TextXAlignment.Left
        nd.TextWrapped                  = true
        nd.LayoutOrder                  = 1
        nd.Parent                       = n

        Tween(n, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency  = 0,
            Position                = UDim2.fromOffset(0, 0)
        }):Play()

        task.delay(Settings.Duration or 3, function()
            local out = Tween(n, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency  = 1,
                Position                = UDim2.fromOffset(40, 0)
            })
            out:Play()
            out.Completed:Wait()
            n:Destroy()
        end)
    end

    function WindowFunctions:Tab(Settings)
        local TabFunctions = {}

        local tabBtn                    = Instance.new("TextButton")
        tabBtn.Name                     = Settings.Name
        tabBtn.AutomaticSize            = Enum.AutomaticSize.X
        tabBtn.Size                     = UDim2.new(0, 0, 1, 0)
        tabBtn.BackgroundColor3         = T().tabIdle
        tabBtn.BorderSizePixel          = 0
        tabBtn.Text                     = Settings.Name
        tabBtn.Font                     = Enum.Font.GothamMedium
        tabBtn.TextSize                 = 14
        tabBtn.TextColor3               = T().tabIdleText
        tabBtn.AutoButtonColor          = false
        tabBtn.Parent                   = navBar

        local tabBtnCorner              = Instance.new("UICorner")
        tabBtnCorner.CornerRadius       = UDim.new(0, 10)
        tabBtnCorner.Parent             = tabBtn

        local tabBtnPad                 = Instance.new("UIPadding")
        tabBtnPad.PaddingLeft           = UDim.new(0, 18)
        tabBtnPad.PaddingRight          = UDim.new(0, 18)
        tabBtnPad.Parent                = tabBtn

        local tabContent                = Instance.new("ScrollingFrame")
        tabContent.Name                 = Settings.Name .. "_Content"
        tabContent.Size                 = UDim2.fromScale(1, 1)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel      = 0
        tabContent.ScrollBarThickness   = 3
        tabContent.ScrollBarImageColor3 = T().sectionStroke
        tabContent.AutomaticCanvasSize  = Enum.AutomaticSize.Y
        tabContent.CanvasSize           = UDim2.new()
        tabContent.Visible              = false
        tabContent.Parent               = content

        local tabPad                    = Instance.new("UIPadding")
        tabPad.PaddingTop               = UDim.new(0, 20)
        tabPad.PaddingBottom            = UDim.new(0, 20)
        tabPad.PaddingLeft              = UDim.new(0, 22)
        tabPad.PaddingRight             = UDim.new(0, 22)
        tabPad.Parent                   = tabContent

        local tabLayout                 = Instance.new("UIListLayout")
        tabLayout.Padding               = UDim.new(0, 14)
        tabLayout.SortOrder             = Enum.SortOrder.LayoutOrder
        tabLayout.Parent                = tabContent

        local function switchTab()
            for _, tab in ipairs(tabs) do
                tab.btn.BackgroundColor3    = T().tabIdle
                tab.btn.TextColor3          = T().tabIdleText
                tab.content.Visible         = false
            end
            tabBtn.BackgroundColor3     = T().tabActive
            tabBtn.TextColor3           = T().tabActiveText
            tabContent.Visible          = true
            currentTab                  = Settings.Name
        end

        tabBtn.MouseButton1Click:Connect(switchTab)

        tabBtn.MouseEnter:Connect(function()
            if currentTab ~= Settings.Name then
                Tween(tabBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = T().btnHover
                }):Play()
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if currentTab ~= Settings.Name then
                Tween(tabBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = T().tabIdle
                }):Play()
            end
        end)

        table.insert(tabs, { btn = tabBtn, content = tabContent, name = Settings.Name })

        if #tabs == 1 then switchTab() end

        onThemeChange(function(th)
            tabContent.ScrollBarImageColor3 = th.sectionStroke
            if currentTab == Settings.Name then
                tabBtn.BackgroundColor3 = th.tabActive
                tabBtn.TextColor3       = th.tabActiveText
            else
                tabBtn.BackgroundColor3 = th.tabIdle
                tabBtn.TextColor3       = th.tabIdleText
            end
        end)

        function TabFunctions:Section(Settings)
            local SectionFunctions = {}

            local sec                       = Instance.new("Frame")
            sec.Name                        = "Section"
            sec.AutomaticSize               = Enum.AutomaticSize.Y
            sec.Size                        = UDim2.new(1, 0, 0, 0)
            sec.BackgroundColor3            = T().section
            sec.BorderSizePixel             = 0
            sec.Parent                      = tabContent

            local secCorner                 = Instance.new("UICorner")
            secCorner.CornerRadius          = UDim.new(0, 12)
            secCorner.Parent                = sec

            local secStroke                 = Instance.new("UIStroke")
            secStroke.Color                 = T().sectionStroke
            secStroke.Thickness             = 1
            secStroke.Parent                = sec

            local secPad                    = Instance.new("UIPadding")
            secPad.PaddingTop               = UDim.new(0, 14)
            secPad.PaddingBottom            = UDim.new(0, 14)
            secPad.PaddingLeft              = UDim.new(0, 18)
            secPad.PaddingRight             = UDim.new(0, 18)
            secPad.Parent                   = sec

            local secLayout                 = Instance.new("UIListLayout")
            secLayout.Padding               = UDim.new(0, 10)
            secLayout.SortOrder             = Enum.SortOrder.LayoutOrder
            secLayout.Parent                = sec

            if Settings.Name then
                local secTitle              = Instance.new("TextLabel")
                secTitle.AutomaticSize      = Enum.AutomaticSize.XY
                secTitle.BackgroundTransparency = 1
                secTitle.Text               = Settings.Name
                secTitle.Font               = Enum.Font.GothamBold
                secTitle.TextSize           = 13
                secTitle.TextColor3         = T().textSec
                secTitle.TextXAlignment     = Enum.TextXAlignment.Left
                secTitle.Parent             = sec

                onThemeChange(function(th) secTitle.TextColor3 = th.textSec end)
            end

            onThemeChange(function(th)
                sec.BackgroundColor3    = th.section
                secStroke.Color         = th.sectionStroke
            end)

            function SectionFunctions:Row()
                local row               = Instance.new("Frame")
                row.Name                = "Row"
                row.AutomaticSize       = Enum.AutomaticSize.Y
                row.Size                = UDim2.new(1, 0, 0, 0)
                row.BackgroundTransparency = 1
                row.Parent              = sec

                local rl                = Instance.new("UIListLayout")
                rl.FillDirection        = Enum.FillDirection.Horizontal
                rl.Padding              = UDim.new(0, 12)
                rl.SortOrder            = Enum.SortOrder.LayoutOrder
                rl.Parent               = row

                return {Container = row}, row
            end

            local function applyBindable(frame, label, name, bindable, onPress)
                if not bindable then return end

                local currentBind   = nil
                local bindConn      = nil

                local bindLabel     = Instance.new("TextLabel")
                bindLabel.AnchorPoint = Vector2.new(1, 0.5)
                bindLabel.Position  = UDim2.new(1, 0, 0.5, 0)
                bindLabel.Size      = UDim2.fromOffset(60, 18)
                bindLabel.BackgroundTransparency = 1
                bindLabel.Text      = "[-]"
                bindLabel.Font      = Enum.Font.GothamMedium
                bindLabel.TextSize  = 11
                bindLabel.TextColor3 = T().textMuted
                bindLabel.TextXAlignment = Enum.TextXAlignment.Right
                bindLabel.Parent    = frame

                onThemeChange(function(th) bindLabel.TextColor3 = th.textMuted end)

                local function updateConn(bound)
                    if bindConn then bindConn:Disconnect() bindConn = nil end
                    currentBind = bound

                    if bound == nil then
                        bindLabel.Text = "[-]"
                        return
                    end

                    local isMouseType = typeof(bound) == "EnumItem"
                        and bound.EnumType == Enum.UserInputType

                    local displayName = isMouseType
                        and tostring(bound):gsub("Enum.UserInputType.", "")
                        or tostring(bound):gsub("Enum.KeyCode.", "")

                    bindLabel.Text = "[" .. displayName .. "]"

                    bindConn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if gpe then return end
                        local match = isMouseType
                            and input.UserInputType == bound
                            or input.KeyCode == bound
                        if match and onPress then
                            task.spawn(onPress)
                        end
                    end)
                end

                frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton2 then
                        showBindContext(name, function(bound)
                            updateConn(bound)
                        end)
                    end
                end)

                if label then
                    label.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton2 then
                            showBindContext(name, function(bound)
                                updateConn(bound)
                            end)
                        end
                    end)
                end

                updateConn(nil)
            end

            function SectionFunctions:Button(Settings)
                local parent    = Settings.Parent or sec
                local isInRow   = Settings.Parent ~= nil

                local btn                   = Instance.new("TextButton")
                btn.Size                    = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                btn.BackgroundColor3        = T().btnBg
                btn.BorderSizePixel         = 0
                btn.Text                    = Settings.Name
                btn.Font                    = Enum.Font.GothamMedium
                btn.TextSize                = 13
                btn.TextColor3              = T().textSec
                btn.AutoButtonColor         = false
                btn.Parent                  = parent

                local btnC                  = Instance.new("UICorner")
                btnC.CornerRadius           = UDim.new(0, 8)
                btnC.Parent                 = btn

                btn.MouseButton1Click:Connect(function()
                    if Settings.Callback then Settings.Callback() end
                end)
                btn.MouseEnter:Connect(function()
                    Tween(btn, TweenInfo.new(0.15), { BackgroundColor3 = T().btnHover }):Play()
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, TweenInfo.new(0.15), { BackgroundColor3 = T().btnBg }):Play()
                end)

                onThemeChange(function(th)
                    btn.BackgroundColor3    = th.btnBg
                    btn.TextColor3          = th.textSec
                end)

                applyBindable(btn, nil, Settings.Name, Settings.Bindable, Settings.Callback)
                return btn
            end

            function SectionFunctions:Toggle(Settings)
                local ToggleFunctions   = {}
                local toggled           = Settings.Default or false
                local parent            = Settings.Parent or sec
                local isInRow           = Settings.Parent ~= nil

                local frame             = Instance.new("Frame")
                frame.Size              = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                frame.BackgroundTransparency = 1
                frame.Parent            = parent

                local lbl               = Instance.new("TextLabel")
                lbl.AnchorPoint         = Vector2.new(0, 0.5)
                lbl.Position            = UDim2.fromScale(0, 0.5)
                lbl.Size                = UDim2.new(1, -30, 0, 0)
                lbl.AutomaticSize       = Enum.AutomaticSize.Y
                lbl.BackgroundTransparency = 1
                lbl.Text                = Settings.Name
                lbl.Font                = Enum.Font.GothamMedium
                lbl.TextSize            = 13
                lbl.TextColor3          = T().textSec
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.TextTruncate        = Enum.TextTruncate.AtEnd
                lbl.Parent              = frame

                local box               = Instance.new("Frame")
                box.AnchorPoint         = Vector2.new(1, 0.5)
                box.Position            = UDim2.fromScale(1, 0.5)
                box.Size                = UDim2.fromOffset(18, 18)
                box.BackgroundColor3    = T().checkBg
                box.BorderSizePixel     = 0
                box.Parent              = frame

                local boxCorner         = Instance.new("UICorner")
                boxCorner.CornerRadius  = UDim.new(0, 5)
                boxCorner.Parent        = box

                local check             = Instance.new("TextLabel")
                check.AnchorPoint       = Vector2.new(0.5, 0.5)
                check.Position          = UDim2.fromScale(0.5, 0.5)
                check.Size              = UDim2.fromOffset(14, 14)
                check.BackgroundTransparency = 1
                check.Text              = "✓"
                check.Font              = Enum.Font.GothamBold
                check.TextSize          = 13
                check.TextColor3        = T().checkOn
                check.TextXAlignment    = Enum.TextXAlignment.Center
                check.TextTransparency  = toggled and 0 or 1
                check.Parent            = box

                local interact          = Instance.new("TextButton")
                interact.Size           = UDim2.fromScale(1, 1)
                interact.BackgroundTransparency = 1
                interact.Text           = ""
                interact.Parent         = frame

                local function setState(state, fire)
                    toggled = state
                    Tween(box, TweenInfo.new(0.15), {
                        BackgroundColor3 = state and T().checkOn or T().checkBg
                    }):Play()
                    Tween(check, TweenInfo.new(0.15), {
                        TextTransparency = state and 0 or 1,
                        TextColor3       = state and T().bg or T().checkOn
                    }):Play()
                    if fire and Settings.Callback then Settings.Callback(state) end
                end

                setState(toggled, false)

                interact.MouseButton1Click:Connect(function()
                    setState(not toggled, true)
                end)

                onThemeChange(function(th)
                    lbl.TextColor3 = th.textSec
                    setState(toggled, false)
                end)

                applyBindable(frame, lbl, Settings.Name, Settings.Bindable, function()
                    setState(not toggled, true)
                end)

                function ToggleFunctions:SetValue(v) setState(v, false) end
                function ToggleFunctions:GetValue()  return toggled end

                return ToggleFunctions
            end

            function SectionFunctions:Slider(Settings)
                local SliderFunctions   = {}
                local value             = Settings.Default or Settings.Min or 0
                local parent            = Settings.Parent or sec
                local isInRow           = Settings.Parent ~= nil

                local frame             = Instance.new("Frame")
                frame.Size              = isInRow and UDim2.new(0.5, -6, 0, 48) or UDim2.new(1, 0, 0, 48)
                frame.BackgroundTransparency = 1
                frame.Parent            = parent

                local lbl               = Instance.new("TextLabel")
                lbl.Size                = UDim2.new(1, -60, 0, 16)
                lbl.BackgroundTransparency = 1
                lbl.Text                = Settings.Name
                lbl.Font                = Enum.Font.GothamMedium
                lbl.TextSize            = 13
                lbl.TextColor3          = T().textSec
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.TextTruncate        = Enum.TextTruncate.AtEnd
                lbl.Parent              = frame

                local valLbl            = Instance.new("TextLabel")
                valLbl.AnchorPoint      = Vector2.new(1, 0)
                valLbl.Position         = UDim2.fromScale(1, 0)
                valLbl.Size             = UDim2.fromOffset(55, 16)
                valLbl.BackgroundTransparency = 1
                valLbl.Text             = tostring(value)
                valLbl.Font             = Enum.Font.GothamBold
                valLbl.TextSize         = 12
                valLbl.TextColor3       = T().textMuted
                valLbl.TextXAlignment   = Enum.TextXAlignment.Right
                valLbl.Parent           = frame

                local track             = Instance.new("Frame")
                track.Position          = UDim2.fromOffset(0, 28)
                track.Size              = UDim2.new(1, 0, 0, 5)
                track.BackgroundColor3  = T().checkBg
                track.BorderSizePixel   = 0
                track.Parent            = frame

                local trackCorner       = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent      = track

                local fill              = Instance.new("Frame")
                fill.Size               = UDim2.fromScale(0, 1)
                fill.BackgroundColor3   = T().accent
                fill.BorderSizePixel    = 0
                fill.Parent             = track

                local fillCorner        = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent       = fill

                local thumb             = Instance.new("Frame")
                thumb.AnchorPoint       = Vector2.new(0.5, 0.5)
                thumb.Position          = UDim2.fromScale(0, 0.5)
                thumb.Size              = UDim2.fromOffset(14, 14)
                thumb.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
                thumb.BorderSizePixel   = 0
                thumb.Parent            = fill

                local thumbCorner       = Instance.new("UICorner")
                thumbCorner.CornerRadius = UDim.new(1, 0)
                thumbCorner.Parent      = thumb

                local thumbStroke       = Instance.new("UIStroke")
                thumbStroke.Color       = T().accent
                thumbStroke.Thickness   = 2
                thumbStroke.Parent      = thumb

                local draggingSlider    = false

                local function updateVal(input)
                    local pct = math.clamp(
                        (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1
                    )
                    value           = math.floor(Settings.Min + (Settings.Max - Settings.Min) * pct)
                    fill.Size       = UDim2.fromScale(pct, 1)
                    valLbl.Text     = tostring(value)
                    if Settings.Callback then Settings.Callback(value) end
                end

                track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = true
                        updateVal(i)
                    end
                end)
                track.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
                        updateVal(i)
                    end
                end)

                onThemeChange(function(th)
                    lbl.TextColor3      = th.textSec
                    valLbl.TextColor3   = th.textMuted
                    track.BackgroundColor3 = th.checkBg
                    fill.BackgroundColor3  = th.accent
                    thumbStroke.Color      = th.accent
                end)

                function SliderFunctions:SetValue(v)
                    value = math.clamp(v, Settings.Min, Settings.Max)
                    local pct = (value - Settings.Min) / (Settings.Max - Settings.Min)
                    fill.Size       = UDim2.fromScale(pct, 1)
                    valLbl.Text     = tostring(value)
                end
                function SliderFunctions:GetValue() return value end

                SliderFunctions:SetValue(value)
                return SliderFunctions
            end

            function SectionFunctions:Input(Settings)
                local InputFunctions    = {}
                local parent            = Settings.Parent or sec
                local isInRow           = Settings.Parent ~= nil

                local frame             = Instance.new("Frame")
                frame.Size              = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                frame.BackgroundTransparency = 1
                frame.Parent            = parent

                local lbl               = Instance.new("TextLabel")
                lbl.AnchorPoint         = Vector2.new(0, 0.5)
                lbl.Position            = UDim2.fromScale(0, 0.5)
                lbl.Size                = UDim2.new(0.44, 0, 0, 0)
                lbl.AutomaticSize       = Enum.AutomaticSize.Y
                lbl.BackgroundTransparency = 1
                lbl.Text                = Settings.Name
                lbl.Font                = Enum.Font.GothamMedium
                lbl.TextSize            = 13
                lbl.TextColor3          = T().textSec
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.TextTruncate        = Enum.TextTruncate.AtEnd
                lbl.Parent              = frame

                local inputBox          = Instance.new("TextBox")
                inputBox.AnchorPoint    = Vector2.new(1, 0.5)
                inputBox.Position       = UDim2.fromScale(1, 0.5)
                inputBox.Size           = UDim2.new(0.53, 0, 0, 26)
                inputBox.BackgroundColor3 = T().inputBg
                inputBox.BorderSizePixel = 0
                inputBox.Text           = Settings.Default or ""
                inputBox.PlaceholderText = Settings.Placeholder or ""
                inputBox.Font           = Enum.Font.Gotham
                inputBox.TextSize       = 12
                inputBox.TextColor3     = T().textSec
                inputBox.PlaceholderColor3 = T().textMuted
                inputBox.ClearTextOnFocus = false
                inputBox.Parent         = frame

                local inputCorner       = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, 6)
                inputCorner.Parent      = inputBox

                local inputPad          = Instance.new("UIPadding")
                inputPad.PaddingLeft    = UDim.new(0, 8)
                inputPad.PaddingRight   = UDim.new(0, 8)
                inputPad.Parent         = inputBox

                inputBox.FocusLost:Connect(function()
                    if Settings.Callback then Settings.Callback(inputBox.Text) end
                end)

                onThemeChange(function(th)
                    lbl.TextColor3              = th.textSec
                    inputBox.BackgroundColor3   = th.inputBg
                    inputBox.TextColor3         = th.textSec
                    inputBox.PlaceholderColor3  = th.textMuted
                end)

                function InputFunctions:SetValue(t) inputBox.Text = t end
                function InputFunctions:GetValue()  return inputBox.Text end

                return InputFunctions
            end

            function SectionFunctions:Dropdown(Settings)
                local DropdownFunctions = {}
                local selected          = Settings.Default or Settings.Options[1]
                local opened            = false
                local parent            = Settings.Parent or sec
                local isInRow           = Settings.Parent ~= nil

                local frame             = Instance.new("Frame")
                frame.Size              = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                frame.BackgroundColor3  = T().inputBg
                frame.BorderSizePixel   = 0
                frame.ClipsDescendants  = true
                frame.Parent            = parent

                local frameCorner       = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent      = frame

                local hdr               = Instance.new("TextButton")
                hdr.Size                = UDim2.new(1, 0, 0, 34)
                hdr.BackgroundTransparency = 1
                hdr.Text                = ""
                hdr.Parent              = frame

                local dLbl              = Instance.new("TextLabel")
                dLbl.Position           = UDim2.fromOffset(12, 0)
                dLbl.Size               = UDim2.new(1, -34, 0, 34)
                dLbl.BackgroundTransparency = 1
                dLbl.Text               = Settings.Name .. ":  " .. selected
                dLbl.Font               = Enum.Font.GothamMedium
                dLbl.TextSize           = 13
                dLbl.TextColor3         = T().textSec
                dLbl.TextXAlignment     = Enum.TextXAlignment.Left
                dLbl.TextTruncate       = Enum.TextTruncate.AtEnd
                dLbl.Parent             = frame

                local arrow             = Instance.new("TextLabel")
                arrow.AnchorPoint       = Vector2.new(1, 0)
                arrow.Position          = UDim2.new(1, -10, 0, 0)
                arrow.Size              = UDim2.fromOffset(14, 34)
                arrow.BackgroundTransparency = 1
                arrow.Text              = "▾"
                arrow.Font              = Enum.Font.GothamBold
                arrow.TextSize          = 14
                arrow.TextColor3        = T().textMuted
                arrow.Parent            = frame

                local opts              = Instance.new("Frame")
                opts.Position           = UDim2.fromOffset(0, 34)
                opts.Size               = UDim2.new(1, 0, 0, 0)
                opts.AutomaticSize      = Enum.AutomaticSize.Y
                opts.BackgroundTransparency = 1
                opts.Parent             = frame

                local optsLayout        = Instance.new("UIListLayout")
                optsLayout.Padding      = UDim.new(0, 3)
                optsLayout.SortOrder    = Enum.SortOrder.LayoutOrder
                optsLayout.Parent       = opts

                local optsPad           = Instance.new("UIPadding")
                optsPad.PaddingLeft     = UDim.new(0, 6)
                optsPad.PaddingRight    = UDim.new(0, 6)
                optsPad.PaddingBottom   = UDim.new(0, 6)
                optsPad.Parent          = opts

                for _, opt in ipairs(Settings.Options) do
                    local ob            = Instance.new("TextButton")
                    ob.Size             = UDim2.new(1, 0, 0, 26)
                    ob.BackgroundColor3 = T().section
                    ob.BorderSizePixel  = 0
                    ob.Text             = opt
                    ob.Font             = Enum.Font.Gotham
                    ob.TextSize         = 12
                    ob.TextColor3       = T().textSec
                    ob.AutoButtonColor  = false
                    ob.Parent           = opts

                    local oc            = Instance.new("UICorner")
                    oc.CornerRadius     = UDim.new(0, 5)
                    oc.Parent           = ob

                    ob.MouseEnter:Connect(function()
                        ob.BackgroundColor3 = T().btnHover
                    end)
                    ob.MouseLeave:Connect(function()
                        ob.BackgroundColor3 = T().section
                    end)
                    ob.MouseButton1Click:Connect(function()
                        selected            = opt
                        dLbl.Text           = Settings.Name .. ":  " .. selected
                        opened              = false
                        arrow.Text          = "▾"
                        frame.Size          = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                        if Settings.Callback then Settings.Callback(selected) end
                    end)

                    onThemeChange(function(th)
                        ob.BackgroundColor3 = th.section
                        ob.TextColor3       = th.textSec
                    end)
                end

                hdr.MouseButton1Click:Connect(function()
                    opened = not opened
                    arrow.Text = opened and "▴" or "▾"
                    local listH = opts.AbsoluteSize.Y
                    frame.Size = isInRow
                        and UDim2.new(0.5, -6, 0, opened and 34 + listH or 34)
                        or  UDim2.new(1, 0, 0, opened and 34 + listH or 34)
                end)

                onThemeChange(function(th)
                    frame.BackgroundColor3  = th.inputBg
                    dLbl.TextColor3         = th.textSec
                    arrow.TextColor3        = th.textMuted
                end)

                function DropdownFunctions:SetValue(v)
                    selected    = v
                    dLbl.Text   = Settings.Name .. ":  " .. selected
                end
                function DropdownFunctions:GetValue() return selected end

                return DropdownFunctions
            end

            function SectionFunctions:Keybind(Settings)
                local KeybindFunctions  = {}
                local currentKey        = Settings.Default or nil
                local binding           = false
                local parent            = Settings.Parent or sec
                local isInRow           = Settings.Parent ~= nil

                local frame             = Instance.new("Frame")
                frame.Size              = isInRow and UDim2.new(0.5, -6, 0, 34) or UDim2.new(1, 0, 0, 34)
                frame.BackgroundTransparency = 1
                frame.Parent            = parent

                local lbl               = Instance.new("TextLabel")
                lbl.AnchorPoint         = Vector2.new(0, 0.5)
                lbl.Position            = UDim2.fromScale(0, 0.5)
                lbl.Size                = UDim2.new(1, -92, 0, 0)
                lbl.AutomaticSize       = Enum.AutomaticSize.Y
                lbl.BackgroundTransparency = 1
                lbl.Text                = Settings.Name
                lbl.Font                = Enum.Font.GothamMedium
                lbl.TextSize            = 13
                lbl.TextColor3          = T().textSec
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.TextTruncate        = Enum.TextTruncate.AtEnd
                lbl.Parent              = frame

                local kBtn              = Instance.new("TextButton")
                kBtn.AnchorPoint        = Vector2.new(1, 0.5)
                kBtn.Position           = UDim2.fromScale(1, 0.5)
                kBtn.Size               = UDim2.fromOffset(80, 24)
                kBtn.BackgroundColor3   = T().inputBg
                kBtn.BorderSizePixel    = 0
                kBtn.Text               = currentKey and currentKey.Name or "None"
                kBtn.Font               = Enum.Font.GothamBold
                kBtn.TextSize           = 11
                kBtn.TextColor3         = T().textMuted
                kBtn.AutoButtonColor    = false
                kBtn.Parent             = frame

                local kCorner           = Instance.new("UICorner")
                kCorner.CornerRadius    = UDim.new(0, 6)
                kCorner.Parent          = kBtn

                kBtn.MouseButton1Click:Connect(function()
                    binding             = true
                    kBtn.Text           = "..."
                    kBtn.TextColor3     = T().accent
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if not binding then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard
                        and input.KeyCode ~= Enum.KeyCode.Unknown then
                        currentKey          = input.KeyCode
                        kBtn.Text           = input.KeyCode.Name
                        kBtn.TextColor3     = T().textMuted
                        binding             = false
                        if Settings.Callback then Settings.Callback(input.KeyCode) end
                    end
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding then return end
                    if not currentKey then return end
                    if input.KeyCode == currentKey and Settings.onPress then
                        Settings.onPress()
                    end
                end)

                onThemeChange(function(th)
                    lbl.TextColor3          = th.textSec
                    kBtn.BackgroundColor3   = th.inputBg
                    kBtn.TextColor3         = th.textMuted
                end)

                function KeybindFunctions:SetKey(k)
                    currentKey  = k
                    kBtn.Text   = k and k.Name or "None"
                end
                function KeybindFunctions:GetKey() return currentKey end

                return KeybindFunctions
            end

            return SectionFunctions
        end

        return TabFunctions
    end

    return WindowFunctions
end

return ModernUI
