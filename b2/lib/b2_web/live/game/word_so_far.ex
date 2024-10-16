defmodule B2Web.Live.Game.WordSoFar do
  use B2Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  defp state_name(_state = :already_used), do: "What are you, loco?"
  defp state_name(_state = :bad_guess), do: "Negatory"
  defp state_name(_state = :good_guess), do: "Affirmative"
  defp state_name(_state = :initializing), do: "Type or Click on your first guess"
  defp state_name(_state = :lost), do: "Sorry, loser"
  defp state_name(_state = :won), do: "You Win!!!"
  defp state_name(_) do "No-op" end

  def render(assigns) do
    ~H"""
    <div class="word-so-far">
      <div class="game-state">
        <%= state_name(@tally.game_state) %>
      </div>
      <div class="letters">
        <%= for letter <- @tally.letters do %>
          <div class={"one-letter #{if letter != "_", do: "correct"}"}>
            <%= letter %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end