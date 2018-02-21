--[[
    GD50
    chain0

    Example used to showcase a simple way of moving something from point to point
    over time in some order, effectively "chaining" the steps.
]]

push = require 'push'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seconds it takes to move each step
MOVEMENT_TIME = 2

function love.load()
    -- create flappy sprite and set it to 0, 0; top-left
    flappySprite = love.graphics.newImage('flappy.png')

    -- current X and Y of flappy
    flappyX, flappyY = 0, 0

    -- base from which we will interpolate flappy, changed every point
    baseX, baseY = flappyX, flappyY

    -- keeps track of movement time
    timer = 0

    -- our four destinations in order, stored as X,Y coordinates
    destinations = {
        [1] = {x = VIRTUAL_WIDTH - flappySprite:getWidth(), y = 0},
        [2] = {x = VIRTUAL_WIDTH - flappySprite:getWidth(), y = VIRTUAL_HEIGHT - flappySprite:getHeight()},
        [3] = {x = 0, y = VIRTUAL_HEIGHT - flappySprite:getHeight()},
        [4] = {x = 0, y = 0}
    }

    -- add a false "reached" flag to each destination
    for k, destination in pairs(destinations) do
        destination.reached = false
    end

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
    timer = math.min(MOVEMENT_TIME, timer + dt)

    for i, destination in ipairs(destinations) do
        if not destination.reached then
            flappyX, flappyY =
                -- add the difference of the destination and base point of the
                -- current interpolation, multiplied by the ratio of time / duration,
                -- which performs a linear interpolation across any two values, negative
                -- or positive
                baseX + (destination.x - baseX) * timer / MOVEMENT_TIME,
                baseY + (destination.y - baseY) * timer / MOVEMENT_TIME
            
            -- flag destination as reached if we've reached the movement time and set the
            -- base point as the new current point
            if timer == MOVEMENT_TIME then
                destination.reached = true
                baseX, baseY = destination.x, destination.y
                timer = 0
            end

            -- only need to calculate first unreached destination we iterate over
            break
        end
    end
end

function love.draw()
    push:start()
    love.graphics.draw(flappySprite, flappyX, flappyY)
    push:finish()
end