local ts=game:GetService'TweenService'
local debris=game:GetService'Debris'

local userinput=game:GetService('UserInputService')
local NOJUMPALLOWED= false

function playSoundFromPart(part,sndname)
	local snd = script:FindFirstChild(sndname)
	if snd ~= nil then
		local sndc = snd:Clone()
		sndc.Parent = part
		sndc:Play()
		debris:AddItem(sndc,sndc.TimeLength+1)
	end
end

return function()
	local Riding = false
	local val
	for _,d in pairs(script.Parent:GetChildren()) do
		if d:IsA'Decal' then
			d.Color3=script.Parent.Color
		end
	end
	local swing = script.Parent:WaitForChild("Swing")
	local top = script.Parent:WaitForChild("Top")
	local val = swing:FindFirstChild("Activated")
	local rt = (script.Parent:FindFirstChild("RespawnTime") and script.Parent.RespawnTime.Value) or 1
	local oldT = swing.Transparency
	local curTween = nil
	swing.ParticleEmitter.Color = ColorSequence.new(swing.Color)
	swing.Touched:Connect(function(part)
		if game.Players:GetPlayerFromCharacter(part.Parent) == game.Players.LocalPlayer and part.Parent:FindFirstChild("Humanoid") and not (val and not val.Value) then
			if Riding ~= true then
				Riding = true
				local autodisconnect
				local h=part.Parent.Humanoid
				if not NOJUMPALLOWED then
					userinput.JumpRequest:Connect(function()
						autodisconnect=true
					end)
				end
				if curTween ~= nil then
					curTween:Cancel()
					swing.Transparency = oldT
				end
				playSoundFromPart(swing,"Grab")
				local ZPA = Instance.new("Animation")
				ZPA.AnimationId = "rbxassetid://2528639449"
				local ZPAT = part.Parent:FindFirstChild("Humanoid"):LoadAnimation(ZPA)
				local Rope = Instance.new("RopeConstraint")
				local Bar = Instance.new("Part")
				local A2 = Instance.new("Attachment")
				local P1 = Instance.new("Attachment")
				local P2 = Instance.new("Attachment")
				local Weld = Instance.new("WeldConstraint")
				Bar.Size = Vector3.new(3,0.4,0.4)
				Bar.TopSurface='Smooth'
				Bar.BottomSurface='Smooth'
				Bar.CanCollide = false
				Bar.CFrame = part.Parent:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,0)
				Bar.CustomPhysicalProperties = PhysicalProperties.new(10,0,0)
				Bar.Color = swing.Color
				A2.Parent = top
				P1.Parent = top
				P2.Parent = Bar
				Rope.Length = script.Parent.RopeLength.Value
				Rope.Visible = true
				Rope.Color = swing.BrickColor
				Rope.Attachment0 = P1
				Rope.Attachment1 = P2
				Rope.Parent = top
				Bar.Parent = script.Parent
				Weld.Part0 = part.Parent:FindFirstChild("HumanoidRootPart")
				Weld.Part1 = Bar
				Weld.Parent = Bar
				swing.Transparency = 0
				ZPAT:Play()
				local pos=swing.Position.Y
				repeat wait() until autodisconnect or part.Parent:WaitForChild("Humanoid").Health<=0
				Bar:Destroy()
				Rope:Destroy()
				Weld:Destroy()
				Bar.CanCollide=true
				ZPAT:Stop()
				ZPAT:Destroy()
				part.Parent:WaitForChild("Humanoid"):ChangeState'Jumping'
				playSoundFromPart(swing,"Jump")
				if rt == 0 then
					Riding=false
					swing.Transparency = oldT
				else
					task.wait(rt)
					Riding=false
					curTween = ts:Create(swing,TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=oldT})
					curTween:Play()
					swing.ParticleEmitter.Enabled = true
					task.wait(1)
					swing.ParticleEmitter.Enabled = false
				end
			end
		end
	end)
end