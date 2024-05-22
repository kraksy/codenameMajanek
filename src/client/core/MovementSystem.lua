
local MovementSystem = {}

local dashSpeed = 120 -- Adjust this value to set the dash speed
local dashDuration = 0.3 -- Adjust this value to set the dash duration
local isDashing = false
local isInAir = false

function MovementSystem.dash()
    if isDashing then
        return
	end
    
    local character = game.Players.LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local direction = humanoid.MoveDirection
    local dashVelocity = direction * dashSpeed
    rootPart.Velocity = dashVelocity
    
    isDashing = true
    
    wait(dashDuration)
    rootPart.Velocity = Vector3.new(0, 0, 0) -- Stop the player's movement after the dash duration 
    isDashing = false
end

return MovementSystem