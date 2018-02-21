--[[
    GD50
    swap0

    First example of a series illustrating swapping; this example just draws
    the grid of tiles to the board.
]]

push = require 'push'

-- for GenerateQuads
require 'Util'

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    -- sprite sheet of tiles
    tileSprite = love.graphics.newImage('match3.png')

    -- individual tile quads
    tileQuads = GenerateQuads(tileSprite, 32, 32)

    -- board of tiles
    board = generateBoard()

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

function love.draw()
    push:start()
    
    -- draw the board with an offset so it's centered on the screen
    drawBoard(128, 16)
    
    push:finish()
end

--[[
    Populates a table with mini-tables each containing X and Y coordinates for
    tiles to draw them at, as well as the quad ID associated with them.
]]
function generateBoard()
    local tiles = {}

    -- each column of tiles
    for y = 1, 8 do
        
        -- row of tiles
        table.insert(tiles, {})

        for x = 1, 8 do
            
            -- tiles[y] will be the blank table we just inserted
            table.insert(tiles[y], {
                
                --coordinates are 0-based, so subtract one before multiplying by 32
                x = (x - 1) * 32,
                y = (y - 1) * 32,
                
                -- assign a random ID to tile to make it a random tile
                tile = math.random(#tileQuads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    -- draw each column
    for y = 1, 8 do

        -- draw each row
        for x = 1, 8 do
            local tile = board[y][x]

            -- draw spritesheet using the tile's quad, adding offsets
            love.graphics.draw(tileSprite, tileQuads[tile.tile],
                tile.x + offsetX, tile.y + offsetY)
        end
    end
end