local field = script.Parent
local gravitymult = script.Parent.Gravity.Value
return function()
	
	local infield = false
	local plr = game.Players.LocalPlayer
	
	local function ChangeGravity(part)
		local gravatt = part:FindFirstChild("Gravattachment")
		if not gravatt then
			local atta = Instance.new("Attachment")
			atta.Parent = part
			atta.Name = "Gravattachment"
			local vforce = Instance.new("VectorForce")
			vforce.Parent = atta
			vforce.Attachment0 = atta
			vforce.RelativeTo = Enum.ActuatorRelativeTo.World
			if part.Massless == false then
				vforce.Force = Vector3.new(0,workspace.Gravity*part:GetMass()*-gravitymult)
			else
				vforce.Force = Vector3.new(0,workspace.Gravity*0*-gravitymult)
			end
		end
	end
	
	local function RevertGravity(part)
		local gravatt = part:FindFirstChild("Gravattachment")
		if gravatt then
			gravatt:Destroy()
		end
	end
	
	field.Touched:Connect(function(graveff)
		if game.Players:GetPlayerFromCharacter(graveff.Parent) == plr and graveff.Name == "HumanoidRootPart" then
			for _,v in pairs(graveff.Parent:GetChildren()) do
				if v:IsA("BasePart") then
					ChangeGravity(v)
				end
			end
		end
	end)
	
	field.TouchEnded:Connect(function(graveff)
		if game.Players:GetPlayerFromCharacter(graveff.Parent) == plr and graveff.Name == "HumanoidRootPart" then
			for _,v in pairs(graveff.Parent:GetChildren()) do
				if v:IsA("BasePart") then
					RevertGravity(v)
				end
			end
		end
	end)
end