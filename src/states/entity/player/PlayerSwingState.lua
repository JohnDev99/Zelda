PlayerSwingState = Class{__includes = BaseState}

function PlayerSwingState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.player.offsetY = 5
    self.player.offsetX = 8

    --Criar uma zona de colisao dependendo da minha direçao
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth--Ponto inicial lado esquerdo
        hitboxY = self.player.y + 2--2pixeis acima do player
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x 
        hitboxY = self.player.y + self.player.height
    end

    --Hitbox so sera ativa quando jogador pressionar tecla de ataque
    self.swordHitBox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    
    self.player:changeAnimation('sword-' .. self.player.direction)
end

function PlayerSwingState:enter(params)
    --Sempre que pressionar tecla de ataque vou acionar
    gSounds['sword']:stop()
    gSounds['sword']:play()
    self.player.currentAnimation:refresh()
end

function PlayerSwingState:update(dt)
    --Vereficar se hitbox colidi com alguma entidade
    for k, entity in pairs(self.dungeon.currentRoom.entities) do
        if entity:collides(self.swordHitBox) then
            entity:damage(1)
            gSounds['hit-enemy']:play()
        end
    end

    --Se parei vou mudar a minha estado para Idle
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    --Atacar se primir espaço
    if love.keyboard.wasPressed('space') then
        self.player:changeState('swing-sword')
    end
end

function PlayerSwingState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], 
    math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

        --
    -- debug for player and hurtbox collision rects VV
    --

    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.swordHitBox.x, self.swordHitBox.y,
        self.swordHitBox.width, self.swordHitBox.height)
    love.graphics.setColor(255, 255, 255, 255)
end
