waterjet = {}

local directionToRotation = {
    up = {
        xVelo    = 0,
        yVelo    = 1,
        rotation = 0
    },
    down = {
        xVelo    = 0,
        yVelo    = - 1,
        rotation = math.pi
    },
    left = {
        xVelo    = -1,
        yVelo    = 0,
        rotation = math.pi * 3 / 2
    },
    right = {
        xVelo    = 1,
        yVelo    = 0,
        rotation = math.pi / 2
    },
}

-- x velocity direction
-- y velocity direction 
-- rotation value 

-- if up 

function waterjet:new(startingLocation, direction)
    rotationObj = directionToRotation[direction]
    o = {
        x = startingLocation.x,
        y = startingLocation.y,
        magnitude = 250,
        img = nil,
        rotation = 0,
        xVelo = rotationObj.xVelo,
        yVelo = rotationObj.yVelo,
        rotation = rotationObj.rotation,
    }
       -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function waterjet:move(dt)
    self.x = self.x + self.magnitude * dt * self.xVelo
    self.y = self.y + self.magnitude * dt * -1 * self.yVelo
end

return waterjet