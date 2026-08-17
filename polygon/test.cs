// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный */
/// <summary>XML doc-комментарий</summary>
/// <param name="name">имя параметра</param>

// ============ 2. USING И NAMESPACE ============
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static System.Math;
using Alias = System.Collections.Generic.List<int>;

namespace ThemeTest;

// ============ 3. АТРИБУТЫ ============
[Serializable]
[Obsolete("используйте NewClass")]
public class Test<T> where T : IComparable<T>
{
    // ============ 4. МОДИФИКАТОРЫ И ПОЛЯ ============
    public const int MaxSize = 100;
    private static readonly string Name = "default";
    protected int counter = 0;
    internal bool flag;
    private volatile int volatileField;

    // ============ 5. ЛИТЕРАЛЫ ЧИСЕЛ ============
    int intDec = 42;
    uint uintVal = 42u;
    long longVal = 42L;
    float floatVal = 3.14f;
    double doubleVal = 3.14159;
    decimal decimalVal = 3.14159m;
    int hexNum = 0xFF00FF;
    int binNum = 0b1010_1010;
    int underscoreSep = 1_000_000;
    bool boolTrue = true;
    bool boolFalse = false;
    char charVal = 'A';
    object? nullVal = null;

    // ============ 6. СТРОКИ ============
    string single = "обычная строка";
    string escaped = "с \"кавычками\" и \n переводом";
    string verbatim = @"C:\path\no\escape";
    string interpolated = $"Значение: {intDec}, hex: {intDec:X}";
    string raw = """
        сырая многострочная строка
        """;

    // ============ 7. СВОЙСТВА И СОБЫТИЯ ============
    public string DisplayName { get; set; } = "";
    public int ReadOnlyProp { get; init; }
    public event EventHandler? Changed;

    // ============ 8. ВЛОЖЕННЫЕ ТИПЫ ============
    public interface IGreeter
    {
        string Greet(string who);
    }

    public enum Color
    {
        Red, Green, Blue
    }

    public record Point(double X, double Y)
    {
        public double Distance() => Sqrt(X * X + Y * Y);
    }

    public struct Coordinates
    {
        public int X, Y;
    }

    // ============ 9. КОНСТРУКТОРЫ И МЕТОДЫ ============
    public Test() { }

    public Test(string name) : this()
    {
        Name = name;
    }

    public override string ToString() => $"Test{{Name='{Name}'}}";

    public U Max<U>(List<U> list) where U : IComparable<U>
    {
        return list.OrderByDescending(x => x).First();
    }

    public async Task<string> FetchDataAsync()
    {
        await Task.Delay(100);
        return "данные";
    }

    // ============ 10. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
    public void ControlFlow()
    {
        if (boolTrue)
        {
            Console.WriteLine("if");
        }
        else if (boolFalse)
        {
            Console.WriteLine("else if");
        }
        else
        {
            Console.WriteLine("else");
        }

        for (int i = 0; i < 10; i++)
        {
            if (i == 5) continue;
            if (i == 8) break;
        }

        foreach (var item in new[] { 1, 2, 3 })
        {
            Console.WriteLine(item);
        }

        int n = 0;
        while (n < 3) { n++; }
        do { n--; } while (n > 0);

        switch (intDec)
        {
            case 42:
                Console.WriteLine("matched");
                break;
            default:
                Console.WriteLine("default");
                break;
        }

        var result = intDec switch
        {
            42 => "сорок два",
            0 => "ноль",
            _ => "другое"
        };

        try
        {
            throw new InvalidOperationException("тестовая ошибка");
        }
        catch (InvalidOperationException ex) when (ex.Message.Length > 0)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {
            Console.WriteLine("finally");
        }

        object obj = "test";
        if (obj is string str && str.Length > 0)
        {
            Console.WriteLine(str);
        }
    }

    // ============ 11. LINQ И ЛЯМБДЫ ============
    public void LinqAndLambdas()
    {
        Func<int, int> square = x => x * x;
        Action<string> print = s => Console.WriteLine(s);

        var numbers = new List<int> { 5, 3, 9, 1 };
        var filtered = numbers.Where(n => n % 2 != 0).Select(square).ToList();
        var query = from n in numbers where n > 2 orderby n select n;
    }

    // ============ 12. ОПЕРАТОРЫ ============
    public void Operators()
    {
        int arithmetic = 1 + 2 - 3 * 4 / 5 % 6;
        bool comparison = 1 < 2 && 3 > 2 || 4 <= 4;
        int? nullable = null;
        int nullCoalesce = nullable ?? 0;
        nullable ??= 5;
        var nullConditional = nullable?.ToString();
        int ternary = boolTrue ? 1 : 0;
    }

    public static void Main(string[] args)
    {
        var test = new Test<int>();
        test.ControlFlow();
        test.LinqAndLambdas();
        test.Operators();

        var point = new Point(3.0, 4.0);
        Console.WriteLine($"Дистанция: {point.Distance():F2}");
    }
}
