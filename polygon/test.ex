# ============ 1. КОММЕНТАРИИ ============
# однострочный комментарий
defmodule ThemeTest do
  @moduledoc """
  Doc-строка модуля (многострочная).
  """

  # ============ 2. АТРИБУТЫ МОДУЛЯ ============
  @max_size 100
  @behaviour GenServer
  @type status :: :active | :inactive | :pending

  # ============ 3. АЛИАСЫ, IMPORT, USE ============
  alias ThemeTest.Helper, as: Helper
  import Enum, only: [map: 2, filter: 2]
  use GenServer
  require Logger

  # ============ 4. ЛИТЕРАЛЫ ============
  @int_dec 42
  @int_neg -17
  @float_num 3.14159
  @hex_num 0xFF00FF
  @oct_num 0o755
  @bin_num 0b1010_1010
  @underscore_sep 1_000_000
  @bool_true true
  @bool_false false
  @nil_val nil
  @atom_val :some_atom
  @atom_quoted :"атом с пробелом"

  # ============ 5. СТРОКИ ============
  @single_line "обычная строка"
  @escaped "с \"кавычками\" и \n переводом"
  @interpolated "Значение: #{@int_dec}, hex: #{@hex_num}"
  @heredoc """
  многострочная
  строка (heredoc)
  """
  @charlist 'char list'
  @sigil_string ~s(строка через sigil)
  @sigil_regex ~r/^\d{3}-\d{2}-\d{4}$/

  # ============ 6. КОЛЛЕКЦИИ ============
  @list [1, 2, 3, :four, "five"]
  @tuple {:ok, "результат"}
  @keyword_list [key: "value", other: 42]
  @map %{name: "Алиса", age: 25}
  @struct_map %{__struct__: SomeStruct}

  # ============ 7. STRUCT ============
  defstruct name: nil, age: 0, tags: []

  # ============ 8. ФУНКЦИИ ============
  def simple_function(a, b \\ 10) do
    a + b
  end

  defp private_function(x) do
    x * 2
  end

  def with_guard(x) when is_integer(x) and x > 0 do
    :positive
  end

  def with_guard(x) when is_integer(x) do
    :non_positive
  end

  # ============ 9. PATTERN MATCHING ============
  def match_example({:ok, result}), do: result
  def match_example({:error, reason}), do: {:error, reason}
  def match_example(%{name: name, age: age}), do: "#{name}: #{age}"
  def match_example([head | tail]), do: {head, tail}
  def match_example(_), do: :unknown

  # ============ 10. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
  def control_flow(value) do
    if @bool_true do
      IO.puts("if")
    else
      IO.puts("else")
    end

    unless @bool_false do
      IO.puts("unless")
    end

    result =
      cond do
        value > 10 -> "большое"
        value > 0 -> "положительное"
        true -> "другое"
      end

    case value do
      0 -> :zero
      n when n > 0 -> :positive
      _ -> :negative
    end

    for i <- 1..10, rem(i, 2) == 0 do
      i * i
    end

    Enum.each(1..3, fn i ->
      IO.puts("итерация #{i}")
    end)

    result
  end

  # ============ 11. PIPE OPERATOR И АНОНИМНЫЕ ФУНКЦИИ ============
  def pipeline do
    [1, 2, 3, 4, 5]
    |> Enum.map(&(&1 * 2))
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
    |> Enum.reduce(0, &+/2)
  end

  # ============ 12. GENSERVER CALLBACKS ============
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  # ============ 13. ОБРАБОТКА ОШИБОК ============
  def with_rescue do
    try do
      raise "тестовая ошибка"
    rescue
      e in RuntimeError -> Logger.error("поймано: #{e.message}")
    catch
      :exit, reason -> IO.puts("выход: #{inspect(reason)}")
    after
      IO.puts("after блок")
    end
  end

  def with_with do
    with {:ok, value} <- {:ok, 1},
         {:ok, doubled} <- {:ok, value * 2} do
      {:ok, doubled}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end

# ============ 14. ПРОТОКОЛЫ ============
defprotocol Describable do
  def describe(value)
end

defimpl Describable, for: Integer do
  def describe(value), do: "число: #{value}"
end
