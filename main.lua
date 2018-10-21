playerImg = nil -- for storage
player = { x = 200, y = 510, speed = 150, img = nil}
screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

sea = { h = 200, w = screenWidth, y = screenHeight - 200, x = 0, img = nil}

function love.load(arg)
    player.img = love.graphics.newImage('aircrafts/Aircraft_03.png')
    bulletImg = love.graphics.newImage('aircrafts/bullet_2_blue.png')
    player.velocity = 0
    player.gravity = 100
    player.move_speed = -200
end

function love.update(dt)
    -- player.velocity = 0
    player.velocity = player.gravity
    playerWidth = player.img:getWidth()
    playerHeight = player.img:getHeight()
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end
    if love.keyboard.isDown('left', 'a') then
        if player.x > 0 then
            player.x = player.x - (player.speed*dt)
            player.velocity = 0
        end
    elseif love.keyboard.isDown('right', 'd') then 
        if player.x < (screenWidth - playerWidth) then
            player.x = player.x + (player.speed*dt)
            player.velocity = 0
        end
    end
    if love.keyboard.isDown('up', 'w') then
        player.velocity = player.move_speed
    end
    -- elseif love.keyboard.isDown('down', 's') then 
    --     player.y = player.y + (player.speed*dt)
    -- end
    
    if player.velocity ~= 0 then 
        player.y = player.y + player.velocity * dt
        -- player.velocity = player.velocity - player.gravity * dt 
    end

    if (player.y + playerHeight) >= screenHeight then 
        -- player.velocity = 0
        player.y = screenHeight - playerHeight
    end

    -- canShootTimer = canShootTimer - (1 * dt)
    -- if canShootTimer < 0 then
    -- canShoot = true
    -- end
    -- if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
    --     newBullet = { x = player.x + (playerWidth / 2), y = player.y, img = bulletImg}
    --     table.insert(bullets, newBullet)
    --     canShoot = false
    --     canShootTimer = canShootTimerMax
    -- end
    -- for i, bullet in ipairs(bullets) do
    --     bullet.y = bullet.y - (250 * dt)

    --     if bullet.y < 0 then
    --         table.remove (bullets, i)
    --     end
    -- end
 end

-- function love.keypressed(key)
    
-- end

function love.draw(dt)
    love.graphics.setColor(16/255, 110/255, 232/255, 1)
    love.graphics.rectangle("fill", sea.x, sea.y, sea.w, sea.h)
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.draw(player.img, player.x, player.y)
    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end