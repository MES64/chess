# frozen_string_literal: true

require_relative '../lib/human_player'

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
end
