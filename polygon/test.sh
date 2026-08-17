#!/usr/bin/env bash
# ============ 1. КОММЕНТАРИИ ============
# однострочный комментарий
: '
Это блочный комментарий-хак
через no-op команду
'

# ============ 2. НАСТРОЙКИ ОБОЛОЧКИ ============
set -euo pipefail
IFS=$'\n\t'

# ============ 3. ПЕРЕМЕННЫЕ И ЛИТЕРАЛЫ ============
readonly MAX_SIZE=100
INT_DEC=42
INT_NEG=-17
FLOAT_NUM=3.14159
BOOL_TRUE=true
BOOL_FALSE=false
EMPTY_VAR=""
declare -i TYPED_INT=10
declare -A ASSOC_ARRAY=([key]="value" [other]="42")
ARRAY_VAR=(1 2 3 "четыре" "пять")

# ============ 4. СТРОКИ ============
SINGLE='обычная строка без интерполяции $VAR'
DOUBLE="строка с интерполяцией $INT_DEC и ${MAX_SIZE}"
ESCAPED="с \"кавычками\" и \n переводом строки"
MULTILINE="строка
на нескольких
строках"
COMMAND_SUB="Текущая директория: $(pwd)"
COMMAND_SUB_OLD="Дата: `date +%Y`"
HEREDOC=$(cat << 'EOF'
многострочный
текст heredoc
EOF
)

# ============ 5. ФУНКЦИИ ============
function greet() {
    local name="${1:-мир}"
    echo "Привет, $name!"
}

simple_function() {
    local result=$(( $1 + $2 ))
    return "$result"
}

# ============ 6. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if [[ "$BOOL_TRUE" == "true" ]]; then
    echo "if"
elif [[ "$BOOL_FALSE" == "true" ]]; then
    echo "elif"
else
    echo "else"
fi

if [ -f "/etc/passwd" ] && [ -r "/etc/passwd" ]; then
    echo "файл существует и читаем"
fi

for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        continue
    fi
    if [[ $i -eq 8 ]]; then
        break
    fi
    echo "итерация: $i"
done

for file in "${ARRAY_VAR[@]}"; do
    echo "элемент: $file"
done

i=0
while [[ $i -lt 3 ]]; do
    ((i++))
done

until [[ $i -le 0 ]]; do
    ((i--))
done

case "$INT_DEC" in
    42)
        echo "matched"
        ;;
    0|1)
        echo "zero or one"
        ;;
    *)
        echo "default"
        ;;
esac

# ============ 7. ФУНКЦИИ И ОБРАБОТКА ОШИБОК ============
trap 'echo "ошибка на строке $LINENO"' ERR

check_command() {
    if ! command -v git &> /dev/null; then
        echo "git не найден" >&2
        exit 1
    fi
}

# ============ 8. ОПЕРАТОРЫ И ТЕСТЫ ============
ARITHMETIC=$((1 + 2 - 3 * 4 / 5 % 6))
COMPARISON=$([[ 1 -lt 2 && 3 -gt 2 ]] && echo "true" || echo "false")
STRING_EQ=$([[ "$SINGLE" == "$DOUBLE" ]] && echo "equal" || echo "not equal")
DEFAULT_VAL="${UNDEFINED_VAR:-default}"
LENGTH="${#DOUBLE}"

# ============ 9. МАССИВЫ И ЦИКЛЫ ПО НИМ ============
for key in "${!ASSOC_ARRAY[@]}"; do
    echo "$key => ${ASSOC_ARRAY[$key]}"
done

# ============ 10. PIPE И РЕДИРЕКТЫ ============
echo "тест" | grep "тест" > /tmp/output.txt 2>&1
cat /tmp/output.txt | wc -l

ls -la /tmp | grep ".txt$" | sort

# ============ 11. MAIN ============
main() {
    check_command
    greet "Тестер"
    simple_function 2 3
    echo "Результат: $ARITHMETIC"
}

main "$@"
