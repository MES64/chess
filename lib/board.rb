# frozen_string_literal: true

# Board contains the grid of chess pieces, along with en passant and castling information
# Methods: #print_board, #update, #moveset, #piece_at?, #empty_at?, #off_grid?
# castling: { white: ['O-O', 'O-O-O'], black: ['O-O', 'O-O-O'] }, en_passant: []
class Board
  attr_reader :grid, :castling, :en_passant, :letter_to_piece

  def initialize(grid:, castling: nil, en_passant: nil, letter_to_piece: nil)
    @grid = grid
    @castling = castling
    @en_passant = en_passant
    @letter_to_piece = letter_to_piece
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

  def update_grid(move)
    if move.include?('O-O')
      castle(move)
    else
      move_piece(move)
    end
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

  def castle(move)
    rank = move.end_with?('w') ? '1' : '8'
    if move.include?('O-O-O')
      move_piece("Ke#{rank}-c#{rank}")
      move_piece("Ra#{rank}-d#{rank}")
    elsif move.include?('O-O')
      move_piece("Ke#{rank}-g#{rank}")
      move_piece("Rh#{rank}-f#{rank}")
    end
  end

  def move_piece(move)
    start_coord = start_coord(move)
    finish_coord = finish_coord(move)
    grid_put(' ', [finish_coord[0], start_coord[1]]) if en_passant?(move, finish_coord)
    grid_put(piece_moved(start_coord, move), finish_coord)
    grid_put(' ', start_coord)
  end

  def letter_to_number
    { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
  end

  def start_coord(move)
    # E.g. start = 'a1' from 'Qa1-h8+'
    start = move.include?('x') ? move.split('x')[0][-2..] : move.split('-')[0][-2..]
    [letter_to_number[start[0]], start[1].to_i - 1]
  end

  def finish_coord(move)
    # E.g. finish = 'h8+' from 'Qa1-h8+'
    finish = move.include?('x') ? move.split('x')[1] : move.split('-')[1]
    [letter_to_number[finish[0]], finish[1].to_i - 1]
  end

  def en_passant?(move, finish_coord)
    move.include?('x') && empty_at?(finish_coord)
  end

  def piece_moved(start_coord, move)
    promotion = move.split('=')[1]
    promotion ? letter_to_piece[grid_at(start_coord).color][promotion[0]] : grid_at(start_coord)
  end

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

  def grid_put(piece, coord)
    row = grid.length - 1 - coord[1]
    column = coord[0]
    grid[row][column] = piece
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
