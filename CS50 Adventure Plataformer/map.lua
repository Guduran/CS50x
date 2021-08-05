local Map = {}
local STI = require "sti"
local Coin = require "coin"
local Trap = require "trap"
local Stone = require "stone"
local Enemy = require "enemy"
local Boss = require "boss"
local Player = require "player"

function Map:load()
    self.currentLevel = 1
    World = love.physics.newWorld(0, 2000) -- 2000 para a gravidade do mundo
    World:setCallbacks(firstContact, lastContact)

    self:boot()
end

function Map:boot()
    if self.currentLevel == 3 then
        love.event.quit()
    end
    self.level = STI("map/map"..self.currentLevel..".lua", {"box2d"})
    self.level:box2d_init(World)
    self.level.layers.solid.visible = false
    self.level.layers.entity.visible = false
    Map_Width = self.level.layers.ground.width * 16

    self:getObjects()
end

function Map:nextLevel()
    self:clear()
    self.currentLevel = self.currentLevel + 1
    self:boot()
    Player:resetPosition()
end

function Map:update()
    if Player.x > Map_Width - 16 then
        self:nextLevel()
    end
end

function Map:clear()
    self.level:box2d_removeLayer("solid")
    Coin.removeAll()
    Enemy.removeAll()
    Boss.removeAll()
    Stone.removeAll()
    Trap.removeAll()
end

function Map:getObjects()
    for i,v in ipairs(self.level.layers.entity.objects) do
        if v.type == "trap" then
            Trap.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "stone" then
            Stone.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "coin" then
            Coin.new(v.x, v.y)
        elseif v.type == "enemy" then
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "boss" then
            Boss.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

return Map