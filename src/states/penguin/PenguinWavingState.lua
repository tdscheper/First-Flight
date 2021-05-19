--[[
	GD50
    Final Project - Tiny Wings Remake
    PenguinWavingState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com

    Just the penguin waving.
]]

PenguinWavingState = Class{__includes = BaseState}

function PenguinWavingState:enter(penguin)
    self.penguin = penguin
    self.animation = Animation {
        frames = PENGUIN_WAVE_FRAMES,
        interval = 0.25
    }
end

function PenguinWavingState:update(dt)
    self.animation:update(dt)
end

function PenguinWavingState:render()
    love.graphics.draw(
        gTextures['penguins'],
        gQuads['penguins'][self.animation:getCurrentFrame()],
        self.penguin.body:getX(),
        self.penguin.body:getY()
    )
end