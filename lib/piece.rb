# frozen_string_literal: true

# Piece contains information about a chess piece: Rook, Knight, Bishop, Queen, King
# It can be represented nicely as a string and it can generate it's move set on the board
class Piece
  attr_reader :color, :letter

  ICONS = {
    'R' => { white: '♖', black: '♜' },
    'N' => { white: '♘', black: '♞' },
    'B' => { white: '♗', black: '♝' },
    'Q' => { white: '♕', black: '♛' },
    'K' => { white: '♔', black: '♚' }
  }.freeze

  def initialize(color:, letter:)
    @color = color
    @letter = letter
  end

  def to_s
    ICONS[letter][color]
  end
end
