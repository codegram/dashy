defmodule DashyWeb.Components.CardTitle do
  use Surface.Component

  @doc "The title of the card"
  prop title, :string, required: false

  @doc "The subtitle of the card"
  prop subtitle, :string, required: false

  def render(assigns) do
    ~H"""
    <div class="bg-white px-4 py-5 border-b border-gray-200 sm:px-6">
      <div class="-ml-4 -mt-4 flex justify-between items-center flex-wrap sm:flex-nowrap">
        <div class="ml-4 mt-4">
          <h3 class="text-lg leading-6 font-medium text-gray-900">
            {{ @title }}
          </h3>
          <p class="mt-1 text-sm text-gray-500">
            {{ @subtitle }}
          </p>
        </div>
      </div>
    </div>
    """
  end
end
