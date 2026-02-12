# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

RSpec.describe Game do
  describe '#update_moveset' do
    # Incoming Command Message -> Test change in observable state

    # Test coverage:
    # - board (0, 1, n)
    # - current_moveset (0, n)
    # - Generally, first check if your move is valid, then add $, +, #
    # - Test no Kings, move leaving own King in danger, or giving: stalemate, check, and checkmate
    # - Maybe en passant and castling (should be like normal move)
    # - Test for valid & invalid castling: King in check at start, middle, end; or piece in the way
    # Note: Watch out for adding w at the end of castling strings!

    let(:board) { instance_double('Board') }

    context 'when the initial Game.moveset is empty' do
      subject(:game_moveset_empty) { described_class.new(board:, moveset: { white: [], black: [] }) }

      xit 'updates the Game.moveset to be empty when Board is empty' do
        allow(board).to receive(:moveset).and_return({ white: [], black: [] })
        game_moveset_empty.update_moveset
        actual_moveset = game_moveset_empty.moveset
        expect(actual_moveset).to match({ white: [], black: [] })
      end

      xit 'updates the Game.moveset = { white: ["a2-a3$", "a2-a4$"], black: [] } when Board only has a white pawn on a2' do
        allow(board).to receive(:moveset).and_return({ white: ['a2-a3'], black: [] })
        game_moveset_empty.update_moveset
        actual_moveset = game_moveset_empty.moveset
        expect(actual_moveset).to match({ white: ['a2-a3$'], black: [] })
      end
    end

    context 'when the initial Game.moveset is not empty' do
      subject(:game_moveset) { described_class.new(board:, moveset: { white: %w[Ng1xf3 e2-e4], black: %w[Rh8-h1+ Ke8-d7] }) }

      xit 'updates the Game.moveset = { white: ["a2-a3"], black: ["a7-a6"] } when Board.moveset = { white: ["a2-a3"], black: ["a7-a6"] }' do
        allow(board).to receive(:moveset).and_return({ white: ['a2-a3'], black: [] })
        game_moveset_empty.update_moveset
        actual_moveset = game_moveset_empty.moveset
        expect(actual_moveset).to match({ white: ['a2-a3$'], black: [] })
      end
    end
  end
end
