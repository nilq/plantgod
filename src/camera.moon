make = (x, y, sx, sy, r) ->
   cam = {
     pos: {
       [1]: x
       [2]: y
     }

     scale: {
       [1]: sx
       [2]: sy
     }

     :r
   }

   cam.move = (dx, dy) =>
    @pos[1] += dx
    @pos[2] += dy
    cam

   cam.set = =>
    with love.graphics
      .push!
      .translate .getWidth! / 2 - @pos[1], .getHeight! / 2 - @pos[2]
      .scale @scale[1], @scale[2]
      .rotate @r
    cam

   cam.unset = =>
    love.graphics.pop!
    cam

   cam

{
  :make
}