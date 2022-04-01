defmodule WolfBehavior do
  @moduledoc """
  a wolf behavior
  """

  @callback howl(sound :: String.t()) :: {:ok, String.t()}
end
