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

# Some Javascript Examples

Note:

- not the sort of JS seen in job interview questions
  - no class, prototypes, etc
- pure functional programming in JS is limited by lack of  tail call optimization
- JS has some wonderful funnies. Like `x == y` does first tries type conversion  to same type.
  - `x === y` checks types and values without any conversions.

BTW, this code is all `sync`; i.e. no asynchronous  interlevering of reads threads

```js
// old school JS node example with call back
import fs from "fs"

fs.readFile("data.txt", "utf8",
  (err, s) => err ? die(err) : out(s))

// another eg.
// note the call back function, run when read happens `r ==> r.text()`
onst txt = await fetch("data.txt").then(r => r.text())

// chatgpt recommends a slightly different style:
const r   = await fetch("data.txt")
const txt = await r.text()
```
The following code using `readFileSync` i.e. no `async`.


```js
#!/usr/bin/env node
// ez.js: easy AI tools
// (c) 2025 Tim Menzies, MIT license
//
// Options:
//    -b bins=5    Number of bins
//    -B Budget=50 Initial sampling budget
//    -C Check=5   final evaluation budget
//    -l leaf=2    Min examples in leaf of tree
//    -p p=2       Distance coefficient
//    -s seed=1    Random number seed
//    -S Show=30   Tree display width

let fs = require("fs")
let BIG = 1e32, the = {}

//--- random (seedable) -------------------------------------------------------
let _seed = 1
let srand = (n) => { _seed = n }
let rand  = () => { _seed = (16807*_seed) % 2147483647
                     return _seed / 2147483647 }

let shuffle = (a) => {
  for (let i = a.length-1; i > 0; i--) {
    let j = Math.floor(rand() * (i+1));
    [a[i], a[j]] = [a[j], a[i]] }
  return a }

let gauss = (mu,sd1) => mu + 2*sd1*(rand()+rand()+rand() - 1.5)

let pick = (d, n) => {
  n *= rand()
  for (let k in d) if ((n -= d[k]) <= 0) return k }

//--- lib ---------------------------------------------------------------------
let clip   = (v,lo,hi) => Math.max(lo, Math.min(hi, v))
let log2   = (n) => Math.log(n) / Math.log(2)
let sorted = (a, f) => [...a].sort((x,y) => f(x) - f(y))

let cast = (s) => s==="true" ? true : s==="false" ? false
                  : isNaN(Number(s)) ? s : Number(s)

let csv = (f) =>
  fs.readFileSync(f,"utf8").trim().split("\n")
    .map(s => s.split(",").map(cast))

let o = (t) =>
  typeof t === "function"      ? (t.doc || "")
  : Array.isArray(t)           ? "["+t.map(o).join(", ")+"]"
  : typeof t === "number"      ? (t===Math.floor(t) ? ""+t : t.toFixed(2))
  : t && typeof t === "object" ? "{"+Object.keys(t)
                                    .map(k => `:${k} ${o(t[k])}`)
                                    .join(" ")+"}"
  : ""+t

//--- create ------------------------------------------------------------------
let NUM = (d={}) => ({it:"NUM", n:0, mu:0, m2:0, ...d})
let SYM = (d={}) => ({it:"SYM", n:0, has:{},     ...d})

let COL = (at=0, txt=" ") =>
  (txt[0] === txt[0].toUpperCase() ? NUM : SYM)(
    {at, txt, goal: txt.slice(-1) !== "-"})

let DATA = (items=[], s="") =>
  adds(items, {it:"DATA", txt:s, rows:[], cols:null})

let COLS = (names) => {
  let cols = names.map((s,n) => COL(n, s))
  return {it:"COLS", names, all:cols,
          x: cols.filter(c => !"-+!X".includes(c.txt.slice(-1))),
          y: cols.filter(c =>  "-+!".includes(c.txt.slice(-1))) }}

let clone = (data, rows=[]) => DATA([data.cols.names, ...rows])

//--- update ------------------------------------------------------------------
let adds = (items, it) => {
  it = it || NUM()
  for (let v of items) add(it, v)
  return it }

let add = (i, v) => {
  if (i.it === "DATA") {
    if (!i.cols) i.cols = COLS(v)
    else i.rows.push(i.cols.all.map(c => add(c, v[c.at])))
  } else if (v !== "?") {
    i.n += 1
    if (i.it === "SYM") i.has[v] = 1 + (i.has[v] || 0)
    if (i.it === "NUM") { let d = v-i.mu; i.mu += d/i.n
                          i.m2 += d*(v - i.mu) }
  }
  return v }

//--- query -------------------------------------------------------------------
let score = (num) =>
  num.n < the.leaf ? BIG
                   : num.mu + sd(num)/(Math.sqrt(num.n) + 1/BIG)

let mids = (data) => data.cols.all.map(mid)
let mid  = (col) => col.it === "SYM" ? mode(col) : col.mu
let mode = (sym) => Object.keys(sym.has)
                      .reduce((a,b) => sym.has[a]>=sym.has[b] ? a : b)

let spread = (col) => col.it === "SYM" ? ent(col) : sd(col)
let sd  = (num) => num.n<2 ? 0 : Math.sqrt(num.m2/(num.n-1))

let ent = (sym) => {
  let out = 0
  for (let k in sym.has) {
    let p = sym.has[k]/sym.n; if (p > 0) out -= p*log2(p) }
  return out }

let z      = (num,v) => (v - num.mu) / (sd(num) + 1/BIG)
let norm   = (num,v) => 1 / (1 + Math.exp(-1.7 * v))
let bucket = (num,v) =>
  Math.floor(the.bins * norm(num, clip(z(num,v), -3, 3)))

//--- distance ----------------------------------------------------------------
let minkowski = (items) => {
  let n=0, d=0
  for (let x of items) { n++; d += x ** the.p }
  return n === 0 ? 0 : (d/n) ** (1/the.p) }

let disty = (data, row) =>
  minkowski(data.cols.y.map(y => norm(y, row[y.at]) - y.goal))

let distx = (data, r1, r2) =>
  minkowski(data.cols.x.map(x => aha(x, r1[x.at], r2[x.at])))

let aha = (col, u, v) => {
  if (u === "?" && v === "?") return 1
  if (col.it === "SYM")      return u !== v ? 1 : 0
  u = norm(col,u); v = norm(col,v)
  if (u === "?") u = v > 0.5 ? 0 : 1
  if (v === "?") v = u > 0.5 ? 0 : 1
  return Math.abs(u - v) }

let furthest = (data,row,rows) => around(data,row,rows).slice(-1)[0]
let nearest  = (data,row,rows) => around(data,row,rows)[0]
let around = (data,row,rows) => sorted(rows, r => distx(data,row,r))

//--- cli ---------------------------------------------------------------------
let run = (f, ...a) => {
  srand(the.seed)
  try { f(...a) } catch(e) { console.error(e.stack) } }

let egs = {
  h: {doc:"Show help.", f:() => {
    console.log("ez.js: easy AI tools\n\nOptions:")
    for (let k in the) console.log(`   -${k} ${k}=${the[k]}`)
    console.log("\nActions:")
    for (let k in egs)
      console.log(`   -${k.padEnd(12)} ${egs[k].doc}`) }},

  _the: {doc:"Show config.", f:() => console.log(o(the)) },

  s: {doc:"Set seed.", a:[Number], f:(n) => {
    the.seed = n; srand(n) }},

  _csvs: {doc:"csv reader.", a:["file"], f:(f) =>
    csv(f).filter((_,i) => i%40===0)
           .forEach(r => console.log(o(r))) },

  _syms: {doc:"SYMs summary.", f:() => {
    let syms = adds("aaaabbc", SYM()), x = ent(syms)
    console.log(o(x))
    console.assert(Math.abs(1.379 - x) < 0.05) }},

  _nums: {doc:"NUMs summary.", f:() => {
    let nums = NUM()
    for (let i=0; i<1000; i++) add(nums, gauss(10, 1))
    console.log(o({mu: nums.mu, sd: sd(nums)}))
    console.assert(Math.abs(10 - nums.mu) < 0.05)
    console.assert(Math.abs(1 - sd(nums)) < 0.05) }},

  _ys: {doc:"Show ys.", a:["file"], f:(f) => {
    let data = DATA(csv(f))
    console.log(data.cols.names.join(" "))
    console.log(o(mids(data)))
    sorted(data.rows, r => disty(data,r))
      .filter((_,i) => i%40===0)
      .forEach(row => {
        let bs = data.cols.y.map(c => bucket(c, row[c.at]))
        console.log(...row,...bs,disty(data,row).toFixed(2))
      }) }},

  _tree: {doc:"Show tree.", a:["file"], f:(f) => {
    let data  = DATA(csv(f))
    let data1 = clone(data, shuffle(data.rows).slice(0,50))
    let [tree] = Tree(data1)
    treeShow(tree) }},

  _test: {doc:"Run tests.", a:["file"], f:(f) => {
    let data = DATA(csv(f))
    let half = Math.floor(data.rows.length / 2)
    let Y   = r => disty(data, r)
    let b4  = sorted(data.rows, Y).map(Y)
    let win = r => Math.floor(
      100*(1 - (Y(r)-b4[0]) / (b4[half]-b4[0]+1/BIG)))
    let wins = NUM()
    for (let i=0; i<60; i++) {
      let rows  = shuffle(data.rows)
      let train = rows.slice(0,half).slice(0, the.Budget)
      let test  = rows.slice(half)
      let [tree] = Tree(clone(data, train))
      test.sort((a,b) =>
        treeLeaf(tree,a).y.mu - treeLeaf(tree,b).y.mu)
      add(wins, win(test.slice(0,the.Check)
                        .reduce((a,b) => Y(a)<Y(b)?a:b))) }
    console.log(
      [Math.round(wins.mu),"sd",Math.round(sd(wins)),
       "b4",o(b4[half]),"lo",o(b4[0]),
       "x",data.cols.x.length,"y",data.cols.y.length,
       "r",data.rows.length,
       ...f.split("/").slice(-2)].join(" ,")) }} }

//--- boot --------------------------------------------------------------------
let doc = fs.readFileSync(__filename, "utf8")
for (let m of doc.matchAll(/(\S+)=(\S+)/g))
  if (m.index < 500) the[m[1]] = cast(m[2])
srand(the.seed)

let args = process.argv.slice(2), i = 0
while (i < args.length) {
  let key = args[i].slice(1).replace(/-/g, "_")
  let eg  = egs[key]
  if (eg) {
    let fa = (eg.a||[]).map(t => t==="file" ? args[++i]
                                            : t(args[++i]))
    run(eg.f, ...fa)
  } else if (key in the) { the[key] = cast(args[++i] || "") }
  i++ }
```

## Typescript

## 1. The "Interface" Definition

* **Behavioral Typing**: In this view, a type is a contract. If a
value has type `T`, it guarantees that a specific set of messages or operations
(methods, functions) can be applied to it without the system "crashing" or entering
an undefined state.

* **Duck Typing:**: "If it walks like a duck and quacks like a duck..." The
interface is discovered at runtime.
* **Static Interfaces:** The compiler ensures the "quack" method exists before the
code even runs.

## 2. The "Static Inference" Definition

iN the **Syntactic/Logical** view, types are
constraints in a system of equations.

* **Type Propagation:** The compiler uses rules (like Hindley-Milner) to flow types
through the program.

   - * Hindley-Milner (HM) is a formal logic system used to deduce the most general type of an expression without explicit annotations.
   - * **Var (Variable):** If  is defined as type σ in the environment, then  has type σ. 
   - **App (Application):** If function  has type τ<sub>1</sub> → τ<sub>2</sub> and argument  has type τ<sub>1</sub>, then the result  has type τ<sub>2</sub>.
   - * **Abs (Abstraction):** If a function takes  of type τ<sub>1</sub> and the body  results in τ<sub>2</sub>, then the function λ has type τ<sub>1</sub> → τ<sub>2</sub>.
   - * **Let (Polymorphism):** To type `let x = e1 in e2`, the system finds the most general type for `e1`, "generalizes" it (makes it generic), and then checks `e2` using that generic type.
   - * **Inst (Instantiation):** A generic type (like ∀α. α → α) can be converted into a specific one (like  → ) when used.
   - * **Gen (Generalization):** If a type variable α doesn't appear in the environment's assumptions, it can be marked as "forall" (∀α), making it polymorphic.
   - Key Entities Used:

        * **τ** (`&tau;`): Tau (Type variable)
        * **σ** (`&sigma;`): Sigma (Type scheme)
        * **→** (`&rarr;`): Arrow (Function mapping)
        * **λ** (`&lambda;`): Lambda (Function abstraction)
        * **∀** (`&forall;`): Universal quantifier (Polymorphism)
        * **α** (`&alpha;`): Alpha (Generic type variable)
        
* **Safety:** It acts as a formal proof that "no variable will ever hold a value
that violates its type's definition."

Verification is the process of proving that a program satisfies certain properties.
Types are the simplest form of formal verification.

* **Refinement Types:** These allow you to embed logic directly into the type.
Instead of just `number`, you define a type `Natural` as .
The compiler now verifies your logic, not just your data format.
* **The Curry-Howard Correspondence:** This is a deep computer science principle
stating that **a program is a proof, and a type is the formula it proves.** If
you can write a function that satisfies a complex type, you have mathematically
proven that the logic is sound.
* **Termination Analysis:** Advanced type systems can verify that a function will
always return a value and never enter an infinite loop.

Compilers are essentially "uncertainty reduction machines." The more a compiler
knows (via types), the less work it has to do at runtime.

-  Monomorphization
In generic code (like `List<T>`), if the compiler knows `T` is an `int64`, it
doesn't create a generic list of pointers. It generates specialized machine code
that treats the data as raw 64-bit integers. This allows for **SIMD (Single
Instruction, Multiple Data)** optimizations.
-  Dead Code Elimination and Inlining
If a type system proves that a variable can *only* be a specific subclass, the
compiler can "devirtualize" function calls. Instead of looking up a method in a
jump table at runtime (slow), it can copy the function code directly into the
caller (fast).
- Memory Layout
Without types, a system might need to "box" every value (wrap it in a descriptor
that says "I am a float"). With types, the compiler knows exactly how many bytes
each object needs.
-  **Struct Packing:** The compiler can reorder fields in a type to minimize padding
and maximize cache hits.
* **Stack vs. Heap:** If the type system can prove a value doesn't "escape" a
function, it can be placed on the **stack** rather than the **heap**, avoiding
expensive garbage collection.


### Summary Table

| Feature | Without Types (Dynamic) | With Types (Static) |
| --- | --- | --- |
| **Errors** | Found by the user at runtime. | Found by the dev at compile time. |
| **Speed** | "Boxing" and runtime checks. | Raw machine instructions. |
| **Verification** | Unit tests (some cases). | Formal proofs (all cases). |
| **Docs** | Needs READMEs and comments. | The code is self-documenting. |


```typescript
#!/usr/bin/env ts-node
import fs from "fs"

// -b bins=5 -B budget=50 -C check=5 -l leaf=2 -p p=2 -s seed=1 -S show=30
type V = string | number | boolean
type Row = V[]
interface Col { it:"NUM"|"SYM"; n:number; at:number; txt:string; goal:number;
                mu:number; m2:number; has:Record<string, number> }
interface DATA { rows:Row[]; cols:{all:Col[], x:Col[], y:Col[], names:string[]} }

const the: any = {}, BIG = 1e32, egs: Record<string, any> = {}
let _seed = 1
const srand = (n:number) => _seed = n
const rand = () => (_seed = (16807 * _seed) % 2147483647) / 2147483647
const cast = (s:string): V => s=="true" || (s=="false" ? false : 
             isNaN(Number(s)) ? s : Number(s))

const col = (at:number, txt:string): Col => ({
  n:0, at, txt, it: /^[A-Z]/.test(txt) ? "NUM" : "SYM",
  goal: txt.endsWith("-") ? 0 : 1, mu:0, m2:0, has:{}
})

const add = (c:Col, v:V) => {
  if (v == "?") return v
  c.n++
  if (c.it == "NUM") {
    let d = (v as number) - c.mu
    c.mu += d / c.n
    c.m2 += d * ((v as number) - c.mu)
  } else c.has[v as string] = (c.has[v as string] || 0) + 1
  return v
}

const makeData = (rows: V[][] = []): DATA => {
  let d: DATA = { rows: [], cols: {all:[], x:[], y:[], names:[]} }
  rows.map((row, i) => {
    if (i == 0) {
      d.cols.names = row as string[]
      d.cols.all = d.cols.names.map((n, j) => col(j, n))
      const x = (s:string) => !"-+!X".includes(s.slice(-1))
      d.cols.x = d.cols.all.filter(c => x(c.txt))
      d.cols.y = d.cols.all.filter(c => !x(c.txt))
    } else d.rows.push(d.cols.all.map(c => add(c, row[c.at])))
  })
  return d
}

const sd = (c:Col) => c.n < 2 ? 0 : (c.m2 / (c.n - 1)) ** .5
const mid = (c:Col) => c.it=="SYM" ? 
  Object.keys(c.has).reduce((a,b) => c.has[a] > c.has[b] ? a : b) : c.mu
const norm = (c:Col, v:number) => 1 / (1 + Math.exp(-1.7 * ((v-c.mu)/(sd(c)+1/BIG))))

const csv = (f:string) => fs.readFileSync(f,"utf8").trim().split("\n")
                            .map(s => s.split(",").map(cast))

const o = (t:any): string => typeof t != "object" ? ""+t : 
  Array.isArray(t) ? "["+t.map(o).join(", ")+"]" :
  "{"+Object.keys(t).map(k => `:${k} ${o(t[k])}`).join(" ")+"}"

const dist = (d:DATA, r1:Row, r2:Row) => {
  let ds = d.cols.x.map(c => {
    let u = r1[c.at], v = r2[c.at]
    if (u=="?" && v=="?") return 1
    if (c.it == "SYM") return u != v ? 1 : 0
    let u1 = norm(c, u as number), v1 = norm(c, v as number)
    if (u=="?") u1 = v1 > .5 ? 0 : 1
    if (v=="?") v1 = u1 > .5 ? 0 : 1
    return Math.abs(u1 - v1)
  })
  return (ds.reduce((a,b) => a + b**the.p, 0) / ds.length) ** (1/the.p)
}

// Tests
egs.the = { doc:"Show config", f:() => console.log(o(the)) }
egs.sym = { doc:"SYM summary", f:() => {
  let s = col(0, "a")
  "aaaabbc".split("").map(x => add(s, x))
  console.log(mid(s))
}}
egs.num = { doc:"NUM summary", f:() => {
  let n = col(0, "A")
  for(let i=0; i<100; i++) add(n, i)
  console.log(n.mu, sd(n))
}}

// Boot
const src = fs.readFileSync(__filename, "utf8")
for (let m of src.matchAll(/(\S+)=(\S+)/g)) the[m[1]] = cast(m[2])
let args = process.argv.slice(2)
for (let i=0; i < args.length; i++) {
  let k = args[i].replace(/^-+/, ""), eg = egs[k]
  if (eg) { srand(the.seed); eg.f() }
  else if (the[k] !== undefined) the[k] = cast(args[++i])
}
```
