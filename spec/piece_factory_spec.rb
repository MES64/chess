# frozen_string_literal: true

require_relative '../lib/piece_factory'
require_relative '../lib/piece'

RSpec.describe PieceFactory do
  describe '#create_piece' do
    # Incoming Query Message -> Test value returned
    #
    # Why Query Message?
    # This is because I am only interested in this method returning a Piece object
    # (ignoring any complications about how this could also be a change in observable state).
    #
    # Why no instance doubles and method stubs?
    # It is impossible to use an instance double of Piece here since this needs to be created
    # in the tests but I need to test that it is created with the correct instance variables
    # within the code... Therefore, the Piece object is actually created in the code without
    # stubbing Piece.new. If there were any objects that Piece relied on, instance doubles of
    # these would be created instead, but since there are not any outside of the primitive ones
    # then no instance doubles are created and nothing is stubbed in these tests!

    subject(:piece_factory) { described_class.new }

    it 'returns a white Rook piece given color: :white, letter: "R"' do
      white_rook = piece_factory.create_piece(color: :white, letter: 'R')
      expect(white_rook).to be_kind_of(Piece)
      expect(white_rook.color).to eql(:white)
      expect(white_rook.letter).to eql('R')
      expect(white_rook.icon).to eql('♖')
      expect(white_rook.moveset).to contain_exactly([-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                                                    [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                                                    [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                                                    [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7])
    end

    it 'returns a black Rook piece given color: :black, letter: "R"' do
      black_rook = piece_factory.create_piece(color: :black, letter: 'R')
      expect(black_rook).to be_kind_of(Piece)
      expect(black_rook.color).to eql(:black)
      expect(black_rook.letter).to eql('R')
      expect(black_rook.icon).to eql('♜')
      expect(black_rook.moveset).to contain_exactly([-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                                                    [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                                                    [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                                                    [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7])
    end

    it 'returns a white Knight piece given color: :white, letter: "N"' do
      white_knight = piece_factory.create_piece(color: :white, letter: 'N')
      expect(white_knight).to be_kind_of(Piece)
      expect(white_knight.color).to eql(:white)
      expect(white_knight.letter).to eql('N')
      expect(white_knight.icon).to eql('♘')
      expect(white_knight.moveset).to contain_exactly([-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2])
    end

    it 'returns a black Knight piece given color: :black, letter: "N"' do
      black_knight = piece_factory.create_piece(color: :black, letter: 'N')
      expect(black_knight).to be_kind_of(Piece)
      expect(black_knight.color).to eql(:black)
      expect(black_knight.letter).to eql('N')
      expect(black_knight.icon).to eql('♞')
      expect(black_knight.moveset).to contain_exactly([-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2])
    end

    it 'returns a white Bishop piece given color: :white, letter: "B"' do
      white_bishop = piece_factory.create_piece(color: :white, letter: 'B')
      expect(white_bishop).to be_kind_of(Piece)
      expect(white_bishop.color).to eql(:white)
      expect(white_bishop.letter).to eql('B')
      expect(white_bishop.icon).to eql('♗')
      expect(white_bishop.moveset).to contain_exactly([-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                                                      [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                                                      [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                                                      [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7])
    end

    it 'returns a black Bishop piece given color: :black, letter: "B"' do
      black_bishop = piece_factory.create_piece(color: :black, letter: 'B')
      expect(black_bishop).to be_kind_of(Piece)
      expect(black_bishop.color).to eql(:black)
      expect(black_bishop.letter).to eql('B')
      expect(black_bishop.icon).to eql('♝')
      expect(black_bishop.moveset).to contain_exactly([-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                                                      [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                                                      [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                                                      [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7])
    end

    it 'returns a white Queen piece given color: :white, letter: "Q"' do
      white_queen = piece_factory.create_piece(color: :white, letter: 'Q')
      expect(white_queen).to be_kind_of(Piece)
      expect(white_queen.color).to eql(:white)
      expect(white_queen.letter).to eql('Q')
      expect(white_queen.icon).to eql('♕')
      expect(white_queen.moveset).to contain_exactly([-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                                                     [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                                                     [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                                                     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                                                     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                                                     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                                                     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                                                     [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7])
    end

    it 'returns a black Queen piece given color: :black, letter: "Q"' do
      black_queen = piece_factory.create_piece(color: :black, letter: 'Q')
      expect(black_queen).to be_kind_of(Piece)
      expect(black_queen.color).to eql(:black)
      expect(black_queen.letter).to eql('Q')
      expect(black_queen.icon).to eql('♛')
      expect(black_queen.moveset).to contain_exactly([-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                                                     [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                                                     [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                                                     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                                                     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                                                     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                                                     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                                                     [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7])
    end

    it 'returns a white King piece given color: :white, letter: "K"' do
      white_king = piece_factory.create_piece(color: :white, letter: 'K')
      expect(white_king).to be_kind_of(Piece)
      expect(white_king.color).to eql(:white)
      expect(white_king.letter).to eql('K')
      expect(white_king.icon).to eql('♔')
      expect(white_king.moveset).to contain_exactly([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [1, -1], [-1, 1], [1, 1])
    end

    it 'returns a black King piece given color: :black, letter: "K"' do
      black_king = piece_factory.create_piece(color: :black, letter: 'K')
      expect(black_king).to be_kind_of(Piece)
      expect(black_king.color).to eql(:black)
      expect(black_king.letter).to eql('K')
      expect(black_king.icon).to eql('♚')
      expect(black_king.moveset).to contain_exactly([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [1, -1], [-1, 1], [1, 1])
    end

    it 'returns a white Pawn piece given color: :white, letter: ""' do
      white_pawn = piece_factory.create_piece(color: :white, letter: '')
      expect(white_pawn).to be_kind_of(Piece)
      expect(white_pawn.color).to eql(:white)
      expect(white_pawn.letter).to eql('')
      expect(white_pawn.icon).to eql('♙')
      expect(white_pawn.moveset).to contain_exactly([0, 1], [0, 2], [-1, 1], [1, 1])
    end

    it 'returns a black Pawn piece given color: :black, letter: ""' do
      black_pawn = piece_factory.create_piece(color: :black, letter: '')
      expect(black_pawn).to be_kind_of(Piece)
      expect(black_pawn.color).to eql(:black)
      expect(black_pawn.letter).to eql('')
      expect(black_pawn.icon).to eql('♟')
      expect(black_pawn.moveset).to contain_exactly([0, -1], [0, -2], [-1, -1], [1, -1])
    end

    it 'raises an error if the color is :red, not :white or :black' do
      expect { piece_factory.create_piece(color: :red, letter: '') }.to raise_error('Invalid color!')
    end

    it 'raises an error if the color is :blue, not :white or :black' do
      expect { piece_factory.create_piece(color: :blue, letter: '') }.to raise_error('Invalid color!')
    end

    # 2 tests for error for invalid letter

    # 1 test for error for both invalid color and letter
  end
end
