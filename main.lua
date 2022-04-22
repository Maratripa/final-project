local function elementInSet(set, element)
    for i=1,#set do
        if set[i] == element then
            return true
        end
    end

    return false
end

local function connectToMaze(cell)
    local adjacent = {}

    if cell.top then
        if elementInSet(inTheMaze, cell.top) then
            table.insert(adjacent, cell.top)
        end
    end
    if cell.bottom then
        if elementInSet(inTheMaze, cell.bottom) then
            table.insert(adjacent, cell.bottom)
        end
    end
    if cell.left then
        if elementInSet(inTheMaze, cell.left) then
            table.insert(adjacent, cell.left)
        end
    end
    if cell.right then
        if elementInSet(inTheMaze, cell.right) then
            table.insert(adjacent, cell.right)
        end
    end
    
    if #adjacent > 0 then
        local chosen = adjacent[love.math.random(#adjacent)]
        if chosen.bottom then
            if cell.top == chosen then
                cell.tc = true
                chosen.bc = true
            end
        end
        if chosen.top then
            if cell.bottom == chosen then
                cell.bc = true
                chosen.tc = true
            end
        end
        if chosen.right then
            if cell.left == chosen then
                cell.lc = true
                chosen.rc = true
            end
        end
        if chosen.left then
            if cell.right == chosen then
                cell.rc = true
                chosen.lc = true
            end
        end
    end
    
end

local width = 1000
local height = 1000

local cols = 100
local rows = 100

local w = width / cols
local h = height / rows

local grid = {}

inTheMaze = {}
local frontier = {}

local done = false

function Cell(i, j)
    local this = {}

    this.i = i
    this.j = j

    this.top = nil
    this.bottom = nil
    this.left = nil
    this.right = nil

    this.tc = false
    this.bc = false
    this.lc = false
    this.rc = false

    this.current = false

    function this:addNeighbors(grid)
        if self.i < rows then
            self.bottom = grid[self.i + 1][self.j]
        end
        if self.i > 1 then
            self.top = grid[self.i - 1][self.j]
        end
        if self.j < cols then
            self.right = grid[self.i][self.j + 1]
        end
        if self.j > 1 then
            self.left = grid[self.i][self.j - 1]
        end
    end

    function this:draw()
        --[[
        love.graphics.rectangle("fill",
                                (self.i - 1) * h,
                                (self.j - 1) * w,
                                w - 1, h - 1)
        ]]--
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setLineWidth(w / 10)
        if not self.tc then
            love.graphics.line((self.j - 1) * w, (self.i - 1) * h,
                                self.j * w, (self.i - 1) * h)
        end
        if not self.bc then
            love.graphics.line((self.j - 1) * w, self.i * h,
                                self.j * w, self.i * h)
        end
        if not self.lc then
            love.graphics.line((self.j - 1) * w, (self.i - 1) * h,
                                (self.j - 1) * w, self.i * h)
        end
        if not self.rc then
            love.graphics.line(self.j * w, (self.i - 1) * h,
                                self.j * w, self.i * h)
        end

        if elementInSet(frontier, self) and elementInSet(inTheMaze, self) then
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.circle("fill", (self.j - 1) * w + w/2, (self.i - 1) * h + h/2, w/3)
        elseif elementInSet(frontier, self) then
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.circle("fill", (self.j - 1) * w + w/2, (self.i - 1) * h + h/2, w/3)
        end

        if self.current then
            love.graphics.setColor(0, 0, 1, 1)
            love.graphics.circle("fill", (self.j - 1) * w + w/2, (self.i - 1) * h + h/2, w/3)
        end

    end

    function this:getNeighbors()
        local available = {}
        if self.top then
            if not elementInSet(inTheMaze, self.top) then
                table.insert(available, self.top)
            end
        end
        if self.bottom then
            if not elementInSet(inTheMaze, self.bottom) then
                table.insert(available, self.bottom)
            end
        end
        if self.left then
            if not elementInSet(inTheMaze, self.left) then
                table.insert(available, self.left)
            end
        end
        if self.right then
            if not elementInSet(inTheMaze, self.right) then
                table.insert(available, self.right)
            end
        end

        return available
    end

    return this
end

function love.load()
    love.window.setMode(width, height)

    for i=1,rows do
        grid[i] = {}
        for j=1,cols do
            grid[i][j] = Cell(i, j)
        end
    end

    for i=1,rows do
        for j=1,cols do
            grid[i][j]:addNeighbors(grid)
        end
    end

    table.insert(inTheMaze, grid[love.math.random(rows)][love.math.random(cols)])

    local neighbors = inTheMaze[1]:getNeighbors()
    for i,v in ipairs(neighbors) do
        if not elementInSet(inTheMaze, v) then
            table.insert(frontier, v)
        end
    end
end

function love.update(dt)
    if not done then
        if #frontier == 0 then
            done = true
        else
            local chosenIndex = love.math.random(#frontier)
            local current = frontier[chosenIndex]
            table.insert(inTheMaze, current)
            table.remove(frontier, chosenIndex)
            current.current = true

            connectToMaze(current)

            local neighbors = current:getNeighbors()
            for i,v in ipairs(neighbors) do
                if not elementInSet(inTheMaze, v) and not elementInSet(frontier, v) then
                    table.insert(frontier, v)
                end
            end

            if #frontier == 0 then
                print("DONE!")
                done = true
            end

            current.current = false
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    for i=1,rows do
        for j=1,cols do
            grid[i][j]:draw()
        end
    end
end