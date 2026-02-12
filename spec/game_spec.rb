# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

RSpec.describe Game do
  describe '#copy_board' do
    # Outgoing Command Message -> Test message sent

    let(:board_class) { instance_double('Class') }

    before do
      allow(board_class).to receive(:new)
    end

    context 'given a random board' do
      let(:board) { instance_double('Board') }
      let(:grid) do
        [%w[a3 b3 c3],
         %w[a2 b2 c2],
         %w[a1 b1 c1]]
      end
      let(:castling) { { white: ['O-O', 'O-O-O'], black: ['O-O-O'] } }
      let(:en_passant) { { white: ['move'], black: [] } }
      let(:letter_to_piece) do
        { white: { 'B' => 'WHITE_BISHOP', 'N' => 'WHITE_KNIGHT' },
          black: { 'B' => 'BLACK_BISHOP', 'N' => 'BLACK_KNIGHT' } }
      end

      before do
        allow(board).to receive(:grid).and_return(grid)
        allow(board).to receive(:castling).and_return(castling)
        allow(board).to receive(:en_passant).and_return(en_passant)
        allow(board).to receive(:letter_to_piece).and_return(letter_to_piece)
      end

      subject(:game_copy) { described_class.new(board:, board_class:) }

      it 'sends new to the Board class with the same instance variable values as the original board' do
        expect(board_class).to receive(:new).with(grid:, castling:, en_passant:, letter_to_piece:)
        game_copy.copy_board
      end
    end

    context 'given a different random board' do
      let(:board) { instance_double('Board') }
      let(:grid) do
        [%w[d3 e3 f3],
         %w[d2 e2 f2],
         %w[d1 e1 f1]]
      end
      let(:castling) { { white: ['O-O-O'], black: [] } }
      let(:en_passant) { { white: [], black: [] } }
      let(:letter_to_piece) do
        { white: { 'R' => 'WHITE_ROOK', 'Q' => 'WHITE_QUEEN' },
          black: { 'R' => 'BLACK_ROOK', 'Q' => 'BLACK_QUEEN' } }
      end

      before do
        allow(board).to receive(:grid).and_return(grid)
        allow(board).to receive(:castling).and_return(castling)
        allow(board).to receive(:en_passant).and_return(en_passant)
        allow(board).to receive(:letter_to_piece).and_return(letter_to_piece)
      end

      subject(:game_copy) { described_class.new(board:, board_class:) }

      it 'sends new to the Board class with the same instance variable values as the original board' do
        expect(board_class).to receive(:new).with(grid:, castling:, en_passant:, letter_to_piece:)
        game_copy.copy_board
      end
    end
  end

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
