--- state to represt the score

ScoreState = Class{__includes = BaseState} --- inheritance

function ScoreState:enter(params)
    self.score = params
end

function ScoreState:update(dt)
	if love.keyboard.wasKeyPressed('enter') or love.keyboard.wasKeyPressed('return') then
        gStateMachine:change('waiting')
    end
end

function ScoreState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Game Over', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
    love.graphics.printf('Your Score : ' ..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Play Again!!', 0, 200, VIRTUAL_WIDTH, 'center')
end