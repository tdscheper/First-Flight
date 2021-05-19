--[[
	GD50
    Final Project - Tiny Wings Remake
    Util.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

	Helper functions.
]]

-- returns minimum value in table of numbers
function getMin(nums)
    local min = nums[1]
    for i = 2, #nums do
        min = math.min(min, nums[i])
    end

    return min
end

-- returns maximum value and its index in table of numbers
function getMaxValAndIndex(nums)
    local index = 1
    local max = nums[1]
    for i = 1, #nums do
        if nums[i] > max then
            index = i
            max = nums[i]
        end
    end

    return max, index
end

-- sorts table of numbers so that it goes from max to min
function sortTable(nums)
    local sortedTable = {}

    local reducedNums = nums
    for i = 1, #nums do
        local max, index = getMaxValAndIndex(reducedNums)
        table.insert(sortedTable, max)
        table.remove(reducedNums, index)
    end

    return sortedTable
end

-- Converts amount of seconds into time string. Ex: 74 -> '1 min 14 sec'
function timeToString(seconds)
    local mins = nil
    local secs = nil

    if seconds < 60 then
        return tostring(seconds) .. ' sec'
    end

    mins = math.floor(seconds / 60)
    secs = seconds - mins * 60
    
    mins = tostring(mins) .. ' min'
    if secs == 0 then 
        secs = ''
    else
        secs = tostring(secs) .. ' sec'
    end

    return mins .. ' ' .. secs
end

-- expanded sine function
function sine(x, a, b, c, d)
    return a * math.sin(b * x + c) + d
end

function getHillYAt(x, width, height, shift, margin)
    return VIRTUAL_HEIGHT - 
        sine(x, height / 2, 2 * math.pi / width, shift, height / 2 + margin)
end

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
    Credit: Colton Ogden
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end