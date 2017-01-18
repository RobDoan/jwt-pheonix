defmodule JwtPhoenix.Plugs.CheckAdmin do
  require Logger
  import Plug.Conn

  def init(role) do
    role
  end

  @doc """
    Verify if metadata is admin
  """
  def call(conn, role) do
    claims = Map.get(conn.assigns, :joken_claims)
    case Map.get(claims, "app_metadata") do
      user_role when user_role == role ->
        assign(conn, :admin, true)
      _ ->
        conn
        |> forbidden
    end
  end

  @doc """
  send 403 status code to client
  """
  def forbidden(conn) do
    msg = %{
        errors: %{
          details: "forbidden resource"
      }
    }
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(403, Poison.encode!(msg))
    |> halt
  end
end
