defmodule AshesWeb.PageController do
  use AshesWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/packages")
  end
end
