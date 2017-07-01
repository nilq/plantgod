game = { }
local mixer = require("src/player/mixer")
local level = require("src/level")
local camera = require("src/camera")
game.load = function(self)
  self.x = 0
  self.y = 0
  self.z = -1000
  self.mixer = mixer.make(4, 100, self.z)
  self.things = { }
  self.thingsb = { }
  self.players = { }
  self.camera = camera.make(0, 0, 1, 1, 0)
  return level.load("res/level.png")
end
game.tag_check = function(self, tags, a, ...)
  for _index_0 = 1, #tags do
    local tag = tags[_index_0]
    if a["on_" .. tag] then
      a["on_" .. tag](a, ...)
    elseif a.settings["on_" .. tag] then
      a.settings["on_" .. tag](a, ...)
    else
      error("undefined trigger!!! >:(")
    end
  end
end
game.remove = function(self, a)
  local i = 1
  local _list_0 = self.things
  for _index_0 = 1, #_list_0 do
    local aa = _list_0[_index_0]
    if aa == a then
      table.remove(self.things, i)
      break
    end
    i = i + 1
  end
end
game.spawn = function(self, a)
  self.things[#self.things + 1] = a
end
game.spawn_back = function(self, a)
  self.thingsb[#self.thingsb + 1] = a
end
game.update = function(self, dt)
  self.camera.r = util.lerp(self.camera.r, 0, dt * 4)
  local _list_0 = self.things
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local thing = _list_0[_index_0]
      if not (thing) then
        _continue_0 = true
        break
      end
      if thing.update then
        thing:update(dt)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end
game.draw = function(self)
  local _list_0 = self.thingsb
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local thingb = _list_0[_index_0]
      if not (thingb) then
        _continue_0 = true
        break
      end
      if thingb.drawb then
        thingb:drawb()
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  local _list_1 = self.thingsb
  for _index_0 = 1, #_list_1 do
    local _continue_0 = false
    repeat
      local thingb = _list_1[_index_0]
      if not (thingb) then
        _continue_0 = true
        break
      end
      if thingb.draw then
        thingb:draw()
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  local _list_2 = self.things
  for _index_0 = 1, #_list_2 do
    local _continue_0 = false
    repeat
      local thing = _list_2[_index_0]
      if not (thing) then
        _continue_0 = true
        break
      end
      if thing.draw then
        thing:draw()
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  self.mixer:draw()
  do
    local _with_0 = love.graphics
    _with_0.setColor(100, 100, 100)
    _with_0.print(tostring(love.timer.getFPS()) .. "FPS\n" .. tostring((string.format("%.4f", love.timer.getDelta()))) .. "dt", 10, 10, 0, 5, 5)
    return _with_0
  end
end
game.press = function(self, key)
  if key == "r" then
    game:load()
  end
  local _list_0 = self.things
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local thing = _list_0[_index_0]
      if not (thing) then
        _continue_0 = true
        break
      end
      if thing.press then
        thing:press(key)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  return self.mixer:press(key)
end
game.release = function(self, key)
  local _list_0 = self.things
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local thing = _list_0[_index_0]
      if not (thing) then
        _continue_0 = true
        break
      end
      if thing.release then
        thing:release(key)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end
return game
