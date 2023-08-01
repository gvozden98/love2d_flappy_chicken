_G.love = require("love")
local push = require 'push'
require 'class'
require 'Bird'
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


function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    love.window.setTitle("Flappy chicken")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    _G.bird = Bird()
    --setting loves keypressed table to an empty table
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + backgroundSpeed * dt) % background_looping_point
    groundScroll = (groundScroll + groundSpeed * dt) % (ground:getWidth() - VIRTUAL_WIDTH)

    --gravity
    bird:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
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
