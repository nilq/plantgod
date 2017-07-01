make = (slots, x, z) ->
  mixer = {
    default: {
      "left": -1
      "right": 1
      "up":    2
      "down": -2
    }
  }

  with mixer
    .slots = {}
    for i = 1, slots
      .slots[#.slots + 1] = 0
  
  mixer.draw = =>
    love.graphics.push!
    love.graphics.scale 2.5, 2.5
    with projection.graphics
      love.graphics.setColor 200, 200, 200
      for i = 1, #@slots
        if @slots[i] == -1
          love.graphics.setColor 255, 200, 200
        elseif @slots[i] == 1
          love.graphics.setColor 200, 200, 255
        elseif @slots[i] == 2
          love.graphics.setColor 255, 200, 255
        elseif @slots[i] == -2
          love.graphics.setColor 200, 255, 255
        else
          love.graphics.setColor 255, 255, 255

        x = i * 4 + i * 32 - 27
        y = love.graphics.getHeight! / 2.5 - 40

        love.graphics.rectangle "fill", x, y, 32, 32

        love.graphics.setColor 200, 200, 200
        love.graphics.rectangle "line", x, y, 32, 32

    love.graphics.pop!

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