local project
project = function(fov, point)
  local scale = fov / (fov + point[#point])
  local point2 = { }
  for _index_0 = 1, #point do
    local coord = point[_index_0]
    point2[#point2 + 1] = coord * scale
    if #point2 - (#point - 1) == 0 then
      return point2, scale
    end
  end
end
local projectn
projectn = function(dimension, fov, point)
  local point2, scale = project(fov, point)
  if dimension - #point2 == 0 then
    return point2, scale
  else
    return projectn(dimension, fov, point2)
  end
end
local line
line = function(fov, p1, p2)
  local pn1, s1 = projectn(2, fov, p1)
  local pn2, s2 = projectn(2, fov, p2)
  do
    local _with_0 = love.graphics
    _with_0.line(pn1[1] * s1, pn1[2] * s1, pn2[1] * s2, pn2[2] * s2)
    return _with_0
  end
end
local circle
circle = function(fov, mode, p1, radius, segments)
  local pn1, s1 = projectn(2, fov, p1)
  do
    local _with_0 = love.graphics
    _with_0.circle(mode, pn1[1] * s1, pn1[2] * s1, radius * s1, segments)
    return _with_0
  end
end
local print
print = function(fov, msg, p1)
  local pn1, s1 = projectn(2, fov, p1)
  do
    local _with_0 = love.graphics
    _with_0.print(msg, pn1[1] * s1, pn1[2] * s1, 0, s1, s1)
    return _with_0
  end
end
local draw
draw = function(fov, img, p1, r, sx, sy)
  if r == nil then
    r = 0
  end
  if sx == nil then
    sx = 1
  end
  if sy == nil then
    sy = 1
  end
  local pn1, s1 = projectn(2, fov, p1)
  do
    local _with_0 = love.graphics
    _with_0.draw(img, pn1[1] * s1, pn1[2] * s1, r, s1 * sx, s1 * sy)
    return _with_0
  end
end
local triangle
triangle = function(fov, mode, p1, p2, p3)
  local pn1, s1 = projectn(2, fov, p1)
  local pn2, s2 = projectn(2, fov, p2)
  local pn3, s3 = projectn(2, fov, p3)
  do
    local _with_0 = love.graphics
    _with_0.polygon(mode, pn1[1] * s1, pn1[2] * s1, pn2[1] * s2, pn2[2] * s2, pn3[1] * s3, pn3[2] * s3)
    return _with_0
  end
end
local square3
square3 = function(fov, mode, p1, p2, p3, p4)
  local _exp_0 = mode
  if "fill" == _exp_0 then
    triangle(fov, "fill", p1, p2, p3)
    triangle(fov, "fill", p2, p3, p4)
    return triangle(fov, "fill", p3, p4, p1)
  elseif "cross?" == _exp_0 then
    triangle(fov, "fill", p1, p2, p3)
    triangle(fov, "fill", p2, p3, p4)
    triangle(fov, "fill", p3, p4, p1)
    return triangle(fov, "fill", p1, p3, p4)
  elseif "line" == _exp_0 then
    line(fov, p1, p2)
    line(fov, p2, p3)
    line(fov, p3, p4)
    return line(fov, p4, p1)
  end
end
local square3h
square3h = function(fov, mode, p1, width, height)
  local p2 = {
    p1[1] + width,
    p1[2],
    p1[3]
  }
  local p3 = {
    p1[1] + width,
    p1[2],
    p1[3] + height
  }
  local p4 = {
    p1[1],
    p1[2],
    p1[3] + height
  }
  return square3(fov, mode, p1, p2, p3, p4)
end
local square3v
square3v = function(fov, mode, p1, width, height)
  local p2 = {
    p1[1],
    p1[2] + width,
    p1[3]
  }
  local p3 = {
    p1[1],
    p1[2] + width,
    p1[3] + height
  }
  local p4 = {
    p1[1],
    p1[2],
    p1[3] + height
  }
  return square3(fov, mode, p1, p2, p3, p4)
end
local square3d
square3d = function(fov, mode, p1, width, height)
  local p2 = {
    p1[1] + width,
    p1[2],
    p1[3]
  }
  local p3 = {
    p1[1] + width,
    p1[2] + height,
    p1[3]
  }
  local p4 = {
    p1[1],
    p1[2] + height,
    p1[3]
  }
  return square3(fov, mode, p1, p2, p3, p4)
end
local cube
cube = function(fov, mode, p1, width, height, depth)
  square3h(fov, mode, {
    p1[1],
    p1[2],
    p1[3]
  }, width, height)
  square3h(fov, mode, {
    p1[1],
    p1[2] - height,
    p1[3]
  }, width, height)
  square3v(fov, mode, {
    p1[1],
    p1[2] - height,
    p1[3]
  }, width, height)
  square3v(fov, mode, {
    p1[1] + width,
    p1[2] - height,
    p1[3]
  }, width, height)
  return square3d(fov, mode, {
    p1[1],
    p1[2] - height,
    p1[3]
  }, width, height)
end
return {
  project = project,
  projectn = projectn,
  graphics = {
    line = line,
    circle = circle,
    triangle = triangle,
    square3 = square3,
    square3h = square3h,
    square3v = square3v,
    square3d = square3d,
    cube = cube,
    draw = draw,
    print = print
  }
}
