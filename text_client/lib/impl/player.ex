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

  def interact( {game, _tally = %{ game_state: :lost }}) do
    IO.puts("Sorry u lost, the word was #{game.letters |> Enum.join}")
  end

  @spec interact(state) :: :ok
  def interact({_game, tally}) do
    IO.puts feedback_for(tally)
    # Feedback
    # display current work
    # next guess
    # make move
    #interact(state)
  end


  ###########################################
  # @type state  :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  defp feedback_for(tally = %{ game_state: :initializing}) do
    "Welcome player. I'm thinking of a #{ tally.letters |> length } letter word"
  end

  # defp feedback_for(tally = %{ game_state: :good_guess }) do
  #   "Good guess! Your guesses look like #{ tally.letters }, and you have #{tally.turns_left} turns left"
  # end

  # defp feedback_for(tally = %{ game_state: :bad_guess }) do
  #   "Oh noes! Your guesses STILL look like #{ tally.letters }, and you have #{tally.turns_left} turns left"
  # end

  # defp feedback_for(tally = %{ game_state: :already_used }) do
  #   "What are you doing???? You already guessed that letter!"
  # end

  defp feedback_for(%{ game_state: :good_guess }), do: "Good guess"
  defp feedback_for(%{ game_state: :bad_guess }), do: "Sorry, letter not in word"
  defp feedback_for(%{ game_state: :already_used }), do: "You did that already?!?!"

  defp feedback_for(_tally) do
    "How did you get here? Nobody's supposed to be here?!?!"
  end
  ###########################################
end
