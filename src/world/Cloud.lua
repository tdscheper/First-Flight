--[[
    GD50
    Final Project - Tiny Wings Remake
    Cloud.lua

    Author: Tommy Scheper
    tdscheper@gmail.com
]]

Cloud = Class{}

function Cloud:init(x, y)
    self.image = gImages['cloud']
    self.width = CLOUD_WIDTH
    self.height = CLOUD_HEIGHT
    self.x = x
    self.y = y
end

function Cloud:render()
    self.image:setFilter('linear', 'linear')
    love.graphics.draw(self.image, self.x, self.y)
end