function getPossibleKingMoves(row, col, boardState)
    moves = {}
    moves[#moves + 1] = { row = row, col = col }

    for i = row - 1, row + 1 do
        for j = col - 1, col + 1 do
            if i >= 0 and i < 8 and j >= 0 and j < 8 then
                if boardState[i][j] == nil or boardState[i][j].color ~= boardState[row][col].color then
                    moves[#moves + 1] = { row = i, col = j }
                end
            end
        end
    end

    return moves
end

function getPossiblePawnMoves(row, col, boardState)
    moves = {}
    moves[#moves + 1] = { row = row, col = col }

    if boardState[row][col].color == "white" then
        if row - 1 >= 0 and boardState[row - 1][col] == nil then
            moves[#moves + 1] = { row = row - 1, col = col }
        end

        if (not boardState[row][col].moved) and boardState[row - 2][col] == nil then
            moves[#moves + 1] = { row = row - 2, col = col }
        end

        if row - 1 >= 0 and col - 1 >= 0 and
            boardState[row - 1][col - 1] ~= nil and
            boardState[row - 1][col - 1].color == "black" then
            moves[#moves + 1] = { row = row - 1, col = col - 1 }
        end

        if row - 1 >= 0 and col + 1 < 8 and
            boardState[row - 1][col + 1] ~= nil and
            boardState[row - 1][col + 1].color == "black" then
            moves[#moves + 1] = { row = row - 1, col = col + 1 }
        end
    else
        if row + 1 < 8 and boardState[row + 1][col] == nil then
            moves[#moves + 1] = { row = row + 1, col = col }
        end

        if (not boardState[row][col].moved) and boardState[row + 2][col] == nil then
            moves[#moves + 1] = { row = row + 2, col = col }
        end

        if row + 1 < 8 and col - 1 >= 0 and
            boardState[row + 1][col - 1] ~= nil and
            boardState[row + 1][col - 1].color == "white" then
            moves[#moves + 1] = { row = row + 1, col = col - 1 }
        end

        if row + 1 < 8 and col + 1 < 8 and
            boardState[row + 1][col + 1] ~= nil and
            boardState[row + 1][col + 1].color == "white" then
            moves[#moves + 1] = { row = row + 1, col = col + 1 }
        end
    end

    return moves
end

function getPossibleKnightMoves(row, col, boardState)
    moves = {}
    moves[#moves + 1] = { row = row, col = col }

    for i = math.max(row - 2, 0), math.min(row + 2, 7) do
        for j = math.max(col - 2, 0), math.min(col + 2, 7) do
            if ((math.abs(i - row) == 2 and math.abs(j - col) == 1) or (math.abs(i - row) == 1 and math.abs(j - col) == 2)) and
                (boardState[i][j] == nil or boardState[i][j].color ~= boardState[row][col].color) then
                moves[#moves + 1] = { row = i, col = j }
            end
        end
    end

    return moves
end

function getPossibleRookMoves(row, col, boardState)
    moves = {}
    moves[#moves + 1] = { row = row, col = col }

    for i = row - 1, 0, -1 do
        if boardState[i][col] == nil then
            moves[#moves + 1] = { row = i, col = col }
        elseif boardState[i][col] ~= nil then
            if boardState[i][col].color ~= boardState[row][col].color then
                moves[#moves + 1] = { row = i, col = col }
            end

            break
        end
    end

    for i = col + 1, 7 do
        if boardState[row][i] == nil then
            moves[#moves + 1] = { row = row, col = i }
        elseif boardState[row][i] ~= nil then
            if boardState[row][i].color ~= boardState[row][col].color then
                moves[#moves + 1] = { row = row, col = i }
            end

            break
        end
    end

    for i = row + 1, 7 do
        if boardState[i][col] == nil then
            moves[#moves + 1] = { row = i, col = col }
        elseif boardState[i][col] ~= nil then
            if boardState[i][col].color ~= boardState[row][col].color then
                moves[#moves + 1] = { row = i, col = col }
            end

            break
        end
    end

    for i = col - 1, 0, -1 do
        if boardState[row][i] == nil then
            moves[#moves + 1] = { row = row, col = i }
        elseif boardState[row][i] ~= nil then
            if boardState[row][i].color ~= boardState[row][col].color then
                moves[#moves + 1] = { row = row, col = i }
            end

            break
        end
    end

    return moves
end

function getPossibleBishopMoves(row, col, boardState)
    moves = {}
    moves[#moves + 1] = { row = row, col = col }

    quarter1 = true
    quarter2 = true
    quarter3 = true
    quarter4 = true

    for i = 1, 7 do
        if quarter1 and row - i >= 0 and col + i < 8 then
            if boardState[row - i][col + i] == nil then
                moves[#moves + 1] = { row = row - i, col = col + i }
            else
                if boardState[row - i][col + i].color ~= boardState[row][col].color then
                    moves[#moves + 1] = { row = row - i, col = col + i }
                end

                quarter1 = false
            end
        end

        if quarter2 and row + i < 8 and col + i < 8 then
            if boardState[row + i][col + i] == nil then
                moves[#moves + 1] = { row = row + i, col = col + i }
            else
                if boardState[row + i][col + i].color ~= boardState[row][col].color then
                    moves[#moves + 1] = { row = row + i, col = col + i }
                end

                quarter2 = false
            end
        end

        if quarter3 and row + i < 8 and col - i >= 0 then
            if boardState[row + i][col - i] == nil then
                moves[#moves + 1] = { row = row + i, col = col - i }
            else
                if boardState[row + i][col - i].color ~= boardState[row][col].color then
                    moves[#moves + 1] = { row = row + i, col = col - i }
                end

                quarter3 = false
            end
        end

        if quarter4 and row - i >= 0 and col - i >= 0 then
            if boardState[row - i][col - i] == nil then
                moves[#moves + 1] = { row = row - i, col = col - i }
            else
                if boardState[row - i][col - i].color ~= boardState[row][col].color then
                    moves[#moves + 1] = { row = row - i, col = col - i }
                end

                quarter4 = false
            end
        end
    end

    return moves
end

function getPossibleQueenMoves(row, col, boardState)
    moves = {}

    rookMoves = getPossibleRookMoves(row, col, boardState)
    bishopMoves = getPossibleBishopMoves(row, col, boardState)

    for i = 1, #rookMoves do
        moves[#moves + 1] = { row = rookMoves[i].row, col = rookMoves[i].col }
    end

    for i = 1, #bishopMoves do
        moves[#moves + 1] = { row = bishopMoves[i].row, col = bishopMoves[i].col }
    end

    return moves
end
