player = { 
    x = 200, 
    y = 510, 
    speed = 100, 
    img = nil, 
    tankMax = 10, 
    refilRate = 1, 
    yEnd = nil, 
    xEnd = nil, 
    playerAccel = 25, 
    maxVelocity = 150,
    inWater = false,
    playerUnderwaterAccel = 15,
    canShootTimerMax = .2,
    canShootTimer = 0,
}

local directionToRotation = {
    up = {
        xVelo    = 0,
        yVelo    = 1,
    },
    down = {
        xVelo    = 0,
        yVelo    = - 1,
    },
    left = {
        xVelo    = -1,
        yVelo    = 0,
    },
    right = {
        xVelo    = 1,
        yVelo    = 0,
    },
}

player.tank = player.tankMax

function player:canShoot(dt)
    self.canShootTimer = self.canShootTimer - dt
    print(self.canShootTimer)
    if self.canShootTimer <= 0 then
        self.canShootTimer = self.canShootTimerMax
        return true
    end
    return false
end

function player:getXEnd()
    return self.x + self:getWidth()
end

function player:getYEnd()
    return self.y + self:getHeight()
end

function player:setInWater(inWater)
    self.inWater = inWater
end

function player:getAcceleration()
    if self.inWater then
        return self.playerUnderwaterAccel
    end
    return self.playerAccel
end

function player:getPlayerCenter()
    return {
        x = self.x + self:getWidth() / 2,
        y = self.y + self:getHeight() / 2,
    }
end

function player:getWidth()
    if self.img then
        return self.img:getWidth()
    end
    return nil
end

function player:getHeight()
    if self.img then
        return self.img:getHeight()
    end
    return nil
end

local function isIntersecting(obj1Start, obj1End, obj2Start, obj2End)
    return (obj1Start > obj2Start and obj1Start < obj2End) or 
        (obj1End > obj2Start and obj1End < obj2End)
end

function player:collidedWith(otherObj)
    return isIntersecting(self.x, self:getXEnd(), otherObj.x, otherObj.xEnd) and
        isIntersecting(self.y, self:getYEnd(), otherObj.y, otherObj.yEnd)
end

return player