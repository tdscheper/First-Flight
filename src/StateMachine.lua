--[[
	GD50
	Final Project - Tiny Wings Remake
	StateMachine.lua
	
    This file was provided by Colton Ogden, but author is unknown.

	Updated by Tommy Scheper
    tdscheper@gmail.com
    
    A state machine for our game.
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName])
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

--[[
	For some reason I couldn't get a table to work as the parameter here, so I'm
	just passing two params; that's all I need in this game anyway
--]]
function StateMachine:render(p1, p2)
	self.current:render(p1, p2)
end
