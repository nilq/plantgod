state = require("lib/state")
util = require("lib/util")
shine = require("lib/shine")
bump = require("lib/bump")
world = bump.newWorld()
post_effect = shine.scanlines():chain((shine.crt():set("x", 0.04)):set("y", 0.045))
do
  local _with_0 = love
  _with_0.graphics.setBackgroundColor(255, 255, 255)
  _with_0.run = function()
    local dt = 0
    local update_time = 0
    local target_delta = 1 / 120
    if _with_0.math then
      _with_0.math.setRandomSeed(os.time())
    end
    if _with_0.load then
      _with_0.load()
    end
    if _with_0.timer then
      _with_0.timer.step()
    end
    state:set("src/core")
    state:load()
    while true do
      update_time = update_time + dt
      if love.event then
        _with_0.event.pump()
        for name, a, b, c, d, e, f in _with_0.event.poll() do
          if "quit" == name then
            if not (_with_0.quit or not _with_0.event.quit()) then
              return a
            end
          end
          _with_0.handlers[name](a, b, c, d, e, f)
        end
      end
      if _with_0.timer then
        _with_0.timer.step()
        dt = _with_0.timer.getDelta()
      end
      if update_time > target_delta then
        state:update(update_time)
        print(update_time)
        update_time = 0
      end
      if _with_0.graphics and _with_0.graphics.isActive() then
        _with_0.graphics.clear(_with_0.graphics.getBackgroundColor())
        _with_0.graphics.setColor(255, 255, 255)
        _with_0.graphics.origin()
        post_effect:draw(function()
          return state:draw()
        end)
        _with_0.graphics.present()
      end
      if _with_0.timer then
        _with_0.timer.sleep(0.001)
      end
    end
  end
  return _with_0
end
