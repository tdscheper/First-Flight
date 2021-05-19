--[[
	GD50
    Final Project - Tiny Wings Remake
    PenguinSittingState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com

    Just the penguin sitting down.
]]

PenguinSittingState = Class{__includes = BaseState}

function PenguinSittingState:enter(penguin)
    self.penguin = penguin
    self.frame = PENGUIN_SIT_FRAME
end

function PenguinSittingState:render()
    love.graphics.draw(
        gTextures['penguins'],
        gQuads['penguins'][self.frame],
        self.penguin.body:getX(),
        self.penguin.body:getY()
    )
end