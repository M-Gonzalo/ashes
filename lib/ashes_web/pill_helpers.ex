defmodule AshesWeb.PillHelpers do
  @moduledoc """
  Shared helpers for pill styling in the application.
  """

  def pill_style(name) when is_binary(name) do
    normalized = String.trim(name)

    case String.downcase(normalized) do
      "official" ->
        {"package-catalog-pill pill--official", nil}

      "community" ->
        {"package-catalog-pill pill--community", nil}

      _ ->
        {h, s, l_border, l_text} = generated_hsl(normalized)
        border = hsl_to_hex(h, s, l_border)
        text = hsl_to_hex(h, s, l_text)
        style = "border-color: #{border}; color: #{text};"
        {"package-catalog-pill", style}
    end
  end

  defp generated_hsl(name) do
    # Use a larger, single phash and a multiplicative spread to reduce clustering.
    seed = :erlang.phash2(name, 1_000_007)

    # Multiply by a large odd constant and fold into 0..359 for the hue.
    hue = rem(seed * 2_654_435_761, 360)

    # Use different parts of the seed to compute saturation and luminances
    # 55..85 range
    saturation = 55 + rem(div(seed, 360), 31)
    # 32..51 range
    l_border = 32 + rem(div(seed, 360 * 31), 20)
    # 88..95 range
    l_text = 88 + rem(div(seed, 360 * 31 * 20), 8)

    {hue, saturation, l_border, l_text}
  end

  defp hsl_to_hex(h, s, l) when is_integer(h) and is_integer(s) and is_integer(l) do
    s = s / 100.0
    l = l / 100.0
    c = (1 - abs(2 * l - 1)) * s
    h_k = h / 60.0
    i = trunc(:math.floor(h_k)) |> Kernel.min(5)
    f = h_k - i
    x = c * (1 - abs(2 * f - 1))

    {r1, g1, b1} =
      case i do
        0 -> {c, x, 0}
        1 -> {x, c, 0}
        2 -> {0, c, x}
        3 -> {0, x, c}
        4 -> {x, 0, c}
        5 -> {c, 0, x}
      end

    m = l - c / 2

    r = clamp_round((r1 + m) * 255)
    g = clamp_round((g1 + m) * 255)
    b = clamp_round((b1 + m) * 255)

    "#" <> hex2(r) <> hex2(g) <> hex2(b)
  end

  defp clamp_round(value) when is_float(value) do
    value
    |> round()
    |> max(0)
    |> min(255)
  end

  defp hex2(int) when is_integer(int) do
    int
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end
end
