defmodule B1Web.HangmanController do
  use B1Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    game |> dbg
    tally = Hangman.tally(game)

    conn
    |> put_session(:game, game)
    |> render(:game, tally: tally)
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]

    tally = conn
    |> get_session(:game)
    |> Hangman.make_move(guess)

    put_in(conn.params["make_move"]["guess"], "")
    |> render(:game, tally: tally)
    # raise inspect(params)
  end
end
