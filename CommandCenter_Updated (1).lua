
--==================================================
-- COMMAND CENTER
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
-- For your own Roblox experience.
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

local Settings = {
    ESP = true,
    Skeleton = false,
    NoClip = false,
    Fly = false,
    Freecam = false,
    Speed = false,
    Teleport = false,
    AimAssist = false,
    TriggerBot = false,
    AntiRecoil = false,
    ManualAntiRecoil = false,
    AimFOVCircle = true,
    AimPart = "Head",

    ESPDistance = 1000,
    BoxScale = 100,
    ShowHealth = true,
    ShowNames = true,
    ShowDistance = true,
    ShowItems = true,
    TeamCheck = true,

    SkeletonDistance = 1000,
    SkeletonThickness = 2,
    SkeletonBox = true,
    SkeletonBoxScale = 100,

    FlySpeed = 60,
    WalkSpeed = 32,
    FreecamSpeed = 50,
    FreecamSensitivity = 0.003,

    TeleportDistance = 10,
    AimFOV = 120,
    AimDistance = 500,
    AimSmoothing = 8,

    TriggerTeamCheck = true,
    TriggerRange = 500,
    TriggerDelay = 0.12,
    ManualRecoilPitchDPS = 10,
    ManualRecoilYawDPS = 0,
}

local COLORS = {
    Background = Color3.fromRGB(25, 27, 31),
    Header = Color3.fromRGB(19, 21, 25),
    Panel = Color3.fromRGB(34, 37, 43),
    Button = Color3.fromRGB(48, 52, 60),
    Selected = Color3.fromRGB(61, 91, 75),
    Green = Color3.fromRGB(83, 195, 130),
    Red = Color3.fromRGB(235, 85, 85),
    Text = Color3.fromRGB(240, 242, 245),
    Muted = Color3.fromRGB(155, 162, 173),
}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "CommandCenter"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = Player:WaitForChild("PlayerGui")

-- Aim-assist FOV indicator (visible only while Aim Assist is enabled).
local AimCircle = Instance.new("Frame")
AimCircle.Name = "AimAssistFOV"
AimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimCircle.Position = UDim2.fromScale(0.5, 0.5)
AimCircle.Size = UDim2.fromOffset(Settings.AimFOV * 2, Settings.AimFOV * 2)
AimCircle.BackgroundTransparency = 1
AimCircle.BorderSizePixel = 0
AimCircle.Visible = false
AimCircle.ZIndex = 20
AimCircle.Parent = Gui
local AimCircleCorner = Instance.new("UICorner")
AimCircleCorner.CornerRadius = UDim.new(1, 0)
AimCircleCorner.Parent = AimCircle
local AimCircleStroke = Instance.new("UIStroke")
AimCircleStroke.Color = Color3.fromRGB(110, 190, 255)
AimCircleStroke.Thickness = 1.5
AimCircleStroke.Transparency = 0.15
AimCircleStroke.Parent = AimCircle

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(660, 570)
Main.Position = UDim2.new(0.5, -330, 0.5, -285)
Main.BackgroundColor3 = COLORS.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 70, 80)
MainStroke.Thickness = 1
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = COLORS.Header
Header.BorderSizePixel = 0
Header.Parent = Main

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(18, 0)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "COMMAND CENTER"
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.fromOffset(18, 30)
Subtitle.Size = UDim2.new(1, -90, 0, 16)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PLAYER VISUALS  /  MOVEMENT  /  CAMERA"
Subtitle.TextColor3 = COLORS.Muted
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -45, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(125, 48, 48)
Close.Text = "X"
Close.TextColor3 = COLORS.Text
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Header

Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

-- Dragging

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--==================================================
-- PANELS
--==================================================

local FeaturePanel = Instance.new("Frame")
FeaturePanel.Position = UDim2.fromOffset(14, 68)
FeaturePanel.Size = UDim2.new(1, -28, 0, 205)
FeaturePanel.BackgroundColor3 = COLORS.Panel
FeaturePanel.BorderSizePixel = 0
FeaturePanel.Parent = Main

Instance.new("UICorner", FeaturePanel).CornerRadius = UDim.new(0, 8)

local FeatureTitle = Instance.new("TextLabel")
FeatureTitle.Position = UDim2.fromOffset(12, 7)
FeatureTitle.Size = UDim2.new(1, -24, 0, 20)
FeatureTitle.BackgroundTransparency = 1
FeatureTitle.Text = "FEATURES"
FeatureTitle.TextColor3 = COLORS.Muted
FeatureTitle.Font = Enum.Font.GothamBold
FeatureTitle.TextSize = 11
FeatureTitle.TextXAlignment = Enum.TextXAlignment.Left
FeatureTitle.Parent = FeaturePanel

local FeatureGrid = Instance.new("Frame")
FeatureGrid.Position = UDim2.fromOffset(10, 32)
FeatureGrid.Size = UDim2.new(1, -20, 1, -40)
FeatureGrid.BackgroundTransparency = 1
FeatureGrid.Parent = FeaturePanel

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(1/4, -7, 0, 48)
GridLayout.CellPadding = UDim2.fromOffset(7, 6)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = FeatureGrid

local SettingsPanel = Instance.new("Frame")
SettingsPanel.Position = UDim2.fromOffset(14, 285)
SettingsPanel.Size = UDim2.new(1, -28, 1, -299)
SettingsPanel.BackgroundColor3 = COLORS.Panel
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Parent = Main

Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 8)

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Position = UDim2.fromOffset(14, 10)
SettingsTitle.Size = UDim2.new(1, -28, 0, 25)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "PLAYER ESP SETTINGS"
SettingsTitle.TextColor3 = COLORS.Text
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 13
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsPanel

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Position = UDim2.fromOffset(10, 42)
SettingsScroll.Size = UDim2.new(1, -20, 1, -50)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ScrollBarThickness = 4
SettingsScroll.CanvasSize = UDim2.new()
SettingsScroll.Parent = SettingsPanel

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 7)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Parent = SettingsScroll

SettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsScroll.CanvasSize = UDim2.fromOffset(
        0,
        SettingsLayout.AbsoluteContentSize.Y + 12
    )
end)

--==================================================
-- FEATURE DEFINITIONS
--==================================================

local Definitions = {
    ESP = {
        title = "PLAYER ESP SETTINGS",
        settings = {
            {"number", "ESP max distance", "ESPDistance", 50, 5000, "studs"},
            {"number", "Player box size", "BoxScale", 25, 200, "%"},
            {"toggle", "Show health bar", "ShowHealth"},
            {"toggle", "Show player names", "ShowNames"},
            {"toggle", "Show distance", "ShowDistance"},
            {"toggle", "Show held item", "ShowItems"},
            {"toggle", "Team check", "TeamCheck"},
        }
    },

    Skeleton = {
        title = "SKELETON ESP SETTINGS",
        settings = {
            {"number", "Skeleton max distance", "SkeletonDistance", 50, 5000, "studs"},
            {"number", "Skeleton line thickness", "SkeletonThickness", 1, 6, "pixels"},
            {"toggle", "Show box around player", "SkeletonBox"},
            {"number", "Skeleton box size", "SkeletonBoxScale", 25, 200, "%"},
        }
    },

    NoClip = {
        title = "NOCLIP SETTINGS",
        settings = {
            {"info", "NoClip disables collision on your character while enabled."},
        }
    },

    Fly = {
        title = "FLY SETTINGS",
        settings = {
            {"number", "Fly movement speed", "FlySpeed", 10, 200, "studs/sec"},
        }
    },

    Freecam = {
        title = "FREECAM SETTINGS",
        settings = {
            {"number", "Freecam movement speed", "FreecamSpeed", 5, 200, "studs/sec"},
            {"number", "Mouse sensitivity", "FreecamSensitivity", 0.001, 0.02, "rotation"},
        }
    },

    Speed = {
        title = "WALK SPEED SETTINGS",
        settings = {
            {"number", "Walk speed", "WalkSpeed", 16, 150, "studs/sec"},
        }
    },

    Teleport = {
        title = "TELEPORT SETTINGS",
        settings = {
            {"number", "Teleport distance", "TeleportDistance", 1, 50, "studs"},
            {"action", "TELEPORT FORWARD"},
            {"info", "Press T to teleport forward using the selected distance."},
        }
    },

    AimAssist = {
        title = "AIM ASSIST SETTINGS",
        settings = {
            {"number", "FOV radius", "AimFOV", 20, 500, "pixels"},
            {"number", "Maximum target distance", "AimDistance", 25, 2000, "studs"},
            {"number", "Aim smoothing", "AimSmoothing", 1, 30, "higher = slower"},
            {"toggle", "Show FOV circle", "AimFOVCircle"},
            {"action", "SWITCH AIM PART (HEAD / TORSO)"},
            {"info", "Hold RIGHT MOUSE BUTTON to aim at the closest visible player inside the FOV. Team check follows the Player ESP Team Check setting."},
            {"info", "For your own experience only. Validate weapon hits on the server."},
        }
    },

    TriggerBot = {
        title = "TRIGGER BOT SETTINGS",
        settings = {
            {"number", "Maximum target distance", "TriggerRange", 25, 2000, "studs"},
            {"number", "Fire interval", "TriggerDelay", 0.05, 1, "seconds"},
            {"toggle", "Team check (skip teammates)", "TriggerTeamCheck"},
            {"info", "When enabled, the equipped Tool activates only when the crosshair ray hits a living player in clear line of sight."},
            {"info", "The weapon's normal Tool.Activated and server-side hit validation still control the shot."},
        }
    },

    AntiRecoil = {
        title = "ANTI-RECOIL SETTINGS",
        settings = {
            {"toggle", "Manual recoil compensation", "ManualAntiRecoil"},
            {"number", "Vertical compensation", "ManualRecoilPitchDPS", 0, 90, "degrees/sec"},
            {"number", "Horizontal compensation", "ManualRecoilYawDPS", 0, 90, "degrees/sec"},
            {"info", "Turn the AntiRecoil feature tile ON, then enable Manual recoil compensation."},
            {"info", "Manual example: set vertical compensation to 10 degrees/sec to counter a steady 10 degrees/sec upward camera kick while firing. Adjust the sign/direction in a private test if your weapon recoils differently."},
        }
    },
}

local featureButtons = {}

--==================================================
-- FEATURE BUTTON SYSTEM
--==================================================

local function updateFeatureButton(feature)
    local data = featureButtons[feature]
    if not data then return end

    local enabled = Settings[feature]

    data.status.Text = enabled and "ON" or "OFF"
    data.status.TextColor3 = enabled and COLORS.Green or COLORS.Muted
    data.toggle.BackgroundColor3 = enabled and COLORS.Selected or COLORS.Button
end

-- Forward declarations for movement functions
local setNoClip
local setFreecam
local startFly
local stopFly
local teleportForward

local function setFeature(feature, enabled)
    Settings[feature] = enabled
    updateFeatureButton(feature)

    if feature == "NoClip" then
        setNoClip(enabled)

    elseif feature == "Fly" then
        if enabled then
            startFly()
        else
            stopFly()
        end

    elseif feature == "Freecam" then
        setFreecam(enabled)

    elseif feature == "Speed" then
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = enabled and Settings.WalkSpeed or 16
        end
    end
end

local function selectFeature(feature)
    SettingsTitle.Text = Definitions[feature].title

    for name, data in pairs(featureButtons) do
        data.select.BackgroundColor3 =
            name == feature and COLORS.Selected or COLORS.Button
    end

    for _, child in ipairs(SettingsScroll:GetChildren()) do
        if child:IsA("GuiObject") and child ~= SettingsLayout then
            child:Destroy()
        end
    end

    for _, setting in ipairs(Definitions[feature].settings) do
        local kind = setting[1]

        if kind == "number" then
            local label = setting[2]
            local key = setting[3]
            local minimum = setting[4]
            local maximum = setting[5]
            local unit = setting[6]

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -8, 0, 55)
            row.BackgroundColor3 = COLORS.Background
            row.BorderSizePixel = 0
            row.Parent = SettingsScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            local text = Instance.new("TextLabel")
            text.Position = UDim2.fromOffset(10, 3)
            text.Size = UDim2.new(1, -125, 0, 22)
            text.BackgroundTransparency = 1
            text.Text = label
            text.TextColor3 = COLORS.Text
            text.Font = Enum.Font.Gotham
            text.TextSize = 12
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = row

            local value = Instance.new("TextBox")
            value.Position = UDim2.new(1, -112, 0, 8)
            value.Size = UDim2.fromOffset(100, 28)
            value.BackgroundColor3 = COLORS.Button
            value.TextColor3 = COLORS.Text
            value.Font = Enum.Font.GothamBold
            value.TextSize = 12
            value.Text = tostring(Settings[key])
            value.ClearTextOnFocus = false
            value.Parent = row
            Instance.new("UICorner", value).CornerRadius = UDim.new(0, 5)

            local unitLabel = Instance.new("TextLabel")
            unitLabel.Position = UDim2.fromOffset(10, 29)
            unitLabel.Size = UDim2.new(1, -130, 0, 17)
            unitLabel.BackgroundTransparency = 1
            unitLabel.Text = "Range: " .. minimum .. "–" .. maximum .. " " .. unit
            unitLabel.TextColor3 = COLORS.Muted
            unitLabel.Font = Enum.Font.Gotham
            unitLabel.TextSize = 10
            unitLabel.TextXAlignment = Enum.TextXAlignment.Left
            unitLabel.Parent = row

            value.FocusLost:Connect(function()
                local number = tonumber(value.Text)

                if number then
                    Settings[key] = math.clamp(number, minimum, maximum)
                end

                value.Text = tostring(Settings[key])

                if key == "WalkSpeed" and Settings.Speed then
                    local character = Player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = Settings.WalkSpeed
                    end
                end
            end)

        elseif kind == "toggle" then
            local label = setting[2]
            local key = setting[3]

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -8, 0, 36)
            row.BackgroundColor3 = COLORS.Background
            row.BorderSizePixel = 0
            row.Parent = SettingsScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            local text = Instance.new("TextLabel")
            text.Position = UDim2.fromOffset(10, 0)
            text.Size = UDim2.new(1, -95, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = label
            text.TextColor3 = COLORS.Text
            text.Font = Enum.Font.Gotham
            text.TextSize = 12
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = row

            local toggle = Instance.new("TextButton")
            toggle.Position = UDim2.new(1, -78, 0, 5)
            toggle.Size = UDim2.fromOffset(68, 26)
            toggle.BorderSizePixel = 0
            toggle.Font = Enum.Font.GothamBold
            toggle.TextSize = 11
            toggle.Parent = row
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 5)

            local function refresh()
                toggle.Text = Settings[key] and "ON" or "OFF"
                toggle.BackgroundColor3 = Settings[key] and COLORS.Selected or COLORS.Button
                toggle.TextColor3 = Settings[key] and COLORS.Green or COLORS.Muted
            end

            toggle.MouseButton1Click:Connect(function()
                Settings[key] = not Settings[key]
                refresh()
            end)

            refresh()

        elseif kind == "action" then
            local actionButton = Instance.new("TextButton")
            actionButton.Size = UDim2.new(1, -8, 0, 38)
            actionButton.BackgroundColor3 = COLORS.Selected
            actionButton.Text = setting[2]
            actionButton.TextColor3 = COLORS.Text
            actionButton.Font = Enum.Font.GothamBold
            actionButton.TextSize = 12
            actionButton.BorderSizePixel = 0
            actionButton.Parent = SettingsScroll
            Instance.new("UICorner", actionButton).CornerRadius = UDim.new(0, 6)

            actionButton.MouseButton1Click:Connect(function()
                if setting[2] == "TELEPORT FORWARD" then
                    teleportForward()
                elseif setting[2] == "SWITCH AIM PART (HEAD / TORSO)" then
                    Settings.AimPart = Settings.AimPart == "Head" and "Torso" or "Head"
                    actionButton.Text = "AIM PART: " .. string.upper(Settings.AimPart) .. " (CLICK TO SWITCH)"
                end
            end)

            if setting[2] == "SWITCH AIM PART (HEAD / TORSO)" then
                actionButton.Text = "AIM PART: " .. string.upper(Settings.AimPart) .. " (CLICK TO SWITCH)"
            end

        elseif kind == "info" then
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, -8, 0, 42)
            info.BackgroundColor3 = COLORS.Background
            info.Text = setting[2]
            info.TextColor3 = COLORS.Muted
            info.Font = Enum.Font.Gotham
            info.TextSize = 11
            info.TextWrapped = true
            info.Parent = SettingsScroll
            Instance.new("UICorner", info).CornerRadius = UDim.new(0, 6)
        end
    end
end

--==================================================
-- FEATURE BUTTONS
--==================================================

local featureOrder = {
    "ESP", "Skeleton", "NoClip",
    "Fly", "Freecam", "Speed",
    "Teleport", "AimAssist", "TriggerBot", "AntiRecoil",
}

for _, feature in ipairs(featureOrder) do
    local selectButton = Instance.new("TextButton")
    selectButton.BackgroundColor3 = COLORS.Button
    selectButton.Text = ""
    selectButton.BorderSizePixel = 0
    selectButton.Parent = FeatureGrid
    Instance.new("UICorner", selectButton).CornerRadius = UDim.new(0, 6)

    local name = Instance.new("TextLabel")
    name.Position = UDim2.fromOffset(9, 5)
    name.Size = UDim2.new(1, -65, 0, 18)
    name.BackgroundTransparency = 1
    name.Text = feature == "ESP" and "Player ESP" or feature
    name.TextColor3 = COLORS.Text
    name.Font = Enum.Font.GothamBold
    name.TextSize = 11
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = selectButton

    local status = Instance.new("TextLabel")
    status.Position = UDim2.new(1, -52, 0, 5)
    status.Size = UDim2.fromOffset(43, 18)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamBold
    status.TextSize = 10
    status.Parent = selectButton

    local toggleButton = Instance.new("TextButton")
    toggleButton.Position = UDim2.fromOffset(8, 27)
    toggleButton.Size = UDim2.new(1, -16, 0, 15)
    toggleButton.BackgroundColor3 = COLORS.Button
    toggleButton.Text = "TOGGLE"
    toggleButton.TextColor3 = COLORS.Muted
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 9
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = selectButton
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

    featureButtons[feature] = {
        select = selectButton,
        status = status,
        toggle = toggleButton,
    }

    selectButton.MouseButton1Click:Connect(function()
        selectFeature(feature)
    end)

    toggleButton.MouseButton1Click:Connect(function()
        setFeature(feature, not Settings[feature])
    end)

    updateFeatureButton(feature)
end

selectFeature("ESP")

--==================================================
-- PLAYER ESP
--==================================================

local ESPObjects = {}

local function teammate(other)
    return Settings.TeamCheck
        and Player.Team ~= nil
        and other.Team ~= nil
        and Player.Team == other.Team
end

local function getColor(other)
    return teammate(other) and COLORS.Green or COLORS.Red
end

local function makeScreenLine()
    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BorderSizePixel = 0
    line.Visible = false
    line.Parent = Gui
    return line
end

local function makeBox()
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = Gui

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = box

    return box, stroke
end

local function createESP(other)
    if other == Player then return end

    local old = ESPObjects[other]
    if old then
        old.highlight:Destroy()
        old.box:Destroy()
        old.label:Destroy()
        old.healthBack:Destroy()
        for _, line in ipairs(old.lines) do
            line:Destroy()
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.9
    highlight.OutlineTransparency = 0
    highlight.Enabled = false

    local box, boxStroke = makeBox()

    local lines = {}
    for i = 1, 15 do
        lines[i] = makeScreenLine()
    end

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromOffset(220, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.Text
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Visible = false
    label.Parent = Gui

    local healthBack = Instance.new("Frame")
    healthBack.Size = UDim2.fromOffset(5, 100)
    healthBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    healthBack.BorderSizePixel = 0
    healthBack.Visible = false
    healthBack.Parent = Gui

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.fromScale(1, 1)
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.Position = UDim2.fromScale(0, 1)
    healthFill.BackgroundColor3 = COLORS.Green
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBack

    ESPObjects[other] = {
        highlight = highlight,
        box = box,
        boxStroke = boxStroke,
        lines = lines,
        label = label,
        healthBack = healthBack,
        healthFill = healthFill,
    }

    if other.Character then
        highlight.Parent = other.Character
    end
end

local function setupPlayer(other)
    if other == Player then return end

    createESP(other)

    other.CharacterAdded:Connect(function(character)
        task.wait(0.5)

        local data = ESPObjects[other]
        if data then
            data.highlight.Parent = character
        end
    end)
end

for _, other in ipairs(Players:GetPlayers()) do
    setupPlayer(other)
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(other)
    local data = ESPObjects[other]
    if not data then return end

    data.highlight:Destroy()
    data.box:Destroy()
    data.label:Destroy()
    data.healthBack:Destroy()

    for _, line in ipairs(data.lines) do
        line:Destroy()
    end

    ESPObjects[other] = nil
end)

local R6Bones = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local R15Bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local function drawLine(line, a, b, color)
    local delta = b - a

    line.Position = UDim2.fromOffset(
        (a.X + b.X) / 2,
        (a.Y + b.Y) / 2
    )

    line.Size = UDim2.fromOffset(
        delta.Magnitude,
        Settings.SkeletonThickness
    )

    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.Visible = true
end

local function hideData(data)
    data.box.Visible = false
    data.label.Visible = false
    data.healthBack.Visible = false

    for _, line in ipairs(data.lines) do
        line.Visible = false
    end
end

local function updateESP()
    Camera = workspace.CurrentCamera

    for other, data in pairs(ESPObjects) do
        local character = other.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        if not character or not humanoid or not root or humanoid.Health <= 0 then
            data.highlight.Enabled = false
            hideData(data)
            continue
        end

        local distance = (Camera.CFrame.Position - root.Position).Magnitude
        local color = getColor(other)

        local espVisible = Settings.ESP and distance <= Settings.ESPDistance
        local skeletonVisible = Settings.Skeleton and distance <= Settings.SkeletonDistance

        data.highlight.Enabled = espVisible
        data.highlight.FillColor = color
        data.highlight.OutlineColor = color

        local cf, size = character:GetBoundingBox()
        local corners = {}

        for x = -1, 1, 2 do
            for y = -1, 1, 2 do
                for z = -1, 1, 2 do
                    local world = cf:PointToWorldSpace(
                        Vector3.new(size.X * x / 2, size.Y * y / 2, size.Z * z / 2)
                    )

                    local screen = Camera:WorldToViewportPoint(world)

                    if screen.Z > 0 then
                        table.insert(corners, Vector2.new(screen.X, screen.Y))
                    end
                end
            end
        end

        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge

        for _, point in ipairs(corners) do
            minX = math.min(minX, point.X)
            minY = math.min(minY, point.Y)
            maxX = math.max(maxX, point.X)
            maxY = math.max(maxY, point.Y)
        end

        local hasBounds = #corners >= 4

        if espVisible and hasBounds then
            local scale = Settings.BoxScale / 100
            local width = (maxX - minX) * scale
            local height = (maxY - minY) * scale

            data.box.Position = UDim2.fromOffset(
                (minX + maxX) / 2 - width / 2,
                (minY + maxY) / 2 - height / 2
            )

            data.box.Size = UDim2.fromOffset(width, height)
            data.boxStroke.Color = color
            data.box.Visible = true

        elseif skeletonVisible and Settings.SkeletonBox and hasBounds then
            local scale = Settings.SkeletonBoxScale / 100
            local width = (maxX - minX) * scale
            local height = (maxY - minY) * scale

            data.box.Position = UDim2.fromOffset(
                (minX + maxX) / 2 - width / 2,
                (minY + maxY) / 2 - height / 2
            )

            data.box.Size = UDim2.fromOffset(width, height)
            data.boxStroke.Color = color
            data.box.Visible = true
        else
            data.box.Visible = false
        end

        if espVisible and head then
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            local textParts = {}

            if Settings.ShowNames then
                table.insert(textParts, other.DisplayName)
            end

            if Settings.ShowDistance then
                table.insert(textParts, math.floor(distance) .. " studs")
            end

            if Settings.ShowItems then
                local tool = character:FindFirstChildOfClass("Tool")
                table.insert(textParts, tool and tool.Name or "Unarmed")
            end

            data.label.Text = table.concat(textParts, "  |  ")
            data.label.Position = UDim2.fromOffset(headScreen.X - 110, headScreen.Y - 25)
            data.label.Visible = #textParts > 0 and headScreen.Z > 0
        else
            data.label.Visible = false
        end

        if espVisible and Settings.ShowHealth and hasBounds then
            local ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

            data.healthBack.Position = UDim2.fromOffset(minX - 9, minY)
            data.healthBack.Size = UDim2.fromOffset(5, maxY - minY)
            data.healthFill.Size = UDim2.new(1, 0, ratio, 0)
            data.healthFill.BackgroundColor3 = Color3.fromRGB(
                255 * (1 - ratio),
                220 * ratio,
                65
            )

            data.healthBack.Visible = true
        else
            data.healthBack.Visible = false
        end

        if skeletonVisible then
            local bones = character:FindFirstChild("UpperTorso") and R15Bones or R6Bones

            for index, bone in ipairs(bones) do
                local partA = character:FindFirstChild(bone[1])
                local partB = character:FindFirstChild(bone[2])
                local line = data.lines[index]

                if partA and partB then
                    local a, aVisible = Camera:WorldToViewportPoint(partA.Position)
                    local b, bVisible = Camera:WorldToViewportPoint(partB.Position)

                    if aVisible and bVisible and a.Z > 0 and b.Z > 0 then
                        drawLine(
                            line,
                            Vector2.new(a.X, a.Y),
                            Vector2.new(b.X, b.Y),
                            color
                        )
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end

            for index = #bones + 1, #data.lines do
                data.lines[index].Visible = false
            end
        else
            for _, line in ipairs(data.lines) do
                line.Visible = false
            end
        end
    end
end

--==================================================
-- FIXED NOCLIP
--==================================================

local originalCollision = {}
local collisionConnection

local function applyNoClip()
    local character = Player.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if originalCollision[part] == nil then
                originalCollision[part] = part.CanCollide
            end

            part.CanCollide = false
        end
    end
end

local function restoreCollision()
    for part, originalValue in pairs(originalCollision) do
        if part and part.Parent then
            part.CanCollide = originalValue
        end
    end

    table.clear(originalCollision)
end

setNoClip = function(enabled)
    Settings.NoClip = enabled
    updateFeatureButton("NoClip")

    if collisionConnection then
        collisionConnection:Disconnect()
        collisionConnection = nil
    end

    if enabled then
        applyNoClip()

        collisionConnection = RunService.Stepped:Connect(function()
            applyNoClip()
        end)
    else
        restoreCollision()
    end
end

--==================================================
-- FLY
--==================================================

local flyAttachment
local flyVelocity
local flyRoot

stopFly = function()
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end

    if flyAttachment then
        flyAttachment:Destroy()
        flyAttachment = nil
    end

    flyRoot = nil

    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

startFly = function()
    stopFly()

    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not root or not humanoid then return end

    flyRoot = root

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root

    humanoid.PlatformStand = true
end

local function updateFly()
    if not Settings.Fly then return end

    if not flyVelocity or not flyRoot or not flyRoot.Parent then
        startFly()
    end

    if not flyVelocity or not flyRoot then return end

    local direction = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        direction += Camera.CFrame.LookVector
    end
    if UIS:IsKeyDown(Enum.KeyCode.S) then
        direction -= Camera.CFrame.LookVector
    end
    if UIS:IsKeyDown(Enum.KeyCode.D) then
        direction += Camera.CFrame.RightVector
    end
    if UIS:IsKeyDown(Enum.KeyCode.A) then
        direction -= Camera.CFrame.RightVector
    end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.yAxis
    end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction -= Vector3.yAxis
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit
    end

    flyVelocity.VectorVelocity = direction * Settings.FlySpeed
end

--==================================================
-- FREECAM
--==================================================

local freecamActive = false
local freecamPosition
local freecamYaw = 0
local freecamPitch = 0

local previousCameraType
local previousCameraSubject
local previousMouseBehavior
local previousMouseIconEnabled

setFreecam = function(enabled)
    enabled = enabled == true
    Camera = workspace.CurrentCamera
    if not Camera then return end

    -- Keep the state and the GUI toggle synchronized, even if F and the
    -- on-screen toggle are used at different times.
    if enabled == freecamActive then
        Settings.Freecam = enabled
        updateFeatureButton("Freecam")
        return
    end

    Settings.Freecam = enabled
    updateFeatureButton("Freecam")

    if enabled then
        previousCameraType = Camera.CameraType
        previousCameraSubject = Camera.CameraSubject
        previousMouseBehavior = UIS.MouseBehavior
        previousMouseIconEnabled = UIS.MouseIconEnabled

        freecamPosition = Camera.CFrame.Position
        local look = Camera.CFrame.LookVector
        freecamYaw = math.atan2(-look.X, -look.Z)
        freecamPitch = math.asin(math.clamp(look.Y, -1, 1))

        freecamActive = true
        Camera.CameraType = Enum.CameraType.Scriptable
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        UIS.MouseIconEnabled = false
    else
        freecamActive = false
        UIS.MouseBehavior = previousMouseBehavior or Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = previousMouseIconEnabled ~= false

        Camera.CameraType = previousCameraType or Enum.CameraType.Custom
        if previousCameraSubject and previousCameraSubject.Parent then
            Camera.CameraSubject = previousCameraSubject
        else
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end
end

local function updateFreecam(dt)
    if not freecamActive then return end

    Camera = workspace.CurrentCamera
    if not Camera then return end

    -- GetMouseDelta works with LockCenter and avoids missed InputChanged events.
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    local mouseDelta = UIS:GetMouseDelta()

    freecamYaw -= mouseDelta.X * Settings.FreecamSensitivity
    freecamPitch = math.clamp(
        freecamPitch - mouseDelta.Y * Settings.FreecamSensitivity,
        -1.5,
        1.5
    )

    local rotation = CFrame.fromOrientation(freecamPitch, freecamYaw, 0)
    local movement = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then movement += Vector3.new(0, 0, -1) end
    if UIS:IsKeyDown(Enum.KeyCode.S) then movement += Vector3.new(0, 0, 1) end
    if UIS:IsKeyDown(Enum.KeyCode.A) then movement += Vector3.new(-1, 0, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.D) then movement += Vector3.new(1, 0, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then movement += Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then movement += Vector3.new(0, -1, 0) end

    if movement.Magnitude > 0 then
        freecamPosition += rotation:VectorToWorldSpace(movement.Unit) * Settings.FreecamSpeed * dt
    end

    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.new(freecamPosition) * rotation
end

--==================================================
-- TELEPORT
--==================================================

teleportForward = function()
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then return end

    local look = workspace.CurrentCamera.CFrame.LookVector
    local direction = Vector3.new(look.X, 0, look.Z)

    if direction.Magnitude < 0.01 then return end

    direction = direction.Unit

    -- Intentionally skip obstruction checks so teleport passes through walls.
    local distance = Settings.TeleportDistance
    root.CFrame = root.CFrame + direction * distance
end

--==================================================
-- AIM ASSIST, TRIGGER BOT, AND MANUAL RECOIL COMPENSATION
--==================================================

local aimHeld = false
local nextTriggerTime = 0
local pendingAutoRecoil = Vector2.zero

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHeld = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHeld = false
    end
end)

local function getAimTarget()
    Camera = workspace.CurrentCamera
    if not Camera then return nil end

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local bestTarget = nil
    local bestPixelDistance = Settings.AimFOV

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= Player and (not Settings.TeamCheck or Player.Team == nil or other.Team ~= Player.Team) then
            local character = other.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = character and (
                Settings.AimPart == "Head" and character:FindFirstChild("Head")
                or character:FindFirstChild("UpperTorso")
                or character:FindFirstChild("Torso")
            )

            if humanoid and humanoid.Health > 0 and root and targetPart then
                local worldDistance = (Camera.CFrame.Position - root.Position).Magnitude
                if worldDistance <= Settings.AimDistance then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPoint.Z > 0 then
                        local pixelDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                        if pixelDistance <= bestPixelDistance then
                            local origin = Camera.CFrame.Position
                            local direction = targetPart.Position - origin
                            local rayParams = RaycastParams.new()
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            rayParams.FilterDescendantsInstances = {Player.Character}
                            local hit = workspace:Raycast(origin, direction, rayParams)
                            if hit and hit.Instance and hit.Instance:IsDescendantOf(character) then
                                bestPixelDistance = pixelDistance
                                bestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

local function updateAimAssist(dt)
    Camera = workspace.CurrentCamera
    if not Camera then return end

    AimCircle.Visible = Settings.AimAssist and Settings.AimFOVCircle
    AimCircle.Size = UDim2.fromOffset(Settings.AimFOV * 2, Settings.AimFOV * 2)
    AimCircle.Position = UDim2.fromOffset(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if not Settings.AimAssist or not aimHeld or freecamActive then return end

    local target = getAimTarget()
    if target then
        local desired = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        local alpha = math.clamp(Settings.AimSmoothing * dt, 0, 1)
        Camera.CFrame = Camera.CFrame:Lerp(desired, alpha)
    end
end

local function getCrosshairPlayer()
    Camera = workspace.CurrentCamera
    if not Camera then return nil end

    local viewport = Camera.ViewportSize
    local ray = Camera:ViewportPointToRay(viewport.X / 2, viewport.Y / 2)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Player.Character}

    local result = workspace:Raycast(ray.Origin, ray.Direction * Settings.TriggerRange, params)
    if not result then return nil end

    local model = result.Instance:FindFirstAncestorOfClass("Model")
    if not model then return nil end

    local targetPlayer = Players:GetPlayerFromCharacter(model)
    if not targetPlayer or targetPlayer == Player then return nil end

    if Settings.TriggerTeamCheck and Player.Team ~= nil and targetPlayer.Team == Player.Team then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end

    return targetPlayer
end

local function updateTriggerBot()
    if not Settings.TriggerBot or freecamActive then return end
    if os.clock() < nextTriggerTime then return end

    -- The center-screen ray is the visibility test: a wall or another object
    -- blocks the target, so the equipped Tool is not activated.
    local target = getCrosshairPlayer()
    if not target then return end

    local character = Player.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    if tool and tool.Enabled then
        tool:Activate()
        nextTriggerTime = os.clock() + Settings.TriggerDelay
    end
end

local function updateRecoilCompensation(dt)
    if freecamActive then return end
    if not Settings.AntiRecoil or not Settings.ManualAntiRecoil then return end

    Camera = workspace.CurrentCamera
    if not Camera then return end

    local character = Player.Character
    local equippedTool = character and character:FindFirstChildOfClass("Tool")
    local firing = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    if not equippedTool or not firing then return end

    local pitchCorrection = Settings.ManualRecoilPitchDPS * dt
    local yawCorrection = Settings.ManualRecoilYawDPS * dt

    if pitchCorrection ~= 0 or yawCorrection ~= 0 then
        Camera.CFrame = Camera.CFrame * CFrame.Angles(
            math.rad(-pitchCorrection),
            math.rad(-yawCorrection),
            0
        )
    end
end

--==================================================
-- KEYBOARD CONTROLS
--==================================================

UIS.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F then
        if UIS:GetFocusedTextBox() then return end
        setFreecam(not freecamActive)
        return
    end

    if processed then return end

    if input.KeyCode == Enum.KeyCode.N then
        setNoClip(not Settings.NoClip)

    elseif input.KeyCode == Enum.KeyCode.G then
        setFeature("Fly", not Settings.Fly)

    elseif input.KeyCode == Enum.KeyCode.T then
        teleportForward()
    end
end)

--==================================================
-- MAIN UPDATE LOOP
--==================================================

RunService.RenderStepped:Connect(function(dt)
    Camera = workspace.CurrentCamera

    updateESP()
    updateFly()
    updateFreecam(dt)
    updateAimAssist(dt)
    updateTriggerBot()
    updateRecoilCompensation(dt)

    if Settings.Speed then
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.WalkSpeed ~= Settings.WalkSpeed then
            humanoid.WalkSpeed = Settings.WalkSpeed
        end
    end
end)

--==================================================
-- RESPAWN SUPPORT
--==================================================

Player.CharacterAdded:Connect(function()
    task.wait(1)

    if Settings.NoClip then
        applyNoClip()
    end

    if Settings.Fly then
        startFly()
    end

    if Settings.Speed then
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = Settings.WalkSpeed
        end
    end
end)

--==================================================
-- CLOSE BUTTON
--==================================================

Close.MouseButton1Click:Connect(function()
    if freecamActive then
        setFreecam(false)
    end
    Settings.AimAssist = false
    AimCircle.Visible = false

    if Settings.Fly then
        Settings.Fly = false
        stopFly()
    end

    if Settings.NoClip then
        setNoClip(false)
    end

    restoreCollision()

    if collisionConnection then
        collisionConnection:Disconnect()
    end

    Gui:Destroy()
end)

print("COMMAND CENTER LOADED")
print("F = Freecam | N = NoClip | G = Fly | T = Teleport | Hold RMB = Aim Assist")
print("TriggerBot and AntiRecoil are configurable in their settings panels.")
