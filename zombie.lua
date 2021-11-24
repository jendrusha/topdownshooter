Zombie = {}
ZombieMT = {__index = Zombie}

local privates = {}

function Zombie.new()
  local pos = {
    x = 0,
    y = 0,
  }

  local side = math.random(1, 4)

  if side == 1 then
    pos.x = -30
    pos.y = math.random(0, love.graphics.getHeight())
  end

  if side == 2 then
    pos.x = love.graphics.getWidth()+30
    pos.y = math.random(0, love.graphics.getHeight())
  end

  if side == 3 then
    pos.x = math.random(0, love.graphics.getWidth())
    pos.y = -30
  end

  if side == 4 then
    pos.x = math.random(0, love.graphics.getWidth())
    pos.y = love.graphics.getHeight()+30
  end

  local self = setmetatable({}, ZombieMT)

  privates[self] = {
    posX = pos.x,
    posY = pos.y,
    image = require("sprites").zombie,
    speed = 140,
    dead = false,
  }

  return self
end

function Zombie:setX(value)
  privates[self].posX = value
end

-- getX get X value
function Zombie:getX()
  return privates[self].posX
end

function Zombie:setY(value)
  privates[self].posY = value
end

-- getY get Y value
function Zombie:getY()
  return privates[self].posY
end

function Zombie:getImage()
  return privates[self].image
end

function Zombie:setDead(val)
  privates[self].dead = val
end

function Zombie:getDead()
  return privates[self].dead
end

function Zombie:isDead()
  return privates[self].dead == true
end

function Zombie:getSpeed()
  return privates[self].speed
end

function Zombie:getPlayerAngle(player)
  if type(player) ~= "table" then
    return error("Invalid player type, got: " .. type(player))
  end

  return math.atan2(player:getY() - self:getY(), player:getX() - self:getX())
end

function Zombie:setToPlayerDirection(player, dt)
  self:setX(self:getX()+(math.cos(self:getPlayerAngle(player))*self:getSpeed()*dt))
  self:setY(self:getY()+(math.sin(self:getPlayerAngle(player))*self:getSpeed()*dt))
end

function Zombie:draw(player)
  local image = self:getImage()

  love.graphics.draw(
    image,
    self:getX(),
    self:getY(),
    self:getPlayerAngle(player),
    nil,
    nil,
    image:getWidth() / 2,
    image:getHeight() / 2
  )
end
