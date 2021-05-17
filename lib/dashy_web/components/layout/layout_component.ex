defmodule DashyWeb.Components.Layout do
  use Surface.LiveComponent

  alias DashyWeb.Router.Helpers, as: Routes

  alias Dashy.Repositories

  alias Surface.Components.Form

  @doc "The content of the Layout"
  slot default, required: true

  prop repos, :list, required: false, default: []
  prop show, :boolean, default: false

  def render(assigns) do
    ~H"""
    <header class="w-full h-14 bg-black sticky p-2" x-data="{focus: false}">
      <Form for={{ :repo }} change="change" opts={{ autocomplete: "off" }}>
        <input type="hidden" name="repo[show]" x-model="focus" />
        <input
          type="text"
          value=""
          name="repo[name]"
          class="px-2 py-1 border rounded transition duration-500 text-sm"
          placeholder="Search or jump to..."
          :class="{ 'bg-white w-80 text-black': focus, 'w-40 bg-transparent text-white': !(focus) }"
          x-on:focus="focus = true"
          x-on:blur="
            focus = false;
            $nextTick(() => {$dispatch('input', {bubbles: true})})
          "
          />

      </Form>
      <ul :if={{(@repos |> Enum.count() > 0) && @show}} class="absolute w-80 shadow-md">
        <li :for={{repo <- @repos}} class="text-gray-600 bg-white border-b-2 p-4">
          <a href="{{Routes.repo_path(@socket, :index, repo.name)}}">{{repo.name}}</a></li>
      </ul>
    </header>
    <slot/>
    """
  end

  def handle_event("change", %{"repo" => %{"name" => name, "show" => show}}, socket) do
    repos =
      case name |> String.length() do
        0 -> []
        _ -> Repositories.get_repositories_by_name(name)
      end

    socket = assign(socket, repos: repos, show: show_value(show))
    {:noreply, socket}
  end

  def handle_event("change", _params, socket) do
    {:noreply, socket}
  end

  defp show_value("false"), do: false
  defp show_value(false), do: false
  defp show_value("true"), do: true
  defp show_value(true), do: false
end
