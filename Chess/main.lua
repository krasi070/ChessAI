require "piecemovement"

local showConsole = false
local consoleLog = {}

local spriteSheet
local whitePieces = {}
local blackPieces = {}

local boardState = {}
local highlitSpaces = {}
local selectedPiece = {}
local playerTurn = "white"

function love.load()
    love.window.setTitle("Chess")
    handCursor = love.mouse.getSystemCursor("hand")
    love.window.setMode(640, 720, { fullscreen = false })
    size = 80
    highlitSize = 70
    highlitSign = 1
    highlitMultiplier = 40
    highlitOffset = 5
    loadSprites()

    initBoardState()
    whiteColor = { 1, 1, 1, 1 }
    blackColor = { 0, 0, 0, 1 }
    highlightColor = { 255 / 255, 216 / 255, 0 / 255, 1 }
end

function love.draw()
	love.graphics.clear()
	drawBoard()
	drawHighlitSpaces()
	drawPieces()

	if showConsole then
		drawConsole()
	end
end

function love.update(dt)
    newValue = highlitSize + (highlitSign * dt * highlitMultiplier)
    if newValue > 80 or newValue < 64 then
        highlitSign = highlitSign * -1;
    end

    highlitSize = highlitSize + (highlitSign * dt * highlitMultiplier)
    highlitOffset = (size - highlitSize) / 2
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		pos = mousePositionToBoardPosition(love.mouse.getPosition())

        if selectedPiece ~= nil and selectedPiece.row == pos.row and selectedPiece.col == pos.col then
            highlitSpaces = {}
            selectedPiece = {}
        elseif isHighlit(pos.row, pos.col) then
			if (pos.row ~= selectedPiece.row or pos.col ~= selectedPiece.col) and
				boardState[selectedPiece.row][selectedPiece.col].moved ~= nil then
				boardState[selectedPiece.row][selectedPiece.col].moved = true
			end

            boardState[pos.row][pos.col] = boardState[selectedPiece.row][selectedPiece.col]
            boardState[selectedPiece.row][selectedPiece.col] = nil
            highlitSpaces = {}
            selectedPiece = {}

			if playerTurn == "white" then
				playerTurn = "black"
			else
				playerTurn = "white"
			end
        elseif boardState[pos.row][pos.col] ~= nil and boardState[pos.row][pos.col].color == playerTurn then
            selectedPiece = { row = pos.row, col = pos.col }
			highlitSpaces = boardState[pos.row][pos.col].movesFunc(pos.row, pos.col, boardState)
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "lshift" then
		showConsole = not showConsole
	end
end

function loadSprites()
    spriteSheet = love.graphics.newImage("chess_pieces.png")

    whitePieces["king"] = love.graphics.newQuad(0, 0, size, size, spriteSheet:getDimensions())
    blackPieces["king"] = love.graphics.newQuad(0, size, size, size, spriteSheet:getDimensions())

    whitePieces["queen"] = love.graphics.newQuad(size, 0, size, size, spriteSheet:getDimensions())
    blackPieces["queen"] = love.graphics.newQuad(size, size, size, size, spriteSheet:getDimensions())

    whitePieces["bishop"] = love.graphics.newQuad(size * 2, 0, size, size, spriteSheet:getDimensions())
    blackPieces["bishop"] = love.graphics.newQuad(size * 2, size, size, size, spriteSheet:getDimensions())

    whitePieces["knight"] = love.graphics.newQuad(size * 3, 0, size, size, spriteSheet:getDimensions())
    blackPieces["knight"] = love.graphics.newQuad(size * 3, size, size, size, spriteSheet:getDimensions())

    whitePieces["rook"] = love.graphics.newQuad(size * 4, 0, size, size, spriteSheet:getDimensions())
    blackPieces["rook"] = love.graphics.newQuad(size * 4, size, size, size, spriteSheet:getDimensions())

    whitePieces["pawn"] = love.graphics.newQuad(size * 5, 0, size, size, spriteSheet:getDimensions())
    blackPieces["pawn"] = love.graphics.newQuad(size * 5, size, size, size, spriteSheet:getDimensions())
end

function drawBoard()
    for i = 0, 7 do
        for j = 0, 7 do
            if (i + j) % 2 == 1 then
                love.graphics.setColor(unpack(blackColor))
                love.graphics.rectangle("fill", j * size, i * size, size, size)
            else
                love.graphics.setColor(unpack(whiteColor))
                love.graphics.rectangle("fill", j * size, i * size, size, size)
            end

			if isPointInRect(j * size, i * size, size, size, love.mouse.getPosition()) then
                love.graphics.setColor(unpack(highlightColor))
                love.graphics.rectangle(
                    "fill",
                    j * size + highlitOffset,
                    i * size + highlitOffset,
                    highlitSize,
                    highlitSize)
                love.mouse.setCursor(handCursor)
			end
        end
    end
end

function drawHighlitSpaces()
	love.graphics.setColor(unpack(highlightColor))

	for i = 1, #highlitSpaces do
		love.graphics.rectangle(
            "fill",
            highlitSpaces[i].col * size + highlitOffset,
            highlitSpaces[i].row * size + highlitOffset,
            highlitSize,
            highlitSize)
	end
end

function drawPieces()
    love.graphics.setColor(1, 1, 1, 1)

    for i = 0, 7 do
        for j = 0, 7 do
            if boardState[i][j] ~= nil then
                love.graphics.draw(spriteSheet, boardState[i][j].sprite, size * j, size * i)
            end
        end
    end
end

function initBoardState()
    for i = 0, 7 do
        boardState[i] = {}
        for j = 0, 7 do
            boardState[i][j] = nil
        end
    end

    -- Kings
    boardState[0][4] = {
        sprite = blackPieces["king"],
        color = "black",
        movesFunc = getPossibleKingMoves
    }

    boardState[7][4] = {
        sprite = whitePieces["king"],
        color = "white",
        movesFunc = getPossibleKingMoves
    }

    -- Queens
    boardState[0][3] = {
        sprite = blackPieces["queen"],
        color = "black",
        movesFunc = getPossibleQueenMoves
    }

    boardState[7][3] = {
        sprite = whitePieces["queen"],
        color = "white",
        movesFunc = getPossibleQueenMoves
    }

    -- Bishops
    boardState[0][2] = {
        sprite = blackPieces["bishop"],
        color = "black",
        movesFunc = getPossibleBishopMoves
    }

    boardState[0][5] = {
        sprite = blackPieces["bishop"],
        color = "black",
        movesFunc = getPossibleBishopMoves
    }

    boardState[7][2] = {
        sprite = whitePieces["bishop"],
        color = "white",
        movesFunc = getPossibleBishopMoves
    }

    boardState[7][5] = {
        sprite = whitePieces["bishop"],
        color = "white",
        movesFunc = getPossibleBishopMoves
    }

    -- Knights
    boardState[0][1] = {
        sprite = blackPieces["knight"],
        color = "black",
        movesFunc = getPossibleKnightMoves
    }

    boardState[0][6] = {
        sprite = blackPieces["knight"],
        color = "black",
        movesFunc = getPossibleKnightMoves
    }

    boardState[7][1] = {
        sprite = whitePieces["knight"],
        color = "white",
        movesFunc = getPossibleKnightMoves
    }

    boardState[7][6] = {
        sprite = whitePieces["knight"],
        color = "white",
        movesFunc = getPossibleKnightMoves
    }

    -- Rooks
    boardState[0][0] = {
        sprite = blackPieces["rook"],
        color = "black",
        movesFunc = getPossibleRookMoves
    }

    boardState[0][7] = {
        sprite = blackPieces["rook"],
        color = "black",
        movesFunc = getPossibleRookMoves
    }

    boardState[7][0] = {
        sprite = whitePieces["rook"],
        color = "white",
        movesFunc = getPossibleRookMoves
    }

    boardState[7][7] = {
        sprite = whitePieces["rook"],
        color = "white",
        movesFunc = getPossibleRookMoves
    }

    -- Pawns
    for i = 0, 7 do
        boardState[1][i] = {
            sprite = blackPieces["pawn"],
            color = "black",
			moved = false,
            movesFunc = getPossiblePawnMoves
        }

        boardState[6][i] = {
            sprite = whitePieces["pawn"],
            color = "white",
			moved = false,
            movesFunc = getPossiblePawnMoves
        }
    end
end

function isPointInRect(x, y, width, height, px, py)
    return not (px < x or py < y or px > x + width or py > y + height)
end

function isHighlit(row, col)
    for i = 1, #highlitSpaces do
        if highlitSpaces[i].row == row and highlitSpaces[i].col == col then
            return true
        end
    end

    return false
end

function mousePositionToBoardPosition(x, y)
   return { row = math.floor(y / size), col = math.floor(x / size) }
end

function cPrint(message)
	now = os.date("*t")
	consoleLog[#consoleLog + 1] = {
		timestamp = now.hour .. ":" .. now.min .. ":" .. now.sec,
		message = message
	}
end

function drawConsole()
    width, height = love.graphics.getDimensions()
	cWidth = width * 2 / 3 - width / 40
	cHeight = height / 2 - height / 40

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", width / 40, height / 2, cWidth, cHeight)

    love.graphics.setFont(love.graphics.newFont(height / 40))
    love.graphics.setColor(1, 1, 1, 1)

	for i = 1, math.min(#consoleLog, 10) do
		index = #consoleLog - (math.min(#consoleLog, 10) - i)
		love.graphics.print(
			consoleLog[index].timestamp .. " - " .. consoleLog[index].message,
			width / 20 , (i - 0.25) * cHeight / 10 + cHeight)
	end
end
