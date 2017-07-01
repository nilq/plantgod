local plants = require("src/plants")
local make
make = function(slots, x, z)
  local mixer = {
    default = {
      ["left"] = -1,
      ["right"] = 1,
      ["up"] = 2,
      ["down"] = -2
    },
    combinations = {
      skunk = "-1, 2, -1, -2",
      shrub = "-1, -1, -1, -1"
    }
  }
  do
    mixer.slots = { }
    for i = 1, slots do
      mixer.slots[#mixer.slots + 1] = 0
    end
  end
  mixer.draw = function(self)
    love.graphics.push()
    love.graphics.scale(2.5, 2.5)
    do
      local _with_0 = projection.graphics
      love.graphics.setColor(200, 200, 200)
      for i = 1, #self.slots do
        if self.slots[i] == -1 then
          love.graphics.setColor(255, 200, 200)
        elseif self.slots[i] == 1 then
          love.graphics.setColor(200, 200, 255)
        elseif self.slots[i] == 2 then
          love.graphics.setColor(255, 200, 255)
        elseif self.slots[i] == -2 then
          love.graphics.setColor(200, 255, 255)
        else
          love.graphics.setColor(255, 255, 255)
        end
        x = i * 4 + i * 32 - 27
        local y = love.graphics.getHeight() / 2.5 - 40
        love.graphics.rectangle("fill", x, y, 32, 32)
        love.graphics.setColor(200, 200, 200)
        love.graphics.rectangle("line", x, y, 32, 32)
      end
    end
    return love.graphics.pop()
  end
  mixer.press = function(self, key)
    if key == "return" then
      for i = 1, #game.players do
        local p = game.players[i]
        for k, v in pairs(self.combinations) do
          local v0 = ""
          for j = 1, #self.slots do
            v0 = v0 .. self.slots[j]
            if not (j == #self.slots) then
              v0 = v0 .. ", "
            end
          end
          if v0 == v then
            local setting = plants.settings[k]
            local a = plants.make(p.pos[1] + p.w / 2 - setting.w / 2, p.pos[2] - p.h * 1.5, game.z, setting)
            a.dy = p.dy * 2.25
            a.dx = p.dx * 1.5
            game:spawn(a)
            break
          end
        end
      end
      for i = 1, #self.slots do
        self.slots[i] = 0
      end
    end
    if self.default[key] then
      for i = 1, #self.slots do
        if self.slots[i] == 0 then
          self.slots[i] = self.default[key]
          break
        end
      end
    end
  end
  return mixer
end
return {
  make = make
}
