function elementInSet(set, element)
    for i=1,#set do
        if set[i] == element then
            return true
        end
    end

    return false
end

function findNeighbors(cell)
    local list = {}

    if cell.top then
        table.insert(list, cell.top)
    end
    if cell.bottom then
        table.insert(list, cell.bottom)
    end
    if cell.left then
        table.insert(list, cell.left)
    end
    if cell.right then
        table.insert(list, cell.right)
    end

    return list
end

function areConnected(c1, c2)
    if c1.top == c2 and c1.tc then
        return true
    elseif c1.bottom == c2 and c1.bc then
        return true
    elseif c1.left == c2 and c1.lc then
        return true
    elseif c1.right == c2 and c1.rc then
        return true
    else
        return false
    end
end