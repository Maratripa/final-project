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
        this.grid = maze.grid

        for i=1,#this.grid do
            for j=1,#this.grid[1] do
                this.grid[i][j].dist = 1e309
                this.grid[i][j].parent = nil
            end
        end

        this.start = this.grid[1][1]
        this.ending = this.grid[#this.grid][#this.grid[1]]

        table.insert(this.explored, this.start)
        this.start.dist = 0
        table.insert(this.queue, this.start)
    end

    function this:update(dt)
        if #this.queue > 0 then
            local current = this.queue[1]
            table.remove(this.queue, 1)

            if current == this.ending then
                this.done = true
            end

            local neighbors = findNeighbors(current)

            for i,v in ipairs(neighbors) do
                if not elementInSet(this.explored, v) and areConnected(current, v) then
                    table.insert(this.explored, v)
                    v.dist = current.dist + 1
                    v.parent = current
                    table.insert(this.queue, v)
                end
            end


        end
    end

    function this:draw()
        local w = maze.width / maze.cols
        local h = maze.height / maze.rows
        for i,v in ipairs(this.explored) do
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.circle("fill", (v.j - 1) * w + w / 2,
                                         (v.i - 1) * h + h / 2,
                                          w / 5)
        end
        if this.done then
            love.graphics.setColor(0, 0, 1, 1)
            local temp = this.ending
            while temp.parent do
                love.graphics.circle("fill", (temp.j - 1) * w + w / 2,
                                         (temp.i - 1) * h + h / 2,
                                          w / 5)
                temp = temp.parent
            end
        end
    end

    return this
end