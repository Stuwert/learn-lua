playerImg = nil -- for storage
player = { x = 200, y = 710, speed = 150, img = nil}
screenWidth = love.graphics.getWidth()

function love.load(arg)
    player.img = love.graphics.newImage('aircrafts/Aircraft_03.png')
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end
    if love.keyboard.isDown('left', 'a') then
        if player.x > 0 then
            player.x = player.x - (player.speed*dt)
        end
    elseif love.keyboard.isDown('right', 'd') then 
        if player.x < (screenWidth - player.img:getWidth()) then
            player.x = player.x + (player.speed*dt)
        end
    end
    if love.keyboard.isDown('up', 'w') then
        player.y = player.y - (player.speed*dt)
    elseif love.keyboard.isDown('down', 's') then 
        player.y = player.y + (player.speed*dt)
    end
end

-- function love.keypressed(key)
    
-- end

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
end