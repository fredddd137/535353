local Alprazolam = {
    Options = {},
    Folder  = "Alprazolam",
}

function Alprazolam.GetService(service)
    return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
end

local TweenService      = Alprazolam.GetService("TweenService")
local RunService        = Alprazolam.GetService("RunService")
local HttpService       = Alprazolam.GetService("HttpService")
local UserInputService  = Alprazolam.GetService("UserInputService")
local Players           = Alprazolam.GetService("Players")
local Lighting          = Alprazolam.GetService("Lighting")

local LocalPlayer   = Players.LocalPlayer
local currentTab    = nil
local tabs          = {}
local unloaded      = false

local assets = {
    interFont = "rbxassetid://12187365364",
}

local function GetGui()
    local gui               = Instance.new("ScreenGui")
    gui.ScreenInsets        = Enum.ScreenInsets.None
    gui.ResetOnSpawn        = false
    gui.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder        = 2147483647
    
    local parent = RunService:IsStudio() 
        and LocalPlayer:FindFirstChild("PlayerGui")
        or (gethui and gethui())
        or Alprazolam.GetService("CoreGui")
    
    gui.Parent = parent
    return gui
end

local function Tween(instance, info, props)
    return TweenService:Create(instance, info, props)
end

function Alprazolam:Window(Settings)
    local WindowFunctions = { Settings = Settings }
    local gui = GetGui()
    gui.Name = "Alprazolam"
    
    local main                      = Instance.new("Frame")
    main.Name                       = "Main"
    main.AnchorPoint                = Vector2.new(0.5, 0.5)
    main.Position                   = UDim2.fromScale(0.5, 0.5)
    main.Size                       = Settings.Size or UDim2.fromOffset(780, 520)
    main.BackgroundColor3           = Color3.fromRGB(250, 250, 250)
    main.BorderSizePixel            = 0
    main.Parent                     = gui
    
    local mainCorner                = Instance.new("UICorner")
    mainCorner.CornerRadius         = UDim.new(0, 16)
    mainCorner.Parent               = main
    local shadow                    = Instance.new("ImageLabel")
    shadow.Name                     = "Shadow"
    shadow.AnchorPoint              = Vector2.new(0.5, 0.5)
    shadow.Position                 = UDim2.fromScale(0.5, 0.5)
    shadow.Size                     = UDim2.fromScale(1, 1) + UDim2.fromOffset(40, 40)
    shadow.BackgroundTransparency   = 1
    shadow.Image                    = "rbxassetid://5554236805"
    shadow.ImageColor3              = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency        = 0.7
    shadow.ScaleType                = Enum.ScaleType.Slice
    shadow.SliceCenter              = Rect.new(23, 23, 277, 277)
    shadow.ZIndex                   = -1
    shadow.Parent                   = main
    
    local topbar                    = Instance.new("Frame")
    topbar.Name                     = "Topbar"
    topbar.Size                     = UDim2.new(1, 0, 0, 70)
    topbar.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
    topbar.BorderSizePixel          = 0
    topbar.Parent                   = main
    
    local topbarCorner              = Instance.new("UICorner")
    topbarCorner.CornerRadius       = UDim.new(0, 16)
    topbarCorner.Parent             = topbar
    
    local topbarBottom              = Instance.new("Frame")
    topbarBottom.AnchorPoint        = Vector2.new(0, 1)
    topbarBottom.Position           = UDim2.fromScale(0, 1)
    topbarBottom.Size               = UDim2.new(1, 0, 0, 16)
    topbarBottom.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
    topbarBottom.BorderSizePixel    = 0
    topbarBottom.Parent             = topbar
    
    local topbarDivider             = Instance.new("Frame")
    topbarDivider.AnchorPoint       = Vector2.new(0, 1)
    topbarDivider.Position          = UDim2.fromScale(0, 1)
    topbarDivider.Size              = UDim2.new(1, 0, 0, 1)
    topbarDivider.BackgroundColor3  = Color3.fromRGB(230, 230, 230)
    topbarDivider.BorderSizePixel   = 0
    topbarDivider.Parent            = topbar
    
    local titleFrame                = Instance.new("Frame")
    titleFrame.Position             = UDim2.fromOffset(24, 0)
    titleFrame.Size                 = UDim2.new(0.3, 0, 1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent               = topbar
    
    local title                     = Instance.new("TextLabel")
    title.AnchorPoint               = Vector2.new(0, 0.5)
    title.Position                  = UDim2.fromScale(0, 0.5)
    title.AutomaticSize             = Enum.AutomaticSize.XY
    title.BackgroundTransparency    = 1
    title.Text                      = Settings.Title or "Modern UI"
    title.Font                      = Enum.Font.GothamBold
    title.TextSize                  = 18
    title.TextColor3                = Color3.fromRGB(30, 30, 30)
    title.TextXAlignment            = Enum.TextXAlignment.Left
    title.Parent                    = titleFrame
    
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
    profileFrame.Position           = UDim2.new(1, -24, 0.5, 0)
    profileFrame.Size               = UDim2.fromOffset(180, 44)
    profileFrame.BackgroundColor3   = Color3.fromRGB(245, 245, 245)
    profileFrame.BorderSizePixel    = 0
    profileFrame.Parent             = topbar
    
    local profileCorner             = Instance.new("UICorner")
    profileCorner.CornerRadius      = UDim.new(1, 0)
    profileCorner.Parent            = profileFrame
    
    local profilePadding            = Instance.new("UIPadding")
    profilePadding.PaddingLeft      = UDim.new(0, 6)
    profilePadding.PaddingRight     = UDim.new(0, 12)
    profilePadding.Parent           = profileFrame
    
    local profileLayout             = Instance.new("UIListLayout")
    profileLayout.FillDirection     = Enum.FillDirection.Horizontal
    profileLayout.Padding           = UDim.new(0, 10)
    profileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    profileLayout.Parent            = profileFrame
    local userId        = LocalPlayer.UserId
    local thumbType     = Enum.ThumbnailType.HeadShot
    local thumbSize     = Enum.ThumbnailSize.Size150x150
    local avatarImg     = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    local avatar                    = Instance.new("ImageLabel")
    avatar.Size                     = UDim2.fromOffset(32, 32)
    avatar.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
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
    
    local displayName               = Instance.new("TextLabel")
    displayName.AutomaticSize       = Enum.AutomaticSize.XY
    displayName.BackgroundTransparency = 1
    displayName.Text                = LocalPlayer.DisplayName
    displayName.Font                = Enum.Font.GothamMedium
    displayName.TextSize            = 13
    displayName.TextColor3          = Color3.fromRGB(30, 30, 30)
    displayName.TextXAlignment      = Enum.TextXAlignment.Left
    displayName.Parent              = userInfo
    
    local username                  = Instance.new("TextLabel")
    username.AutomaticSize          = Enum.AutomaticSize.XY
    username.BackgroundTransparency = 1
    username.Text                   = "@" .. LocalPlayer.Name
    username.Font                   = Enum.Font.Gotham
    username.TextSize               = 11
    username.TextColor3             = Color3.fromRGB(120, 120, 120)
    username.TextXAlignment         = Enum.TextXAlignment.Left
    username.LayoutOrder            = 1
    username.Parent                 = userInfo
    
    local content                   = Instance.new("Frame")
    content.Name                    = "Content"
    content.Position                = UDim2.fromOffset(0, 70)
    content.Size                    = UDim2.new(1, 0, 1, -70)
    content.BackgroundTransparency  = 1
    content.ClipsDescendants        = true
    content.Parent                  = main
    
    local dragging, dragInput, dragStart, startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
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
            updateDrag(input)
        end
    end)
    
    function WindowFunctions:Tab(Settings)
        local TabFunctions = {}
        local tabButton             = Instance.new("TextButton")
        tabButton.Name              = Settings.Name
        tabButton.AutomaticSize     = Enum.AutomaticSize.X
        tabButton.Size              = UDim2.new(0, 0, 1, 0)
        tabButton.BackgroundColor3  = Color3.fromRGB(240, 240, 240)
        tabButton.BorderSizePixel   = 0
        tabButton.Text              = Settings.Name
        tabButton.Font              = Enum.Font.GothamMedium
        tabButton.TextSize          = 14
        tabButton.TextColor3        = Color3.fromRGB(100, 100, 100)
        tabButton.AutoButtonColor   = false
        tabButton.Parent            = navBar
        
        local tabCorner             = Instance.new("UICorner")
        tabCorner.CornerRadius      = UDim.new(0, 10)
        tabCorner.Parent            = tabButton
        
        local tabPadding            = Instance.new("UIPadding")
        tabPadding.PaddingLeft      = UDim.new(0, 18)
        tabPadding.PaddingRight     = UDim.new(0, 18)
        tabPadding.Parent           = tabButton
        local tabContent            = Instance.new("ScrollingFrame")
        tabContent.Name             = Settings.Name .. "Content"
        tabContent.Size             = UDim2.fromScale(1, 1)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel  = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.CanvasSize       = UDim2.new()
        tabContent.Visible          = false
        tabContent.Parent           = content
        
        local tabContentPadding     = Instance.new("UIPadding")
        tabContentPadding.PaddingTop    = UDim.new(0, 20)
        tabContentPadding.PaddingBottom = UDim.new(0, 20)
        tabContentPadding.PaddingLeft   = UDim.new(0, 24)
        tabContentPadding.PaddingRight  = UDim.new(0, 24)
        tabContentPadding.Parent    = tabContent
        
        local tabContentLayout      = Instance.new("UIListLayout")
        tabContentLayout.Padding    = UDim.new(0, 16)
        tabContentLayout.SortOrder  = Enum.SortOrder.LayoutOrder
        tabContentLayout.Parent     = tabContent
        
        local function switchTab()
            for _, tab in pairs(tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
                tab.Button.TextColor3       = Color3.fromRGB(100, 100, 100)
                tab.Content.Visible         = false
            end
            
            tabButton.BackgroundColor3  = Color3.fromRGB(30, 30, 30)
            tabButton.TextColor3        = Color3.fromRGB(255, 255, 255)
            tabContent.Visible          = true
            currentTab                  = Settings.Name
        end
        
        tabButton.MouseButton1Click:Connect(switchTab)
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= Settings.Name then
                Tween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(235, 235, 235)
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= Settings.Name then
                Tween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(240, 240, 240)
                }):Play()
            end
        end)
        table.insert(tabs, {
            Button  = tabButton,
            Content = tabContent,
            Name    = Settings.Name
        })
        if #tabs == 1 then
            switchTab()
        end
        
        function TabFunctions:Section(Settings)
            local SectionFunctions = {}
            
            local section               = Instance.new("Frame")
            section.Name                = "Section"
            section.AutomaticSize       = Enum.AutomaticSize.Y
            section.Size                = UDim2.new(1, 0, 0, 0)
            section.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
            section.BorderSizePixel     = 0
            section.Parent              = tabContent
            
            local sectionCorner         = Instance.new("UICorner")
            sectionCorner.CornerRadius  = UDim.new(0, 12)
            sectionCorner.Parent        = section
            
            local sectionStroke         = Instance.new("UIStroke")
            sectionStroke.Color         = Color3.fromRGB(235, 235, 235)
            sectionStroke.Thickness     = 1
            sectionStroke.Parent        = section
            
            local sectionPadding        = Instance.new("UIPadding")
            sectionPadding.PaddingTop   = UDim.new(0, 16)
            sectionPadding.PaddingBottom = UDim.new(0, 16)
            sectionPadding.PaddingLeft  = UDim.new(0, 18)
            sectionPadding.PaddingRight = UDim.new(0, 18)
            sectionPadding.Parent       = section
            
            local sectionLayout         = Instance.new("UIListLayout")
            sectionLayout.Padding       = UDim.new(0, 12)
            sectionLayout.SortOrder     = Enum.SortOrder.LayoutOrder
            sectionLayout.Parent        = section
            if Settings.Name then
                local sectionTitle          = Instance.new("TextLabel")
                sectionTitle.AutomaticSize  = Enum.AutomaticSize.XY
                sectionTitle.BackgroundTransparency = 1
                sectionTitle.Text           = Settings.Name
                sectionTitle.Font           = Enum.Font.GothamBold
                sectionTitle.TextSize       = 14
                sectionTitle.TextColor3     = Color3.fromRGB(50, 50, 50)
                sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                sectionTitle.Parent         = section
            end
            
            function SectionFunctions:Row()
                local row               = Instance.new("Frame")
                row.Name                = "Row"
                row.AutomaticSize       = Enum.AutomaticSize.Y
                row.Size                = UDim2.new(1, 0, 0, 0)
                row.BackgroundTransparency = 1
                row.Parent              = section
                
                local rowLayout         = Instance.new("UIListLayout")
                rowLayout.FillDirection = Enum.FillDirection.Horizontal
                rowLayout.Padding       = UDim.new(0, 12)
                rowLayout.SortOrder     = Enum.SortOrder.LayoutOrder
                rowLayout.Parent        = row
                
                return {Container = row}, row
            end
            
            function SectionFunctions:Button(Settings)
                local parent = Settings.Parent or section
                local isInRow = Settings.Parent ~= nil
                
                local button                = Instance.new("TextButton")
                button.Name                 = "Button"
                button.Size                 = isInRow 
                    and UDim2.new(0.5, -6, 0, 38) 
                    or UDim2.new(1, 0, 0, 38)
                button.BackgroundColor3     = Color3.fromRGB(248, 248, 248)
                button.BorderSizePixel      = 0
                button.Text                 = Settings.Name
                button.Font                 = Enum.Font.GothamMedium
                button.TextSize             = 13
                button.TextColor3           = Color3.fromRGB(60, 60, 60)
                button.AutoButtonColor      = false
                button.Parent               = parent
                
                local buttonCorner          = Instance.new("UICorner")
                buttonCorner.CornerRadius   = UDim.new(0, 8)
                buttonCorner.Parent         = button
                
                button.MouseButton1Click:Connect(function()
                    if Settings.Callback then Settings.Callback() end
                end)
                
                button.MouseEnter:Connect(function()
                    Tween(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(240, 240, 240)
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    Tween(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(248, 248, 248)
                    }):Play()
                end)
                
                return button
            end
            
            function SectionFunctions:Toggle(Settings)
                local ToggleFunctions = {}
                local toggled = Settings.Default or false
                local parent = Settings.Parent or section
                local isInRow = Settings.Parent ~= nil
                
                local toggleFrame           = Instance.new("Frame")
                toggleFrame.Size            = isInRow 
                    and UDim2.new(0.5, -6, 0, 38) 
                    or UDim2.new(1, 0, 0, 38)
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Parent          = parent
                
                local toggleLabel           = Instance.new("TextLabel")
                toggleLabel.AnchorPoint     = Vector2.new(0, 0.5)
                toggleLabel.Position        = UDim2.fromScale(0, 0.5)
                toggleLabel.Size            = UDim2.new(1, -54, 0, 0)
                toggleLabel.AutomaticSize   = Enum.AutomaticSize.Y
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text            = Settings.Name
                toggleLabel.Font            = Enum.Font.GothamMedium
                toggleLabel.TextSize        = 13
                toggleLabel.TextColor3      = Color3.fromRGB(60, 60, 60)
                toggleLabel.TextXAlignment  = Enum.TextXAlignment.Left
                toggleLabel.TextTruncate    = Enum.TextTruncate.AtEnd
                toggleLabel.Parent          = toggleFrame

                local toggleTrack               = Instance.new("Frame")
                toggleTrack.Name                = "Track"
                toggleTrack.AnchorPoint         = Vector2.new(1, 0.5)
                toggleTrack.Position            = UDim2.fromScale(1, 0.5)
                toggleTrack.Size                = UDim2.fromOffset(44, 24)
                toggleTrack.BackgroundColor3    = toggled 
                    and Color3.fromRGB(100, 200, 100) 
                    or  Color3.fromRGB(200, 200, 200)
                toggleTrack.BorderSizePixel     = 0
                toggleTrack.Parent              = toggleFrame
                
                local toggleTrackCorner         = Instance.new("UICorner")
                toggleTrackCorner.CornerRadius  = UDim.new(1, 0)
                toggleTrackCorner.Parent        = toggleTrack
                
                local toggleThumb               = Instance.new("Frame")
                toggleThumb.Name                = "Thumb"
                toggleThumb.AnchorPoint         = Vector2.new(0, 0.5)
                toggleThumb.Position            = toggled 
                    and UDim2.new(1, -22, 0.5, 0) 
                    or  UDim2.fromOffset(2, 0)
                toggleThumb.Size                = UDim2.fromOffset(20, 20)
                toggleThumb.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
                toggleThumb.BorderSizePixel     = 0
                toggleThumb.Parent              = toggleTrack
                
                local toggleThumbCorner         = Instance.new("UICorner")
                toggleThumbCorner.CornerRadius  = UDim.new(1, 0)
                toggleThumbCorner.Parent        = toggleThumb
                
                local toggleInteract            = Instance.new("TextButton")
                toggleInteract.Size             = UDim2.fromScale(1, 1)
                toggleInteract.BackgroundTransparency = 1
                toggleInteract.Text             = ""
                toggleInteract.Parent           = toggleTrack
                
                local function setState(state, fireCallback)
                    Tween(toggleTrack, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = state 
                            and Color3.fromRGB(100, 200, 100) 
                            or  Color3.fromRGB(200, 200, 200)
                    }):Play()
                    
                    Tween(toggleThumb, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        Position = state 
                            and UDim2.new(1, -22, 0.5, 0) 
                            or  UDim2.fromOffset(2, 0)
                    }):Play()
                    
                    if fireCallback and Settings.Callback then
                        Settings.Callback(state)
                    end
                end
                
                toggleInteract.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    setState(toggled, true)
                end)
                
                function ToggleFunctions:SetValue(state)
                    toggled = state
                    setState(state, false)
                end
                
                function ToggleFunctions:GetValue()
                    return toggled
                end
                
                return ToggleFunctions
            end
            
            function SectionFunctions:Slider(Settings)
                local SliderFunctions = {}
                local value     = Settings.Default or Settings.Min or 0
                local parent    = Settings.Parent or section
                local isInRow   = Settings.Parent ~= nil
                
                local sliderFrame               = Instance.new("Frame")
                sliderFrame.Name                = "Slider"
                sliderFrame.Size                = isInRow 
                    and UDim2.new(0.5, -6, 0, 50) 
                    or  UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent              = parent
                
                local sliderLabel               = Instance.new("TextLabel")
                sliderLabel.Size                = UDim2.new(1, -60, 0, 16)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text                = Settings.Name
                sliderLabel.Font                = Enum.Font.GothamMedium
                sliderLabel.TextSize            = 13
                sliderLabel.TextColor3          = Color3.fromRGB(60, 60, 60)
                sliderLabel.TextXAlignment      = Enum.TextXAlignment.Left
                sliderLabel.TextTruncate        = Enum.TextTruncate.AtEnd
                sliderLabel.Parent              = sliderFrame
                
                local sliderValueLabel          = Instance.new("TextLabel")
                sliderValueLabel.AnchorPoint    = Vector2.new(1, 0)
                sliderValueLabel.Position       = UDim2.fromScale(1, 0)
                sliderValueLabel.Size           = UDim2.fromOffset(55, 16)
                sliderValueLabel.BackgroundTransparency = 1
                sliderValueLabel.Text           = tostring(value)
                sliderValueLabel.Font           = Enum.Font.GothamBold
                sliderValueLabel.TextSize       = 12
                sliderValueLabel.TextColor3     = Color3.fromRGB(100, 100, 100)
                sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                sliderValueLabel.Parent         = sliderFrame
                
                local sliderTrack               = Instance.new("Frame")
                sliderTrack.Name                = "Track"
                sliderTrack.Position            = UDim2.fromOffset(0, 30)
                sliderTrack.Size                = UDim2.new(1, 0, 0, 6)
                sliderTrack.BackgroundColor3    = Color3.fromRGB(235, 235, 235)
                sliderTrack.BorderSizePixel     = 0
                sliderTrack.Parent              = sliderFrame
                
                local sliderTrackCorner         = Instance.new("UICorner")
                sliderTrackCorner.CornerRadius  = UDim.new(1, 0)
                sliderTrackCorner.Parent        = sliderTrack
                
                local sliderFill                = Instance.new("Frame")
                sliderFill.Name                 = "Fill"
                sliderFill.Size                 = UDim2.fromScale(0, 1)
                sliderFill.BackgroundColor3     = Color3.fromRGB(100, 200, 100)
                sliderFill.BorderSizePixel      = 0
                sliderFill.Parent               = sliderTrack
                
                local sliderFillCorner          = Instance.new("UICorner")
                sliderFillCorner.CornerRadius   = UDim.new(1, 0)
                sliderFillCorner.Parent         = sliderFill
                
                local sliderThumb               = Instance.new("Frame")
                sliderThumb.Name                = "Thumb"
                sliderThumb.AnchorPoint         = Vector2.new(0.5, 0.5)
                sliderThumb.Position            = UDim2.fromScale(0, 0.5)
                sliderThumb.Size                = UDim2.fromOffset(16, 16)
                sliderThumb.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
                sliderThumb.BorderSizePixel     = 0
                sliderThumb.Parent              = sliderFill
                
                local sliderThumbCorner         = Instance.new("UICorner")
                sliderThumbCorner.CornerRadius  = UDim.new(1, 0)
                sliderThumbCorner.Parent        = sliderThumb
                
                local sliderThumbStroke         = Instance.new("UIStroke")
                sliderThumbStroke.Color         = Color3.fromRGB(100, 200, 100)
                sliderThumbStroke.Thickness     = 2
                sliderThumbStroke.Parent        = sliderThumb
                
                local dragging = false
                
                local function updateValue(input)
                    local pct = math.clamp(
                        (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X,
                        0, 1
                    )
                    value = math.floor(Settings.Min + (Settings.Max - Settings.Min) * pct)
                    
                    sliderFill.Size         = UDim2.fromScale(pct, 1)
                    sliderValueLabel.Text   = tostring(value)
                    
                    if Settings.Callback then Settings.Callback(value) end
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateValue(input)
                    end
                end)
                
                sliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input)
                    end
                end)
                
                function SliderFunctions:SetValue(val)
                    value = math.clamp(val, Settings.Min, Settings.Max)
                    local pct = (value - Settings.Min) / (Settings.Max - Settings.Min)
                    sliderFill.Size         = UDim2.fromScale(pct, 1)
                    sliderValueLabel.Text   = tostring(value)
                end
                
                function SliderFunctions:GetValue()
                    return value
                end
                
                SliderFunctions:SetValue(value)
                return SliderFunctions
            end
            
            function SectionFunctions:Input(Settings)
                local InputFunctions = {}
                local parent    = Settings.Parent or section
                local isInRow   = Settings.Parent ~= nil
                
                local inputFrame                = Instance.new("Frame")
                inputFrame.Name                 = "Input"
                inputFrame.Size                 = isInRow 
                    and UDim2.new(0.5, -6, 0, 38) 
                    or  UDim2.new(1, 0, 0, 38)
                inputFrame.BackgroundTransparency = 1
                inputFrame.Parent               = parent
                
                local inputLabel                = Instance.new("TextLabel")
                inputLabel.AnchorPoint          = Vector2.new(0, 0.5)
                inputLabel.Position             = UDim2.fromScale(0, 0.5)
                inputLabel.Size                 = UDim2.new(0.45, 0, 0, 0)
                inputLabel.AutomaticSize        = Enum.AutomaticSize.Y
                inputLabel.BackgroundTransparency = 1
                inputLabel.Text                 = Settings.Name
                inputLabel.Font                 = Enum.Font.GothamMedium
                inputLabel.TextSize             = 13
                inputLabel.TextColor3           = Color3.fromRGB(60, 60, 60)
                inputLabel.TextXAlignment       = Enum.TextXAlignment.Left
                inputLabel.TextTruncate         = Enum.TextTruncate.AtEnd
                inputLabel.Parent               = inputFrame
                
                local inputBox                  = Instance.new("TextBox")
                inputBox.Name                   = "Box"
                inputBox.AnchorPoint            = Vector2.new(1, 0.5)
                inputBox.Position               = UDim2.fromScale(1, 0.5)
                inputBox.Size                   = UDim2.new(0.52, 0, 0, 26)
                inputBox.BackgroundColor3       = Color3.fromRGB(248, 248, 248)
                inputBox.BorderSizePixel        = 0
                inputBox.Text                   = Settings.Default or ""
                inputBox.PlaceholderText        = Settings.Placeholder or "Enter text..."
                inputBox.Font                   = Enum.Font.Gotham
                inputBox.TextSize               = 12
                inputBox.TextColor3             = Color3.fromRGB(60, 60, 60)
                inputBox.PlaceholderColor3      = Color3.fromRGB(160, 160, 160)
                inputBox.ClearTextOnFocus       = false
                inputBox.Parent                 = inputFrame
                
                local inputBoxCorner            = Instance.new("UICorner")
                inputBoxCorner.CornerRadius     = UDim.new(0, 6)
                inputBoxCorner.Parent           = inputBox
                
                local inputBoxPadding           = Instance.new("UIPadding")
                inputBoxPadding.PaddingLeft     = UDim.new(0, 8)
                inputBoxPadding.PaddingRight    = UDim.new(0, 8)
                inputBoxPadding.Parent          = inputBox
                
                inputBox.Focused:Connect(function()
                    Tween(inputBox, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(242, 242, 242)
                    }):Play()
                end)
                
                inputBox.FocusLost:Connect(function()
                    Tween(inputBox, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(248, 248, 248)
                    }):Play()
                    
                    if Settings.Callback then Settings.Callback(inputBox.Text) end
                end)
                
                function InputFunctions:SetValue(text)
                    inputBox.Text = text
                end
                
                function InputFunctions:GetValue()
                    return inputBox.Text
                end
                
                return InputFunctions
            end
            
            function SectionFunctions:Keybind(Settings)
                local KeybindFunctions = {}
                local currentKey    = Settings.Default or nil
                local binding       = false
                local parent        = Settings.Parent or section
                local isInRow       = Settings.Parent ~= nil
                
                local keybindFrame              = Instance.new("Frame")
                keybindFrame.Name               = "Keybind"
                keybindFrame.Size               = isInRow 
                    and UDim2.new(0.5, -6, 0, 38) 
                    or  UDim2.new(1, 0, 0, 38)
                keybindFrame.BackgroundTransparency = 1
                keybindFrame.Parent             = parent
                
                local keybindLabel              = Instance.new("TextLabel")
                keybindLabel.AnchorPoint        = Vector2.new(0, 0.5)
                keybindLabel.Position           = UDim2.fromScale(0, 0.5)
                keybindLabel.Size               = UDim2.new(1, -92, 0, 0)
                keybindLabel.AutomaticSize      = Enum.AutomaticSize.Y
                keybindLabel.BackgroundTransparency = 1
                keybindLabel.Text               = Settings.Name
                keybindLabel.Font               = Enum.Font.GothamMedium
                keybindLabel.TextSize           = 13
                keybindLabel.TextColor3         = Color3.fromRGB(60, 60, 60)
                keybindLabel.TextXAlignment     = Enum.TextXAlignment.Left
                keybindLabel.TextTruncate       = Enum.TextTruncate.AtEnd
                keybindLabel.Parent             = keybindFrame
                
                local keybindBtn                = Instance.new("TextButton")
                keybindBtn.Name                 = "BindButton"
                keybindBtn.AnchorPoint          = Vector2.new(1, 0.5)
                keybindBtn.Position             = UDim2.fromScale(1, 0.5)
                keybindBtn.Size                 = UDim2.fromOffset(80, 26)
                keybindBtn.BackgroundColor3     = Color3.fromRGB(248, 248, 248)
                keybindBtn.BorderSizePixel      = 0
                keybindBtn.Text                 = currentKey and currentKey.Name or "None"
                keybindBtn.Font                 = Enum.Font.GothamBold
                keybindBtn.TextSize             = 11
                keybindBtn.TextColor3           = Color3.fromRGB(100, 100, 100)
                keybindBtn.AutoButtonColor      = false
                keybindBtn.Parent               = keybindFrame
                
                local keybindBtnCorner          = Instance.new("UICorner")
                keybindBtnCorner.CornerRadius   = UDim.new(0, 6)
                keybindBtnCorner.Parent         = keybindBtn
                
                keybindBtn.MouseButton1Click:Connect(function()
                    binding             = true
                    keybindBtn.Text     = "..."
                    keybindBtn.TextColor3 = Color3.fromRGB(100, 200, 100)
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKey              = input.KeyCode
                            keybindBtn.Text         = input.KeyCode.Name
                            keybindBtn.TextColor3   = Color3.fromRGB(100, 100, 100)
                            binding                 = false
                            
                            if Settings.Callback then Settings.Callback(input.KeyCode) end
                        end
                        
                    elseif not binding and currentKey and input.KeyCode == currentKey then
                        if Settings.onPress then Settings.onPress() end
                    end
                end)
                
                function KeybindFunctions:SetKey(key)
                    currentKey      = key
                    keybindBtn.Text = key.Name
                end
                
                function KeybindFunctions:GetKey()
                    return currentKey
                end
                
                return KeybindFunctions
            end
            
            function SectionFunctions:Dropdown(Settings)
                local DropdownFunctions = {}
                local selected  = Settings.Default or Settings.Options[1]
                local opened    = false
                local parent    = Settings.Parent or section
                local isInRow   = Settings.Parent ~= nil
                
                local dropdownFrame             = Instance.new("Frame")
                dropdownFrame.Name              = "Dropdown"
                dropdownFrame.Size              = isInRow 
                    and UDim2.new(0.5, -6, 0, 38) 
                    or  UDim2.new(1, 0, 0, 38)
                dropdownFrame.BackgroundColor3  = Color3.fromRGB(248, 248, 248)
                dropdownFrame.BorderSizePixel   = 0
                dropdownFrame.ClipsDescendants  = true
                dropdownFrame.Parent            = parent
                
                local dropdownCorner            = Instance.new("UICorner")
                dropdownCorner.CornerRadius     = UDim.new(0, 8)
                dropdownCorner.Parent           = dropdownFrame
                
                local dropdownHeader            = Instance.new("TextButton")
                dropdownHeader.Size             = UDim2.new(1, 0, 0, 38)
                dropdownHeader.BackgroundTransparency = 1
                dropdownHeader.Text             = ""
                dropdownHeader.Parent           = dropdownFrame
                
                local dropdownLabel             = Instance.new("TextLabel")
                dropdownLabel.Position          = UDim2.fromOffset(12, 0)
                dropdownLabel.Size              = UDim2.new(1, -40, 0, 38)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text              = Settings.Name .. ":  " .. selected
                dropdownLabel.Font              = Enum.Font.GothamMedium
                dropdownLabel.TextSize          = 13
                dropdownLabel.TextColor3        = Color3.fromRGB(60, 60, 60)
                dropdownLabel.TextXAlignment    = Enum.TextXAlignment.Left
                dropdownLabel.TextTruncate      = Enum.TextTruncate.AtEnd
                dropdownLabel.Parent            = dropdownFrame
                
                local dropdownArrow             = Instance.new("TextLabel")
                dropdownArrow.AnchorPoint       = Vector2.new(1, 0)
                dropdownArrow.Position          = UDim2.new(1, -12, 0, 0)
                dropdownArrow.Size              = UDim2.fromOffset(16, 38)
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Text              = "▾"
                dropdownArrow.Font              = Enum.Font.GothamBold
                dropdownArrow.TextSize          = 14
                dropdownArrow.TextColor3        = Color3.fromRGB(120, 120, 120)
                dropdownArrow.Parent            = dropdownFrame
                
                local optionsList               = Instance.new("Frame")
                optionsList.Name                = "Options"
                optionsList.Position            = UDim2.fromOffset(0, 38)
                optionsList.Size                = UDim2.new(1, 0, 0, 0)
                optionsList.AutomaticSize       = Enum.AutomaticSize.Y
                optionsList.BackgroundTransparency = 1
                optionsList.Parent              = dropdownFrame
                
                local optionsLayout             = Instance.new("UIListLayout")
                optionsLayout.Padding           = UDim.new(0, 4)
                optionsLayout.SortOrder         = Enum.SortOrder.LayoutOrder
                optionsLayout.Parent            = optionsList
                
                local optionsPadding            = Instance.new("UIPadding")
                optionsPadding.PaddingLeft      = UDim.new(0, 8)
                optionsPadding.PaddingRight     = UDim.new(0, 8)
                optionsPadding.PaddingBottom    = UDim.new(0, 8)
                optionsPadding.Parent           = optionsList
                
                for _, option in ipairs(Settings.Options) do
                    local optionBtn             = Instance.new("TextButton")
                    optionBtn.Name              = option
                    optionBtn.Size              = UDim2.new(1, 0, 0, 28)
                    optionBtn.BackgroundColor3  = Color3.fromRGB(255, 255, 255)
                    optionBtn.BorderSizePixel   = 0
                    optionBtn.Text              = option
                    optionBtn.Font              = Enum.Font.Gotham
                    optionBtn.TextSize          = 12
                    optionBtn.TextColor3        = Color3.fromRGB(80, 80, 80)
                    optionBtn.AutoButtonColor   = false
                    optionBtn.Parent            = optionsList
                    
                    local optionCorner          = Instance.new("UICorner")
                    optionCorner.CornerRadius   = UDim.new(0, 6)
                    optionCorner.Parent         = optionBtn
                    
                    optionBtn.MouseEnter:Connect(function()
                        optionBtn.BackgroundColor3 = Color3.fromRGB(244, 244, 244)
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        optionBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        selected                = option
                        dropdownLabel.Text      = Settings.Name .. ":  " .. selected
                        dropdownArrow.Text      = "▾"
                        opened                  = false
                        dropdownFrame.Size      = isInRow 
                            and UDim2.new(0.5, -6, 0, 38) 
                            or  UDim2.new(1, 0, 0, 38)
                        
                        if Settings.Callback then Settings.Callback(selected) end
                    end)
                end
                
                dropdownHeader.MouseButton1Click:Connect(function()
                    opened = not opened
                    
                    local listH = optionsList.AbsoluteSize.Y
                    local baseH = 38
                    
                    dropdownArrow.Text  = opened and "▴" or "▾"
                    dropdownFrame.Size  = isInRow
                        and UDim2.new(0.5, -6, 0, opened and baseH + listH or baseH)
                        or  UDim2.new(1, 0, 0, opened and baseH + listH or baseH)
                end)
                
                function DropdownFunctions:SetValue(val)
                    selected            = val
                    dropdownLabel.Text  = Settings.Name .. ":  " .. selected
                end
                
                function DropdownFunctions:GetValue()
                    return selected
                end
                
                return DropdownFunctions
            end
            
            
            return SectionFunctions
        end
        
        return TabFunctions
    end
    
    function WindowFunctions:Notify(Settings)
        local notifHolder = gui:FindFirstChild("NotifHolder")
        
        if not notifHolder then
            notifHolder                         = Instance.new("Frame")
            notifHolder.Name                    = "NotifHolder"
            notifHolder.AnchorPoint             = Vector2.new(1, 1)
            notifHolder.Position                = UDim2.new(1, -20, 1, -20)
            notifHolder.Size                    = UDim2.fromOffset(310, 0)
            notifHolder.AutomaticSize           = Enum.AutomaticSize.Y
            notifHolder.BackgroundTransparency  = 1
            notifHolder.Parent                  = gui
            
            local holderLayout                  = Instance.new("UIListLayout")
            holderLayout.Padding                = UDim.new(0, 8)
            holderLayout.SortOrder              = Enum.SortOrder.LayoutOrder
            holderLayout.VerticalAlignment      = Enum.VerticalAlignment.Bottom
            holderLayout.Parent                 = notifHolder
        end
        
        local notif                         = Instance.new("Frame")
        notif.Name                          = "Notification"
        notif.Size                          = UDim2.new(1, 0, 0, 0)
        notif.AutomaticSize                 = Enum.AutomaticSize.Y
        notif.BackgroundColor3              = Color3.fromRGB(255, 255, 255)
        notif.BorderSizePixel               = 0
        notif.Position                      = UDim2.fromOffset(40, 0)
        notif.BackgroundTransparency        = 1
        notif.Parent                        = notifHolder
        
        local notifCorner                   = Instance.new("UICorner")
        notifCorner.CornerRadius            = UDim.new(0, 12)
        notifCorner.Parent                  = notif
        
        local notifStroke                   = Instance.new("UIStroke")
        notifStroke.Color                   = Color3.fromRGB(230, 230, 230)
        notifStroke.Thickness               = 1
        notifStroke.Parent                  = notif
        
        local notifPadding                  = Instance.new("UIPadding")
        notifPadding.PaddingTop             = UDim.new(0, 14)
        notifPadding.PaddingBottom          = UDim.new(0, 14)
        notifPadding.PaddingLeft            = UDim.new(0, 16)
        notifPadding.PaddingRight           = UDim.new(0, 16)
        notifPadding.Parent                 = notif
        
        local notifLayout                   = Instance.new("UIListLayout")
        notifLayout.Padding                 = UDim.new(0, 5)
        notifLayout.SortOrder               = Enum.SortOrder.LayoutOrder
        notifLayout.Parent                  = notif
        
        local notifTitle                    = Instance.new("TextLabel")
        notifTitle.AutomaticSize            = Enum.AutomaticSize.XY
        notifTitle.BackgroundTransparency   = 1
        notifTitle.Text                     = Settings.Title or "Notification"
        notifTitle.Font                     = Enum.Font.GothamBold
        notifTitle.TextSize                 = 14
        notifTitle.TextColor3               = Color3.fromRGB(30, 30, 30)
        notifTitle.TextXAlignment           = Enum.TextXAlignment.Left
        notifTitle.Parent                   = notif
        
        local notifDesc                     = Instance.new("TextLabel")
        notifDesc.Size                      = UDim2.new(1, 0, 0, 0)
        notifDesc.AutomaticSize             = Enum.AutomaticSize.Y
        notifDesc.BackgroundTransparency    = 1
        notifDesc.Text                      = Settings.Description or ""
        notifDesc.Font                      = Enum.Font.Gotham
        notifDesc.TextSize                  = 12
        notifDesc.TextColor3                = Color3.fromRGB(100, 100, 100)
        notifDesc.TextXAlignment            = Enum.TextXAlignment.Left
        notifDesc.TextWrapped               = true
        notifDesc.LayoutOrder               = 1
        notifDesc.Parent                    = notif
        Tween(notif, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency  = 0,
            Position                = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(Settings.Duration or 3, function()
            local out = Tween(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                BackgroundTransparency  = 1,
                Position                = UDim2.fromOffset(40, 0)
            })
            out:Play()
            out.Completed:Wait()
            notif:Destroy()
        end)
    end
    
    function WindowFunctions:SetTitle(text)
        title.Text = text
    end
    
    function WindowFunctions:Destroy()
        unloaded = true
        gui:Destroy()
    end
    
    return WindowFunctions
end

return Alprazolam
