local credits = [[
             _____ _  __   __        __     ______                   
            |  ___| | \ \ / /        \ \   / /___ \                  
            | |_  | |  \ V /          \ \ / /  __) |                 
            |  _| | |___| |            \ V /  / __/                  
 ____       |_| __|_____|_|           _ \_/  |_____| ____ ____ ____  
| __ ) _   _   / ___|___ | |__   __ _| | _____ _ __ | ___| ___| ___| 
|  _ \| | | | | |   / _ \| '_ \ / _` | |/ / _ \ '_ \|___ \___ \___ \ 
| |_) | |_| | | |__| (_) | |_) | (_| |   <  __/ | | |___) |__) |__) |
|____/ \__, |  \____\___/|_.__/ \__,_|_|\_\___|_| |_|____/____/____/ 
       |___/                                                                                                            
]]

print(credits)

local p = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local STGUI = p:WaitForChild("PlayerGui")

local bindable = Instance.new("BindableFunction")
local NFScript = Instance.new("ScreenGui", STGUI)
NFScript.ResetOnSpawn = false
NFScript.Name = "NFScript"

local debounce = false
local flying = false
local chips = false
local noclipEnabled = false
local menuHidden = false
local bodyVelocity = nil
local currentSpeed = 10
local flyKey = Enum.KeyCode.R
local spinConnection = nil

local function notification(Text, Subtext, Time)
	if debounce == false then 
		debounce = true
		game.StarterGui:SetCore("SendNotification", {
			Title = Subtext;
			Text = Text;
			Duration = Time;
		})
		task.wait(1)
		debounce = false
	end
end

function bindable.OnInvoke(response)
	if response == "Yes!" then
		if flying then
			flying = false
			if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
			local char = p.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.PlatformStand = false
			end
		end
		if chips then
			if spinConnection then spinConnection:Disconnect() spinConnection = nil end
			chips = false
		end
		notification("ScreenGui Destroyed", "Bye!", 5)
		NFScript:Destroy()
		script:Destroy()
	else
		notification("ScreenGui Not Destroyed", "Canceled", 5)
	end
end

local function notificationyesno(Text, Subtext, Time, Answer, Answer2)
	if debounce then return end
	debounce = true
	game.StarterGui:SetCore("SendNotification", {
		Title = Subtext;  
		Text = Text; 
		Duration = Time,
		Callback = bindable,  
		Button1 = Answer,
		Button2 = Answer2
	})
	task.wait(1)
	debounce = false
end

local function setNoclip(on)
	local char = p.Character
	if not char then return end
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not on
		end
	end
end

local function stopFly()
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	local char = p.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.PlatformStand = false
	end
end

local function startFly()
	local char = p.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	flying = true
	char.Humanoid.PlatformStand = true

	if bodyVelocity then bodyVelocity:Destroy() end
	bodyVelocity = Instance.new("BodyVelocity", hrp)
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
end

local function updateFlight()
	if not flying then return end

	local char = p.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not bodyVelocity then
		stopFly()
		return
	end

	local cam = workspace.CurrentCamera

	local moveDir = Vector3.new(
		(uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
		(uis:IsKeyDown(Enum.KeyCode.E) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.Q) and 1 or 0),
		(uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
	)

	if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end

	bodyVelocity.Velocity = cam.CFrame:VectorToWorldSpace(moveDir) * currentSpeed
end

local function startSpin()
	if spinConnection then spinConnection:Disconnect() end
	spinConnection = rs.RenderStepped:Connect(function()
		local char = p.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp and chips then
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(-10), 0)
		end
	end)
end

local function stopSpin()
	if spinConnection then
		spinConnection:Disconnect()
		spinConnection = nil
	end
end

notification("FLY V2 STARTING", "Downloading assets", 3)
task.wait(3)

local WIP = Instance.new("Frame", NFScript)
WIP.Position = UDim2.new(0.329, 50, 0.414, -155)
WIP.Size = UDim2.new(0, 343, 0, 447)
WIP.Name = "WIP"
WIP.BackgroundColor3 = Color3.new(1, 1, 1)
local UICorner = Instance.new("UICorner", WIP)
UICorner.CornerRadius = UDim.new(0, 9)
local UIDragDetector = Instance.new("UIDragDetector", WIP)

local UR = Instance.new("Frame", WIP)
UR.BackgroundColor3 = Color3.new(0.635294, 0.635294, 0.635294)
UR.Position = UDim2.new(0, 0, 0.067, 0)
UR.Size = UDim2.new(0, 343, 0, 66)
UR.Name = "UR"
local UICorner1 = Instance.new("UICorner", UR)
UICorner1.CornerRadius = UDim.new(0, 9)

local X = Instance.new("TextButton", UR)
X.Name = "X"
X.BackgroundColor3 = Color3.new(1, 0, 0)
X.Position = UDim2.new(0.828, 0, 0.121, 0)
X.Size = UDim2.new(0, 50, 0, 50)
X.Text = "X"
X.TextSize = 31
local UICorner2 = Instance.new("UICorner", X)
UICorner2.CornerRadius = UDim.new(1, 0)

local T = Instance.new("TextButton", UR)
T.Name = "T"
T.BackgroundColor3 = Color3.new(1, 0.933, 0)
T.Position = UDim2.new(0.653, 0, 0.121, 0)
T.Size = UDim2.new(0, 50, 0, 50)
T.Text = "-"
T.TextSize = 48
local UICorner3 = Instance.new("UICorner", T)
UICorner3.CornerRadius = UDim.new(1, 0)

local By = Instance.new("TextLabel", UR)
By.Name = "By"
By.BackgroundTransparency = 1
By.Position = UDim2.new(0.029, 0, 0.121, 0)
By.Size = UDim2.new(0, 200, 0, 50)
By.Text = "By Cobaken555 FLY V2"
By.TextSize = 14

local NP = Instance.new("TextButton", WIP)
NP.Name = "NP"
NP.BackgroundColor3 = Color3.new(1, 0, 0.0157)
NP.Position = UDim2.new(0.029, 0, 0.85, 0)
NP.Size = UDim2.new(0, 323, 0, 50)
NP.Text = "NOCLIP: OFF"
NP.TextSize = 31
NP.TextScaled = true
local UICorner4 = Instance.new("UICorner", NP)
UICorner4.CornerRadius = UDim.new(0.7, 0)

local ST = Instance.new("TextButton", WIP)
ST.BackgroundColor3 = Color3.new(0.2353, 1, 0.00392)
ST.Position = UDim2.new(0.434, 0, 0.251, 0)
ST.Size = UDim2.new(0, 177, 0, 126)
ST.Name = "ST"
ST.Text = "START"
ST.TextSize = 76
ST.TextScaled = true
local UICorner5 = Instance.new("UICorner", ST)
UICorner5.CornerRadius = UDim.new(0, 9)

local TH = Instance.new("TextBox", WIP)
TH.BackgroundColor3 = Color3.new(0.6745, 0.6745, 0.6745)
TH.ClearTextOnFocus = false
TH.Name = "TH"
TH.Position = UDim2.new(0.07, 0, 0.376, 0)
TH.Size = UDim2.new(0, 103, 0, 37)
TH.Text = "50"
TH.PlaceholderColor3 = Color3.new(0.302, 0.302, 0.302)
TH.PlaceholderText = "Type here"
TH.TextScaled = true
local UICorner6 = Instance.new("UICorner", TH)
UICorner6.CornerRadius = UDim.new(0, 9)

local SN = Instance.new("TextButton", WIP)
SN.BackgroundColor3 = Color3.new(1, 0, 0)
SN.Position = UDim2.new(0.05, 0, 0.485, 0)
SN.Size = UDim2.new(0, 116, 0, 21)
SN.Name = "SN"
SN.Text = "Chips: OFF"
SN.TextScaled = true

local S = Instance.new("TextLabel", WIP)
S.BackgroundColor3 = Color3.new(0.7843, 0.7843, 0.7843)
S.Name = "S"
S.Position = UDim2.new(0.207, 0, 0.573, 0)
S.Size = UDim2.new(0, 200, 0, 50)
S.Text = "SETTINGS"
S.TextSize = 57
S.TextScaled = true
local UICorner7 = Instance.new("UICorner", S)
UICorner7.CornerRadius = UDim.new(0, 9)

local SD = Instance.new("TextLabel", WIP)
SD.Name = "SD"
SD.BackgroundTransparency = 1
SD.Size = UDim2.new(0, 103, 0, 31)
SD.Position = UDim2.new(0.07, 0, 0.251, 0)
SD.Text = "Speed:"
SD.TextScaled = true

local SS = Instance.new("TextLabel", WIP)
SS.Name = "SS"
SS.BackgroundColor3 = Color3.new(0, 1, 0.835)
SS.Position = UDim2.new(0.07, 0, 0.716, 0)
SS.Size = UDim2.new(0, 200, 0, 36)
SS.Text = "Button Flying:"
SS.TextScaled = true
local UICorner8 = Instance.new("UICorner", SS)
UICorner8.CornerRadius = UDim.new(0, 9)

local CB = Instance.new("TextButton", SS)
CB.Name = "CB"
CB.BackgroundColor3 = Color3.new(0, 0.6588, 0.549)
CB.Position = UDim2.new(1.08, 0, 0, 0)
CB.Size = UDim2.new(0, 74, 0, 36)
CB.Text = "R"
CB.TextScaled = true
local UICorner9 = Instance.new("UICorner", CB)
UICorner9.CornerRadius = UDim.new(1, 1)

rs.RenderStepped:Connect(function()
	if noclipEnabled then
		setNoclip(true)
	end
	if flying then
		updateFlight()
	end
end)

X.MouseButton1Click:Connect(function()
	notificationyesno("Destroy menu and stop fly?", "Confirm", 5, "Yes!", "No")
end)

T.MouseButton1Click:Connect(function()
	menuHidden = not menuHidden
	for _, child in pairs(WIP:GetChildren()) do
		if child.Name ~= "UR" and (child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("TextBox")) then
			child.Visible = not menuHidden
		end
	end
	if menuHidden == false then
		WIP.BackgroundTransparency = 0
	else
		WIP.BackgroundTransparency = 1
	end
	T.Text = menuHidden and "+" or "-"
end)

NP.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		NP.BackgroundColor3 = Color3.new(0, 1, 0)
		NP.Text = "NOCLIP: ON"
		notification("Noclip Enabled", "Status", 2)
	else
		NP.BackgroundColor3 = Color3.new(1, 0, 0)
		NP.Text = "NOCLIP: OFF"
		setNoclip(false)
		notification("Noclip Disabled", "Status", 2)
	end
end)

ST.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		ST.BackgroundColor3 = Color3.new(0.2353, 1, 0.00392)
		ST.Text = "START"
		notification("Flight Stopped", "Status", 2)
	else
		startFly()
		ST.BackgroundColor3 = Color3.new(1, 0, 0)
		ST.Text = "STOP"
		notification("Flight Started", "Status", 2)
	end
end)

TH.FocusLost:Connect(function()
	local num = tonumber(TH.Text)
	if num then
		currentSpeed = math.clamp(num, 1, 500)
		TH.Text = tostring(currentSpeed)
		notification("Speed set to " .. currentSpeed, "Settings", 2)
	else
		TH.Text = tostring(currentSpeed)
	end
end)

SN.MouseButton1Click:Connect(function()
	if chips == false then
		chips = true
		SN.BackgroundColor3 = Color3.new(0, 1, 0)
		SN.Text = "Chips: ON"
		startSpin()
		notification("Spin Enabled", "Chips", 2)
	else
		chips = false
		SN.BackgroundColor3 = Color3.new(1, 0, 0)
		SN.Text = "Chips: OFF"
		stopSpin()
		notification("Spin Disabled", "Chips", 2)
	end
end)

local function rebindKey()
	notification("Press any key to bind", "Bind Key", 3)
	local connection
	connection = uis.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			flyKey = input.KeyCode
			CB.Text = flyKey.Name
			notification("Fly key set to " .. flyKey.Name, "Bind Complete", 2)
			connection:Disconnect()
		end
	end)
end

CB.MouseButton1Click:Connect(rebindKey)

uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == flyKey then
		if flying then
			stopFly()
			ST.BackgroundColor3 = Color3.new(0.2353, 1, 0.00392)
			ST.Text = "START"
		else
			startFly()
			ST.BackgroundColor3 = Color3.new(1, 0, 0)
			ST.Text = "STOP"
		end
	end
end)

p.CharacterAdded:Connect(function()
	flying = false
	noclipEnabled = false
	chips = false
	bodyVelocity = nil
	stopSpin()
	ST.BackgroundColor3 = Color3.new(0.2353, 1, 0.00392)
	ST.Text = "START"
	NP.BackgroundColor3 = Color3.new(1, 0, 0)
	NP.Text = "NOCLIP: OFF"
	SN.BackgroundColor3 = Color3.new(1, 0, 0)
	SN.Text = "Chips: OFF"
end)

notification("FLY V2 LOADED", "Ready!", 2)
