defmodule Dictionary do
  @opaque state :: { list(String.t) }

  @spec start() :: :ok
  defdelegate start(), to: Dictionary.Impl.WordList

  @spec random_word(state) :: String.t
  defdelegate random_word(state), to: Dictionary.Impl.WordList
end
