require "utils"

function Astar(maze)
    local this = {}

    this.grid = {}

    this.open_set = {}
    this.closed_set = {}

    this.start = nil
    this.ending = nil

    this.path = {}

    this.done = false

    local function heuristic(c1, c2)
        local dx = c1.j - c2.j
        local dy = c1.i - c2.i

        local d = math.abs(dx) + math.abs(dy)

        return d
    end

    function this:setup()
        this.grid = maze.grid
        for i=1,#this.grid do
            for j=1,#this.grid[1] do
                local current = this.grid[i][j]
                current.f = 0
                current.g = 0
                current.h = 0
                current.previous = nil
            end
        end

        this.start = this.grid[1][1]
        this.ending = this.grid[#this.grid][#this.grid[1]]

        table.insert(this.open_set, this.start)
    end

    function this:update(dt)
        if #this.open_set > 0 then

            local winner = 1
            for i,v in ipairs(this.open_set) do
                if v.f < this.open_set[winner].f then
                    winner = i
                end
            end
            
            local current = this.open_set[winner]

            if current == this.ending then
                print("DONE!")
                this.done = true
            end

            table.remove(this.open_set, winner)
            table.insert(this.closed_set, current)

            local neighbors = findNeighbors(current)
            for i,v in ipairs(neighbors) do
                if elementInSet(this.closed_set, v) or not areConnected(current, v) then
                    goto continue
                end

                local temp_g = current.g + 1

                local new_path = false

                if elementInSet(this.open_set, v) then
                    if temp_g < v.g then
                        v.g = temp_g
                        new_path = true
                    end
                else
                    v.g = temp_g
                    new_path = true
                    table.insert(this.open_set, v)
                end

                if new_path then
                    v.h = heuristic(v, this.ending)
                    v.f = v.g + v.h
                    v.previous = current
                end

                ::continue::
            end

            this.path = {}
            local temp = current
            table.insert(this.path, temp)
            while temp.previous do
                table.insert(this.path, temp.previous)
                temp = temp.previous
            end
        else
            print("NO SOLUTION")
            this.done = true
        end
    end

    function this:draw()
        local w = math.floor(maze.width / maze.cols)
        local h = math.floor(maze.height / maze.rows)

        for i=1,#this.path-1 do
            love.graphics.setLineWidth(w / 5)
            love.graphics.setLineStyle("smooth")
            love.graphics.setLineJoin("none")
            love.graphics.setColor(0, 0, 1, 1)

            local points = {}
            for i=1,#this.path do
                table.insert(points, (this.path[i].j - 1) * w + math.floor(w / 2))
                table.insert(points, (this.path[i].i - 1) * h + math.floor(h / 2))
            end
            love.graphics.line(points)
        end
    end

    return this
end