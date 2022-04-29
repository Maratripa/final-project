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
        self.grid = maze.grid
        for i=1,#self.grid do
            for j=1,#self.grid[1] do
                local current = self.grid[i][j]
                current.f = 0
                current.g = 0
                current.h = 0
                current.previous = nil
            end
        end

        self.start = self.grid[1][1]
        self.ending = self.grid[#self.grid][#self.grid[1]]

        table.insert(self.open_set, self.start)
    end

    function this:update(dt)
        if #self.open_set > 0 then

            local winner = 1
            for i,v in ipairs(self.open_set) do
                if v.f < self.open_set[winner].f then
                    winner = i
                end
            end
            
            local current = self.open_set[winner]

            if current == self.ending then
                print("DONE!")
                self.done = true
            end

            table.remove(self.open_set, winner)
            table.insert(self.closed_set, current)

            local neighbors = findNeighbors(current)
            for i,v in ipairs(neighbors) do
                if elementInSet(self.closed_set, v) or not areConnected(current, v) then
                    goto continue
                end

                local temp_g = current.g + 1

                local new_path = false

                if elementInSet(self.open_set, v) then
                    if temp_g < v.g then
                        v.g = temp_g
                        new_path = true
                    end
                else
                    v.g = temp_g
                    new_path = true
                    table.insert(self.open_set, v)
                end

                if new_path then
                    v.h = heuristic(v, self.ending)
                    v.f = v.g + v.h
                    v.previous = current
                end

                ::continue::
            end

            self.path = {}
            local temp = current
            table.insert(self.path, temp)
            while temp.previous do
                table.insert(self.path, temp.previous)
                temp = temp.previous
            end
        else
            print("NO SOLUTION")
            self.done = true
        end
    end

    function this:draw()
        local w = math.floor(maze.width / maze.cols)
        local h = math.floor(maze.height / maze.rows)

        for i,v in ipairs(self.open_set) do
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.circle("fill", (v.j - 1) * w + w / 2,
                                         (v.i - 1) * h + h / 2, w / 5)
        end

        for i,v in ipairs(self.closed_set) do
            if not elementInSet(self.path, v) then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.circle("fill", (v.j - 1) * w + w / 2,
                                            (v.i - 1) * h + h / 2, w / 5)
            end
        end

        for i=1,#self.path-1 do
            love.graphics.setLineWidth(w / 5)
            love.graphics.setColor(0, 0, 1, 1)

            local points = {}
            for i=1,#self.path do
                table.insert(points, (self.path[i].j - 1) * w + math.floor(w / 2))
                table.insert(points, (self.path[i].i - 1) * h + math.floor(h / 2))
            end
            love.graphics.line(points)
        end
    end

    return this
end