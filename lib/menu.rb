# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

# Menu is responsible for the user setting up a game, by either:
# - Choosing whether white/black is a human player or a computer player in a new game
# - Loading a previously saved game
# Menu can also delete any saved game and exit the program
class Menu
  def start
    loop { enter_command }
  end

  private

  def enter_command
    puts
    puts '----- Welcome to Chess! -----'
    puts 'Enter a command'
    loop do
      done = send_to_menu(user_input)
      return if done

      puts 'Enter a command again'
    rescue ArgumentError
      output_invalid_arguments
    end
  end

  def send_to_menu(command)
    message_with_args = command.split
    message = message_with_args[0]
    send(*message_with_args) if %w[play load delete exit].include?(message)
  end

  def user_input
    gets.chomp
  end

  def output_invalid_arguments
    puts 'Invalid Arguments!'
    puts 'Enter a command again'
  end

  def play(white_player, black_player)
    player_type = { 'human' => HumanPlayer.new, 'computer' => ComputerPlayer.new }
    players = { white: player_type[white_player], black: player_type[black_player] }

    return false unless players[:white] && players[:black]

    board = Board.new
    moveset = { white: [], black: [] }

    game = Game.new(board:, moveset:, players:, current_player: :white, check: false, board_class: Board)

    game.play
    true
  end

  def load(file_name)
  end

  def delete(file_name)
  end
end
