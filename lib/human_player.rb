# frozen_string_literal: true

# HumanPlayer takes user input from a human chess player, for:
# - making a move with #make_move
# - responding to a draw request with #accept_draw?
class HumanPlayer
  def make_move(game)
    puts 'Enter a command'
    loop do
      done = send_to_game(game, user_input)
      return if done

      puts 'Enter a command again'
    rescue NoMethodError
      output_invalid_command
    rescue ArgumentError
      output_invalid_arguments
    end
  end

  def send_to_game(game, command)
    game.send(*command.split)
  end

  def draw_accepted?(user_input)
    user_input == 'y'
  end

  def valid_yes_no?(user_input)
    %w[y n].include?(user_input)
  end

  def accept_draw?(color)
    loop do
      puts "#{color}: Accept the draw? y/n"
      input = user_input
      return draw_accepted?(input) if valid_yes_no?(input)

      puts 'Invalid Input!'
    end
  end

  private

  def user_input
    gets.chomp
  end

  def output_invalid_command
    puts 'Invalid Command!'
    puts 'Enter a command again'
  end

  def output_invalid_arguments
    puts 'Invalid Arguments!'
    puts 'Enter a command again'
  end
end
