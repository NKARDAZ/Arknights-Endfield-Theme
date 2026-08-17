<?php
// ============ 1. КОММЕНТАРИИ ============
// однострочный комментарий
# альтернативный однострочный
/* блочный
   многострочный */
/**
 * PHPDoc комментарий
 * @param string $name имя
 * @return int результат
 */

// ============ 2. NAMESPACE И USE ============
namespace ThemeTest;

use App\Models\User;
use App\Interfaces\Describable as Descr;

// ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
define("MAX_SIZE", 100);
const PI_VAL = 3.14159;

$intDec = 42;
$intNeg = -17;
$floatNum = 3.14159;
$expNum = 6.022e23;
$hexNum = 0xFF00FF;
$octNum = 0o755;
$binNum = 0b1010_1010;
$underscoreSep = 1_000_000;
$boolTrue = true;
$boolFalse = false;
$nullVal = null;

// ============ 4. СТРОКИ ============
$single = 'обычная строка';
$double = "с \"кавычками\" и \n переводом";
$interpolated = "Значение: $intDec, hex: {$hexNum}";
$heredoc = <<<EOT
многострочная
строка (heredoc)
EOT;
$nowdoc = <<<'EOT'
строка без интерполяции $var
EOT;

// ============ 5. МАССИВЫ ============
$indexedArray = [1, 2, 3, "четыре"];
$assocArray = ["name" => "Алиса", "age" => 25];
$nestedArray = [[1, 2], [3, 4]];

// ============ 6. ИНТЕРФЕЙСЫ, ТРЕЙТЫ, КЛАССЫ ============
interface Shape
{
    public function area(): float;
}

trait Loggable
{
    public function log(string $message): void
    {
        echo "[LOG] $message\n";
    }
}

abstract class BaseShape implements Shape
{
    protected string $name;

    abstract public function area(): float;
}

class Circle extends BaseShape
{
    use Loggable;

    private float $radius;
    public static int $instanceCount = 0;
    public readonly string $id;

    public function __construct(float $radius)
    {
        $this->radius = $radius;
        $this->id = uniqid();
        self::$instanceCount++;
    }

    public function area(): float
    {
        return M_PI * $this->radius ** 2;
    }

    public function __toString(): string
    {
        return "Circle({$this->radius})";
    }
}

enum Status: string
{
    case Active = 'active';
    case Inactive = 'inactive';
}

// ============ 7. ФУНКЦИИ ============
function simpleFunction(int $a, int $b = 10, ...$rest): int
{
    return $a + $b;
}

function &referenceFunction(array &$arr): array
{
    return $arr;
}

$arrowFn = fn($x) => $x * 2;
$closure = function ($x) use ($intDec) {
    return $x + $intDec;
};

// ============ 8. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if ($boolTrue) {
    echo "if\n";
} elseif ($boolFalse) {
    echo "elseif\n";
} else {
    echo "else\n";
}

for ($i = 0; $i < 10; $i++) {
    if ($i === 5) continue;
    if ($i === 8) break;
}

foreach ($indexedArray as $key => $value) {
    echo "$key => $value\n";
}

$i = 0;
while ($i < 3) { $i++; }
do { $i--; } while ($i > 0);

switch ($intDec) {
    case 42:
        echo "matched\n";
        break;
    default:
        echo "default\n";
}

$result = match ($intDec) {
    42 => "сорок два",
    0 => "ноль",
    default => "другое",
};

try {
    throw new \InvalidArgumentException("тестовая ошибка");
} catch (\InvalidArgumentException | \TypeError $e) {
    echo "поймано: " . $e->getMessage() . "\n";
} finally {
    echo "finally\n";
}

// ============ 9. ОПЕРАТОРЫ ============
$arithmetic = 1 + 2 - 3 * 4 / 5 % 6 ** 2;
$comparison = 1 < 2 && 3 > 2 || 4 <= 4;
$identical = 1 === "1";
$nullCoalesce = $nullVal ?? "fallback";
$nullsafeChain = $obj?->getProperty();
$spread = [...$indexedArray, 5];
$spaceship = 1 <=> 2;

// ============ 10. MAIN ============
$circle = new Circle(5.0);
echo $circle->area() . "\n";
echo (string) $circle . "\n";
$circle->log("создан объект");
