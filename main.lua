projection = require("lib/projection")
fov = 3000
love.graphics.setDefaultFilter("nearest", "nearest")
sprites = require("src/sprites")
require("lib")
love.keypressed = function(self, key, isrepeat)
  return state:press(key)
end
love.keyreleased = function(self, key, isrepeat)
  return state:release(key)
end
