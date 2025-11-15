defmodule AshesWeb.Components.StatusChip do
  use AshesWeb, :html

  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :selected, :boolean, default: false
  attr :class, :string, default: "package-catalog-chip"
  attr :style, :string, default: nil
  attr :click_event, :string, default: "filter_status"

  def status_chip(assigns) do
    assigns = assign(assigns, :clear?, assigns.selected)
    assigns = assign(assigns, :click_value, assigns.value)

    ~H"""
    <span
      class={[@class, @selected && "package-catalog-chip--selected", "cursor-pointer"]}
      style={@style}
      phx-click={@click_event}
      phx-value-type={@click_value}
      phx-value-clear={if(@clear?, do: "true", else: "false")}
    >
      {@label}
      <%= if @selected do %>
        <.icon name="hero-x-mark" class="w-3 h-3 ml-2" />
      <% end %>
    </span>
    """
  end
end
