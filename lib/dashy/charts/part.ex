defmodule Dashy.Charts.Part do
  @derive Jason.Encoder
  defstruct [:name, :time, :seconds, :minutes, :link]
end
