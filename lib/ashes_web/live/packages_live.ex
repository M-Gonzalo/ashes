defmodule AshesWeb.PackagesLive do
  use AshesWeb, :live_view

  alias Ecosystem.Packages
  import AshesWeb.Components.StatusChip

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Ash Framework Ecosystem Catalog")
      |> assign(:search, "")
      |> assign(:category_filter, "")
      |> assign(:filter_type, "")
      |> assign(:active_tags, [])
      |> assign(:current_scope, nil)
      |> assign(:packages, [])
      |> assign(:filtered_packages, [])
      |> assign(:categories, get_categories())
      |> load_packages()

    if connected?(socket) do
      AshesWeb.Endpoint.subscribe("package:created")
      AshesWeb.Endpoint.subscribe("package:updated")
      AshesWeb.Endpoint.subscribe("package:destroyed")
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    search = params["search"] || ""
    category = params["category"] || ""
    filter = params["filter"] || ""
    tags = (params["tags"] || "") |> String.split(",", trim: true) |> Enum.reject(&(&1 == ""))

    socket =
      socket
      |> assign(:search, search)
      |> assign(:category_filter, category)
      |> assign(:filter_type, filter)
      |> assign(:active_tags, tags)
      |> apply_filters(search, category, filter, tags)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    query_params =
      base_query(search, socket.assigns.category_filter, socket.assigns.active_tags) ++
        if(socket.assigns.filter_type != "", do: [filter: socket.assigns.filter_type], else: [])

    socket =
      socket
      |> assign(:search, search)
      |> apply_filters(
        search,
        socket.assigns.category_filter,
        socket.assigns.filter_type,
        socket.assigns.active_tags
      )

    {:noreply, push_patch(socket, to: build_path(query_params), replace: true)}
  end

  @impl true
  def handle_event("noop", %{"search" => search}, socket) do
    query_params =
      base_query(search, socket.assigns.category_filter, socket.assigns.active_tags) ++
        if(socket.assigns.filter_type != "", do: [filter: socket.assigns.filter_type], else: [])

    socket =
      socket
      |> assign(:search, search)
      |> apply_filters(
        search,
        socket.assigns.category_filter,
        socket.assigns.filter_type,
        socket.assigns.active_tags
      )

    {:noreply, push_patch(socket, to: build_path(query_params), replace: true)}
  end

  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("filter_category", %{"category" => category}, socket) do
    query_params =
      base_query(socket.assigns.search, category, socket.assigns.active_tags) ++
        if(socket.assigns.filter_type != "", do: [filter: socket.assigns.filter_type], else: [])

    {:noreply, push_patch(socket, to: build_path(query_params))}
  end

  @impl true
  def handle_event("filter_status", %{"type" => _type, "clear" => "true"}, socket) do
    # Clear the filter by removing the filter parameter
    query_params =
      base_query(
        socket.assigns.search,
        socket.assigns.category_filter,
        socket.assigns.active_tags
      )

    {:noreply, push_patch(socket, to: build_path(query_params))}
  end

  def handle_event("filter_status", %{"type" => type}, socket) do
    # Set the filter to the specified type
    query_params =
      base_query(
        socket.assigns.search,
        socket.assigns.category_filter,
        socket.assigns.active_tags
      ) ++
        [filter: type]

    {:noreply, push_patch(socket, to: build_path(query_params))}
  end

  @impl true
  def handle_event("add_tag", %{"tag" => tag}, socket) do
    active_tags =
      if(tag in socket.assigns.active_tags,
        do: socket.assigns.active_tags,
        else: [tag | socket.assigns.active_tags]
      )

    query_params =
      base_query(socket.assigns.search, socket.assigns.category_filter, active_tags) ++
        if(socket.assigns.filter_type != "", do: [filter: socket.assigns.filter_type], else: [])

    {:noreply, push_patch(socket, to: build_path(query_params))}
  end

  @impl true
  def handle_event("remove_tag", %{"tag" => tag}, socket) do
    active_tags = List.delete(socket.assigns.active_tags, tag)

    query_params =
      base_query(socket.assigns.search, socket.assigns.category_filter, active_tags) ++
        if(socket.assigns.filter_type != "", do: [filter: socket.assigns.filter_type], else: [])

    {:noreply, push_patch(socket, to: build_path(query_params))}
  end

  @impl true
  def handle_info(%Ash.Notifier.Notification{} = notification, socket) do

    socket = load_packages(socket)

    socket =
      apply_filters(
        socket,
        socket.assigns.search,
        socket.assigns.category_filter,
        socket.assigns.filter_type,
        socket.assigns.active_tags
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{topic: topic, event: _event}, socket)
      when topic in ["package:created", "package:updated", "package:destroyed"] do
    socket = load_packages(socket)

    socket =
      apply_filters(
        socket,
        socket.assigns.search,
        socket.assigns.category_filter,
        socket.assigns.filter_type,
        socket.assigns.active_tags
      )

    {:noreply, socket}
  end

  # Query building helpers to centralize URL parameter construction
  defp base_query(search, category_filter, active_tags) do
    []
    |> maybe_put(:search, search)
    |> maybe_put(:category, category_filter)
    |> maybe_put(:tags, Enum.join(active_tags, ","))
  end

  defp build_path([]), do: ~p"/packages"
  defp build_path(params), do: ~p"/packages" <> "?" <> URI.encode_query(params)

  defp maybe_put(acc, _key, ""), do: acc
  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: [{key, value} | acc]

  defp load_packages(socket) do
    packages =
      Packages.Package
      |> Ash.Query.for_read(:read)
      |> Ash.Query.load([:tags])
      |> Ash.Query.sort([:name])
      |> Ash.read!()

    assign(socket, :packages, packages)
  end

  defp apply_filters(socket, search, category, filter, active_tags) do
    category_arg = if category != "", do: category, else: nil

    official_arg =
      case filter do
        "official" -> true
        "community" -> false
        _ -> nil
      end

    status_arg =
      case filter do
        "soft-deprecated" -> "soft-deprecated"
        "retired" -> "retired"
        _ -> nil
      end

    packages =
      Packages.get_packages!(
        category_arg,
        official_arg,
        status_arg,
        active_tags,
        search,
        load: [:tags],
        query: [sort: [:name]]
      )

    # No more client-side filtering needed
    assign(socket, :filtered_packages, packages)
  end

  defp get_categories do
    [
      {"All categories", ""},
      {"Core framework", "core"},
      {"Data layers", "data-layer"},
      {"API & transport", "api"},
      {"Auth & security", "auth"},
      {"Domain behavior", "domain"},
      {"UI & admin", "ui"},
      {"Observability", "observability"},
      {"Workflow & orchestration", "workflow"},
      {"Testing & fixtures", "testing"},
      {"Tooling & DX", "tooling"},
      {"Miscellaneous", "misc"}
    ]
  end
end
