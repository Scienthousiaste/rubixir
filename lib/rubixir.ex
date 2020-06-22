defmodule Rubixir do
  @moduledoc """
  Documentation for `Rubixir`.
  """
	alias Rubixir.Solver, as: Solver

	def main(input) do
		input
		|> String.split(" ")
		|> parse_options
		|> parse_moves
		|> Solver.solve	
		|> print_solution
	end

	def parse_options(token_list) do
		Enum.at(token_list, 0) <> " options ! "
	end

	def parse_moves(input) do
		input <> " moves ! "
	end

	def print_solution(string) do
		IO.puts string
	end
end
