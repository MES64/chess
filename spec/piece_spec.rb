# frozen_string_literal: true

require_relative '../lib/piece'

RSpec.describe Piece do
  describe '#to_s' do
    # Incoming Query Message -> Test value returned

    context 'when the color is white' do
      let(:color) { :white }

      context 'when the letter is "R" for Rook' do
        subject(:white_rook_string) { described_class.new(color:, letter: 'R') }

        it 'returns "♖"' do
          expect(white_rook_string.to_s).to eql('♖')
        end
      end

      context 'when the letter is "N" for Knight' do
        subject(:white_knight_string) { described_class.new(color:, letter: 'N') }

        it 'returns "♘"' do
          expect(white_knight_string.to_s).to eql('♘')
        end
      end

      context 'when the letter is "B" for Bishop' do
        subject(:white_bishop_string) { described_class.new(color:, letter: 'B') }

        it 'returns "♗"' do
          expect(white_bishop_string.to_s).to eql('♗')
        end
      end

      context 'when the letter is "Q" for Queen' do
        subject(:white_queen_string) { described_class.new(color:, letter: 'Q') }

        it 'returns "♕"' do
          expect(white_queen_string.to_s).to eql('♕')
        end
      end

      context 'when the letter is "K" for King' do
        subject(:white_king_string) { described_class.new(color:, letter: 'K') }

        it 'returns "♔"' do
          expect(white_king_string.to_s).to eql('♔')
        end
      end
    end

    context 'when the color is black' do
      let(:color) { :black }

      context 'when the letter is "R" for Rook' do
        subject(:black_rook_string) { described_class.new(color:, letter: 'R') }

        it 'returns "♜"' do
          expect(black_rook_string.to_s).to eql('♜')
        end
      end

      context 'when the letter is "N" for Knight' do
        subject(:black_knight_string) { described_class.new(color:, letter: 'N') }

        it 'returns "♞"' do
          expect(black_knight_string.to_s).to eql('♞')
        end
      end

      context 'when the letter is "B" for Bishop' do
        subject(:black_bishop_string) { described_class.new(color:, letter: 'B') }

        it 'returns "♝"' do
          expect(black_bishop_string.to_s).to eql('♝')
        end
      end

      context 'when the letter is "Q" for Queen' do
        subject(:black_queen_string) { described_class.new(color:, letter: 'Q') }

        it 'returns "♛"' do
          expect(black_queen_string.to_s).to eql('♛')
        end
      end

      context 'when the letter is "K" for King' do
        subject(:black_king_string) { described_class.new(color:, letter: 'K') }

        it 'returns "♚"' do
          expect(black_king_string.to_s).to eql('♚')
        end
      end
    end
  end
end
