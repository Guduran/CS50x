local Enemy = {}
Enemy.__index = Enemy
local Player = require "player"
local Music = require "music"
local TableEnemy = {}


function Enemy.new(x, y)
    local enemy = setmetatable({}, Enemy)
    enemy.x = x
    enemy.y = y
    enemy.offsetY = -8
    enemy.speed = 100
    enemy.speed_x = enemy.speed
    enemy.r = 0

    enemy.damage = 1
    enemy.rageCounter = 0
    enemy.rageTrigger = 3
    enemy.speed_rage = 1

    enemy.state = "walk"
    enemy.animation = {timer = 0, rate = 0.1}
    enemy.animation.run = {total = 9, current = 1, img = Enemy.runAnimation}
    enemy.animation.walk = {total = 8, current = 1, img = Enemy.walkAnimation}
    enemy.animation.draw = enemy.animation.walk.img[1]

    enemy.physics = {}
    enemy.physics.body = love.physics.newBody(World, enemy.x, enemy.y, "dynamic")
    enemy.physics.body:setFixedRotation(true)
    enemy.physics.body:getMass(25)
    enemy.physics.shape = love.physics.newRectangleShape(Enemy.width * 0.7, Enemy.height * 0.7)
    enemy.physics.fixture = love.physics.newFixture(enemy.physics.body, enemy.physics.shape)
    table.insert(TableEnemy, enemy)
end

function Enemy:removeAll()
    for i,v in ipairs(TableEnemy) do
        v.physics.body:destroy()
    end

    TableEnemy = {}
end

function Enemy.getAssets()
    Enemy.runAnimation = {}
    for i=1,9 do
        Enemy.runAnimation[i] = love.graphics.newImage("assets/enemy/run/"..i..".png")
    end
    Enemy.walkAnimation = {}
    for i=1,8 do
        Enemy.walkAnimation[i] = love.graphics.newImage("assets/enemy/walk/"..i..".png")
    end

    Enemy.width = Enemy.runAnimation[1]:getWidth()
    Enemy.height = Enemy.runAnimation[1]:getHeight()
end

function Enemy:getPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.speed_x * self.speed_rage, 100)
end

function Enemy:rage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
        Music:getRoar()
        self.state = "run"
        self.speed_rage = 3
        self.rageCounter = 0
    else
        self.state = "walk"
        self.speed_rage = 1
    end
end

function Enemy:update(dt)
    self:getPhysics()
    self:animate(dt)
end

function Enemy:turns()
    self.speed_x = -self.speed_x
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Enemy:setNewFrame()
    local animation2 = self.animation[self.state]
    if animation2.current < animation2.total then
       animation2.current = animation2.current + 1
    else
       animation2.current = 1
    end
    self.animation.draw = animation2.img[animation2.current]
 end

function Enemy.updateAll(dt)
    for i,enemy in ipairs(TableEnemy) do
        enemy:update(dt)
    end
end

function Enemy:draw()
    local scaleX = 1.85
    if self.speed_x < 0 then
        scaleX = -1.85
    end
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 1.85, self.width / 2, self.height / 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 1.85, self.width / 2, self.height / 2)
end

function Enemy.drawAll()
    for i,enemy in ipairs(TableEnemy) do
        enemy:draw()
    end
end

function Enemy.firstContact(a, b, collision)
    for i, enemy in ipairs(TableEnemy) do
        if a == enemy.physics.fixture or b == enemy.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:getHurts(enemy.damage)
                Music:getHurts()
            end
            enemy:rage()
            enemy:turns()
        end
    end
end

return Enemy