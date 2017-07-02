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
      @current = @.f @current, #@frames, dt * @s
      if (math.floor @current + 0.5) == #@frames
        @current = 0 if @loop

    .get_current = =>
      @frames[math.floor @current]

  anim

{
  :make
}