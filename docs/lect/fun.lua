-- # First Class Fucntions
-- 
-- In Lua, a function is just a value.  
-- Like a number.  
-- Like a string.
-- 
-- You can:
-- - store it in a variable
-- - pass it to another function
-- - return it from a function 
-- 

f = function(x) return x*x end
-- 
-- 
-- IF we write functions to a table, we can make (e.g.) a demo
-- suite that we can call from the command-line; e.g. `lua fun.ad --a`.
-- 

eg,egs = {},{} -- "egs" used later
eg["--a"]= function() print(f(3)) end --> 9

function main(cli)
  for i,s in pairs(cli) do -- "arg" is the command line 
    if eg[s] then eg[s](cli[i+1]) end end end
-- 
-- 
-- Functions can be passed to other functions.
-- 

function map(t,fn)
   local u={}; for _,v in pairs(t) do u[1+#u]=fn(v); end; return u end

eg["--b"]=function(  t) t={10,20,30}; map(t,print) end -->

-- 10
-- 20
-- 30
-- 
-- 
-- This can be used to (e.g.) fix a bug in Lua's table.concat function that 
-- crashed on booleans (we need to cast it to a string first).
-- 

function cat(t) return "{"..table.concat(map(t,tostring),", ") .. "}" end
function pat(t) print(cat(t)); return t end

eg["--c"]=function() print(cat({1,2,3})) end --> {1, 2, 3}
-- 
-- Of course we can to that recrusively (X and Y or Z == Java;s X ? Y : Z)
-- 

function rat(t) return type(t)=="table" and cat(map(t,rat)) or tostring(t) end
function prat(t) print(rat(t)); return t end

eg["--d"]=function()
  print(rat({1,2,{10,20},{{300,400},50}})) end --> pretty recursive print
-- 
-- 
-- Functions store variables so first class functions can carray round state.
-- 

function lt(n) -- stand by for a function that returns... a function
  return function(a,b) return a[n] < b[n] end end

eg["--eg"]=function(   t)
  t={{10,20,30,"a"},
     {30,10,20,"b"},
     {5, 30,50,"c"}}
  print("before:",rat(t))
  table.sort(t, lt(3))
  print("after:", rat(t)) end --> prints t sorted by last item
-- 
-- 
-- Finally, a test suite:
-- 

eg["--all"]= function(    fn) 
  map(egs, function(s) print("\n"..s); assert(not eg[s]()) end) end

eg["-h"] = function() print("lua fun.md " .. cat(egs)) end

for k,_ in pairs(eg) do if k ~= "--all" then egs[1+#egs]=k; table.sort(egs) end end
-- 
-- 
-- Main. In Lua, "arg" is the command line
-- 

main(arg)
-- 
