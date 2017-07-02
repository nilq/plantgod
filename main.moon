export projection = require "lib/projection"
export fov        = 3000

sound_player = require "src/player/sound"

love.graphics.setDefaultFilter "nearest", "nearest"

export sprites = require "src/sprites"

require "lib"

love.keypressed = (key, isrepeat) =>
  state\press key

love.keyreleased = (key, isrepeat) =>
  state\release key

sound_player\start_music!