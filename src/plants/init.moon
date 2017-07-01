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

  plant.update = (dt) =>
    @pos[1], @pos[2], @collisions = world\move @, @pos[1] + @dx, @pos[2] + @dy

    for c in *@collisions
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0

      if @seed and c.other.name == "dirt"
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
      @draw_pos = {
        game.x + @pos[1] + (@settings.ox or 0)
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
        love.graphics.setColor 255, 255, 255
        .draw fov, sprites.plants[@settings.name], @draw_pos, 0, 1.5, 1.5

  plant.grow = (settings) =>
    unless settings.touchable
      world\remove @
    else
      world\update @, @pos[1] - settings.w / 2, @pos[2] - settings.h - @h * 3, settings.w, settings.h
    
    for tag in *settings.tags
      @tag[#@tag + 1] = tag

    @settings = settings

    @w    = settings.w
    @h    = settings.h
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
  on_pick: =>
    game.camera.r += util.randf -.5, .5

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
  ox: -20
  oy: 0
  touchable: true
  tags: {"grab"}
  on_grab: (a) => 
    a.attatched = -1
}

{
  :make
  settings: {
    :skunk
    :shrub
    :berry
  }
}