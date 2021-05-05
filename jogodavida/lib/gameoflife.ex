defmodule Gameoflife do
  @moduledoc """
  Documentation for Gameoflife.
  """

  @doc """
  Initialize game.
  """
  def game(matrix, iterations) do

    game_recursive(matrix, iterations)

  end

  @doc """
  Calls itself recursively until iterations = 0. Calls the main game loop in each iteration.
  """
  def game_recursive(matrix, iterations) do
    if iterations > 0 do
      game_loop(matrix)
      |> stop_or_continue(matrix, iterations)
    else
      {matrix, iterations}
    end
  end

  def stop_or_continue(new_matrix, matrix, i) do
    if !is_matrix_equal(new_matrix, matrix) do
      game_recursive(new_matrix, i - 1)
    else
      {new_matrix, i}
    end
  end

  @doc """
  Calls the game_loop_x with initial value 1.
  """
  def game_loop(matrix) do
    game_loop_x(matrix, matrix, 1)
  end

  @doc """
  Calls itself recursively until x is greater then matrix size. Calls game_loop_y in each iteration.
  """
  def game_loop_x(newMatrix, matrix, x) do
    if x <= matrix[:rows] do

      game_loop_y(newMatrix, matrix, x, 1)
      |> game_loop_x(matrix, x+1)

    else
      newMatrix
    end
  end

  @doc """
  Calls itself recursively until y is greater then matrix size. Calls change cell in each iteration.
  """
  def game_loop_y(newMatrix, matrix, x, y) do
    if y <= matrix[:rows] do
      neighbors = adjacent(matrix, x, y)
      Matrex.at(matrix, x, y)
      |> change_cell(neighbors, newMatrix, x, y)
      |> game_loop_y(matrix, x, y+1)
    else
      newMatrix
    end
  end


  @doc """
  Changes the cell state if it's necessary.
  """
  def change_cell(cell, neighbors, matrix, x, y) do
    cond do
      reproduction_conditions(neighbors, cell) -> revive_cell(matrix, x, y)
      infection_conditions(neighbors, cell) -> zombify_cell(matrix, x, y)
      subpopulation_conditions(neighbors, cell) -> kill_cell(matrix, x, y)
      superpopulation_conditions(neighbors, cell) -> kill_cell(matrix, x, y)
      starvation_conditions(neighbors, cell) -> kill_cell(matrix, x, y)
      true -> matrix
    end
  end

  @doc """
  Calls adjacent_recursive to count
  how many cells of each state there is.
  It is a list with 3 elements, first position is the sum of Dead Cells (0),
  second position is the sum of Alive Cells (1), last one
  is from Zombie Cells (2)

  Eg: [2, 5, 1] -> 2 dead cells, 5 alive cells, 1 zombie cell.
  """
  def adjacent(matrix, line, column) do
    adjacentStates = [0, 0, 0]
    posList = mount_pos_tuple(line, column)
    adjacent_recursive(matrix, 0, posList, adjacentStates)
  end

  @doc """
  Mounts the positions of the neighbors of the cell in a tuple of tuples.
  """
  def mount_pos_tuple(line, column) do

    # tuple = {}
    # for x <- line-1..line+1 do
    #   for y <- column-1..column+1 do
    #     Tuple.append(tuple, {x, y})
    #   end
    # end |>
    # Tuple.delete_at(4)
    {
      {line-1, column-1},
      {line-1, column},
      {line-1, column+1},
      {line, column-1},
      {line, column+1},
      {line+1, column-1},
      {line+1, column},
      {line+1, column+1}
    }
  end

  @doc """
  Recursively calls itself, using the acc to accumulate in a list the sum of cells states in adjacent
  cells.
  """
  def adjacent_recursive(matrix, pos, posList, acc) do

    line = elem(elem(posList, pos), 0)
    column = elem(elem(posList, pos), 1)
    size = matrix[:rows]

    acc = if(line >= 1 and line <= size and column >= 1 and column <= size) do
      cell = Matrex.at(matrix, line, column)
      List.replace_at(acc, round(cell), Enum.at(acc, round(cell))+1)
    else
      acc
    end

    if pos < 7 do
      adjacent_recursive(matrix, pos+1, posList, acc)
    else
      acc
    end

  end

  def is_matrix_equal(matrix1, matrix2) do
    list_equals(Matrex.to_list(matrix1), Matrex.to_list(matrix2))
  end

  def list_equals(list1, list2) do

    if length(list1) != length(list2) do
      false
    end

    list_equals_rec(list1, list2)

  end

  def list_equals_rec([h1|t1], [h2|t2]) do

    if(h1 != h2) do
      false
    else
      list_equals_rec(t1, t2)
    end

  end

  def list_equals_rec([], []) do
    true
  end


  @doc """
  Verify if there is 3 alive cells in neighbors and the cell is dead.
  """
  def reproduction_conditions(neighbors, cell) do
    Enum.at(neighbors, 1) == 3 and cell == 0.0
  end

  @doc """
  Verify if there is at least 1 cell in neighbors that is a zombie and the current cell is alive.
  """
  def infection_conditions(neighbors, cell) do
    Enum.at(neighbors, 2) >= 1 and cell == 1.0
  end

  @doc """
  Verify if there is less than 2 alive and no zombies cells in neighbors and the current cell is alive.
  """
  def subpopulation_conditions(neighbors, cell) do
    Enum.at(neighbors, 1) < 2 and Enum.at(neighbors,2) == 0 and cell == 1.0
  end

  @doc """
  Verify if there more than 3 alive and no zombies cells in neighbors and the current cell is alive.
  """
  def superpopulation_conditions(neighbors, cell) do
    Enum.at(neighbors, 1) > 3 and Enum.at(neighbors,2) == 0 and cell == 1.0
  end

  @doc """
  Verify if there is no cell alive current cell is a zombie.
  """
  def starvation_conditions(neighbors, cell) do
    Enum.at(neighbors, 1) == 0 and cell == 2.0
  end

  @doc """
  Change cell state to dead
  """
  def kill_cell(matrix, x, y) do
    Matrex.set(matrix, x, y, 0)
  end

  @doc """
  Change cell state to alive
  """
  def revive_cell(matrix, x, y) do
    Matrex.set(matrix, x, y, 1)
  end

  @doc """
  Change cell state to zombie
  """
  def zombify_cell(matrix, x, y) do
    Matrex.set(matrix, x, y, 2)
  end



end
