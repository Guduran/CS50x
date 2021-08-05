local HUD = {}
local Player = require "player"

function HUD:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/coin.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.x = love.graphics.getWidth() - 170
    self.coins.y = 20

    self.lifes = {}
    self.lifes.img = love.graphics.newImage("assets/life.png")
    self.lifes.width = self.lifes.img:getWidth()
    self.lifes.height = self.lifes.img:getHeight()
    self.lifes.x = -30
    self.lifes.y = 20
    self.lifes.scale = 1.2
    self.lifes.spacing = self.lifes.width * self.lifes.scale + 20

    self.font = love.graphics.newFont("assets/font.ttf", 36)
    self.minorFont = love.graphics.newFont("assets/font.ttf", 18)
end

function HUD:update(dt)

end

function HUD:draw()
    self:displayCoins()
    self:displaylifes()
    self:displayHowToPlay()
end

function HUD:displaylifes()
    for i=1, Player.life.current do
        love.graphics.setColor(0,0,0,1)
        love.graphics.draw(self.lifes.img, self.lifes.x + self.lifes.spacing * i, self.lifes.y, 0, self.lifes.scale, self.lifes.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.lifes.img, self.lifes.x + self.lifes.spacing * i, self.lifes.y, 0, self.lifes.scale, self.lifes.scale)
    end
end

function HUD:displayHowToPlay()
    love.graphics.setFont(self.minorFont)
    love.graphics.print("WELCOME, use arrow keys to move.", 535,5)
    love.graphics.print("When the hearts run out, you will come back from the beginning.", 450,30)
    love.graphics.print("Reach the end of the map to advanced. GOOD LUCK", 500,55)
end

function HUD:displayCoins()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, 2, 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, 2, 2)

    love.graphics.setFont(self.font)
    love.graphics.setColor(0,1,0,1)
    love.graphics.print(" : " ..Player.coins, (self.coins.x + self.coins.width * 1.51) + 2, (self.coins.y + self.coins.height / 2 * 1.5 - self.font:getHeight() / 2) + 2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(" : " ..Player.coins, (self.coins.x + self.coins.width * 1.5) + 2, (self.coins.y + self.coins.height / 2 * 1.5 - self.font:getHeight() / 2) + 2)
end

return HUD