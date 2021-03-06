function love.load()
  math.randomseed(os.time())

 distance_between = require("modules.utility").distance_between
 sprites = require("sprites")
 require("modules.collection")
 require("modules.player")
 require("modules.zombie")
 require("modules.bullet")

  zombies = Collection.new()
  bullets = Collection.new()
  player = Player.new()
  maxTime = 2
  state = {
    game = 1,
    maxTime = maxTime,
    timer = 2,
    score = 0,
  }
end

function love.update(dt)
  if state.game == 2 then
    player:setKeybindings(dt)
  end

  moveZombiesInPlayerDirection(player, dt)
  updateScoreAndKillZombieOnHit()
  removeZombieOnHit()

  bullets:each(function(_, b)
    b:move(dt)
  end)

  bullets:remove(function(b)
    return (
        b:getX() < 0 or
        b:getY() < 0 or
        b:getX() > love.graphics.getWidth() or
        b:getY() > love.graphics.getHeight()
      ) or
      b:isDead()
  end)

  if state.game == 2 then
    state.timer = state.timer - dt

    if state.timer <= 0 then
      zombies:add(Zombie.new())
      state.maxTime = 0.95 * state.maxTime
      state.timer = state.maxTime
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)

  if state.game == 1 then
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("Press enter to begin!", 0, 50, love.graphics.getWidth(), "center")
  end

  love.graphics.printf("Score: "..state.score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

  player:draw()

  zombies:each(function(_, z)
    z:draw(player)
  end)

  bullets:each(function(_, b)
    b:draw()
  end)
end

function love.keypressed(key)
  if key == "return" and state.game == 1 then
    state.maxTime = maxTime
    state.game = 2
    state.time = maxTime
    state.score = 0
  end
end
function love.mousepressed(_, _, button)
  if button == 1 and state.game == 2 then
    bullets:add(
      Bullet.new({
        x = player:getX(),
        y = player:getY(),
        angle = player:getMouseAngle(),
      })
    )
  end
end

function updateScoreAndKillZombieOnHit()
  zombies:each(function(_, z)
    bullets:each(function(_, b)
      if distance_between(z:getX(), z:getY(), b:getX(), b:getY()) < 20 then
        z:setDead(true)
        b:setDead(true)
        state.score = state.score + 1
      end
    end)
  end)
end

function removeZombieOnHit()
  zombies:remove(function(z)
    return z:isDead()
  end)
end

function moveZombiesInPlayerDirection(player, dt)
  zombies:each(function(_, z)
    z:setToPlayerDirection(player, dt)
    if distance_between(z:getX(), z:getY(), player:getX(), player:getY()) < 30 then
      zombies:destroy()
      state.game = 1
      player:setToCenterOfView()
    end
  end)
end
