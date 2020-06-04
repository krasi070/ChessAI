local spritesheet
local whitePieces = {}
local blackPieces = {}

function love.load()
    love.window.setTitle("Chess")
    handCursor = love.mouse.getSystemCursor("hand")
    love.window.setMode(640, 640, { fullscreen = false })
    size = 80
    loadSprites()

    whiteColor = { 1, 1, 1, 1 }
    blackColor = { 0, 0, 0, 1 }
    highlightColor = { 255 / 255, 216 / 255, 0 / 255, 1 }
end

function love.draw()
    for i = 0, 7 do
        for j = 0, 7 do
            if isPointInRect(j * size, i * size, size, size, love.mouse.getPosition()) then
                love.graphics.setColor(unpack(highlightColor))
                love.graphics.rectangle("fill", j * size, i * size, size, size)
                love.mouse.setCursor(handCursor)
            elseif (i + j) % 2 == 1 then
                love.graphics.setColor(unpack(blackColor))
                love.graphics.rectangle("fill", j * size, i * size, size, size)
            else
                love.graphics.setColor(unpack(whiteColor))
                love.graphics.rectangle("fill", j * size, i * size, size, size)
            end
        end
    end

    setBoard()
end

function loadSprites()
    spritesheet = love.graphics.newImage("chess_pieces.png")

    whitePieces["king"] = love.graphics.newQuad(0, 0, size, size, spritesheet:getDimensions())
    blackPieces["king"] = love.graphics.newQuad(0, size, size, size, spritesheet:getDimensions())

    whitePieces["queen"] = love.graphics.newQuad(size, 0, size, size, spritesheet:getDimensions())
    blackPieces["queen"] = love.graphics.newQuad(size, size, size, size, spritesheet:getDimensions())

    whitePieces["bishop"] = love.graphics.newQuad(size * 2, 0, size, size, spritesheet:getDimensions())
    blackPieces["bishop"] = love.graphics.newQuad(size * 2, size, size, size, spritesheet:getDimensions())

    whitePieces["knight"] = love.graphics.newQuad(size * 3, 0, size, size, spritesheet:getDimensions())
    blackPieces["knight"] = love.graphics.newQuad(size * 3, size, size, size, spritesheet:getDimensions())

    whitePieces["rook"] = love.graphics.newQuad(size * 4, 0, size, size, spritesheet:getDimensions())
    blackPieces["rook"] = love.graphics.newQuad(size * 4, size, size, size, spritesheet:getDimensions())

    whitePieces["pawn"] = love.graphics.newQuad(size * 5, 0, size, size, spritesheet:getDimensions())
    blackPieces["pawn"] = love.graphics.newQuad(size * 5, size, size, size, spritesheet:getDimensions())
end

function setBoard()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(spritesheet, blackPieces["king"], size * 4, 0)
    love.graphics.draw(spritesheet, whitePieces["king"], size * 4, size * 7)

    love.graphics.draw(spritesheet, blackPieces["queen"], size * 3, 0)
    love.graphics.draw(spritesheet, whitePieces["queen"], size * 3, size * 7)

    love.graphics.draw(spritesheet, blackPieces["bishop"], size * 2, 0)
    love.graphics.draw(spritesheet, blackPieces["bishop"], size * 5, 0)
    love.graphics.draw(spritesheet, whitePieces["bishop"], size * 2, size * 7)
    love.graphics.draw(spritesheet, whitePieces["bishop"], size * 5, size * 7)

    love.graphics.draw(spritesheet, blackPieces["knight"], size * 1, 0)
    love.graphics.draw(spritesheet, blackPieces["knight"], size * 6, 0)
    love.graphics.draw(spritesheet, whitePieces["knight"], size * 1, size * 7)
    love.graphics.draw(spritesheet, whitePieces["knight"], size * 6, size * 7)

    love.graphics.draw(spritesheet, blackPieces["rook"], 0, 0)
    love.graphics.draw(spritesheet, blackPieces["rook"], size * 7, 0)
    love.graphics.draw(spritesheet, whitePieces["rook"], 0, size * 7)
    love.graphics.draw(spritesheet, whitePieces["rook"], size * 7, size * 7)

    for i = 0, 7 do
        love.graphics.draw(spritesheet, blackPieces["pawn"], size * i, size)
        love.graphics.draw(spritesheet, whitePieces["pawn"], size * i, size * 6)
    end
end

function isPointInRect(x, y, width, height, px, py)
	return not (px < x or py < y or px > x + width or py > y + height)
end
