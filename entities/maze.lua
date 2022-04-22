require "utils"
require "entities.cell"

function Maze(rows, cols, width, height)
    local this = {}

    this.rows = rows
    this.cols = cols

    this.width = width
    this.height = height

    this.grid = {}
    this.frontier = {}
    this.in_the_maze = {}

    this.done = false

    function this:populate()
        for i=1,this.rows do
            this.grid[i] = {}
            for j=1,this.cols do
                this.grid[i][j] = Cell(i, j, this.width/this.cols, this.height/this.rows)
            end
        end

        for i=1,this.rows do
            for j=1,this.cols do
                this.grid[i][j]:addNeighbors(this.grid)
            end
        end
    end

    function this:setRandomStart()
        table.insert(this.in_the_maze, this.grid[love.math.random(this.rows)][love.math.random(this.cols)])

        local neighbors = this.in_the_maze[1]:getNeighbors(this)

        for i,v in ipairs(neighbors) do
            if not elementInSet(this.in_the_maze, v) then
                table.insert(this.frontier, v)
            end
        end
    end

    function this:connectToMaze(cell)
        local adjacent = {}

        if cell.top then
            if elementInSet(this.in_the_maze, cell.top) then
                table.insert(adjacent, cell.top)
            end
        end
        if cell.bottom then
            if elementInSet(this.in_the_maze, cell.bottom) then
                table.insert(adjacent, cell.bottom)
            end
        end
        if cell.left then
            if elementInSet(this.in_the_maze, cell.left) then
                table.insert(adjacent, cell.left)
            end
        end
        if cell.right then
            if elementInSet(this.in_the_maze, cell.right) then
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
    
    function this:generate()
        while not this.done do
            local chosen_index = love.math.random(#this.frontier)
            local current = this.frontier[chosen_index]

            table.insert(this.in_the_maze, current)
            table.remove(this.frontier, chosen_index)

            this:connectToMaze(current)

            local neighbors = current:getNeighbors(this)
            for i,v in ipairs(neighbors) do
                if not elementInSet(this.in_the_maze, v) and not elementInSet(this.frontier, v) then
                    table.insert(this.frontier, v)
                end
            end

            if #this.frontier == 0 then
                this.done = true
                print("DONE!")
            end
        end
    end

    function this:update(dt)
        local chosen_index = love.math.random(#this.frontier)
        local current = this.frontier[chosen_index]

        table.insert(this.in_the_maze, current)
        table.remove(this.frontier, chosen_index)

        this:connectToMaze(current)

        local neighbors = current:getNeighbors(this)
        for i,v in ipairs(neighbors) do
            if not elementInSet(this.in_the_maze, v) and not elementInSet(this.frontier, v) then
                table.insert(this.frontier, v)
            end
        end

        if #this.frontier == 0 then
            this.done = true
            print("DONE!")
        end
    end

    function this:draw()
        for i=1,this.rows do
            for j=1,this.cols do
                this.grid[i][j]:draw()
            end
        end
    end

    return this
end