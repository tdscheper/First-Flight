--[[
	GD50
    Final Project - Tiny Wings Remake
    GameOverState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com
	
	Screen that displays the user's score and duration of the game after it ends.
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:enter(def)
    self.world = def.world
    self.background = def.background
    self.terrain = def.terrain
    self.penguin = def.penguin
    self.shader = def.shader
    self.shadeFactor = def.shadeFactor
    self.translateX = def.translateX
    self.score = def.score
    self.duration = def.duration
    self.cloudTouches = def.cloudTouches

    self:createButtons()
    self:addHighScore()

    Timer.clear()
    self.timer = 0
    Timer.every(0.35, function()
        self.timer = self.timer + 1
    end)
end

function GameOverState:createButtons()
    self.buttons = {}

    -- back button
    table.insert(self.buttons, Button {
        font = gFonts['large'],
        fontColor = gColors['white'],
        text = 'BACK',
        translateX = self.translateX,
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2 + 30,
        xMargin = 2,
        yMargin = 2,
        color = gColors['transparent'],
        onPress = function()
            gStateMachine:change('start')
        end
    })

end

function GameOverState:addHighScore()
    -- if high enough, add high score to the file holding scores
    local scores = loadHighScores()
    if #scores < 15 or self.score > getMin(scores) then
        love.filesystem.append('first_flight.lst', tostring(self.score) .. '\n')
    end
end

function GameOverState:update(dt)
    self.world:update(dt)

    self.penguin:update(dt)
    -- drop the penguin
    local vx, vy = self.penguin.body:getLinearVelocity()
    self.penguin.body:setLinearVelocity(0, math.max(0, vy))

    if    self.timer >= 2 and (love.keyboard.wasPressed('return') 
       or self.buttons[1]:wasClicked()) then
        self.buttons[1].onPress()
    end

    self.background:update(dt, self.translateX)
    self.terrain:update(dt, self.translateX)
end

function GameOverState:render()
    love.graphics.translate(self.translateX, 0)

    self.background:render(self.shader, self.shadeFactor)
    self.terrain:render(self.shader, self.shadeFactor)
    self.penguin:render(self.shader, self.shadeFactor)

    -- our only button
    -- flash the highlight; keep it highlighted if hovered over
    if self.timer >= 2 then
        local highlight = false
        if self.buttons[1]:isBeingHoveredOver() or self.timer % 2 == 0 then
            highlight = true
        end
        self.buttons[1]:render(highlight and gColors['cyan'])
    end


    local font = gFonts['huge']
    love.graphics.setFont(font)
    love.graphics.setColor(unpack(gColors['white']))
    local text = 'Score: ' .. tostring(self.score)
    love.graphics.print(
        text,
        -self.translateX + VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2,
        VIRTUAL_HEIGHT / 3 - 20 - font:getHeight(text) / 2
    )

    font = gFonts['italic-medium']
    love.graphics.setFont(font)
    text = 'Duration: ' .. timeToString(self.duration)
    love.graphics.print(
        text,
        -self.translateX + VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2,
        VIRTUAL_HEIGHT / 3 - 20 - font:getHeight(text) / 2 + 40
    )

    text = 'Cloud Touches: ' .. tostring(self.cloudTouches)
    love.graphics.print(
        text,
        -self.translateX + VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2,
        VIRTUAL_HEIGHT / 3 - 20 - font:getHeight(text) / 2 + 60
    )
end