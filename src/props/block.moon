make = (x, y, z) ->
  block = {
    pos: {
      [1]: x
      [2]: y
      [3]: z
    }
  }

  block.w = 20
  block.h = 20

  block.draw = =>
    with projection.graphics
      love.graphics.setColor 200, 200, 200
      .square3d fov, "fill", @pos, @w, @h

      love.graphics.setColor 150, 150, 150
      .square3d fov, "line", @pos, @w, @h

  block

{
  :make
}