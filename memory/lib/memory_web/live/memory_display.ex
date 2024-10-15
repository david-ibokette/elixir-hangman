defmodule MemoryWeb.Live.MemoryDisplay do
  use MemoryWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :name, "Earth!!!!")
    {:ok, schedule_tick_and_update_assign(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, schedule_tick_and_update_assign(socket)}
  end

  defp schedule_tick_and_update_assign(socket) do
    Process.send_after(self(), :tick, 1000)
    assign(socket, :memory, :erlang.memory())
  end

  def render(assigns) do
    ~H"""
    <h1>
      Hola <%= assigns.name %> from LiveView
    </h1>
    <table>
      <tbody>
        <%= for {name, value} <- assigns.memory do %>
          <tr>
            <th><%= name %></th>
            <td><%= value %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end