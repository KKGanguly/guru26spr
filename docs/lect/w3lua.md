.

# More on Lua

Recall that Lua has "tables" that switch from arrays to dictionaries,
depending on their keys?

- all numeric keys running 1,2...n
  - `t` is an array!
  - `#t==n`
  - if we iterate thiugh `t`,  we always get the same order   
    `for j,n in pairs({"name","age") do print(j,n) end` prints  
    "1 name"    
    "2 age"   
- keys are symbols `apples`, `oranges` etc...
  - e.g. `t={applies=4, oranges}=2`
  - #t==0
  - if we iterate thiugh a table, we may not get the same order   
    `for j,n in pairs({name="tim",age=21) do print(j,n) end` prints  
    name or age first in any order.

So my pretty printer of nested tables had to:

```lua
local function o(t,     u,k)
  if math.type(t)=="float" then return fmt("%.2f",t) end
  if type(t)~="table" then return tostring(t) end u={}
  if #t>0 then for i=1,#t do u[i]=o(t[i]) end
  else 
     k={} 
     for n in pairs(t) do k[#k+1]=n end 
     table.sort(k)
     for i=1,#k do u[i]=fmt(":%s %s",k[i],o(t[k[i]])) end 
  end
  return "{"..table.concat(u," ").."}" end 
```
Now what is we spread some iterator magic? What about all that nonesens of ``are you
a table or ana array" was buried away inside an iterator.   

local function o(t,     u,k)

  if math.type(t)=="float" then return fmt("%.2f",t) end

  if type(t)~="table" then return tostring(t) end u={}

  if #t>0 then for i=1,#t do u[i]=o(t[i]) end

  else 

      k={} 

     for n in pairs(t) do k[#k+1]=n end 

     table.sort(k)

     for i=1,#k do u[i]=fmt(":%s %s",k[i],o(t[k[i]])) end 

  end

  return "{"..table.concat(u," ").."}" end
