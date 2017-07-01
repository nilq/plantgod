export game = {}

mixer  = require "src/player/mixer"
level  = require "src/level"
camera = require "src/camera"

game.load = =>
  game.z       = -1000
  game.mixer   = mixer.make 4, 100, game.z
  game.things  = {}
  game.players = {}
  game.camera  = camera.make 0, 0, 1, 1, 0

  level.load "res/level.png"

game.tag_check = (tags, a) =>
  for tag in *tags
    if a["on_" .. tag]
      a["on_" .. tag] a
    elseif a.settings["on_" .. tag]
      a.settings["on_" .. tag] a
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

game.update = (dt) =>
  @camera.r = util.lerp @camera.r, 0, dt * 4

  for thing in *@things
    continue unless thing
    thing\update dt if thing.update

game.draw = =>
  @camera\set!

  for thing in *@things
    continue unless thing
    thing\draw! if thing.draw

  @camera\unset!
  
  @mixer\draw!

game.press = (key) =>
  for thing in *@things
    continue unless thing
    thing\press key if thing.press

  @mixer\press key

game.release = (key) =>
  for thing in *@things
    continue unless thing
    thing\release key if thing.release

game