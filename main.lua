--[[
    GD50 2020
    Final Project - Tiny Wings Remake
    main.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    "Tiny Wings" is an iOS app created by Andreas Illiger which made its debut on the App 
    Store in 2011. It surged to the top of the App Store charts when Apple featured the 
    app in one of its Keynotes. In the game, the user controls a bird's flight, which is 
    determined by how well the user utilizes the hills to launch the bird into the air. 
    The game is a race against time, as it ends when the sun sets in the game.
]]

require 'src/Dependencies'

function love.load()
    love.window.setTitle('First Flight')
    math.randomseed(os.time())

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['high-score'] = function() return HighScoreState() end
    }
    
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.update(dt)
    gMouseX, gMouseY = Push:toGame(love.mouse.getPosition())

    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.draw()
    Push:start()
    gStateMachine:render()
    Push:finish()
end

function loadHighScores()
    love.filesystem.setIdentity('first_flight')

    -- if file doesn't exist, create it (empty)
    if not love.filesystem.exists('first_flight.lst') then
        love.filesystem.write('first_flight.lst', '')
    end

    -- iterate over each line of file
    local highScores = {}
    for line in love.filesystem.lines('first_flight.lst') do
        table.insert(highScores, tonumber(line))
    end

    return highScores
end