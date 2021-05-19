--[[
	GD50
    Final Project - Tiny Wings Remake
    PlayState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com
	
	Screen where the user plays the game.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.daylightBar = DaylightBar()

    -- used for camera
    self.translateX = 0

    --[[
        This code comes from
        https://love2d.org/forums/viewtopic.php?t=79617
        I altered it so that it darkens (rather than lightens) images
    --]]
    self.darkShader = love.graphics.newShader([[
        extern float DarkFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb -= vec3(DarkFactor);
            return outputcolor;
        }
    ]])
    self.shadeFactor = 0

    self.score = 0
    -- how long the game goes on
    self.duration = 0
    -- how many times user gets penguin to touch clouds
    self.cloudTouches = 0

    Timer.clear()
    self.timer = START_TIME
    Timer.every(1, function()
        self.timer = self.timer - 1
        self.duration = self.duration + 1
        self.score = self.score + 1
    end)
end

function PlayState:enter(def)
    self.world = def.world
    self.background = def.background
    self.terrain = def.terrain
    self.penguin = def.penguin
    self.level = def.level or 1

    self.penguin.stateMachine:change('slide', self.penguin)
end

function PlayState:update(dt)
    self.world:update(dt)

    self.penguin:update(dt)
    self.translateX = -self.penguin.body:getX() + PENGUIN_START_X

    --[[
        We want the background/terrain to get darker as time passes.
        With 0 seconds left, we want the shading factor to be 0.8 (we don't want
        the screen to go completely black). With however many seconds we started
        with (START_TIME seconds) left, we want the shading factor to be 0. 
        With this, we get the function y = (-0.8/START_TIME)x + 0.8, where
        x is the time and y is the shading factor.
        In case the timer ever rises above its start time, make sure the shading
        factor never goes below 0; also, in case the timer goes below 0, make sure it 
        never goes above 0.8.
    --]]
    self.shadeFactor = math.min(
        0.8, 
        math.max(0, (-0.8/START_TIME) * self.timer + 0.8)
    )

    self.background:update(dt, self.translateX)
    self.terrain:update(dt, self.translateX)
    self.daylightBar:update(dt, self.translateX, self.timer, START_TIME)

    for i, hill in ipairs(self.terrain.hills) do
        if     not hill.scored
           and self.penguin.x + self.penguin.width > hill.x + hill.width then
            self.score = self.score + 10
            hill.scored = true
        end
    end

    for i, orb in ipairs(self.terrain.orbs) do
        if self.penguin:collides(orb) then
            self.penguin.body:applyForce(1000, 100)
            gSounds['orb-consume']:play()
            orb.consumed = true
        end
    end

    -- add to the score, timer if the bird reahces cloud level
    for i, cloud in ipairs(self.background.clouds) do
        if self.penguin:collides(cloud) and not self.penguin.inFlight then
            if not self.penguin.squeaking then
                gSounds['squeak']:play()

                --[[
                    Put this here so it doesnt't execute every single frame that the 
                    penguin is touching a cloud
                --]]
                self.score = self.score + 50
                self.timer = self.timer + 1
                self.cloudTouches = self.cloudTouches + 1

                self.penguin.squeaking = true
                Timer.after(2, function()
                    self.penguin.squeaking = false
                end)
            end
        end
    end

    -- If we've made it past the terrain, move to the next level
    if     not self.penguin.inFlight 
       and self.penguin.x > self.terrain.x + self.terrain.width then
        -- ensure the penguin makes it to the next terrain
        self.penguin.body:setLinearVelocity(500, 0)
        self.penguin.body:setGravityScale(0)
        self.penguin.inFlight = true

        -- add to score, add time to timer
        Timer.every(0.5, function()
            self.timer = self.timer + 5
            self.score = self.score + 100
        end):limit(6)

        -- spawn new terrain
        self.level = self.level + 1
        self.terrain = Terrain(
            self.world, 
            self.level,
            self.terrain.x + self.terrain.width + STANDARD_HILL_WIDTH * 10
        )
    end

    -- If we've moved to a new level, reset the gravity scale of the penguin
    if     self.penguin.inFlight 
       and self.penguin.x > self.terrain.x - STANDARD_HILL_WIDTH then
        self.penguin.body:setGravityScale(1)
        self.penguin.inFlight = false
    end

    --[[
        This is unlikely, but if penguin ever drops to a height which is beneath
        the lowest part of a hill, then it's game over
    --]]
    if self.penguin.y > VIRTUAL_HEIGHT - GROUND_MARGIN then
        -- drop it below the screen
        local vx, vy = self.penguin.body:getLinearVelocity()
        self.penguin.body:setLinearVelocity(vx, 20)

        gStateMachine:change('game-over', {
            world = self.world,
            background = self.background,
            terrain = self.terrain,
            penguin = self.penguin,
            shader = self.darkShader,
            shadeFactor = self.shadeFactor,
            translateX = self.translateX,
            score = self.score,
            duration = self.duration,
            cloudTouches = self.cloudTouches
        })
    end

    if self.timer <= 0 then
        gStateMachine:change('game-over', {
            world = self.world,
            background = self.background,
            terrain = self.terrain,
            penguin = self.penguin,
            shader = self.darkShader,
            shadeFactor = self.shadeFactor,
            translateX = self.translateX,
            score = self.score,
            duration = self.duration,
            cloudTouches = self.cloudTouches
        })
    end
end

function PlayState:render()
    love.graphics.translate(self.translateX, 0)

    self.background:render(self.darkShader, self.shadeFactor)
    self.terrain:render(self.darkShader, self.shadeFactor)
    self.penguin:render(self.darkShader, self.shadeFactor)
    self.daylightBar:render()

    -- display the score on top right of screen, below clouds
    local font = gFonts['italic-medium']
    local scoreText = tostring(self.score)
    love.graphics.setFont(font)
    love.graphics.setColor(unpack(gColors['cyan']))
    love.graphics.print(
        scoreText,
        -self.translateX + VIRTUAL_WIDTH - font:getWidth(scoreText) - 5,
        30
    )
    font = gFonts['medium']
    local text = 'SCORE: '
    love.graphics.setFont(font)
    love.graphics.print(
        text,
          -self.translateX + VIRTUAL_WIDTH - font:getWidth(scoreText) - 5 
        - font:getWidth(text),
        30
    )

    -- If we're moving to a new level, display the level
    if self.penguin.inFlight then
        font = gFonts['italic-large']
        text = 'Island ' .. tostring(self.level)
        love.graphics.setFont(font)
        love.graphics.setColor(unpack(gColors['cyan']))
        love.graphics.print(
            text,
            -self.translateX + VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2,
            VIRTUAL_HEIGHT / 2 - font:getHeight(text) / 2
        )
    end
end