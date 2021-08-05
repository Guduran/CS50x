local Stone = {}
Stone.__index = Stone
local TableStones = {}


function Stone.new(x, y)
    local stone = setmetatable({}, Stone)
    stone.x = x
    stone.y = y
    stone.img = love.graphics.newImage("assets/stone.png")
    stone.width = stone.img:getWidth()
    stone.height = stone.img:getHeight()

    stone.physics = {}
    stone.physics.body = love.physics.newBody(World, stone.x, stone.y, "dynamic")
    stone.physics.body:getMass(25)
    stone.physics.shape = love.physics.newRectangleShape(stone.width, stone.height)
    stone.physics.fixture = love.physics.newFixture(stone.physics.body, stone.physics.shape)
    table.insert(TableStones, stone)
end

function Stone:getPhysics()
    self.x, self.y = self.physics.body:getPosition()
end

function Stone:removeAll()
    for i,v in ipairs(TableStones) do
        v.physics.body:destroy()
    end

    TableStones = {}
end

function Stone:update(dt)
    self:getPhysics()
end

function Stone.updateAll(dt)
    for i,stone in ipairs(TableStones) do
        stone:update(dt)
    end
end

function Stone:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Stone.drawAll()
    for i,stone in ipairs(TableStones) do
        stone:draw()
    end
end


return Stone