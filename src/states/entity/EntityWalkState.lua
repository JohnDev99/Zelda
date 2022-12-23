EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon

    self.entity:changeAnimation('walk-down')

    --AI
    self.moveDuration = 0
    self.moveTimer = 0
    --Caso player colida com uma parede, nao vai passar a animaçao de walk
    self.bumped = false
end

function EntityWalkState:update(dt)
    --Assumir que nao começaomos a colidir com uma parede
    self.bumped = false

    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkspeed * dt

        if self.entity.x <= MAP_RENDER_OFFSETX + TILE_SIZE then
            self.entity.x = MAP_RENDER_OFFSETX + TILE_SIZE
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkspeed * dt
        --Colisao lado direito com os limites do mapa
        if self.entity.x + self.entity.width >=  VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.entity.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.entity.width
            self.bumped = true--Colidi com uma parede
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkspeed * dt

        if self.entity.y <= MAP_RENDER_OFFSETY + TILE_SIZE - self.entity.height / 2 then
            self.entity.y = MAP_RENDER_OFFSETY + TILE_SIZE - self.entity.height / 2
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkspeed * dt

        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSETY - TILE_SIZE
        
        if self.entity.y + self.entity.height >= bottomEdge then
            self.entity.y = bottomEdge - self.entity.height
            self.bumped = true
        end
    end
end

function EntityWalkState:processAI(params, dt)
    --Comportamento da AI
    local room = params.room
    --Lista de direçoes da AI
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        self.moveDuration = math.random(5)
        --Escolher direçao aletoria da AI
        self.entity.direction = directions[math.random(#directions)]--Tabela indice
        --Mudar para animaçao correspondente a direçao obtida
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.moveTimer > self.moveDuration then
        self.moveTimer = 0--Reset temporizador

        --Chance de parar e entrar em idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            --Escolher outra vez direçao aleatoria
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end
    --Temporizador continua a contar
    self.moveTimer = self.moveTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
    math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end
