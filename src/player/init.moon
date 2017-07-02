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

    .animations = {
      run: anim.make sprites.anims.run, 2, true
    }

    .acc      = 26
    .stdacc   = acc
    .frcx     = 3.5
    .frcy     = 0.5
    .dx       = 0
    .dy       = 0
    .grounded = false
    .gravity  = 12.5
    .jump     = 10
    .jumped   = false
    .airmul   = 0.45
    .dxmul    = 1
    .attatched = 0

  player.update = (dt) =>
    @grounded = false

    @pos[1], @pos[2], @collisions = world\move @, @pos[1] + @dx * @dxmul, @pos[2] + @dy, game.filter

    @dxmul = util.lerp @dxmul, 1, dt / 10

    -- Resolve collisions
    for c in *@collisions
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0

      game\tag_check c.other.tags, c.other, @ if c.other.tags
      if c.other.settings
        game\tag_check c.other.settings.tags, c.other, @ if c.other.settings.tags

    with love.keyboard
      if @attatched == 0
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
      else
        @dx = 0
        @dy = 0
        if (.isDown "d") and @attatched == 1
          @dx = 6
          @attatched = 0
        if (.isDown "a") and @attatched == -1
          @dx = -6
          @attatched = 0
        if .isDown "space"
          @dx = 6 * @attatched
          @dy = -7
          @attatched = 0
    with math 
      dirx = util.sign @dx
      diry = util.sign @dy
      if @grounded
        if 0.01 < .abs @dx
          @dx += (.abs @dx) * @frcx * -dirx * dt 
        else
          @dx = 0
      else
        if 0.01 < .abs @dx
          @dx += (.abs @dx) * @frcy * -dirx * dt 
        else
          @dx = 0


      if 0.01 < .abs @dy
        @dy += (.abs @dy) * @frcy * -diry * dt
      else
        @dy = 0

      @dy += @gravity * dt unless @attatched  ~= 0

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
      .x = util.lerp .x, -real_pos[1] + love.graphics.getWidth! / 5, t
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

  player

{
  :make
}