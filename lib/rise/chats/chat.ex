defmodule Rise.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rise.Accounts.User

  schema "chats" do
    field :message, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:message, :user_id])
    |> validate_required([:message, :user_id])
  end
end
