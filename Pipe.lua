Pipe = class {}

local PIPE_IMAGE = love.graphics.newImage('newPipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_HEIGHT - 40)
    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end