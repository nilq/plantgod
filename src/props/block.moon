color = {
  dirt:  {111, 63, 20}
  sand:  {189, 197, 150}
  bark:  {100, 52, 34}
  stone: {81, 81, 81}
}

make = (x, y, z, name) ->
  block = {
    pos: {
      [1]: x
      [2]: y
      [3]: z
    }
    :name
  }

  block.w = 24
  block.h = 24

  block.draw = =>
    @draw_pos = {
      game.x + @pos[1]
      game.y + @pos[2]
      @pos[3]
    }

    with projection.graphics
      love.graphics.setColor 255, 255, 255
      .draw fov, sprites.textures[@name], {@draw_pos[1], @draw_pos[2], @draw_pos[3] - 20}, 0, 1.55, 1.55

  block.drawb = =>
    @draw_pos = {
      game.x + @pos[1]
      game.y + @pos[2]
      @pos[3]
    }

    with projection.graphics
      love.graphics.setColor color[@name]
      .cube fov, "fill", {@draw_pos[1], @draw_pos[2] + @h, @draw_pos[3] - @w}, @w, @h, 10

  block

{
  :make
}