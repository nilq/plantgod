local make
make = function(x, y, sx, sy, r)
  local cam = {
    pos = {
      [1] = x,
      [2] = y
    },
    scale = {
      [1] = sx,
      [2] = sy
    },
    r = r
  }
  cam.move = function(self, dx, dy)
    self.pos[1] = self.pos[1] + dx
    self.pos[2] = self.pos[2] + dy
    return cam
  end
  cam.set = function(self)
    do
      local _with_0 = love.graphics
      _with_0.push()
      _with_0.translate(_with_0.getWidth() / 2 - self.pos[1], _with_0.getHeight() / 2 - self.pos[2])
      _with_0.scale(self.scale[1], self.scale[2])
      _with_0.rotate(self.r)
    end
    return cam
  end
  cam.unset = function(self)
    love.graphics.pop()
    return cam
  end
  return cam
end
return {
  make = make
}
