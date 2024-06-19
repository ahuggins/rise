defmodule RiseWeb.HelloController do
  use RiseWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def show(conn, %{"messenger" => messenger}) do
    conn
    |> assign(:messenger, messenger)
    |> assign(:receiver, ~c"dwight")
    |> render(:show)
  end
end
