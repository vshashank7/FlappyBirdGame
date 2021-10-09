WaitingState = Class{__includes = BaseState} --- inheritance

COUNTDOWN_TIME = 0.75 --- 0.75 sec waiting before reducing counter
function WaitingState:init()
	self.counter = 3
	self.timer = 0
end

function WaitingState:update(dt)
	self.timer = self.timer + dt

	if self.timer >= COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.counter = self.counter - 1
	end
	if self.counter == 0 then
		gStateMachine:change('play')
	end
end

function WaitingState:render()
	love.graphics.setFont(hugeFont)
    love.graphics.printf('Game Will Start In ' ..tostring(self.counter), 0, 100, VIRTUAL_WIDTH, 'center')
end