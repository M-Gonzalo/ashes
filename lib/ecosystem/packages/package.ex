defmodule Ecosystem.Packages.Package do
  use Ash.Resource,
    otp_app: :ashes,
    domain: Ecosystem.Packages,
    data_layer: AshSqlite.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  import Ash.Expr

  sqlite do
    table "packages"
    repo Ashes.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [
        :name,
        :package,
        :category,
        :official,
        :kind,
        :status,
        :description,
        :github_repo_handle
      ]
    end

    update :update do
      accept [
        :name,
        :package,
        :category,
        :official,
        :kind,
        :status,
        :description,
        :github_repo_handle
      ]
    end

    update :add_github_repo do
      accept [:github_repo_handle]
    end

    read :packages do
      argument :category, :string, allow_nil?: true
      argument :official, :boolean, allow_nil?: true
      argument :status, :string, allow_nil?: true
      argument :tags, {:array, :string}, allow_nil?: true, default: []
      argument :search, :string, allow_nil?: true, default: ""

      filter expr(
               (is_nil(^arg(:category)) or category == ^arg(:category)) and
                 (is_nil(^arg(:official)) or official == ^arg(:official)) and
                 (is_nil(^arg(:status)) or status == ^arg(:status))
             )

      prepare fn query, _context ->
        tags = Ash.Query.get_argument(query, :tags) || []
        search = Ash.Query.get_argument(query, :search) || ""

        query
        |> apply_tags_filter(tags)
        |> apply_search_filter(search)
      end
    end
  end

  pub_sub do
    module AshesWeb.Endpoint
    prefix "package"

    publish :create, ["created", :id]
    publish :update, ["updated"]
    publish :update, ["updated", :id]
    publish :add_github_repo, ["updated"]
    publish :add_github_repo, ["updated", :id]
    publish :destroy, ["destroyed", :id]
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

    calculate :deepwiki_url,
              :string,
              expr(
                if is_nil(github_repo_handle) do
                  nil
                else
                  "https://deepwiki.com/" <> github_repo_handle
                end
              ) do
      public? true
    end
  end

  identities do
    identity :by_package, [:package]
    identity :by_github_repo_handle, [:github_repo_handle]
  end

  # Helper functions - build expressions that will be passed to Ash.Query.filter
  defp apply_tags_filter(query, []), do: query

  defp apply_tags_filter(query, tags) do
    filter_expr =
      Enum.reduce(tags, expr(true), fn tag, acc ->
        expr(^acc and exists(tags, name == ^tag))
      end)

    Ash.Query.do_filter(query, filter_expr)
  end

  defp apply_search_filter(query, ""), do: query

  defp apply_search_filter(query, search) do
    Ash.Query.do_filter(
      query,
      expr(
        contains(name, ^search) or
          contains(package, ^search) or
          contains(description, ^search) or
          exists(tags, contains(name, ^search))
      )
    )
  end
end
