

defmodule MainModule do
  require Matrix

  def main do


    {matrix_size,_} = IO.gets("Escreva o tamanho da grade: ") |> Integer.parse
    {qtd_iterations,_} = IO.gets("Escreva a quantidade de iterações: ") |> Integer.parse

    matrix = initialize_matrix(matrix_size)

    IO.inspect matrix

  end

  def initialize_matrix(size) do

    matrix = Matrix.from_list([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ])

    matrix

  end

  def initialize_matrix


end
