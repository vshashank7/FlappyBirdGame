push = require 'Res/push'


Class = require 'Res/classic'

require 'Bird'
require 'Pipes'

-- constants

WINDOW_WIDTH = 960
WINDOW_HEIGHT = 570

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

-- speed of parallex effect
BACKGROUND_SCROLL_SPEED = 30
BOTTOM_SCROLL_SPEED = 60

-- iteration point
BACKGROUND_LOOPING_POINT = VIRTUAL_WIDTH + 60
BOTTOM_LOOPING_POINT = VIRTUAL_WIDTH + 57

-- x coordinate of image
local bottomWallImageScroll = 0
local backgroundImageScroll = 0

--love.graphics.newImage(file Path)
local backgroundImage = love.graphics.newImage('Res/background.jpg')
local bottomWallImage = love.graphics.newImage('Res/bottomWall.jpg')

local pipesList = {}

-- keeps track of when to spawn a new pipe
local timer = 0
local PIPE_SPAWN_RATE = 3
local lastY = -PIPE_HEIGHT + math.random(80) + 30
local gapBetweenPipes = 120
local isGameOn = true
local gameScore = 0

function love.load()
	love.graphics.setDefaultFilter('nearest','nearest')

	love.window.setTitle('Flappy Bird Game')

	math.randomseed(os.time())

	--track the status of game
	status = 'started'

	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	bird = Bird()

	-- creating the empty table to keep track of which key was pressed in last frame
	love.keyboard.keyPressed = {}
end

function love.resize(width,height)
	push:resize(width,height)
end

function love.keypressed(key)
	-- store detail of key pressed
	love.keyboard.keyPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

-- method to check if key was pressed in last frame
function love.keyboard.wasKeyPressed(key)
	return love.keyboard.keyPressed[key]
end

function love.update(dt)

	if isGameOn then
		-- update x coordinate of images to generate parallex effect
		backgroundImageScroll = (backgroundImageScroll + BACKGROUND_SCROLL_SPEED * dt)%BACKGROUND_LOOPING_POINT
		bottomWallImageScroll = (bottomWallImageScroll + BOTTOM_SCROLL_SPEED * dt) % BOTTOM_LOOPING_POINT

		-- increment timer
		timer = timer + dt

		-- if timer is greater than 2 sec add new pipe to table
		if timer > PIPE_SPAWN_RATE then
			local y = math.max(-PIPE_HEIGHT + 15, 
	                math.min(lastY + math.random(-30, 30), VIRTUAL_HEIGHT - gapBetweenPipes - PIPE_HEIGHT))
	        lastY = y
			table.insert(pipesList,Pipes(y))
			timer = 0
		end

		-- Update Position of Bird
		bird:adjustPosition(dt)

		-- update position of each pipe in table
		for key, pipe in pairs(pipesList) do
			pipe:adjustPosition(dt)

			if bird:collide(pipe) then
				isGameOn = false
				break
			end

			if bird:crossedPipe(pipe) then
				if not pipe.crossed then 
					gameScore = gameScore + 1
					pipe.crossed = true
				end
			end
			

			-- if pipe has scrolled the complete screen delete it  
			if pipe.x < -PIPE_WIDTH then
				table.remove(pipesList,key)
			end
		end

	end
	-- clear after each frame
	love.keyboard.keyPressed = {}
	
end

function love.draw()
	push:apply('start')
		-- render images
		love.graphics.draw(backgroundImage,-1*backgroundImageScroll,0)
		love.graphics.print('Score : '..tostring(gameScore),VIRTUAL_WIDTH - 100,100)

		-- render all pipes in table
		for key, pipe in pairs(pipesList) do
			pipe:renderPipes()
		end

		love.graphics.draw(bottomWallImage,-1*bottomWallImageScroll,VIRTUAL_HEIGHT-40)

		-- render Bird
		bird:renderBird()
	push:apply('end')
end