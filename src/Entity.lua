Entity = Class{}

function Entity:init(def)--def vai ser o GameObject
    self.direction = 'down'
    self.animations = self:createAnimations(def.animations)
    --Dimensoes
    self.x = def.x 
    self.y = def.y 
    self.width = def.width
    self.height = def.height
    --Offsets
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkspeed = def.walkspeed
    self.health = def.health

    self.invunerable = false 
    self.invunerableDuration = 0
    self.invunerableTimer = 0

    self.flashTimer = 0
    self.dead = false
end

function Entity:createAnimations(animations)
    local animationsToReturn = {}

    --Classe de animaçao
    for k, animationDef in pairs(animations) do
        animationsToReturn[k] = Animation{
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end
    return animationsToReturn
end

--Detetar colisoes
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

--Diminuir vida da entidade
function Entity:damage(dmg)
    self.health = self.health - dmg
end
--Mudar para estado de invunerabel
function Entity:goInvulnerable(duration)
    self.invunerable = true
    self.invunerableDuration = duration
end

function Entity:changeState(state)
    self.stateMachine:change(state)
end

function Entity:changeAnimation(animation)
    self.currentAnimation = self.animations[animation]
end

function Entity:update(dt)
    if self.invunerable then
        self.flashTimer = self.flashTimer + dt
        self.invunerableTimer = self.invunerableTimer + dt
        if self.invunerableTimer > self.invunerableDuration then
            self.invunerable = false
            self.invunerableTimer = 0
            self.invunerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    if self.invunerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end
