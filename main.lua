local settings = require "settings"

require "menu"
require "timer"
require "entities.maze"

settings.maze = Maze(settings.rows, settings.cols, settings.width, settings.height)

settings.maze:populate()
settings.maze:setRandomStart()
settings.maze:generate()

function love.load()
    love.window.setMode(settings.width, settings.height, nil)

    menu = LoadMenu()

    alg = settings.alg

    timer = Timer()

    timer:start()
end

function love.update(dt)
    if not settings.paused then
        if settings.maze.done then
            if not alg.done then
                alg:update(dt)
                timer:update()
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    if settings.paused then
        menu:draw()
    else
        settings.maze:draw()
        alg:draw()
        timer:draw()
    end
end

function love.keypressed(k)
    -- Toggle paused mode
    if k == "escape" then
        settings.paused = not settings.paused
    end
end

function love.mousepressed(x, y)
    if settings.paused then
        menu:processMouse(x, y)
    end
end