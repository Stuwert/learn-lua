player = { 
    x = 200, 
    y = 510, 
    speed = 100, 
    img = nil, 
    tankMax = 10, 
    refilRate = 1, 
    yEnd = nil, 
    xEnd = nil, 
    inWater = false,
    playerUnderwaterAccel = 15,
    canShootTimerMax = .2,
    canShootTimer = 0,
    currentXVelo = 0,
    currentYVelo = 0,
}

local maxVelocity = 150

local directionToRotation = {
    up = {
        xAccel        = 0,
        yAccel        = -200,
        playerGravity = 100,
    },
    left = {
        xAccel        = -100,
        yAccel        = 0,
        playerGravity = 0,
    },
    right = {
        xAccel        = 100,
        yAccel        = 0,
        playerGravity = 0,
    },
    none = {
        xAccel        = 0,
        yAccel        = 0,
        playerGravity = 100,
    }
}

player.currentAcceleration = directionToRotation.none

local velocity = {
    xAxis = 0,
    yAxis = 0,
}

player.tank = player.tankMax

local function calculateVelocity(currentVelocity, acceleration, dt)
    return currentVelocity + acceleration * dt
end

local function calculatePosition(currentPosition, velocity, dt)
    return currentPosition + velocity * dt
end

function player:canShoot(dt)
    self.canShootTimer = self.canShootTimer - dt
    print(self.canShootTimer)
    if self.canShootTimer <= 0 then
        self.canShootTimer = self.canShootTimerMax
        return true
    end
    return false
end

function player:accelerate(direction)
    print(direction)
    self.currentAcceleration = directionToRotation[direction]
    print(self.currentAcceleration.xAccel)
    print(self.currentAcceleration.yAccel)
    print(self.currentAcceleration.playerGravity)
end

function player:move(dt)
    self.currentXVelo = calculateVelocity(
        self.currentXVelo,
        self.currentAcceleration.xAccel,
        dt
    )
    print('x velo is')
    print(self.currentXVelo)
    self.currentYVelo = calculateVelocity(
        self.currentYVelo,
        self.currentAcceleration.yAccel,
        dt
    )
    print('y velo is')
    print(self.currentYVelo)
    self.currentYVelo = calculateVelocity(
        self.currentYVelo,
        self.currentAcceleration.playerGravity,
        dt
    )
    print('y velo is')
    print(self.currentYVelo)
    self.x = calculatePosition(
        self.x,
        self.currentXVelo,
        dt
    )
    self.y = calculatePosition(
        self.y,
        self.currentYVelo,
        dt
    )
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