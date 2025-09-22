# frozen_string_literal: true

require_relative '../lib/piece'
require_relative '../lib/board'

RSpec.describe Piece do
  describe '#print_color' do
    # Incoming Query Message -> Test value returned

    context 'when the color is white' do
      subject(:piece_white_color) { described_class.new(color: :white, letter: 'R') }

      it 'returns "97"' do
        expect(piece_white_color.print_color).to eql('97')
      end
    end

    context 'when the color is black' do
      subject(:piece_black_color) { described_class.new(color: :black, letter: 'Q') }

      it 'returns "30"' do
        expect(piece_black_color.print_color).to eql('30')
      end
    end
  end

  describe '#to_s' do
    # Incoming Query Message -> Test value returned

    context 'when the color is white' do
      let(:color) { :white }

      context 'when the letter is "R" for Rook' do
        subject(:white_rook_string) { described_class.new(color:, letter: 'R') }

        it 'returns "♜"' do
          expect(white_rook_string.to_s).to eql('♜')
        end
      end

      context 'when the letter is "N" for Knight' do
        subject(:white_knight_string) { described_class.new(color:, letter: 'N') }

        it 'returns "♞"' do
          expect(white_knight_string.to_s).to eql('♞')
        end
      end

      context 'when the letter is "B" for Bishop' do
        subject(:white_bishop_string) { described_class.new(color:, letter: 'B') }

        it 'returns "♝"' do
          expect(white_bishop_string.to_s).to eql('♝')
        end
      end

      context 'when the letter is "Q" for Queen' do
        subject(:white_queen_string) { described_class.new(color:, letter: 'Q') }

        it 'returns "♛"' do
          expect(white_queen_string.to_s).to eql('♛')
        end
      end

      context 'when the letter is "K" for King' do
        subject(:white_king_string) { described_class.new(color:, letter: 'K') }

        it 'returns "♚"' do
          expect(white_king_string.to_s).to eql('♚')
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

  describe '#moveset_from' do
    # Incoming Query Message -> Test value returned

    context 'when the color is white' do
      let(:color) { :white }

      context 'when the board is empty' do
        let(:board_empty) { instance_double('Board') }

        before do
          allow(board_empty).to receive(:off_grid?).and_return(true)
          (0..7).each do |file|
            (0..7).each do |rank|
              allow(board_empty).to receive(:off_grid?).with([file, rank]).and_return(false)
            end
          end

          allow(board_empty).to receive(:piece_at?).and_return(false)
        end

        context 'when the letter is "R" for Rook' do
          subject(:white_rook_moveset) { described_class.new(color:, letter: 'R') }

          it 'returns moveset containing only arms ending "Rd4-a4", "Rd4-h4", "Rd4-d1", "Rd4-d8" given coordinate d4/[3, 3]' do
            moveset = white_rook_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Rd4-a4', 'Rd4-b4', 'Rd4-c4',
                                               'Rd4-e4', 'Rd4-f4', 'Rd4-g4', 'Rd4-h4',
                                               'Rd4-d1', 'Rd4-d2', 'Rd4-d3',
                                               'Rd4-d5', 'Rd4-d6', 'Rd4-d7', 'Rd4-d8')
          end

          it 'returns moveset containing only arms ending "Rh2-a2", "Rh2-h1", "Rh2-h8" given coordinate h2/[7, 1]' do
            moveset = white_rook_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Rh2-a2', 'Rh2-b2', 'Rh2-c2', 'Rh2-d2', 'Rh2-e2', 'Rh2-f2', 'Rh2-g2',
                                               'Rh2-h1',
                                               'Rh2-h3', 'Rh2-h4', 'Rh2-h5', 'Rh2-h6', 'Rh2-h7', 'Rh2-h8')
          end
        end

        context 'when the letter is "B" for Bishop' do
          subject(:white_bishop_moveset) { described_class.new(color:, letter: 'B') }

          it 'returns moveset containing only arms ending "Bd4-a1", "Bd4-h8", "Bd4-a7", "Bd4-g1" given coordinate d4/[3, 3]' do
            moveset = white_bishop_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Bd4-c3', 'Bd4-b2', 'Bd4-a1',
                                               'Bd4-e5', 'Bd4-f6', 'Bd4-g7', 'Bd4-h8',
                                               'Bd4-c5', 'Bd4-b6', 'Bd4-a7',
                                               'Bd4-e3', 'Bd4-f2', 'Bd4-g1')
          end

          it 'returns moveset containing only arms ending "Bh2-g1", "Bh2-b8" given coordinate h2/[7, 1]' do
            moveset = white_bishop_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Bh2-g1',
                                               'Bh2-g3', 'Bh2-f4', 'Bh2-e5', 'Bh2-d6', 'Bh2-c7', 'Bh2-b8')
          end
        end

        context 'when the letter is "Q" for Queen' do
          subject(:white_queen_moveset) { described_class.new(color:, letter: 'Q') }

          it 'returns moveset containing only arms ending "Qd4-a1", "Qd4-h8", "Qd4-a7", "Qd4-g1", "Qd4-a4", "Qd4-h4", "Qd4-d1", "Qd4-d8" given coordinate d4/[3, 3]' do
            moveset = white_queen_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Qd4-c3', 'Qd4-b2', 'Qd4-a1',
                                               'Qd4-e5', 'Qd4-f6', 'Qd4-g7', 'Qd4-h8',
                                               'Qd4-c5', 'Qd4-b6', 'Qd4-a7',
                                               'Qd4-e3', 'Qd4-f2', 'Qd4-g1',
                                               'Qd4-a4', 'Qd4-b4', 'Qd4-c4',
                                               'Qd4-e4', 'Qd4-f4', 'Qd4-g4', 'Qd4-h4',
                                               'Qd4-d1', 'Qd4-d2', 'Qd4-d3',
                                               'Qd4-d5', 'Qd4-d6', 'Qd4-d7', 'Qd4-d8')
          end

          it 'returns moveset containing only arms ending "Qh2-g1", "Qh2-b8", "Qh2-a2", "Qh2-h1", "Qh2-h8" given coordinate h2/[7, 1]' do
            moveset = white_queen_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Qh2-g1',
                                               'Qh2-g3', 'Qh2-f4', 'Qh2-e5', 'Qh2-d6', 'Qh2-c7', 'Qh2-b8',
                                               'Qh2-a2', 'Qh2-b2', 'Qh2-c2', 'Qh2-d2', 'Qh2-e2', 'Qh2-f2', 'Qh2-g2',
                                               'Qh2-h1',
                                               'Qh2-h3', 'Qh2-h4', 'Qh2-h5', 'Qh2-h6', 'Qh2-h7', 'Qh2-h8')
          end
        end

        context 'when the letter is "K" fo King' do
          subject(:white_king_moveset) { described_class.new(color:, letter: 'K') }

          it 'returns moveset containing exactly "Kd4-x" with x = c3, e5, c5, e3, c4, e4, d3, d5 given coordinate d4/[3, 3]' do
            moveset = white_king_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Kd4-c3', 'Kd4-e5', 'Kd4-c5', 'Kd4-e3', 'Kd4-c4', 'Kd4-e4', 'Kd4-d3', 'Kd4-d5')
          end

          it 'returns moveset containing exactly "Kh2-x" with x = g1, g3, g2, h1, h3 given coordinate h2/[7, 1]' do
            moveset = white_king_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Kh2-g1', 'Kh2-g3', 'Kh2-g2', 'Kh2-h1', 'Kh2-h3')
          end
        end

        context 'when the letter is "N" for Knight' do
          subject(:white_knight_moveset) { described_class.new(color:, letter: 'N') }

          it 'returns moveset containing exactly "Nd4-x" with x = c2, e2, b3, f3, b5, f5, c6, e6 given coordinate d4/[3, 3]' do
            moveset = white_knight_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Nd4-c2', 'Nd4-e2', 'Nd4-b3', 'Nd4-f3', 'Nd4-b5', 'Nd4-f5', 'Nd4-c6', 'Nd4-e6')
          end

          it 'returns moveset containing exactly "Nh2-x" with x = f1, f3, g4 given coordinate h2/[7, 1]' do
            moveset = white_knight_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Nh2-f1', 'Nh2-f3', 'Nh2-g4')
          end
        end
      end

      context 'when the board is set up to block all piece movesets with both black and white pieces' do
        let(:board_blocking) { instance_double('Board') }

        before do
          allow(board_blocking).to receive(:off_grid?).and_return(true)
          (0..7).each do |file|
            (0..7).each do |rank|
              allow(board_blocking).to receive(:off_grid?).with([file, rank]).and_return(false)
            end
          end
        end

        # Board:
        # W = White, B = Black, X = Test
        # 8: . . . . . . . B
        # 7: . . . . . . . .
        # 6: . . . W . . . .
        # 5: . . B . . . . .
        # 4: . . W X . . B .
        # 3: . . . . . W . .
        # 2: . . B . . W . X
        # 1: . . . . . . B W
        #    A B C D E F G H

        before do
          allow(board_blocking).to receive(:piece_at?).and_return(false)

          allow(board_blocking).to receive(:piece_at?).with([7, 7], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([3, 5], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 4], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 3], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([6, 3], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([5, 2], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 1], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([5, 1], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([6, 0], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([7, 0], :white).and_return(true)
        end

        context 'when the letter is "R" for Rook' do
          subject(:white_rook_moveset) { described_class.new(color:, letter: 'R') }

          it 'returns moveset containing only arms ending "Rd4xg4", "Rd4-d1", "Rd4-d5" given coordinate d4/[3, 3]' do
            moveset = white_rook_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Rd4-e4', 'Rd4-f4', 'Rd4xg4',
                                               'Rd4-d3', 'Rd4-d2', 'Rd4-d1',
                                               'Rd4-d5')
          end

          it 'returns moveset containing only arms ending "Rh2-g2", "Rh2xh8" given coordinate h2/[7, 1]' do
            moveset = white_rook_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Rh2-g2',
                                               'Rh2-h3', 'Rh2-h4', 'Rh2-h5', 'Rh2-h6', 'Rh2-h7', 'Rh2xh8')
          end
        end

        context 'when the letter is "B" for Bishop' do
          subject(:white_bishop_moveset) { described_class.new(color:, letter: 'B') }

          it 'returns moveset containing only arms ending "Bd4-a1", "Bd4xh8", "Bd4xc5", "Bd4-e3" given coordinate d4/[3, 3]' do
            moveset = white_bishop_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Bd4-c3', 'Bd4-b2', 'Bd4-a1',
                                               'Bd4-e5', 'Bd4-f6', 'Bd4-g7', 'Bd4xh8',
                                               'Bd4xc5',
                                               'Bd4-e3')
          end

          it 'returns moveset containing only arms ending "Bh2xg1", "Bh2-e5" given coordinate h2/[7, 1]' do
            moveset = white_bishop_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Bh2xg1',
                                               'Bh2-g3', 'Bh2-f4', 'Bh2-e5')
          end
        end

        context 'when the letter is "Q" for Queen' do
          subject(:white_queen_moveset) { described_class.new(color:, letter: 'Q') }

          it 'returns moveset containing only arms ending "Qd4-a1", "Qd4xh8", "Qd4xc5", "Qd4-e3", "Qd4xg4", "Qd4-d1", "Qd4-d5" given coordinate d4/[3, 3]' do
            moveset = white_queen_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Qd4-c3', 'Qd4-b2', 'Qd4-a1',
                                               'Qd4-e5', 'Qd4-f6', 'Qd4-g7', 'Qd4xh8',
                                               'Qd4xc5',
                                               'Qd4-e3',
                                               'Qd4-e4', 'Qd4-f4', 'Qd4xg4',
                                               'Qd4-d1', 'Qd4-d2', 'Qd4-d3',
                                               'Qd4-d5')
          end

          it 'returns moveset containing only arms ending "Qh2xg1", "Qh2-e5", "Qh2-g2", "Qh2xh8" given coordinate h2/[7, 1]' do
            moveset = white_queen_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Qh2xg1',
                                               'Qh2-g3', 'Qh2-f4', 'Qh2-e5',
                                               'Qh2-g2',
                                               'Qh2-h3', 'Qh2-h4', 'Qh2-h5', 'Qh2-h6', 'Qh2-h7', 'Qh2xh8')
          end
        end

        context 'when the letter is "K" fo King' do
          subject(:white_king_moveset) { described_class.new(color:, letter: 'K') }

          it 'returns moveset containing exactly "Kd4xc5", "Kd4-x" with x = c3, e5, e3, e4, d3, d5 given coordinate d4/[3, 3]' do
            moveset = white_king_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Kd4-c3', 'Kd4-e5', 'Kd4xc5', 'Kd4-e3', 'Kd4-e4', 'Kd4-d3', 'Kd4-d5')
          end

          it 'returns moveset containing exactly "Kh2xg1", "Kh2-x" with x = g3, g2, h3 given coordinate h2/[7, 1]' do
            moveset = white_king_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Kh2xg1', 'Kh2-g3', 'Kh2-g2', 'Kh2-h3')
          end
        end

        context 'when the letter is "N" for Knight' do
          subject(:white_knight_moveset) { described_class.new(color:, letter: 'N') }

          it 'returns moveset containing exactly "Nd4xc2", "Nd4-x" with x = e2, b3, b5, f5, c6, e6 given coordinate d4/[3, 3]' do
            moveset = white_knight_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Nd4xc2', 'Nd4-e2', 'Nd4-b3', 'Nd4-b5', 'Nd4-f5', 'Nd4-c6', 'Nd4-e6')
          end

          it 'returns moveset containing exactly "Nh2xg4", "Nh2-f1" given coordinate h2/[7, 1]' do
            moveset = white_knight_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Nh2-f1', 'Nh2xg4')
          end
        end
      end
    end

    context 'when the color is black' do
      let(:color) { :black }

      context 'when the board is empty' do
        let(:board_empty) { instance_double('Board') }

        before do
          allow(board_empty).to receive(:off_grid?).and_return(true)
          (0..7).each do |file|
            (0..7).each do |rank|
              allow(board_empty).to receive(:off_grid?).with([file, rank]).and_return(false)
            end
          end

          allow(board_empty).to receive(:piece_at?).and_return(false)
        end

        context 'when the letter is "R" for Rook' do
          subject(:black_rook_moveset) { described_class.new(color:, letter: 'R') }

          it 'returns moveset containing only arms ending "Rd4-a4", "Rd4-h4", "Rd4-d1", "Rd4-d8" given coordinate d4/[3, 3]' do
            moveset = black_rook_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Rd4-a4', 'Rd4-b4', 'Rd4-c4',
                                               'Rd4-e4', 'Rd4-f4', 'Rd4-g4', 'Rd4-h4',
                                               'Rd4-d1', 'Rd4-d2', 'Rd4-d3',
                                               'Rd4-d5', 'Rd4-d6', 'Rd4-d7', 'Rd4-d8')
          end

          it 'returns moveset containing only arms ending "Rh2-a2", "Rh2-h1", "Rh2-h8" given coordinate h2/[7, 1]' do
            moveset = black_rook_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Rh2-a2', 'Rh2-b2', 'Rh2-c2', 'Rh2-d2', 'Rh2-e2', 'Rh2-f2', 'Rh2-g2',
                                               'Rh2-h1',
                                               'Rh2-h3', 'Rh2-h4', 'Rh2-h5', 'Rh2-h6', 'Rh2-h7', 'Rh2-h8')
          end
        end

        context 'when the letter is "B" for Bishop' do
          subject(:black_bishop_moveset) { described_class.new(color:, letter: 'B') }

          it 'returns moveset containing only arms ending "Bd4-a1", "Bd4-h8", "Bd4-a7", "Bd4-g1" given coordinate d4/[3, 3]' do
            moveset = black_bishop_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Bd4-c3', 'Bd4-b2', 'Bd4-a1',
                                               'Bd4-e5', 'Bd4-f6', 'Bd4-g7', 'Bd4-h8',
                                               'Bd4-c5', 'Bd4-b6', 'Bd4-a7',
                                               'Bd4-e3', 'Bd4-f2', 'Bd4-g1')
          end

          it 'returns moveset containing only arms ending "Bh2-g1", "Bh2-b8" given coordinate h2/[7, 1]' do
            moveset = black_bishop_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Bh2-g1',
                                               'Bh2-g3', 'Bh2-f4', 'Bh2-e5', 'Bh2-d6', 'Bh2-c7', 'Bh2-b8')
          end
        end

        context 'when the letter is "Q" for Queen' do
          subject(:black_queen_moveset) { described_class.new(color:, letter: 'Q') }

          it 'returns moveset containing only arms ending "Qd4-a1", "Qd4-h8", "Qd4-a7", "Qd4-g1", "Qd4-a4", "Qd4-h4", "Qd4-d1", "Qd4-d8" given coordinate d4/[3, 3]' do
            moveset = black_queen_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Qd4-c3', 'Qd4-b2', 'Qd4-a1',
                                               'Qd4-e5', 'Qd4-f6', 'Qd4-g7', 'Qd4-h8',
                                               'Qd4-c5', 'Qd4-b6', 'Qd4-a7',
                                               'Qd4-e3', 'Qd4-f2', 'Qd4-g1',
                                               'Qd4-a4', 'Qd4-b4', 'Qd4-c4',
                                               'Qd4-e4', 'Qd4-f4', 'Qd4-g4', 'Qd4-h4',
                                               'Qd4-d1', 'Qd4-d2', 'Qd4-d3',
                                               'Qd4-d5', 'Qd4-d6', 'Qd4-d7', 'Qd4-d8')
          end

          it 'returns moveset containing only arms ending "Qh2-g1", "Qh2-b8", "Qh2-a2", "Qh2-h1", "Qh2-h8" given coordinate h2/[7, 1]' do
            moveset = black_queen_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Qh2-g1',
                                               'Qh2-g3', 'Qh2-f4', 'Qh2-e5', 'Qh2-d6', 'Qh2-c7', 'Qh2-b8',
                                               'Qh2-a2', 'Qh2-b2', 'Qh2-c2', 'Qh2-d2', 'Qh2-e2', 'Qh2-f2', 'Qh2-g2',
                                               'Qh2-h1',
                                               'Qh2-h3', 'Qh2-h4', 'Qh2-h5', 'Qh2-h6', 'Qh2-h7', 'Qh2-h8')
          end
        end

        context 'when the letter is "K" fo King' do
          subject(:black_king_moveset) { described_class.new(color:, letter: 'K') }

          it 'returns moveset containing exactly "Kd4-x" with x = c3, e5, c5, e3, c4, e4, d3, d5 given coordinate d4/[3, 3]' do
            moveset = black_king_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Kd4-c3', 'Kd4-e5', 'Kd4-c5', 'Kd4-e3', 'Kd4-c4', 'Kd4-e4', 'Kd4-d3', 'Kd4-d5')
          end

          it 'returns moveset containing exactly "Kh2-x" with x = g1, g3, g2, h1, h3 given coordinate h2/[7, 1]' do
            moveset = black_king_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Kh2-g1', 'Kh2-g3', 'Kh2-g2', 'Kh2-h1', 'Kh2-h3')
          end
        end

        context 'when the letter is "N" for Knight' do
          subject(:black_knight_moveset) { described_class.new(color:, letter: 'N') }

          it 'returns moveset containing exactly "Nd4-x" with x = c2, e2, b3, f3, b5, f5, c6, e6 given coordinate d4/[3, 3]' do
            moveset = black_knight_moveset.moveset_from(coord: [3, 3], board: board_empty)
            expect(moveset).to contain_exactly('Nd4-c2', 'Nd4-e2', 'Nd4-b3', 'Nd4-f3', 'Nd4-b5', 'Nd4-f5', 'Nd4-c6', 'Nd4-e6')
          end

          it 'returns moveset containing exactly "Nh2-x" with x = f1, f3, g4 given coordinate h2/[7, 1]' do
            moveset = black_knight_moveset.moveset_from(coord: [7, 1], board: board_empty)
            expect(moveset).to contain_exactly('Nh2-f1', 'Nh2-f3', 'Nh2-g4')
          end
        end
      end

      context 'when the board is set up to block all piece movesets with both black and white pieces' do
        let(:board_blocking) { instance_double('Board') }

        before do
          allow(board_blocking).to receive(:off_grid?).and_return(true)
          (0..7).each do |file|
            (0..7).each do |rank|
              allow(board_blocking).to receive(:off_grid?).with([file, rank]).and_return(false)
            end
          end
        end

        # Board: (Same as one used in White tests but colors are flipped)
        # W = White, B = Black, X = Test
        # 8: . . . . . . . W
        # 7: . . . . . . . .
        # 6: . . . B . . . .
        # 5: . . W . . . . .
        # 4: . . B X . . W .
        # 3: . . . . . B . .
        # 2: . . W . . B . X
        # 1: . . . . . . W B
        #    A B C D E F G H

        before do
          allow(board_blocking).to receive(:piece_at?).and_return(false)

          allow(board_blocking).to receive(:piece_at?).with([7, 7], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([3, 5], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 4], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 3], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([6, 3], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([5, 2], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([2, 1], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([5, 1], :black).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([6, 0], :white).and_return(true)
          allow(board_blocking).to receive(:piece_at?).with([7, 0], :black).and_return(true)
        end

        context 'when the letter is "R" for Rook' do
          subject(:black_rook_moveset) { described_class.new(color:, letter: 'R') }

          it 'returns moveset containing only arms ending "Rd4xg4", "Rd4-d1", "Rd4-d5" given coordinate d4/[3, 3]' do
            moveset = black_rook_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Rd4-e4', 'Rd4-f4', 'Rd4xg4',
                                               'Rd4-d3', 'Rd4-d2', 'Rd4-d1',
                                               'Rd4-d5')
          end

          it 'returns moveset containing only arms ending "Rh2-g2", "Rh2xh8" given coordinate h2/[7, 1]' do
            moveset = black_rook_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Rh2-g2',
                                               'Rh2-h3', 'Rh2-h4', 'Rh2-h5', 'Rh2-h6', 'Rh2-h7', 'Rh2xh8')
          end
        end

        context 'when the letter is "B" for Bishop' do
          subject(:black_bishop_moveset) { described_class.new(color:, letter: 'B') }

          it 'returns moveset containing only arms ending "Bd4-a1", "Bd4xh8", "Bd4xc5", "Bd4-e3" given coordinate d4/[3, 3]' do
            moveset = black_bishop_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Bd4-c3', 'Bd4-b2', 'Bd4-a1',
                                               'Bd4-e5', 'Bd4-f6', 'Bd4-g7', 'Bd4xh8',
                                               'Bd4xc5',
                                               'Bd4-e3')
          end

          it 'returns moveset containing only arms ending "Bh2xg1", "Bh2-e5" given coordinate h2/[7, 1]' do
            moveset = black_bishop_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Bh2xg1',
                                               'Bh2-g3', 'Bh2-f4', 'Bh2-e5')
          end
        end

        context 'when the letter is "Q" for Queen' do
          subject(:black_queen_moveset) { described_class.new(color:, letter: 'Q') }

          it 'returns moveset containing only arms ending "Qd4-a1", "Qd4xh8", "Qd4xc5", "Qd4-e3", "Qd4xg4", "Qd4-d1", "Qd4-d5" given coordinate d4/[3, 3]' do
            moveset = black_queen_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Qd4-c3', 'Qd4-b2', 'Qd4-a1',
                                               'Qd4-e5', 'Qd4-f6', 'Qd4-g7', 'Qd4xh8',
                                               'Qd4xc5',
                                               'Qd4-e3',
                                               'Qd4-e4', 'Qd4-f4', 'Qd4xg4',
                                               'Qd4-d1', 'Qd4-d2', 'Qd4-d3',
                                               'Qd4-d5')
          end

          it 'returns moveset containing only arms ending "Qh2xg1", "Qh2-e5", "Qh2-g2", "Qh2xh8" given coordinate h2/[7, 1]' do
            moveset = black_queen_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Qh2xg1',
                                               'Qh2-g3', 'Qh2-f4', 'Qh2-e5',
                                               'Qh2-g2',
                                               'Qh2-h3', 'Qh2-h4', 'Qh2-h5', 'Qh2-h6', 'Qh2-h7', 'Qh2xh8')
          end
        end

        context 'when the letter is "K" fo King' do
          subject(:black_king_moveset) { described_class.new(color:, letter: 'K') }

          it 'returns moveset containing exactly "Kd4xc5", "Kd4-x" with x = c3, e5, e3, e4, d3, d5 given coordinate d4/[3, 3]' do
            moveset = black_king_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Kd4-c3', 'Kd4-e5', 'Kd4xc5', 'Kd4-e3', 'Kd4-e4', 'Kd4-d3', 'Kd4-d5')
          end

          it 'returns moveset containing exactly "Kh2xg1", "Kh2-x" with x = g3, g2, h3 given coordinate h2/[7, 1]' do
            moveset = black_king_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Kh2xg1', 'Kh2-g3', 'Kh2-g2', 'Kh2-h3')
          end
        end

        context 'when the letter is "N" for Knight' do
          subject(:black_knight_moveset) { described_class.new(color:, letter: 'N') }

          it 'returns moveset containing exactly "Nd4xc2", "Nd4-x" with x = e2, b3, b5, f5, c6, e6 given coordinate d4/[3, 3]' do
            moveset = black_knight_moveset.moveset_from(coord: [3, 3], board: board_blocking)
            expect(moveset).to contain_exactly('Nd4xc2', 'Nd4-e2', 'Nd4-b3', 'Nd4-b5', 'Nd4-f5', 'Nd4-c6', 'Nd4-e6')
          end

          it 'returns moveset containing exactly "Nh2xg4", "Nh2-f1" given coordinate h2/[7, 1]' do
            moveset = black_knight_moveset.moveset_from(coord: [7, 1], board: board_blocking)
            expect(moveset).to contain_exactly('Nh2-f1', 'Nh2xg4')
          end
        end
      end
    end
  end
end
