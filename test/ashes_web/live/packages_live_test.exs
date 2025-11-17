defmodule AshesWeb.PackagesLiveTest do
  use AshesWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # Helpers to assert count integrity against rendered cards
  defp count_from_label(html) do
    case Regex.run(~r/(\d+)\s+components shown/, html) do
      [_, num] -> String.to_integer(num)
      _ -> flunk("Could not find components count label in HTML")
    end
  end

  defp count_cards(html) do
    Regex.scan(~r/class="package-catalog-card"/, html)
    |> length()
  end

  test "renders packages page with header and count", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/packages")

    assert has_element?(view, "h1", "Ash Framework Ecosystem Catalog")
    assert has_element?(view, "p.package-catalog-count", ~r/components shown/)

    # Deep assertion: label count matches number of rendered cards
    html = render(view)
    assert count_from_label(html) == count_cards(html)
  end

  test "search updates listing, keeps input value, and count is consistent", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/packages")

    initial_html = render(view)
    initial_count = count_from_label(initial_html)
    initial_cards = count_cards(initial_html)
    assert initial_count == initial_cards

    # submit a search term via the search form
    view
    |> element("form[phx-change=search]")
    |> render_change(%{"search" => "ash"})

    # input value is reflected back into the DOM
    assert render(view) =~ ~s(id="search")
    assert render(view) =~ ~s(value="ash")

    # Deep assertion: after search, counts match and are <= initial
    html = render(view)
    new_count = count_from_label(html)
    new_cards = count_cards(html)
    assert new_count == new_cards
    assert new_count <= initial_count
  end

  test "category filter changes select selection and count is consistent", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/packages")

    initial_html = render(view)
    initial_count = count_from_label(initial_html)
    initial_cards = count_cards(initial_html)
    assert initial_count == initial_cards

    # change the category to "api"
    view
    |> element("form[phx-change=filter_category]")
    |> render_change(%{"category" => "api"})

    # The option with value="api" should now be selected
    html = render(view)
    assert html =~ ~s(<option value="api" selected)

    # Deep assertion: count label matches cards and is <= initial
    new_count = count_from_label(html)
    new_cards = count_cards(html)
    assert new_count == new_cards
    assert new_count <= initial_count
  end

  test "status chip toggles selection for 'official' and count stays consistent", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/packages")

    initial_html = render(view)
    initial_count = count_from_label(initial_html)
    initial_cards = count_cards(initial_html)
    assert initial_count == initial_cards

    # Click the 'official' status chip (unselected state in default toolbar)
    view
    |> element(~s(span.package-catalog-chip[phx-value-type="official"]))
    |> render_click()

    # After click, toolbar re-renders with only the selected chip branch
    # Ensure chip has the selected class and the 'official' type marker
    html = render(view)
    assert html =~ ~s(package-catalog-chip--selected)
    assert html =~ ~s(phx-value-type="official")

    # Deep assertion: count label matches cards and is <= initial
    official_count = count_from_label(html)
    official_cards = count_cards(html)
    assert official_count == official_cards
    assert official_count <= initial_count

    # Clicking again should clear the filter (chip rendered in selected state has clear=true)
    view
    |> element(~s(span.package-catalog-chip[phx-value-type="official"]))
    |> render_click()

    # After clearing, the default toolbar renders again (no selected class present)
    html2 = render(view)
    refute html2 =~ ~s(package-catalog-chip--selected)

    # Deep assertion: count label matches cards
    cleared_count = count_from_label(html2)
    cleared_cards = count_cards(html2)
    assert cleared_count == cleared_cards
  end
end
