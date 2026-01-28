<p align="center">
  <a href="https://github.com/txt/guru26spr/blob/main/README.md"><img 
     src="https://img.shields.io/badge/Home-%23ff5733?style=flat-square&logo=home&logoColor=white" /></a>
  <a href="https://github.com/txt/guru26spr/blob/main/docs/lect/syllabus.md"><img 
      src="https://img.shields.io/badge/Syllabus-%230055ff?style=flat-square&logo=openai&logoColor=white" /></a>
  <a href="https://docs.google.com/spreadsheets/d/1xZfIwkmu6hTJjXico1zIzklt1Tl9-L9j9uHrix9KToU/edit?usp=sharing"><img
      src="https://img.shields.io/badge/Teams-%23ffd700?style=flat-square&logo=users&logoColor=white" /></a>
  <a href="https://moodle-courses2527.wolfware.ncsu.edu/course/view.php?id=8119"><img 
      src="https://img.shields.io/badge/Moodle-%23dc143c?style=flat-square&logo=moodle&logoColor=white" /></a>
  <a href="https://discord.gg/vCCXMfzQ"><img 
      src="https://img.shields.io/badge/Chat-%23008080?style=flat-square&logo=discord&logoColor=white" /></a>
  <a href="https://github.com/txt/guru26spr/blob/main/LICENSE.md"><img 
      src="https://img.shields.io/badge/©%20timm%202026-%234b4b4b?style=flat-square&logoColor=white" /></a></p>
<h1 align="center">:cyclone: CSC491/591: How to be a SE Guru <br>NC State, Spring '26</h1>
<img src="https://raw.githubusercontent.com/txt/guru26spr/refs/heads/main/etc/img/banenr.png"> 



# Homework 3: AWK, Lua, First-Class Functions

Due: One week from today. Submit to Moodle.

Files:
- [diabetes.csv](diabetes.csv) — 768 rows, numeric attributes. Use with nb.py and nb.lua.
- [soybean.csv](soybean.csv) — symbolic attributes. Use with AWK exercises.
- [nb.py](nb.py) — Python version of Naive Bayes
- [nb.lua](nb.lua) — Lua version of Naive Bayes
- [lib.lua](lib.lua) — utilities imported by nb.lua
- [nb_py_lua.pdf](nb_py_lua.pdf) — side-by-side listing of all three files

## What to Submit


Pages,s tapled togehter, with your group number and  student names and numbers on page1 (student numbers should jsut be the last 4 digits)

- `a1.awk` through `a10.awk`
- `partB.txt`
- `fp.lua`

No PDFs. No screenshots. No zip files containing zip files.
---

## Part A: AWK (10 exercises)

All exercises use `soybean.csv`. Submit one `.awk` file per exercise.

**A1.** Print every line where the class (last column) is `diaporthe-stem-canker`.

**A2.** Count how many rows belong to each class. Output one line per class.

**A3.** Compute the most common value in column 2. Print the value and its count.

**A4.** *(for grad students)* Cross-tabulation: for each class, count how many rows have column 1 equal to each distinct value. Output should look like:
```
diaporthe-stem-canker 0 3
diaporthe-stem-canker 1 2
...
```

**A5.** Print rows 1-10, then for rows 11+, print only rows where column 3 is not "?". Use `next`.

**A6.** Write a function `entropy(arr, n)` where `arr` holds counts and `n` is total. Use it to print the entropy of the class distribution. Formula: `-sum(p * log(p))` where `p = count/n`.

**A7.** *(for grad students)* Reservoir sampling: print exactly 20 random rows (not counting the header). Use `srand()` and `rand()`. Run it twice—should get different rows each time.

**A8-A10** use this 18-line Naive Bayes as a starting point:

```awk
BEGIN { FS=","; Total=0 }
NR==1 { next }
NR<=11 { train(); next }
{ c=classify(); print $NF","c; train() }

function train(    i,c) {
  Total++; c=$NF; Classes[c]++
  for(i=1; i<NF; i++) {
    if($i=="?") continue
    Freq[c,i,$i]++
    if(++Seen[i,$i]==1) Attr[i]++ }}

function classify(    i,c,t,best,bestc) {
  best=-1e30
  for(c in Classes) {
    t=log(Classes[c]/Total)
    for(i=1; i<NF; i++) {
      if($i=="?") continue
      t+=log((Freq[c,i,$i]+1)/(Classes[c]+Attr[i])) }
    if(t>best) { best=t; bestc=c }}
  return bestc }
```

Run with: `gawk -f nb.awk soybean.csv`

**A8.** Get it running. At the END, print accuracy: `correct/total` as a percentage.

**A9.** Add a command-line variable `-v wait=N` that controls how many rows to use for initial training (currently hardcoded as 10). Test with `wait=20` and `wait=50`. Does accuracy change?

**A10.** *(for grad students)* Add Laplace smoothing parameters `-v k=1` and `-v m=2`. Right now the code uses `+1` in the numerator and `+Attr[i]` in the denominator. Replace these with `+k` and `+k*Attr[i]`. The prior calculation should use `m`: `(Classes[c]+m)/(Total+m*NumClasses)`. You'll need to track `NumClasses`.

---

## Part B: Lua via Python (8 exercises)

You have `nb.py` and `nb.lua`. They do the same thing. Your job: understand the Lua by mapping it to Python you already know.

**B1.** In `nb.lua`, find the equivalent of Python's `class Obj(dict)`. Write 3-4 sentences explaining how `isa()` and metatables give you the same dot-notation access that Python's `__getattr__` provides.

**B2.** Look at this Lua function signature:
```lua
function NUM.add(i,v,    d)
```
The extra spaces before `d` are a Lua convention: everything after the gap is a local variable, not a parameter. So `i` and `v` are inputs; `d` is scratch space. Lua doesn't have a `local` keyword in function signatures, so this is how we signal intent.

Question: What are `i` and `v` in this context? Write the Python equivalent with type hints.

**B3.** Compare `like()` in both files. The Lua version uses `i.sd^2` but the Python version computes `sd` on the fly from `m2`. Why the difference? Which design would you prefer and why?

**B4.** At the bottom of `nb.lua`:
```lua
return {the=the, SYM=SYM, NUM=NUM, ...}
```
What's this doing? What's the Python equivalent? (Hint: think about `import`.)

**B5.** In Python we write:
```python
for n, row in enumerate(rows):
```
Find the Lua equivalent in `nb()`. How does Lua handle the "give me index and value" problem differently?

**B6.** *(for grad students)* Look at `Cols()` in both files. Python uses list comprehensions:
```python
x=[c for c in all if not re.search(r"[!X]$", c.txt)]
```
What does Lua use instead? Find the equivalent line in `nb.lua`.

**B7.** *(for grad students)* In `lib.lua`, find the `most()` function. It returns the key where `f(k,v)` is maximum. Write a Python equivalent in 3-4 lines.

**B8.** *(for grad students)* The Python code uses `match/case` for pretty-printing in `o()`. The Lua version uses `if/elseif`. But there's a deeper difference in how they detect types. What is it? (Hint: look at `math.type()` and `getmetatable()`.)

Submit: a text file with your answers. No code required for Part B.

---

## Part C: First-Class Functions (6 exercises)

Implement these in Lua. Put them all in one file called `fp.lua`. Include a test for each function that prints something sensible.

**C1. collect(t, f)** — return a new table with `f` applied to each element.
```lua
collect({1,2,3}, function(x) return x*x end)  --> {1,4,9}
```

**C2. select(t, f)** — return elements where `f` returns true.
```lua
select({1,2,3,4,5}, function(x) return x%2==0 end)  --> {2,4}
```

**C3. reject(t, f)** — return elements where `f` returns false.
```lua
reject({1,2,3,4,5}, function(x) return x%2==0 end)  --> {1,3,5}
```

**C4. inject(t, acc, f)** — fold left. `f` takes `(accumulator, element)`.
```lua
inject({1,2,3,4}, 0, function(a,x) return a+x end)  --> 10
inject({1,2,3,4}, 1, function(a,x) return a*x end)  --> 24
```

**C5.** *(for grad students)* detect(t, f) — return first element where `f` is true, or `nil`.
```lua
detect({1,2,3,4}, function(x) return x>2 end)  --> 3
```

**C6.** *(for grad students)* range(start, stop, step) — return an iterator (not a table).
```lua
for x in range(1,10,2) do print(x) end  --> 1 3 5 7 9
```

This last one is tricky. Lua iterators are functions that return functions. Look at `iter()` in `lib.lua` for a hint.
