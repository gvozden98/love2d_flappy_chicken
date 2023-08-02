Bird = class {}

local gravity = 10

function Bird:init()
    self.image = love.graphics.newImage('sprites/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0;
end

function Bird:update(dt)
    self.dy = self.dy + gravity * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -3
        sounds['jump']:setVolume(0.5)
        sounds["jump"]:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    --AABB collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 4 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 4 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end
    return false
end

function Bird:collidesWithGround()
    if (self.y + 2) + (self.height - 4) >= (VIRTUAL_HEIGHT - ground:getHeight() + 2) then
        return true
    else
        return false
    end
end

function Bird:collidesWithSky()
    if (self.y + 2) + (self.height - 4) <= -32 then
        return true
    else
        return false
    end
end

function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0;
end
