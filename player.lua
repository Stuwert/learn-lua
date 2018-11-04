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

local maxVelocity = 400

local directionToRotation = {
    up = {
        xAccel        = 0,
        yAccel        = -400,
        playerGravity = 100,
    },
    left = {
        xAccel        = -400,
        yAccel        = 0,
        playerGravity = 0,
    },
    right = {
        xAccel        = 400,
        yAccel        = 0,
        playerGravity = 0,
    },
    none = {
        xAccel        = 0,
        yAccel        = 0,
        playerGravity = 400,
    }
}

player.currentAcceleration = directionToRotation.none

local velocity = {
    xAxis = 0,
    yAxis = 0,
}

player.tank = player.tankMax

local function getDirection(value)
    if value == 0 then
        return 0
    end
    return math.abs(value) / value
end

local function isChangingDirections(currentVelocity, acceleration)
    return getDirection(currentVelocity) ~= getDirection(acceleration)
end

-- so the issue here

local function calculateVelocity(velocity, acceleration, dt)
    currentDirection = getDirection(velocity)
    print("direction is " .. currentDirection)
    -- if accel is 0 drop the velo to 0
    print('-----')
    print('velocity is ' .. velocity)
    -- slow down the current velocity
    if acceleration == 0 or isChangingDirections(velocity, acceleration) then
        magnitude = math.abs(velocity)
        velocity =  currentDirection * math.max(magnitude * .99 - 10, 0);
        print("new veloity is " .. velocity)
    end
    velocity = velocity + acceleration * dt
    print(velocity)
    magnitude = math.min(math.abs(velocity), maxVelocity)
    print(magnitude)
    return magnitude * getDirection(velocity) -- <- it's multiplying by 0 here on stops
    -- print(math.min(, maxVelocity) * getDirection(currentVelocity))
    -- return currentVelocity + acceleration * dt
    -- return math.min(math.abs(currentVelocity + acceleration * dt), maxVelocity) * getDirection(currentVelocity)
end

--[[
    f(v) = v / (1 + t) - 1
    f(v) = v - v ^ t
]]

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
    -- this might be where the mess is

    if self.currentYVelo == 0 then
        self.currentXVelo = calculateVelocity(
            self.currentXVelo,
            self.currentAcceleration.xAccel,
            dt
        )
    end

    if self.currentXVelo == 0 then
        self.currentYVelo = calculateVelocity(
            self.currentYVelo,
            self.currentAcceleration.yAccel,
            dt
        )
        self.currentYVelo = calculateVelocity(
            self.currentYVelo,
            self.currentAcceleration.playerGravity,
            dt
        )
    end

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