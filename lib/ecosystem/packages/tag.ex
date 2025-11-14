defmodule Ecosystem.Packages.Tag do
  use Ash.Resource, otp_app: :ashes, domain: Ecosystem.Packages, data_layer: AshSqlite.DataLayer

  sqlite do
    table "tags"
    repo Ashes.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name], update: [:name]]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  identities do
    identity :by_name, [:name]
  end
end
