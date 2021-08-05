

local Player = {}


function Player:load()
   self.x = 30
   self.start_x = self.x
   self.y = 280
   self.start_y = self.y
   self.width = 20
   self.height = 60
   self.speed_x = 0
   self.speed_y = 0
   self.speed_max = 200
   self.speed_acc = 4000
   self.friction = 3500
   self.gravity = 1500
   self.jumpAmount = -500
   self.life = {current = 3, max = 3}
   self.alive = true

   self.grounded = false
   self.doubleJump = true

   self.color = {
      r = 1,
      g = 1,
      b = 1,
      speed = 3
   }

   self.direction = "right"
   self.state = "idle"

   self.coins = 0

   self:Assets()

   self.physics = {}
   self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
   self.physics.body:setFixedRotation(true)
   self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
   self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
   self.physics.body:setGravityScale(0)
end

function Player:getHurts(amount)
   self:getRed()
   if self.life.current - amount > 0 then
      self.life.current = self.life.current - amount
   else
      self.life.current = 0
      self:die()
   end
end

function Player:die()
   self.alive = false
end

function Player:getRed()
   self.color.g = 0
   self.color.b = 0
end

function Player:getUncolor(dt)
   self.color.r = math.min(self.color.r + self.color.speed * dt, 1)
   self.color.g = math.min(self.color.g + self.color.speed * dt, 1)
   self.color.b = math.min(self.color.b + self.color.speed * dt, 1)
end

function Player:revive()
   if not self.alive then
      self:resetPosition()
      self.life.current = self.life.max
      self.alive = true
   end
end

function Player:resetPosition()
   self.physics.body:setPosition(self.start_x, self.start_y)
end

function Player:addCoins()
   self.coins = self.coins + 1
end

function Player:Assets()
   self.animation = {timer = 0, rate = 0.1}

   self.animation.move = {total = 8, current = 1, img = {}}
   for i=1, self.animation.move.total do
      self.animation.move.img[i] = love.graphics.newImage("assets/player/move/"..i..".png")
   end

   self.animation.idle = {total = 8, current = 1, img = {}}
   for i=1, self.animation.idle.total do
      self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
   end

   self.animation.jump = {total = 8, current = 1, img = {}}
   for i=1, self.animation.jump.total do
      self.animation.jump.img[i] = love.graphics.newImage("assets/player/jump/"..i..".png")
   end

   self.animation.draw = self.animation.idle.img[1]
   self.animation.width = self.animation.draw:getWidth()
   self.animation.height = self.animation.draw:getHeight()
end

function Player:update(dt)
   self:getUncolor(dt)
   self:revive()
   self:setState()
   self:setDirection()
   self:animate(dt)
   self:syncPhysics()
   self:move(dt)
   self:applyGravity(dt)
end

function Player:setState()
   if not self.grounded then
      self.state = "jump"
   elseif self.speed_x == 0 then
      self.state = "idle"
   else
      self.state = "move"
   end
end

function Player:setDirection()
   if self.speed_x < 0 then
      self.direction = "left"
   elseif self.speed_x > 0 then
      self.direction = "right"
   end
end

function Player:animate(dt)
   self.animation.timer = self.animation.timer + dt
   if self.animation.timer > self.animation.rate then
      self.animation.timer = 0
      self:setNewFrame()
   end
end

function Player:setNewFrame()
   local animation2 = self.animation[self.state]
   if animation2.current < animation2.total then
      animation2.current = animation2.current + 1
   else
      animation2.current = 1
   end
   self.animation.draw = animation2.img[animation2.current]
end

function Player:applyGravity(dt)
   if not self.grounded then
      self.speed_y = self.speed_y + self.gravity * dt
   end
end

function Player:move(dt)
   if love.keyboard.isDown("right") then
      self.speed_x = math.min(self.speed_x + self.speed_acc * dt, self.speed_max)
   elseif love.keyboard.isDown("left") then
      self.speed_x = math.max(self.speed_x - self.speed_acc * dt, -self.speed_max)
   else
      self:applyFriction(dt)
   end
end

function Player:applyFriction(dt)
   if self.speed_x > 0 then
      self.speed_x = math.max(self.speed_x - self.friction * dt, 0)
   elseif self.speed_x < 0 then
      self.speed_x = math.min(self.speed_x + self.friction * dt, 0)
   end
end

function Player:syncPhysics()
   self.x, self.y = self.physics.body:getPosition()
   self.physics.body:setLinearVelocity(self.speed_x, self.speed_y)
end

function Player:firstContact(a, b, collision)
   if self.grounded == true then
      return
   end
   local nx, ny = collision:getNormal()
   if a == self.physics.fixture then
      if ny > 0 then
         self:land(collision)
      elseif ny < 0 then
         self.speed_y = 0
      end
   elseif b == self.physics.fixture then
      if ny < 0 then
         self:land(collision)
      elseif ny > 0 then
         self.speed_y = 0
      end
   end
end

function Player:land(collision)
   self.currentGroundCollision = collision
   self.speed_y = 0
   self.grounded = true
   self.doubleJump = true
end

function Player:jump(key)
   if key == "up" then
      if self.grounded then
         self.speed_y = self.jumpAmount
      elseif self.doubleJump then
         self.doubleJump = false
         self.speed_y = self.jumpAmount * 0.8
      end
   end
end

function Player:lastContact(a, b, collision)
   if a == self.physics.fixture or b == self.physics.fixture then
      if self.currentGroundCollision == collision then
         self.grounded = false
      end
   end
end

function Player:draw()
   local scaleX = 1
   if self.direction == "left" then
      scaleX = -1
   end
   love.graphics.setColor(self.color.r, self.color.g, self.color.b)
   love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
   love.graphics.setColor(1,1,1,1)
end

return Player
