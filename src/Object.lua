--[[
    GD50
    Final Project - Tiny Wings Remake
    Object.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    The parent class for any object in the game.
]]

Object = Class{}

function Object:init(def)
    self.image = def.image
    self.width = def.width or self.image:getWidth()
    self.height = def.height or self.image:getHeight()
    self.x = def.x
    self.y = def.y
    self.followCamera = def.followCamera
    if self.followCamera == nil then self.followCamera = false end
end

function Object:update(dt, translateX)
    if self.followCamera then
        self.x = (-translateX or 0) + self.x
    end
end

function Object:render()
    love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end