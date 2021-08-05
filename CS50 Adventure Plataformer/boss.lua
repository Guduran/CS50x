local Boss = {}
Boss.__index = Boss
local Player = require "player"
local Music = require "music"
local Tableboss = {}


function Boss.new(x, y)
    local boss = setmetatable({}, Boss)
    boss.x = x
    boss.y = y
    boss.offsetY = -25
    boss.speed = 250
    boss.speed_x = boss.speed
    boss.r = 0

    boss.damage = 1
    boss.rageCounter = 0
    boss.rageTrigger = 3
    boss.speed_rage = 1

    boss.state = "walk"
    boss.animation = {timer = 0, rate = 0.1}
    boss.animation.run = {total = 6, current = 1, img = Boss.runAnimation}
    boss.animation.walk = {total = 6, current = 1, img = Boss.walkAnimation}
    boss.animation.draw = boss.animation.walk.img[1]

    boss.physics = {}
    boss.physics.body = love.physics.newBody(World, boss.x, boss.y, "dynamic")
    boss.physics.body:setFixedRotation(true)
    boss.physics.body:getMass(25)
    boss.physics.shape = love.physics.newRectangleShape(Boss.width * 0.4, Boss.height * 0.8)
    boss.physics.fixture = love.physics.newFixture(boss.physics.body, boss.physics.shape)
    table.insert(Tableboss, boss)
end

function Boss:removeAll()
    for i,v in ipairs(Tableboss) do
        v.physics.body:destroy()
    end

    Tableboss = {}
end

function Boss.getAssets()
    Boss.runAnimation = {}
    for i=1,6 do
        Boss.runAnimation[i] = love.graphics.newImage("assets/boss/run/"..i..".png")
    end
    Boss.walkAnimation = {}
    for i=1,6 do
        Boss.walkAnimation[i] = love.graphics.newImage("assets/boss/walk/"..i..".png")
    end

    Boss.width = Boss.runAnimation[1]:getWidth()
    Boss.height = Boss.runAnimation[1]:getHeight()
end

function Boss:getPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.speed_x * self.speed_rage, 100)
end

function Boss:rage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
        Music:getDemonRoar()
        self.state = "run"
        self.speed_rage = 3
        self.rageCounter = 0
    else
        self.state = "walk"
        self.speed_rage = 1
    end
end

function Boss:update(dt)
    self:getPhysics()
    self:animate(dt)
end

function Boss:turns()
    self.speed_x = -self.speed_x
end

function Boss:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Boss:setNewFrame()
    local animation2 = self.animation[self.state]
    if animation2.current < animation2.total then
       animation2.current = animation2.current + 1
    else
       animation2.current = 1
    end
    self.animation.draw = animation2.img[animation2.current]
 end

function Boss.updateAll(dt)
    for i,boss in ipairs(Tableboss) do
        boss:update(dt)
    end
end

function Boss:draw()
    local scaleX = 2
    if self.speed_x < 0 then
        scaleX = -2
    end
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 2, self.width / 2, self.height / 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 2, self.width / 2, self.height / 2)
end

function Boss.drawAll()
    for i,boss in ipairs(Tableboss) do
        boss:draw()
    end
end

function Boss.firstContact(a, b, collision)
    for i, boss in ipairs(Tableboss) do
        if a == boss.physics.fixture or b == boss.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:getHurts(boss.damage)
                Music:getHurts()
            end
            boss:rage()
            boss:turns()
        end
    end
end

return Boss