level = {
  grid_size: 20
  default: {
    "dirt":  {0, 0, 0}
    "god":   {255, 255, 0}
    "skunk": {0, 200, 0}
  }
}

player = require "src/player"
props  = require "src/props"
plants = require "src/plants"

block  = props.block

with level
  .load = (path, make_entity=.make_entity) ->
    image = love.image.newImageData path

    for x = 1, image\getWidth!
      row = {}
      for y = 1, image\getHeight!

        rx, ry = x - 1, y - 1
        r, g, b = image\getPixel rx, ry

        for k, v in pairs .default
          if r == v[1] and g == v[2] and b == v[3]
            make_entity k, .grid_size * rx, .grid_size * ry

  .make_entity = (k, x, y) ->
    switch k
      when "god"
        a = player.make x, y, game.z
        game\spawn a
        world\add a, a.pos[1], a.pos[2], a.w, a.h
      
      when "dirt"
        a = block.make x, y, game.z
        game\spawn a
        world\add a, a.pos[1], a.pos[2], a.w, a.h
      
      when "skunk"
        a = plants.make x, y, game.z, {
          w: 8
          h: 25
          touchable: true
          tags: {"pick"}
          on_pick: =>
            game.camera.r += util.randf -.5, .5

            world\remove @
            game\remove  @
        }
        game\spawn a

level