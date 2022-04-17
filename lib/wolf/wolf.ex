defmodule Wolf do
  @moduledoc """
  implements wolf behavior
  """
  @behaviour WolfBehavior

  @impl true
  @spec howl(String.t()) :: {:ok, String.t()}
  def howl(sound) do
    {:ok, massage_sound(sound)}
  end

  defp massage_sound(sound), do: "#{sound}!!!"

  def bike(), do: :bike
end
