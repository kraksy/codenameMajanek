
local folder = script:WaitForChild("core") 
local CombatS = folder:WaitForChild("CombatSystem")
local MovementS = folder:WaitForChild("MovementSystem")

local Combat = require(CombatS)
local Movement = require(MovementS)

local UserInputService = game:GetService("UserInputService")	
local Logservice = game:GetService("LogService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local humanoid = character:WaitForChild("Humanoid")

local FPS = Enum.CameraMode.LockFirstPerson
local TPS = Enum.CameraMode.Classic

player.CameraMode = TPS

local FPSLocked = true

--- all inputs 

local shiftKeyL = Enum.KeyCode.LeftShift 
local Qkey = Enum.KeyCode.Q
local FKey = Enum.KeyCode.F
local DebugKey = Enum.KeyCode.L

--- 

local isShiftDown = false -- LEFT SHIFT
local isADown = false -- A
local isDDown = false -- D

local isWDown = false -- W
local isSDown = false -- S 

local dashLock = false
local isBlocking = false
local isDebug = true -- for camera 

local function handledash()
	if isADown and isShiftDown then
		print("dashing")
		Movement.dash()
	elseif isDDown and isShiftDown then
		print("dashing")
		Movement.dash()
	end
end

local function isInAir()
	local state = humanoid:GetState()
	return state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping
end

local function HandleInput()
	dashLock = false
	if isInAir() then dashLock = true 
	elseif not isSDown then dashLock = true 
	elseif not isWDown then dashLock = true 
	elseif not dashLock then
		handledash()
	end
end

local function toggleDebug()
	isDebug = not isDebug
end

local function toggleBlocking()
	isBlocking = not isBlocking
end

humanoid.StateChanged:Connect(function(oldState, newState)
	if isInAir() then
		print("Player is in the air")
	else
		print("Player is not in the air")
	end
end)

UserInputService.InputBegan:Connect(function(input, typing)
	if not typing then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Combat.attack()
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			Combat.Block()
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.A then
				isADown = true
				HandleInput()
			elseif input.KeyCode == Enum.KeyCode.D then
				isDDown = true
				HandleInput()
			elseif input.KeyCode == Enum.KeyCode.W then
				isWDown = true
			elseif input.KeyCode == Enum.KeyCode.S then
				isSDown = true
			elseif input.KeyCode == Enum.KeyCode.LeftShift then
				isShiftDown = true
				HandleInput()
			elseif input.KeyCode == Enum.KeyCode.L then
				toggleDebug()
				if isDebug then
					player.CameraMode = FPS
				elseif not isDebug then
					player.CameraMode = TPS
					player.CameraMinZoomDistance = 10
				end
			end
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, typing)
	if not typing then
		if input.KeyCode == Enum.UserInputType.MouseButton1 then
			return
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.LeftShift then
				isShiftDown = false
			elseif input.KeyCode == Enum.KeyCode.A then
				isADown = false
			elseif input.KeyCode == Enum.KeyCode.W then
				isWDown = false
			elseif input.KeyCode == Enum.KeyCode.S then
				isSDown = false
			elseif input.KeyCode == Enum.KeyCode.D then
				isDDown = false
			end
		end
	end
end)