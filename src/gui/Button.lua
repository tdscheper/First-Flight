--[[
    GD50
    Final Project - Tiny Wings Remake
    Button.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    A simple rectangular button with rounded edges and centered text.
]]

Button = Class{}

function Button:init(def)
    self.font = def.font
    self.fontColor = def.fontColor
    -- string of text displayed
    self.text = def.text

    -- color of the button (not text)
    self.color = def.color

    self.translateX = def.translateX or 0
    -- central point of button/text
    self.x = -self.translateX + def.x
    self.y = def.y

    -- margins between centered text and button
    self.xMargin = def.xMargin or 0
    self.yMargin = def.yMargin or 0

    -- width and height of button is determined by the text and margins
    self.width = self.font:getWidth(self.text) + 2 * self.xMargin
    self.height = self.font:getHeight(self.text) + 2 * self.yMargin

    -- top left point of button
    self.adjX = self.x - self.width / 2
    self.adjY = self.y - self.height / 2

    -- function called when button is pressed
    self.onPress = def.onPress
end

-- checks if mouse cursor is hovering over the button
function Button:isBeingHoveredOver()
    if gMouseX == nil or gMouseY == nil then return false end

    local adjMouseX = -self.translateX + gMouseX

    return not (
           (adjMouseX < self.adjX or adjMouseX > self.adjX + self.width)
        or (gMouseY < self.adjY or gMouseY > self.adjY + self.height)
    )
end

-- checks if the button has been clicked (or tapped)
function Button:wasClicked()
    return self:isBeingHoveredOver() and love.mouse.wasPressed(1)
end

function Button:render(highlightColor)
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle(
        'fill',
        self.adjX,
        self.adjY,
        self.width,
        self.height,
        10, 10 -- rounded edges
    )

    love.graphics.setFont(self.font)
    love.graphics.setColor(
        unpack(highlightColor or self.fontColor)
    )
    love.graphics.print(
        self.text,
        self.adjX + self.xMargin,
        self.adjY + self.yMargin
    )
end