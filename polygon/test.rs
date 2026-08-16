// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный */
//! Doc-комментарий модуля
/// Doc-комментарий элемента

// ============ 2. ИМПОРТЫ И АТРИБУТЫ ============
#![allow(dead_code)]
use std::collections::HashMap;
use std::fmt::{self, Display};
use std::rc::Rc;
use std::cell::RefCell;

// ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
const MAX_SIZE: usize = 64;
static GLOBAL_COUNTER: i32 = 0;

fn literals() {
    let int_dec: i32 = 42;
    let int_neg: i32 = -17;
    let float_num: f64 = 3.14159;
    let exp_num: f64 = 6.022e23;
    let hex_num: i32 = 0xFF00FF;
    let oct_num: i32 = 0o755;
    let bin_num: i32 = 0b1010_1010;
    let underscore_sep: i64 = 1_000_000;
    let bool_true: bool = true;
    let bool_false: bool = false;
    let char_val: char = 'A';
    let unicode_char: char = '\u{00e9}';
}

// ============ 4. СТРОКИ ============
fn strings() {
    let simple = "простая строка";
    let escaped = "с \"кавычками\" и \n переводом строки";
    let raw = r"сырая строка \n без экранирования";
    let raw_hash = r#"строка с "кавычками" внутри"#;
    let byte_str = b"byte string";
    let formatted = format!("Значение: {}, hex: {:#x}", 42, 42);
    let multiline = "строка
    на нескольких
    строках";
}

// ============ 5. СТРУКТУРЫ, ENUM, TRAIT ============
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
struct Point {
    x: f64,
    y: f64,
}

#[derive(Debug, Clone)]
enum Status {
    Active,
    Inactive,
    Pending(u32),
    Custom { code: i32, message: String },
}

trait Describable {
    fn describe(&self) -> String;

    fn default_impl(&self) -> String {
        String::from("default")
    }
}

trait Shape: Describable {
    fn area(&self) -> f64;
}

// ============ 6. ДЖЕНЕРИКИ И LIFETIME ============
struct Container<T> {
    items: Vec<T>,
}

impl<T: Clone + Display> Container<T> {
    fn new() -> Self {
        Container { items: Vec::new() }
    }

    fn push(&mut self, item: T) {
        self.items.push(item);
    }
}

struct User<'a> {
    name: &'a str,
    age: u8,
    status: Status,
}

impl<'a> User<'a> {
    fn new(name: &'a str, age: u8) -> Self {
        User { name, age, status: Status::Pending(0) }
    }

    fn is_adult(&self) -> bool {
        self.age >= 18
    }
}

impl<'a> Describable for User<'a> {
    fn describe(&self) -> String {
        format!("{} ({} лет)", self.name, self.age)
    }
}

impl<'a> fmt::Display for User<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "User<{}>", self.name)
    }
}

// ============ 7. ФУНКЦИИ ============
fn find_max<T: PartialOrd + Copy>(items: &[T]) -> Option<T> {
    items.iter().copied().fold(None, |acc, x| match acc {
        None => Some(x),
        Some(m) if x > m => Some(x),
        Some(m) => Some(m),
    })
}

fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err(String::from("деление на ноль"));
    }
    Ok(a / b)
}

async fn fetch_data() -> Result<String, Box<dyn std::error::Error>> {
    Ok(String::from("данные"))
}

// ============ 8. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
fn control_flow() {
    let bool_true = true;
    if bool_true {
        println!("if");
    } else if !bool_true {
        println!("else if");
    } else {
        println!("else");
    }

    for i in 0..10 {
        if i == 5 { continue; }
        if i == 8 { break; }
    }

    let mut n = 0;
    while n < 3 {
        n += 1;
    }

    loop {
        n -= 1;
        if n == 0 { break; }
    }

    let status = Status::Active;
    match status {
        Status::Active => println!("активен"),
        Status::Inactive => println!("неактивен"),
        Status::Pending(n) => println!("ожидание: {n}"),
        Status::Custom { code, message } => println!("{code}: {message}"),
    }

    let numbers = vec![3, 7, 1, 9, 4];
    if let Some(&first) = numbers.first() {
        println!("первый: {first}");
    }

    let result: Result<i32, String> = Ok(5);
    while let Ok(v) = result {
        println!("значение: {v}");
        break;
    }
}

// ============ 9. ОПЦИИ, РЕЗУЛЬТАТ, ОПЕРАТОР ? ============
fn chained_operations() -> Result<i32, String> {
    let value = divide(10.0, 2.0)? as i32;
    Ok(value)
}

// ============ 10. УКАЗАТЕЛИ, RC, REFCELL, UNSAFE ============
fn smart_pointers() {
    let boxed: Box<i32> = Box::new(5);
    let rc: Rc<i32> = Rc::new(5);
    let rc_clone = Rc::clone(&rc);
    let refcell: RefCell<i32> = RefCell::new(5);
    *refcell.borrow_mut() += 1;

    unsafe {
        let raw_ptr: *const i32 = &5;
        println!("{}", *raw_ptr);
    }
}

// ============ 11. ЗАМЫКАНИЯ И ИТЕРАТОРЫ ============
fn closures() {
    let add = |a: i32, b: i32| -> i32 { a + b };
    let numbers: Vec<i32> = vec![1, 2, 3, 4, 5];
    let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).filter(|x| x % 2 == 0).collect();
}

// ============ 12. МАКРОСЫ ============
fn macros() {
    println!("простой макрос");
    let v = vec![1, 2, 3];
    assert!(v.len() == 3, "длина должна быть 3");
    let s = format!("{:?}", v);
}

fn main() {
    literals();
    strings();
    control_flow();
    smart_pointers();
    closures();
    macros();

    let mut user = User::new("Алиса", 25);
    user.status = Status::Active;

    let numbers: Vec<i32> = vec![3, 7, 1, 9, 4];
    let max_val = find_max(&numbers).unwrap_or(0);

    let mut scores: HashMap<String, i32> = HashMap::new();
    scores.insert(String::from("alice"), 95);

    for (key, value) in &scores {
        println!("{key}: {value}");
    }

    assert!(user.is_adult(), "должен быть совершеннолетним");
}
