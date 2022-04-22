function Cell(i, j, w, h)
    local this = {}

    this.i = i
    this.j = j

    this.w = w
    this.h = h

    this.top = nil
    this.bottom = nil
    this.left = nil
    this.right = nil

    this.tc = false -- Top connection
    this.bc = false -- Bottom connection
    this.lc = false -- Left connection
    this.rc = false -- Right connection

    function this:addNeighbors(grid)
        local rows = #grid
        local cols = #grid[1]

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

    function this:getNeighbors(maze)
        local available = {}
        if self.top then
            if not elementInSet(maze.in_the_maze, self.top) then
                table.insert(available, self.top)
            end
        end
        if self.bottom then
            if not elementInSet(maze.in_the_maze, self.bottom) then
                table.insert(available, self.bottom)
            end
        end
        if self.left then
            if not elementInSet(maze.in_the_maze, self.left) then
                table.insert(available, self.left)
            end
        end
        if self.right then
            if not elementInSet(maze.in_the_maze, self.right) then
                table.insert(available, self.right)
            end
        end

        return available
    end

    return this
end