local hpower = script.Parent.Parent.HealPower

game.ReplicatedStorage.HealEvent.OnServerEvent:Connect(function(plr, Type)
	if Type == "Pad" then
		local Humanoid = game.Workspace:WaitForChild(plr.Name).Humanoid
		if (Humanoid.Health + hpower.Value) >= 100 then
			Humanoid.Health = 100
		else
			Humanoid.Health += hpower.Value
		end
	end
end)