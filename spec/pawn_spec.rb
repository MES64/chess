# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/board'

RSpec.describe Pawn do
  describe '#print_color' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_color) { described_class.new(:white) }

      it 'returns "97"' do
        expect(pawn_white_color.print_color).to eql('97')
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_color) { described_class.new(:black) }

      it 'returns "30"' do
        expect(pawn_black_color.print_color).to eql('30')
      end
    end
  end

  describe '#to_s' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_string) { described_class.new(:white) }

      it 'returns "♟"' do
        expect(pawn_white_string.to_s).to eql('♟')
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_string) { described_class.new(:black) }

      it 'returns "♟"' do
        expect(pawn_black_string.to_s).to eql('♟')
      end
    end
  end

  describe '#moveset_from' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_moveset) { described_class.new(:white) }

      context 'when the board is empty' do
        let(:board_empty) { instance_double('Board') }

        before do
          allow(board_empty).to receive(:empty_at?).and_return(true)
          allow(board_empty).to receive(:piece_at?).and_return(false)
        end

        it 'returns moveset only containing "d4-d5" given coordinate d4/[3, 3]' do
          moveset = pawn_white_moveset.moveset_from(coord: [3, 3], board: board_empty)
          expect(moveset).to contain_exactly('d4-d5')
        end

        it 'returns moveset only containing "e5-e6" given coordinate e5/[4, 4]' do
          moveset = pawn_white_moveset.moveset_from(coord: [4, 4], board: board_empty)
          expect(moveset).to contain_exactly('e5-e6')
        end

        it 'returns moveset containing exactly "h2-h3", "h2-h4" given coordinate h2/[7, 1]' do
          moveset = pawn_white_moveset.moveset_from(coord: [7, 1], board: board_empty)
          expect(moveset).to contain_exactly('h2-h3', 'h2-h4')
        end

        it 'returns moveset containing exactly "b2-b3", "b2-b4" given coordinate b2/[1, 1]' do
          moveset = pawn_white_moveset.moveset_from(coord: [1, 1], board: board_empty)
          expect(moveset).to contain_exactly('b2-b3', 'b2-b4')
        end

        it 'returns moveset containing exactly "a7-a8=P" where P = Q,R,N,B given coordinate a7/[0, 6]' do
          moveset = pawn_white_moveset.moveset_from(coord: [0, 6], board: board_empty)
          expect(moveset).to contain_exactly('a7-a8=Q', 'a7-a8=R', 'a7-a8=N', 'a7-a8=B')
        end

        it 'returns moveset containing exactly "f7-f8=P" where P = Q,R,N,B given coordinate f7/[5, 6]' do
          moveset = pawn_white_moveset.moveset_from(coord: [5, 6], board: board_empty)
          expect(moveset).to contain_exactly('f7-f8=Q', 'f7-f8=R', 'f7-f8=N', 'f7-f8=B')
        end
      end

      context 'when the board is empty except at the coordinate in front of the pawn' do
        it 'returns empty moveset given coordinate c6/[2, 5]' do
          board_block1 = instance_double('Board')
          allow(board_block1).to receive(:empty_at?).with([2, 6]).and_return(false)
          allow(board_block1).to receive(:empty_at?).with([2, 7]).and_return(true)
          allow(board_block1).to receive(:piece_at?).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [2, 5], board: board_block1)
          expect(moveset).to be_empty
        end

        it 'returns empty moveset given coordinate g2/[6, 1]' do
          board_block2 = instance_double('Board')
          allow(board_block2).to receive(:empty_at?).with([6, 2]).and_return(false)
          allow(board_block2).to receive(:empty_at?).with([6, 3]).and_return(true)
          allow(board_block2).to receive(:piece_at?).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [6, 1], board: board_block2)
          expect(moveset).to be_empty
        end
      end

      context 'when the board is empty except at the coordinate two spaces forward' do
        it 'returns moveset containing exactly "c6-c7" given coordinate c6/[2, 5]' do
          board_no_block = instance_double('Board')
          allow(board_no_block).to receive(:empty_at?).with([2, 6]).and_return(true)
          allow(board_no_block).to receive(:empty_at?).with([2, 7]).and_return(false)
          allow(board_no_block).to receive(:piece_at?).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [2, 5], board: board_no_block)
          expect(moveset).to contain_exactly('c6-c7')
        end

        it 'returns moveset containing exactly "g2-g3" given coordinate g2/[6, 1]' do
          board_block_forward_two = instance_double('Board')
          allow(board_block_forward_two).to receive(:empty_at?).with([6, 2]).and_return(true)
          allow(board_block_forward_two).to receive(:empty_at?).with([6, 3]).and_return(false)
          allow(board_block_forward_two).to receive(:piece_at?).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [6, 1], board: board_block_forward_two)
          expect(moveset).to contain_exactly('g2-g3')
        end
      end

      context 'when the board is empty except for a black piece [-1, 1] from the piece coordinate' do
        it 'returns moveset containing exactly "c6-c7", "c6xb7" given coordinate c6/[2, 5]' do
          board_take1 = instance_double('Board')
          allow(board_take1).to receive(:empty_at?).with([2, 6]).and_return(true)
          allow(board_take1).to receive(:empty_at?).with([2, 7]).and_return(true)
          allow(board_take1).to receive(:piece_at?).with([1, 6], :black).and_return(true)
          allow(board_take1).to receive(:piece_at?).with([3, 6], :black).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [2, 5], board: board_take1)
          expect(moveset).to contain_exactly('c6-c7', 'c6xb7')
        end

        it 'returns moveset containing exactly "g2-g3", "g2-g4", "g2xf3" given coordinate g2/[6, 1]' do
          board_take2 = instance_double('Board')
          allow(board_take2).to receive(:empty_at?).with([6, 2]).and_return(true)
          allow(board_take2).to receive(:empty_at?).with([6, 3]).and_return(true)
          allow(board_take2).to receive(:piece_at?).with([5, 2], :black).and_return(true)
          allow(board_take2).to receive(:piece_at?).with([7, 2], :black).and_return(false)

          moveset = pawn_white_moveset.moveset_from(coord: [6, 1], board: board_take2)
          expect(moveset).to contain_exactly('g2-g3', 'g2-g4', 'g2xf3')
        end
      end

      context 'when the board is empty except for a black piece [1, 1] from the piece coordinate' do
        it 'returns moveset containing exactly "c6-c7", "c6xd7" given coordinate c6/[2, 5]' do
          board_take3 = instance_double('Board')
          allow(board_take3).to receive(:empty_at?).with([2, 6]).and_return(true)
          allow(board_take3).to receive(:empty_at?).with([2, 7]).and_return(true)
          allow(board_take3).to receive(:piece_at?).with([1, 6], :black).and_return(false)
          allow(board_take3).to receive(:piece_at?).with([3, 6], :black).and_return(true)

          moveset = pawn_white_moveset.moveset_from(coord: [2, 5], board: board_take3)
          expect(moveset).to contain_exactly('c6-c7', 'c6xd7')
        end

        it 'returns moveset containing exactly "g2-g3", "g2-g4", "g2xh3" given coordinate g2/[6, 1]' do
          board_take4 = instance_double('Board')
          allow(board_take4).to receive(:empty_at?).with([6, 2]).and_return(true)
          allow(board_take4).to receive(:empty_at?).with([6, 3]).and_return(true)
          allow(board_take4).to receive(:piece_at?).with([5, 2], :black).and_return(false)
          allow(board_take4).to receive(:piece_at?).with([7, 2], :black).and_return(true)

          moveset = pawn_white_moveset.moveset_from(coord: [6, 1], board: board_take4)
          expect(moveset).to contain_exactly('g2-g3', 'g2-g4', 'g2xh3')
        end
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_moveset) { described_class.new(:black) }

      context 'when the board is empty' do
        let(:board_empty) { instance_double('Board') }

        before do
          allow(board_empty).to receive(:empty_at?).and_return(true)
          allow(board_empty).to receive(:piece_at?).and_return(false)
        end

        it 'returns moveset only containing "d5-d4" given coordinate d5/[3, 4]' do
          moveset = pawn_black_moveset.moveset_from(coord: [3, 4], board: board_empty)
          expect(moveset).to contain_exactly('d5-d4')
        end

        it 'returns moveset only containing "e6-e5" given coordinate e6/[4, 5]' do
          moveset = pawn_black_moveset.moveset_from(coord: [4, 5], board: board_empty)
          expect(moveset).to contain_exactly('e6-e5')
        end

        it 'returns moveset containing exactly "h7-h6", "h7-h5" given coordinate h7/[7, 6]' do
          moveset = pawn_black_moveset.moveset_from(coord: [7, 6], board: board_empty)
          expect(moveset).to contain_exactly('h7-h6', 'h7-h5')
        end

        it 'returns moveset containing exactly "b7-b6", "b7-b5" given coordinate b7/[1, 6]' do
          moveset = pawn_black_moveset.moveset_from(coord: [1, 6], board: board_empty)
          expect(moveset).to contain_exactly('b7-b6', 'b7-b5')
        end

        it 'returns moveset containing exactly "a2-a1=P" where P = Q,R,N,B given coordinate a2/[0, 1]' do
          moveset = pawn_black_moveset.moveset_from(coord: [0, 1], board: board_empty)
          expect(moveset).to contain_exactly('a2-a1=Q', 'a2-a1=R', 'a2-a1=N', 'a2-a1=B')
        end

        it 'returns moveset containing exactly "f2-f1=P" where P = Q,R,N,B given coordinate f2/[5, 1]' do
          moveset = pawn_black_moveset.moveset_from(coord: [5, 1], board: board_empty)
          expect(moveset).to contain_exactly('f2-f1=Q', 'f2-f1=R', 'f2-f1=N', 'f2-f1=B')
        end
      end

      context 'when the board is empty except at the coordinate in front of the pawn' do
        it 'returns empty moveset given coordinate c6/[2, 5]' do
          board_block3 = instance_double('Board')
          allow(board_block3).to receive(:empty_at?).with([2, 4]).and_return(false)
          allow(board_block3).to receive(:empty_at?).with([2, 3]).and_return(true)
          allow(board_block3).to receive(:piece_at?).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [2, 5], board: board_block3)
          expect(moveset).to be_empty
        end

        it 'returns empty moveset given coordinate g7/[6, 6]' do
          board_block4 = instance_double('Board')
          allow(board_block4).to receive(:empty_at?).with([6, 5]).and_return(false)
          allow(board_block4).to receive(:empty_at?).with([6, 4]).and_return(true)
          allow(board_block4).to receive(:piece_at?).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [6, 6], board: board_block4)
          expect(moveset).to be_empty
        end
      end

      context 'when the board is empty except at the coordinate two spaces forward' do
        it 'returns moveset containing exactly "c6-c5" given coordinate c6/[2, 5]' do
          board_no_block2 = instance_double('Board')
          allow(board_no_block2).to receive(:empty_at?).with([2, 4]).and_return(true)
          allow(board_no_block2).to receive(:empty_at?).with([2, 3]).and_return(false)
          allow(board_no_block2).to receive(:piece_at?).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [2, 5], board: board_no_block2)
          expect(moveset).to contain_exactly('c6-c5')
        end

        it 'returns moveset containing exactly "g7-g6" given coordinate g7/[6, 6]' do
          board_block_forward_two2 = instance_double('Board')
          allow(board_block_forward_two2).to receive(:empty_at?).with([6, 5]).and_return(true)
          allow(board_block_forward_two2).to receive(:empty_at?).with([6, 4]).and_return(false)
          allow(board_block_forward_two2).to receive(:piece_at?).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [6, 6], board: board_block_forward_two2)
          expect(moveset).to contain_exactly('g7-g6')
        end
      end

      context 'when the board is empty except for a white piece [-1, -1] from the piece coordinate' do
        it 'returns moveset containing exactly "c6-c5", "c6xb5" given coordinate c6/[2, 5]' do
          board_take5 = instance_double('Board')
          allow(board_take5).to receive(:empty_at?).with([2, 4]).and_return(true)
          allow(board_take5).to receive(:empty_at?).with([2, 3]).and_return(true)
          allow(board_take5).to receive(:piece_at?).with([1, 4], :white).and_return(true)
          allow(board_take5).to receive(:piece_at?).with([3, 4], :white).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [2, 5], board: board_take5)
          expect(moveset).to contain_exactly('c6-c5', 'c6xb5')
        end

        it 'returns moveset containing exactly "g7-g6", "g7-g5", "g7xf6" given coordinate g7/[6, 6]' do
          board_take6 = instance_double('Board')
          allow(board_take6).to receive(:empty_at?).with([6, 5]).and_return(true)
          allow(board_take6).to receive(:empty_at?).with([6, 4]).and_return(true)
          allow(board_take6).to receive(:piece_at?).with([5, 5], :white).and_return(true)
          allow(board_take6).to receive(:piece_at?).with([7, 5], :white).and_return(false)

          moveset = pawn_black_moveset.moveset_from(coord: [6, 6], board: board_take6)
          expect(moveset).to contain_exactly('g7-g6', 'g7-g5', 'g7xf6')
        end
      end

      context 'when the board is empty except for a white piece [1, -1] from the piece coordinate' do
        it 'returns moveset containing exactly "c6-c5", "c6xd5" given coordinate c6/[2, 5]' do
          board_take7 = instance_double('Board')
          allow(board_take7).to receive(:empty_at?).with([2, 4]).and_return(true)
          allow(board_take7).to receive(:empty_at?).with([2, 3]).and_return(true)
          allow(board_take7).to receive(:piece_at?).with([1, 4], :white).and_return(false)
          allow(board_take7).to receive(:piece_at?).with([3, 4], :white).and_return(true)

          moveset = pawn_black_moveset.moveset_from(coord: [2, 5], board: board_take7)
          expect(moveset).to contain_exactly('c6-c5', 'c6xd5')
        end

        it 'returns moveset containing exactly "g7-g6", "g7-g5", "g7xh6" given coordinate g7/[6, 6]' do
          board_take8 = instance_double('Board')
          allow(board_take8).to receive(:empty_at?).with([6, 5]).and_return(true)
          allow(board_take8).to receive(:empty_at?).with([6, 4]).and_return(true)
          allow(board_take8).to receive(:piece_at?).with([5, 5], :white).and_return(false)
          allow(board_take8).to receive(:piece_at?).with([7, 5], :white).and_return(true)

          moveset = pawn_black_moveset.moveset_from(coord: [6, 6], board: board_take8)
          expect(moveset).to contain_exactly('g7-g6', 'g7-g5', 'g7xh6')
        end
      end
    end
  end

  describe '#en_passant_left' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_en_passant_left) { described_class.new(:white) }

      it 'returns ["h5xg6"] for coord h5/[7, 4]' do
        en_passant_left = pawn_white_en_passant_left.en_passant_left([7, 4])
        expect(en_passant_left).to eql(['h5xg6'])
      end

      it 'returns ["b5xa6"] for coord b5/[1, 4]' do
        en_passant_left = pawn_white_en_passant_left.en_passant_left([1, 4])
        expect(en_passant_left).to eql(['b5xa6'])
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_en_passant_left) { described_class.new(:black) }

      it 'returns ["h4xg3"] for coord h4/[7, 3]' do
        en_passant_left = pawn_black_en_passant_left.en_passant_left([7, 3])
        expect(en_passant_left).to eql(['h4xg3'])
      end

      it 'returns ["b4xa3"] for coord b4/[1, 3]' do
        en_passant_left = pawn_black_en_passant_left.en_passant_left([1, 3])
        expect(en_passant_left).to eql(['b4xa3'])
      end
    end
  end

  describe '#en_passant_right' do
    # Incoming Query Message -> Test value returned

    context 'when the pawn is white' do
      subject(:pawn_white_en_passant_right) { described_class.new(:white) }

      it 'returns ["a5xb6"] for coord a5/[0, 4]' do
        en_passant_right = pawn_white_en_passant_right.en_passant_right([0, 4])
        expect(en_passant_right).to eql(['a5xb6'])
      end

      it 'returns ["g5xh6"] for coord g5/[6, 4]' do
        en_passant_right = pawn_white_en_passant_right.en_passant_right([6, 4])
        expect(en_passant_right).to eql(['g5xh6'])
      end
    end

    context 'when the pawn is black' do
      subject(:pawn_black_en_passant_right) { described_class.new(:black) }

      it 'returns ["a4xb3"] for coord a4/[0, 3]' do
        en_passant_right = pawn_black_en_passant_right.en_passant_right([0, 3])
        expect(en_passant_right).to eql(['a4xb3'])
      end

      it 'returns ["g4xh3"] for coord g4/[6, 3]' do
        en_passant_right = pawn_black_en_passant_right.en_passant_right([6, 3])
        expect(en_passant_right).to eql(['g4xh3'])
      end
    end
  end
end
