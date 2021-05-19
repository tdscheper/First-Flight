--[[
    GD50
    Final Project - Tiny Wings Remake
    DaylightBar.lua

    Author: Tommy Scheper
    tdscheper@gmail.com

    A bar that shows how much daylight is left in the game before it gets too dark and
    ends the game.
]]

DaylightBar = Class{}

function DaylightBar:init()
    self.bar = {}
    self.bar.width = VIRTUAL_WIDTH * 2/3
    self.bar.height = 2
    self.bar.x = VIRTUAL_WIDTH / 6
    self.bar.y = VIRTUAL_HEIGHT - GROUND_MARGIN / 2 - self.bar.height / 2

    self.slider = {}
    self.slider.image = gImages['slider']
    self.slider.width = SLIDER_WIDTH
    self.slider.height = SLIDER_HEIGHT
    self.slider.x = self.bar.x - self.slider.width / 2
    self.slider.y = self.bar.y + self.bar.height / 2 - self.slider.height / 2

    self.sun = {}
    self.sun.image = gImages['sun']
    self.sun.width = SUN_WIDTH
    self.sun.height = SUN_HEIGHT
    
    self.moon = {}
    self.moon.image = gImages['moon']
    self.moon.width = MOON_WIDTH
    self.moon.height = MOON_HEIGHT

    self.translateX = 0
end

function DaylightBar:update(dt, translateX, current, max)
    self.translateX = translateX or self.translateX

    self.bar.x = -self.translateX + VIRTUAL_WIDTH / 6

    -- move the slider in correspondence with the time and keep it on the bar
    self.slider.x = math.max(
        self.bar.x - self.slider.width / 2,
        math.min(
            self.bar.x + self.bar.width - self.slider.width / 2,
            self.bar.x - self.slider.width / 2 + ((max - current) / max) 
                * self.bar.width
        )
    )
end

function DaylightBar:render()
    love.graphics.draw(
        self.sun.image,
        self.bar.x - self.sun.width - 4,
        self.bar.y + self.bar.height / 2 - self.sun.height / 2
    )

    love.graphics.draw(
        self.moon.image,
        self.bar.x + self.bar.width + 4,
        self.bar.y + self.bar.height / 2 - self.moon.height / 2
    )

    -- draw moon blue part of bar before the slider
    love.graphics.setColor(unpack(gColors['moon-blue']))
    love.graphics.rectangle(
        'fill',
        self.bar.x,
        self.bar.y,
        self.slider.x + self.slider.width / 2 - self.bar.x,
        self.bar.height
    )
    -- draw sun yellow part of bar after the slider
    love.graphics.setColor(unpack(gColors['sun-yellow']))
    love.graphics.rectangle(
        'fill',
        self.slider.x + self.slider.width / 2,
        self.bar.y,
        self.bar.x + self.bar.width - self.slider.x - self.slider.width / 2,
        self.bar.height
    )
    -- reset color
    love.graphics.setColor(unpack(gColors['white']))

    -- draw slider on top of bar
    love.graphics.draw(self.slider.image, self.slider.x, self.slider.y)
end