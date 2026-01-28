# frozen_string_literal: true

# Board contains the grid of chess pieces, along with en passant and castling information
# Methods: #print_board, #update, #moveset, #piece_at?, #empty_at?, #off_grid?
# castling: { white: ['O-O', 'O-O-O'], black: ['O-O', 'O-O-O'] }, en_passant: { white: [], black: ["c4xb3"] }
# I would ideally shorten this class, possibly by making a separate grid class
class Board
  attr_reader :grid, :castling, :letter_to_piece
  attr_accessor :en_passant

  def initialize(grid: nil, castling: nil, en_passant: nil, letter_to_piece: nil)
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

  def update(move)
    update_en_passant(move)
    update_castling(move)
    update_grid(move)
  end

  def update_grid(move)
    if move.include?('O-O')
      castle(move)
    else
      move_piece(move)
    end
  end

  def update_castling(move)
    # Matches for Rook moves, taking a Rook, King moves, and Castling moves
    castling[:white].delete('O-O-O') if move.match?(/Ra1|xa1|Ke1|O-O.*w/)
    castling[:white].delete('O-O') if move.match?(/Rh1|xh1|Ke1|O-O.*w/)
    castling[:black].delete('O-O-O') if move.match?(/Ra8|xa8|Ke8|O-O.*b/)
    castling[:black].delete('O-O') if move.match?(/Rh8|xh8|Ke8|O-O.*b/)
  end

  def update_en_passant(move)
    self.en_passant = { white: [], black: [] }
    add_en_passant(move) if pawn_moved_forward_two?(move)
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

  def add_en_passant(move)
    left_coord = left_coord_of_moved_pawn(move)
    right_coord = right_coord_of_moved_pawn(move)
    color = white_pawn_moved_forward_two?(move) ? :black : :white
    # Piece can be sent en_passant messages too, and always return []
    en_passant[color] += grid_at(left_coord).en_passant_right(left_coord) if piece_at?(left_coord, color)
    en_passant[color] += grid_at(right_coord).en_passant_left(right_coord) if piece_at?(right_coord, color)
  end

  def left_coord_of_moved_pawn(move)
    finish_coord = finish_coord(move)
    [finish_coord[0] - 1, finish_coord[1]]
  end

  def right_coord_of_moved_pawn(move)
    finish_coord = finish_coord(move)
    [finish_coord[0] + 1, finish_coord[1]]
  end

  def pawn_moved_forward_two?(move)
    move.match?(/^[a-h](2|7)-[a-h](4|5)/)
  end

  def white_pawn_moved_forward_two?(move)
    move.match?(/^[a-h]2-[a-h]4/)
  end

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
