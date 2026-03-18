# frozen_string_literal: true

# ComputerPlayer decides the move to be taken by the PC, for:
# - making a move with #make_move
# - responding to a draw request with #accept_draw?
class ComputerPlayer
  attr_reader :type
  attr_accessor :turn_count

  def initialize
    @type = 'computer'
    @turn_count = 0
  end

  def make_move(game)
    if turn_count == 200
      draw_accepted = send_offer_draw(game)
      return if draw_accepted
    end
    send_move(game)
    self.turn_count += 1
  end

  def accept_draw?(color)
    puts "#{color}: Accept the draw? y/n"
    puts 'y'
    true
  end

  private

  def send_offer_draw(game)
    puts 'Computer Move'
    puts 'offer_draw'
    game.offer_draw
  end

  def send_move(game)
    move = find_move(game)
    puts 'Computer Move'
    puts "move #{move}"
    game.move(move)
  end

  def find_move(game)
    my_color = game.current_player
    my_moveset = game.moveset[my_color]
    my_moveset.sample
  end
end
