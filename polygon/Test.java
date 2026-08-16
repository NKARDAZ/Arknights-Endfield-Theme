package com.example.theme;

// ============ 1. КОММЕНТАРИИ ============
// однострочный
/* блочный */
/**
 * Javadoc
 * @param name имя
 * @return результат
 * @throws Exception если ошибка
 * @deprecated используйте newMethod
 */

// ============ 2. ИМПОРТЫ ============
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import static java.lang.Math.PI;

// ============ 3. АННОТАЦИИ ============
@FunctionalInterface
interface Operation {
    int apply(int a, int b);
}

@Deprecated
@SuppressWarnings("unchecked")
public class Test<T extends Comparable<T>> implements Runnable, Cloneable {

    // ============ 4. МОДИФИКАТОРЫ И ПОЛЯ ============
    public static final int MAX_SIZE = 100;
    private String name;
    protected int counter = 0;
    transient boolean cache;
    volatile boolean flag;
    private final List<T> items = new ArrayList<>();

    // ============ 5. ЛИТЕРАЛЫ ЧИСЕЛ ============
    int intDec = 42;
    long longNum = 42L;
    float floatNum = 3.14f;
    double doubleNum = 3.14159d;
    int hexNum = 0xFF00FF;
    int octNum = 0755;
    int binNum = 0b10101010;
    int underscoreSep = 1_000_000;
    boolean boolTrue = true;
    boolean boolFalse = false;
    char charVal = 'A';
    char unicodeChar = '\u00e9';
    String nullVal = null;

    // ============ 6. СТРОКИ ============
    String single = "обычная строка";
    String escaped = "с \"кавычками\" и \n переводом строки";
    String textBlock = """
            Текстовый блок
            многострочный
            """;

    // ============ 7. ВЛОЖЕННЫЕ ТИПЫ ============
    public interface Greeter {
        String greet(String who);
    }

    public enum Color {
        RED("красный"), GREEN("зелёный"), BLUE("синий");

        private final String label;

        Color(String label) {
            this.label = label;
        }
    }

    public static class Inner {
        int value;
    }

    public record Coordinates(double x, double y) {
        public double distance() {
            return Math.sqrt(x * x + y * y);
        }
    }

    // ============ 8. КОНСТРУКТОРЫ ============
    public Test(String name) {
        this.name = name;
    }

    public Test() {
        this("default");
    }

    // ============ 9. МЕТОДЫ, ДЖЕНЕРИКИ ============
    @Override
    public String toString() {
        return "Test{name='" + name + "'}";
    }

    public <U extends Number> U max(List<U> list) {
        return list.stream()
                .max(Comparator.naturalOrder())
                .orElseThrow(() -> new IllegalArgumentException("empty"));
    }

    @Override
    public void run() {
        System.out.println("running");
    }

    // ============ 10. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
    public void controlFlow() {
        if (boolTrue) {
            System.out.println("if");
        } else if (boolFalse) {
            System.out.println("else if");
        } else {
            System.out.println("else");
        }

        for (int i = 0; i < 10; i++) {
            if (i == 5) continue;
            if (i == 8) break;
        }

        for (T item : items) {
            System.out.println(item);
        }

        int i = 0;
        while (i < 3) { i++; }
        do { i--; } while (i > 0);

        switch (intDec) {
            case 42 -> System.out.println("matched");
            case 0, 1 -> System.out.println("zero or one");
            default -> System.out.println("default");
        }

        try (var scanner = new Scanner(System.in)) {
            String line = scanner.nextLine();
        } catch (RuntimeException e) {
            e.printStackTrace();
        } finally {
            System.out.println("finally");
        }

        Object obj = "test";
        if (obj instanceof String str && str.length() > 0) {
            System.out.println(str);
        }

        String result = switch (Color.RED) {
            case RED -> "красный";
            case GREEN, BLUE -> "другой";
        };
    }

    // ============ 11. ЛЯМБДЫ И STREAM API ============
    public void streamsAndLambdas() {
        Function<Integer, Integer> square = x -> x * x;
        Operation add = (a, b) -> a + b;

        List<Integer> numbers = List.of(5, 3, 9, 1);
        List<Integer> filtered = numbers.stream()
                .filter(n -> n % 2 != 0)
                .map(square::apply)
                .collect(Collectors.toList());

        Optional<Integer> found = numbers.stream().findFirst();
        found.ifPresent(System.out::println);
    }

    public static void main(String[] args) {
        Test<Integer> test = new Test<>("Тест");
        test.controlFlow();
        test.streamsAndLambdas();

        Coordinates coords = new Coordinates(3.0, 4.0);
        System.out.printf("Дистанция: %.2f%n", coords.distance());

        for (Color c : Color.values()) {
            System.out.println(c);
        }
    }
}
