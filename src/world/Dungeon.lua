Dungeon = Class{}

function Dungeon:init(player)
    self.player = player

    self.rooms = {}--Desnecessario neste caso, em que so existe um mapa
    self.currentRoom = Room(self.player)--Mapa atual é o que o player se encontra
    self.nextRoom = nil

    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    --Eventos acionados quando o player transita para outro mapa
    Event.on('shift-left', function()
        --Metodo para iniciar transiçao
        self:beginShifting(-VIRTUAL_WIDTH, 0)
    end)
    Event.on('shift-right', function()
        self:beginShifting(VIRTUAL_WIDTH, 0)
    end)
    Event.on('shift-up', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT)
    end)
    Event.on('shift-down', function()
        self:beginShifting(0, VIRTUAL_HEIGHT)
    end)
end

function Dungeon:beginShifting(shiftX, shiftY)
    --Iniciar transiçao
    self.shifting = true
    self.nextRoom = Room(self.player)

    --Portas abertas ate finalizar transiçao do player entre mapas
    for k, doorway in pairs(self.nextRoom.doorways) do
        doorway.open = true
    end

    --Indicar direçao da minha transiçao
    self.nextRoom.adjacentOffsetX = shiftX
    self.nextRoom.adjacentOffsetY = shiftY

    --Mover o personagem para fora da porta
    local playerX, playerY = self.player.x, self.player.y

    --Defenir qual sera a posiçao do player(x, y) apos passar as portas para o proximo mapa
    if shiftX > 0 then
        playerX = VIRTUAL_WIDTH + (MAP_RENDER_OFFSETX + TILE_SIZE)
    elseif shiftX < 0 then
        playerX = -VIRTUAL_WIDTH + (MAP_RENDER_OFFSETX + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width)
    elseif shiftY > 0 then
        playerY = VIRTUAL_HEIGHT + (MAP_RENDER_OFFSETY + self.player.height / 2)
    else
        playerY = -VIRTUAL_HEIGHT + MAP_RENDER_OFFSETY + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
    end

    --Tween entre posiçoes
    --Mover player para nova posiçao , que vai ser a oposta a da porta
    Timer.tween(1, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()
        self:finishShifting()
        
        if shiftX < 0 then
            self.player.x = MAP_RENDER_OFFSETX + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width
            self.player.direction = 'left'
        elseif shiftX > 0 then
            self.player.x = MAP_RENDER_OFFSETX + TILE_SIZE
            self.player.direction = 'right'
        elseif shiftY < 0 then
            self.player.y = MAP_RENDER_OFFSETY + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
            self.player.direction = 'up'
        else
            self.player.y = MAP_RENDER_OFFSETY + self.player.height / 2
            self.player.direction = 'down'
        end

        --Apos player passar da porta, fechar todas as portas 
        for k, doorway in pairs(self.currentRoom.doorways) do
            doorway.open = false
        end
        gSounds['door']:play()
    end)
end

--Reset- todas as variaveis responsaveis pela transiçao de mapa
function Dungeon:finishShifting()
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    self.currentRoom = self.nextRoom
    self.nextRoom = nil

    self.currentRoom.adjacentOffsetX = 0
    self.currentRoom.adjacentOffsetY = 0
end

function Dungeon:update(dt)
    --continuar a atualizar caso nao esteja a mudar de mapa
    if not self.shifting then
        self.currentRoom:update(dt)
    else
        --Player continua a caminhar apos passar porta
        self.player.currentAnimation:update(dt)
    end
end

function Dungeon:render()
    --Passar graficamente de um mapa para outro
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    self.currentRoom:render()

    --Renderizar outro mapa enquanto transito pela porta
    if self.nextRoom then
        self.nextRoom:render()
    end
end