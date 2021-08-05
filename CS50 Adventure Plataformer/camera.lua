local Camera = {
    x = 0,
    y = 0,
    scale = 2
}

function Camera:main()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setFocus(x, y)
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y
    local end_map = self.x + love.graphics.getWidth() / 2

    if self.x < 0 then
        self.x = 0
    elseif end_map > Map_Width then
        self.x = Map_Width - love.graphics.getWidth() / 2
    end
end

return Camera