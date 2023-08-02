_G.love = require("love")
local push = require 'push'
require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 512

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 256

local groundScroll = 0
local groundSpeed = 150

local background_looping_point = 767 - 512
local backgroundSpeed = 100
local backgroundScroll = 0

local background = love.graphics.newImage('Background1-export.png')
_G.ground = love.graphics.newImage('plain-background.png')

local bird = Bird()
local pipePairs = {}
local pipeTimer = 0

local scrolling = true
_G.score = 0

--initilize our last recorded Y value for a gap placement to
local lastY = -PIPE_HEIGHT + math.random(80) + 20
function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())
    love.window.setTitle("Flappy chicken")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    _G.titlefont = love.graphics.newFont('font.ttf', 32)
    _G.pressKeyFont = love.graphics.newFont('font.ttf', 16)
    _G.scoreFont = love.graphics.newFont('font.ttf', 12)
    _G.fpsFont = love.graphics.newFont("font.ttf", 6)
    --setting loves keypressed table to an empty table
    _G.state = 'title'
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    if state == 'play' then
        backgroundScroll = (backgroundScroll + backgroundSpeed * dt) % background_looping_point
        groundScroll = (groundScroll + groundSpeed * dt) % (ground:getWidth() - VIRTUAL_WIDTH)

        --gravity
        pipeTimer = pipeTimer + dt

        if pipeTimer > 1.5 then
            --this is how to add to the table,
            local y = math.max(-PIPE_HEIGHT + 20,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y
            table.insert(pipePairs, PipePair(y))
            pipeTimer = 0
        end

        bird:update(dt)

        for k, pair in pairs(pipePairs) do
            pair:update(dt)
            if not pair.scored then
                if pair.x + PIPE_WIDTH < bird.x then
                    _G.score = score + 1
                    pair.scored = true
                end
            end

            -- check to see if bird collided with pipe
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    _G.state = 'end'
                end
            end

            -- if pipe is no longer visible past left edge, remove it from scene
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end
        if bird:collidesWithGround() or bird:collidesWithSky() then
            _G.state = 'end'
        end

        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    for index, pair in pairs(pipePairs) do
        pair:render()
    end
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Score: ' .. score, 0, 10, VIRTUAL_WIDTH, 'left')
    if state == 'title' then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Flappy Chicken', 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(pressKeyFont)
        love.graphics.printf('Press Enter', 0, 76, VIRTUAL_WIDTH, 'center')
    end
    if state == 'end' then
        love.graphics.setFont(titlefont)
        love.graphics.printf('Game Over!', 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(pressKeyFont)
        love.graphics.printf('Press Enter to restart', 0, 76, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())
    bird:render()
    --displayFPS()
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    --keep track of pressed key, altering love defined tables
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
    if state == 'title' then
        if key == 'return' then
            _G.state = 'play'
        end
    end

    if state == 'end' then
        if key == 'return' then
            _G.score = 0
            bird:reset()
            pipePairs = {}
            _G.state = 'play'
        end
    end
    --love.keyboard.isDown() cannot keep track of pressed keys in other classes besides main
end

--[[adding a function to the keyboard table to check if keyboard was pressed,
    if we define love.keyboard outside of main it will overwrite the  function so it has to be done this way]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- function spawnTime(dt)
--     if resetTimer >= 5 then
--         return true
--     end

-- end

-- function displayFPS()
--     -- simple FPS display across all states
--     love.graphics.setFont(fpsFont)
--     love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
--     love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
-- end
