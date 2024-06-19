defmodule RiseWeb.ChatLive do
  use RiseWeb, :live_view

  alias Rise.Chats
  alias Rise.Chats.Chat

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    Rise is loading...
    """
  end

  def render(assigns) do
    ~H"""
    <div id="feed" phx-update="stream" class="flex flex-col gap-2">
      <div
        :for={{dom_id, chat} <- @streams.chats}
        id={dom_id}
        class="w-1/2 mx-auto flex flex-col gap-2 p-4 border rounded"
      >
        <div class="bg-white">
          <p><%= chat.user.email %></p>
          <p><%= chat.message %></p>
        </div>
      </div>
    </div>

    <.simple_form for={@form} phx-change="validate" phx-submit="save-message">
      <div class="flex w-full items-center">
        <.input field={@form[:message]} type="text" required class="w-full" />

        <.button type="submit" phx-disable-with="Saving...">Create Message</.button>
      </div>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Rise.PubSub, "chats")

      form =
        %Chat{}
        |> Chat.changeset(%{})
        |> to_form(as: "chat")

      socket =
        socket
        |> assign(form: form, loading: false)
        |> stream(:chats, Chats.list_chats())

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-message", %{"chat" => params}, socket) do
    %{current_user: user} = socket.assigns

    params
    |> Map.put("user_id", user.id)
    |> Chats.save()
    |> case do
      {:ok, chat} ->
        socket =
          socket
          |> put_flash(:info, "Chat created successfully!")

        # |> push_navigate(to: ~p"/home")

        Phoenix.PubSub.broadcast(Rise.PubSub, "chats", {:new, Map.put(chat, :user, user)})

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:new, chat}, socket) do
    socket =
      socket
      |> put_flash(:info, "#{chat.user.email} just messaged!")
      |> stream_insert(:chats, chat)

    {:noreply, socket}
  end
end
