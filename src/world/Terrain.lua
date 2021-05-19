--[[
    GD50
    Final Project - Tiny Wings Remake
    Terrain.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    The terrain which the user-controlled penguin slides on to gain speed and altitude.
]]

Terrain = Class{}

function Terrain:init(world, level, x)
    self.world = world
    self.levelHills = math.max(30, math.min(120, (level + 1) * 12))
    self.x = x or 0
    self.width = 0
    
    self.hills = {}
    --[[
        Need a variable to keep track of the total number of hills created by
        this instance of Terrain since the actual Hills will be removed from
        self.hills
    --]]
    self.numHills = 0
    
    self.orbs = {}
    self:generateHills(self.x)
    
    -- whether we've generated the last set of hills in this terrain or not
    self.endReached = false
end

function Terrain:generateHills(passX)
    if self.numHills + NUM_HILLS_GEN <= self.levelHills then
        -- first hill is always regular
        if self.numHills == 0 then
            table.insert(self.hills, Hill {
                world = self.world, 
                x = passX - 64, 
                type = 'standard-standard'
            })
        else
            table.insert(self.hills, Hill {
                world = self.world,
                x = self.hills[#self.hills].x + self.hills[#self.hills].period
            })
        end
        self.numHills = self.numHills + 1
        self.width = self.width + self.hills[#self.hills].period

        for i = 2, NUM_HILLS_GEN do
            table.insert(self.hills, Hill {
                world = self.world,
                x = self.hills[#self.hills].x + self.hills[#self.hills].period
            })
            self.numHills = self.numHills + 1
            self.width = self.width + self.hills[#self.hills].period
        end

        --[[
            If these were the last set of hills in the terrain, then add orbs
            before the last few hills
        --]]
        if self.numHills + NUM_HILLS_GEN > self.levelHills then
            self:generateOrbs()
        end
    elseif not self.endReached then
        self.endReached = true
    end
end

function Terrain:generateOrbs()
    for i = #self.hills, #self.hills - 1, -1 do
        local orbX = self.hills[i].x + self.hills[i].width / 4 - ORB_WIDTH
        local orbY = VIRTUAL_HEIGHT - GROUND_MARGIN - self.hills[i].height / 2 - ORB_HEIGHT

        -- table.insert(self.orbs, Orb(orbX, orbY))
        table.insert(self.orbs, Object {
            image = gImages['orb'],
            x = orbX, 
            y = orbY
        })

        -- Since skinny hills spawn two at a time, ensure there's an orb at both of the 2
        local type = self.hills[i].type
        if type == 'skinny-standard' or type == 'skinny-short' then
            table.insert(self.orbs, Object {
                image = gImages['orb'],
                x = orbX + self.hills[i].width, 
                y = orbY
            })
        end
    end
end

function Terrain:update(dt, translateX)
    for i, hill in ipairs(self.hills) do
        hill:update(dt, translateX or 0)

        if hill.destroyed then
            table.remove(self.hills, i)

            if #self.hills <= NUM_HILLS_GEN and not self.endReached then 
                self:generateHills(self.x) 
            end
        end
    end
end

function Terrain:render(shader, baseShadeFactor)
    if shader then
        love.graphics.setShader(shader)
        shader:send('DarkFactor', baseShadeFactor / 2)
    end

    for i, hill in ipairs(self.hills) do
        hill:render()
    end
    
    love.graphics.setShader()

    for i, orb in ipairs(self.orbs) do
        if not orb.consumed then orb:render() end
    end
end