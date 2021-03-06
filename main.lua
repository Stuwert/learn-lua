screenWidth = nil
screenHeight = nil
playerImg = nil -- for storage
player = require "player"
waterjet = require "waterjet"

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

gravityAccel = 9.8

bulletImg = nil

bullets = {}
sea = {}
jets = { content = {} }

function jets:moveSpray(dt)
    for i, jet in ipairs(self.content) do
        jet:move(dt)
        if jet:isNotOnScreen() == true then
            table.remove(self.content, i)
        end
    end
end


function love.load(arg)
    love.window.setMode(800, 800)
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    player.img = love.graphics.newImage('octopus.png')
    player.screenWidth = screenWidth
    player.screenHeight = screenHeight
    waterjet.img = love.graphics.newImage('waterdrop.png')
    player.velocity = 0
    player.gravity = 400
    sea = { yEnd = screenHeight, xEnd = screenWidth, y = screenHeight - 400, x = 0, img = nil}
end

function refillTank()
    player.tank = player.tankMax
end

function setWaterMoveSpeed()
    player.velocity = 0
    player.move_speed = -100
end

function love.update(dt)
    -- Things that need doing
    --[[
        Things that need doing:
        - If there is still velocity elsewhere, don't apply acceleration
    ]]--


    -- describe the loop

    -- set player in water
    -- refill tank/set water move speed

    -- check player inputs
        -- if movement input, cancel gravity
        -- apply accel
    -- calculate velocity
        -- apply velo max
    -- calculate position
        -- apply position maxes
    -- calculate screen location
    -- apply new position
    -- animate ?

    -- player.velocity = 0

    -- this feels like subscription is the correct methodology here
    -- certain events (verbs) fire, and then other events listen to them.


    -- Objects: gameSpace, player, waterJets, ocean
    -- am I over-architecting this?  probably.

    jets:moveSpray(dt)

    player.velocity = player.gravity
    player.move_speed = -200

    if player:collidedWith(sea) then
        refillTank()
        setWaterMoveSpeed()
    end

    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end

    if love.keyboard.isDown('left', 'a') and player.tank > 0 then
        if player.x > 0 then
            player:accelerate('left')
            if player:collidedWith(sea) == false then
                player.tank = player.tank - dt * 2
                if player:canShoot(dt) then
                    newWaterJet = waterjet:new(player:getPlayerCenter(), 'right')
                    table.insert(jets.content, newWaterJet)
                end
            end
            player.velocity = 0
        end
    elseif love.keyboard.isDown('right', 'd') and player.tank > 0 then
        if player.x < (screenWidth - player:getWidth()) then
            player:accelerate('right')
            if player:collidedWith(sea) == false then
                player.tank = player.tank - dt * 2
                if player:canShoot(dt) then
                    newWaterJet = waterjet:new(player:getPlayerCenter(), 'left')
                    table.insert(jets.content, newWaterJet)
                end
            end
            player.velocity = 0
        end
    elseif love.keyboard.isDown('up', 'w') and player.tank > 0 then
        player:accelerate('up')
        if player:collidedWith(sea) == false then
            if player:canShoot(dt) then
                newWaterJet = waterjet:new(player:getPlayerCenter(), 'down')
                table.insert(jets.content, newWaterJet)
            end
        end
    else
        -- if player:collidedWith(sea) == false then
            player:accelerate('none')
        -- end
    end

    player:move(dt)

    if player.velocity ~= 0 then
        player.y = player.y + player.velocity * dt
        -- player.velocity = player.velocity - player.gravity * dt
    end

    if (player.y + player:getHeight()) >= screenHeight then
        -- player.velocity = 0
        player.y = screenHeight - player:getHeight()
    end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and player:canShoot(dt) then
        newWaterJet = waterjet:new(player:getPlayerCenter(), 'up')
        table.insert(jets.content, newWaterJet)
    end
 end

-- function love.keypressed(key)

-- end

function love.draw(dt)
    for i, jet in ipairs(jets.content) do
        love.graphics.draw(jet.img, jet.x, jet.y, jet.rotation)
    end
    love.graphics.setColor(16/255, 110/255, 232/255, 1)
    love.graphics.rectangle("fill", sea.x, sea.y, sea.xEnd - sea.x, sea.yEnd - sea.y)
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.draw(player.img, player.x, player.y)
end

function waterjet:isNotOnScreen()
    return self.x < 0 or self.y < 0
        or self.x > screenWidth or self.y > screenHeight
end
