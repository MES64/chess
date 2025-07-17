# frozen_string_literal: true

require_relative '../lib/piece'

RSpec.describe Piece do
  describe '#to_s' do
    # Incoming Query Message -> Test value returned

    context 'for white king' do
      subject(:piece_string_white_king) { described_class.new(icon: '♔') }

      it 'returns white king string' do
        expect(piece_string_white_king.to_s).to eql('♔')
      end
    end

    context 'for black king' do
      subject(:piece_string_black_king) { described_class.new(icon: '♚') }

      it 'returns black king string' do
        expect(piece_string_black_king.to_s).to eq('♚')
      end
    end
  end

  describe '#moveset_from' do
    # Incoming Query Message -> Test value returned

    context 'for the knight moveset' do
      let(:moveset_knight) { [[-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2]] }
      subject(:piece_moveset_knight) { described_class.new(moveset: moveset_knight) }

      it 'returns correct moveset from coordinate [0, 0]' do
        expected_moveset = [[-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2]]
        actual_moveset = piece_moveset_knight.moveset_from([0, 0])
        expect(actual_moveset).to eql(expected_moveset)
      end

      it 'returns correct moveset from coordinate [5, 6]' do
        expected_moveset = [[4, 4], [6, 4], [3, 5], [7, 5], [3, 7], [7, 7], [4, 8], [6, 8]]
        actual_moveset = piece_moveset_knight.moveset_from([5, 6])
        expect(actual_moveset).to eql(expected_moveset)
      end
    end

    context 'for the King moveset' do
      let(:moveset_king) { [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]] }
      subject(:piece_moveset_king) { described_class.new(moveset: moveset_king) }

      it 'returns correct moveset from coordinate [0, 0]' do
        expected_moveset = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
        actual_moveset = piece_moveset_king.moveset_from([0, 0])
        expect(actual_moveset).to eql(expected_moveset)
      end

      it 'returns correct moveset from coordinate [5, 6]' do
        expected_moveset = [[4, 5], [5, 5], [6, 5], [4, 6], [6, 6], [4, 7], [5, 7], [6, 7]]
        actual_moveset = piece_moveset_king.moveset_from([5, 6])
        expect(actual_moveset).to eql(expected_moveset)
      end
    end
  end
end
