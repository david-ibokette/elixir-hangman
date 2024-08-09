defmodule Hangman do
  alias Hangman.Impl.Game
  alias Hangman.Type
  alias Hangman.Runtime.Server

  @opaque game :: Game.t

  @spec new_game() :: game
  def new_game do
    { :ok, pid } = Server.start_link
    pid
  end

  @spec tally(game) :: Type.tally
  def tally(game) do
    tally = GenServer.call(game, {:tally})
    tally
  end

  @spec make_move(game, String.t) :: { game, Type.tally }
  def make_move(game, guess) do
    tally  = GenServer.call(game, {:make_move, guess})
    { game, tally }
  end
end
