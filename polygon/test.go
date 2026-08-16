// Package main - тестовый файл Go для проверки цветовой темы

// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный */
package main

// ============ 2. ИМПОРТЫ ============
import (
	"errors"
	"fmt"
	"strings"
	"sync"
	"context"
	alias "encoding/json"
)

// ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
const MaxRetries = 3
const Pi float64 = 3.14159

const (
	StatusPending = iota
	StatusActive
	StatusDone
)

var (
	intDec         = 42
	intNeg         = -17
	floatNum       = 3.14159
	hexNum         = 0xFF00FF
	octNum         = 0o755
	binNum         = 0b10101010
	underscoreSep  = 1_000_000
	boolTrue       = true
	boolFalse      = false
	nilVal   error = nil
	runeVal        = 'A'
	strVal         = "строка"
	rawStr         = `сырая строка \n без экранирования`
)

// ============ 4. ТИПЫ ============
type Status int

type Shape interface {
	Area() float64
	Perimeter() float64
}

type Rectangle struct {
	Width, Height float64
	Tags          []string
}

type Point struct {
	X, Y float64
}

type Handler func(w string, r int) error

type Number interface {
	~int | ~float64
}

// ============ 5. МЕТОДЫ ============
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

func (r *Rectangle) Scale(factor float64) {
	r.Width *= factor
	r.Height *= factor
}

// ============ 6. ДЖЕНЕРИКИ ============
func Sum[T Number](items []T) T {
	var total T
	for _, item := range items {
		total += item
	}
	return total
}

type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

// ============ 7. ФУНКЦИИ И ОШИБКИ ============
func NewTask(name string, tags ...string) (*Rectangle, error) {
	if name == "" {
		return nil, errors.New("имя задачи не может быть пустым")
	}
	return &Rectangle{Width: 1, Height: 1, Tags: tags}, nil
}

func mustParse(value string) int {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("восстановлено:", r)
		}
	}()
	return len(value)
}

// ============ 8. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
func controlFlow() {
	if boolTrue {
		fmt.Println("if")
	} else if boolFalse {
		fmt.Println("else if")
	} else {
		fmt.Println("else")
	}

	for i := 0; i < 10; i++ {
		if i == 5 {
			continue
		}
		if i == 8 {
			break
		}
	}

	items := []int{1, 2, 3}
	for idx, val := range items {
		fmt.Println(idx, val)
	}

	n := 0
	for n < 3 {
		n++
	}

	switch intDec {
	case 42:
		fmt.Println("matched")
	case 0, 1:
		fmt.Println("zero or one")
	default:
		fmt.Println("default")
	}

	switch v := interface{}(intDec).(type) {
	case int:
		fmt.Println("int:", v)
	case string:
		fmt.Println("string:", v)
	default:
		fmt.Println("unknown")
	}
}

// ============ 9. ГОРУТИНЫ И КАНАЛЫ ============
func concurrency() {
	var wg sync.WaitGroup
	ch := make(chan int, 1)

	wg.Add(1)
	go func() {
		defer wg.Done()
		ch <- 42
	}()

	select {
	case v := <-ch:
		fmt.Println("получено:", v)
	default:
		fmt.Println("канал пуст")
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	_ = ctx
	wg.Wait()
}

// ============ 10. ОПЕРАТОРЫ ============
func operators() {
	arithmetic := 1 + 2 - 3*4/5%6
	comparison := 1 < 2 && 3 > 2 || 4 <= 4
	bitwise := 5 & 3 | 2 ^ 1
	shift := 1 << 2 >> 1
	logical := !boolTrue

	_ = arithmetic
	_ = comparison
	_ = bitwise
	_ = shift
	_ = logical
}

func main() {
	task, err := NewTask("Проверить тему", "vscode", "тест")
	if err != nil {
		fmt.Println("ошибка:", err)
		return
	}

	task.Scale(2)
	fmt.Printf("Площадь: %.2f\n", task.Area())
	fmt.Println(strings.Join(task.Tags, ", "))

	var shapes []Shape = []Shape{task}
	for i, s := range shapes {
		fmt.Printf("Фигура %d: %v\n", i, s.Area())
	}

	controlFlow()
	concurrency()
	operators()

	data, _ := alias.Marshal(Point{X: 1, Y: 2})
	fmt.Println(string(data))
}
