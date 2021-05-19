--[[
    GD50
    Final Project - Tiny Wings Remake
    Hill.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    One hill which makes up the terrain.
]]

Hill = Class{}

function Hill:init(def)
    self.world = def.world
    self.body = love.physics.newBody(self.world, 0, 0, 'kinematic')

    --[[
        Table which will contain the coordinates of each point of each line
        segment which shape the hill's curve.
        Format: {x1, y1, x2, y2, ... xn, yn}
    --]]
    self.piecePoints = {}
    --[[
        Table which will contain each rectangle (GroundPiece) which colors in 
        the area under the hill's curve
    --]]
    self.pieces = {}

    -- choose type of hill
    local types = {
        'standard-standard', 
        'skinny-standard', 
        'standard-tall', 
        'skinny-short'
    }
    self.type = def.type or types[math.random(#types)]

    self.width = HILL_DEFS[self.type].width
    self.height = HILL_DEFS[self.type].height
    self.shift = HILL_DEFS[self.type].shift

    self.x = def.x

    -- If hill is skinny, spawn two of them
    self.period = STANDARD_HILL_WIDTH
    -- Shape the hill
    for x = self.x, self.x + self.period, GROUND_PIECE_WIDTH do
        local y = getHillYAt(x, self.width, self.height, self.shift, GROUND_MARGIN)
        table.insert(self.piecePoints, x)
        table.insert(self.piecePoints, y)
    end 

    -- physical
    self.shape = love.physics.newChainShape(false, self.piecePoints)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData('hill')

    -- visual
    for i = 1, #self.piecePoints, 2 do
        table.insert(self.pieces, GroundPiece(
            self.piecePoints[i], 
            self.piecePoints[i + 1]
        ))
    end

    -- whether or not the hill's physics body has been destroyed
    self.destroyed = false
end

function Hill:update(dt, translateX)
    if not self.destroyed and self.x + self.period < (-translateX or 0) then
        self.body:destroy()
        self.destroyed = true
    end
end

function Hill:render()
    if not self.destroyed then
        for i, piece in ipairs(self.pieces) do
            piece:render()
        end

        --[[
           Draw line over the tops of the pieces.
           There will actually be three lines: one regular, one to the right a 
           bit, and one to the left a bit
        --]]
        love.graphics.setColor(unpack(gColors['white']))
        local points = {
            self.body:getWorldPoints(
                self.shape:getPoints()
            )
        }
        -- regular
        for i = 1, #points do
            points[i] = math.floor(points[i])
        end
        love.graphics.line(unpack(points))
        -- to the right
        for i = 1, #points, 2 do
            points[i] = points[i] + 1
        end
        love.graphics.line(unpack(points))
        -- to the left
        for i = 1, #points, 2 do
            points[i] = points[i] - 2
        end
        love.graphics.line(unpack(points))
    end
end