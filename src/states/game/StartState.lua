StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    --Iniciar estado de jogo
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()
    --Ecra inicial 
    --Escalar em todo o meu ecra
    love.graphics.draw(gTextures['background'], 0, 0, 0,
    VIRTUAL_WIDTH / gTextures['background']:getWidth(),
    VIRTUAL_HEIGHT / gTextures['background']:getHeight())
    
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Legend of Link', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('Legend of Link', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 - 64, VIRTUAL_WIDTH, 'center')
end