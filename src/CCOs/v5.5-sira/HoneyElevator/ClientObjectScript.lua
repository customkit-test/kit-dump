return function()
	script.Parent.TopSurface = 'Studs'
	if script.Parent.Name == "ButtonActivatedPlatform" or script.Parent:FindFirstChild("ButtonActivated") then
		local a = Instance.new("BoolValue",script.Parent)
		a.Name = "Activated"
	end
	local players = not script.Parent:FindFirstChild("IgnorePlayers")
	local boxes = not script.Parent:FindFirstChild("IgnoreBoxes")
	local speed = script.Parent:FindFirstChild("Speed") and script.Parent.Speed.Value or 40
	
	local pad = script.Parent
	local pad2 = pad:Clone()
	pad2:ClearAllChildren()
	pad2.Transparency = 1
	pad2.Size = pad2.Size + Vector3.new(3,1,3)
	pad2.CFrame = pad.CFrame + script.Parent.CFrame.UpVector * 1/2
	pad2.CanCollide = false
	pad2.Parent = pad
	pad2.Anchored = false
	pad2.Massless = true
	local wc = Instance.new("WeldConstraint",pad2)
	wc.Part0 = pad2
	wc.Part1 = pad
	local onpad = false
	
	pad2.Touched:Connect(function(part)
		local torso = part.Parent:FindFirstChild("Torso") or part
		if (not torso:FindFirstChild("ElevatorVelocity") and (part.Parent:FindFirstChild("Humanoid") and players) or ((part.Name == "Pushbox" or part:FindFirstChild("IsBox") ~= nil) and boxes))
			and not (script.Parent:FindFirstChild("Activated") and not script.Parent.Activated.Value) then
			local velocity = Instance.new("BodyVelocity", torso)
			velocity.Name = "ElevatorVelocity"
			local uv=script.Parent.CFrame.UpVector
			local maxf=Vector3.new(0,0,0)
			if uv.X ~= 0 then maxf = Vector3.new(math.huge, maxf.Y, maxf.Z) end
			if uv.Z ~= 0 then maxf = Vector3.new(maxf.X, maxf.Y, math.huge) end

			velocity.MaxForce = Vector3.new(0,math.huge,0)
			velocity.Velocity = script.Parent.CFrame.UpVector*speed
		end
	end)
	pad2.TouchEnded:Connect(function(part)
		local torso = part.Parent:FindFirstChild("Torso") or part
		if torso:FindFirstChild("ElevatorVelocity") and (part.Parent:FindFirstChild("Humanoid") and players) or ((part.Name == "Pushbox" or part:FindFirstChild("IsBox") ~= nil) and boxes) then torso.ElevatorVelocity:Destroy() end
	end)
end