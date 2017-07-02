make = (frames, s=1, loop=false, f=util.lerp, current=0) ->
  anim = {
    :frames
    :s
    :loop
    :current
    :f
  }

  with anim
    .update = (dt) =>
      @current = math.floor @f @current, #@frames, dt * @s
      if @current - #@frames == 0
        @current = 0 if @loop

    .current = =>
      @frames @current

  anim

{
  :make
}