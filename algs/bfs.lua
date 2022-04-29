require "utils"

function BFS(maze)
    local this = {}

    this.grid = {}

    this.queue = {}
    this.explored = {}

    this.start = nil
    this.ending = nil

    this.path = {}

    this.done = false

    function this:setup()
        self.grid = maze.grid

        for i=1,#self.grid do
            for j=1,#self.grid[1] do
                self.grid[i][j].dist = 1e309
                self.grid[i][j].parent = nil
            end
        end

        self.start = self.grid[1][1]
        self.ending = self.grid[#self.grid][#self.grid[1]]

        table.insert(self.explored, self.start)
        self.start.dist = 0
        table.insert(self.queue, self.start)
    end

    function this:update(dt)
        if #self.queue > 0 then
            local current = self.queue[1]
            table.remove(self.queue, 1)

            if current == self.ending then
                self.done = true
            end

            local neighbors = findNeighbors(current)

            for i,v in ipairs(neighbors) do
                if not elementInSet(self.explored, v) and areConnected(current, v) then
                    table.insert(self.explored, v)
                    v.dist = current.dist + 1
                    v.parent = current
                    table.insert(self.queue, v)
                end
            end


        end
    end

    function this:draw()
        local w = maze.width / maze.cols
        local h = maze.height / maze.rows
        --[[
        for i,v in ipairs(this.explored) do
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.circle("fill", (v.j - 1) * w + w / 2,
                                         (v.i - 1) * h + h / 2,
                                          w / 5)
        end
        ]]--

        love.graphics.setColor(0, 1, 0, 0.4)
        love.graphics.setLineWidth(w / 5)
        for i,v in ipairs(self.explored) do
            if v.parent then
                love.graphics.line((v.parent.j - 1) * w + w / 2, (v.parent.i - 1) * h + h / 2,
                                    (v.j - 1) * w + w / 2, (v.i - 1) * h + h / 2)
            end
        end

        if self.done then
            local path = {}
            local temp = self.ending
            table.insert(path, (temp.j - 1) * w + w / 2)
            table.insert(path, (temp.i - 1) * h + h / 2)
            while temp.parent do
                table.insert(path, (temp.parent.j - 1) * w + w / 2)
                table.insert(path, (temp.parent.i - 1) * h + h / 2)
                temp = temp.parent
            end
            love.graphics.setColor(0, 0, 1, 1)
            love.graphics.setLineWidth(w / 4)
            love.graphics.line(path)
            
        end
    end

    return this
end