defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__ {
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ##################################################

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word |> new_game
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  ##################################################

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    # IO.puts("make_move :won/:lost")
    game
    |> return_with_tally()
  end

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game, guess) do
    # IO.puts("make_move other")
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ##################################################

  defp accept_guess(game, _guess, _already_used = true) do
    # IO.puts("accept_guess already_used==true")
    %{ game | game_state: :already_used }
  end

  defp accept_guess(game, guess, _already_used) do
    # IO.puts("accept_guess !already_used: " <> guess)
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  ##################################################

  # Score Good Guess
  @spec score_guess(t, true) :: { t }
  defp score_guess(game, _good_guess = true) do
    # if all letters guessed --> :won | :good_guess
    # IO.puts("score_guess used:")
    # Enum.each(game.used, fn x -> IO.puts(x) end)
    new_state = won_or_good_guess(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  # Score Bad Guess, no turns left
  @spec score_guess(t, false) :: { t }
  defp score_guess(game = %{ turns_left: 1 }, _good_guess) do
    %{ game | turns_left: 0, game_state: :lost }
  end

  # Score Bad Guess, turns left still
  @spec score_guess(t, false) :: { t }
  defp score_guess(game, _good_guess) do
    %{ game | turns_left: game.turns_left - 1, game_state: :bad_guess }
  end


  ##################################################

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort,
    }
  end

  defp return_with_tally(game) do
    { game, tally(game)}
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end
  defp maybe_reveal(_is_guessed = true, letter), do: letter
  defp maybe_reveal(_is_guessed, _letter), do: "_"

  defp won_or_good_guess(_all_guessed = true), do: :won
  defp won_or_good_guess(_all_guessed), do: :good_guess
end
