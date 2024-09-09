defmodule TextClient do
  alias ElixirLS.LanguageServer.Providers.CodeMod.Text
  @spec start() :: :ok
  def start() do
    TextClient.Runtime.RemoteHangman.connect()
    |> TextClient.Impl.Player.start()
  end
end
