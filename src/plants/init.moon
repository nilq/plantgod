make = (x, y, z, settings) ->
  plant = {
    pos: {
      [1]: x
      [2]: y
      [3]: z - 5
    }
  }

  plant.tag      = {}
  plant.w        = 4
  plant.h        = 5
  plant.frcx     = 0.001
  plant.frcy     = 2
  plant.dx       = 0
  plant.dy       = 0
  plant.gravity  = 30
  plant.grounded = false
  plant.seed     = true
  plant.dirx     = nil

  plant.life    = 5
  plant.touched = false

  plant.update = (dt) =>
    @pos[1], @pos[2], @collisions = world\move @, @pos[1] + @dx, @pos[2] + @dy, game.filter

    if @seed and @touched
      @life -= dt
      if @life <= 0
        game\remove @
        world\remove @

    for c in *@collisions
      @touched = true
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0

      if @seed and (c.other.name == "dirt" or c.other.name == "grass")
        if settings.condition
          continue unless settings\condition c

          if settings.adjustdir
            @dirx = -c.normal.x
            @settings.dirx = @dirx if @settings

        @grow settings

      if @settings
        @settings\collide c if @settings.collide

      game\tag_check c.other.tags, c.other, @ if c.other.tags
      if c.other.settings
        game\tag_check c.other.settings.tags, c.other, @ if c.other.settings.tags

    if @grounded
      @dx -= (@dx / @frcx) * dt
    else
      @dx -= (@dx / @frcy) * dt

    @dy -= (@dy / @frcy) * dt
    @dy += @gravity * dt

  plant.draw = =>
    if @settings
      if @settings.draw
        @settings\draw @, @real_draw
      else
        @real_draw!
    else
      @real_draw!

  plant.real_draw = =>
    if @settings
      if @dirx == -1
        @draw_pos = {
          game.x + @pos[1] + (@settings.ox or 0) + sprites.plants[@settings.name]\getWidth! / 2
          game.y + @pos[2] + (@settings.oy or 0)
          @pos[3]
        }
      elseif @dirx == 1
        @draw_pos = {
          game.x + @pos[1] + (@settings.ox or 0)
          game.y + @pos[2] + (@settings.oy or 0)
          @pos[3]
        }
      else
        @draw_pos = {
          game.x + @pos[1] + (@settings.ox or 0) + sprites.plants[@settings.name]\getWidth! / 2
          game.y + @pos[2] + (@settings.oy or 0)
          @pos[3]
        }
    else
      @draw_pos = {
        game.x + @pos[1]
        game.y + @pos[2]
        @pos[3]
      }

    with projection.graphics
      if @seed
        love.graphics.setColor 100, 255, 100
        .square3d fov, "fill", @draw_pos, @w, @h
      else
        sprite = sprites.plants[@settings.name]

        love.graphics.setColor 255, 255, 255
        .draw fov, sprite, @draw_pos, 0, (@dirx or 1) * 1.5, 1.5, sprite\getWidth! / 2

  plant.grow = (settings) =>
    @touchable = settings.touchable or true

    world\update @, @pos[1] - (@dirx or 1) * (settings.w / 2), @pos[2] - settings.h - @h * 3, settings.w, settings.h
    
    for tag in *settings.tags
      @tag[#@tag + 1] = tag

    @settings = settings

    @gravity = 0 if @settings.flying

    @w    = @settings.w
    @h    = @settings.h
    @dx   = 0
    @dy   = 0
    @seed = false

  world\add plant, plant.pos[1], plant.pos[2], plant.w, plant.h

  plant

skunk = {
  name: "skunk"
  w: 24
  h: 24
  touchable: true
  tags: {"pick"}
  
  -- draw nice stuff
  effect: shine.godsray!
  draw: (plant_self, real_draw_function) =>
    @effect\draw ->
      real_draw_function plant_self

  on_pick: (a) =>
    a.dxmul = -1

    world\remove @
    game\remove  @
}

shrub = {
  name: "shrub"
  w: 24
  h: 24
  touchable: true
  tags: {"touch"}
  on_touch: (c) =>
    c.pos[2] -= 1
    c.dy      = -12
}

berry = {
  name: "berry"
  w: 4
  h: 24
  touchable: true
  adjustdir: true
  flying:    true
  tags: {"grab"}
  dirx: 0
  condition: (c) =>
    c.normal.x ~= 0

  on_grab: (a) =>
    a.attatched = -@dirx
}

{
  :make
  settings: {
    :skunk
    :shrub
    :berry
  }
}