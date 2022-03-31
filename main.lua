local width = 1000
local height = 1000

local cols = 100
local rows = 100

local w = width / cols
local h = height / rows

local grid = {}

local openSet = {}

local totalCells = 0

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

    this.visited = false

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
    end

    function this:getNeighbors()
        local available = {}
        if self.top then
            if not self.top.visited then
                table.insert(available, 1)
            end
        end
        if self.bottom then
            if not self.bottom.visited then
                table.insert(available, 2)
            end
        end
        if self.left then
            if not self.left.visited then
                table.insert(available, 3)
            end
        end
        if self.right then
            if not self.right.visited then
                table.insert(available, 4)
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
            totalCells = totalCells + 1
        end
    end

    for i=1,rows do
        for j=1,cols do
            grid[i][j]:addNeighbors(grid)
        end
    end

    table.insert(openSet, grid[love.math.random(rows)][love.math.random(cols)])
end

function love.update(dt)
    if not done and #openSet < totalCells then
        local index = love.math.random(#openSet)
        local current = openSet[index]
        current.visited = true

        local available = current:getNeighbors()
        local choice = available[love.math.random(#available)]
        if #available > 0 then
            if choice == 1 then
                current.tc = true
                current.top.bc = true
                current.top.visited = true
                table.insert(openSet, current.top)
            elseif choice == 2 then
                current.bc = true
                current.bottom.tc = true
                current.bottom.visited = true
                table.insert(openSet, current.bottom)
            elseif choice == 3 then
                current.lc = true
                current.left.rc = true
                current.left.visited = true
                table.insert(openSet, current.left)
            elseif choice == 4 then
                current.rc = true
                current.right.lc = true
                current.right.visited = true
                table.insert(openSet, current.right)
            end
        end
        if #openSet == totalCells then
            done = true
            print("DONE!")
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