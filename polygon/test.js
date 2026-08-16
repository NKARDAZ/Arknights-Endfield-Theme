// ============ 1. КОММЕНТАРИИ ============
// однострочный комментарий
/* блочный
   многострочный комментарий */
/**
 * JSDoc комментарий
 * @param {string} name - имя
 * @returns {number} результат
 * @deprecated используйте newFn
 */

// ============ 2. ИМПОРТЫ / ЭКСПОРТЫ ============
"use strict";
import defaultExport, { namedA, namedB as aliasB } from "./module.js";
import * as ns from "./namespace.js";
export default class Main {}
export { namedA, aliasB };
export const CONST_EXPORT = 1;

// ============ 3. ЛИТЕРАЛЫ ЧИСЕЛ ============
const intDec = 42;
const intNeg = -17;
const floatNum = 3.14159;
const expNum = 6.022e23;
const expNeg = 1.5e-10;
const hexNum = 0xFF00FF;
const octNum = 0o755;
const binNum = 0b10101010;
const bigInt = 9007199254740993n;
const underscoreSep = 1_000_000.000_1;
const specials = [NaN, Infinity, -Infinity];

// ============ 4. СТРОКИ И ШАБЛОНЫ ============
const single = 'одинарные кавычки';
const double = "двойные \"кавычки\" с экранированием";
const escapes = "перевод\nстроки\tтаб\\бэкслеш\u00e9юникод";
const template = `Шаблон с ${intDec} и ${floatNum.toFixed(2)} внутри`;
const multilineTemplate = `
  многострочная
  строка
`;
const tagged = String.raw`C:\path\to\file`;
const regex1 = /^[a-zA-Z0-9_.+-]+@[\w-]+\.\w+$/gi;
const regex2 = /(?<year>\d{4})-(?<month>\d{2})/;

// ============ 5. КОНСТАНТЫ ЯЗЫКА ============
const boolTrue = true;
const boolFalse = false;
const nothing = null;
const notDefined = undefined;

// ============ 6. ПЕРЕМЕННЫЕ И ОБЪЯВЛЕНИЯ ============
var oldStyle = 1;
let mutable = 2;
const immutable = 3;
let a, b, c;
let [x, y, ...rest] = [1, 2, 3, 4];
let { key, nested: { deep } = {} } = { key: 1, nested: { deep: 2 } };

// ============ 7. ФУНКЦИИ ============
function namedFunction(param1, param2 = "default", ...restParams) {
  return param1 + param2;
}
const arrowFn = (a, b) => a + b;
const arrowNoParens = x => x * 2;
const arrowBlock = (x) => {
  return x + 1;
};
async function asyncFn() {
  await Promise.resolve();
}
function* generatorFn() {
  yield 1;
  yield* [2, 3];
}
(function iife() {
  console.log("IIFE");
})();

// ============ 8. КЛАССЫ ============
class Animal {
  static species = "unknown";
  #privateField = 0;
  static #privateStatic = 1;

  constructor(name) {
    this.name = name;
  }

  get displayName() {
    return this.name;
  }
  set displayName(value) {
    this.name = value;
  }

  static create(name) {
    return new Animal(name);
  }

  #privateMethod() {
    return this.#privateField;
  }

  async fetchInfo() {
    return await fetch("/api");
  }
}

class Dog extends Animal {
  constructor(name, breed) {
    super(name);
    this.breed = breed;
  }
}

// ============ 9. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if (boolTrue) {
  console.log("if");
} else if (boolFalse) {
  console.log("else if");
} else {
  console.log("else");
}

for (let i = 0; i < 10; i++) {
  if (i === 5) continue;
  if (i === 8) break;
}

for (const item of [1, 2, 3]) { console.log(item); }
for (const key in { a: 1 }) { console.log(key); }

let i = 0;
while (i < 3) { i++; }
do { i--; } while (i > 0);

switch (intDec) {
  case 42:
    console.log("matched");
    break;
  default:
    console.log("default");
}

try {
  throw new Error("тестовая ошибка");
} catch (err) {
  console.error(err.message);
} finally {
  console.log("finally");
}

// ============ 10. ОПЕРАТОРЫ ============
const arithmetic = 1 + 2 - 3 * 4 / 5 % 6 ** 2;
const comparison = 1 < 2 && 3 > 2 || 4 <= 4 && 5 >= 5;
const equality = 1 === 1 && 2 !== 3 && 1 == "1" && 2 != "3";
const bitwise = 5 & 3 | 2 ^ 1;
const shift = 1 << 2 >> 1 >>> 1;
const logical = !boolTrue && (boolFalse || !!boolTrue);
const ternary = boolTrue ? "yes" : "no";
const nullish = notDefined ?? "fallback";
const optChain = obj?.nested?.value;
const spread = [...[1, 2], ...[3, 4]];
let assignCombo = 1;
assignCombo += 1; assignCombo -= 1; assignCombo *= 2; assignCombo /= 2;
assignCombo ??= 5; assignCombo ||= 6; assignCombo &&= 7;

// ============ 11. ОБЪЕКТЫ ============
const obj = {
  key: "value",
  [`computed${1}`]: true,
  method() { return 1; },
  get accessor() { return 1; },
  ...{ spread: true },
  [Symbol.iterator]: function* () { yield 1; },
};

// ============ 12. ВСТРОЕННЫЕ ОБЪЕКТЫ (support.*) ============
console.log("log"); console.warn("warn"); console.error("error");
Math.max(1, 2); Math.PI; Math.random();
JSON.stringify({ a: 1 }); JSON.parse("{}");
Array.isArray([]); Object.keys({}); Object.assign({}, {});
new Promise((resolve, reject) => resolve(1));
new Map(); new Set(); new WeakMap();
Number.parseInt("42"); Number.isFinite(1);
setTimeout(() => {}, 1000);

// ============ 13. TYPEOF / INSTANCEOF / DELETE / IN / NEW ============
typeof intDec === "number";
obj instanceof Object;
delete obj.key;
"key" in obj;
const instance = new Animal("Рекс");

// ============ 14. ДЕКОРАТОРЫ (proposal) ============
// @decorator
// class Decorated {}

// ============ 15. НЕДОСТИЖИМЫЙ / НЕПРАВИЛЬНЫЙ КОД (для invalid.*) ============
// const 123abc = 1; // невалидный идентификатор (закомментировано намеренно)

export { namedFunction, arrowFn, Animal, Dog };
