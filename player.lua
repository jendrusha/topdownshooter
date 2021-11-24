Player = {}
PlayerMT = {__index = Player}

local privates = {}

function Player.new()
  local self = setmetatable({}, PlayerMT)

  privates[self] = {
    posX = love.graphics.getWidth()/2,
    posY = love.graphics.getHeight()/2,
    image = require("sprites").player,
    speed = 180,
  }

  return self
end

function Player:getX()
  return privates[self].posX
end

function Player:setX(x)
  privates[self].posX = x
end

function Player:getY()
  return privates[self].posY
end

function Player:setY(y)
  privates[self].posY = y
end

function Player:getSpeed()
  return privates[self].speed
end

function Player:getImage()
  return privates[self].image
end

function Player:setToCenterOfView()
    player:setX(love.graphics.getWidth() / 2)
    player:setY(love.graphics.getHeight() / 2)
end

function Player:getMouseAngle()
  return math.atan2(self:getY() - love.mouse.getY(), self:getX() - love.mouse.getX()) + math.pi
end

function Player:draw()
  local image = self:getImage()
  love.graphics.draw(
    image,
    self:getX(),
    self:getY(),
    self:getMouseAngle(),
    nil,
    nil,
    image:getWidth() / 2,
    image:getHeight() / 2
  )
end

function Player:setKeybindings(dt)
  if love.keyboard.isDown("d") and self:getX() < love.graphics.getWidth() - 10 then
    self:setX(self:getX()+self:getSpeed()*dt)
  end
  if love.keyboard.isDown("a") and self:getX() > 10 then
    self:setX(self:getX()-self:getSpeed()*dt)
  end
  if love.keyboard.isDown("w") and self:getY() > 10 then
    self:setY(self:getY()-self:getSpeed()*dt)
  end
  if love.keyboard.isDown("s") and self:getY() < love.graphics.getHeight() - 10 then
    self:setY(self:getY()+self:getSpeed()*dt)
  end
end
