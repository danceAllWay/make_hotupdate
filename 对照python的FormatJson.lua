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
  
function FormatJson:init ( intend ,name )
  local tmp = {}
  setmetatable ( tmp,self )
  self.__index = self
  intend  = intend or 4
  name = name or ""
  self.name = name
  self.intend = intend
  self.stack = ""
  self.source = ""
  self.obj = nil
  return tmp
end


function FormatJson:jsonStr( s )
  return ' " ' + s + ' " '
end

-- def get_source(name):
--    with open(name,'r') as f:
--      return ''.join(f.read().split())
function FormatJson:getSource( name )
  local f = io.open ( name , "r" )
  return f:read ( "*a" )
end


  
--  def prepare(self):
--    try:
--      self.obj=eval(self.source)
--    except:
--      raise Exception('Invalid json string!')
function FormatJson:prepare (  )
  self.obj = json.decode ( self.source )
end

--  def line_intend(self,level=0):
--    return '\n'+' '*self.intend*level
function FormatJson:lineIntend ( level )
  level = level or 0
  local str = "\n"
  local intend = self.intend * level
  for i = 0, self.intend * level - 1 do
    str = str .. " "
  end
  return str
end

--[[  def parse_dict(self,obj=None,intend_level=0):
    self.stack.append(self.line_intend(intend_level)+'{')
    intend_level+=1
    for key,value in obj.items():
      key=self.json_str(str(key))
      self.stack.append(self.line_intend(intend_level)+key+':')
      self.parse(value,intend_level)
      self.stack.append(',')
    self.stack.append(self.line_intend(intend_level-1)+'}')
  ]]
function FormatJson:parseDict ( obj, intendLevel )
  intendLevel = intendLevel or 0
  self.stack = self.stack .. self:lineIntend ( intendLevel ) .. "{"
  intendLevel = intendLevel + 1
  for key, value in pairs ( obj ) do
    self.stack = self.stack .. self:lineIntend ( intendLevel ) .. '"' .. key .. '"' .. ":"
    self:parse ( value, intendLevel )
    self.stack = self.stack .. ","
  end
  self.stack = self.stack .. self:lineIntend ( intendLevel - 1 ) .. '}'
end

 --[[ def parse_list(self,obj=None,intend_level=0):
    self.stack.append(self.line_intend(intend_level)+'[')
    intend_level+=1
    for item in obj:
      self.parse(item,intend_level)
      self.stack.append(',')
    self.stack.append(self.line_intend(intend_level-1)+']')]]

function FormatJson:parseList ( obj, intendLevel )
  intendLevel = intendLevel or 0
  self.stack = self.stack .. self:lineIntend ( intendLevel ) .. "["
  intendLevel = intendLevel + 1
  for _, item in ipairs ( obj ) do
    self:parse ( item , intendLevel )
    self.stack = self.stack .. ","
  end
  self.stack = self.stack .. self:lineIntend ( intendLevel - 1 ) .. "]"
end

--[[  def parse(self,obj,intend_level=0):
    if obj is None:
      self.stack.append('null')
    elif obj is True:
      self.stack.append('true')
    elif obj is False:
      self.stack.append('false')
    elif isinstance(obj,(int,long,float)):
      self.stack.append(str(obj))
    elif isinstance(obj,str):
      self.stack.append(self.json_str(obj))
    elif isinstance(obj,(list,tuple)):
      self.parse_list(obj,intend_level)
    elif isinstance(obj,dict):
      self.parse_dict(obj,intend_level)
    else:
      raise Exception('Invalid json type %s!' % obj)]]
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
    self.stack = self.stack .. '"' .. obj .. '"'
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



--[[  def render(self):
    self.parse(self.obj,0)
    res_file='good'+self.name
    res=''.join(self.stack)
    with open(res_file,'w') as f:
      f.write(res)
    print res]]
function FormatJson:render ()
  --self.source = self:getSource ( self.name )
  --self:prepare ()
  self.obj = baseValue
  self:parse ( self.obj , 0 )
  local res_file = "good" .. self.name
  local f = io.open ( res_file, "w" )
  f:write ( self.stack )
  f:close()
  print ( self.stack )
end

--[[
if __name__=="__main__":
  jf=JsonFormatter(name="json.txt")
  jf.render()
]]
return FormatJson













