defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "reality" do
    assert [1,2,3] == [1,2,3]
    assert 1 + 2 < 4
    # assert { :ok, _data} = { :error }
  end

  test "reality 2" do
    list = [1, 2, 3]
    list = Enum.concat(list, list |> Enum.map(fn x -> x * 4 end))
    assert list == [1, 2,3, 4, 8, 12]
  end
end
