local level = {
  grid_size = 24,
  default = {
    ["dirt"] = {
      0,
      0,
      0
    },
    ["stone"] = {
      81,
      81,
      81
    },
    ["god"] = {
      255,
      255,
      0
    },
    ["skunk"] = {
      0,
      200,
      0
    }
  }
}
local player = require("src/player")
local props = require("src/props")
local plants = require("src/plants")
local block = props.block
do
  level.load = function(path, make_entity)
    if make_entity == nil then
      make_entity = level.make_entity
    end
    local image = love.image.newImageData(path)
    for x = 1, image:getWidth() do
      local row = { }
      for y = 1, image:getHeight() do
        local rx, ry = x - 1, y - 1
        local r, g, b = image:getPixel(rx, ry)
        for k, v in pairs(level.default) do
          if r == v[1] and g == v[2] and b == v[3] then
            make_entity(k, level.grid_size * rx, level.grid_size * ry)
          end
        end
      end
    end
  end
  level.make_entity = function(k, x, y)
    local _exp_0 = k
    if "god" == _exp_0 then
      local a = player.make(x, y, game.z - 5)
      game:spawn(a)
      world:add(a, a.pos[1], a.pos[2], a.w, a.h)
      game.players[#game.players + 1] = a
    elseif "dirt" == _exp_0 then
      local a = block.make(x, y, game.z, k)
      game:spawn_back(a)
      return world:add(a, a.pos[1], a.pos[2], a.w, a.h)
    elseif "stone" == _exp_0 then
      local a = block.make(x, y, game.z, k)
      game:spawn_back(a)
      return world:add(a, a.pos[1], a.pos[2], a.w, a.h)
    elseif "skunk" == _exp_0 then
      local a = plants.make(x, y, game.z - 5, plants.settings.skunk)
      return game:spawn(a)
    end
  end
end
return level
