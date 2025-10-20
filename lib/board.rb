# frozen_string_literal: true

# Board contains the grid of chess pieces, along with en passant and castling information
# Methods: #print_board, #update, #moveset, #piece_at?, #empty_at?, #off_grid?
class Board
  attr_reader :grid

  def initialize(grid:)
    @grid = grid
  end

  def off_grid?(coord)
    grid_at(coord).nil?
  end

  def empty_at?(coord)
    grid_at(coord) == ' '
  end

  def piece_at?(coord, color_wanted)
    return false if empty_at?(coord) || off_grid?(coord)

    grid_at(coord).color == color_wanted
  end

  def print_board(color:)
    letters = { white: 'a b c d e f g h', black: 'h g f e d c b a' }[color]

    rows = grid.each_with_index.map do |row, index|
      "#{grid.length - index} #{print_row(row, index, color)}\e[0m\n"
    end
    board_string = color == :white ? rows.join : rows.reverse.join
    "#{board_string}  #{letters}\n"
  end

  private

  def grid_at(coord)
    row = grid.length - 1 - coord[1]
    column = coord[0]
    return if row.negative? || column.negative?

    grid.dig(row, column)
  end

  def print_row(row, index, color)
    square_color = index.even? ? '44' : '104'
    squares = row.map do |piece|
      square_color = square_color == '104' ? '44' : '104'
      print_square(piece, square_color)
    end
    color == :white ? squares.join : squares.reverse.join
  end

  def print_square(piece, square_color)
    "\e[#{print_color(piece)}#{square_color}m#{piece} "
  end

  def print_color(piece)
    piece == ' ' ? '' : "#{piece.print_color};"
  end
end
