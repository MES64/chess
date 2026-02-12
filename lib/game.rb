# frozen_string_literal: true

# Game contains all the info to have a game of chess: Board, Players, result, etc.
# It contains methods to update the moveset, result, player turn, and board based on Player
# commands: #move, #force_draw, #offer_draw, #resign, #save, #exit
class Game
  attr_reader :board, :board_class

  def initialize(board:, board_class: nil)
    @board = board
    @board_class = board_class
  end

  def copy_board
    board_class.new(grid: board.grid, castling: board.castling, en_passant: board.en_passant,
                    letter_to_piece: board.letter_to_piece)
  end

  def update_board(move)
    board.update(move)
  end
end
