local make
make = function(x, y, z)
  local player = {
    pos = {
      [1] = x,
      [2] = y,
      [3] = z
    }
  }
  do
    player.w = 24
    player.h = 24
    player.acc = 20
    player.frcx = 0.12
    player.frcy = 2
    player.dx = 0
    player.dy = 0
    player.grounded = false
    player.gravity = 25
    player.jump = 8
    player.jumped = false
    player.airmul = 0.75
  end
  player.update = function(self, dt)
    self.grounded = false
    self.pos[1], self.pos[2], self.collisions = world:move(self, self.pos[1] + self.dx, self.pos[2] + self.dy)
    local _list_0 = self.collisions
    for _index_0 = 1, #_list_0 do
      local c = _list_0[_index_0]
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
    do
      local _with_0 = love.keyboard
      if _with_0.isDown("d") then
        if self.grounded then
          self.dx = self.dx + (self.acc * dt)
        else
          self.dx = self.dx + (self.airmul * self.acc * dt)
        end
      end
      if _with_0.isDown("a") then
        if self.grounded then
          self.dx = self.dx - (self.acc * dt)
        else
          self.dx = self.dx - (self.airmul * self.acc * dt)
        end
      end
      if _with_0.isDown("space") then
        if not (self.grounded) then
          self.dy = self.dy - (dt * self.gravity / 40)
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
    if self.dy >= 0 then
      self.jumped = false
    end
    return self:camera_follow(dt * 4)
  end
  player.get_real = function(self)
    local point, scale = projection.projectn(2, fov, self.pos)
    return {
      point[1] * scale,
      point[2] * scale
    }
  end
  player.camera_follow = function(self, t)
    local real_pos = self.pos
    do
      local _with_0 = game
      _with_0.x = util.lerp(_with_0.x, -real_pos[1] + love.graphics.getWidth() / 4, t)
      _with_0.y = util.lerp(_with_0.y, -real_pos[2] + love.graphics.getHeight() / 4, t / 2)
      return _with_0
    end
  end
  player.draw = function(self)
    self.draw_pos = {
      game.x + self.pos[1],
      game.y + self.pos[2],
      self.pos[3]
    }
    do
      local _with_0 = projection.graphics
      love.graphics.setColor(200, 255, 200)
      _with_0.square3d(fov, "fill", self.draw_pos, self.w, self.h)
      love.graphics.setColor(150, 150, 150)
      _with_0.square3d(fov, "line", self.draw_pos, self.w, self.h)
      return _with_0
    end
  end
  player.press = function(self, key)
    if self.grounded then
      if key == "space" then
        self.dy = -self.jump
        self.jumped = true
      end
    end
  end
  player.release = function(self, key)
    if self.jumped then
      if key == "space" then
        self.dy = 0
      end
    end
  end
  return player
end
return {
  make = make
}
