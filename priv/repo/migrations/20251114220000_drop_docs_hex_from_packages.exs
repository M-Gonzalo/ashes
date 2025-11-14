defmodule Ashes.Repo.Migrations.DropDocsHexFromPackages do
  use Ecto.Migration

  def up do
    alter table(:packages) do
      remove :docs_url
      remove :hex_url
    end
  end

  def down do
    alter table(:packages) do
      add :docs_url, :text
      add :hex_url, :text
    end
  end
end
