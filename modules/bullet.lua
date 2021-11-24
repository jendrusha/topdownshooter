Bullet = {}
BulletMT = {__index = Bullet}

local privates = {}

function Bullet.new(opts)
  local self = setmetatable({}, BulletMT)
  privates[self] = {
    posX = opts.x,
    posY = opts.y,
    dead = false,
    speed = 500,
    direction = opts.angle,
    image = require("sprites").bullet,
  }

  return self
end

function Bullet:setX(x)
  privates[self].posX = x
end

function Bullet:getX()
  return privates[self].posX
end

function Bullet:setY(y)
  privates[self].posY = y
end

function Bullet:getY()
  return privates[self].posY
end

function Bullet:setDead(val)
  privates[self].dead = val
end

function Bullet:isDead()
  return privates[self].dead == true
end

function Bullet:getImage()
  return privates[self].image
end

function Bullet:getSpeed()
  return privates[self].speed
end

function Bullet:getDirection()
  return privates[self].direction
end

function Bullet:move(dt)
  self:setX(self:getX()+(math.cos(self:getDirection())*self:getSpeed()*dt))
  self:setY(self:getY()+(math.sin(self:getDirection())*self:getSpeed()*dt))
end

function Bullet:draw()
  local image = self:getImage()
  love.graphics.draw(
    image,
    self:getX(),
    self:getY(),
    nil,
    0.4,
    nil,
    image:getWidth()/2,
    image:getHeight()/2
  )
end
