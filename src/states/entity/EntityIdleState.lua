EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
    --Animaçao Idle da entidade
    self.entity:changeAnimation('idle-' .. self.entity.direction)

    --AI
    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then --Se o meu tempo de duraçao nao tiver sido alterado ou 0
        self.waitDuration = math.random(5)--O meu tempo de Idle vai ser entre 1 a 5 segundos
    else
        self.waitTimer = self.waitTimer + dt--Caso o meu tempo de duraçao for diferente de 0

        if self.waitTimer > self.waitDuration then--se o meu tempo de espera em Idle passar da sua duraçao
            self.entity:changeState('walk')--Mudar para outro estado
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation--Variavel que vai armazenar o frame atual

    --Dados da entidade passada no construtor
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
    math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end