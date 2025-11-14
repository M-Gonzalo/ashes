defmodule Ecosystem.Packages.PackageTag do
  use Ash.Resource, otp_app: :ashes, domain: Ecosystem.Packages, data_layer: AshSqlite.DataLayer

  sqlite do
    table "package_tags"
    repo Ashes.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:package_id, :tag_id], update: [:package_id, :tag_id]]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :package_id, :uuid do
      allow_nil? false
      public? true
    end

    attribute :tag_id, :uuid do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :package, Ecosystem.Packages.Package,
      define_attribute?: false,
      source_attribute: :package_id

    belongs_to :tag, Ecosystem.Packages.Tag,
      define_attribute?: false,
      source_attribute: :tag_id
  end

  identities do
    identity :by_package_and_tag, [:package_id, :tag_id]
  end
end
