local Utils = require('broom.util')

local M = {}
M.__index = M
M.__tostring = function(set)
  local s = 'Set('
  local sep = ''
  for v in pairs(set) do
    s = s .. sep .. tostring(v)
    sep = ', '
  end
  return s .. ')'
end

local function construct(optionalValues)
  local values = optionalValues or {}
  local self = {}

  setmetatable(self, M)

  if type(values) == 'table' then
    for _, v in ipairs(values) do
      self[v] = true
    end
  elseif values ~= nil then
    self[values] = true
  end

  return setmetatable(self, M)
end

M.new = function(values)
  return construct(values)
end

function M.contains(self, e)
  return self[e] == true
end

function M.add(self, e)
  if e == nil or M.contains(self, e) then
    return false
  end
  self[e] = true
  return true
end

function M.clear(self)
  for k in pairs(self) do
    self[k] = nil
  end
end

function M.is_empty(self)
  return M.size(self) == 0
end

function M.remove(self, e)
  if e == nil or not M.contains(self, e) then
    return false
  end
  self[e] = nil
  return true
end

function M.size(self)
  return Utils.tablelen(self)
end

setmetatable(M, {
  __call = function(cls, ...)
    return construct(...)
  end,
})

return M
