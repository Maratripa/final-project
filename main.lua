require "entities.maze"
require "algs.astar"

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

    astar = Astar(maze)

    astar:setup()
end

function love.update(dt)
    if maze.done then
        if not astar.done then
            astar:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    maze:draw()
    astar:draw()
end