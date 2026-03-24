local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
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
closeCorner.CornerRadius = UDim.new(1, 0)
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
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minBtn

-- ANCHOR TOGGLE
local anchorBtn = Instance.new("TextButton")
anchorBtn.Size = UDim2.new(0, 80, 0, 36)
anchorBtn.Position = UDim2.new(0, 10, 0, 60)
anchorBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
anchorBtn.Text = "OFF"
anchorBtn.TextColor3 = Color3.new(1,1,1)
anchorBtn.BorderSizePixel = 0
anchorBtn.Parent = frame

local anchorCorner = Instance.new("UICorner")
anchorCorner.CornerRadius = UDim.new(0, 10)
anchorCorner.Parent = anchorBtn

-- ANTI AFK TOGGLE
local afkBtn = Instance.new("TextButton")
afkBtn.Size = UDim2.new(0, 80, 0, 36)
afkBtn.Position = UDim2.new(0, 110, 0, 60)
afkBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
afkBtn.Text = "AFK OFF"
afkBtn.TextColor3 = Color3.new(1,1,1)
afkBtn.BorderSizePixel = 0
afkBtn.Parent = frame

local afkCorner = Instance.new("UICorner")
afkCorner.CornerRadius = UDim.new(0, 10)
afkCorner.Parent = afkBtn

-- STATE
local anchored = false
local antiAFK = false
local minimized = false

-- HRP
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- ANCHOR TOGGLE (animasi saklar)
anchorBtn.MouseButton1Click:Connect(function()
    anchored = not anchored
    local hrp = getHRP()
    hrp.Anchored = anchored

    local targetX = anchored and 110 or 10
    TweenService:Create(anchorBtn, TweenInfo.new(0.2), {
        Position = UDim2.new(0, targetX, 0, 60)
    }):Play()

    anchorBtn.Text = anchored and "ON" or "OFF"
end)

-- ANTI AFK TOGGLE
afkBtn.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    afkBtn.Text = antiAFK and "AFK ON" or "AFK OFF"
end)

-- CLOSE
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        -- jadi kotak (buat foto nanti)
        frame:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Quad", 0.2, true)

        for _, v in ipairs(frame:GetChildren()) do
            if v ~= minBtn and v ~= closeBtn then
                v.Visible = false
            end
        end
    else
        frame:TweenSize(UDim2.new(0, 220, 0, 120), "Out", "Quad", 0.2, true)

        for _, v in ipairs(frame:GetChildren()) do
            v.Visible = true
        end
    end
end)

-- RESET
player.CharacterAdded:Connect(function()
    anchored = false
    anchorBtn.Position = UDim2.new(0, 10, 0, 60)
    anchorBtn.Text = "OFF"
end)

-- ANTI AFK LOOP
spawn(function()
    while true do
        task.wait(math.random(540, 660)) -- 9-11 menit

        if antiAFK then
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)
