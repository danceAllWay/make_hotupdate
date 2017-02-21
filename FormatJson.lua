local json = require "json"
local jsonutil = require("json.util")
require "Config"

local function isArray ( val )
  
  local ret = jsonutil.IsArray(val)
  if ret == true or ret == false then
    return ret
  end
  
  -- Use the 'n' element if it's a number
  if type ( val.n ) == 'number' and math.floor ( val.n ) == val.n and val.n >= 1 then
    return true
  end
  local len = #val
  for k, v in pairs ( val ) do
    if type ( k ) ~= 'number' then
      return false
    end
    local _, decim = math.modf ( k )
    if not ( decim == 0 and 1 <= k ) then
      return false
    end
    if k > len then -- Use Lua's length as absolute determiner
      return false
    end
  end

  return true
end


local FormatJson = {}
  
function FormatJson:init ( intend )
  local tmp = {}
  setmetatable ( tmp,self )
  self.__index = self
  intend  = intend or 4
  self.intend = intend
  self.stack = ""
  self:parse ( self.obj , 0 )
  return tmp
end

function FormatJson:initWithFile ( fileName, intend )
  local f = io.open ( fileName , "r" )
  if not file then
    print ( "The file " .. fileName .. " not exist" )
    return
  end
  local str = f:read ( "*a" )
  self.obj = json.decode ( self.source )
  f:close ()
  return self:init ( intend )
end

function FormatJson:initWithTable ( t, intend )
  if type ( t ) ~= "table" then
    print ( " param#1 not a table")
    return
  end
  self.obj = t
  return self:init ( intend )
end

function FormatJson:print ()
  print ( self.stack )
end

function FormatJson:writeToFile( fileName, isPrint )
  if isPrint then
    self:print ()
  end
  local f = io.open ( fileName, "w" )
  f:write ( self.stack )
  f:close()
end


function FormatJson:jsonStr( s )
  return '"' .. s .. '"'
end

function FormatJson:lineIntend ( level )
  level = level or 0
  if level == 0 and self.stack == "" then
    return ""
  end
  local str = "\n"
  local intend = self.intend * level
  for i = 0, self.intend * level - 1 do
    str = str .. " "
  end
  return str
end

function FormatJson:parseDict ( obj, intendLevel )
  intendLevel = intendLevel or 0
  self.stack = self.stack .. self:lineIntend ( intendLevel ) .. "{"
  intendLevel = intendLevel + 1
  local isSubComma = false
  for key, value in pairs ( obj ) do
    self.stack = self.stack .. self:lineIntend ( intendLevel ) .. self:jsonStr ( key ) .. ":"
    self:parse ( value, intendLevel )
    self.stack = self.stack .. ","
    isSubComma = true
  end
  if isSubComma then
    self.stack = string.sub ( self.stack, 1, string.len ( self.stack ) - 1 )
  end
  self.stack = self.stack .. self:lineIntend ( intendLevel - 1 ) .. '}'
end

function FormatJson:parseList ( obj, intendLevel )
  intendLevel = intendLevel or 0
  self.stack = self.stack .. self:lineIntend ( intendLevel ) .. "["
  intendLevel = intendLevel + 1
  local isSubComma = false
  for _, item in ipairs ( obj ) do
    self:parse ( item , intendLevel )
    self.stack = self.stack .. ","
    isSubComma = true
  end
  if isSubComma then
    self.stack = string.sub ( self.stack, 1, string.len ( self.stack ) - 1 )
  end
  self.stack = self.stack .. self:lineIntend ( intendLevel - 1 ) .. "]"
end

function FormatJson:parse( obj, intendLevel )
  if not obj then
    self.stack = self.stack .. "null"
  elseif type ( obj ) == "boolean" then
    if obj then
      self.stack = self.stack .. "true"
    else
      self.stack = self.stack .. "false"
    end
  elseif type ( obj ) == "number" then
    self.stack = self.stack .. tostring ( obj )
  elseif type ( obj ) == "string" then
    self.stack = self.stack .. self:jsonStr ( obj )
  elseif type ( obj ) == "table" then
    if isArray ( obj ) then
      self:parseList ( obj, intendLevel )
    else
      self:parseDict ( obj, intendLevel )
    end
  else
    print ( "The obj's type is " .. type ( obj ) )
  end
end

return FormatJson













