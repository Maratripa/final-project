require "algs.astar"
require "algs.bfs"

local settings = require "settings"

local function Button(pos_x, pos_y, width, height, text, callback)
    -- Create a button entity, you can create multiple buttons if needed
    local entity = {}

    -- Button properties
    entity.x = pos_x
    entity.y = pos_y
    entity.width = width
    entity.height = height

    -- Button text and callback
    entity.text = text
    entity.callback = callback

    -- Button colors
    entity.colors = {
        background = {0.95, 0.95, 0.95, 1},
        text = {0.05, 0.05, 0.05, 1}
    }

    function entity:draw()
        local font = love.graphics.setNewFont(20)
        love.graphics.setFont(font)

        love.graphics.setColor(self.colors.background)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

        love.graphics.setColor(self.colors.text)
        love.graphics.printf(self.text, self.x, self.y + self.height / 3, self.width, "center")
    end

    return entity
end

local function Text(pos_x, pos_y, width, text)
    local entity = {}

    entity.x = pos_x
    entity.y = pos_y
    entity.width = width

    entity.text = text

    entity.colors = {
        text = {0.05, 0.05, 0.05, 1}
    }

    function entity:draw()
        love.graphics.setColor(self.colors.text)
        local font = love.graphics.setNewFont(30)
        love.graphics.setFont(font)
        love.graphics.printf(self.text, self.x, self.y, self.width, "center")
    end

    return entity
end

function LoadMenu()
    -- Menu table
    local menu = {}

    menu.widgets = {}
    menu.buttons = {}

    local button_width = settings.width / 3
    local spacer = settings.width / 9

    -- Create text message
    local title = Text(spacer, spacer, settings.width - 2 * spacer, "Choose an algorithm to solve the maze")
    table.insert(menu.widgets, title)

    -- Create A* button
    local astar_button = Button(spacer, spacer * 3, button_width, button_width / 3, "A* Algorithm",
                                function()
                                    settings.alg = Astar(settings.maze)
                                    settings.alg:setup()
                                    love.load()
                                    settings.paused = false
                                end)
    table.insert(menu.widgets, astar_button)
    table.insert(menu.buttons, astar_button)

    -- Create BFS button
    local bfs_button = Button(spacer * 2 + button_width, spacer * 3, button_width, button_width / 3,
                              "BFS Algorithm", function()
                                settings.alg = BFS(settings.maze)
                                settings.alg:setup()
                                love.load()
                                settings.paused = false
                              end)
    table.insert(menu.widgets, bfs_button)
    table.insert(menu.buttons, bfs_button)

    function menu:draw()
        for i,v in ipairs(self.widgets) do
            v:draw()
        end
    end

    function menu:processMouse(x, y)
        -- check mouse click on buttons
        for i,v in ipairs(self.buttons) do
            if x >= v.x and
               x <= v.x + v.width and
               y >= v.y and
               y <= v.y + v.height then
                   v.callback()
            end
        end
    end

    return menu
end