export game = {}

mixer = require "src/player/mixer"
level = require "src/level"

game.load = =>
  game.z      = -1000
  game.mixer  = mixer.make 8, 100, game.z
  game.things = {}

  level.load "res/level.png"

game.spawn = (a) =>
  @things[#@things + 1] = a

game.update = (dt) =>
  for thing in *@things
    thing\update dt if thing.update

game.draw = =>
  for thing in *@things
    thing\draw! if thing.draw

  @mixer\draw!

game.press = (key) =>
  for thing in *@things
    thing\press key if thing.press

  @mixer\press key

game.release = (key) =>
  for thing in *@things
    thing\release key if thing.release

game