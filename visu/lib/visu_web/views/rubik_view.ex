defmodule VisuWeb.RubikView do
  use VisuWeb, :view
  
  def make_move_button(move) do
    """
      <div class="move-button action-button">#{move}</div>
    """
    |> raw
  end

  def make_action_button(text) do
    """
      <div class="action-button">#{text}</div>
    """
    |> raw

  end

  def json_encode(cube) do
    Jason.encode!(Map.from_struct(cube))
  end

end
