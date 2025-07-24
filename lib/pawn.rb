# frozen_string_literal: true

# Pawn contains information about a pawn chess piece
# It can be represented nicely as a string and it can generate it's move set on the board
class Pawn
  attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = color == :white ? '♙' : '♟'
  end

  def to_s
    icon
  end
end
