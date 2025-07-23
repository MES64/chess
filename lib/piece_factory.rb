# frozen_string_literal: true

require_relative 'piece'

# Piece Factory creates valid Chess pieces according to their given specification, throwing an
# error if the arguments are invalid.
# This assumes a fixed board dimension of 8x8, leaving any possible new features needing
# different dimensions for future refactorings.
class PieceFactory
  def create_piece(color:, letter:)
    raise 'Invalid color!' unless %i[white black].include?(color)

    moveset = if letter == 'R'
                [[-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                 [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                 [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                 [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
              elsif letter == 'N'
                [[-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2]]
              elsif letter == 'B'
                [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                 [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                 [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                 [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
              elsif letter == 'Q'
                [[-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                 [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                 [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                 [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                 [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                 [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                 [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                 [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
              elsif letter == 'K'
                [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [1, -1], [-1, 1], [1, 1]]
              else
                color == :white ? [[0, 1], [0, 2], [-1, 1], [1, 1]] : [[0, -1], [0, -2], [-1, -1], [1, -1]]
              end

    icon = if letter == 'R'
             color == :white ? '♖' : '♜'
           elsif letter == 'N'
             color == :white ? '♘' : '♞'
           elsif letter == 'B'
             color == :white ? '♗' : '♝'
           elsif letter == 'Q'
             color == :white ? '♕' : '♛'
           elsif letter == 'K'
             color == :white ? '♔' : '♚'
           else
             color == :white ? '♙' : '♟'
           end

    Piece.new(color:, letter:, icon:, moveset:)
  end
end
