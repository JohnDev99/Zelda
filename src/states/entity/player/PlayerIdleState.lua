PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    self.entity.offsetX = 0
    self.entity.offsetY = 5
end

function PlayerIdleState:update(dt)
    --Se alguma tecla de movimento estiver a ser pressionada alterar estado do player
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    --Se primir espaço, mudar para o estado de atacar
    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end
