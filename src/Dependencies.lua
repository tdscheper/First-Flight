--[[
    GD50
    Final Project - Tiny Wings Remake
    Dependencies.lua

    Author: Tommy Scheper
    tdscheper@gmail.com
]]

-- https://github.com/Ulydev/push
Push = require 'lib/push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'
-- https://github.com/airstruck/knife
Timer = require 'lib/knife.timer'

require 'src/Util'
require 'src/Constants'
require 'src/StateMachine'
require 'src/Animation'
require 'src/Object'
require 'src/world/Snowflake'
require 'src/world/Cloud'
require 'src/world/Background'
require 'src/world/GroundPiece'
require 'src/world/hill_defs'
require 'src/world/Hill'
require 'src/world/Terrain'
require 'src/gui/Button'
require 'src/gui/DaylightBar'
require 'src/Penguin'
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/game/GameOverState'
require 'src/states/game/HighScoreState'
require 'src/states/penguin/PenguinWavingState'
require 'src/states/penguin/PenguinSlidingState'
require 'src/states/penguin/PenguinSittingState'

love.graphics.setDefaultFilter('nearest', 'nearest')

gFonts = {
    ['retro-small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['retro-medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['retro-large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['retro-huge'] = love.graphics.newFont('fonts/font.ttf', 64),
    ['small'] = love.graphics.newFont('fonts/dernier/Dernier.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/dernier/Dernier.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/dernier/Dernier.ttf', 32),
    ['huge'] = love.graphics.newFont('fonts/dernier/Dernier.ttf', 64),
    ['italic-small'] = love.graphics.newFont('fonts/dernier/Dernier_Italic.ttf', 8),
    ['italic-medium'] = love.graphics.newFont('fonts/dernier/Dernier_Italic.ttf', 16),
    ['italic-large'] = love.graphics.newFont('fonts/dernier/Dernier_Italic.ttf', 32),
    ['italic-huge'] = love.graphics.newFont('fonts/dernier/Dernier_Italic.ttf', 64)
}

gTextures = {
    ['penguins'] = love.graphics.newImage('graphics/penguins.png'),
    ['symbols'] = love.graphics.newImage('graphics/boxsym.png')
}

gQuads = {
    ['penguins'] = GenerateQuads(gTextures['penguins'], 32, 32),
    ['symbols'] = GenerateQuads(gTextures['symbols'], 16, 16)
}

gImages = {
    ['sky'] = love.graphics.newImage('graphics/sky.png'),
    ['cloud'] = love.graphics.newImage('graphics/cloud.png'),
    ['sliding-penguin'] = love.graphics.newImage('graphics/penguin.png'),
    ['orb'] = love.graphics.newImage('graphics/orb.png'),
    ['sun'] = love.graphics.newImage('graphics/yellow_sun.png'),
    ['moon'] = love.graphics.newImage('graphics/blue_moon.png'),
    ['slider'] = love.graphics.newImage('graphics/slider.png')
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'stream'),
    ['slide'] = love.audio.newSource('sounds/slide.wav', 'stream'),
    ['squeak'] = love.audio.newSource('sounds/bird_squeak.wav', 'stream'),
    ['orb-consume'] = love.audio.newSource('sounds/orb_consume.wav', 'stream')
}

-- Before LOVE2D version 11
gColors = {
    ['white'] = {252, 252, 255},
    ['cyan'] = {3, 252, 240},
    ['sun-yellow'] = {253, 225, 130},
    ['moon-blue'] = {37, 88, 124},
    ['transparent'] = {0, 0, 0, 0}
}

--[[
-- LOVE2D 11
gColors = {
    ['white'] = {252/255, 252/255, 255/255},
    ['cyan'] = {3/255, 252/255, 240/255},
    ['sun-yellow'] = {253/255, 225/255, 130/255},
    ['moon-blue'] = {37/255, 88/255, 124/255},
    ['transparent'] = {0, 0, 0, 0}
}
]]