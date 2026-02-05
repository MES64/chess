# frozen_string_literal: true

# HumanPlayer takes user input from a human chess player, for:
# - making a move with #make_move
# - responding to a draw request with #accept_draw?
class HumanPlayer
  def draw_accepted?(user_input)
    user_input == 'y'
  end

  def valid_yes_no?(user_input)
    %w[y n].include?(user_input)
  end
end
