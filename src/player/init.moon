make = (x, y, z) ->
  player = {
    pos: {
      [1]: x
      [2]: y
      [3]: z
    }
  }

  player.w = 20
  player.h = 20

  player.acc      = 20
  player.frcx     = 0.12
  player.frcy     = 2
  player.dx       = 0
  player.dy       = 0
  player.grounded = false
  player.gravity  = 25
  player.jump     = 8
  player.jumped   = false
  player.airmul   = 0.75

  player.update = (dt) =>
    @grounded = false

    @pos[1], @pos[2], @collisions = world\move @, @pos[1] + @dx, @pos[2] + @dy

    for c in *@collisions
      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
        @dy = 0
      if c.normal.x ~= 0
        @dx = 0

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
    real_pos = @get_real!
    with game.camera
      .pos[1] = util.lerp .pos[1], real_pos[1], t
      .pos[2] = util.lerp .pos[2], real_pos[2], t

  player.draw = =>
    with projection.graphics
      love.graphics.setColor 200, 255, 200
      .square3d fov, "fill", @pos, @w, @h

      love.graphics.setColor 150, 150, 150
      .square3d fov, "line", @pos, @w, @h

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