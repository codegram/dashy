defmodule DashyWeb.Components.Card do
  use Surface.Component

  @doc "The content of the Card"
  slot default, required: true

  @doc "The title of the card"
  prop title, :string, required: false

  def render(assigns) do
    ~H"""
    <div class="mx-auto mt-4 max-w-none">
      <div class="overflow-hidden bg-white sm:rounded-lg sm:shadow">
        <slot/>
      </div>
    </div>
    """
  end
end
