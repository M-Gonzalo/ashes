defmodule AshesWeb.Plugs.SetScriptName do
  import Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "x-forwarded-prefix") do
      [prefix | _] when is_binary(prefix) and prefix != "" ->
        prefix = ensure_leading_slash(prefix)
        prefix = normalize_trailing(prefix)
        segments = String.split(prefix, "/", trim: true)
        %{conn | script_name: conn.script_name ++ segments}

      _ ->
        conn
    end
  end

  defp ensure_leading_slash(<<"/"::binary, _::binary>> = s), do: s
  defp ensure_leading_slash(s), do: "/" <> s

  defp normalize_trailing("/"), do: "/"
  defp normalize_trailing(s), do: String.trim_trailing(s, "/")
end
