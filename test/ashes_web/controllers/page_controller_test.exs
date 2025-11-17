defmodule AshesWeb.PageControllerTest do
  use AshesWeb.ConnCase

  test "GET / redirects to /packages", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn, 302) == ~p"/packages"
  end
end
