defmodule Rise.Repo do
  use Ecto.Repo,
    otp_app: :rise,
    adapter: Ecto.Adapters.SQLite3
end
