# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/human_player'
require_relative 'lib/computer_player'

board = Board.new
human_player = HumanPlayer.new
computer_player = ComputerPlayer.new

players = { white: human_player, black: computer_player }
moveset = { white: [], black: [] }

game = Game.new(board:, moveset:, players:, current_player: :white, check: false, board_class: Board)

game.play
