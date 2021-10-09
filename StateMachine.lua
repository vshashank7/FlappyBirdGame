StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}

	self.states = states or {}
	self.currentState = self.empty
end

function StateMachine:change(stateName,params)
	----- check if the state exist or not
	assert(self.states[stateName])

	----- exist the current state and move to the new state
	self.currentState:exit()
	self.currentState = self.states[stateName]()
	self.currentState:enter(params)
end

function StateMachine:update(dt)
	self.currentState:update(dt)
end

function StateMachine:render()
	self.currentState:render()
end