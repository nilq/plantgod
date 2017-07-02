plants = require "src/plants"
sprites = require "src/sprites"

make = (slots, x, z) ->
  mixer = {
    default: {
      "left": -1
      "right": 1
      "up":    2
      "down": -2
    }

    combinations: {
      skunk: "-1, 2, -1, -2"
      shrub: "-1, -1, -1, -1"
      berry: "1, 1, -1, -1"
    }

    runes: {
      [0]: sprites.runes.blank
      [-1]: sprites.runes.l_rune
      [1]: sprites.runes.r_rune
      [-2]: sprites.runes.d_rune
      [2]: sprites.runes.u_rune
    }
  }

  with mixer
    .s = 48

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

        x = i * 4 + i * @s - 27
        y = love.graphics.getHeight! / 2.5 - 40 / (32 / @s)

        love.graphics.rectangle "fill", x, y, @s, @s
        love.graphics.draw @runes[@slots[i]], x, y, 0, @s/32, @s/32, -4, -4

        love.graphics.setColor 200, 200, 200
        love.graphics.rectangle "line", x, y, @s, @s

    love.graphics.pop!

  mixer.press = (key) =>
    if key == "backspace"
      for i = #@slots, 1, -1
        unless @slots[i] == 0
          @slots[i] = 0
          break

    if key == "return"
      for i = 1, #game.players
        p = game.players[i]

        v0 = ""
        for j = 1, #@slots
          v0 ..= @slots[j]
          v0 ..= ", " unless j == #@slots
        for k, v in pairs @combinations
          if v0 == v
            setting = plants.settings[k]

            a = plants.make p.pos[1] + p.w / 2 - setting.w / 2, p.pos[2] - p.h * 1.5, game.z, setting
            a.dy = p.dy * 2.25
            a.dx = p.dx * 1.5

            game\spawn a
            break

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