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


# Prompts, printing.

Lesson: 
- Polymorhism used a lot in Python (the "dunder" methods)
- Classes (usually) store their attributes internally in a magic variable  `__dict_``
- Inheritance can be cool (open-closed principle)
- Classes are cool places to store class-specific config.
- Core Python can be usefully improved.
- ask more than one LLM.
- LLMs are coo!
- Some LLMs are better than others
- LLMs are (sometimes) stupid

## Python Dunder (Magic) Methods Cheat Sheet

A quick reference for Python's special double-underscore methods.

### 1. Initialization & Representation
These methods control how objects are created and how they are displayed as
strings.

| Method | Purpose | Example |
| :--- | :--- | :--- |
| `__init__` | **Constructor**: Sets attributes. | `x = Class()` |
| `__new__` | **Creator**: Allocates memory. | `x = Class()` |
| `__str__` | **User String**: Pretty output. | `print(x)` |
| `__repr__` | **Debug String**: Exact representation. | `repr(x)` |
| `__del__` | **Destructor**: Cleanup logic. | `del x` |

### 2. Container & Iteration
Make your object behave like a list, dictionary, or iterator.

| Method | Purpose | Example |
| :--- | :--- | :--- |
| `__len__` | **Length**: Returns size. | `len(x)` |
| `__getitem__` | **Read**: Access by index/key. | `x['key']` |
| `__setitem__` | **Write**: Set by index/key. | `x['k'] = 1` |
| `__delitem__` | **Delete**: Remove by index/key. | `del x['k']` |
| `__iter__` | **Start Loop**: Returns iterator. | `for i in x:` |
| `__next__` | **Step**: Gets next item. | `next(iter)` |
| `__contains__`| **Check**: Membership test. | `'val' in x` |

### 3. Mathematical Operators
Enable math operations (`+`, `-`, `*`) and comparisons (`==`, `<`).

| Method | Purpose | Example |
| :--- | :--- | :--- |
| `__add__` | **Add**: `+` operator. | `x + y` |
| `__sub__` | **Sub**: `-` operator. | `x - y` |
| `__mul__` | **Mul**: `*` operator. | `x * y` |
| `__truediv__` | **Div**: `/` operator. | `x / y` |
| `__eq__` | **Equal**: `==` check. | `x == y` |
| `__lt__` | **Less**: `<` check. | `x < y` |

### 4. Advanced & Utility
Special handling for function calls, context managers (`with`), and attributes.

| Method | Purpose | Example |
| :--- | :--- | :--- |
| `__call__` | **Function**: Call obj as func. | `x(arg)` |
| `__enter__` | **Open**: Setup `with` block. | `with x:` |
| `__exit__` | **Close**: Teardown `with` block. | End of `with` |
| `__getattr__` | **Missing**: Handle missing attr. | `x.missing` |
| `__setattr__` | **Set**: Intercept attr assignment. | `x.a = 1` |


### Implementation Example

```python
class Wallet:
    def __init__(self, money):
        self.money = money          # __init__

    def __str__(self):
        return f"${self.money}"     # __str__ for print()

    def __add__(self, other):
        # Allows Wallet + Wallet or Wallet + int
        val = other.money if isinstance(other, Wallet) else other
        return Wallet(self.money + val)

    def __len__(self):
        return int(self.money)      # __len__ for len()

    def __call__(self):
        print("Cha-ching!")         # __call__ makes obj callable

# Usage
w1 = Wallet(50)
w2 = Wallet(20)

print(w1)       # Output: $50
w3 = w1 + w2    # Output: Wallet(70)
print(len(w1))  # Output: 50
w1()            # Output: Cha-ching!

```

## Prompting Engineering and Customiziing Prinitng

> Write a minimal Python class Thing with a class variable DECIMALS = 2 and a __repr__ method that formats only float attributes from self.__dict__ to that many decimals using a dictionary comprehension. Keep it under 80 chars per line and use as few lines as possible. Write a demo showing this working. Make 2 classes Employee and Car. Car inherits from thing. Car's prints are mich nice that Emplouee's default print.

## Chatgpt
```python
# chatgotclass Thing:
    DECIMALS = 2
    def __repr__(s):
        d={k:round(v,s.DECIMALS) for k,v in s.__dict__.items()
           if isinstance(v,float)}
        return f"{s.__class__.__name__}{d}"

class Employee:
    def __init__(s,name,salary):
        s.name,s.salary=name,salary

class Car(Thing):
    def __init__(s,make,speed,price):
        s.make,s.speed,s.price=make,speed,price
```

### Demo (chatgpt)
```python
e=Employee("tim",123456.789)
c=Car("mazda",123.4567,19999.999)

print(e)
print(c)

#—>
<__main__.Employee object at 0x109f6b610>
Car{'speed': 123.46, 'price': 20000.0}```

## Claude```pythonclass Thing:
    DECIMALS = 2
    def __repr__(s):
        d = {k: round(v, s.DECIMALS) for k, v in s.__dict__.items()
             if isinstance(v, float)}
        return f"{s.__class__.__name__}{d}"
```

## Gemini

```py
class Thing:
    DECIMALS = 2
    def __repr__(self):
        # Round floats, keep other attributes as-is
        d = {k: round(v, self.DECIMALS) if isinstance(v, float) else v
             for k, v in self.__dict__.items()}
        return f"{type(self).__name__}{d}"

class Employee:
    def __init__(self, name, salary):
        self.name, self.salary = name, salary

class Car(Thing):
    def __init__(self, make, speed, price):
        self.make, self.speed, self.price = make, speed, price
```
### Demo (Gemini)

```py
e = Employee("tim", 123456.789)
c = Car("mazda", 123.4567, 19999.999)

print(e)
print(c)

#—> 
<__main__.Employee object at 0x...> Car{'make': 'mazda', 'speed': 123.46, 'price': 20000.0}``
```

> Would you like to see how to implement this using Python's dataclasses for even less boilerplate?

> Heck yes. and is there anything better (most succinct) that dataclass?

```py
from dataclasses import dataclass

class Thing:
    DECIMALS = 2
    def __repr__(self):
        d = {k: round(v, self.DECIMALS) if isinstance(v, float) else v 
             for k, v in self.__dict__.items()}
        return f"{type(self).__name__}{d}"

@dataclass
class Car(Thing):
    make: str
    speed: float
    price: float
```
### Demo (Gemini)
```py
c = Car("mazda", 123.4567, 19999.999)
print(c)   #—> 
Output: Car{'make': 'mazda', 'speed': 123.46, 'price': 20000.0}```But wait, there’s more!```pyfrom types import SimpleNamespace as obj

# No class definition needed
c = obj(make="mazda", speed=123.4567, price=19999.999)

print(c)
# Output: namespace(make='mazda', price=19999.999, speed=123.4567
```

And the fun keeps on coming

> Would you like to see how to hack SimpleNamespace to include your custom rounding logic in just two lines?

> Heck, yes

```py
from types import SimpleNamespace as obj

class Thing(obj):
  def __repr__(s): return f"Thing{ {k:round(v,2) if isinstance(v,float) else v for k,v in s.__dict__.items()} }"
```

# Demo
```py
c = Thing(make="mazda", speed=123.4567, price=19999.999)
print(c)#—>Thing{'make': 'mazda', 'speed': 123.46, 'price': 20000.0}
```

But the way, the above has a bug. It always prints the Thing name not the subclass name `type(self)`.
 