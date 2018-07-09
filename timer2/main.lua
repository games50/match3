--[[
    GD50
    timer2

    Example used to showcase a simple way of implementing a timer that affects
    some output on the screen, but with the Timer class provided by the Knife
    library to make our lives a whole lot easier.
]]

push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    -- all of the intervals for our labels
    intervals = {1, 2, 4, 3, 2, 8}

    -- all of the counters for our labels
    counters = {0, 0, 0, 0, 0, 0}

    -- create Timer entries for each interval and counter
    for i = 1, 6 do
        -- anonymous function that gets called every intervals[i], in seconds
        Timer.every(intervals[i], function()
            counters[i] = counters[i] + 1
        end)
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
    -- perform the actual updates in the functions we passed in via Timer.every
    Timer.update(dt)
end

function love.draw()
    push:start()
    
    -- "5" could be # of some table here for a real-world use case
    for i = 1, 6 do
        -- reference the counters and intervals table via i here, which is being
        -- updated with the Timer library over time thanks to Timer.update
        love.graphics.printf('Timer: ' .. tostring(counters[i]) .. ' seconds (every ' ..
            tostring(intervals[i]) .. ')', 0, 54 + i * 16, VIRTUAL_WIDTH, 'center')
    end
    
    push:finish()
end