defmodule TMSOWeb.OverlayView do
  use TMSOWeb, :view

  def display_match_format(nil), do: ""
  def display_match_format(pl_number), do: "#{pl_number}v#{pl_number}"
end
