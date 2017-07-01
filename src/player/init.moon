make = (x, y, z) ->
  player = {
    pos: {
      [1]: x
      [2]: y
      [3]: z
    }
  }

  with player
    .w = 24
    .h = 24

    .acc      = 20
    .stdacc   = acc
    .frcx     = 0.12
    .frcy     = 2
    .dx       = 0
    .dy       = 0
    .grounded = false
    .gravity  = 25
    .jump     = 8
    .jumped   = false
    .airmul   = 0.75

  player.update = (dt) =>
    -- Clear flags
    @grounded = false
    @fast = false

    @pos[1], @pos[2], @collisions = world\move @, @pos[1] + @dx, @pos[2] + @dy

    -- Resolve collisions
    for c in *@collisions
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0
      
      if fast
        acc = stdacc * 2
      else
        acc = stdacc

      game\tag_check c.other.tags, c.other, @ if c.other.tags
      if c.other.settings
        game\tag_check c.other.settings.tags, c.other, @ if c.other.settings.tags

    with love.keyboard
      if .isDown "d"
        if @grounded
          @dx += @acc * dt
        else
          @dx += @airmul * @acc * dt
      if .isDown "a"
        if @grounded
          @dx -= @acc * dt
        else
          @dx -= @airmul * @acc * dt
      
      if .isDown "space"
        unless @grounded
          @dy -= dt * @gravity / 40

    if @grounded
      @dx -= (@dx / @frcx) * dt
    else
      @dx -= (@dx / @frcy) * dt

    @dy -= (@dy / @frcy) * dt

    @dy += @gravity * dt

    @jumped = false if @dy >= 0

    @camera_follow dt * 4

  player.get_real = =>
    point, scale = projection.projectn 2, fov, @pos
    {
      point[1] * scale
      point[2] * scale
    }

  player.camera_follow = (t) =>
    real_pos = @pos
    with game
      .x = util.lerp .x, -real_pos[1] + love.graphics.getWidth! / 4, t
      .y = util.lerp .y, -real_pos[2] + love.graphics.getHeight! / 4, t / 2

  player.draw = =>
    @draw_pos = {
      game.x + @pos[1]
      game.y + @pos[2]
      @pos[3]
    }
    with projection.graphics
      love.graphics.setColor 200, 255, 200
      .square3d fov, "fill", @draw_pos, @w, @h

      love.graphics.setColor 150, 150, 150
      .square3d fov, "line", @draw_pos, @w, @h

  player.press = (key) =>
    if @grounded
      if key == "space"
        @dy = -@jump
        @jumped = true

  player.release = (key) =>
    if @jumped
      if key == "space" 
        @dy = 0
  
  player.makefast = =>
    @fast = true

  player

{
  :make
}