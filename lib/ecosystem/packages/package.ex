defmodule Ecosystem.Packages.Package do
  use Ash.Resource, otp_app: :ashes, domain: Ecosystem.Packages, data_layer: AshSqlite.DataLayer

  sqlite do
    table "packages"
    repo Ashes.Repo
  end

  actions do
    defaults [
      :read,
      :destroy,
      create: [
        :name,
        :package,
        :category,
        :official,
        :kind,
        :status,
        :description,
        :github_repo_handle
      ],
      update: [
        :name,
        :package,
        :category,
        :official,
        :kind,
        :status,
        :description,
        :github_repo_handle
      ]
    ]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :package, :string do
      allow_nil? false
      public? true
    end

    attribute :category, :string do
      allow_nil? false
      public? true
    end

    attribute :official, :boolean do
      public? true
    end

    attribute :kind, :string do
      public? true
    end

    attribute :status, :string do
      public? true
    end

    attribute :description, :string do
      public? true
    end

    attribute :github_repo_handle, :string do
      public? true
      allow_nil? true
    end

    timestamps()
  end

  relationships do
    has_many :package_tags, Ecosystem.Packages.PackageTag, destination_attribute: :package_id

    many_to_many :tags, Ecosystem.Packages.Tag,
      through: Ecosystem.Packages.PackageTag,
      join_relationship: :package_tags,
      source_attribute_on_join_resource: :package_id,
      destination_attribute_on_join_resource: :tag_id
  end

  calculations do
    calculate :hex_url, :string, expr("https://hex.pm/packages/" <> package) do
      public? true
    end

    calculate :docs_url, :string, expr("https://hexdocs.pm/" <> package) do
      public? true
    end

    calculate :deepwiki_url, :string, expr("https://deepwiki.com/" <> github_repo_handle) do
      public? true
    end
  end

  identities do
    identity :by_package, [:package]
    identity :by_github_repo_handle, [:github_repo_handle]
  end
end
