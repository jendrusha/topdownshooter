function love.load()
  math.randomseed(os.time())

 distance_between = require("utility").distance_between
 require("player")
 require("zombie")
 require("bullet")

  zombies = {}
  bullets = {}
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

  for _, b in ipairs(bullets) do
    b:move(dt)
  end

  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b:getX() < 0 or b:getY() < 0 or b:getX() > love.graphics.getWidth() or b:getY() > love.graphics.getHeight() then
      table.remove(bullets, i)
    end
  end

  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b:isDead() then
      table.remove(bullets, i)
    end
  end

  if state.game == 2 then
    state.timer = state.timer - dt

    if state.timer <= 0 then
      table.insert(zombies, Zombie.new())
      state.maxTime = 0.95 * state.maxTime
      state.timer = state.maxTime
    end
  end
end

function love.draw()
  love.graphics.draw(require("sprites").background, 0, 0)

  if state.game == 1 then
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("Press enter to begin!", 0, 50, love.graphics.getWidth(), "center")
  end

  love.graphics.printf("Score: "..state.score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

  player:draw()

  for _, z in ipairs(zombies) do
    z:draw(player)
  end

  for _, b in ipairs(bullets) do
    b:draw()
  end
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
    table.insert(bullets, Bullet.new({
      x = player:getX(),
      y = player:getY(),
      angle = player:getMouseAngle(),
    }))
  end
end

function updateScoreAndKillZombieOnHit()
  for _, z in ipairs(zombies) do
    for _,b in ipairs(bullets) do
      if distance_between(z:getX(), z:getY(), b:getX(), b:getY()) < 20 then
        z:setDead(true)
        b:setDead(true)
        state.score = state.score + 1
      end
    end
  end
end

function removeZombieOnHit()
  for i=#zombies, 1, -1 do
    local z = zombies[i]
    if z:isDead() then
      table.remove(zombies, i)
    end
  end
end

function moveZombiesInPlayerDirection(player, dt)
  for _, z in ipairs(zombies) do
    z:setToPlayerDirection(player, dt)
    if distance_between(z:getX(), z:getY(), player:getX(), player:getY()) < 30 then
      zombies = {}
      state.game = 1
      player:setToCenterOfView()
    end
  end
end
