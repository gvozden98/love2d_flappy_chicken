Pipe = class {}

local PIPE_IMAGE = love.graphics.newImage('newPipe.png')

local PIPE_SCROLL = -60
-- speed at which the pipe should scroll right to left
PIPE_SPEED = 60

-- height of pipe image, globally accessible
PIPE_HEIGHT = 156
PIPE_WIDTH = 32


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0,                                     --rotation
        1,                                     -- x scale
        self.orientation == 'top' and -1 or 1) --y scale
end
