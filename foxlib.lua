local io = require("io")
local serialization = require("serialization")
local filesystem = require("filesystem") 
local term = require("term")
local w,h = term.getViewport()

if not (serialization and filesystem and term and io) then --Check to make sure we've got all our libraries. To be honest most of these are required to boot anyways,
 error("Missing required libraries. Make sure you have serialization, fileystem, term and IO libaries installed.") 
end

 
local function pos(x,y) 
  term.setCursor(x,1+y) 
end

local function clear() 
  for i=2,h-1 do pos(1,i) 
    term.clearLine() 
  end
end

local function setCenter(text,row) 
  local start = w/2-#text/2
  if start < w-2 then 
   term.setCursor(start,row) 
   print(text) 
  else 
   error("Text too long to center properly.")
  end 
end


foxlib = {}
foxlib.cfg = {}


foxlib.cfg.read=function(f)
local file = io.open(f,'r')
 f = serialization.unserialize(f:read("*a"))
f:close()
return f
end

foxlib.cfg.write=function(f,d)
  if fs.exists(f) then  
    local fN = io.open(f,"a")
    fN:write(d)
    fN:close()
  else
   local fN = io.open(f,"w")
   fN:write("LOG CREATED")
   fN:write(d)
   fN:close()
  end
end

foxlib.ui = {} --Needs OOP rewrite for objective handling of User Interfaces.
--Our nice text UI box is in place, we can return here later to make new functions but for now this will do.

foxlib.ui.setTitle=function(t)
  pos(1,0)
  term.clearLine()
  setCenter(t,1)
end

foxlib.ui.box={ 
x=1,  
y=1,  
width=1, 
height=1,  
text="", 
new=function(name)     
o = name or {}         
setmetatable(o,{__index=userBox})       
return o  end, draw = function(self) 
pos(self.x,self.y)   
print(self.text)  
end,    

drawCenter = function(self)   
local x=self.x+(self.w/2-#self.text/2)    
pos(x,self.y)   
 print(self.text)  
end}

foxlib.ui.clear = function()
  clear()
  pos(1,1)
end

return foxlib
