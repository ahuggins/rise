defmodule Rise.Chats do
  import Ecto.Query, warn: false

  alias Rise.Repo
  alias Rise.Chats.Chat

  def list_chats do
    query =
      from c in Chat,
        select: c,
        order_by: [asc: :inserted_at],
        preload: [:user]

    Repo.all(query)
  end

  def save(params) do
    %Chat{}
    |> Chat.changeset(params)
    |> Repo.insert()
  end
end
