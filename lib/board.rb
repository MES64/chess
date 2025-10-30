# frozen_string_literal: true

# Board contains the grid of chess pieces, along with en passant and castling information
# Methods: #print_board, #update, #moveset, #piece_at?, #empty_at?, #off_grid?
# castling: { white: ['O-O', 'O-O-O'], black: ['O-O', 'O-O-O'] }, en_passant: []
class Board
  attr_reader :grid, :castling, :en_passant

  def initialize(grid:, castling: nil, en_passant: nil)
    @grid = grid
    @castling = castling
    @en_passant = en_passant
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

  def moveset
    { white: color_moveset(:white), black: color_moveset(:black) }
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

  def color_moveset(color)
    pieces_moveset(color) + castling[color] + en_passant[color]
  end

  def pieces_moveset(color)
    moveset = []
    coords.each { |coord| moveset += piece_moveset(coord) if piece_at?(coord, color) }
    moveset
  end

  def piece_moveset(coord)
    grid_at(coord).moveset_from(coord:, board: self)
  end

  def coords
    rows = (0...grid.length)
    columns = (0...grid[0].length)

    coords = []
    rows.each { |row| coords += columns.map { |column| [row, column] } }
    coords
  end

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
