local return_v = false
local value_v = 0
local deep_copy
deep_copy = function(org)
  local copy = { }
  if "table" == type(org) then
    for k, v in next,org,nil do
      copy[deep_copy(k)] = deep_copy(org)
    end
    setmetatable(copy, deep_copy(getmetatable(org)))
  else
    copy = org
  end
  return copy
end
local gauss_random
gauss_random = function()
  if return_v then
    return_v = false
    return value_v
  end
  local u = 2 * math.random() - 1
  local v = 2 * math.random() - 1
  local r = u ^ 2 + v ^ 2
  if r == 0 or r > 1 then
    return gauss_random()
  end
  local c = math.sqrt(-2 * (math.log(r)) / r)
  value_v = v * c
  return u * c
end
local randf
randf = function(a, b)
  return (b - a) * math.random() + a
end
local randi
randi = function(a, b)
  return math.floor((b - a) * math.random() + a)
end
local randn
randn = function(mu, sigma)
  return mu + gauss_random() * sigma
end
local distance
distance = function(a, b)
  return math.sqrt((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2)
end
local lerp
lerp = function(a, b, t)
  return a + (b - a) * t
end
local sign
sign = function(n)
  if n < 0 then
    return -1
  end
  if n > 0 then
    return 1
  end
  return 0
end
local cap
cap = function(n)
  if n < 0 then
    return 0
  end
  if n > 1 then
    return 1
  end
  return n
end
return {
  deep_copy = deep_copy,
  gauss_random = gauss_random,
  randf = randf,
  randi = randi,
  randn = randn,
  cap = cap,
  distance = distance,
  lerp = lerp,
  sign = sign
}
