require "entities.maze"
require "algs.astar"
require "algs.bfs"

local width = 1000
local height = 1000

local cols = 50
local rows = 50

function love.load()
    love.window.setMode(width, height)

    maze = Maze(rows, cols, width, height)

    maze:populate()

    maze:setRandomStart()

    maze:generate()

    alg = BFS(maze)

    alg:setup()
end

function love.update(dt)
    if maze.done then
        if not alg.done then
            alg:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    maze:draw()
    alg:draw()
end