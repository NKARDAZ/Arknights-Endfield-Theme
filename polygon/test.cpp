// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный
   многострочный */

// ============ 2. ПРЕПРОЦЕССОР ============
#include <iostream>
#include <vector>
#include <memory>
#include <string>
#include <algorithm>
#include <optional>
#define MAX_BUFFER 256
#ifndef GUARD_H
#define GUARD_H
#endif
#pragma once

namespace theme_test {

// ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
constexpr int MAX_SIZE = 128;
const double PI_VAL = 3.14159;
static int global_counter = 0;

int intDec = 42;
unsigned int uintVal = 42u;
long longVal = 42L;
long long longLongVal = 42LL;
float floatVal = 3.14f;
double doubleVal = 3.14159;
int hexVal = 0xFF00FF;
int octVal = 0755;
int binVal = 0b10101010;
int underscoreSep = 1'000'000;
bool boolTrue = true;
bool boolFalse = false;
char charVal = 'A';
const char* cstr = "C-строка";
std::string cppstr = "C++ строка";
auto autoVal = 42;
nullptr_t nullVal = nullptr;

// ============ 4. СТРОКИ ============
std::string raw = R"(сырая строка \n без экранирования)";
std::string escaped = "с \"кавычками\" и \n переводом строки \t табом";
wchar_t wideChar = L'A';
const wchar_t* wideStr = L"wide string";

// ============ 5. ШАБЛОНЫ (templates) ============
template <typename T, typename U = int>
class Container {
private:
    std::vector<T> data_;

public:
    Container() = default;
    explicit Container(std::size_t size) : data_(size) {}

    void push(const T& value) {
        data_.push_back(value);
    }

    [[nodiscard]] std::size_t size() const noexcept {
        return data_.size();
    }

    template <typename Predicate>
    auto find_if(Predicate pred) -> decltype(data_.begin()) {
        return std::find_if(data_.begin(), data_.end(), pred);
    }

    auto begin() { return data_.begin(); }
    auto end() { return data_.end(); }
};

template <typename T>
concept Numeric = std::is_arithmetic_v<T>;

// ============ 6. СТРУКТУРЫ, КЛАССЫ, НАСЛЕДОВАНИЕ ============
struct Point {
    double x = 0.0;
    double y = 0.0;

    Point operator+(const Point& other) const {
        return Point{x + other.x, y + other.y};
    }

    bool operator==(const Point& other) const = default;
};

class Shape {
public:
    virtual ~Shape() = default;
    virtual double area() const = 0;
    virtual void describe() const {
        std::cout << "Фигура\n";
    }
};

class Circle final : public Shape {
private:
    double radius_;

public:
    explicit Circle(double radius) : radius_(radius) {}

    double area() const override {
        return PI_VAL * radius_ * radius_;
    }
};

// ============ 7. ENUM ============
enum class Status : uint8_t {
    Ok = 0,
    Error = 1,
    Pending,
};

enum Legacy { LEGACY_A, LEGACY_B };

// ============ 8. УКАЗАТЕЛИ И ССЫЛКИ ============
int value = 10;
int* ptr = &value;
int& ref = value;
int&& rref = 10;
std::unique_ptr<Circle> uptr = std::make_unique<Circle>(5.0);
std::shared_ptr<Circle> sptr = std::make_shared<Circle>(3.0);
std::optional<int> maybeVal = std::nullopt;

} // namespace theme_test

// ============ 9. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
int main(int argc, char** argv) {
    using namespace theme_test;

    if (boolTrue) {
        std::cout << "if\n";
    } else if (boolFalse) {
        std::cout << "else if\n";
    } else {
        std::cout << "else\n";
    }

    for (int i = 0; i < 10; ++i) {
        if (i == 5) continue;
        if (i == 8) break;
    }

    for (const auto& p : std::vector<Point>{{1.0, 2.0}, {3.5, -1.2}}) {
        std::cout << p.x << "\n";
    }

    int i = 0;
    while (i < 3) { ++i; }
    do { --i; } while (i > 0);

    switch (intDec) {
        case 42:
            std::cout << "matched\n";
            break;
        default:
            std::cout << "default\n";
    }

    try {
        throw std::runtime_error("тестовая ошибка");
    } catch (const std::exception& e) {
        std::cerr << e.what() << "\n";
    } catch (...) {
        std::cerr << "неизвестная ошибка\n";
    }

    if (Status status = Status::Ok; status == Status::Ok) {
        std::cout << "статус ОК\n";
    }

    // ============ 10. ЛЯМБДЫ ============
    auto lambda = [captured = value](int x) mutable -> int {
        return x + captured;
    };
    auto byRef = [&value]() { value++; };

    // ============ 11. ОПЕРАТОРЫ ============
    int arithmetic = 1 + 2 - 3 * 4 / 5 % 6;
    bool comparison = 1 < 2 && 3 > 2 || 4 <= 4;
    int bitwise = 5 & 3 | 2 ^ 1;
    int shift = 1 << 2 >> 1;
    bool logical = !boolTrue;
    int ternary = boolTrue ? 1 : 0;

    static_assert(sizeof(int) == 4, "int должен быть 4 байта");
    auto result = static_cast<double>(intDec);

    return 0;
}
