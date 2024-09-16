defmodule B1Web.HangmanHTML do
  @moduledoc """
  This module contains pages rendered by HangmanController.

  See the `hangman_html` directory for all templates available.
  """
  use B1Web, :html

  embed_templates "hangman_html/*"

  def figure_for(0) do
    ~s{
  +---+
  |   |
  O   |
 /|\\  |
 / \\  |
      |
=========
    }
  end
  def figure_for(1) do
    ~s{
  +---+
  |   |
  O   |
 /|\\  |
 /    |
      |
=========
    }
  end
  def figure_for(2) do
    ~s{
  +---+
  |   |
  O   |
 /|\\  |
      |
      |
=========
    }
  end
  def figure_for(3) do
    ~s{
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========
    }
  end
  def figure_for(4) do
    ~s{
  +---+
  |   |
  O   |
  |   |
      |
      |
=========
    }
  end
  def figure_for(5) do
    ~s{
  +---+
  |   |
  O   |
      |
      |
      |
=========
    }
  end
  def figure_for(6) do
    ~s{
  +---+
  |   |
      |
      |
      |
      |
=========
    }
  end
  def figure_for(7) do
    ~s{
  +---+
      |
      |
      |
      |
      |
=========
    }
  end
end
