local partiros = Instance.new("Part", workspace)
partiros.Size = Vector3.new(100000, 1, 100000)
partiros.Anchored = true
local UIS = game:GetService("UserInputService")
print("Hi this is working Script Cobaken555")
local debounce = false

local function notification(Text, Subtext, Time)
	if debounce == false then 
		debounce = true
		game.StarterGui:SetCore("SendNotification", {
			Title = Subtext;
			Text = Text;
			Duration = Time;})
		task.wait(1)
		debounce = false
	end
end
notification("Hi This script Working", "WORKS", 3)

UIS.InputBegan:Connect(function(plr)
	if plr.KeyCode == Enum.KeyCode.E then
		partiros.Position = partiros.Position + Vector3.new(0,1,0)
	end
	if plr.KeyCode == Enum.KeyCode.Q then
		partiros.Position = partiros.Position - Vector3.new(0,1,0)
	end
end)
