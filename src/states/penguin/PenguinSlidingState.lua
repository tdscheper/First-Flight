--[[
	GD50
    Final Project - Tiny Wings Remake
    PenguinSlidingState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com
	
	The behavior of the penguin while the user is controlling it (playing the game).
]]

PenguinSlidingState = Class{__includes = BaseState}

function PenguinSlidingState:enter(penguin)
    self.penguin = penguin

    self.image = gImages['sliding-penguin']

    self.penguin.width = SLIDING_PENGUIN_WIDTH
    self.penguin.height = SLIDING_PENGUIN_HEIGHT
end

function PenguinSlidingState:update(dt)
    --[[
        Place middle of penguin's body (horizontally) in middle of ball that's
        actually rolling
        Place bottom of penguin's body at bottom of ball
    --]]
    self.penguin.x = self.penguin.body:getX() - self.penguin.width / 2
    self.penguin.y = self.penguin.body:getY() - self.penguin.height + 
        self.penguin.shape:getRadius()

    --[[
        Make a noise when the penguin is sliding on the terrain. 
        (This code works since the only other possible physics object the 
        penguin can make contact with is the ground.)
    --]]
    if #self.penguin.body:getContactList() == 0 then
        self.penguin.onHill = false
        gSounds['slide']:stop()
    elseif not self.penguin.onHill then
        self.penguin.onHill = true
        gSounds['slide']:play()
    end

    if not self.penguin.inFlight then
        local vx, vy = self.penguin.body:getLinearVelocity()
        -- don't let the penguin fly too fast
        if vx > MAX_VX then
            vx = MAX_VX
        --[[ 
            Always give the penguin some velocity so that it advances through
            the terrain
        --]]
        elseif vx < MIN_VX then
            vx = MIN_VX
        end
        self.penguin.body:setLinearVelocity(vx, vy)
    end

    -- don't let penguin go above screen
    if self.penguin.body:getY() - self.penguin.shape:getRadius() < 0 then
        self.penguin.body:setY(self.penguin.shape:getRadius())
        local vx, vy = self.penguin.body:getLinearVelocity()
        self.penguin.body:setLinearVelocity(vx, 0)
    end

    if     not self.penguin.inFlight
       and (love.mouse.isDown(1) or love.keyboard.isDown('space')) then
        self.penguin.body:applyForce(0, 100)
    end
end

function PenguinSlidingState:render(shader, baseShadeFactor)
    love.graphics.setShader(shader)
    shader:send('DarkFactor', baseShadeFactor / 2)

    love.graphics.draw(self.image, self.penguin.x, self.penguin.y)

    love.graphics.setShader()
end