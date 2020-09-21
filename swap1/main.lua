--[[
    GD50
    swap1

    Showcases simple swapping of tiles on a game board, no tweening.
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

    -- currently selected tile, will be swapped with next tile we choose
    -- we make it a flag instead of a reference so we can remove it later
    highlightedTile = false
    highlightedX, highlightedY = 1, 1

    -- currently selected tile, changed with arrow keys
    selectedTile = board[1][1]

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

    -- double assignment; Lua shortcut
    local x, y = selectedTile.gridX, selectedTile.gridY

    -- input handling, staying constrained within the bounds of the grid
    if key == 'up' then
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif key == 'down' then
        if y < 8 then
            selectedTile = board[y + 1][x]
        end
    elseif key == 'left' then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif key == 'right' then
        if x < 8 then
            selectedTile = board[y][x + 1]
        end
    end

    -- pressing enter highlights a tile if none is highlighted and swaps two tiles
    -- if one is already
    if key == 'enter' or key == 'return' then
        if not highlightedTile then
            highlightedTile = true
            highlightedX, highlightedY = selectedTile.gridX, selectedTile.gridY
        else
            -- swap tiles
            local tile1 = selectedTile
            local tile2 = board[highlightedY][highlightedX]

            -- swap tile information
            local tempX, tempY = tile2.x, tile2.y
            local tempgridX, tempgridY = tile2.gridX, tile2.gridY

            -- swap places in the board
            local tempTile = tile1
            board[tile1.gridY][tile1.gridX] = tile2
            board[tile2.gridY][tile2.gridX] = tempTile

            -- swap coordinates and tile grid positions
            tile2.x, tile2.y = tile1.x, tile1.y
            tile2.gridX, tile2.gridY = tile1.gridX, tile1.gridY
            tile1.x, tile1.y = tempX, tempY
            tile1.gridX, tile1.gridY = tempgridX, tempgridY

            -- unhighlight
            highlightedTile = false

            -- reset selection because of the swap
            selectedTile = tile2
        end
    end
end

function love.update(dt)

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

                -- now we need to know what tile X and Y this tile is
                gridX = x,
                gridY = y,
                
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

            -- draw highlight on tile if selected
            if highlightedTile then
                if tile.gridX == highlightedX and tile.gridY == highlightedY then
                    
                    -- half opacity so we can still see tile underneath
                    love.graphics.setColor(1, 1, 1, 128/255)

                    -- rounded rectangle with the 4 at the end (corner segments)
                    love.graphics.rectangle('fill', tile.x + offsetX, tile.y + offsetY, 32, 32, 4)

                    -- reset color back to default
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end
    end

    -- drawing currently selected tile:
    -- almost opaque red color
    love.graphics.setColor(1, 0, 0, 234/255)

    -- thicker line width than normal
    love.graphics.setLineWidth(4)

    -- line rect where tile is
    love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)

    -- reset default color
    -- love.graphics.setColor(1, 1, 1, 1)
end