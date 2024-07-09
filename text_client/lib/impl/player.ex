defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  def interact( {_game, _tally = %{ game_state: :won }}) do
    IO.puts("You win!!! ☮" |> color_string(:blue_background))
  end

  def interact( {_game, tally = %{ game_state: :lost }}) do
    IO.puts("Sorry u lost, the word was #{tally.letters |> Enum.join}" |> color_string(:red_background))
  end

  @spec interact(state) :: :ok
  def interact({game, tally}) do
    # Feedback
    IO.puts feedback_for(tally)

    # display current word
    IO.puts current_word(tally)

    # with the guess make move, and then finally interact
    Hangman.make_move(game, get_guess())
    |> interact()
  end


  ###########################################
  # @type state  :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  defp feedback_for(tally = %{ game_state: :initializing}) do
    "Welcome player. I'm thinking of a #{ tally.letters |> length } letter word"
  end

  defp feedback_for(%{ game_state: :good_guess }), do: "Good guess" |> color_string(:black)
  defp feedback_for(%{ game_state: :bad_guess }), do: "Sorry, letter not in word" |> color_string(:red)
  defp feedback_for(%{ game_state: :already_used }), do: "You did that already?!?!" |> color_string(:yellow)

  defp feedback_for(_tally) do
    "How did you get here? Nobody's supposed to be here?!?!"
  end
  ###########################################

  defp current_word(tally) do
    [
      "Word looks like: #{tally.letters |> Enum.join(" ")}," |> color_string(:cyan),
      " turns left: #{tally.turns_left}," |> color_string(:green),
      " used: #{tally.used |> Enum.join(",")}" |> color_string(:blue),
    ]
  end

  ###########################################

  defp get_guess() do
    "What's your guess? "
    |> color_string(:magenta)
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
  end

  ###########################################

  defp color_string(str, color) do
      IO.ANSI.format([color, str])
  end

  ###########################################
end
