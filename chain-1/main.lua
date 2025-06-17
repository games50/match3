--[[
    CS50 2D
    chain-1

    Example used to showcase a way of moving something from point to point using
    the Timer:finish function.
]]

push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seconds it takes to move each step
MOVEMENT_TIME = 2

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- create flappy sprite and set it to 0, 0; top-left
    flappySprite = love.graphics.newImage('flappy.png')

    -- table to just store flappy's X and Y
    flappy = {x = 0, y = 0, opacity = 255}

    -- destinations are now just placed in Timer.tween, now with a :finish
    -- function after every tween that gets called once that tween is finished
    Timer.tween(MOVEMENT_TIME, {
        [flappy] = {x = VIRTUAL_WIDTH - flappySprite:getWidth(), y = 0, opacity = 0}
    })
    :finish(function()
        Timer.tween(MOVEMENT_TIME, {
            [flappy] = {x = VIRTUAL_WIDTH - flappySprite:getWidth(), y = VIRTUAL_HEIGHT - flappySprite:getHeight(), opacity = 255}
        })
        :finish(function()
            Timer.tween(MOVEMENT_TIME, {
                [flappy] = {x = 0, y = VIRTUAL_HEIGHT - flappySprite:getHeight(), opacity = 0}
            })
            :finish(function()
                Timer.tween(MOVEMENT_TIME, {
                    [flappy] = {x = 0, y = 0, opacity = 255}
                })
            end)
        end)
    end)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'normal' })
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    push.start()
    love.graphics.setColor(1, 1, 1, flappy.opacity / 255)
    love.graphics.draw(flappySprite, flappy.x, flappy.y)
    push.finish()
end