function getPossibleKingMoves(row, col, boardState)
    moves = {}

    for i = row - 1, row + 1 do
        for j = col - 1, col + 1 do
            if i >= 0 and i < 8 and j >= 0 and j < 8 then
                if boardState[i][j] == nil or (i == row and j == col) then
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

        if row - 1 >= 0 and col - 1 >= 0 and boardState[row - 1][col - 1] ~= nil then
            moves[#moves + 1] = { row = row - 1, col = col - 1 }
        end

        if row - 1 >= 0 and col + 1 < 8 and boardState[row - 1][col + 1] ~= nil then
            moves[#moves + 1] = { row = row - 1, col = col + 1 }
        end
    else
        if row + 1 < 8 and boardState[row + 1][col] == nil then
            moves[#moves + 1] = { row = row + 1, col = col }
        end

        if (not boardState[row][col].moved) and boardState[row + 2][col] == nil then
            moves[#moves + 1] = { row = row + 2, col = col }
        end

        if row + 1 < 8 and col - 1 >= 0 and boardState[row + 1][col - 1] ~= nil then
            moves[#moves + 1] = { row = row + 1, col = col - 1 }
        end

        if row + 1 < 8 and col + 1 < 8 and boardState[row + 1][col + 1] ~= nil then
            moves[#moves + 1] = { row = row + 1, col = col + 1 }
        end
    end

    return moves
end
