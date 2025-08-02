local ogcooldown = script.Parent.Cooldown
local timer = 0

-- // Hey code snooper, I see you! Thanks for using this CO though :)

return function()
	script.Parent.Touched:Connect(function(part)
		if part.Parent.Humanoid ~= nil then
			if timer <= 0 then
				timer = ogcooldown.Value
				script.Parent.BillboardGui.Timer.Text = timer
				script.Parent.HealSFX:Play()
				script.Parent.BillboardGui.Timer.Visible = true
				
				game.ReplicatedStorage.HealEvent:FireServer(game.Players.LocalPlayer)
				script.Parent.Color = Color3.fromRGB(90, 90, 90)
				script.Parent.HealParticle:Emit()
				
				while timer > 0 do
					script.Parent.BillboardGui.Timer.Text = timer
					script.Parent.TimerSFX:Play()
					wait(1)
					timer -= 1
				end
				
				script.Parent.Color = Color3.fromRGB(66, 105, 66)
				script.Parent.BillboardGui.Timer.Visible = false
			end
		end
	end)

end

