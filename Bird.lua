
Bird = Class{}

function Bird:init()
	-- image of the bird
	self.birdImage = love.graphics.newImage('Res/bird.png')
	
	-- dimension of bird image
	self.width = self.birdImage:getWidth()
	self.height = self.birdImage:getHeight()

	--coordinate of bird image (Center of screen)
	self.x = VIRTUAL_WIDTH/2 - self.width/2
	self.y = VIRTUAL_HEIGHT/2 - self.height/2

	self.deltaY = 0
	self.GRAVITY_RATE = 8
	self.ANTI_GRAVITY_RATE = 3
end

function Bird:adjustPosition(dt)
	-- update delta Y to generate free fall effect
	self.deltaY = self.deltaY + self.GRAVITY_RATE * dt

	-- on space jump 
	if love.keyboard.wasKeyPressed('space') == true then
		if self.y >= 0 then
			self.deltaY = self.deltaY - self.ANTI_GRAVITY_RATE
		end
	end

	-- update Y coordinate to Render 
	self.y = self.y + self.deltaY
end

function Bird:renderBird()
	love.graphics.draw(self.birdImage,self.x,self.y)
end

function Bird:collide(pipe)
	if (self.x + 4) + (self.width - 8) >= pipe.x and (self.x + 4) <= pipe.x + PIPE_WIDTH then
		if ((self.y + 4) + (self.height - 8) >= pipe.reversePipe_y and (self.y + 4) <= pipe.reversePipe_y + PIPE_HEIGHT) or 
			((self.y + 4) + (self.height - 8) >= pipe.pipe_y and (self.y + 4) <= pipe.pipe_y + PIPE_HEIGHT) then
			return true
		end
	end

	return false
end

function Bird:crossedPipe(pipe)
	if (self.x + 2) >= pipe.x + PIPE_WIDTH then
		return true
	end
	return false
end