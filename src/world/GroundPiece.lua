--[[
    GD50
    Final Project - Tiny Wings Remake
    GroundPiece.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    An individual rectangle used for coloring in the area under the hill curve.
]]

GroundPiece = Class{}

function GroundPiece:init(x, y)
    self.x = x
    self.y = y
    self.width = GROUND_PIECE_WIDTH
    self.height = GROUND_PIECE_HEIGHT
    self.color = gColors['white']
end

function GroundPiece:render()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle(
        'fill',
        math.floor(self.x),
        math.floor(self.y),
        self.width,
        self.height
    )
end