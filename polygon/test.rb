# ============ 1. КОММЕНТАРИИ ============
# однострочный комментарий
=begin
блочный
многострочный комментарий
=end

# ============ 2. ТРЕБОВАНИЯ ============
require "json"
require_relative "./helper"

# ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
MAX_SIZE = 100
PI_VAL = 3.14159

int_dec = 42
int_neg = -17
float_num = 3.14159
exp_num = 6.022e23
hex_num = 0xFF00FF
oct_num = 0o755
bin_num = 0b1010_1010
underscore_sep = 1_000_000
bool_true = true
bool_false = false
nil_val = nil
symbol_val = :some_symbol
symbol_quoted = :"символ с пробелом"

# ============ 4. СТРОКИ ============
single = 'обычная строка'
double = "с \"кавычками\" и \n переводом"
interpolated = "Значение: #{int_dec}, hex: #{int_dec.to_s(16)}"
heredoc = <<~HEREDOC
  многострочная
  строка (heredoc)
HEREDOC
regex = /^[a-zA-Z0-9_.+-]+@[\w-]+\.\w+$/i
percent_string = %w[один два три]

# ============ 5. КОЛЛЕКЦИИ ============
array = [1, 2, "три", :four, nil]
hash = { name: "Алиса", age: 25 }
hash_old = { "name" => "Алиса", "age" => 25 }
range = (1..10)
range_excl = (1...10)

# ============ 6. МОДУЛИ И КЛАССЫ ============
module Describable
  def describe
    "неизвестно"
  end
end

class Animal
  include Describable
  extend Comparable

  attr_accessor :name
  attr_reader :age

  MAX_AGE = 100

  def initialize(name, age = 0)
    @name = name
    @age = age
  end

  def to_s
    "#{@name} (#{@age})"
  end

  def self.create_default
    new("default")
  end

  private

  def private_method
    @name
  end
end

class Dog < Animal
  def initialize(name, breed)
    super(name)
    @breed = breed
  end
end

# ============ 7. STRUCT ============
Point = Struct.new(:x, :y) do
  def distance
    Math.sqrt(x**2 + y**2)
  end
end

# ============ 8. МЕТОДЫ И БЛОКИ ============
def simple_method(a, b = 10, *args, c:, d: nil, **kwargs)
  a + b
end

def method_with_block
  yield 42 if block_given?
end

square = ->(x) { x * x }
square_lambda = lambda { |x| x * x }

# ============ 9. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if bool_true
  puts "if"
elsif bool_false
  puts "elsif"
else
  puts "else"
end

puts "unless" unless bool_false

(0...10).each do |i|
  next if i == 5
  break if i == 8
end

i = 0
while i < 3
  i += 1
end

i -= 1 until i.zero?

case int_dec
when 42
  puts "matched"
when 0..10
  puts "range"
else
  puts "default"
end

begin
  raise ArgumentError, "тестовая ошибка"
rescue ArgumentError => e
  puts "поймано: #{e.message}"
rescue StandardError
  puts "общая ошибка"
ensure
  puts "ensure"
end

# ============ 10. ИТЕРАТОРЫ ============
result = [1, 2, 3, 4, 5]
  .select { |n| n.even? }
  .map { |n| n * 2 }
  .reduce(0) { |sum, n| sum + n }

array.each { |item| puts item }

# ============ 11. ОПЕРАТОРЫ ============
arithmetic = 1 + 2 - 3 * 4 / 5 % 6 ** 2
comparison = 1 < 2 && 3 > 2 || !bool_false
spaceship = 1 <=> 2
safe_nav = nil&.to_s
nullish = nil_val || "fallback"

# ============ 12. MAIN ============
if __FILE__ == $0
  dog = Dog.new("Бобик", "лабрадор")
  puts dog.to_s
  point = Point.new(3.0, 4.0)
  puts point.distance
end
