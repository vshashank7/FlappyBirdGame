push = require 'Res/push'


Class = require 'Res/classic'

require 'Bird'
require 'Pipes'
require 'StateMachine'
require 'GameStates/BaseState'
require 'GameStates/PlayState'
require 'GameStates/TitleState'

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

	-- initialise the fonts
	smallFont = love.graphics.newFont('Res/font.ttf', 8)
    mediumFont = love.graphics.newFont('Res/font.ttf', 14)
    flappyFont = love.graphics.newFont('Res/font.ttf', 28)
    hugeFont = love.graphics.newFont('Res/font.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
    }
    gStateMachine:change('title')

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
	if love.keyboard.keyPressed[key] then
		return true
	else
		return false
	end 
end

function love.update(dt)

	-- update x coordinate of images to generate parallex effect
	backgroundImageScroll = (backgroundImageScroll + BACKGROUND_SCROLL_SPEED * dt)%BACKGROUND_LOOPING_POINT
	bottomWallImageScroll = (bottomWallImageScroll + BOTTOM_SCROLL_SPEED * dt) % BOTTOM_LOOPING_POINT

	-- update the game state
	gStateMachine:update(dt)
		
	-- clear after each frame
	love.keyboard.keyPressed = {}
	
end

function love.draw()
	push:apply('start')

	-- render images
	love.graphics.draw(backgroundImage,-1*backgroundImageScroll,0)

	-- render based on Game State
	gStateMachine:render()

	love.graphics.draw(bottomWallImage,-1*bottomWallImageScroll,VIRTUAL_HEIGHT-40)

	push:apply('end')
end