defmodule Dictionary.Impl.WordList do
  @type t :: list(String.t)

  @spec start() :: t
  def start do
    "../../assets/words.txt"
      |> Path.expand(__DIR__)
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
