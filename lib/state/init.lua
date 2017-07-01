local state = {
  current = { },
  global = {
    update = { },
    draw = { }
  }
}
setmetatable(state, state)
state.new = function(self)
  return { }
end
state.set = function(self, path, args)
  if self.current.unload then
    self.current.unload()
  end
  local matches = { }
  for match in string.gmatch(path, "[^;]+") do
    matches[#matches + 1] = match
  end
  path = matches[1]
  package.loaded[path] = false
  self.current = require(path)
  return self
end
state.load = function(self)
  if self.current.load then
    self.current:load()
  end
  return self
end
state.update = function(self, dt)
  if self.current.update then
    self.current:update(dt)
  end
  return self
end
state.draw = function(self)
  if self.current.update then
    self.current:draw()
  end
  return self
end
state.press = function(self, key, isrepeat)
  if self.current.press then
    self.current:press(key, isrepeat)
  end
  return self
end
state.release = function(self, key, isrepeat)
  if self.current.release then
    self.current:release(key, isrepeat)
  end
  return self
end
return state
