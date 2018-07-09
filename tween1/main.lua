--[[
    GD50
    tween1

    Example used to showcase a simple way of "tweening" (interpolating) some value
    over a period of time, in this case by moving Flappy Bird across the screen,
    horizontally. This example instantiates a large number of birds all moving at
    different rates to show a slightly better example than before.
]]

push = require 'push'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- longest possible movement duration
TIMER_MAX = 10

function love.load()
    flappySprite = love.graphics.newImage('flappy.png')

    -- table of birds with random movement rates and Y positions
    birds = {}

    -- create 1000 random birds
    for i = 1, 100 do
        table.insert(birds, {
            -- all start at left side
            x = 0,

            -- random Y position within screen boundaries
            y = math.random(VIRTUAL_HEIGHT - 24),

            -- random rate between half a second and our max, floating point
            -- math.random() by itself will generate a random float between 0 and 1,
            -- so we add that to math.random(max) to get a number between 0 and 10,
            -- floating-point
            rate = math.random() + math.random(TIMER_MAX - 1)
        })
    end

    -- timer for interpolating the Y values
    timer = 0

    -- end X position for our interpolations
    endX = VIRTUAL_WIDTH - flappySprite:getWidth()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- only need to run this for max of 
    if timer < TIMER_MAX then

        timer = timer + dt

        -- iterating over all birds this time, calculating based on their own rate
        for k, bird in pairs(birds) do
            
            -- math.min ensures we don't go past the end
            -- timer / MOVE_DURATION is a ratio that we effectively just multiply our
            -- X by each turn to make it seem as if we're moving right
            bird.x = math.min(endX, endX * (timer / bird.rate))
        end
    end
end

function love.draw()
    push:start()

    -- iterate over bird table now
    for k, bird in pairs(birds) do
        love.graphics.draw(flappySprite, bird.x, bird.y)
    end

    love.graphics.print(tostring(timer), 4, 4)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 4, VIRTUAL_HEIGHT - 16)
    push:finish()
end