defmodule AshesWeb.PageController do
  use AshesWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
