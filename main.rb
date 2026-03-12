# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/human_player'

board = Board.new
player = HumanPlayer.new

players = { white: player, black: player }
moveset = { white: [], black: [] }

game = Game.new(board:, moveset:, players:, current_player: :white, check: false, board_class: Board)

game.play
