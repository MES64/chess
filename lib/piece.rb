# frozen_string_literal: true

# Piece appearance in terminal
# 30 sets font color to black (otherwise it is white)
# "\e[30;104m#{'♔ '}\e[0m" = White on Light
# "\e[30;104m#{'♚ '}\e[0m" = Black on Light
# "\e[30;44m#{'♙ '}\e[0m" = White on Dark
# "\e[30;44m#{'♚ '}\e[0m" = Black on Dark

# Piece objects contain information about the chess piece and can generate the always-available
# moves given a coordinate on the grid (assuming no boundaries on the board)
class Piece
  attr_reader :icon

  def initialize(icon:)
    @icon = icon
  end

  def to_s
    icon
  end
end
