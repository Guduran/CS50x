local Trap = {}
Trap.__index = Trap
local TableTraps = {}
local Player = require "player"


function Trap.new(x, y)
    local trap = setmetatable({}, Trap)
    trap.x = x
    trap.y = y
    trap.img = love.graphics.newImage("assets/trap.png")
    trap.width = trap.img:getWidth()
    trap.height = trap.img:getHeight()
    trap.damage = 1

    trap.physics = {}
    trap.physics.body = love.physics.newBody(World, trap.x, trap.y, "static")
    trap.physics.shape = love.physics.newRectangleShape(trap.width, trap.height)
    trap.physics.fixture = love.physics.newFixture(trap.physics.body, trap.physics.shape)
    trap.physics.fixture:setSensor(true)
    table.insert(TableTraps, trap)
end

function Trap:update(dt)

end

function Trap:removeAll()
    for i,v in ipairs(TableTraps) do
        v.physics.body:destroy()
    end

    TableTraps = {}
end

function Trap:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Trap.updateAll(dt)
    for i,trap in ipairs(TableTraps) do
        trap:update(dt)
    end
end

function Trap.drawAll()
    for i,trap in ipairs(TableTraps) do
        trap:draw()
    end
end

function Trap.firstContact(a, b, collision)
    for i, trap in ipairs(TableTraps) do
        if a == trap.physics.fixture or b == trap.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:getHurts(trap.damage)
                return true
            end
        end
    end
end

return Trap