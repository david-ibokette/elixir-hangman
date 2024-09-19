defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  alias Hangman.Runtime.Watchdog

  use GenServer

  @type t :: pid
  @idle_timeout 1 * 60 * 60 * 1000   # 1 hour

  ### client process code

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### server process code

  def init(_) do
    watcher = Watchdog.start(@idle_timeout)
    { :ok, { Game.new_game, watcher} }
  end

  def handle_call({:make_move, guess}, _from, { game, watcher }) do
    Watchdog.im_alive(watcher)
    { updated_game, tally } = Game.make_move(game, guess)
    { :reply, tally, { updated_game, watcher } }
  end

  def handle_call({:tally}, _from, { game, watcher }) do
    Watchdog.im_alive(watcher)
    { :reply, Game.tally(game), { game, watcher } }
  end

end
