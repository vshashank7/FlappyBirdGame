
Pipes = Class{}

local pipeImage = love.graphics.newImage('Res/pipe.png')

local scrollRate = 60
local gapBetweenPipes = 120

-- dimension of pipe image
PIPE_WIDTH = pipeImage:getWidth()
PIPE_HEIGHT = pipeImage:getHeight()

function Pipes:init(y)
	self.x = VIRTUAL_WIDTH

	--will use this to check if pipe has crossed the bird
	self.crossed = false
	-- will render it on random location within last quarter of the screen height
	self.reversePipe_y = y 
	self.pipe_y = self.reversePipe_y + PIPE_HEIGHT + gapBetweenPipes

end

function Pipes:adjustPosition(dt)
	-- update x coordinate to Render 
	self.x = self.x - scrollRate * dt
end

function Pipes:renderPipes()
	love.graphics.draw(pipeImage,self.x,self.pipe_y)
	--- flip the image on yaxis for reverse
	love.graphics.draw(pipeImage,self.x,self.reversePipe_y + PIPE_HEIGHT,0,1,-1) --- last three params (rotation, xscale , yscale)
end