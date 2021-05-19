--[[
    GD50
    Final Project - Tiny Wings Remake
    Background.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    The sky, clouds, and snow displayed behind everything else in the game.
]]

Background = Class{}

function Background:init()
    self.sky = gImages['sky']

    -- Two-dimensional table holding the snowflakes, row by row
    self.snow = {}
    self:generateSnow(0, SNOW_OFFSET)

    self.clouds = {}
    self:generateClouds(-CLOUD_WIDTH)

    self.translateX = 0
end

--[[ 
    Generate snowflakes such that they appear like this:
    *   *   *   *
      *   *   *   *
    *   *   *   *
    This will be called only once, when the user opens up the game
--]]
function Background:generateSnow(x, offset)
    local stagger = false
    for i = VIRTUAL_HEIGHT, -VIRTUAL_HEIGHT * 2, -offset do
        self:addSnowRowToTop(x, i, offset, stagger)
        stagger = not stagger
    end
end

function Background:removeBottomSnowRow()
    for i = #self.snow[1], 1, -1 do
        table.remove(self.snow[1], i)
    end
    table.remove(self.snow, 1)
end

function Background:addSnowRowToTop(x, y, offset, stagger)
    table.insert(self.snow, {})

    local s = stagger and offset / 2 or 0
    for i = x + s, x + s + VIRTUAL_WIDTH * 2, offset do
        table.insert(self.snow[#self.snow], Snowflake(i, y))
    end
end

function Background:removeLeftSnowCol()
    for row = 1, #self.snow do
        table.remove(self.snow[row], 1)
    end
end

function Background:addSnowColToRight()
    for row = 1, #self.snow do
        table.insert(self.snow[row], Snowflake(
            self.snow[row][#self.snow[row]].x + SNOW_OFFSET,
            self.snow[row][1].y
        ))
    end
end

-- Make a row of clouds, then add a staggered row on top
function Background:generateClouds(x)
    for i = x, x + VIRTUAL_WIDTH * 2, CLOUD_WIDTH + 5 do
        table.insert(self.clouds, Cloud(i, CLOUD_Y))
    end
    for i = x + CLOUD_WIDTH / 2, x + VIRTUAL_WIDTH * 2, CLOUD_WIDTH + 5 do
        table.insert(self.clouds, Cloud(i, CLOUD_Y))
    end
end

--[[
    Since the rows of clouds are staggered, the last cloud in self.clouds may
    not be the one farthest to the right. This function finds that cloud and 
    returns it.
--]]
function Background:getFarthestCloud()
    local farthestCloud = self.clouds[#self.clouds]

    for i = 1, #self.clouds - 1 do
        if self.clouds[i].x > farthestCloud.x then
            farthestCloud = self.clouds[i]
        end
    end

    return farthestCloud
end

-- same deal as getFarthestCloud(), just with snowflakes
function Background:getFarthestRightSnowflake()
    local farX = math.max(self.snow[1][#self.snow[1]].x, self.snow[2][#self.snow[2]].x)
    if farX == self.snow[1][#self.snow[1]].x then
        return self.snow[1][#self.snow[1]]
    end
    return self.snow[2][#self.snow[2]]
end

-- same deal as getFarthestRightSnowflake(), just left
function Background:getFarthestLeftSnowflake()
    local farX = math.min(self.snow[1][1].x, self.snow[2][1].x)
    if farX == self.snow[1][1].x then
        return self.snow[1][1]
    end
    return self.snow[2][1]
end

function Background:update(dt, translateX)
    self.translateX = translateX or self.translateX

    for row = 1, #self.snow do
        for col = 1, #self.snow[row] do
            self.snow[row][col]:update(dt)
        end
    end

    -- remove any snowflakes that we've gone past
    -- Eliminate left column of self.snow, then add new one to the right
    local leftFlake = self:getFarthestLeftSnowflake()
    if leftFlake.x < -self.translateX - SNOW_OFFSET - SNOWFLAKE_RADIUS then
        self:removeLeftSnowCol()
        self:addSnowColToRight()
    end

    -- remove any snowflakes that have fallen below screen
    -- Eliminate bottom row of self.snow, then add new one to the top
    if self.snow[1][1].y > VIRTUAL_HEIGHT + SNOWFLAKE_RADIUS then
        self:removeBottomSnowRow()

        local stagger = true
        if self.snow[#self.snow][1].x > self.snow[#self.snow - 1][1].x then
            stagger = false
        end
        self:addSnowRowToTop(
            self:getFarthestLeftSnowflake().x,
            self.snow[#self.snow][1].y - SNOW_OFFSET,
            SNOW_OFFSET,
            stagger
        )
    end

    -- remove any clouds that we've gone past
    for i, cloud in ipairs(self.clouds) do
        if cloud.x + cloud.width < -self.translateX then
            table.remove(self.clouds, i)
        end
    end

    -- add more clouds when necessary
    local cloud = self:getFarthestCloud()
    if cloud.x + cloud.width <= -self.translateX + VIRTUAL_WIDTH + CLOUD_WIDTH / 2 then
        self:generateClouds(-self.translateX + VIRTUAL_WIDTH)
    end
end

function Background:render(shader, baseShadeFactor)
    if shader then love.graphics.setShader(shader) end

    -- darken the sky
    if shader then shader:send('DarkFactor', baseShadeFactor) end
    love.graphics.draw(self.sky, -self.translateX, 0)

    -- keep the snow pretty bright
    if shader then shader:send('DarkFactor', baseShadeFactor / 2) end
    for row = 1, #self.snow do
        for col = 1, #self.snow[row] do
            self.snow[row][col]:render()
        end
    end

    -- don't make the clouds too dark
    if shader then shader:send('DarkFactor', baseShadeFactor / 1.5) end
    for i, cloud in ipairs(self.clouds) do
        cloud:render()
    end

    love.graphics.setShader()
end