make = (x, y, z, settings) ->
  plant = {
    pos: {
      [1]: x
      [2]: y
      [3]: z
    }

    :settings
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
      if @seed
        @grow!
        
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0

    if @grounded
      @dx -= (@dx / @frcx) * dt
    else
      @dx -= (@dx / @frcy) * dt

    @dy -= (@dy / @frcy) * dt
    @dy += @gravity * dt

  plant.draw = =>
    with projection.graphics
      love.graphics.setColor 100, 255, 100
      .square3d fov, "fill", @pos, @w, @h

  plant.grow = (settings=@settings) =>
    unless settings.touchable
      world\remove @
    else
      world\update @, @pos[1] - settings.w / 2, @pos[2] - settings.h - @h * 3, settings.w, settings.h
    
    for tag in *settings.tags
      @tag[#@tag + 1] = tag

    @settings = settings

    @w    = settings.w
    @h    = settings.h
    @seed = false

  world\add plant, plant.pos[1], plant.pos[2], plant.w, plant.h

  plant

skunk = {
  w: 8
  h: 25
  touchable: true
  tags: {"pick"}
  on_pick: =>
    game.camera.r += util.randf -.5, .5

    world\remove @
    game\remove  @
}

{
  :make
  settings: {
    :skunk
  }
}