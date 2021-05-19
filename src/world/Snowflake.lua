--[[
    GD50
    Final Project - Tiny Wings Remake
    Snowflake.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    A simple snowflake that falls down toward the bottom of the screen.
]]

Snowflake = Class{}

function Snowflake:init(x, y)
    self.x = x
    self.y = y
    self.radius = SNOWFLAKE_RADIUS
    self.color = gColors['white']
    self.dy = SNOWFALL_SPEED
end

function Snowflake:update(dt)
    -- make the snowflake fall down the screen
    self.y = self.y + self.dy * dt
end

function Snowflake:render()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle(
        'fill',
        math.floor(self.x),
        math.floor(self.y),
        self.radius
    )
end