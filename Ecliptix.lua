-- Da Hood Script Lock with GUI Password Prompt and External Script Load for Roblox Executors
-- Stylish GUI password lock; runs external script only if password matches

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local correctPassword = "BLATANTKOSH"

local externalScriptURL = "https://raw.githubusercontent.com/Francium-Lua/Francium-Lua/main/obf_qCJ6KQ530VS6FudYg6Wdc57sw4At4vh7YCjX4ux4zx9MBg9T2nSamz7gc7HtiB9O.lua"

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DaHoodScriptLockGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Create Background overlay
local background = Instance.new("Frame")
background.Name = "Background"
background.AnchorPoint = Vector2.new(0.5, 0.5)
background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
background.BackgroundTransparency = 0.5
background.BorderSizePixel = 0
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0.5, 0, 0.5, 0)
background.Parent = screenGui

-- Create password Frame
local frame = Instance.new("Frame")
frame.Name = "PasswordFrame"
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Size = UDim2.new(0, 350, 0, 180)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Parent = screenGui
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "DA HOOD SCRIPT LOCK"
titleLabel.TextColor3 = Color3.fromRGB(0, 114, 255)
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.Parent = frame

-- Create instruction label
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "Instruction"
instructionLabel.BackgroundTransparency = 1
instructionLabel.Position = UDim2.new(0, 20, 0, 55)
instructionLabel.Size = UDim2.new(1, -40, 0, 25)
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.Text = "Enter password to unlock the script:"
instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionLabel.TextSize = 18
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.Parent = frame

-- Create textbox for password input
local passwordBox = Instance.new("TextBox")
passwordBox.Name = "PasswordBox"
passwordBox.Position = UDim2.new(0, 20, 0, 85)
passwordBox.Size = UDim2.new(1, -40, 0, 40)
passwordBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
passwordBox.BorderSizePixel = 0
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.Font = Enum.Font.GothamBold
passwordBox.TextSize = 24
passwordBox.ClearTextOnFocus = false
passwordBox.PlaceholderText = "Password"
passwordBox.Text = ""
passwordBox.TextXAlignment = Enum.TextXAlignment.Center
passwordBox.Parent = frame
passwordBox.ClipsDescendants = true
passwordBox.TextEditable = true
passwordBox.TextStrokeTransparency = 1
passwordBox.TextWrapped = false
passwordBox.MultiLine = false
passwordBox.TextEditable = true
passwordBox.TextTransparency = 0
passwordBox.TextTruncate = Enum.TextTruncate.AtEnd
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitButton:Activate()
    end
end)

-- Create error message label (initially hidden)
local errorLabel = Instance.new("TextLabel")
errorLabel.Name = "ErrorLabel"
errorLabel.BackgroundTransparency = 1
errorLabel.Position = UDim2.new(0, 20, 0, 130)
errorLabel.Size = UDim2.new(1, -40, 0, 25)
errorLabel.Font = Enum.Font.GothamBold
errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
errorLabel.TextSize = 18
errorLabel.Text = ""
errorLabel.TextWrapped = true
errorLabel.Visible = false
errorLabel.TextXAlignment = Enum.TextXAlignment.Center
errorLabel.Parent = frame

-- Create submit button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Position = UDim2.new(0.25, 0, 0, 130)
submitButton.Size = UDim2.new(0.5, 0, 0, 40)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 114, 255)
submitButton.AutoButtonColor = true
submitButton.Font = Enum.Font.GothamBold
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 24
submitButton.Text = "Unlock"
submitButton.Parent = frame

-- Disable other inputs while GUI is active
local userInputService = game:GetService("UserInputService")
local inputConnection
inputConnection = userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- Block input to game while locked (except for GUI)
        if not screenGui:IsAncestorOf(input.UserInputType) then
            -- This is just best effort; we block no input here; Roblox has no official way to block all inputs
        end
    end
end)

local function tryUnlock()
    local pwd = passwordBox.Text or ""
    if pwd == correctPassword then
        errorLabel.Visible = false
        submitButton.Text = "Loading..."
        submitButton.AutoButtonColor = false
        submitButton.Active = false
        passwordBox.Active = false
        passwordBox.Selectable = false

        -- Clean GUI
        screenGui:Destroy()
        if inputConnection then
            inputConnection:Disconnect()
            inputConnection = nil
        end

        -- Load external script safely
        local success, err = pcall(function()
            loadstring(game:HttpGet(externalScriptURL))()
        end)
        if not success then
            warn("Failed to load or run external script: ".. tostring(err))
        end
    else
        errorLabel.Text = "Incorrect password. Please try again."
        errorLabel.Visible = true
        -- Optional: shake animation or clear input
        passwordBox.Text = ""
        passwordBox:CaptureFocus()
    end
end

submitButton.MouseButton1Click:Connect(tryUnlock)

-- Autofocus the TextBox on load
passwordBox:CaptureFocus()


-- Mobile optimization: Make sure it fits mobile screen well
local function optimizeForMobile()
    -- Adjust frame width for smaller widths
    local viewport = workspace.CurrentCamera.ViewportSize
    if viewport.X < 400 then
        frame.Size = UDim2.new(0, viewport.X - 50, 0, 180)
    end
end
optimizeForMobile()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(optimizeForMobile)
