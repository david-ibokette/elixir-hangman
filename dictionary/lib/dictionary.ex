defmodule Dictionary do
  @opaque state :: Dictionary.Impl.WordList.t

  @spec start() :: state
  defdelegate start(), to: Dictionary.Impl.WordList

  @spec random_word(state) :: String.t
  defdelegate random_word(state), to: Dictionary.Impl.WordList
end
