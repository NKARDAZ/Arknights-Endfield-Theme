%% ============ 1. КОММЕНТАРИИ ============
%% однострочный комментарий
%%% Комментарий уровня модуля (используется для заголовков секций)

-module(theme_test).

%% ============ 2. АТРИБУТЫ МОДУЛЯ ============
-author("Тестовый автор").
-vsn("1.0.0").
-export([main/0, area/1, classify/1, safe_divide/2]).
-import(lists, [map/2, filter/2]).
-include("theme_test.hrl").
-define(MAX_SIZE, 100).
-define(GREETING(Name), "Привет, " ++ Name).

%% ============ 3. TYPE SPECS ============
-type shape() :: {circle, float()} | {rectangle, float(), float()}.
-type status() :: active | inactive | pending.
-spec area(shape()) -> float().
-spec classify(integer()) -> atom().

%% ============ 4. ЛИТЕРАЛЫ ============
int_dec() -> 42.
int_neg() -> -17.
float_num() -> 3.14159.
exp_num() -> 6.022e23.
hex_num() -> 16#FF00FF.
oct_num() -> 8#755.
bin_num() -> 2#1010.
atom_val() -> some_atom.
atom_quoted() -> 'атом с пробелом'.
bool_true() -> true.
bool_false() -> false.
nil_val() -> undefined.

%% ============ 5. СТРОКИ И БИНАРНЫЕ ДАННЫЕ ============
simple_string() -> "обычная строка".
escaped_string() -> "с \"кавычками\" и \n переводом".
binary_string() -> <<"бинарная строка">>.
binary_data() -> <<1, 2, 3, 255>>.
char_val() -> $A.

%% ============ 6. КОРТЕЖИ, СПИСКИ, MAP ============
tuple_val() -> {ok, "результат"}.
list_val() -> [1, 2, 3, four, "five"].
cons_list() -> [1 | [2, 3]].
map_val() -> #{name => "Алиса", age => 25}.
record_like() -> #{<<"key">> => <<"value">>}.

%% ============ 7. ЗАПИСИ (records) ============
-record(person, {name :: string(), age = 0 :: integer(), tags = [] :: list()}).

new_person(Name, Age) ->
    #person{name = Name, age = Age}.

%% ============ 8. ФУНКЦИИ И PATTERN MATCHING ============
area({circle, R}) -> math:pi() * R * R;
area({rectangle, W, H}) -> W * H.

classify(N) when N < 0 -> negative;
classify(0) -> zero;
classify(N) when N > 0, N < 10 -> small;
classify(_) -> large.

match_example({ok, Result}) -> Result;
match_example({error, Reason}) -> {error, Reason};
match_example([Head | Tail]) -> {Head, Tail};
match_example(_) -> unknown.

%% ============ 9. АНОНИМНЫЕ ФУНКЦИИ ============
squared() ->
    Square = fun(X) -> X * X end,
    Square(5).

higher_order() ->
    lists:map(fun(X) -> X * 2 end, [1, 2, 3]).

%% ============ 10. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
control_flow(Value) ->
    Result = if
        Value > 10 -> "большое";
        Value > 0 -> "положительное";
        true -> "другое"
    end,
    case Value of
        0 -> zero;
        N when N > 0 -> positive;
        _ -> negative
    end,
    Result.

%% ============ 11. СПИСОЧНЫЕ ВЫРАЖЕНИЯ ============
squares() ->
    [X * X || X <- lists:seq(1, 10), X rem 2 =:= 0].

pairs() ->
    [{X, Y} || X <- [1, 2, 3], Y <- [1, 2, 3], X =/= Y].

%% ============ 12. ОБРАБОТКА ОШИБОК ============
safe_divide(_, 0) -> {error, "деление на ноль"};
safe_divide(A, B) -> {ok, A / B}.

with_try() ->
    try
        error("тестовая ошибка")
    catch
        error:Reason -> {caught, Reason};
        throw:Value -> {thrown, Value};
        exit:Reason -> {exited, Reason}
    after
        io:format("after блок~n")
    end.

%% ============ 13. ПРОЦЕССЫ И СООБЩЕНИЯ ============
spawn_process() ->
    Pid = spawn(fun loop/0),
    Pid ! {self(), hello},
    receive
        {Pid, Response} -> Response
    after 1000 ->
        timeout
    end.

loop() ->
    receive
        {From, hello} ->
            From ! {self(), "привет"},
            loop();
        stop ->
            ok
    end.

%% ============ 14. MAIN ============
main() ->
    Circle = {circle, 5.0},
    io:format("Площадь: ~p~n", [area(Circle)]),
    io:format("Классификация 5: ~p~n", [classify(5)]),
    Person = new_person("Алиса", 25),
    io:format("Person: ~p~n", [Person]),
    ok.
