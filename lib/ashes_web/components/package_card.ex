defmodule AshesWeb.Components.PackageCard do
  use AshesWeb, :html

  def package_card(assigns) do
    ~H"""
    <article class="package-catalog-card">
      <div class="package-catalog-card-header">
        <div class="package-catalog-card-title">
          <span>{@package.name}</span>
          <small>{@package.package}</small>
        </div>
        <span class="package-catalog-card-category">{category_label(@package.category)}</span>
      </div>

      <p class="package-catalog-card-description">{@package.description}</p>

      <div class="package-catalog-card-footer">
        <div class="package-catalog-pill-row">
          {render_origin_pill(@package.official)}
          <%= if @package.kind do %>
            <span class="package-catalog-pill">{@package.kind}</span>
          <% end %>
          <%= if @package.status do %>
            <span class={[
              "package-catalog-pill",
              "package-catalog-chip",
              status_class(@package.status)
            ]}>
              {@package.status}
            </span>
          <% end %>

          <%= for tag <- @package.tags do %>
            <% {class, style} = AshesWeb.PillHelpers.pill_style(tag.name) %>
            <span
              class={"#{class} cursor-pointer"}
              style={style}
              phx-click="add_tag"
              phx-value-tag={tag.name}
            >
              {tag.name}
            </span>
          <% end %>
        </div>

        <div class="package-catalog-links">
          <%= if @package.package do %>
            <a
              href={"https://hex.pm/packages/" <> @package.package}
              target="_blank"
              rel="noreferrer"
              class="package-catalog-link"
            >
              Hex
            </a>
          <% end %>
          <%= if @package.package do %>
            <a
              href={"https://hexdocs.pm/" <> @package.package}
              target="_blank"
              rel="noreferrer"
              class="package-catalog-link"
            >
              Docs
            </a>
          <% end %>
          <%= if @package.github_repo_handle && @package.github_repo_handle != "" do %>
            <a
              href={"https://deepwiki.com/" <> @package.github_repo_handle}
              target="_blank"
              rel="noreferrer"
              class="package-catalog-link"
            >
              DeepWiki
            </a>
          <% end %>
        </div>
      </div>
    </article>
    """
  end

  defp category_label(category) do
    case category do
      "core" -> "Core Framework"
      "data-layer" -> "Data Layer"
      "api" -> "API & Transport"
      "auth" -> "Auth & Security"
      "domain" -> "Domain Behavior"
      "ui" -> "UI & Admin"
      "observability" -> "Observability"
      "workflow" -> "Workflow & Orchestration"
      "testing" -> "Testing & Fixtures"
      "tooling" -> "Tooling & DX"
      "misc" -> "Miscellaneous"
      _ -> category
    end
  end

  defp render_origin_pill(official) do
    if official do
      assigns = %{}

      ~H"""
      <span class="package-catalog-pill pill--official">Official</span>
      """
    else
      assigns = %{}

      ~H"""
      <span class="package-catalog-pill pill--community">Community</span>
      """
    end
  end

  defp status_class(status) do
    case status do
      nil ->
        ""

      status ->
        status_lower = String.downcase(status)

        cond do
          String.contains?(status_lower, "retired") -> "package-catalog-chip--danger"
          String.contains?(status_lower, "soft") -> "package-catalog-chip--warning"
          String.contains?(status_lower, "experimental") -> "package-catalog-chip--warning"
          true -> ""
        end
    end
  end
end
