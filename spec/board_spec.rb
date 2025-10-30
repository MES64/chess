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

  describe '#moveset' do
    # Incoming Query Message -> Test value returned

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

      subject(:board_empty_moveset) { described_class.new(grid: grid_empty, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }) }

      it 'returns { white: [], black: [] }' do
        actual_moveset = board_empty_moveset.moveset
        expect(actual_moveset).to match({ white: [], black: [] })
      end
    end

    context 'when the board contains only a white pawn at a2' do
      let(:white_pawn) { instance_double('Pawn') }

      let(:grid_white_pawn) do
        [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
      end

      subject(:board_white_pawn_moveset) { described_class.new(grid: grid_white_pawn, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }) }

      before do
        allow(white_pawn).to receive(:color).and_return(:white)
        allow(white_pawn).to receive(:moveset_from).with(coord: [0, 1], board: board_white_pawn_moveset).and_return(%w[a2-a3 a2-a4])
      end

      it 'returns { white: ["a2-a3", "a2-a4"], black: [] }' do
        actual_moveset = board_white_pawn_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly('a2-a3', 'a2-a4'), black: [] })
      end
    end

    context 'when the board contains a white queen at c3, a black bishop at g3, and a black knight at e5' do
      let(:white_queen) { instance_double('Piece') }
      let(:black_bishop) { instance_double('Piece') }
      let(:black_knight) { instance_double('Piece') }

      let(:white_queen_moveset) do
        %w[Qc3-b2 Qc3-a1
           Qc3-d4 Qc3xe5
           Qc3-d2 Qc3-e1
           Qc3-b4 Qc3-a5
           Qc3-b3 Qc3-a3
           Qc3-d3 Qc3-e3 Qc3-f3 Qc3xg3
           Qc3-c2 Qc3-c1
           Qc3-c4 Qc3-c5 Qc3-c6 Qc3-c7 Qc3-c8]
      end

      let(:black_bishop_moveset) do
        %w[Bg3-f2 Bg3-e1
           Bg3-h4
           Bg3-h2
           Bg3-f4]
      end

      let(:black_knight_moveset) { %w[Ne5-d3 Ne5-f3 Ne5-c4 Ne5-g4 Ne5-c6 Ne5-g6 Ne5-d7 Ne5-f7] }

      let(:grid_three_pieces) do
        [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', black_knight, ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', white_queen, ' ', ' ', ' ', black_bishop, ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
      end

      subject(:board_three_pieces_moveset) { described_class.new(grid: grid_three_pieces, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }) }

      before do
        allow(white_queen).to receive(:color).and_return(:white)
        allow(black_bishop).to receive(:color).and_return(:black)
        allow(black_knight).to receive(:color).and_return(:black)

        allow(white_queen).to receive(:moveset_from).with(coord: [2, 2], board: board_three_pieces_moveset).and_return(white_queen_moveset)
        allow(black_bishop).to receive(:moveset_from).with(coord: [6, 2], board: board_three_pieces_moveset).and_return(black_bishop_moveset)
        allow(black_knight).to receive(:moveset_from).with(coord: [4, 4], board: board_three_pieces_moveset).and_return(black_knight_moveset)
      end

      it 'returns { white: white_queen_moveset, black: black_bishop_moveset + black_knight_moveset }' do
        actual_moveset = board_three_pieces_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*white_queen_moveset), black: contain_exactly(*(black_bishop_moveset + black_knight_moveset)) })
      end
    end

    context 'when there are castling moves only: castling = { white: ["O-O", "O-O-O"], black: ["O-O-O"] }' do
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

      subject(:board_castling_moveset) { described_class.new(grid: grid_empty, castling: { white: %w[O-O O-O-O], black: %w[O-O-O] }, en_passant: { white: [], black: [] }) }

      it 'returns { white: ["O-O", "O-O-O"], black: ["O-O-O"] }' do
        actual_moveset = board_castling_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly('O-O', 'O-O-O'), black: ['O-O-O'] })
      end
    end

    context 'when there are en passant moves only: en_passant = { white: [], black: ["c4xb3"] }' do
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

      subject(:board_en_passant_moveset) { described_class.new(grid: grid_empty, castling: { white: [], black: [] }, en_passant: { white: [], black: %w[c4xb3] }) }

      it 'returns { white: [], black: ["c4xb3"] }' do
        actual_moveset = board_en_passant_moveset.moveset
        expect(actual_moveset).to match({ white: [], black: %w[c4xb3] })
      end
    end

    context 'when there are normal, castling, and en passant moves all together' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:white_king) { instance_double('Piece') }
      let(:white_rook) { instance_double('Piece') }
      let(:black_knight) { instance_double('Piece') }

      let(:white_pawn_moveset) { %w[b5-b6 b5xa6] }

      let(:black_pawn_moveset) { %w[c5-c4] }

      let(:white_king_moveset) { %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f2 Ke1-f1] }

      let(:white_rook_moveset) do
        %w[Rh1-g1 Rh1-f1
           Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1-h7 Rh1-h8]
      end

      let(:black_knight_moveset) { %w[Na6-b4 Na6-c7 Na6-b8] }

      let(:grid_all) do
        [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [black_knight, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', white_pawn, black_pawn, ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]
      end

      subject(:board_all_moveset) { described_class.new(grid: grid_all, castling: { white: %w[O-O], black: [] }, en_passant: { white: %w[b5xc6], black: [] }) }

      before do
        allow(white_pawn).to receive(:color).and_return(:white)
        allow(black_pawn).to receive(:color).and_return(:black)
        allow(white_king).to receive(:color).and_return(:white)
        allow(white_rook).to receive(:color).and_return(:white)
        allow(black_knight).to receive(:color).and_return(:black)

        allow(white_pawn).to receive(:moveset_from).with(coord: [1, 4], board: board_all_moveset).and_return(white_pawn_moveset)
        allow(black_pawn).to receive(:moveset_from).with(coord: [2, 4], board: board_all_moveset).and_return(black_pawn_moveset)
        allow(white_king).to receive(:moveset_from).with(coord: [4, 0], board: board_all_moveset).and_return(white_king_moveset)
        allow(white_rook).to receive(:moveset_from).with(coord: [7, 0], board: board_all_moveset).and_return(white_rook_moveset)
        allow(black_knight).to receive(:moveset_from).with(coord: [0, 5], board: board_all_moveset).and_return(black_knight_moveset)
      end

      it 'returns { white: white_piece_moveset + ["O-O"] + ["b5xc6"], black: black_piece_moveset }' do
        white_piece_moveset = white_pawn_moveset + white_king_moveset + white_rook_moveset
        black_piece_moveset = black_pawn_moveset + black_knight_moveset
        actual_moveset = board_all_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*(white_piece_moveset + ['O-O'] + ['b5xc6'])), black: contain_exactly(*black_piece_moveset) })
      end
    end
  end
end

# Notes:
# - Write separate tests for default Board instance variables
# - Refactor letters in #print_board to be more general
#
# - Maybe refactor them for coord. Maybe hash or swap coordinate indexes. Could do later...
# - Can also think about a ' ' piece for empty squares to send the print_color message, etc.
# - Don't worry about any more refactoring now; better to finish the project and see what the refactoring
#   should be from there (if it is even worth doing). For now, just add private methods to simplify!
