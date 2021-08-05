local Coin = {}
Coin.__index = Coin
local TableCoins = {}
local Player = require "player"
local Music = require "music"

function Coin.new(x, y)
    local coin = setmetatable({}, Coin)
    coin.x = x
    coin.y = y
    coin.img = love.graphics.newImage("assets/coin.png")
    coin.width = coin.img:getWidth()
    coin.height = coin.img:getHeight()
    coin.scaleX = 1
    
    coin.toBeRemoved = false

    coin.physics = {}
    coin.physics.body = love.physics.newBody(World, coin.x, coin.y, "static")
    coin.physics.shape = love.physics.newRectangleShape(coin.width, coin.height)
    coin.physics.fixture = love.physics.newFixture(coin.physics.body, coin.physics.shape)
    coin.physics.fixture:setSensor(true)
    table.insert(TableCoins, coin)
end

function Coin:update(dt)
    self:checkRemove()
    self:spin()
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function Coin:remove()
    for i, coin in ipairs(TableCoins) do
        if coin == self then
            Player:addCoins()
            self.physics.body:destroy()
            table.remove(TableCoins, i)
        end
    end
end

function Coin:removeAll()
    for i,v in ipairs(TableCoins) do
        v.physics.body:destroy()
    end

    TableCoins = {}
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2)
end

function Coin:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Coin:updateAll(dt)
    for i,coin in ipairs(TableCoins) do
        coin:update(dt)
    end
end

function Coin.drawAll()
    for i,coin in ipairs(TableCoins) do
        coin:draw()
    end
end

function Coin.firstContact(a, b, collision)
    for i, coin in ipairs(TableCoins) do
        if a == coin.physics.fixture or b == coin.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Music:getCoin()
                coin.toBeRemoved =  true
                return true
            end
        end
    end
end

return Coin