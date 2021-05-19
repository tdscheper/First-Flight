--[[
	GD50
    Final Project - Tiny Wings Remake
    HighScoreState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com
	
	A screen displaying up to 15 of the device's high scores.
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:init()
    self.highScores = sortTable(loadHighScores())
    self:createButtons()

    Timer.clear()
    self.timer = 0
    Timer.every(0.35, function()
        self.timer = self.timer + 1
    end)
end

function HighScoreState:enter(def)
    self.world = def.world
    self.background = def.background
    self.terrain = def.terrain
    self.penguin = def.penguin

    self.penguin.stateMachine:change('sit', self.penguin)
end

function HighScoreState:createButtons() 
    self.buttons = {}

    -- back button
    table.insert(self.buttons, Button {
        font = gFonts['medium'],
        fontColor = gColors['white'],
        text = 'BACK',
        x = 30,
        y = 45,
        xMargin = 2,
        yMargin = 2,
        color = gColors['transparent'],
        onPress = function()
            gStateMachine:change('start', {
                world = self.world,
                background = self.background,
                terrain = self.terrain,
                penguin = self.penguin
            })
        end
    })
end

function HighScoreState:update(dt)
    self.background:update(dt)
    self.penguin:update(dt)

    if love.keyboard.wasPressed('return') or self.buttons[1]:wasClicked() then
        self.buttons[1].onPress()
    end
end

function HighScoreState:render()
    self.background:render()
    self.terrain:render()
    self.penguin:render()

    -- our only button
    -- flash the highlight; keep it highlighted if hovered over
    local highlight = false
    if self.buttons[1]:isBeingHoveredOver() or self.timer % 2 == 0 then
        highlight = true
    end
    self.buttons[1]:render(highlight and gColors['cyan'])

    -- display high scores
    local font = gFonts['medium']
    love.graphics.setFont(font)
    love.graphics.setColor(unpack(gColors['cyan']))

    local longestWidth = font:getWidth('99. 9999999')
    local longestNumWidth = font:getWidth('99.')
    --[[
        This offset serves as both the distance in between the columns and between the 
        left/right edge of screen and first/last column.
        3 columns, 4 equal spaces
    --]]
    local offset = (VIRTUAL_WIDTH - 3 * longestWidth) / 4

    -- Three columns of 5 scores
    for i = 1, 3 do
        for j = 1, 5 do
            local numText = tostring((i - 1) * 5 + j) .. '.'
            local scoreText = '-'
            if self.highScores[(i - 1) * 5 + j] then
                scoreText = tostring(self.highScores[(i - 1) * 5 + j])
            end
            local text = numText .. ' ' .. scoreText

            --[[
                Line up the numbers so that the dots at the end are all on the same x.
                This is so we don't get something like this:
                    9. <score>
                    10. <score>
                but rather this:
                     9. <score>
                    10. <score>
            --]]
            local numOffset = longestNumWidth - font:getWidth(numText)
            love.graphics.print(
                text,
                offset + (i - 1) * (longestWidth + offset) + numOffset,
                VIRTUAL_HEIGHT / 4 + (j - 1) * (font:getHeight(text) + 4)
            )
        end
    end
end