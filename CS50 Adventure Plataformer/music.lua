local Music = {}

function Music:load()
    backmusic = love.audio.newSource("assets/sfx/backmusic.mp3", "stream") --stream for music files
    backmusic:setVolume(0.6)
    backmusic:setLooping(true)
    backmusic:play()

    coin_song = love.audio.newSource("assets/sfx/coin.ogg", "static") --static for short sounds effects

    minotaur_song = love.audio.newSource("assets/sfx/minoroar.mp3", "static")

    hurt_song = love.audio.newSource("assets/sfx/hit.ogg", "static")
    hurt_song:setVolume(1.1)
    
    jump_song = love.audio.newSource("assets/sfx/jump.ogg", "static")
    jump_song:setVolume(0.7)

    demon_song = love.audio.newSource("assets/sfx/demonroar.mp3", "static")
end

function Music:playWhen(key)
    if key == "up" then
        jump_song:play()
    end
end

function Music:getHurts()
    hurt_song:play()
end

function Music:getCoin()
    coin_song:play()
end

function Music:getDemonRoar()
    demon_song:play()
end

function Music:getRoar()
    minotaur_song:play()
end

return Music