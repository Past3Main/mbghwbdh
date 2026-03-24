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

-- FUNCTIONS
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- =========================
-- TOGGLE CREATOR
-- =========================
local function createToggle(parent, position, callback)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 80, 0, 36)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    bg.BorderSizePixel = 0
    bg.Parent = parent

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1,0)
    bgCorner.Parent = bg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 30, 0, 30)
    circle.Position = UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.Parent = bg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1,0)
    circleCorner.Parent = circle

    local state = false

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            local targetX = state and 47 or 3
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, targetX, 0, 3)
            }):Play()

            if callback then callback(state) end
        end
    end)

    return {
        getState = function() return state end,
        setState = function(val)
            state = val
            local targetX = state and 47 or 3
            circle.Position = UDim2.new(0, targetX, 0, 3)
            if callback then callback(state) end
        end
    }
end

-- =========================
-- STATES
-- =========================
local running = true

-- Anchor (atas)
local anchorToggle = createToggle(frame, UDim2.new(0,10,0,50), function(state)
    local hrp = getHRP()
    hrp.Anchored = state
end)

-- Anti AFK (bawah)
local afkToggle = createToggle(frame, UDim2.new(0,10,0,100), function(state)
    -- state dipakai di loop
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
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -68, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BorderSizePixel = 0
minBtn.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minBtn

-- =========================
-- MINIMIZE
-- =========================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        frame:TweenSize(UDim2.new(0,60,0,60), "Out", "Quad", 0.2, true)
        for _,v in ipairs(frame:GetChildren()) do
            if v ~= closeBtn and v ~= minBtn then
                v.Visible = false
            end
        end
    else
        frame:TweenSize(UDim2.new(0,220,0,160), "Out", "Quad", 0.2, true)
        for _,v in ipairs(frame:GetChildren()) do
            v.Visible = true
        end
    end
end)

-- =========================
-- ANTI AFK LOOP
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
-- DESTROY ALL (X BUTTON)
-- =========================
local function destroyAll()
    running = false

    -- reset anchor
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end

    -- reset toggle
    anchorToggle.setState(false)
    afkToggle.setState(false)

    -- destroy GUI
    gui:Destroy()
end

closeBtn.MouseButton1Click:Connect(destroyAll)
