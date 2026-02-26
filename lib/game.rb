# frozen_string_literal: true

# Game contains all the info to have a game of chess: Board, Players, result, etc.
# It contains methods to update the moveset, result, player turn, and board based on Player
# commands: #move, #force_draw, #offer_draw, #resign, #save, #exit
class Game
  attr_reader :board, :board_class, :moveset

  def initialize(board: nil, moveset: nil, board_class: nil)
    @board = board
    @moveset = moveset
    @board_class = board_class
  end

  def update_moveset
    board_moveset = board.moveset
    moveset[:white] = validated_moveset(board_moveset, :white)
    moveset[:black] = validated_moveset(board_moveset, :black)
  end

  def next_board_info(move)
    next_board = copy_board
    update_given_board(next_board, move)
    { moveset: next_board.moveset, king_locations: next_board.king_locations }
  end

  def copy_board
    board_class.new(grid: board.grid, castling: board.castling, en_passant: board.en_passant,
                    letter_to_piece: board.letter_to_piece)
  end

  def update_given_board(given_board, move)
    given_board.update(move)
  end

  def update_board(move)
    board.update(move)
  end

  private

  def validated_moveset(board_moveset, color)
    moveset = []
    board_moveset[color].each do |move|
      next_board_info = next_board_info(input_move(move, color))
      next if move_invalid?(move, color, next_board_info, board_moveset)

      moveset << add_check(move, next_board_info, color)
    end
    moveset
  end

  def move_invalid?(move, color, next_board_info, board_moveset)
    return true if king_ends_in_check?(color, next_board_info)
    return false unless move.include?('O-O')

    next_moveset = next_board_info[:moveset]
    king_starts_in_check?(color, board_moveset) ||
      king_moves_through_check?(move, color, next_moveset[opposite_color(color)]) ||
      castling_blocked?(move, color)
  end

  def king_starts_in_check?(color, board_moveset)
    taking_king?(taken_color: color, taking_moveset: board_moveset[opposite_color(color)],
                 king_locations: board.king_locations)
  end

  def king_ends_in_check?(color, next_board_info)
    next_moveset = next_board_info[:moveset]
    next_king_locations = next_board_info[:king_locations]
    taking_king?(taken_color: color, taking_moveset: next_moveset[opposite_color(color)],
                 king_locations: next_king_locations)
  end

  def input_move(move, color)
    color_string = color == :white ? 'w' : 'b'
    move.include?('O-O') ? "#{move}#{color_string}" : move
  end

  def add_check(move, next_board_info, color)
    next_moveset = next_board_info[:moveset]
    next_king_locations = next_board_info[:king_locations]
    if taking_king?(taken_color: opposite_color(color), taking_moveset: next_moveset[color],
                    king_locations: next_king_locations)
      "#{move}+"
    else
      move
    end
  end

  def taking_king?(taken_color:, taking_moveset:, king_locations:)
    taking_moveset.any? { |move| move.include?("x#{king_locations[taken_color]}") }
  end

  def king_moves_through_check?(castling_move, color, opposite_moveset)
    file = castling_move == 'O-O' ? 'f' : 'd'
    rank = color == :white ? '1' : '8'
    castled_rook_location = "#{file}#{rank}"
    opposite_moveset.any? { |move| move.include?("x#{castled_rook_location}") }
  end

  def castling_blocked?(move, color)
    y_coord = color == :white ? 0 : 7
    x_coords = move == 'O-O' ? [5, 6] : [1, 2, 3]
    x_coords.any? { |x_coord| !board.empty_at?([x_coord, y_coord]) }
  end

  def opposite_color(color)
    color == :white ? :black : :white
  end
end
