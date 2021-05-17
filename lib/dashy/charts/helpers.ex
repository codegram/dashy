defmodule Dashy.Charts.Helpers do
  def generate_colors(total) do
    0..total
    |> Enum.map(fn index ->
      %{
        h: "#{360 / total * index}",
        s: "#{50 + 25 * rem(index, 3)}%",
        l: "#{75 - 25 * rem(index, 3)}%"
      }
    end)
  end

  def build_style_color(%{h: h, s: s, l: l}, a \\ "100%") do
    "hsla(#{h}, #{s}, #{l}, #{a})"
  end
end
