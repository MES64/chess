# frozen_string_literal: true

require_relative '../lib/pawn'

RSpec.describe Pawn do
  describe '#to_s' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_string) { described_class.new(:white) }

      it 'returns "♙"' do
        expect(pawn_white_string.to_s).to eql('♙')
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_string) { described_class.new(:black) }

      it 'returns "♟"' do
        expect(pawn_black_string.to_s).to eql('♟')
      end
    end
  end
end
