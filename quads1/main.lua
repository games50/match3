--[[
    quads1

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Demonstrates drawing a texture while passing in the quad for the top left tile.
]]

function love.load()
    push = require 'push'

    love.graphics.setDefaultFilter('nearest', 'nearest')

    texture = love.graphics.newImage('match3.png')
    quad = love.graphics.newQuad(0, 0, 32, 32, texture:getDimensions())

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
    love.graphics.draw(texture, quad)
    push:finish()
end