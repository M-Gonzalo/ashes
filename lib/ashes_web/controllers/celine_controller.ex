defmodule AshesWeb.CelineController do
  use AshesWeb, :controller

  def show(conn, _params) do
    conn
    |> redirect(external: "https://youtu.be/CX11yw6YL1w")
  end
end
