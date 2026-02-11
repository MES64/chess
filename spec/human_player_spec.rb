# frozen_string_literal: true

require_relative '../lib/human_player'
require_relative '../lib/game'

RSpec.describe HumanPlayer do
  # accept_draw? returns true/false depending on user input ('y'/'n')
  # Looping Script; test behavior of loop
  # Contains methods valid_yes_no? and draw_accepted?
  # Note: puts/gets gets sent to self and passed up to Kernel

  describe '#draw_accepted?' do
    # Incoming Query Message -> Test value returned

    subject(:human_player_draw) { described_class.new }

    it 'returns true for input "y"' do
      expect(human_player_draw).to be_draw_accepted('y')
    end

    it 'returns false for input "n"' do
      expect(human_player_draw).to_not be_draw_accepted('n')
    end
  end

  describe '#valid_yes_no?' do
    # Incoming Query Message -> Test value returned

    subject(:human_player_yes_no) { described_class.new }

    it 'returns true for input "y"' do
      expect(human_player_yes_no).to be_valid_yes_no('y')
    end

    it 'returns true for input "n"' do
      expect(human_player_yes_no).to be_valid_yes_no('n')
    end

    it 'returns false for random input "2n"' do
      expect(human_player_yes_no).to_not be_valid_yes_no('2n')
    end

    it 'returns false for random input " hi"' do
      expect(human_player_yes_no).to_not be_valid_yes_no(' hi')
    end
  end

  describe '#accept_draw?' do
    # Looping Script Method -> Test behavior of loop

    subject(:human_player_accept) { described_class.new }

    before do
      allow(human_player_accept).to receive(:puts)
      allow(human_player_accept).to receive(:user_input)
      allow(human_player_accept).to receive(:draw_accepted?)
    end

    it 'does not loop when user input is a valid "y"/"n"' do
      allow(human_player_accept).to receive(:valid_yes_no?).and_return(true)
      expect(human_player_accept).to_not receive(:puts).with('Invalid Input!')
      human_player_accept.accept_draw?(:white)
    end

    it 'loops once with an error message when user input is an invalid, then a valid "y"/"n"' do
      allow(human_player_accept).to receive(:valid_yes_no?).and_return(false, true)
      expect(human_player_accept).to receive(:puts).with('Invalid Input!').once
      human_player_accept.accept_draw?(:black)
    end

    it 'loops 3 times each with an error message when user input is invalid, invalid, invalid, valid "y"/"n"' do
      allow(human_player_accept).to receive(:valid_yes_no?).and_return(false, false, false, true)
      expect(human_player_accept).to receive(:puts).with('Invalid Input!').exactly(3).times
      human_player_accept.accept_draw?(:white)
    end
  end

  describe '#send_to_game' do
    # Outgoing Command Message -> Test message sent
    # Note: For error handling (NoMethodError, ArgumentError), I ignore this here since these are
    # well tested in standard Ruby, and also form an integration test. I shall therefore simply write a
    # try/catch in #make_move and test the overall effect later

    subject(:human_player_send) { described_class.new }

    let(:game) { instance_double('Game') }

    before do
      allow(game).to receive(:move)
      allow(game).to receive(:force_draw)
      allow(game).to receive(:offer_draw)
      allow(game).to receive(:resign)
      allow(game).to receive(:save)
      allow(game).to receive(:exit)
    end

    it 'sends move("a2-a3") to game for the command "move a2-a3"' do
      expect(game).to receive(:move).with('a2-a3')
      human_player_send.send_to_game(game, 'move a2-a3')
    end

    it 'sends move("O-O") to game for the command "move O-O"' do
      expect(game).to receive(:move).with('O-O')
      human_player_send.send_to_game(game, 'move O-O')
    end

    it 'sends move("Ra1-a8+") to game for the command "  move    Ra1-a8+   "' do
      expect(game).to receive(:move).with('Ra1-a8+')
      human_player_send.send_to_game(game, '  move    Ra1-a8+   ')
    end

    it 'sends force_draw("50-move") to game for the command "force_draw 50-move"' do
      expect(game).to receive(:force_draw).with('50-move')
      human_player_send.send_to_game(game, 'force_draw 50-move')
    end

    it 'sends offer_draw() to game for the command "offer_draw"' do
      expect(game).to receive(:offer_draw)
      human_player_send.send_to_game(game, 'offer_draw')
    end

    it 'sends resign() to game for the command "resign"' do
      expect(game).to receive(:resign)
      human_player_send.send_to_game(game, 'resign')
    end

    it 'sends save("file-name1") to game for the command "save file-name1"' do
      expect(game).to receive(:save).with('file-name1')
      human_player_send.send_to_game(game, 'save file-name1')
    end

    it 'sends exit() to game for the command "exit"' do
      expect(game).to receive(:exit)
      human_player_send.send_to_game(game, 'exit')
    end

    it 'sends exit("file-name1") to game for the command "exit file-name1"' do
      expect(game).to receive(:exit).with('file-name1')
      human_player_send.send_to_game(game, 'exit file-name1')
    end
  end
end
