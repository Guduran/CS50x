
local Player = require "player"
local Coin = require "coin"
local HUD = require "hud"
local Trap = require "trap"
local Camera = require "camera"
local Stone = require "stone"
local Enemy = require "enemy"
local Boss = require "boss"
local Map = require "map"
local Music = require "music"

function love.load()
    Enemy.getAssets()
    Boss.getAssets()
    Map:load()
    background = love.graphics.newImage "assets/background.png"
    Player:load()
    HUD:load()
    Music:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Camera:setFocus(Player.x, 0)
    Coin:updateAll(dt)
    HUD:update(dt)
    Trap:updateAll(dt)
    Stone:updateAll(dt)
    Enemy.updateAll(dt)
    Boss.updateAll(dt)
    Map:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, 1.4, 1)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    
    Camera:main()
    Player:draw()
    Coin.drawAll()
    Trap.drawAll()
    Stone.drawAll()
    Enemy.drawAll()
    Boss.drawAll()
    Camera:clear()

    HUD:draw()
end

function love.keypressed(key)
    Player:jump(key)
    Music:playWhen(key)
end

function firstContact(a, b, collision)
    if Coin.firstContact(a, b, collision) then
        return
    end
    if Trap.firstContact(a, b, collision) then
        return
    end
    Boss.firstContact(a,b, collision)
    Enemy.firstContact(a, b, collision)
    Player:firstContact(a, b, collision)
end

function lastContact(a, b, collision)
    Player:lastContact(a, b, collision)
end
