defmodule MainModule do
  require Gameoflife

  def main do

    #Estados: 0 morto, 1 vivo, 2 zumbi

    #{matrix_size, qtd_iterations, automatic, step}
    matrix_info = get_initial_input()

    matrix = initialize_matrix(matrix_info)
    |> Matrex.print()

    {_, qtd_iterations, _, step} = matrix_info
    {final_matrix, iterations_left} = Gameoflife.game(matrix, {qtd_iterations, step})

    if(!step)do
      Matrex.print(final_matrix)
    end

    print_result_iterations(qtd_iterations, iterations_left)


    :ok

  end

  def get_initial_input() do
    {matrix_size,_} = IO.gets("Escreva o tamanho da grade: ") |> Integer.parse
    {qtd_iterations,_} = IO.gets("Escreva a quantidade de iterações: ") |> Integer.parse
    automatic = IO.gets("A matriz deve ser gerada aleatóriamente?:(y/n)")
    step = IO.gets("Deseja ver cada resultado de iteração?(y/n)")

    {
      matrix_size,
      qtd_iterations,
      (String.at(automatic, 0) == "y") or (String.at(automatic, 0) == "Y"),
      (String.at(step, 0) == "y") or (String.at(step, 0) == "Y")
    }
  end

  def initialize_matrix({size, _, automatic, _}) do

    if(automatic == true) do
      Matrex.new(size, size, fn -> round(Enum.random(0..2)) end)
    else
      get_matrix_input(size)
    end

  end

  def print_result_iterations(qtd_iterations, iterations_left) do

    result = qtd_iterations - iterations_left

    if iterations_left > 0 do
        IO.puts "Jogo estabilizou em #{result} iterações"
    else
      IO.puts "Jogo executou todas iterações"
    end

  end

  def get_matrix_input(size) do

    list_of_lists = get_list_of_lists(size, size-1, [])
    Matrex.new(list_of_lists)

  end

  def get_list_of_lists(size, amount, last_list) do

    if(amount >= 0) do

      list = get_a_list(size,amount)

      if check_corretude_of_list(list, size) do
        [list|get_list_of_lists(size, amount-1, list)] #retorna a list na cabeça com a chamada recursiva na tail
      else
        IO.puts("Lista está errada em tamanho ou em elementos. Digite novamente. ")
        get_list_of_lists(size, amount, last_list)
      end
    else
      []
    end

  end

  def get_a_list(size, amount) do

      IO.gets("Digite a #{size - amount}° linha da matriz(números separados por espaço): ")
      |> String.trim
      |> String.split
      |> Enum.map(&String.to_integer/1)

  end

  def check_corretude_of_list(list, size) do

      actual_size = length(list)

      if actual_size == size do
        check_corretude_of_list_rec(list)
      else
        false
      end

  end

  def check_corretude_of_list_rec(list) do

      case list do

        [] -> true
        [h|t] ->
          if check_corretude_of_list_element(h) do
            check_corretude_of_list_rec(t)
          else
            false
          end
      end

  end

  def check_corretude_of_list_element(element) do
    if is_integer(element) do
      if (0 <= element) and (element <= 2) do
        true
      else
        false
      end
    else
      false
    end

  end

end
