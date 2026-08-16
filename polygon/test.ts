// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный */
/**
 * TSDoc комментарий
 * @template T
 * @param value значение
 */

// ============ 2. ИМПОРТЫ / МОДУЛИ ============
import type { Request, Response } from "express";
import { Component, Injectable } from "./decorators";
import * as fs from "node:fs";
export * from "./other";

// ============ 3. ПРИМИТИВНЫЕ ТИПЫ (storage.type) ============
let n: number = 1;
let s: string = "text";
let b: boolean = true;
let u: undefined = undefined;
let nul: null = null;
let any1: any = 1;
let unk: unknown = 1;
let nev: never;
let voidVal: void;
let obj1: object = {};
let sym: symbol = Symbol("s");
let big: bigint = 1n;

// ============ 4. ЛИТЕРАЛЬНЫЕ И СОСТАВНЫЕ ТИПЫ ============
type StrOrNum = string | number;
type Both = { a: number } & { b: string };
type Tuple = [string, number, boolean?];
type ReadonlyArr = readonly string[];
type FuncType = (a: number, b: number) => number;
type Literal = "small" | "medium" | "large";
type Mapped<T> = { [K in keyof T]: T[K] };
type Conditional<T> = T extends string ? "str" : "other";
type Indexed = { [key: string]: number };
type TemplateLit = `prefix-${string}`;

// ============ 5. ИНТЕРФЕЙСЫ И ENUM ============
interface Shape {
  readonly id: number;
  name?: string;
  area(): number;
}

interface Extended extends Shape {
  color: string;
}

enum Status {
  Active = "ACTIVE",
  Inactive = "INACTIVE",
  Pending,
}

const enum Direction {
  Up,
  Down,
}

// ============ 6. ДЖЕНЕРИКИ ============
class Box<T> {
  private value: T;
  constructor(value: T) {
    this.value = value;
  }
  get(): T {
    return this.value;
  }
}

function identity<T, U extends { length: number }>(value: T, other: U): T {
  return value;
}

interface Repository<T, K = string> {
  find(id: K): Promise<T | null>;
}

// ============ 7. КЛАССЫ С МОДИФИКАТОРАМИ ============
abstract class Base {
  protected abstract compute(): number;
  public readonly createdAt: Date = new Date();
  private static count = 0;

  constructor(protected name: string, private readonly age: number) {}

  public getName(): string {
    return this.name;
  }
}

@Component({ selector: "app-root" })
@Injectable()
class Circle extends Base implements Shape {
  readonly id: number;

  constructor(id: number, private radius: number) {
    super("circle", 0);
    this.id = id;
  }

  protected compute(): number {
    return this.area();
  }

  area(): number {
    return Math.PI * this.radius ** 2;
  }
}

// ============ 8. ФУНКЦИИ, СТРЕЛКИ, PEREГРУЗКИ ============
function overload(a: number): number;
function overload(a: string): string;
function overload(a: any): any {
  return a;
}

const isString = (val: unknown): val is string => typeof val === "string";
function assertIsNumber(val: unknown): asserts val is number {
  if (typeof val !== "number") throw new Error("not a number");
}

async function handler(req: Request, res: Response): Promise<void> {
  const status: Status = Status.Active;
  res.status(200).json({ status });
}

// ============ 9. НАМЕСПЕЙСЫ И DECLARE ============
namespace MyNamespace {
  export const value = 1;
}

declare module "external-lib" {
  export function doSomething(): void;
}

declare global {
  interface Window {
    customProp: string;
  }
}

// ============ 10. УТИЛИТНЫЕ ТИПЫ ============
type PartialShape = Partial<Shape>;
type PickedShape = Pick<Shape, "id" | "name">;
type OmittedShape = Omit<Shape, "area">;
type ReadonlyShape = Readonly<Shape>;
type RecordType = Record<string, number>;

// ============ 11. АССЕРШЕНЫ И NON-NULL ============
const el = document.getElementById("root") as HTMLElement;
const el2 = <HTMLElement>document.getElementById("root");
const definite: string = null! ;
const satisfiesExample = { a: 1 } satisfies Record<string, number>;

// ============ 12. ОПЕРАТОРЫ (общие с JS) ============
const points: { x: number; y: number }[] = [{ x: 1, y: 2 }];
const nullish = definite ?? "fallback";
const optChain = points[0]?.x;
const spreadArr = [...points];

export { Circle, identity, Status, Direction };
export type { Shape, Point };
type Point = { x: number; y: number };
