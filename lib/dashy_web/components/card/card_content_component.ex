# <div class="-mt-px px-4 py-5">
#           <slot/>
#         </div>
defmodule DashyWeb.Components.CardContent do
  use Surface.Component

  @doc "The content of the Card"
  slot default, required: true

  def render(assigns) do
    ~H"""
    <div class="-mt-px px-4 py-5">
      <slot/>
    </div>
    """
  end
end
