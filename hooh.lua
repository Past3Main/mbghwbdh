local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

-- FLAGS
local running = true
local minimized = false

-- FUNCTION
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- =========================
-- TOGGLE FUNCTION
-- =========================
local function createToggle(parent, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 36)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = ""
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 30, 0, 30)
    circle.Position = UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1,0)
    circleCorner.Parent = circle

    local state = false
    local debounce = false

    btn.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true

        state = not state
        local targetX = state and 47 or 3
        TweenService:Create(circle, TweenInfo.new(0.2), {
            Position = UDim2.new(0, targetX, 0, 3)
        }):Play()

        if callback then callback(state) end

        task.wait(0.2)
        debounce = false
    end)

    return {
        getState = function() return state end,
        setState = function(val)
            state = val
            local targetX = state and 47 or 3
            circle.Position = UDim2.new(0, targetX, 0, 3)
            if callback then callback(state) end
        end,
        button = btn
    }
end

-- =========================
-- TOGGLES
-- =========================
local anchorToggle = createToggle(frame, UDim2.new(0,10,0,50), function(state)
    local hrp = getHRP()
    hrp.Anchored = state
end)

local afkToggle = createToggle(frame, UDim2.new(0,10,0,100), function(state)
    -- dipakai di loop
end)

-- =========================
-- BUTTONS
-- =========================
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,28,0,28)
minBtn.Position = UDim2.new(1,-68,0,6)
minBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BorderSizePixel = 0
minBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minBtn

-- =========================
-- IMAGE (ICON MINIMIZE)
-- =========================
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1,0,1,0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://100141220459015"
image.Visible = false
image.Parent = frame
image.ScaleType = Enum.ScaleType.Crop

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0,14)
imgCorner.Parent = image

local imageButton = Instance.new("TextButton")
imageButton.Size = UDim2.new(1,0,1,0)
imageButton.BackgroundTransparency = 1
imageButton.Text = ""
imageButton.Parent = image

-- =========================
-- MINIMIZE
-- =========================
minBtn.MouseButton1Click:Connect(function()
    minimized = true

    frame:TweenSize(UDim2.new(0,60,0,60), "Out", "Quad", 0.2, true)

    anchorToggle.button.Visible = false
    afkToggle.button.Visible = false
    closeBtn.Visible = false
    minBtn.Visible = false

    image.Visible = true
end)

-- EXPAND (klik icon)
imageButton.MouseButton1Click:Connect(function()
    minimized = false

    frame:TweenSize(UDim2.new(0,220,0,160), "Out", "Quad", 0.2, true)

    anchorToggle.button.Visible = true
    afkToggle.button.Visible = true
    closeBtn.Visible = true
    minBtn.Visible = true

    image.Visible = false
end)

-- =========================
-- ANTI AFK
-- =========================
spawn(function()
    while running do
        task.wait(math.random(540,660))
        if afkToggle.getState() then
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)

-- =========================
-- DESTROY ALL
-- =========================
local function destroyAll()
    running = false

    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end

    anchorToggle.setState(false)
    afkToggle.setState(false)

    gui:Destroy()
end

closeBtn.MouseButton1Click:Connect(destroyAll)
