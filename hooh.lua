local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- =========================
-- GUI
-- =========================
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

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- =========================
-- FLAGS
-- =========================
local running = true
local minimized = false

-- =========================
-- FUNCTIONS
-- =========================
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function equipSlot2()
    local backpack = player:WaitForChild("Backpack")
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    -- retry biar aman
    for i = 1,5 do
        local tools = backpack:GetChildren()
        if #tools >= 2 then
            humanoid:EquipTool(tools[2])
            return
        end
        task.wait(0.5)
    end
end

-- =========================
-- TOGGLE
-- =========================
local function createToggle(parent, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 36)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = ""
    btn.Parent = parent

    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 30, 0, 30)
    circle.Position = UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.Parent = btn

    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

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
            circle.Position = UDim2.new(0, state and 47 or 3, 0, 3)
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

local afkToggle = createToggle(frame, UDim2.new(0,10,0,100))

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
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,28,0,28)
minBtn.Position = UDim2.new(1,-68,0,6)
minBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BorderSizePixel = 0
minBtn.Parent = frame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)

-- =========================
-- IMAGE MINIMIZE
-- =========================
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1,0,1,0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://100141220459015"
image.Visible = false
image.Parent = frame
image.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", image).CornerRadius = UDim.new(0,14)

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
task.spawn(function()
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
-- RESPAWN HANDLER (KUNCI)
-- =========================
player.CharacterAdded:Connect(function(char)
    print("Respawn detected")

    local hrp = char:WaitForChild("HumanoidRootPart")

    task.wait(1) -- biar tool & char siap

    equipSlot2()

    if anchorToggle.getState() then
        hrp.Anchored = true
    end
end)

-- =========================
-- CLOSE
-- =========================
closeBtn.MouseButton1Click:Connect(function()
    running = false

    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end

    gui:Destroy()
end)
