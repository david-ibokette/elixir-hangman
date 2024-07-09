defmodule Dictionary.Impl.WordList do
  def start do
    word_list = "../../assets/words.txt"
      |> Path.expand(__DIR__)
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
    { word_list }
  end

  def random_word({word_list}) do
    word_list
    |> Enum.random()
  end
end
