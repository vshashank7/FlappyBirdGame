---- starting screen of the game

TitleState = Class{__includes = BaseState} --- inheritance

function TitleState:update(dt)
    if love.keyboard.wasKeyPressed('enter') or love.keyboard.wasKeyPressed('return') then
        gStateMachine:change('waiting')
    end
end

function TitleState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Start the Game', 0, 100, VIRTUAL_WIDTH, 'center')
end