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
    IO.puts("You win!!! ☮")
  end

  def interact( {_game, tally = %{ game_state: :lost }}) do
    IO.puts("Sorry u lost, the word was #{tally.letters |> Enum.join}")
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

  defp feedback_for(%{ game_state: :good_guess }), do: "Good guess"
  defp feedback_for(%{ game_state: :bad_guess }), do: "Sorry, letter not in word"
  defp feedback_for(%{ game_state: :already_used }), do: "You did that already?!?!"

  defp feedback_for(_tally) do
    "How did you get here? Nobody's supposed to be here?!?!"
  end
  ###########################################

  defp current_word(tally) do
    [
      IO.ANSI.format([:cyan, "Word looks like: #{tally.letters |> Enum.join(" ")},"]),
      IO.ANSI.format([:green, " turns left: #{tally.turns_left},"]),
      IO.ANSI.format([:blue, " used: #{tally.used |> Enum.join(",")}"]),
    ]
  end

  ###########################################

  defp get_guess() do
    IO.gets("What's your guess? ") |> String.trim() |> String.downcase()
  end

  ###########################################
end
