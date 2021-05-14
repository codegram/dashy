defmodule Dashy.Charts.Run do
  @derive Jason.Encoder
  defstruct [:time, :seconds, :minutes, :link, :status]
end
