local color = {
  dirt = {
    111,
    63,
    20
  },
  sand = {
    189,
    197,
    150
  },
  bark = {
    100,
    52,
    34
  },
  stone = {
    81,
    81,
    81
  }
}
local make
make = function(x, y, z, name)
  local block = {
    pos = {
      [1] = x,
      [2] = y,
      [3] = z
    }
  }
  block.w = 24
  block.h = 24
  block.draw = function(self)
    self.draw_pos = {
      game.x + self.pos[1],
      game.y + self.pos[2],
      self.pos[3]
    }
    do
      local _with_0 = projection.graphics
      love.graphics.setColor(255, 255, 255)
      _with_0.draw(fov, sprites.textures[name], {
        self.draw_pos[1],
        self.draw_pos[2],
        self.draw_pos[3] - 20
      }, 0, 3.1, 3.1)
      return _with_0
    end
  end
  block.drawb = function(self)
    self.draw_pos = {
      game.x + self.pos[1],
      game.y + self.pos[2],
      self.pos[3]
    }
    do
      local _with_0 = projection.graphics
      love.graphics.setColor(color[name])
      _with_0.cube(fov, "fill", {
        self.draw_pos[1],
        self.draw_pos[2] + self.h,
        self.draw_pos[3] - self.w
      }, self.w, self.h, 10)
      return _with_0
    end
  end
  return block
end
return {
  make = make
}
