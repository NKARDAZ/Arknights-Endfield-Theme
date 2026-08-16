#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ============ 1. КОММЕНТАРИИ ============
# однострочный комментарий
"""
Docstring модуля — тоже своего рода блочный комментарий.
Многострочный.
"""

# ============ 2. ИМПОРТЫ ============
from __future__ import annotations
import re
import os.path as osp
from typing import Optional, List, Dict, Union, Callable, TypeVar, Generic
from dataclasses import dataclass, field
from abc import ABC, abstractmethod
from enum import Enum, auto
from functools import wraps, lru_cache
from contextlib import contextmanager

# ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ЧИСЕЛ ============
INT_DEC: int = 42
INT_NEG: int = -17
FLOAT_NUM: float = 3.14159
EXP_NUM: float = 6.022e23
HEX_NUM: int = 0xFF00FF
OCT_NUM: int = 0o755
BIN_NUM: int = 0b10101010
UNDERSCORE_SEP: int = 1_000_000
COMPLEX_NUM: complex = 3 + 4j
BOOL_TRUE: bool = True
BOOL_FALSE: bool = False
NONE_VAL = None

# ============ 4. СТРОКИ ============
single = 'одинарные кавычки'
double = "двойные \"кавычки\" с \n экранированием"
triple = """
многострочная
строка
"""
raw_str = r"C:\path\no\escape"
f_string = f"Значение: {INT_DEC!r}, hex: {INT_DEC:#x}, pad: {INT_DEC:05d}"
byte_str = b"bytes literal \x00"
concat = "часть1" "часть2"

PATTERN = re.compile(r"^\d{3}-\d{2}-\d{4}$")

# ============ 5. ПЕРЕМЕННЫЕ И TYPE HINTS ============
name: str
age: int = 0
items: List[str] = []
mapping: Dict[str, int] = {}
maybe: Optional[str] = None
union_type: Union[int, str] = 1
callback: Callable[[int, int], int] = lambda a, b: a + b

T = TypeVar("T")

# ============ 6. ФУНКЦИИ ============
def simple_function(a, b=10, *args, c, d=None, **kwargs):
    """Docstring функции."""
    return a + b

def annotated_function(x: int, y: int = 0) -> int:
    return x + y

lambda_fn = lambda x, y=1: x * y

def decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

@decorator
@lru_cache(maxsize=128)
def cached_function(n: int) -> int:
    return n * n

async def async_function():
    await some_coroutine()

async def async_generator():
    for i in range(10):
        yield i

def generator_function():
    yield 1
    yield from [2, 3]

@contextmanager
def managed_resource():
    yield "resource"

# ============ 7. КЛАССЫ ============
class Animal(ABC):
    """Базовый абстрактный класс."""

    species: str = "unknown"
    _protected_field: int = 0
    __private_field: int = 0

    def __init__(self, name: str, age: int = 0) -> None:
        self.name = name
        self.age = age

    def __repr__(self) -> str:
        return f"Animal({self.name!r})"

    def __eq__(self, other) -> bool:
        return isinstance(other, Animal) and self.name == other.name

    @property
    def description(self) -> str:
        return f"{self.name}, {self.age}"

    @description.setter
    def description(self, value: str) -> None:
        self.name = value

    @staticmethod
    def make_sound() -> str:
        return "..."

    @classmethod
    def create_default(cls) -> "Animal":
        return cls("default")

    @abstractmethod
    def move(self) -> None:
        ...


class Dog(Animal):
    def move(self) -> None:
        print("бежит")


@dataclass
class Point:
    x: float
    y: float
    tags: List[str] = field(default_factory=list)

    def __post_init__(self) -> None:
        self._normalized = False


class Container(Generic[T]):
    def __init__(self, item: T) -> None:
        self._item = item

    def get(self) -> T:
        return self._item


class Color(Enum):
    RED = auto()
    GREEN = auto()
    BLUE = auto()

# ============ 8. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if BOOL_TRUE:
    print("if")
elif BOOL_FALSE:
    print("elif")
else:
    print("else")

for i in range(10):
    if i == 5:
        continue
    if i == 8:
        break
else:
    print("цикл завершён без break")

n = 0
while n < 3:
    n += 1
else:
    print("while завершён")

with open("/tmp/file.txt", "w") as f, open("/tmp/f2.txt") as g:
    f.write("data")

try:
    raise ValueError("тестовая ошибка")
except (ValueError, TypeError) as e:
    print(f"поймано: {e}")
except Exception:
    print("общее исключение")
else:
    print("без ошибок")
finally:
    print("finally")

match INT_DEC:
    case 0:
        print("ноль")
    case n if n > 10:
        print("больше 10")
    case [a, b]:
        print("список из двух")
    case {"key": value}:
        print("словарь")
    case Point(x=0, y=0):
        print("точка в начале координат")
    case _:
        print("иначе")

# ============ 9. КОМПРЕХЕНШЕНЫ ============
squares = [x ** 2 for x in range(10) if x % 2 == 0]
gen_expr = (x for x in range(10))
dict_comp = {k: v for k, v in zip("abc", [1, 2, 3])}
set_comp = {x for x in range(10)}
nested = [[y for y in range(x)] for x in range(5)]

# ============ 10. ОПЕРАТОРЫ ============
arithmetic = 1 + 2 - 3 * 4 / 5 // 6 % 7 ** 2
comparison = 1 < 2 and 3 > 2 or not (4 <= 4)
identity_op = None is None
membership = "a" in "abc" and "x" not in "abc"
walrus = (result := 10) > 5

# ============ 11. ВСТРОЕННЫЕ ФУНКЦИИ / ТИПЫ ============
print(len([1, 2, 3]), type(1), isinstance(1, int), sum([1, 2]), sorted([3, 1, 2]))
super().__init__() if False else None

# ============ 12. АССЕРТЫ И ИСКЛЮЧЕНИЯ ============
assert INT_DEC == 42, "должно быть 42"

if __name__ == "__main__":
    dog = Dog(name="Бобик", age=3)
    print(dog.description, dog.make_sound())
