defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "reality" do
    assert [1,2,3] == [1,2,3]
    assert 1 + 2 < 4
    # assert { :ok, _data} = { :error }
  end
end
