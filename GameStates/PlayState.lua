--- game state for playing event

PlayState = Class{__includes = BaseState} --- inheritance

local PIPE_SPAWN_RATE = 3
local gapBetweenPipes = 120

function PlayState:init()
	self.bird = Bird()
	self.pipesList = {}
	self.lastY = -PIPE_HEIGHT + math.random(80) + 30
	self.timer = 0
	self.gameScore = 0
end

function PlayState:update(dt)
	-- increment timer
	self.timer = self.timer + dt

	-- if timer is greater than 2 sec add new pipe to table
	if self.timer > PIPE_SPAWN_RATE then
		local y = math.max(-PIPE_HEIGHT + 15, 
                math.min(self.lastY + math.random(-30, 30), VIRTUAL_HEIGHT - gapBetweenPipes - PIPE_HEIGHT))
        self.lastY = y
		table.insert(self.pipesList,Pipes(y))
		self.timer = 0
	end

	-- Update Position of Bird
	self.bird:adjustPosition(dt)

	---- check if bird hits the floor
	if self.bird.y >= VIRTUAL_HEIGHT - 20 then
    	gStateMachine:change('score',self.gameScore)
	end

	-- update position of each pipe in table
	for key, pipe in pairs(self.pipesList) do
		pipe:adjustPosition(dt)

		---- check collision of bird with the pipe
		if self.bird:collide(pipe) then
			gStateMachine:change('score',self.gameScore)
			break
		end

		if self.bird:crossedPipe(pipe) then
			if not pipe.crossed then 
				self.gameScore = self.gameScore + 1
				pipe.crossed = true
			end
		end
		

		-- if pipe has scrolled the complete screen delete it  
		if pipe.x < -PIPE_WIDTH then
			table.remove(self.pipesList,key)
		end
	end
end

function PlayState:render()
	-- render all pipes in table
	for key, pipe in pairs(self.pipesList) do
		pipe:renderPipes()
	end

	love.graphics.setFont(mediumFont)
	love.graphics.print('Score : '..tostring(self.gameScore),10,10)
	-- render Bird
	self.bird:renderBird()
end