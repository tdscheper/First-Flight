--[[
    GD50
    Final Project - Tiny Wings Remake
    Penguin.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    The user-controlled penguin.
]]

Penguin = Class{}

function Penguin:init(def)
    self.world = def.world
    self.x = def.x
    self.y = def.y

    self.body = love.physics.newBody(
        self.world,
        self.x,
        self.y,
        'dynamic'
    )
    self.shape = love.physics.newCircleShape(6)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1.25)
    self.fixture:setUserData('penguin')

    self.width = PENGUIN_WIDTH
    self.height = PENGUIN_HEIGHT

    self.stateMachine = StateMachine {
        ['wave'] = function() return PenguinWavingState() end,
        ['slide'] = function() return PenguinSlidingState() end,
        ['fall'] = function() return PenguinFallingState() end,
        ['sit'] = function() return PenguinSittingState() end
    }
    self.stateMachine:change(def.state, self)

    --[[
        Whether we are on a hill or not
        Although we are technically on a hill to begin, start with false so that
        the sliding noise doesn't play
    --]]
    self.onHill = false

    -- whether we are transitioning to next level or not
    self.inFlight = false
end

-- used for collisions with objects outside of the physics world (such as orbs)
function Penguin:collides(target)
    return not (
        (self.x + self.width < target.x or self.x > target.x + target.width) or
        (self.y + self.height < target.y or self.y > target.y + target.height)
    )
end

function Penguin:update(dt)
    self.stateMachine:update(dt)
end

function Penguin:render(shader, baseShadeFactor)
    self.stateMachine:render(shader, baseShadeFactor)
end