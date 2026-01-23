# frozen_string_literal: true

# Pawn contains information about a pawn chess piece
# It can be represented nicely as a string and it can generate it's move set on the board
class Pawn
  attr_reader :color, :print_color

  PRINT_COLORS = {
    white: '97',
    black: '30'
  }.freeze

  def initialize(color)
    @color = color
    @print_color = PRINT_COLORS[color]
  end

  def moveset_from(coord:, board:)
    moveset = []
    moves(coord, board).each { |move| moveset += moves_to_s(coord, move, '-') }
    takes(coord, board).each { |take| moveset += moves_to_s(coord, take, 'x') }
    moveset
  end

  def en_passant_left(coord)
    [move_to_s(coord, take_left(coord), 'x')]
  end

  def en_passant_right(coord)
    [move_to_s(coord, take_right(coord), 'x')]
  end

  def to_s
    '♟'
  end

  private

  def moves(coord, board)
    moves = []
    moves << forward_one(coord) if board.empty_at?(forward_one(coord))
    moves << forward_two(coord) if forward_two_available?(coord) && forward_two_clear?(coord, board)
    moves
  end

  def takes(coord, board)
    takes = []
    takes << take_left(coord) if board.piece_at?(take_left(coord), opposite_color)
    takes << take_right(coord) if board.piece_at?(take_right(coord), opposite_color)
    takes
  end

  def forward_two_available?(coord)
    (coord[1] == 1 && color == :white) || (coord[1] == 6 && color == :black)
  end

  def forward_two_clear?(coord, board)
    board.empty_at?(forward_two(coord)) && board.empty_at?(forward_one(coord))
  end

  def opposite_color
    color == :white ? :black : :white
  end

  def forward_one(coord)
    color == :white ? [coord[0], coord[1] + 1] : [coord[0], coord[1] - 1]
  end

  def forward_two(coord)
    color == :white ? [coord[0], coord[1] + 2] : [coord[0], coord[1] - 2]
  end

  def take_left(coord)
    forward = color == :white ? coord[1] + 1 : coord[1] - 1
    [coord[0] - 1, forward]
  end

  def take_right(coord)
    forward = color == :white ? coord[1] + 1 : coord[1] - 1
    [coord[0] + 1, forward]
  end

  def moves_to_s(coord, move, separator)
    promotion_pieces = [0, 7].include?(move[1]) ? %w[=Q =R =N =B] : ['']
    promotion_pieces.map { |piece| "#{move_to_s(coord, move, separator)}#{piece}" }
  end

  def move_to_s(coord, move, separator)
    "#{coord_to_s(coord)}#{separator}#{coord_to_s(move)}"
  end

  def coord_to_s(coord)
    number_to_letter = %w[a b c d e f g h]
    "#{number_to_letter[coord[0]]}#{coord[1] + 1}"
  end
end
