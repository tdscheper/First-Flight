--[[
    GD50
    Final Project - Tiny Wings Remake
    hill_defs.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    Shapes of the hills.
]]

--[[
    'shift' is the phase shift of the sine function which will be used to shape the hills. 
    This shift allows for each hill to smoothly transition to a new hill which may be 
    shaped by a new sine function
--]]
HILL_DEFS = {
    ['standard-standard'] = {
        width = STANDARD_HILL_WIDTH,
        height = STANDARD_HILL_HEIGHT,
        shift = 0
    },
    ['skinny-standard'] = {
        width = STANDARD_HILL_WIDTH / 2,
        height = STANDARD_HILL_HEIGHT,
        shift = -3 * math.pi / 2
    },
    ['wide-standard'] = {
        width = STANDARD_HILL_WIDTH * 2,
        height = STANDARD_HILL_HEIGHT,
        shift = 3 * math.pi / 4
    },
    ['standard-tall'] = {
        width = STANDARD_HILL_WIDTH,
        height = STANDARD_HILL_HEIGHT * (4 / 3),
        shift = 0
    },
    ['skinny-tall'] = {
        width = STANDARD_HILL_WIDTH / 2,
        height = STANDARD_HILL_HEIGHT * (4 / 3),
        shift = -3 * math.pi / 2
    },
    ['wide-tall'] = {
        width = STANDARD_HILL_WIDTH * 2,
        height = STANDARD_HILL_HEIGHT * (4 / 3),
        shift = 3 * math.pi / 4
    },
    ['standard-short'] = {
        width = STANDARD_HILL_WIDTH,
        height = STANDARD_HILL_HEIGHT / 2,
        shift = 0
    },
    ['skinny-short'] = {
        width = STANDARD_HILL_WIDTH / 2,
        height = STANDARD_HILL_HEIGHT / 2,
        shift = -3 * math.pi / 2
    },
    ['wide-short'] = {
        width = STANDARD_HILL_WIDTH * 2,
        height = STANDARD_HILL_HEIGHT / 2,
        shift = 3 * math.pi / 4
    }
}