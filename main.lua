screenWidth = nil
screenHeight = nil
playerImg = nil -- for storage
player = { x = 200, y = 510, speed = 150, img = nil, tankMax = 5, refilRate = 1}
player.tank = player.tankMax

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}
sea = {}

function love.load(arg)
    love.window.setMode(800, 800)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    player.img = love.graphics.newImage('aircrafts/Aircraft_03.png')
    bulletImg = love.graphics.newImage('aircrafts/bullet_2_blue.png')
    player.velocity = 0
    player.gravity = 400
    player.move_speed = -200
    sea = { h = 200, w = screenWidth, y = screenHeight - 200, x = 0, img = nil}
end

function love.update(dt)
    print(player.tank)
    inWater = playerInWater(player, sea)
    -- player.velocity = 0
    player.velocity = player.gravity
    player.move_speed = -200
    if inWater then
        player.tank = player.tank + dt * 2
        if player.tank >= player.tankMax then
            player.tank = player.tankMax
        end
        player.velocity = 0
        player.move_speed = -100
    end
    playerWidth = player.img:getWidth()
    playerHeight = player.img:getHeight()
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end
    if love.keyboard.isDown('left', 'a') and player.tank > 0 then
        if player.x > 0 then
            player.x = player.x - (player.speed*dt)
            if inWater == false then
                player.tank = player.tank - dt * 2
            end
            player.velocity = 0
        end
    elseif love.keyboard.isDown('right', 'd') and player.tank > 0 then 
        if player.x < (screenWidth - playerWidth) then
            player.x = player.x + (player.speed*dt)
            if inWater == false then
                player.tank = player.tank - dt * 2
            end
            player.velocity = 0
        end
    end
    if love.keyboard.isDown('up', 'w') and player.tank > 0 then
        player.velocity = player.move_speed
        if inWater == false then
            player.tank = player.tank - dt * 2
        end
    elseif love.keyboard.isDown('down', 's') and inWater then 
        player.velocity = -1 * player.move_speed
    end
    
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


function playerInWater(player, water)
    if (player.x < water.x) then
        return false
    end
    if (player.x + player.img:getWidth() > water.x + water.w) then
        return false
    end
    if (player.y < water.y) then
        return false
    end
    if (player.y + player.img:getHeight() > water.y + water.h) then
        return false
    end

    return true
end
