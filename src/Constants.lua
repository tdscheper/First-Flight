--[[
    GD50
    Final Project - Tiny Wings Remake
    Constants.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    Some global constants for our game.
]]

-- window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- gravity for our physics world
GRAVITY = 175

-- cloud dimensions
CLOUD_WIDTH = 47
CLOUD_HEIGHT = 27
-- clouds' y-position
CLOUD_Y = -CLOUD_HEIGHT / 3

SNOWFLAKE_RADIUS = 2
-- how far apart each snowflake should be, both vertically and horizontally
SNOW_OFFSET = 50
-- speed at which snow moves down vertically
SNOWFALL_SPEED = 10

-- dimensions of each rectangle used to create the hills
GROUND_PIECE_WIDTH = 2
GROUND_PIECE_HEIGHT = 256
-- standard size hill dimensions
STANDARD_HILL_WIDTH = VIRTUAL_WIDTH / 2
STANDARD_HILL_HEIGHT = 60
-- margin between lowest point of hill and VIRTUAL_HEIGHT
GROUND_MARGIN = 16
--[[
    Number of hills to be generated at once.
    Note: skinny hills spawn two at a time, so even if this equals 6, 11
    hills could spawn (first always regular, rest skinny)
--]]
NUM_HILLS_GEN = 6

-- penguin frames we're using
PENGUIN_WAVE_FRAMES = {42, 43}
PENGUIN_SLIDE_FRAME = 28
PENGUIN_SIT_FRAME = 39
-- penguin dimensions
PENGUIN_WIDTH = 32
PENGUIN_HEIGHT = 32
--[[
    Dimensions of sliding penguin image
    Much of the image is just transparent space, so I found a more accurate 
    width/height than what would come from getWidth()/getHeight()
--]]
SLIDING_PENGUIN_WIDTH = 24
SLIDING_PENGUIN_HEIGHT = 12
-- Penguin's start position so that it rests on the first hilltop
PENGUIN_START_X = 49
PENGUIN_START_Y = VIRTUAL_HEIGHT - GROUND_MARGIN - STANDARD_HILL_HEIGHT - PENGUIN_HEIGHT
-- max/min velocities for our penguin
MAX_VX = 400
MIN_VX = 30

-- orb dimensions
ORB_WIDTH = 16
ORB_HEIGHT = 16

-- sun dimensions
SUN_WIDTH = 11
SUN_HEIGHT = 11
-- moon dimensions
MOON_WIDTH = 11
MOON_HEIGHT = 11

--- slider dimensions
SLIDER_WIDTH = 7
SLIDER_HEIGHT = 13

-- what we want to initialize our game timer at
START_TIME = 100