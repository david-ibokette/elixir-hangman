defmodule Lists do
  def switch({a, b}) do
    {b, a}
  end

  def matches({a, a}), do: true
  def matches({_, _}), do: false

  def len([]), do: 0
  def len([_head|t]), do: 1 + len(t)

  def sum([]), do: 0
  def sum([h|t]), do: h + sum(t)

  # [1,2,3] = [1, 4, 9]
  def square([]), do: []
  def square([h|t]), do: [h*h | square(t)]

  # [1,2,3] = [2, 4, 6]
  def double([]), do: []
  def double([h|t]), do: [h+h | double(t)]

  def map([], _), do: []
  def map([h|t], func), do: [func.(h) | map(t, func)]

  def triple([h|t]), do: map([h|t], fn x -> 3*x end)
  def triple2(list), do: map(list, fn x -> 3*x end)
end
