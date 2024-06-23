defmodule Dictionary do
  @word_list "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  # def word_list do
  #   "assets/words.txt"
  #   |> File.read!()
  #   |> String.split(~r/\n/, trim: true)
  # end

  def random_word do
    @word_list
    |> Enum.random()
  end
end
