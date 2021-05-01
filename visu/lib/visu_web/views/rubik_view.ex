defmodule VisuWeb.RubikView do
  use VisuWeb, :view
  
  def make_move_button(move) do
    """
      <div class="move-button action-button">#{move}</div>
    """
    |> raw
  end

  def make_action_button(text, button_id) do
    """
      <div class="action-button" id=#{button_id}>#{text}</div>
    """
    |> raw

  end

  def json_encode(cube) do
    Jason.encode!(Map.from_struct(cube))
  end

end
