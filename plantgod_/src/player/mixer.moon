make = (slots, x, z) ->
  mixer = {
    default: {
      "left": -1
      "right": 1
    }
  }

  with mixer
    .slots = {}
    for i = 1, slots
      .slots[#.slots + 1] = 0
  
  mixer.draw = =>
    with projection.graphics
      love.graphics.setColor 200, 200, 200
      for i = 1, #@slots
        if @slots[i] == -1
          love.graphics.setColor 255, 200, 200
        elseif @slots[i] == 1
          love.graphics.setColor 200, 200, 255
        else
          love.graphics.setColor 255, 255, 255

        .square3d fov, "fill", {i * 4 + i * 32, love.graphics.getHeight! / 2.75, z}, 32, 32

        love.graphics.setColor 200, 200, 200
        .square3d fov, "line", {i * 4 + i * 32, love.graphics.getHeight! / 2.75, z}, 32, 32

  mixer.press = (key) =>
    if key == "return"
      for i = 1, #@slots
        @slots[i] = 0

    if @default[key]
      for i = 1, #@slots
        if @slots[i] == 0
          @slots[i] = @default[key]
          break

  mixer

{
  :make
}