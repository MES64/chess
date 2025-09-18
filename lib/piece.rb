# frozen_string_literal: true

# Piece contains information about a chess piece: Rook, Knight, Bishop, Queen, King
# It can be represented nicely as a string and it can generate it's move set on the board
class Piece
  attr_reader :color, :letter, :icon, :limit, :base_moveset

  ICONS = {
    'R' => '♜',
    'N' => '♞',
    'B' => '♝',
    'Q' => '♛',
    'K' => '♚'
  }.freeze

  LIMITS = {
    'R' => -1,
    'N' => 1,
    'B' => -1,
    'Q' => -1,
    'K' => 1
  }.freeze

  BASE_MOVESETS = {
    'R' => [[-1, 0], [1, 0], [0, -1], [0, 1]],
    'N' => [[-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2]],
    'B' => [[-1, -1], [-1, 1], [1, -1], [1, 1]],
    'Q' => [[-1, -1], [-1, 1], [1, -1], [1, 1], [-1, 0], [1, 0], [0, -1], [0, 1]],
    'K' => [[-1, -1], [-1, 1], [1, -1], [1, 1], [-1, 0], [1, 0], [0, -1], [0, 1]]
  }.freeze

  def initialize(color:, letter:)
    @color = color
    @letter = letter
    @icon = ICONS[letter]
    @limit = LIMITS[letter]
    @base_moveset = BASE_MOVESETS[letter]
  end

  def moveset_from(coord:, board:)
    moveset = []
    base_moveset.each { |change| moveset += moveset_along_direction(change:, coord:, board:) }
    moveset
  end

  def to_s
    icon
  end

  private

  def moveset_along_direction(change:, coord:, board:)
    moveset = []
    moveset << move(board, coord, change, moveset.length) until blocked?(board, coord, change, moveset.length)
    moveset
  end

  def blocked?(board, coord, change, move_count)
    current_position = position(coord, change, move_count)
    previous_position = position(coord, change, move_count - 1)

    move_count == limit ||
      board.off_grid?(current_position) ||
      blocked_own_piece?(board, current_position) ||
      just_took_piece?(board, previous_position)
  end

  def blocked_own_piece?(board, current_position)
    board.piece_at?(current_position, color)
  end

  def just_took_piece?(board, previous_position)
    board.piece_at?(previous_position, opposite_color)
  end

  def position(coord, change, move_count)
    file_change = change[0] * (move_count + 1)
    rank_change = change[1] * (move_count + 1)

    [coord[0] + file_change, coord[1] + rank_change]
  end

  def move(board, coord, change, move_count)
    current_position = position(coord, change, move_count)
    separator = board.piece_at?(current_position, opposite_color) ? 'x' : '-'

    "#{letter}#{file(coord)}#{rank(coord)}#{separator}#{file(current_position)}#{rank(current_position)}"
  end

  def file(coord)
    number_to_letter = %w[a b c d e f g h]

    number_to_letter[coord[0]]
  end

  def rank(coord)
    coord[1] + 1
  end

  def opposite_color
    color == :white ? :black : :white
  end
end
