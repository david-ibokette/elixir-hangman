defmodule B1Web.HangmanHTML do
  @moduledoc """
  This module contains pages rendered by HangmanController.

  See the `hangman_html` directory for all templates available.
  """
  use B1Web, :html

  embed_templates "hangman_html/*"

  def continue_or_try_again(assigns) do
    ~H"""
  <.link :if={@state in [:won, :lost]} href={~p"/hangman"}>
	<.button>Try again</.button>
</.link>
<.form
	:let={f}
	:if={@state not in [:won, :lost]}
	for={%{}}
  	as={:make_move}
  	action={~p"/hangman"}
  	method="put"
>
	<.input field={f[:guess]} />
	<.button>Make next guess</.button>
</.form>
"""
  end

  @status_fields %{
    initializing: { "initializing", "Guess the word, a letter a a time" },
    good_guess:   {"good-guess",    "Good guess!"},
    bad_guess:    {"bad-guess",     "Sorry, that's a bad guess"},
    won:          {"won",           "You won!"},
    lost:         {"lost",          "Sorry, you lost"},
    already_used: {"already-used",  "You already used that letter"}
  }

  def move_status(status) do
    { class, msg } = @status_fields[status]
    "<div class='status #{class}'>#{msg}</div>"
  end

  defdelegate figure_for(turns_left), to: B1Web.HangmanView.Helpers.FigureFor

end
