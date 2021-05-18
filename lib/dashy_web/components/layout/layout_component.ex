defmodule DashyWeb.Components.Layout do
  use Surface.LiveComponent

  alias DashyWeb.Router.Helpers, as: Routes

  alias Dashy.Repositories
  alias DashyWeb.Components.Button
  alias DashyWeb.Components.Modal

  alias Surface.Components.Form

  @doc "The content of the Layout"
  slot default, required: true

  prop repos, :list, required: false, default: []
  prop show, :boolean, default: false
  prop modal, :boolean, default: false

  def render(assigns) do
    ~H"""
    <header class="w-full h-14 bg-black sticky p-2 flex flex-row" x-data="{focus: false}">
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
      <Button class="ml-4" click="open-modal">New Repository</Button>
      <ul :if={{(@repos |> Enum.count() > 0) && @show}} class="absolute w-80 shadow-md top-10">
        <li :for={{repo <- @repos}} class="text-gray-600 bg-white border-b-2 p-4">
          <a href="{{Routes.repo_path(@socket, :index, repo.name)}}">{{repo.name}}</a></li>
      </ul>
      <Modal :if={{@modal}}>
        <Form for={{:new_repo}} submit="create-repo" opts={{ autocomplete: "off" }}>
          <h1>New Repo</h1>
          <div class="mt-6">
            <label for="user" class="block text-sm font-medium text-gray-700">user</label>
            <div class="mt-1">
              <input type="text" name="new_repo[user]" id="user" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md" placeholder="github username">
            </div>
          </div>
          <div class="mt-4">
            <label for="name" class="block text-sm font-medium text-gray-700">Name</label>
            <div class="mt-1">
              <input type="text" name="new_repo[name]" id="name" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md" placeholder="github repository name">
            </div>
          </div>
          <div class="mt-6 flex flex-row justify-end ">
            <Button click="close-modal" color="alert" background="secondary">Cancel</Button>
            <Button type="submit" class="ml-4" color="primary" background="primary">Create</Button>
          </div>
        </Form>
      </Modal>
    </header>
    <slot/>
    """
  end

  def handle_event("create-repo", %{"new_repo" => params}, socket) do
    case Repositories.create_repository(params) do
      {:ok, repository} ->
        {:noreply, redirect(socket, to: Routes.repo_path(socket, :index, repository.name))}

      {:error, changeset} ->
        socket = assign(socket, errors: changeset.errors)
        {:noreply, socket}
    end
  end

  def handle_event("open-modal", _, socket) do
    {:noreply, socket |> assign(modal: true)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, socket |> assign(modal: false)}
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
