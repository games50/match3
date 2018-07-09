--[[
    quads4

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Demonstrates creating a table of quads from a texture and randomly drawing them
    all over the screen, but not rapidly, so we need to cache their indices.
]]

function GenerateQuads(texture, width, height)
    local sheetWidth = texture:getWidth() / width
    local sheetHeight = texture:getHeight() / height

    local quadCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[quadCounter] =
                love.graphics.newQuad(x * width, y * height, width, height,
                    texture:getDimensions())
            quadCounter = quadCounter + 1
        end
    end

    return quads
end

function love.load()
    push = require 'push'

    love.graphics.setDefaultFilter('nearest', 'nearest')

    tiles = {}
    texture = love.graphics.newImage('match3.png')
    quads = GenerateQuads(texture, 32, 32)
    refreshTiles()

    push:setupScreen(512, 288, 1280, 720, {
        fullscreen = false
    })
end

function refreshTiles()
    tiles = {}

    for y = 1, 288 / 32 do

        table.insert(tiles, {})
        
        for x = 1, 512 / 32 do
            table.insert(tiles[y], math.random(#quads))
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        refreshTiles()
    end
end

function love.draw()
    push:start()
    
    for y = 1, 288 / 32 do
        for x = 1, 512 / 32 do
            love.graphics.draw(texture, quads[tiles[y][x]], (x - 1) * 32, (y - 1) * 32)        
        end
    end
    
    push:finish()
end