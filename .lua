aimlock.MouseButton1Down:connect(function()
	PLAYER  = game.Players.LocalPlayer
	MOUSE   = PLAYER:GetMouse()
	CC      = game.Workspace.CurrentCamera

	_G.AIM_AT = 'Head'
	_G.BIND   = 101 -- E

	function GetNearestPlayerToMouse()
		local PLAYERS      = {}
		local PLAYER_HOLD  = {}
		local DISTANCES    = {25000}
		for i, v in pairs(game.Players:GetPlayers()) do
			if v ~= PLAYER then
				table.insert(PLAYERS, v)
			end
		end
		for i, v in pairs(PLAYERS) do
			if v and (v.Character) ~= nil and v.Team ~= PLAYER.Team then
				local AIM = v.Character:FindFirstChild(_G.AIM_AT)
				if AIM ~= nil then
					local DISTANCE                 = (AIM.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
					local RAY                      = Ray.new(game.Workspace.CurrentCamera.CoordinateFrame.p, (MOUSE.Hit.p - CC.CoordinateFrame.p).unit * DISTANCE)
					local HIT,POS                  = game.Workspace:FindPartOnRay(RAY, game.Workspace)
					local DIFF                     = math.floor((POS - AIM.Position).magnitude)
					PLAYER_HOLD[v.Name .. i]       = {}
					PLAYER_HOLD[v.Name .. i].dist  = DISTANCE
					PLAYER_HOLD[v.Name .. i].plr   = v
					PLAYER_HOLD[v.Name .. i].diff  = DIFF
					table.insert(DISTANCES, DIFF)
				end
			end
		end

		if unpack(DISTANCES) == nil then
			return false
		end

		local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
		if L_DISTANCE > 25000 then
			return false
		end

		for i, v in pairs(PLAYER_HOLD) do
			if v.diff == L_DISTANCE then
				return v.plr
			end
		end
		return false
	end

	MOUSE.KeyDown:connect(function(KEY)
		KEY = KEY:lower():byte()
		if KEY == _G.BIND then
			ENABLED = true
		end
	end)

	MOUSE.KeyUp:connect(function(KEY)
		KEY = KEY:lower():byte()
		if KEY == _G.BIND then
			ENABLED = false
		end
	end)

	game:GetService('RunService').RenderStepped:connect(function()
		if ENABLED then
			local TARGET = GetNearestPlayerToMouse()
			if (TARGET ~= false) then
				local AIM = TARGET.Character:FindFirstChild(_G.AIM_AT)
				if AIM then
					CC.CoordinateFrame = CFrame.new(CC.CoordinateFrame.p, AIM.CFrame.p)
				end
			end
		end
	end)

	print("Rage-Aimbot loaded")
end)
