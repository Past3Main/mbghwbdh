local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- FRAME
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

-- CLOSE BUTTON
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

-- MINIMIZE BUTTON
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

-- HRP helper
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- STATES
local anchored = false
local antiAFK = false
local minimized = false

-- =========================
-- ANCHOR TOGGLE (atas)
-- =========================
local anchorBg = Instance.new("Frame")
anchorBg.Size = UDim2.new(0, 80, 0, 36)
anchorBg.Position = UDim2.new(0, 10, 0, 50)
anchorBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
anchorBg.BorderSizePixel = 0
anchorBg.Parent = frame
local anchorBgCorner = Instance.new("UICorner")
anchorBgCorner.CornerRadius = UDim.new(1,0)
anchorBgCorner.Parent = anchorBg

local anchorCircle = Instance.new("Frame")
anchorCircle.Size = UDim2.new(0, 30, 0, 30)
anchorCircle.Position = UDim2.new(0, 3, 0, 3)
anchorCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
anchorCircle.Parent = anchorBg
local anchorCircleCorner = Instance.new("UICorner")
anchorCircleCorner.CornerRadius = UDim.new(1,0)
anchorCircleCorner.Parent = anchorCircle

anchorBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        anchored = not anchored
        local hrp = getHRP()
        hrp.Anchored = anchored
        local targetX = anchored and 47 or 3
        TweenService:Create(anchorCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, targetX, 0, 3)}):Play()
    end
end)

-- =========================
-- ANTI-AFK TOGGLE (bawah)
-- =========================
local afkBg = Instance.new("Frame")
afkBg.Size = UDim2.new(0, 80, 0, 36)
afkBg.Position = UDim2.new(0, 10, 0, 100)
afkBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
afkBg.BorderSizePixel = 0
afkBg.Parent = frame
local afkBgCorner = Instance.new("UICorner")
afkBgCorner.CornerRadius = UDim.new(1,0)
afkBgCorner.Parent = afkBg

local afkCircle = Instance.new("Frame")
afkCircle.Size = UDim2.new(0, 30, 0, 30)
afkCircle.Position = UDim2.new(0, 3, 0, 3)
afkCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
afkCircle.Parent = afkBg
local afkCircleCorner = Instance.new("UICorner")
afkCircleCorner.CornerRadius = UDim.new(1,0)
afkCircleCorner.Parent = afkCircle

afkBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        antiAFK = not antiAFK
        local targetX = antiAFK and 47 or 3
        TweenService:Create(afkCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, targetX, 0, 3)}):Play()
    end
end)

-- =========================
-- CLOSE & MINIMIZE
-- =========================
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Quad", 0.2, true)
        for _, v in ipairs(frame:GetChildren()) do
            if v ~= closeBtn and v ~= minBtn then
                v.Visible = false
            end
        end
    else
        frame:TweenSize(UDim2.new(0, 220, 0, 160), "Out", "Quad", 0.2, true)
        for _, v in ipairs(frame:GetChildren()) do
            v.Visible = true
        end
    end
end)

-- =========================
-- RESET SAAT RESPAWN
-- =========================
player.CharacterAdded:Connect(function()
    anchored = false
    antiAFK = false
    anchorCircle.Position = UDim2.new(0, 3, 0, 3)
    afkCircle.Position = UDim2.new(0, 3, 0, 3)
end)

-- =========================
-- ANTI-AFK LOOP
-- =========================
spawn(function()
    while true do
        task.wait(math.random(540,660)) -- 9-11 menit
        if antiAFK then
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)
