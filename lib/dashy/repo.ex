defmodule Dashy.Repo do
  use Ecto.Repo,
    otp_app: :dashy,
    adapter: Ecto.Adapters.Postgres
end
