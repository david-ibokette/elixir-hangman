defmodule Hangman do
  alias Hangman.Impl.Game
  alias Hangman.Type

  @opaque game :: Game.t
  @type tally :: Type.tally

  @spec new_game() :: game
  def new_game do
    { :ok, pid } = Hangman.Runtime.Application.start_game
    pid
  end

  @spec tally(game) :: tally
  def tally(game) do
    tally = GenServer.call(game, {:tally})
    tally
  end

  @spec make_move(game, String.t) :: tally
  def make_move(game, guess) do
    tally  = GenServer.call(game, {:make_move, guess})
    # { game, tally }
    tally
  end
end
