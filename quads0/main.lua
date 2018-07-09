--[[
    quads0

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Demonstrates simply drawing a texture.
]]

function love.load()
    push = require 'push'

    love.graphics.setDefaultFilter('nearest', 'nearest')

    texture = love.graphics.newImage('match3.png')

    push:setupScreen(512, 288, 1280, 720, {
        fullscreen = false
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(texture)
    push:finish()
end