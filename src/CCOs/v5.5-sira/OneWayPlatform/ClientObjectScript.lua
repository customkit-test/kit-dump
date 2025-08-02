return function()
	script.Parent.RightSurface = "Universal"
	local p=game.Players.LocalPlayer
	game:GetService('RunService').RenderStepped:Connect(function()
		local c=p.Character
		if c then
			local pp=c.PrimaryPart
			if pp and script.Parent then
				script.Parent.CanCollide=(pp.Position.Y>script.Parent.Position.Y+2)
			end
		end
	end)
end