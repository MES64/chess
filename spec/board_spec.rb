# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/piece'

RSpec.describe Board do
  describe '#print_board' do
    # Incoming Query Message -> Test value returned

    context 'when the color is white' do
      let(:color) { :white }

      context 'when the board is empty' do
        let(:grid_empty) do
          [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
        end

        subject(:board_empty_white) { described_class.new(grid: grid_empty) }

        it 'returns an empty board string from white side' do
          expected_string = <<~BOARD
            8 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            7 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            6 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            5 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            4 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            3 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            2 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            1 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
              a b c d e f g h
          BOARD
          actual_string = board_empty_white.print_board(color:)
          expect(actual_string).to eql(expected_string)
        end
      end

      context 'when the board is set up to start a game of Chess' do
        let(:black_rook) { instance_double('Piece') }
        let(:black_knight) { instance_double('Piece') }
        let(:black_bishop) { instance_double('Piece') }
        let(:black_queen) { instance_double('Piece') }
        let(:black_king) { instance_double('Piece') }

        let(:white_rook) { instance_double('Piece') }
        let(:white_knight) { instance_double('Piece') }
        let(:white_bishop) { instance_double('Piece') }
        let(:white_queen) { instance_double('Piece') }
        let(:white_king) { instance_double('Piece') }

        let(:black_pawn) { instance_double('Pawn') }
        let(:white_pawn) { instance_double('Pawn') }

        before do
          allow(black_rook).to receive(:to_s).and_return('♜')
          allow(black_knight).to receive(:to_s).and_return('♞')
          allow(black_bishop).to receive(:to_s).and_return('♝')
          allow(black_queen).to receive(:to_s).and_return('♛')
          allow(black_king).to receive(:to_s).and_return('♚')
          allow(black_pawn).to receive(:to_s).and_return('♟')

          allow(white_rook).to receive(:to_s).and_return('♜')
          allow(white_knight).to receive(:to_s).and_return('♞')
          allow(white_bishop).to receive(:to_s).and_return('♝')
          allow(white_queen).to receive(:to_s).and_return('♛')
          allow(white_king).to receive(:to_s).and_return('♚')
          allow(white_pawn).to receive(:to_s).and_return('♟')

          allow(black_rook).to receive(:print_color).and_return('30')
          allow(black_knight).to receive(:print_color).and_return('30')
          allow(black_bishop).to receive(:print_color).and_return('30')
          allow(black_queen).to receive(:print_color).and_return('30')
          allow(black_king).to receive(:print_color).and_return('30')
          allow(black_pawn).to receive(:print_color).and_return('30')

          allow(white_rook).to receive(:print_color).and_return('97')
          allow(white_knight).to receive(:print_color).and_return('97')
          allow(white_bishop).to receive(:print_color).and_return('97')
          allow(white_queen).to receive(:print_color).and_return('97')
          allow(white_king).to receive(:print_color).and_return('97')
          allow(white_pawn).to receive(:print_color).and_return('97')
        end

        let(:grid_start) do
          [[black_rook, black_knight, black_bishop, black_queen, black_king, black_bishop, black_knight, black_rook],
           [black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn],
           [white_rook, white_knight, white_bishop, white_queen, white_king, white_bishop, white_knight, white_rook]]
        end

        subject(:board_start_white) { described_class.new(grid: grid_start) }

        it 'returns a starting board string from white side' do
          expected_string = <<~BOARD
            8 \e[30;104m♜ \e[30;44m♞ \e[30;104m♝ \e[30;44m♛ \e[30;104m♚ \e[30;44m♝ \e[30;104m♞ \e[30;44m♜ \e[0m
            7 \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[0m
            6 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            5 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            4 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            3 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            2 \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[0m
            1 \e[97;44m♜ \e[97;104m♞ \e[97;44m♝ \e[97;104m♛ \e[97;44m♚ \e[97;104m♝ \e[97;44m♞ \e[97;104m♜ \e[0m
              a b c d e f g h
          BOARD
          actual_string = board_start_white.print_board(color:)
          expect(actual_string).to eql(expected_string)
        end
      end
    end

    context 'when the color is black' do
      let(:color) { :black }

      context 'when the board is empty' do
        let(:grid_empty) do
          [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
        end

        subject(:board_empty_black) { described_class.new(grid: grid_empty) }

        it 'returns an empty board string from black side' do
          expected_string = <<~BOARD
            1 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            2 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            3 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            4 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            5 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            6 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            7 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            8 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
              h g f e d c b a
          BOARD
          actual_string = board_empty_black.print_board(color:)
          expect(actual_string).to eql(expected_string)
        end
      end

      context 'when the board is set up to start a game of Chess' do
        let(:black_rook) { instance_double('Piece') }
        let(:black_knight) { instance_double('Piece') }
        let(:black_bishop) { instance_double('Piece') }
        let(:black_queen) { instance_double('Piece') }
        let(:black_king) { instance_double('Piece') }

        let(:white_rook) { instance_double('Piece') }
        let(:white_knight) { instance_double('Piece') }
        let(:white_bishop) { instance_double('Piece') }
        let(:white_queen) { instance_double('Piece') }
        let(:white_king) { instance_double('Piece') }

        let(:black_pawn) { instance_double('Pawn') }
        let(:white_pawn) { instance_double('Pawn') }

        before do
          allow(black_rook).to receive(:to_s).and_return('♜')
          allow(black_knight).to receive(:to_s).and_return('♞')
          allow(black_bishop).to receive(:to_s).and_return('♝')
          allow(black_queen).to receive(:to_s).and_return('♛')
          allow(black_king).to receive(:to_s).and_return('♚')
          allow(black_pawn).to receive(:to_s).and_return('♟')

          allow(white_rook).to receive(:to_s).and_return('♜')
          allow(white_knight).to receive(:to_s).and_return('♞')
          allow(white_bishop).to receive(:to_s).and_return('♝')
          allow(white_queen).to receive(:to_s).and_return('♛')
          allow(white_king).to receive(:to_s).and_return('♚')
          allow(white_pawn).to receive(:to_s).and_return('♟')

          allow(black_rook).to receive(:print_color).and_return('30')
          allow(black_knight).to receive(:print_color).and_return('30')
          allow(black_bishop).to receive(:print_color).and_return('30')
          allow(black_queen).to receive(:print_color).and_return('30')
          allow(black_king).to receive(:print_color).and_return('30')
          allow(black_pawn).to receive(:print_color).and_return('30')

          allow(white_rook).to receive(:print_color).and_return('97')
          allow(white_knight).to receive(:print_color).and_return('97')
          allow(white_bishop).to receive(:print_color).and_return('97')
          allow(white_queen).to receive(:print_color).and_return('97')
          allow(white_king).to receive(:print_color).and_return('97')
          allow(white_pawn).to receive(:print_color).and_return('97')
        end

        let(:grid_start) do
          [[black_rook, black_knight, black_bishop, black_queen, black_king, black_bishop, black_knight, black_rook],
           [black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn, black_pawn],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn, white_pawn],
           [white_rook, white_knight, white_bishop, white_queen, white_king, white_bishop, white_knight, white_rook]]
        end

        subject(:board_start_black) { described_class.new(grid: grid_start) }

        it 'returns a starting board string from black side' do
          expected_string = <<~BOARD
            1 \e[97;104m♜ \e[97;44m♞ \e[97;104m♝ \e[97;44m♚ \e[97;104m♛ \e[97;44m♝ \e[97;104m♞ \e[97;44m♜ \e[0m
            2 \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[97;44m♟ \e[97;104m♟ \e[0m
            3 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            4 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            5 \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[0m
            6 \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[44m  \e[104m  \e[0m
            7 \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[30;104m♟ \e[30;44m♟ \e[0m
            8 \e[30;44m♜ \e[30;104m♞ \e[30;44m♝ \e[30;104m♚ \e[30;44m♛ \e[30;104m♝ \e[30;44m♞ \e[30;104m♜ \e[0m
              h g f e d c b a
          BOARD
          actual_string = board_start_black.print_board(color:)
          expect(actual_string).to eql(expected_string)
        end
      end
    end
  end

  describe '#off_grid?' do
    # Incoming Query Message -> Test value returned

    let(:grid_empty) do
      [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
    end

    subject(:board_off_grid) { described_class.new(grid: grid_empty) }

    it 'returns false for coordinate [2, 3]' do
      expect(board_off_grid).to_not be_off_grid [2, 3]
    end

    it 'returns false for coordinate [0, 0]' do
      expect(board_off_grid).to_not be_off_grid [0, 0]
    end

    it 'returns false for coordinate [0, 7]' do
      expect(board_off_grid).to_not be_off_grid [0, 7]
    end

    it 'returns false for coordinate [7, 0]' do
      expect(board_off_grid).to_not be_off_grid [7, 0]
    end

    it 'returns false for coordinate [7, 7]' do
      expect(board_off_grid).to_not be_off_grid [7, 7]
    end

    it 'returns true for coordinate [-2, -3]' do
      expect(board_off_grid).to be_off_grid [-2, -3]
    end

    it 'returns true for coordinate [-1, 0]' do
      expect(board_off_grid).to be_off_grid [-1, 0]
    end

    it 'returns true for coordinate [0, -1]' do
      expect(board_off_grid).to be_off_grid [0, -1]
    end

    it 'returns true for coordinate [100, 208]' do
      expect(board_off_grid).to be_off_grid [100, 208]
    end

    it 'returns true for coordinate [7, 8]' do
      expect(board_off_grid).to be_off_grid [7, 8]
    end

    it 'returns true for coordinate [8, 7]' do
      expect(board_off_grid).to be_off_grid [8, 7]
    end
  end

  describe '#empty_at?' do
    # Incoming Query Message -> Test value returned

    let(:black_rook) { instance_double('Piece') }
    let(:white_knight) { instance_double('Piece') }
    let(:black_pawn) { instance_double('Pawn') }
    let(:white_pawn) { instance_double('Pawn') }

    let(:grid_empty_at) do
      [[black_rook, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', black_pawn, ' '],
       [' ', ' ', white_knight, ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
    end

    subject(:board_empty_at) { described_class.new(grid: grid_empty_at) }

    it 'returns true for an empty square at [0, 2]' do
      expect(board_empty_at).to be_empty_at [0, 2]
    end

    it 'returns true for an empty square at [7, 7]' do
      expect(board_empty_at).to be_empty_at [7, 7]
    end

    it 'returns false for a white pawn at [0, 1]' do
      expect(board_empty_at).to_not be_empty_at [0, 1]
    end

    it 'returns false for a white knight at [2, 4]' do
      expect(board_empty_at).to_not be_empty_at [2, 4]
    end

    it 'returns false for a black pawn at [6, 5]' do
      expect(board_empty_at).to_not be_empty_at [6, 5]
    end

    it 'returns false for a black rook at [0, 7]' do
      expect(board_empty_at).to_not be_empty_at [0, 7]
    end

    it 'returns false for no square at [-1, 0]' do
      expect(board_empty_at).to_not be_empty_at [-1, 0]
    end

    it 'returns false for no square at [0, -1]' do
      expect(board_empty_at).to_not be_empty_at [0, -1]
    end

    it 'returns false for no square at [-1, -1]' do
      expect(board_empty_at).to_not be_empty_at [-1, -1]
    end

    it 'returns false for no square at [8, 7]' do
      expect(board_empty_at).to_not be_empty_at [8, 7]
    end

    it 'returns false for no square at [7, 8]' do
      expect(board_empty_at).to_not be_empty_at [7, 8]
    end

    it 'returns false for no square at [8, 8]' do
      expect(board_empty_at).to_not be_empty_at [8, 8]
    end
  end

  describe '#piece_at?' do
    # Incoming Query Message -> Test value returned

    let(:black_rook) { instance_double('Piece') }
    let(:white_knight) { instance_double('Piece') }
    let(:black_pawn) { instance_double('Pawn') }
    let(:white_pawn) { instance_double('Pawn') }

    before do
      allow(black_rook).to receive(:color).and_return(:black)
      allow(white_knight).to receive(:color).and_return(:white)
      allow(black_pawn).to receive(:color).and_return(:black)
      allow(white_pawn).to receive(:color).and_return(:white)
    end

    let(:grid_piece_at) do
      [[black_rook, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', black_pawn, ' '],
       [' ', ' ', white_knight, ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
    end

    subject(:board_piece_at) { described_class.new(grid: grid_piece_at) }

    context 'when looking for a white piece' do
      it 'returns false for an empty square at [0, 2]' do
        expect(board_piece_at).to_not be_piece_at([0, 2], :white)
      end

      it 'returns false for an empty square at [7, 7]' do
        expect(board_piece_at).to_not be_piece_at([7, 7], :white)
      end

      it 'returns true for a white pawn at [0, 1]' do
        expect(board_piece_at).to be_piece_at([0, 1], :white)
      end

      it 'returns true for a white knight at [2, 4]' do
        expect(board_piece_at).to be_piece_at([2, 4], :white)
      end

      it 'returns false for a black pawn at [6, 5]' do
        expect(board_piece_at).to_not be_piece_at([6, 5], :white)
      end

      it 'returns false for a black rook at [0, 7]' do
        expect(board_piece_at).to_not be_piece_at([0, 7], :white)
      end

      it 'returns false for no square at [-1, 0]' do
        expect(board_piece_at).to_not be_piece_at([-1, 0], :white)
      end
    end

    context 'when looking for a black piece' do
      it 'returns false for an empty square at [0, 2]' do
        expect(board_piece_at).to_not be_piece_at([0, 2], :black)
      end

      it 'returns false for an empty square at [7, 7]' do
        expect(board_piece_at).to_not be_piece_at([7, 7], :black)
      end

      it 'returns false for a white pawn at [0, 1]' do
        expect(board_piece_at).to_not be_piece_at([0, 1], :black)
      end

      it 'returns false for a white knight at [2, 4]' do
        expect(board_piece_at).to_not be_piece_at([2, 4], :black)
      end

      it 'returns true for a black pawn at [6, 5]' do
        expect(board_piece_at).to be_piece_at([6, 5], :black)
      end

      it 'returns true for a black rook at [0, 7]' do
        expect(board_piece_at).to be_piece_at([0, 7], :black)
      end

      it 'returns false for no square at [-1, 0]' do
        expect(board_piece_at).to_not be_piece_at([-1, 0], :black)
      end
    end
  end
end

# Notes:
# - Maybe refactor them for coord. Maybe hash or swap coordinate indexes. Could do later...
# - Can also think about a ' ' piece for empty squares to send the print_color message, etc.
# - Don't worry about any more refactoring now; better to finish the project and see what the refactoring
#   should be from there (if it is even worth doing). For now, just add private methods to simplify!
