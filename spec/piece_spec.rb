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
end
