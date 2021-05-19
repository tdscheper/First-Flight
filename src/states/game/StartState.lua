--[[
	GD50
    Final Project - Tiny Wings Remake
    StartState.lua
    
    Author: Tommy Scheper
    tdscheper@gmail.com
	
	Screen giving option to start the game or view high scores.
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self:createButtons()
    self.buttons[1].highlight = true

    Timer.clear()
    self.timer = 0
    Timer.every(0.35, function()
        self.timer = self.timer + 1
    end)
end

function StartState:enter(def)
    if def == nil then def = {} end

    self.world = def.world or love.physics.newWorld(0, GRAVITY)
    self.background = def.background or Background()
    self.terrain = def.terrain or Terrain(self.world, 1)
    self.penguin = def.penguin or Penguin {
        world = self.world,
        x = PENGUIN_START_X,
        y = PENGUIN_START_Y,
        state = 'wave'
    }

    -- ensure the penguin is waving if coming from different state
    self.penguin.stateMachine:change('wave', self.penguin)
end

-- create play button and high scores button
function StartState:createButtons()
    self.buttons = {}

    --[[
        These buttons will be the same, just with different text, y-placement, and 
        behavior after being pressed
    --]]
    for i = 1, 2 do
        table.insert(self.buttons, Button {
            font = gFonts['large'],
            fontColor = gColors['white'],
            text = i == 1 and 'PLAY' or 'HIGH SCORES',
            x = VIRTUAL_WIDTH / 2,
            y = VIRTUAL_HEIGHT / 3 + 30 + (i == 1 and 0 or self.buttons[1].height + 2),
            xMargin = 2,
            yMargin = 2,
            color = gColors['transparent'],
            onPress = function()
                gStateMachine:change(i == 1 and 'play' or 'high-score', {
                    background = self.background,
                    world = self.world,
                    terrain = self.terrain,
                    penguin = self.penguin
                })
            end
        })
    end
end

function StartState:update(dt)
    self.background:update(dt)
    self.penguin:update(dt)

    if self.buttons[1]:isBeingHoveredOver() then
        self.buttons[1].highlight = true
        self.buttons[2].highlight = false
    elseif self.buttons[2]:isBeingHoveredOver() then
        self.buttons[2].highlight = true
        self.buttons[1].highlight = false
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('up') then
        self.buttons[1].highlight = not self.buttons[1].highlight
        self.buttons[2].highlight = not self.buttons[2].highlight
        self.timer = 0
    end

    for i, button in ipairs(self.buttons) do
        if    (button.highlight and love.keyboard.wasPressed('return')) 
           or button:wasClicked() then
            button.onPress()
        end
    end
end

function StartState:render()
    self.background:render()
    self.terrain:render()
    self.penguin:render()

    for i, button in ipairs(self.buttons) do
        -- flash the highlight if there is one. 
        -- Always keep it highlighted if its being hovered over, though
        local highlight = false
        if button.highlight and (button:isBeingHoveredOver() or self.timer % 2 == 0) then
            highlight = true
        end
        button:render(highlight and gColors['cyan'])
    end

    local font = gFonts['italic-huge']
    love.graphics.setFont(font)
    love.graphics.setColor(unpack(gColors['cyan']))
    local text = 'FIRST FLIGHT'
    love.graphics.print(
        text,
        VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2,
        VIRTUAL_HEIGHT / 4 - font:getHeight(text) / 2
    )
end