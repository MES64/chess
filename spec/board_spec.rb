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

        subject(:board_empty_white) { described_class.new(grid: grid_empty, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

        subject(:board_start_white) { described_class.new(grid: grid_start, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

        subject(:board_empty_black) { described_class.new(grid: grid_empty, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

        subject(:board_start_black) { described_class.new(grid: grid_start, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

    subject(:board_off_grid) { described_class.new(grid: grid_empty, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

    subject(:board_empty_at) { described_class.new(grid: grid_empty_at, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

    subject(:board_piece_at) { described_class.new(grid: grid_piece_at, castling: nil, en_passant: nil, letter_to_piece: nil) }

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

      subject(:board_empty_moveset) { described_class.new(grid: grid_empty, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }, letter_to_piece: nil) }

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

      subject(:board_white_pawn_moveset) { described_class.new(grid: grid_white_pawn, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }, letter_to_piece: nil) }

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

      subject(:board_three_pieces_moveset) { described_class.new(grid: grid_three_pieces, castling: { white: [], black: [] }, en_passant: { white: [], black: [] }, letter_to_piece: nil) }

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

      subject(:board_castling_moveset) { described_class.new(grid: grid_empty, castling: { white: %w[O-O O-O-O], black: %w[O-O-O] }, en_passant: { white: [], black: [] }, letter_to_piece: nil) }

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

      subject(:board_en_passant_moveset) { described_class.new(grid: grid_empty, castling: { white: [], black: [] }, en_passant: { white: [], black: %w[c4xb3] }, letter_to_piece: nil) }

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

      subject(:board_all_moveset) { described_class.new(grid: grid_all, castling: { white: %w[O-O], black: [] }, en_passant: { white: %w[b5xc6], black: [] }, letter_to_piece: nil) }

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

  describe '#update_grid' do
    # Incoming Command Message -> Test change of observable state

    context 'when the grid is empty' do
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

      subject(:board_empty_update_grid) { described_class.new(grid: grid_empty, castling: nil, en_passant: nil, letter_to_piece: nil) }

      it 'updates the grid to be empty for the move "a2-a3"' do
        expected_grid = grid_empty

        board_empty_update_grid.update_grid('a2-a3')
        actual_grid = board_empty_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end
    end

    context 'when the grid only contains a white pawn at a2' do
      let(:white_pawn) { instance_double('Pawn') }

      let(:grid_pawn) do
        [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
      end

      subject(:board_pawn_update_grid) { described_class.new(grid: grid_pawn, castling: nil, en_passant: nil, letter_to_piece: nil) }

      it 'updates the grid by moving the pawn from a2 to a3 for the move "a2-a3"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]

        board_pawn_update_grid.update_grid('a2-a3')
        actual_grid = board_pawn_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end
    end

    context 'when the grid has a few pieces: normal and taking moves' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:black_king) { instance_double('Piece') }
      let(:black_rook) { instance_double('Piece') }
      let(:black_queen) { instance_double('Piece') }
      let(:black_knight) { instance_double('Piece') }
      let(:white_rook) { instance_double('Piece') }
      let(:white_king) { instance_double('Piece') }

      let(:grid_few) do
        [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [black_queen, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]
      end

      subject(:board_few_update_grid) { described_class.new(grid: grid_few, castling: nil, en_passant: nil, letter_to_piece: nil) }

      it 'updates the grid by moving the black knight from d4 to e6 for the move "Nd4-e6"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
                         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_queen, ' ', ' ', ' ', black_knight, ' ', ' ', ' '],
                         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
                         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]

        board_few_update_grid.update_grid('Nd4-e6')
        actual_grid = board_few_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by the black queen capturing from a6 to a7 for the move "Qa6xa7"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
                         [black_queen, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
                         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
                         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]

        board_few_update_grid.update_grid('Qa6xa7')
        actual_grid = board_few_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end
    end

    context 'when the grid has a few pieces: check and checkmate moves' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:black_king) { instance_double('Piece') }
      let(:black_rook) { instance_double('Piece') }
      let(:black_queen) { instance_double('Piece') }
      let(:black_knight) { instance_double('Piece') }
      let(:white_rook) { instance_double('Piece') }
      let(:white_king) { instance_double('Piece') }

      let(:grid_few) do
        [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [black_queen, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]
      end

      subject(:board_few_update_grid) { described_class.new(grid: grid_few, castling: nil, en_passant: nil, letter_to_piece: nil) }

      it 'updates the grid by moving the white rook from h1 to f1 with check for the move "Rh1-f1+"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
                         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_queen, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
                         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
                         [white_rook, ' ', ' ', ' ', white_king, white_rook, ' ', ' ']]

        board_few_update_grid.update_grid('Rh1-f1+')
        actual_grid = board_few_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by the black rook capturing from h8 to h1 with check for the move "Rh8xh1+"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_queen, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
                         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', white_pawn, ' ', ' ', ' '],
                         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', black_rook]]

        board_few_update_grid.update_grid('Rh8xh1+')
        actual_grid = board_few_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by the black queen capturing from a6 to e2 with checkmate for the move "Qa6xe2#"' do
        expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', black_rook],
                         [white_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', black_pawn, white_pawn, ' ', ' ', ' '],
                         [' ', ' ', ' ', black_knight, ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [white_pawn, ' ', ' ', ' ', black_queen, ' ', ' ', ' '],
                         [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]

        board_few_update_grid.update_grid('Qa6xe2#')
        actual_grid = board_few_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end
    end

    context 'when the grid has a few pieces: pawn promotion' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:black_knight) { instance_double('Piece') }
      let(:black_king) { instance_double('Piece') }
      let(:white_rook) { instance_double('Piece') }
      let(:white_king) { instance_double('Piece') }

      let(:white_bishop) { instance_double('Piece') }
      let(:white_knight) { instance_double('Piece') }
      let(:white_queen) { instance_double('Piece') }

      let(:black_bishop) { instance_double('Piece') }
      let(:black_rook) { instance_double('Piece') }
      let(:black_queen) { instance_double('Piece') }

      let(:grid_promotion) do
        [[' ', black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
         [white_pawn, white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [black_pawn, ' ', white_king, ' ', ' ', ' ', ' ', ' '],
         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]
      end

      let(:letter_to_piece) do
        { white: { 'B' => white_bishop, 'N' => white_knight, 'R' => white_rook, 'Q' => white_queen },
          black: { 'B' => black_bishop, 'N' => black_knight, 'R' => black_rook, 'Q' => black_queen } }
      end

      subject(:board_promotion_update_grid) { described_class.new(grid: grid_promotion, castling: nil, en_passant: nil, letter_to_piece:) }

      before do
        allow(white_pawn).to receive(:color).and_return(:white)
        allow(black_pawn).to receive(:color).and_return(:black)
        allow(black_knight).to receive(:color).and_return(:black)
        allow(black_king).to receive(:color).and_return(:black)
        allow(white_rook).to receive(:color).and_return(:white)
        allow(white_king).to receive(:color).and_return(:white)
        allow(white_bishop).to receive(:color).and_return(:white)
        allow(white_knight).to receive(:color).and_return(:white)
        allow(white_queen).to receive(:color).and_return(:white)
        allow(black_bishop).to receive(:color).and_return(:black)
        allow(black_rook).to receive(:color).and_return(:black)
        allow(black_queen).to receive(:color).and_return(:black)
      end

      it 'updates the grid by promoting the white pawn from a7 to a white bishop on a8 for the move "a7-a8=B"' do
        expected_grid = [[white_bishop, black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_pawn, ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a7-a8=B')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the white pawn from a7 to a white knight on a8 for the move "a7-a8=N"' do
        expected_grid = [[white_knight, black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_pawn, ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a7-a8=N')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the white pawn (by capturing) from a7 to a white rook on b8 with checkmate for the move "a7xb8=R#"' do
        expected_grid = [[' ', white_rook, ' ', ' ', ' ', black_king, ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_pawn, ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a7xb8=R#')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the white pawn (by capturing) from a7 to a white queen on b8 with checkmate for the move "a7xb8=Q#"' do
        expected_grid = [[' ', white_queen, ' ', ' ', ' ', black_king, ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [black_pawn, ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [' ', white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a7xb8=Q#')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the black pawn from a2 to a black queen on a1 for the move "a2-a1=Q"' do
        expected_grid = [[' ', black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [white_pawn, white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [black_queen, white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a2-a1=Q')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the black pawn from a2 to a black rook on a1 for the move "a2-a1=R"' do
        expected_grid = [[' ', black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [white_pawn, white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [black_rook, white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a2-a1=R')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the black pawn from a2 to a black knight on a1 with check for the move "a2-a1=N+"' do
        expected_grid = [[' ', black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [white_pawn, white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [black_knight, white_rook, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a2-a1=N+')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end

      it 'updates the grid by promoting the black pawn (by capturing) from a2 to a black bishop on b1 with check for the move "a2xb1=B+"' do
        expected_grid = [[' ', black_knight, ' ', ' ', ' ', black_king, ' ', ' '],
                         [white_pawn, white_rook, ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                         [' ', ' ', white_king, ' ', ' ', ' ', ' ', ' '],
                         [' ', black_bishop, ' ', ' ', ' ', ' ', ' ', ' ']]

        board_promotion_update_grid.update_grid('a2xb1=B+')
        actual_grid = board_promotion_update_grid.grid
        expect(actual_grid).to eql(expected_grid)
      end
    end

    context 'when the grid has a few pieces: Castling and En Passant' do
      context 'when white pieces are moved' do
        let(:white_pawn) { instance_double('Pawn') }
        let(:black_pawn) { instance_double('Pawn') }

        let(:black_king) { instance_double('Piece') }
        let(:white_rook) { instance_double('Piece') }
        let(:white_king) { instance_double('Piece') }

        let(:grid_few) do
          [[' ', ' ', ' ', ' ', ' ', black_king, ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', black_pawn, white_pawn, ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]
        end

        subject(:board_white_update_grid) { described_class.new(grid: grid_few, castling: nil, en_passant: nil, letter_to_piece: nil) }

        it 'updates the grid by doing white queen-side castling for the move "O-O-Ow"' do
          expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', black_pawn, white_pawn, ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', white_king, white_rook, ' ', ' ', ' ', white_rook]]

          board_white_update_grid.update_grid('O-O-Ow')
          actual_grid = board_white_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end

        it 'updates the grid by doing white king-side castling with check for the move "O-O+w"' do
          expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', black_pawn, white_pawn, ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [white_rook, ' ', ' ', ' ', ' ', white_rook, white_king, ' ']]

          board_white_update_grid.update_grid('O-O+w')
          actual_grid = board_white_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end

        it 'updates the grid by the white pawn on c5 taking the black pawn on b5 en passant for the move "c5xb6"' do
          expected_grid = [[' ', ' ', ' ', ' ', ' ', black_king, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', white_pawn, ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [white_rook, ' ', ' ', ' ', white_king, ' ', ' ', white_rook]]

          board_white_update_grid.update_grid('c5xb6')
          actual_grid = board_white_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end
      end

      context 'when black pieces are moved' do
        let(:white_pawn) { instance_double('Pawn') }
        let(:black_pawn) { instance_double('Pawn') }

        let(:black_king) { instance_double('Piece') }
        let(:black_rook) { instance_double('Piece') }
        let(:black_queen) { instance_double('Piece') }
        let(:white_king) { instance_double('Piece') }

        let(:grid_few) do
          [[black_rook, ' ', ' ', ' ', black_king, ' ', ' ', black_rook],
           [' ', ' ', ' ', ' ', black_queen, ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', black_pawn, white_pawn, ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
           [' ', ' ', ' ', ' ', white_king, ' ', ' ', ' ']]
        end

        subject(:board_black_update_grid) { described_class.new(grid: grid_few, castling: nil, en_passant: nil, letter_to_piece: nil) }

        it 'updates the grid by doing black queen-side castling for the move "O-O-Ob"' do
          expected_grid = [[' ', ' ', black_king, black_rook, ' ', ' ', ' ', black_rook],
                           [' ', ' ', ' ', ' ', black_queen, ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', black_pawn, white_pawn, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', white_king, ' ', ' ', ' ']]

          board_black_update_grid.update_grid('O-O-Ob')
          actual_grid = board_black_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end

        it 'updates the grid by doing black king-side castling for the move "O-Ob"' do
          expected_grid = [[black_rook, ' ', ' ', ' ', ' ', black_rook, black_king, ' '],
                           [' ', ' ', ' ', ' ', black_queen, ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', black_pawn, white_pawn, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', white_king, ' ', ' ', ' ']]

          board_black_update_grid.update_grid('O-Ob')
          actual_grid = board_black_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end

        it 'updates the grid by the black pawn on e4 taking the white pawn on f4 en passant with check for the move "e4xf3+"' do
          expected_grid = [[black_rook, ' ', ' ', ' ', black_king, ' ', ' ', black_rook],
                           [' ', ' ', ' ', ' ', black_queen, ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', black_pawn, ' ', ' '],
                           [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                           [' ', ' ', ' ', ' ', white_king, ' ', ' ', ' ']]

          board_black_update_grid.update_grid('e4xf3+')
          actual_grid = board_black_update_grid.grid
          expect(actual_grid).to eql(expected_grid)
        end
      end
    end
  end

  describe '#update_castling' do
    # Incoming Command Message -> Test change of observable state

    context 'when castling is empty' do
      let(:castling_empty) { { white: [], black: [] } }

      subject(:board_empty_update_castling) { described_class.new(grid: nil, castling: castling_empty, en_passant: nil, letter_to_piece: nil) }

      it 'updates castling to { white: [], black: [] } for the move "b2-b3"' do
        board_empty_update_castling.update_castling('b2-b3')
        actual_castling = board_empty_update_castling.castling
        expect(actual_castling).to match({ white: [], black: [] })
      end
    end

    context 'when castling contains one move for white' do
      let(:castling_one_move) { { white: ['O-O-O'], black: [] } }

      subject(:board_one_move_update_castling) { described_class.new(grid: nil, castling: castling_one_move, en_passant: nil, letter_to_piece: nil) }

      it 'updates castling to { white: ["O-O-O"], black: [] } for the move "b2-b3"' do
        board_one_move_update_castling.update_castling('b2-b3')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: [] })
      end

      it 'updates castling to { white: ["O-O-O"], black: [] } for the move "b7-b5"' do
        board_one_move_update_castling.update_castling('b7-b5')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: [] })
      end

      it 'updates castling to { white: [], black: [] } for the move "O-O-O+w"' do
        board_one_move_update_castling.update_castling('O-O-O+w')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: [], black: [] })
      end

      it 'updates castling to { white: [], black: [] } for the move "Ra1-b1"' do
        board_one_move_update_castling.update_castling('Ra1-b1')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: [], black: [] })
      end

      it 'updates castling to { white: ["O-O-O"], black: [] } for the move "Rh1-g1"' do
        board_one_move_update_castling.update_castling('Rh1-g1')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: [] })
      end

      it 'updates castling to { white: [], black: [] } for the move "Ke1-f2"' do
        board_one_move_update_castling.update_castling('Ke1-f2')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: [], black: [] })
      end

      it 'updates castling to { white: ["O-O-O"], black: [] } for the move "Ke8-d8"' do
        board_one_move_update_castling.update_castling('Ke8-d8')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: [] })
      end

      it 'updates castling to { white: [], black: [] } for the move "Qa8xa1+"' do
        board_one_move_update_castling.update_castling('Qa8xa1+')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: [], black: [] })
      end

      it 'updates castling to { white: ["O-O-O"], black: [] } for the move "Qh8xh1"' do
        board_one_move_update_castling.update_castling('Qh8xh1')
        actual_castling = board_one_move_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: [] })
      end
    end

    context 'when castling contains full castling moves' do
      let(:castling_full) { { white: %w[O-O O-O-O], black: %w[O-O O-O-O] } }

      subject(:board_full_update_castling) { described_class.new(grid: nil, castling: castling_full, en_passant: nil, letter_to_piece: nil) }

      it 'updates castling to { white: ["O-O", "O-O-O"], black: ["O-O", "O-O-O"] } for the move "b2-b3"' do
        board_full_update_castling.update_castling('b2-b3')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: ["O-O", "O-O-O"] } for the move "b7-b5"' do
        board_full_update_castling.update_castling('b7-b5')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: [], black: ["O-O", "O-O-O"] } for the move "O-O-Ow"' do
        board_full_update_castling.update_castling('O-O-Ow')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: [], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: [], black: ["O-O", "O-O-O"] } for the move "O-Ow"' do
        board_full_update_castling.update_castling('O-Ow')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: [], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: [] } for the move "O-O-Ob"' do
        board_full_update_castling.update_castling('O-O-Ob')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: [] })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: [] } for the move "O-Ob"' do
        board_full_update_castling.update_castling('O-Ob')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: [] })
      end

      it 'updates castling to { white: [], black: ["O-O", "O-O-O"] } for the move "Ke1-f2"' do
        board_full_update_castling.update_castling('Ke1-f2')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: [], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: [] } for the move "Ke8-d8"' do
        board_full_update_castling.update_castling('Ke8-d8')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: [] })
      end

      it 'updates castling to { white: ["O-O"], black: ["O-O", "O-O-O"] } for the move "Ra1-b1"' do
        board_full_update_castling.update_castling('Ra1-b1')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O'], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O-O"], black: ["O-O", "O-O-O"] } for the move "Rh1-g1"' do
        board_full_update_castling.update_castling('Rh1-g1')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: ["O-O"] } for the move "Ra8-b8"' do
        board_full_update_castling.update_castling('Ra8-b8')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: ['O-O'] })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: ["O-O-O"] } for the move "Rh8-g8"' do
        board_full_update_castling.update_castling('Rh8-g8')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: ['O-O-O'] })
      end

      it 'updates castling to { white: ["O-O"], black: ["O-O"] } for the move "Ra1xa8"' do
        board_full_update_castling.update_castling('Ra1xa8')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O'], black: ['O-O'] })
      end

      it 'updates castling to { white: ["O-O", "O-O-O"], black: ["O-O-O"] } for the move "Qh2xh8+"' do
        board_full_update_castling.update_castling('Qh2xh8+')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: contain_exactly('O-O', 'O-O-O'), black: ['O-O-O'] })
      end

      it 'updates castling to { white: ["O-O"], black: ["O-O", "O-O-O"] } for the move "Bg7xa1"' do
        board_full_update_castling.update_castling('Bg7xa1')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O'], black: contain_exactly('O-O', 'O-O-O') })
      end

      it 'updates castling to { white: ["O-O-O"], black: ["O-O-O"] } for the move "Rh8xh1#"' do
        board_full_update_castling.update_castling('Rh8xh1#')
        actual_castling = board_full_update_castling.castling
        expect(actual_castling).to match({ white: ['O-O-O'], black: ['O-O-O'] })
      end
    end
  end

  describe '#update_en_passant' do
    # Incoming Command Message -> Test change of observable state

    context 'when it is the white player turn' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:black_king) { instance_double('Piece') }
      let(:white_queen) { instance_double('Piece') }
      let(:white_king) { instance_double('Piece') }

      let(:grid_white) do
        [[' ', ' ', ' ', ' ', black_king, ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', black_pawn, white_pawn, black_pawn, white_pawn, ' '],
         [black_pawn, ' ', black_pawn, ' ', ' ', ' ', ' ', ' '],
         [black_pawn, ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', white_pawn, ' ', white_pawn, white_queen, ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', white_king, ' ', ' ', ' ']]
      end

      before do
        allow(black_pawn).to receive(:color).and_return(:black)
        allow(black_pawn).to receive(:en_passant_left).with([2, 3]).and_return(['c4xb3'])
        allow(black_pawn).to receive(:en_passant_right).with([0, 3]).and_return(['a4xb3'])
        allow(black_pawn).to receive(:en_passant_right).with([2, 3]).and_return(['c4xd3'])
      end

      context 'when there are no En Passant moves: { white: [], black: [] }' do
        let(:en_passant_white_none) { { white: [], black: [] } }

        subject(:board_white_none) { described_class.new(grid: grid_white, castling: nil, en_passant: en_passant_white_none, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "Qe2-g4"' do
          board_white_none.update_en_passant('Qe2-g4')
          actual_en_passant = board_white_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "b2-b3"' do
          board_white_none.update_en_passant('b2-b3')
          actual_en_passant = board_white_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "Ke1-f1"' do
          board_white_none.update_en_passant('Ke1-f1')
          actual_en_passant = board_white_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: ["c4xd3"] } for the move "d2-d4"' do
          board_white_none.update_en_passant('d2-d4')
          actual_en_passant = board_white_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: ['c4xd3'] })
        end

        it 'updates en_passant to { white: [], black: ["a4xb3", "c4xb3"] } for the move "b2-b4"' do
          board_white_none.update_en_passant('b2-b4')
          actual_en_passant = board_white_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: contain_exactly('a4xb3', 'c4xb3') })
        end
      end

      context 'when there is one En Passant move: { white: ["e5xd6"], black: [] }' do
        let(:en_passant_white_one) { { white: ['e5xd6'], black: [] } }

        subject(:board_white_one) { described_class.new(grid: grid_white, castling: nil, en_passant: en_passant_white_one, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "Qe2-g4"' do
          board_white_one.update_en_passant('Qe2-g4')
          actual_en_passant = board_white_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "e5xd6+"' do
          board_white_one.update_en_passant('e5xd6+')
          actual_en_passant = board_white_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: ["c4xd3"] } for the move "d2-d4"' do
          board_white_one.update_en_passant('d2-d4')
          actual_en_passant = board_white_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: ['c4xd3'] })
        end

        it 'updates en_passant to { white: [], black: ["a4xb3", "c4xb3"] } for the move "b2-b4"' do
          board_white_one.update_en_passant('b2-b4')
          actual_en_passant = board_white_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: contain_exactly('a4xb3', 'c4xb3') })
        end
      end

      context 'when there are two En Passant moves: { white: ["e5xf6", "g5xf6"], black: [] }' do
        let(:en_passant_white_two) { { white: %w[e5xf6 g5xf6], black: [] } }

        subject(:board_white_two) { described_class.new(grid: grid_white, castling: nil, en_passant: en_passant_white_two, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "Qe2-g4"' do
          board_white_two.update_en_passant('Qe2-g4')
          actual_en_passant = board_white_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "e5xf6+"' do
          board_white_two.update_en_passant('e5xf6+')
          actual_en_passant = board_white_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "g5xf6"' do
          board_white_two.update_en_passant('g5xf6')
          actual_en_passant = board_white_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: ["c4xd3"] } for the move "d2-d4"' do
          board_white_two.update_en_passant('d2-d4')
          actual_en_passant = board_white_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: ['c4xd3'] })
        end

        it 'updates en_passant to { white: [], black: ["a4xb3", "c4xb3"] } for the move "b2-b4"' do
          board_white_two.update_en_passant('b2-b4')
          actual_en_passant = board_white_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: contain_exactly('a4xb3', 'c4xb3') })
        end
      end
    end

    context 'when it is the black player turn' do
      let(:white_pawn) { instance_double('Pawn') }
      let(:black_pawn) { instance_double('Pawn') }

      let(:black_king) { instance_double('Piece') }
      let(:white_king) { instance_double('Piece') }
      let(:black_rook) { instance_double('Piece') }

      let(:grid_black) do
        [[' ', ' ', ' ', ' ', black_king, ' ', ' ', ' '],
         [white_king, ' ', ' ', black_pawn, black_rook, black_pawn, ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', white_pawn, ' ', white_pawn, ' '],
         [black_pawn, white_pawn, black_pawn, white_pawn, ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
         [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
      end

      before do
        allow(white_pawn).to receive(:color).and_return(:white)
        allow(white_pawn).to receive(:en_passant_left).with([4, 4]).and_return(['e5xd6'])
        allow(white_pawn).to receive(:en_passant_left).with([6, 4]).and_return(['g5xf6'])
        allow(white_pawn).to receive(:en_passant_right).with([4, 4]).and_return(['e5xf6'])
      end

      context 'when there are no En Passant moves: { white: [], black: [] }' do
        let(:en_passant_black_none) { { white: [], black: [] } }

        subject(:board_black_none) { described_class.new(grid: grid_black, castling: nil, en_passant: en_passant_black_none, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "d7-d6+"' do
          board_black_none.update_en_passant('d7-d6+')
          actual_en_passant = board_black_none.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: ["e5xd6"], black: [] } for the move "d7-d5+"' do
          board_black_none.update_en_passant('d7-d5+')
          actual_en_passant = board_black_none.en_passant
          expect(actual_en_passant).to match({ white: ['e5xd6'], black: [] })
        end

        it 'updates en_passant to { white: ["e5xf6", "g5xf6"], black: [] } for the move "f7-f5"' do
          board_black_none.update_en_passant('f7-f5')
          actual_en_passant = board_black_none.en_passant
          expect(actual_en_passant).to match({ white: contain_exactly('e5xf6', 'g5xf6'), black: [] })
        end
      end

      context 'when there is one En Passant move: { white: [], black: ["c4xd3"] }' do
        let(:en_passant_black_one) { { white: [], black: ['c4xd3'] } }

        subject(:board_black_one) { described_class.new(grid: grid_black, castling: nil, en_passant: en_passant_black_one, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "d7-d6+"' do
          board_black_one.update_en_passant('d7-d6+')
          actual_en_passant = board_black_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "c4xd3"' do
          board_black_one.update_en_passant('c4xd3')
          actual_en_passant = board_black_one.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: ["e5xd6"], black: [] } for the move "d7-d5+"' do
          board_black_one.update_en_passant('d7-d5+')
          actual_en_passant = board_black_one.en_passant
          expect(actual_en_passant).to match({ white: ['e5xd6'], black: [] })
        end

        it 'updates en_passant to { white: ["e5xf6", "g5xf6"], black: [] } for the move "f7-f5"' do
          board_black_one.update_en_passant('f7-f5')
          actual_en_passant = board_black_one.en_passant
          expect(actual_en_passant).to match({ white: contain_exactly('e5xf6', 'g5xf6'), black: [] })
        end
      end

      context 'when there are two En Passant moves: { white: [], black: ["a4xb3", "c4xb3"] }' do
        let(:en_passant_black_two) { { white: [], black: %w[a4xb3 c4xb3] } }

        subject(:board_black_two) { described_class.new(grid: grid_black, castling: nil, en_passant: en_passant_black_two, letter_to_piece: nil) }

        it 'updates en_passant to { white: [], black: [] } for the move "d7-d6+"' do
          board_black_two.update_en_passant('d7-d6+')
          actual_en_passant = board_black_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "a4xb3"' do
          board_black_two.update_en_passant('a4xb3')
          actual_en_passant = board_black_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: [], black: [] } for the move "c4xb3"' do
          board_black_two.update_en_passant('c4xb3')
          actual_en_passant = board_black_two.en_passant
          expect(actual_en_passant).to match({ white: [], black: [] })
        end

        it 'updates en_passant to { white: ["e5xd6"], black: [] } for the move "d7-d5+"' do
          board_black_two.update_en_passant('d7-d5+')
          actual_en_passant = board_black_two.en_passant
          expect(actual_en_passant).to match({ white: ['e5xd6'], black: [] })
        end

        it 'updates en_passant to { white: ["e5xf6", "g5xf6"], black: [] } for the move "f7-f5"' do
          board_black_two.update_en_passant('f7-f5')
          actual_en_passant = board_black_two.en_passant
          expect(actual_en_passant).to match({ white: contain_exactly('e5xf6', 'g5xf6'), black: [] })
        end
      end
    end
  end
end

# Notes:
# - For 50 move and 3-fold rules for declaring a draw, need move and state history stored in Game
# - Write separate tests for default Board instance variables:
#     Treat initialize as a script method and test default values of instance variables
#     and outgoing command messages to create piece instance variables.
#     X - Better to view as simple init of instance variables
#       - So always pass in nil for anything not used, as if no defaults in tests
#       - Now simply write code for init with default values in ()
#
# - Maybe refactor them for coord. Maybe hash or swap coordinate indexes. Could do later...
# - Can also think about a ' ' piece for empty squares to send the print_color message, etc.
# - Could think about a refactor in Board; Grid class? Plenty of private methods and could contain pieces
# - Don't worry about any more refactoring now; better to finish the project and see what the refactoring
#   should be from there (if it is even worth doing). For now, just add private methods to simplify!
