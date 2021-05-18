defmodule DashyWeb.PageLiveTest do
  use DashyWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Repos"
    assert render(page_live) =~ "Here you can see some awesome repos"
  end
end
