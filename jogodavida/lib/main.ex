defmodule MainModule do
  require Matrix
  require Gameoflife

  def main do

    #Estados: 0 morto, 1 vivo, 2 zumbi

    {matrix_size,_} = IO.gets("Escreva o tamanho da grade: ") |> Integer.parse
    {qtd_iterations,_} = IO.gets("Escreva a quantidade de iterações: ") |> Integer.parse

    matrix = initialize_matrix(matrix_size)
    |> Matrex.print()

    Gameoflife.game(matrix, qtd_iterations)
    |> Matrex.print()

    :ok

  end

  def initialize_matrix(size) do

    Matrex.new(size, size, fn -> round(Enum.random(0..2)) end)

  end

end
