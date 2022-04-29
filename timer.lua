local settings = require "settings"

function Timer()
    local this = {}

    this.start_time = nil
    this.time = nil

    function this:start()
        self.start_time = love.timer.getTime()
    end

    function this:update()
        self.time = love.timer.getTime() - self.start_time
    end

    function this:draw()
        love.graphics.setColor(1, 1, 1, 0.85)
        love.graphics.rectangle("fill", settings.width - 170,
                                5, 160, 30)

        local font = love.graphics.setNewFont(20)
        love.graphics.setFont(font)
        local time_str = string.format("Time: %.3f" .. 's', self.time)
        love.graphics.setColor(0.05, 0.05, 0.05, 1)
        love.graphics.printf(time_str, settings.width - 160, (settings.height / settings.rows) / 2, settings.width, "left")
    end

    return this
end