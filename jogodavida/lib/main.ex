defmodule MainModule do
  require Matrix
  require Gameoflife

  def main do

    #Estados: 0 morto, 1 vivo, 2 zumbi

    {matrix_size,_} = IO.gets("Escreva o tamanho da grade: ") |> Integer.parse
    {qtd_iterations,_} = IO.gets("Escreva a quantidade de iterações: ") |> Integer.parse

    matrix = initialize_matrix(matrix_size)
    |> Matrex.print()

    {final_matrix, iterations_left} = Gameoflife.game(matrix, qtd_iterations)

    Matrex.print(final_matrix)

    print_result_iterations(qtd_iterations, iterations_left)


    :ok

  end

  def initialize_matrix(size) do

    Matrex.new(size, size, fn -> round(Enum.random(0..2)) end)

  end

  def print_result_iterations(qtd_iterations, iterations_left) do

    result = qtd_iterations - iterations_left

    if result > 0 do
        IO.puts "Jogo estabilizou em #{result} iterações"
    else
      IO.puts "Jogo executou todas iterações"
    end

  end

end
