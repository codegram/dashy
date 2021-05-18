defmodule DashyWeb.Components.Button do
  use Surface.Component

  @doc "Extra Css classes"
  prop class, :css_class, required: false

  @doc "The type of the button"
  prop type, :string, default: "button"

  @doc "The color of the button"
  prop color, :string, default: "primary"

  @doc "The class of the button"
  prop background, :string, default: "primary"

  @doc "The content for the button"
  slot default, required: true

  @doc "Event emitted by the button"
  prop click, :event, required: false

  @doc "Value emitted by the button"
  prop value, :string, required: false

  def render(assigns) do
    ~H"""
    <button
      :on-click={{ @click }}
      phx-value-val="{{@value}}"
      type={{@type}}
      class={{@class, "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white focus:outline-none focus:ring-2 focus:ring-offset-2", "bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500": @color == "primary" && @background == "primary",
      "bg-yellow-400 hover:bg-yellow-500 focus:ring-yellow-500": @color == "warning" && @background == "primary",
      "bg-red-600 hover:bg-red-700 focus:ring-red-500": @color == "alert" && @background == "primary",
      "text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:ring-indigo-500": @color == "primary" && @background == "secondary",
      "text-yellow-600 bg-yellow-200 hover:bg-yellow-300 focus:ring-yellow-500": @color == "warning" && @background == "secondary",
      "text-red-700 bg-red-100 hover:bg-red-200 focus:ring-red-500": @color == "alert" && @background == "secondary"
      }}>
      <slot/>
    </button>
    """
  end
end
