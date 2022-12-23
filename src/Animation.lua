Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.looping = def.looping or true --true(padrao)
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    if not self.looping and self.timesPlayed > 0 then
        return
    end

    --se existir mais do que um frame 
    if #self.frames > 1 then
        --
        self.timer = self.timer + dt--começar a contar
        if self.timer > self.interval then--se passar do limite de tempo
            self.timer = self.timer % self.interval--fazer resto de divisao igual a 0
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))--resto de diviao 1
            if self.currentFrame == 1 then--se voltarmos ao primeiro frame
                self.timesPlayed = self.timesPlayed + 1--um loop completo
            end
        end
    end
end

--Metodo para obter frame atual
function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end
