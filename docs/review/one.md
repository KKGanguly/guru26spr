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

# REview1


## Technical Terms & Concepts


### **Shebang (`#!`)**
The first line in a script (e.g., `#!/usr/bin/env python`) that
tells the OS which interpreter to use. It is a prime example of
late binding.

```py
#!/usr/bin/env python3 -B

print("Pythn will run me")
```

```gawk
#!/usr/bin/env gawk -f

BEGIN { print "Gawk will run me" }
```


### **Distributed Control**
A system design where no single "god object" rules. Control is passed
hand-to-hand between small, independent tools (like the OS handing
off to Python).

Example:

- Lots of code files with different she-bangs
- A JSON server where start-up comma's are specified in the JSON. The underlying system software delivers the software to different services, and what happens next is controlled byt that JASON at that service

### **Late Binding**
Deciding *what* code to run at the last possible second (runtime)
rather than hard-coding it.

Example: The OS reading a shebang line to find an interpreter.*

### **Dependency Injection**
Passing objects (like config or functions) into a function rather
than hard-coding them inside. This makes code testable and modular.

### **Lambda / Lambda Body**
An anonymous, throw-away function defined inline. In Python, often
used for short operations.

Example: 
- `lambda x: x * 2`
- `print(sorted([3,4,1], key=lambda x: -x))` # print in reverse order

### **Open / Closed Principle Body**
Code should be open to modify execution while being closed to being edited.

Example: the `key` keyword in Python sort (lets us sort on many things in many different ways)
```py
def gt(n): return lambda a: - a[n]  

print(sorted([[1,2,3],[10,9,8]], key=gt(1)))
 # --> [[10, 9, 8], [1, 2, 3]]
```
### **First-Class Functions**
Treating functions like any other variable: passing them as arguments,
returning them from other functions, or storing them in lists.
Note that when we pass functions, we also pass along the ocal vars on that function. 

Example1: the `gt(1)` example shown above.

Example2: kind a mini-OO systems wher a function returns a function that dispaches a command:

```py
def Obj():
    x = 0
    def f(msg):
        nonlocal x
        if msg == "inc": x += 1
        if msg == "get": return x
    return f

o = Obj()
o("inc")
o("inc")
print(o("get"))  # 2
```

### **Decorators**
A design pattern (and Python syntax `@wrapper`) that wraps a function
to modify its behavior without changing its code.

```py
def memo(f):
    "This function returns a function. Cool!"
    cache = {}
    def g(x):
        if x not in cache:
            cache[x] = f(x)
        return cache[x]
    return g 

@memo
def fib(n):
    return n if n < 2 else fib(n-1) + fib(n-2)

for i in range (10,100):
  print(i,":", end="",flush=True)
  fib(i)   # instant
```

### **Callbacks**
A function passed as an argument to be "called back" later when an
event happens (like a button click or a file finishing loading).

### **Factory Function**
A function whose job is to create and return other functions or
objects, often pre-configured with specific settings.

A special kind of constructor
- Constructors deterministically return one type
- Factories may use some reflection to return one type or another.
- Factories may returna  whole forest of types (e.g. might configure a web interface from a YAML file)

### **Polymorphism**
The ability for different objects to respond to the same method call
in their own way. It replaces big `if/else` chains checking types.

### **Casing on Type**
An "evil" anti-pattern where code checks an object's type (e.g.,
`if type(x) == int`) instead of using polymorphism.

### **SimpleNamespace**
A Python utility (from `types`) that lets you access dictionary keys
as object attributes (e.g., `obj.name` instead of `obj['name']`).

### **List Comprehension**
A concise syntax for creating a new list by applying an expression to
each item in an existing sequence.

- A list comprehension is just a loop, an if, and an append — compressed.

Examples:
 - square even numbers `squares = [x*x for x in range(10) if x % 2 == 0]`
 - flatten a list: `flat = [x for row in [[1,2],[3,4],[5]] for x in row]`
 - label things: `labels = ["big" if x > 10 else "small" for x in [3, 12, 7, 20]]`

Here they are **re-written in raw Python** (no comprehensions), as plainly and mechanically as possible.

```py
squares = []
for x in range(10):
    if x % 2 == 0:
        squares.append(x * x)

flat = []
for row in [[1, 2], [3, 4], [5]]:
    for x in row:
        flat.append(x)

labels = []
for x in [3, 12, 7, 20]:
    if x > 10:
        labels.append("big")
    else:
        labels.append("small")
```

### **Supply Chain Attack**
A security threat where an attacker compromises a library you depend
on (like a pip package), causing malicious code to run inside your
application without you realizing it.


## Design Principles & Philosophies

- **Separation of Concerns (SoC)**
Dividing a program into distinct sections, where each handles a
specific job (e.g., grading logic vs. printing results).
- **Single Responsibility Principle**
A function or module should have one, and only one, reason to change.
It should do one thing well.

- **DRY (Don't Repeat Yourself)**
The principle that knowledge or logic should appear only once in the
codebase. If you copy-paste, you are creating a maintenance debt.

- **YAGNI (You Ain't Gonna Need It)**
Don't add functionality until it is necessary. "Gurus" reject
speculative complexity.

- **VITAL**
"Vitally Important Technologies Acquired Locally." If a tech is core
to your business, you must own and understand it, not rent it.

- **Backpacking (Minimalism)**
Carrying only the dependencies you absolutely need. Avoids "bloat"
so your code remains portable and easy to maintain.

- **Mechanism vs. Policy**
Separating *how* something is done (Mechanism) from *what* is done
(Policy).
*Example: A grading engine (mech) vs. the specific grade cutoffs (policy).*

- **Fold Knowledge into Data**
Moving logic out of `if` statements and into data structures (like
dicts or lists). Makes code "stupid and robust."

- **Normalization**
Converting data into a standard range (often 0.0 to 1.0) to make it
easier to compare, grade, or process uniformly.

- **Behavior Oriented Programming (BOP)**
A mindset of defining software by what it *does* (its behaviors and
tests) rather than just its data structures.


## Practice Questions


### **Topic: Core Philosophies & Acronyms**

**1. VITAL**

* **a) (2 mins)** What does the acronym **VITAL** stand for?
* **b) (4 mins)** Explain the strategic risk of "renting" a core
technology (like an AI model) instead of owning it locally.

**2. YAGNI**

* **a) (2 mins)** What does **YAGNI** stand for?
* **b) (4 mins)** A developer adds a "User Export" feature because
"we might need it next month." Explain why this violates YAGNI.

**3. Backpacking**

* **a) (2 mins)** Define the "Backpacking" concept from the notes.
* **b) (4 mins)** How does adding too many dependencies ("Car
Camping") hurt the portability and maintenance of a project?

**4. DRY (Don't Repeat Yourself)**

* **a) (2 mins)** Define the **DRY** principle.
* **b) (4 mins)** Explain exactly how copy-pasting code creates
"Maintenance Debt" when a bug is found in one copy.

**5. Open/Closed Principle**

* **a) (2 mins)** Define the Open/Closed Principle.
* **b) (4 mins)** How does Python's `sort(key=func)` allow sorting
to be "open for extension" without changing the sort code?

---

### **Topic: Architecture & Design Principles**

**6. Mechanism vs. Policy**

* **a) (2 mins)** Define "Mechanism" and "Policy."
* **b) (4 mins)** In a grading script, identify the Mechanism and
the Policy:
`if score >= 90: return "A"`

**7. Separation of Concerns (SoC)**

* **a) (2 mins)** Define Separation of Concerns.
* **b) (4 mins)** **Critique:** Why is a function named
`fetch_data_and_render_html()` a bad design choice?

**8. Single Responsibility Principle (SRP)**

* **a) (2 mins)** Define the Single Responsibility Principle.
* **b) (4 mins)** You see a 50-line function with comments like
`# Step 1: Load` and `# Step 2: Calc`. How should this be
refactored?

**9. Folding Knowledge into Data**

* **a) (2 mins)** Explain the phrase "Fold knowledge into data."
* **b) (4 mins)** **Refactor:** Explain how a long chain of
`if/elif` statements can be replaced by a simple Dictionary
lookup.

**10. Normalization**

* **a) (2 mins)** What is "Data Normalization" in this context?
* **b) (4 mins)** Why is it easier to grade assignments if all raw
scores (e.g., 45/50, 9/10) are converted to a 0.0-1.0 float?

**11. Testability**

* **a) (2 mins)** What makes a function "hard to test"?
* **b) (4 mins)** Explain how separating "Calculation" logic from
"Printing" logic eliminates the need to mock `stdout`.

**12. Reusability**

* **a) (2 mins)** Define Reusability.
* **b) (4 mins)** Why is a "Monolithic" script (one big file) harder
to reuse in a web application than a modular one?

---

### **Topic: Scripting & Runtime Concepts**

**13. The Shebang (`#!`)**

* **a) (2 mins)** What is the purpose of the `#!` line at the top of
a file?
* **b) (4 mins)** How does the Shebang illustrate "Late Binding"
(deciding *how* to run a file at the last moment)?

**14. Distributed Control**

* **a) (2 mins)** Define "Distributed Control."
* **b) (4 mins)** Contrast Distributed Control with a "God Object."
Why is it safer for the OS to hand off control to tools?

**15. Casing on Type**

* **a) (2 mins)** What is the "Casing on Type" anti-pattern?
* **b) (4 mins)** Why is checking `if type(x) == int` considered
brittle compared to using Polymorphism?

**16. Callbacks**

* **a) (2 mins)** Define a "Callback" function.
* **b) (4 mins)** Why do we pass a function *name* (e.g., `run`)
instead of calling it (`run()`) when setting up a button click?

---

### **Topic: Python Mechanics**

**17. Lambda Functions (Reading Comprehension)**

* **a) (2 mins)** What is a Lambda function in Python?
* **b) (4 mins)** **Explain this code:** What specific job is the
lambda doing here?
`sorted_files = sorted(files, key=lambda f: f.size)`

**18. List Comprehensions**

* **a) (2 mins)** What is the purpose of a List Comprehension?
* **b) (4 mins)** **Refactor:** Convert this loop to a comprehension.
`res = []`
`for x in nums: res.append(x*2)`

**19. SimpleNamespace**

* **a) (2 mins)** What is `types.SimpleNamespace`?
* **b) (4 mins)** How does it improve code readability compared to
using a standard Dictionary with bracket syntax `['key']`?

