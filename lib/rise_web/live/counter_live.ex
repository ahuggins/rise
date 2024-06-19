defmodule RiseWeb.CounterLive do
  use RiseWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, count: 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl">Count: <%= @count %></h1>
    <div class="flex gap-4 mt-3">
      <button class="px-4 py-2 rounded bg-blue-500" phx-click="increment">+</button>
      <button class="px-4 py-2 rounded bg-red-500" phx-click="decrement">-</button>
    </div>
    """
  end

  def handle_event("increment", _, socket) do
    count = socket.assigns.count + 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end

  def handle_event("decrement", _, socket) do
    count = socket.assigns.count - 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end
end
