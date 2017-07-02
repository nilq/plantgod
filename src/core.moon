export game = {}

mixer  = require "src/player/mixer"
level  = require "src/level"
camera = require "src/camera"

game.filter = (item, other) ->
  if other.touchable ~= nil
    unless other.touchable
      return "cross"
  "slide"

game.load = =>
  @x       = 0
  @y       = 0
  @z       = -1000
  @mixer   = mixer.make 4, 100, @z
  @things  = {}
  @thingsb = {}
  @players = {}
  @camera  = camera.make 0, 0, 1, 1, 0

  items = world\getItems!

  for item in *items
    world\remove item

  level.load "res/level.png"

game.tag_check = (tags, a, ...) =>
  for tag in *tags
    if a["on_" .. tag]
      a["on_" .. tag] a, ...
    elseif a.settings["on_" .. tag]
      a.settings["on_" .. tag] a, ...
    else
      error "undefined trigger!!! >:("

game.remove = (a) =>
  i = 1
  for aa in *@things
    if aa == a
      table.remove @things, i
      break
    i += 1

game.spawn = (a) =>
  @things[#@things + 1] = a

game.spawn_back = (a) =>
  @thingsb[#@thingsb + 1] = a

game.update = (dt) =>
  @camera.r = util.lerp @camera.r, 0, dt * 4

  for thing in *@things
    continue unless thing
    thing\update dt if thing.update

game.draw = =>
  for thingb in *@thingsb
    continue unless thingb
    thingb\drawb! if thingb.drawb

  for thing in *@things
    continue unless thing
    thing\draw! if thing.draw

  for thingb in *@thingsb
    continue unless thingb
    thingb\draw! if thingb.draw

  @mixer\draw!

  with love.graphics
    .setColor 100, 100, 100
    .print "#{love.timer.getFPS!}FPS\n#{(string.format "%.4f", love.timer.getDelta!)}dt", 10, 10, 0, 5, 5

game.press = (key) =>
  if key == "r"
    game\load!
  for thing in *@things
    continue unless thing
    thing\press key if thing.press

  @mixer\press key

game.release = (key) =>
  for thing in *@things
    continue unless thing
    thing\release key if thing.release

game