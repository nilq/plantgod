local make
make = function(x, y, z, settings)
  local plant = {
    pos = {
      [1] = x,
      [2] = y,
      [3] = z
    },
    settings = settings
  }
  plant.tag = { }
  plant.w = 4
  plant.h = 5
  plant.frcx = 0.001
  plant.frcy = 2
  plant.dx = 0
  plant.dy = 0
  plant.gravity = 30
  plant.grounded = false
  plant.seed = true
  plant.update = function(self, dt)
    self.pos[1], self.pos[2], self.collisions = world:move(self, self.pos[1] + self.dx, self.pos[2] + self.dy)
    local _list_0 = self.collisions
    for _index_0 = 1, #_list_0 do
      local c = _list_0[_index_0]
      if self.seed then
        self:grow()
      end
      if self.settings.collide then
        self.settings:collide(c)
      end
      if c.normal.y ~= 0 then
        if c.normal.y == -1 then
          self.grounded = true
        end
        self.dy = 0
      end
      if c.normal.x ~= 0 then
        self.dx = 0
      end
      if c.other.tags then
        game:tag_check(c.other.tags, c.other, self)
      end
      if c.other.settings then
        if c.other.settings.tags then
          game:tag_check(c.other.settings.tags, c.other, self)
        end
      end
    end
    if self.grounded then
      self.dx = self.dx - ((self.dx / self.frcx) * dt)
    else
      self.dx = self.dx - ((self.dx / self.frcy) * dt)
    end
    self.dy = self.dy - ((self.dy / self.frcy) * dt)
    self.dy = self.dy + (self.gravity * dt)
  end
  plant.draw = function(self)
    self.draw_pos = {
      game.x + self.pos[1],
      game.y + self.pos[2],
      self.pos[3]
    }
    do
      local _with_0 = projection.graphics
      if self.seed then
        love.graphics.setColor(100, 255, 100)
        _with_0.square3d(fov, "fill", self.draw_pos, self.w, self.h)
      else
        love.graphics.setColor(255, 255, 255)
        _with_0.draw(fov, sprites.plants[self.settings.name], self.draw_pos, 0, 1.5, 1.5)
      end
      return _with_0
    end
  end
  plant.grow = function(self, settings)
    if settings == nil then
      settings = self.settings
    end
    if not (settings.touchable) then
      world:remove(self)
    else
      world:update(self, self.pos[1] - settings.w / 2, self.pos[2] - settings.h - self.h * 3, settings.w, settings.h)
    end
    local _list_0 = settings.tags
    for _index_0 = 1, #_list_0 do
      local tag = _list_0[_index_0]
      self.tag[#self.tag + 1] = tag
    end
    self.settings = settings
    self.w = settings.w
    self.h = settings.h
    self.seed = false
  end
  world:add(plant, plant.pos[1], plant.pos[2], plant.w, plant.h)
  return plant
end
local skunk = {
  name = "skunk",
  w = 24,
  h = 24,
  touchable = true,
  tags = {
    "pick"
  },
  on_pick = function(self)
    game.camera.r = game.camera.r + util.randf(-.5, .5)
    world:remove(self)
    return game:remove(self)
  end
}
local shrub = {
  name = "shrub",
  w = 24,
  h = 24,
  touchable = true,
  tags = {
    "touch"
  },
  on_touch = function(self, c)
    c.pos[2] = c.pos[2] - 1
    c.dy = -15
  end
}
return {
  make = make,
  settings = {
    skunk = skunk,
    shrub = shrub
  }
}
