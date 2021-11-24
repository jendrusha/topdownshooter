 Collection = {}
 CollectionMT = {__index =  Collection}

local privates = {}

function  Collection.new(items)
  items = items or {}
  local self = setmetatable({},  CollectionMT)
  privates[self] = items

  return self
end

function Collection:all()
  return privates[self]
end

function Collection:add(value)
  table.insert(privates[self], value)
end

function Collection:get(key)
  local item = nil

  for k, v in ipairs(privates[self]) do
    if privates[self][k][key] ~= nil then
      item = v[key]
    end
  end

  return item
end

function Collection:delete(key)
  for i=#privates[self], 1, -1 do
    if i == key then
      table.remove(privates[self], i)
    end
  end
end

function Collection:destroy()
  privates[self] = {}
end

function Collection:filter(callback)
  local items = {}

  for i=#privates[self], 1, -1 do
    if callback(privates[self][i]) then
      table.insert(items, privates[self][i])
    end
  end

  return Collection.new(items)
end

function Collection:remove(callback)
  for i=#privates[self], 1, -1 do
    if callback(privates[self][i]) then
      table.remove(privates[self], i)
    end
  end
end

function Collection:each(callback)
  for k, v in ipairs(privates[self]) do
    callback(k, v)
  end
end

function Collection:length()
  return #privates[self]
end
