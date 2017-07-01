export game = {}

mixer  = require "src/player/mixer"
level  = require "src/level"
camera = require "src/camera"

game.load = =>
  game.z      = -1000
  game.mixer  = mixer.make 8, 100, game.z
  game.things = {}
  game.camera = camera.make 0, 0, 1, 1, 0

  level.load "res/level.png"

game.spawn = (a) =>
  @things[#@things + 1] = a

game.update = (dt) =>
  for thing in *@things
    thing\update dt if thing.update

game.draw = =>
  @camera\set!

  for thing in *@things
    thing\draw! if thing.draw

  @mixer\draw!

  @camera\unset!

game.press = (key) =>
  for thing in *@things
    thing\press key if thing.press

  @mixer\press key

game.release = (key) =>
  for thing in *@things
    thing\release key if thing.release

game