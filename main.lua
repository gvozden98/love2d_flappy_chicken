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
local ground = love.graphics.newImage('plain-background.png')

local bird = Bird()
local pipePairs = {}
local pipeTimer = 0

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

    --setting loves keypressed table to an empty table
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + backgroundSpeed * dt) % background_looping_point
    groundScroll = (groundScroll + groundSpeed * dt) % (ground:getWidth() - VIRTUAL_WIDTH)

    --gravity
    pipeTimer = pipeTimer + dt

    if pipeTimer > 2 then
        --this is how to add to the table,
        local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
        table.insert(pipePairs, PipePair(y))
        pipeTimer = 0
    end

    bird:update(dt)

    for k, pair in ipairs(pipePairs) do
        pair:update(dt)
    end

    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for index, pair in ipairs(pipePairs) do
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())
    bird:render()
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
