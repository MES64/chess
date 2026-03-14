# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/human_player'

RSpec.describe Game do
  describe '#copy_board' do
    # Outgoing Command Message -> Test message sent

    let(:board_class) { instance_double('Class') }

    before do
      allow(board_class).to receive(:new)
    end

    context 'given a random board' do
      let(:board) { instance_double('Board') }
      let(:grid) do
        [%w[a3 b3 c3],
         %w[a2 b2 c2],
         %w[a1 b1 c1]]
      end
      let(:castling) { { white: ['O-O', 'O-O-O'], black: ['O-O-O'] } }
      let(:en_passant) { { white: ['move'], black: [] } }
      let(:letter_to_piece) do
        { white: { 'B' => 'WHITE_BISHOP', 'N' => 'WHITE_KNIGHT' },
          black: { 'B' => 'BLACK_BISHOP', 'N' => 'BLACK_KNIGHT' } }
      end

      before do
        allow(board).to receive(:grid_copy).and_return(grid)
        allow(board).to receive(:castling_copy).and_return(castling)
        allow(board).to receive(:en_passant_copy).and_return(en_passant)
        allow(board).to receive(:letter_to_piece).and_return(letter_to_piece)
      end

      subject(:game_copy) { described_class.new(board:, board_class:) }

      it 'sends new to the Board class with deep copies of instance variables of original board' do
        expect(board_class).to receive(:new).with(grid:, castling:, en_passant:, letter_to_piece:)
        game_copy.copy_board
      end
    end

    context 'given a different random board' do
      let(:board) { instance_double('Board') }
      let(:grid) do
        [%w[d3 e3 f3],
         %w[d2 e2 f2],
         %w[d1 e1 f1]]
      end
      let(:castling) { { white: ['O-O-O'], black: [] } }
      let(:en_passant) { { white: [], black: [] } }
      let(:letter_to_piece) do
        { white: { 'R' => 'WHITE_ROOK', 'Q' => 'WHITE_QUEEN' },
          black: { 'R' => 'BLACK_ROOK', 'Q' => 'BLACK_QUEEN' } }
      end

      before do
        allow(board).to receive(:grid_copy).and_return(grid)
        allow(board).to receive(:castling_copy).and_return(castling)
        allow(board).to receive(:en_passant_copy).and_return(en_passant)
        allow(board).to receive(:letter_to_piece).and_return(letter_to_piece)
      end

      subject(:game_copy) { described_class.new(board:, board_class:) }

      it 'sends new to the Board class with deep copies of instance variables of original board' do
        expect(board_class).to receive(:new).with(grid:, castling:, en_passant:, letter_to_piece:)
        game_copy.copy_board
      end
    end
  end

  describe '#update_board' do
    # Outgoing Command Message -> Test message sent

    let(:board) { instance_double('Board') }

    before do
      allow(board).to receive(:update)
    end

    subject(:game_update_board) { described_class.new(board:) }

    it 'sends #update to board with "a2-a3" given the move "a2-a3"' do
      expect(board).to receive(:update).with('a2-a3')
      game_update_board.update_board('a2-a3')
    end

    it 'sends #update to board with "Rh8-h1+" given the move "Rh8-h1+"' do
      expect(board).to receive(:update).with('Rh8-h1+')
      game_update_board.update_board('Rh8-h1+')
    end
  end

  describe '#update_given_board' do
    # Outgoing Command Message -> Test message sent

    let(:board) { instance_double('Board') }

    before do
      allow(board).to receive(:update)
    end

    subject(:game_update_given_board) { described_class.new }

    it 'sends #update to board with "a2-a3" given the board and the move "a2-a3"' do
      expect(board).to receive(:update).with('a2-a3')
      game_update_given_board.update_given_board(board, 'a2-a3')
    end

    it 'sends #update to board with "Rh8-h1+" given the board and the move "Rh8-h1+"' do
      expect(board).to receive(:update).with('Rh8-h1+')
      game_update_given_board.update_given_board(board, 'Rh8-h1+')
    end
  end

  describe '#update_moveset' do
    # Incoming Command Message -> Test change in observable state

    let(:board) { instance_double('Board') }

    subject(:game_moveset) { described_class.new(board:, moveset: { white: [], black: [] }) }

    before do
      # This allows nothing to happen for cases where the kings are safe, making stubbing all cases easier
      allow(game_moveset).to receive(:next_board_info).and_return({ moveset: { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f2 Ke1-f1], black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f7 Ke8-f8] }, king_locations: { white: 'e1', black: 'e8' } })
    end

    context 'when the board is empty' do
      # 8 . . . . . . . .
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 . . . . . . . .
      #   a b c d e f g h

      before do
        allow(board).to receive(:moveset).and_return({ white: [], black: [] })
        allow(board).to receive(:king_locations).and_return({ white: ' ', black: ' ' })
      end

      context 'when the initial game.moveset is empty' do
        subject(:game_moveset_empty) { described_class.new(board:, moveset: { white: [], black: [] }) }

        it 'updates the game.moveset to be empty' do
          game_moveset_empty.update_moveset
          actual_moveset = game_moveset_empty.moveset
          expect(actual_moveset).to match({ white: [], black: [] })
        end
      end

      context 'when the initial game.moveset is { white: ["a2-a3", "a2-a4"], black: ["a7-a6", "a7-a5"] }' do
        subject(:game_moveset_not_empty) { described_class.new(board:, moveset: { white: %w[a2-a3 a2-a4], black: %w[a7-a6 a7-a5] }) }

        it 'updates the game.moveset to be empty' do
          game_moveset_not_empty.update_moveset
          actual_moveset = game_moveset_not_empty.moveset
          expect(actual_moveset).to match({ white: [], black: [] })
        end
      end
    end

    context 'when there is one white pawn and one black pawn' do
      # 8 . . . . . . . .
      # 7 ♙ . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . . . . . .
      # 1 . . . . . . . .
      #   a b c d e f g h

      before do
        allow(board).to receive(:moveset).and_return({ white: %w[a2-a3 a2-a4], black: %w[a7-a6 a7-a5] })
        allow(board).to receive(:king_locations).and_return({ white: ' ', black: ' ' })
      end

      it 'updates the game.moveset to { white: ["a2-a3", "a2-a4"], black: ["a7-a6", "a7-a5"] }' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly('a2-a3', 'a2-a4'), black: contain_exactly('a7-a6', 'a7-a5') })
      end
    end

    context 'when white can check black' do
      # 8 . . . . . . . ♔
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 ♜ . . . . . . .
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ra1-a2 Ra1-a3 Ra1-a4 Ra1-a5 Ra1-a6 Ra1-a7 Ra1-a8
                    Ra1-b1 Ra1-c1 Ra1-d1 Ra1-e1 Ra1-f1 Ra1-g1 Ra1-h1],
          black: %w[Kh8-g8 Kh8-g7 Kh8-h7] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: ' ', black: 'h8' })

        allow(game_moveset).to receive(:next_board_info).with('Ra1-a8').and_return(
          { moveset: { white: %w[Ra8-a7 Ra8-a6 Ra8-a5 Ra8-a4 Ra8-a3 Ra8-a2 Ra8-a1
                                 Ra8-b8 Ra8-c8 Ra8-d8 Ra8-e8 Ra8-f8 Ra8-g8 Ra8xh8],
                       black: %w[Kh8-g8 Kh8-g7 Kh8-h7] },
            king_locations: { white: ' ', black: 'h8' } }
        )
        allow(game_moveset).to receive(:next_board_info).with('Ra1-h1').and_return(
          { moveset: { white: %w[Rh1-g1 Rh1-f1 Rh1-e1 Rh1-d1 Rh1-c1 Rh1-b1 Rh1-a1
                                 Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1-h7 Rh1xh8],
                       black: %w[Kh8-g8 Kh8-g7 Kh8-h7] },
            king_locations: { white: ' ', black: 'h8' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Ra1-a2 Ra1-a3 Ra1-a4 Ra1-a5 Ra1-a6 Ra1-a7 Ra1-a8+
                    Ra1-b1 Ra1-c1 Ra1-d1 Ra1-e1 Ra1-f1 Ra1-g1 Ra1-h1+],
          black: %w[Kh8-g8 Kh8-g7 Kh8-h7] }
      end

      it 'updates the game.moveset to the board.moveset with added check: "Ra1-a8+", "Ra1-h1+"' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when black can check white' do
      # 8 . . . . . . . .
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 . ♗ . . . . . ♚
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Kh1-g1 Kh1-g2 Kh1-h2],
          black: %w[Bb1-a2 Bb1-c2 Bb1-d3 Bb1-e4 Bb1-f5 Bb1-g6 Bb1-h7] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'h1', black: ' ' })

        allow(game_moveset).to receive(:next_board_info).with('Bb1-e4').and_return(
          { moveset: { white: %w[Kh1-g1 Kh1-g2 Kh1-h2],
                       black: %w[Be4-b1 Be4-c2 Be4-d3 Be4-f5 Be4-g6 Be4-h7
                                 Be4-a8 Be4-b7 Be4-c6 Be4-d5 Be4-f3 Be4-g2 Be4xh1] },
            king_locations: { white: 'h1', black: ' ' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Kh1-g1 Kh1-g2 Kh1-h2],
          black: %w[Bb1-a2 Bb1-c2 Bb1-d3 Bb1-e4+ Bb1-f5 Bb1-g6 Bb1-h7] }
      end

      it 'updates the game.moveset to the board.moveset with added check: "Bb1-e4+"' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when white can move King into check' do
      # 8 . . . . ♖ . . .
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . ♞ . . .
      # 1 . . . . ♚ . . .
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-f1 Ke1-f2
                    Ne2-c1 Ne2-g1 Ne2-c3 Ne2-g3 Ne2-d4 Ne2-f4],
          black: %w[Re8-a8 Re8-b8 Re8-c8 Re8-d8 Re8-f8 Re8-g8 Re8-h8
                    Re8-e7 Re8-e6 Re8-e5 Re8-e4 Re8-e3 Re8xe2] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: ' ' })

        allow(game_moveset).to receive(:next_board_info).with('Re8xe2').and_return(
          { moveset: { white: %w[Ke1-d1 Ke1-d2 Ke1-f1 Ke1-f2 Ke1xe2],
                       black: %w[Re2-a2 Re2-b2 Re2-c2 Re2-d2 Re2-f2 Re2-g2 Re2-h2
                                 Re2-e8 Re2-e7 Re2-e6 Re2-e5 Re2-e4 Re2-e3 Re2xe1] },
            king_locations: { white: 'e1', black: ' ' } }
        )

        # Stub for all white knight moves; put anything for next white knight moves as it's irrelevant
        allow(game_moveset).to receive(:next_board_info).with(/Ne2-/).and_return(
          { moveset: { white: %w[Ke1-d1 Ke1-d2 Ke1-f1 Ke1-f2 Ke1-e2
                                 Nc1-e2],
                       black: %w[Re8-a8 Re8-b8 Re8-c8 Re8-d8 Re8-f8 Re8-g8 Re8-h8
                                 Re8-e7 Re8-e6 Re8-e5 Re8-e4 Re8-e3 Re8-e2 Re8xe1] },
            king_locations: { white: 'e1', black: ' ' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-f1 Ke1-f2],
          black: %w[Re8-a8 Re8-b8 Re8-c8 Re8-d8 Re8-f8 Re8-g8 Re8-h8
                    Re8-e7 Re8-e6 Re8-e5 Re8-e4 Re8-e3 Re8xe2+] }
      end

      it 'updates the game.moveset to the board.moveset minus all white knight moves (with added check: "Re8xe2+")' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when black can leave King in check' do
      # 8 . . . . . . . ♔
      # 7 ♙ . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 . . . . . . . ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Rh1-a1 Rh1-b1 Rh1-c1 Rh1-d1 Rh1-e1 Rh1-f1 Rh1-g1
                    Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1-h7 Rh1xh8],
          black: %w[Kh8-g8 Kh8-g7 Kh8-h7
                    a7-a6 a7-a5] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: ' ', black: 'h8' })

        # Pawn moves
        allow(game_moveset).to receive(:next_board_info).with('a7-a6').and_return(
          { moveset: { white: %w[Rh1-a1 Rh1-b1 Rh1-c1 Rh1-d1 Rh1-e1 Rh1-f1 Rh1-g1
                                 Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1-h7 Rh1xh8],
                       black: %w[Kh8-g8 Kh8-g7 Kh8-h7
                                 a6-a5] },
            king_locations: { white: ' ', black: 'h8' } }
        )
        allow(game_moveset).to receive(:next_board_info).with('a7-a5').and_return(
          { moveset: { white: %w[Rh1-a1 Rh1-b1 Rh1-c1 Rh1-d1 Rh1-e1 Rh1-f1 Rh1-g1
                                 Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1-h7 Rh1xh8],
                       black: %w[Kh8-g8 Kh8-g7 Kh8-h7
                                 a5-a4] },
            king_locations: { white: ' ', black: 'h8' } }
        )

        # King moves
        allow(game_moveset).to receive(:next_board_info).with('Kh8-h7').and_return(
          { moveset: { white: %w[Rh1-a1 Rh1-b1 Rh1-c1 Rh1-d1 Rh1-e1 Rh1-f1 Rh1-g1
                                 Rh1-h2 Rh1-h3 Rh1-h4 Rh1-h5 Rh1-h6 Rh1xh7],
                       black: %w[Kh7-h8 Kh7-g8 Kh7-g7 Kh7-g6 Kh7-h6
                                 a7-a6 a7-a5] },
            king_locations: { white: ' ', black: 'h7' } }
        )

        # All Rh1-h[2-7] are check moves; ignore irrelevant next moves for the rook
        allow(game_moveset).to receive(:next_board_info).with(/Rh1-h/).and_return(
          { moveset: { white: %w[Rh1xh8],
                       black: %w[Kh8-g8 Kh8-g7 Kh8-h7
                                 a7-a6 a7-a5] },
            king_locations: { white: ' ', black: 'h8' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Rh1-a1 Rh1-b1 Rh1-c1 Rh1-d1 Rh1-e1 Rh1-f1 Rh1-g1
                    Rh1-h2+ Rh1-h3+ Rh1-h4+ Rh1-h5+ Rh1-h6+ Rh1-h7+ Rh1xh8],
          black: %w[Kh8-g8 Kh8-g7] }
      end

      it 'updates the game.moveset to the board.moveset minus all moves leaving the black king on the h file (with added check: "Rh1-h[2-7]+")' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when all castling is valid' do
      # Valid Castling
      # 8 ♖ . . . ♔ . . ♖
      # 7 ♙ . . . . . . ♙
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . . . . . ♟
      # 1 ♜ . . . ♚ . . ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    O-O O-O-O],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f8 Ke8-f7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    O-O O-O-O] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: 'e8' })
        allow(board).to receive(:empty_at?).and_return(true)
      end

      let(:expected_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    O-O O-O-O],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f8 Ke8-f7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    O-O O-O-O] }
      end

      it 'updates the game.moveset to the board.moveset with castling unchanged' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when all castling is invalid from King starting in check' do
      # 8 ♖ . . . ♔ . . ♖
      # 7 ♙ . . . . . . ♙
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . ♙ ♜ . . ♟
      # 1 ♜ . . . ♚ . . ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1xd2 Ke1-f1 Ke1-f2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    O-O O-O-O
                    Re2xd2 Re2-f2 Re2-g2 Re2-e3 Re2-e4 Re2-e5 Re2-e6 Re2-e7 Re2xe8],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f8 Ke8-f7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    O-O O-O-O
                    d2-d1=Q d2-d1=R d2-d1=N d2-d1=B d2xe1=Q d2xe1=R d2xe1=N d2xe1=B] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: 'e8' })
        allow(board).to receive(:empty_at?).and_return(true)

        # Giving the effect of disallowing invalid moves for white
        allow(game_moveset).to receive(:next_board_info).with(/Ra1|Rh1|a2-|h2-|Re2-|Re2xe8/).and_return(
          { moveset: { white: %w[Ke1-d1],
                       black: %w[d2xe1=Q] },
            king_locations: { white: 'e1', black: 'e8' } }
        )

        # Giving the effect of disallowing invalid moves for black
        allow(game_moveset).to receive(:next_board_info).with(/Ra8|Rh8|a7-|h7-|Ke8-e7|d2-|d2x/).and_return(
          { moveset: { white: %w[Re2xe8],
                       black: %w[Ke8-d8] },
            king_locations: { white: 'e1', black: 'e8' } }
        )

        # Giving the effect of white checking black
        allow(game_moveset).to receive(:next_board_info).with(/Ke1/).and_return(
          { moveset: { white: %w[Re2xe8],
                       black: %w[Ke8-d8] },
            king_locations: { white: 'd1', black: 'e8' } }
        )

        # Giving the effect of black checking white
        allow(game_moveset).to receive(:next_board_info).with(/Ke8-d|Ke8-f/).and_return(
          { moveset: { white: %w[Ke1-d1],
                       black: %w[d2xe1=Q] },
            king_locations: { white: 'e1', black: 'd8' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Ke1-d1+ Ke1xd2+ Ke1-f1+ Ke1-f2+
                    Re2xd2],
          black: %w[Ke8-d8+ Ke8-d7+ Ke8-f8+ Ke8-f7+] }
      end

      it 'updates the game.moveset to the validated board.moveset, also with no castling moves' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when all castling is invalid from King moving through check' do
      # 8 ♖ . . . ♔ . . ♖
      # 7 ♙ . ♝ ♖ . ♖ ♝ ♙
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . . . . . ♟
      # 1 ♜ . . . ♚ . . ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    O-O O-O-O
                    Bc7-a5 Bc7-b6 Bc7-d8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                    Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7xh8 Bg7-f8 Bg7-h6],
          black: %w[Ke8-d8 Ke8-e7 Ke8-f8
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    O-O O-O-O
                    Rd7xc7 Rd7-e7 Rd7-d1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6 Rd7-d8
                    Rf7-e7 Rf7xg7 Rf7-f1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6 Rf7-f8] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: 'e8' })
        allow(board).to receive(:empty_at?).and_return(true)

        # Giving the effect of disallowing invalid moves for white
        allow(game_moveset).to receive(:next_board_info).with(/Ke1-d|Ke1-f/).and_return(
          { moveset: { white: %w[Ra1-b1],
                       black: %w[Rd7xd1] },
            king_locations: { white: 'd1', black: 'e8' } }
        )

        # Giving the effect of disallowing invalid moves for black
        allow(game_moveset).to receive(:next_board_info).with(/Ke8-d|Ke8-f/).and_return(
          { moveset: { white: %w[Bc7xd8],
                       black: %w[Ra8-b8] },
            king_locations: { white: 'e1', black: 'd8' } }
        )

        # Giving the effect of black checking white
        allow(game_moveset).to receive(:next_board_info).with(/Rd7-e7|Rf7-e7/).and_return(
          { moveset: { white: %w[Ra1-b1],
                       black: %w[Re7xe1] },
            king_locations: { white: 'e1', black: 'e8' } }
        )

        # Castling:

        # 8 ♖ . . . ♔ . . ♖
        # 7 ♙ . ♝ ♖ . ♖ ♝ ♙
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . . . . . . . .
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . . ♜ ♚ .
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-Ow').and_return(
          { moveset: { white: %w[Kg1-f2 Kg1-g2 Kg1-h1
                                 Ra1-b1 Ra1-c1 Ra1-d1 Ra1-e1
                                 Rf1-b1 Rf1-c1 Rf1-d1 Rf1-e1 Rf1-f2 Rf1-f3 Rf1-f4 Rf1-f5 Rf1-f6 Rf1xf7
                                 a2-a3 a2-a4
                                 h2-h3 h2-h4
                                 Bc7-a5 Bc7-b6 Bc7-d8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                                 Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7xh8 Bg7-f8 Bg7-h6],
                       black: %w[Ke8-d8 Ke8-e7 Ke8-f8
                                 Ra8-b8 Ra8-c8 Ra8-d8
                                 Rh8-g8 Rh8-f8
                                 a7-a6 a7-a5
                                 h7-h6 h7-h5
                                 O-O O-O-O
                                 Rd7xc7 Rd7-e7 Rd7-d1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6 Rd7-d8
                                 Rf7-e7 Rf7xg7 Rf7xf1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6 Rf7-f8] },
            king_locations: { white: 'g1', black: 'e8' } }
        )

        # 8 ♖ . . . ♔ . . ♖
        # 7 ♙ . ♝ ♖ . ♖ ♝ ♙
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . . . . . . . .
        # 2 ♟ . . . . . . ♟
        # 1 . . ♚ ♜ . . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-O-Ow').and_return(
          { moveset: { white: %w[Kc1-b1 Kc1-b2 Kc1-c2 Kc1-d2
                                 Rd1-e1 Rd1-f1 Rd1-g1 Rd1-d2 Rd1-d3 Rd1-d4 Rd1-d5 Rd1-d6 Rd1xd7
                                 Rh1-g1 Rh1-f1 Rh1-e1
                                 a2-a3 a2-a4
                                 h2-h3 h2-h4
                                 Bc7-a5 Bc7-b6 Bc7-d8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                                 Bg7-a1 Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7xh8 Bg7-f8 Bg7-h6],
                       black: %w[Ke8-d8 Ke8-e7 Ke8-f8
                                 Ra8-b8 Ra8-c8 Ra8-d8
                                 Rh8-g8 Rh8-f8
                                 a7-a6 a7-a5
                                 h7-h6 h7-h5
                                 O-O O-O-O
                                 Rd7xc7 Rd7-e7 Rd7xd1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6 Rd7-d8
                                 Rf7-e7 Rf7xg7 Rf7-f1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6 Rf7-f8] },
            king_locations: { white: 'c1', black: 'e8' } }
        )

        # 8 ♖ . . . . ♖ ♔ .
        # 7 ♙ . ♝ ♖ . ♖ ♝ ♙
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . . . . . . . .
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . ♚ . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-Ob').and_return(
          { moveset: { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                                 Ra1-b1 Ra1-c1 Ra1-d1
                                 Rh1-g1 Rh1-f1
                                 a2-a3 a2-a4
                                 h2-h3 h2-h4
                                 O-O O-O-O
                                 Bc7-a5 Bc7-b6 Bc7-d8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                                 Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7-h8 Bg7xf8 Bg7-h6],
                       black: %w[Kg8xg7 Kg8-h8
                                 Ra8-b8 Ra8-c8 Ra8-d8 Ra8-e8
                                 Rf8-e8 Rf8-d8 Rf8-c8 Rf8-b8
                                 a7-a6 a7-a5
                                 h7-h6 h7-h5
                                 Rd7xc7 Rd7-e7 Rd7-d1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6 Rd7-d8
                                 Rf7-e7 Rf7xg7 Rf7-f1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6] },
            king_locations: { white: 'e1', black: 'g8' } }
        )

        # 8 . . ♔ ♖ . . . ♖
        # 7 ♙ . ♝ ♖ . ♖ ♝ ♙
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . . . . . . . .
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . ♚ . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-O-Ob').and_return(
          { moveset: { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                                 Ra1-b1 Ra1-c1 Ra1-d1
                                 Rh1-g1 Rh1-f1
                                 a2-a3 a2-a4
                                 h2-h3 h2-h4
                                 O-O O-O-O
                                 Bc7-a5 Bc7-b6 Bc7xd8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                                 Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7xh8 Bg7-f8 Bg7-h6],
                       black: %w[Kc8-b8 Kc8-b7 Kc8xc7
                                 Rd8-e8 Rd8-f8 Rd8-g8
                                 Rh8-g8 Rh8-f8 Rh8-e8
                                 a7-a6 a7-a5
                                 h7-h6 h7-h5
                                 Rd7xc7 Rd7-e7 Rd7-d1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6
                                 Rf7-e7 Rf7xg7 Rf7-f1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6 Rf7-f8] },
            king_locations: { white: 'e1', black: 'c8' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Ke1-e2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    Bc7-a5 Bc7-b6 Bc7-d8 Bc7-b8 Bc7-d6 Bc7-e5 Bc7-f4 Bc7-g3
                    Bg7-b2 Bg7-c3 Bg7-d4 Bg7-e5 Bg7-f6 Bg7xh8 Bg7-f8 Bg7-h6],
          black: %w[Ke8-e7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    Rd7xc7 Rd7-e7+ Rd7-d1 Rd7-d2 Rd7-d3 Rd7-d4 Rd7-d5 Rd7-d6 Rd7-d8
                    Rf7-e7+ Rf7xg7 Rf7-f1 Rf7-f2 Rf7-f3 Rf7-f4 Rf7-f5 Rf7-f6 Rf7-f8] }
      end

      it 'updates the game.moveset to the validated board.moveset, also with no castling moves' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when all castling is invalid from King ending in check' do
      # 8 ♖ . . . ♔ . . ♖
      # 7 ♙ ♟ . . . . . ♟
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . ♘ . . . . . ♘
      # 2 ♟ . . . . . . ♟
      # 1 ♜ . . . ♚ . . ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4 a2xb3
                    O-O O-O-O
                    b7-b8=Q b7-b8=R b7-b8=N b7-b8=B b7xa8=Q b7xa8=R b7xa8=N b7xa8=B],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f8 Ke8-f7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    O-O O-O-O
                    Nb3xa1 Nb3-c1 Nb3-d2 Nb3-d4 Nb3-a5 Nb3-c5
                    Nh3-g1 Nh3-f2 Nh3-f4 Nh3-g5] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: 'e8' })
        allow(board).to receive(:empty_at?).and_return(true)

        # Giving the effect of disallowing invalid moves for white
        allow(game_moveset).to receive(:next_board_info).with(/Ke1-d2|Ke1-f2/).and_return(
          { moveset: { white: %w[Ra1-b1],
                       black: %w[Nb3xd2] },
            king_locations: { white: 'd2', black: 'e8' } }
        )

        # Giving the effect of white checking black
        allow(game_moveset).to receive(:next_board_info).with(/b7-b8=Q|b7-b8=R|b7xa8=Q|b7xa8=R/).and_return(
          { moveset: { white: %w[Qa8xe8],
                       black: %w[Ke8-d8] },
            king_locations: { white: 'e1', black: 'e8' } }
        )

        # Castling

        # 8 ♖ . . . ♔ . . ♖
        # 7 ♙ ♟ . . . . . ♟
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . ♘ . . . . . ♘
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . . ♜ ♚ .
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-Ow').and_return(
          { moveset: { white: %w[Ra1-b1],
                       black: %w[Nh3xg1] },
            king_locations: { white: 'g1', black: 'e8' } }
        )

        # 8 ♖ . . . ♔ . . ♖
        # 7 ♙ ♟ . . . . . ♟
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . ♘ . . . . . ♘
        # 2 ♟ . . . . . . ♟
        # 1 . . ♚ ♜ . . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-O-Ow').and_return(
          { moveset: { white: %w[Rh1-g1],
                       black: %w[Nb3xc1] },
            king_locations: { white: 'c1', black: 'e8' } }
        )

        # 8 ♖ . . . . ♖ ♔ .
        # 7 ♙ ♟ . . . . . ♟
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . ♘ . . . . . ♘
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . ♚ . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-Ob').and_return(
          { moveset: { white: %w[h7xg8=Q],
                       black: %w[Ra8-b8] },
            king_locations: { white: 'e1', black: 'g8' } }
        )

        # 8 . . ♔ ♖ . . . ♖
        # 7 ♙ ♟ . . . . . ♟
        # 6 . . . . . . . .
        # 5 . . . . . . . .
        # 4 . . . . . . . .
        # 3 . ♘ . . . . . ♘
        # 2 ♟ . . . . . . ♟
        # 1 ♜ . . . ♚ . . ♜
        #   a b c d e f g h
        allow(game_moveset).to receive(:next_board_info).with('O-O-Ob').and_return(
          { moveset: { white: %w[b7xc8=Q],
                       black: %w[Rh8-g8] },
            king_locations: { white: 'e1', black: 'c8' } }
        )
      end

      let(:expected_moveset) do
        { white: %w[Ke1-d1 Ke1-e2 Ke1-f1
                    Ra1-b1 Ra1-c1 Ra1-d1
                    Rh1-g1 Rh1-f1
                    a2-a3 a2-a4 a2xb3
                    b7-b8=Q+ b7-b8=R+ b7-b8=N b7-b8=B b7xa8=Q+ b7xa8=R+ b7xa8=N b7xa8=B],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f8 Ke8-f7
                    Ra8-b8 Ra8-c8 Ra8-d8
                    Rh8-g8 Rh8-f8
                    a7-a6 a7-a5
                    Nb3xa1 Nb3-c1 Nb3-d2 Nb3-d4 Nb3-a5 Nb3-c5
                    Nh3-g1 Nh3-f2 Nh3-f4 Nh3-g5] }
      end

      it 'updates the game.moveset to the validated board.moveset, also with no castling moves' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end

    context 'when all castling is invalid from pieces blocking' do
      # 8 ♖ . ♘ . ♔ ♘ . ♖
      # 7 ♙ . . . . . . ♙
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . . . . . ♟
      # 1 ♜ ♘ . . ♚ . ♘ ♜
      #   a b c d e f g h

      let(:board_moveset) do
        { white: %w[Ke1-d1 Ke1-d2 Ke1-e2 Ke1-f1 Ke1-f2
                    Ra1xb1
                    Rh1xg1
                    a2-a3 a2-a4
                    h2-h3 h2-h4
                    O-O O-O-O],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f7
                    Ra8-b8
                    Rh8-g8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    O-O O-O-O
                    Nc8-e7 Nc8-b6 Nc8-d6
                    Nf8-d7 Nf8-e6 Nf8-g6
                    Nb1-d2 Nb1-a3 Nb1-c3
                    Ng1-e2 Ng1-f3 Ng1-h3] }
      end

      before do
        allow(board).to receive(:moveset).and_return(board_moveset)
        allow(board).to receive(:king_locations).and_return({ white: 'e1', black: 'e8' })
        allow(board).to receive(:empty_at?).and_return(true)

        # Giving the effect of disallowing invalid moves for white
        allow(game_moveset).to receive(:next_board_info).with(/Ke1-d2|Ke1-e2/).and_return(
          { moveset: { white: %w[Ra1xb1],
                       black: %w[Nb1xd2] },
            king_locations: { white: 'd2', black: 'e8' } }
        )

        # Giving the effect of black checking white
        allow(game_moveset).to receive(:next_board_info).with('Ng1-f3').and_return(
          { moveset: { white: %w[Ra1xb1],
                       black: %w[Nf3xe1] },
            king_locations: { white: 'e1', black: 'e8' } }
        )

        # Castling
        allow(board).to receive(:empty_at?).with([1, 0]).and_return(false)
        allow(board).to receive(:empty_at?).with([6, 0]).and_return(false)
        allow(board).to receive(:empty_at?).with([2, 7]).and_return(false)
        allow(board).to receive(:empty_at?).with([5, 7]).and_return(false)
      end

      let(:expected_moveset) do
        { white: %w[Ke1-d1 Ke1-f1 Ke1-f2
                    Ra1xb1
                    Rh1xg1
                    a2-a3 a2-a4
                    h2-h3 h2-h4],
          black: %w[Ke8-d8 Ke8-d7 Ke8-e7 Ke8-f7
                    Ra8-b8
                    Rh8-g8
                    a7-a6 a7-a5
                    h7-h6 h7-h5
                    Nc8-e7 Nc8-b6 Nc8-d6
                    Nf8-d7 Nf8-e6 Nf8-g6
                    Nb1-d2 Nb1-a3 Nb1-c3
                    Ng1-e2 Ng1-f3+ Ng1-h3] }
      end

      it 'updates the game.moveset to the validated board.moveset, also with no castling moves' do
        game_moveset.update_moveset
        actual_moveset = game_moveset.moveset
        expect(actual_moveset).to match({ white: contain_exactly(*expected_moveset[:white]), black: contain_exactly(*expected_moveset[:black]) })
      end
    end
  end

  describe '#update_result' do
    # Incoming Command Message -> Test change in observable state

    context 'when there is one white pawn and one black pawn' do
      # 8 . . . . . . . .
      # 7 ♙ . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 ♟ . . . . . . .
      # 1 . . . . . . . .
      #   a b c d e f g h

      context 'when the initial result is nil' do
        subject(:game_result_nil) { described_class.new(result: nil, current_player: :white, check: false, moveset: { white: %w[a2-a3 a2-a4], black: %w[a7-a6 a7-a5] }) }

        it 'updates result to be nil' do
          game_result_nil.update_result
          actual_result = game_result_nil.result
          expect(actual_result).to be_nil
        end
      end

      context 'when the initial result is set to "Game Over: Draw by 50 moves"' do
        subject(:game_result_set_draw) { described_class.new(result: 'Game Over: Draw by 50 moves', current_player: :black, check: false, moveset: { white: %w[a2-a3 a2-a4], black: %w[a7-a6 a7-a5] }) }

        it 'leaves result as is' do
          game_result_set_draw.update_result
          actual_result = game_result_set_draw.result
          expect(actual_result).to eql('Game Over: Draw by 50 moves')
        end
      end

      context 'when the initial result is set to "Game Over: Black resigns"' do
        subject(:game_result_set_resign) { described_class.new(result: 'Game Over: Black resigns', current_player: :white, check: false, moveset: { white: %w[a2-a3 a2-a4], black: %w[a7-a6 a7-a5] }) }

        it 'leaves result as is' do
          game_result_set_resign.update_result
          actual_result = game_result_set_resign.result
          expect(actual_result).to eql('Game Over: Black resigns')
        end
      end
    end

    context 'when white stalemates black' do
      # 8 . . . . . . . ♔
      # 7 ♜ . . . . . . .
      # 6 . . . . . ♞ . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 . . . . . . . .
      #   a b c d e f g h

      let(:moveset) do
        { white: %w[Ra7-a1 Ra7-a2 Ra7-a3 Ra7-a4 Ra7-a5 Ra7-a6 Ra7-a8+
                    Ra7-b7 Ra7-c7 Ra7-d7 Ra7-e7 Ra7-f7 Ra7-g7 Ra7-h7+
                    Nf6-e4 Nf6-g4 Nf6-d5 Nf6-h5 Nf6-d7 Nf6-h7 Nf6-e8 Nf6-g8],
          black: %w[] }
      end

      context 'when the initial result is nil' do
        let(:result) { nil }

        context 'when the current player turn is black' do
          let(:current_player) { :black }

          subject(:game_result_black_stalemate) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'updates result to be "Game Over: Draw, white stalemates black"' do
            game_result_black_stalemate.update_result
            actual_result = game_result_black_stalemate.result
            expect(actual_result).to eql('Game Over: Draw, white stalemates black')
          end
        end

        context 'when the current player turn is white' do
          let(:current_player) { :white }

          subject(:game_result_white_no_stalemate) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'leaves result as nil' do
            game_result_white_no_stalemate.update_result
            actual_result = game_result_white_no_stalemate.result
            expect(actual_result).to be_nil
          end
        end
      end

      context 'when the initial result is set to "Game Over: Draw by 50 moves"' do
        let(:result) { 'Game Over: Draw by 50 moves' }

        context 'when the current player turn is black' do
          let(:current_player) { :black }

          subject(:game_result_black_leave) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'leaves result as is' do
            game_result_black_leave.update_result
            actual_result = game_result_black_leave.result
            expect(actual_result).to eql('Game Over: Draw by 50 moves')
          end
        end

        context 'when the current player turn is white' do
          let(:current_player) { :white }

          subject(:game_result_white_leave) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'leaves result as is' do
            game_result_white_leave.update_result
            actual_result = game_result_white_leave.result
            expect(actual_result).to eql('Game Over: Draw by 50 moves')
          end
        end
      end
    end

    context 'when black stalemates white' do
      # 8 . . . . . . . .
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . ♙ ♙
      # 2 . . . . ♘ . . .
      # 1 . . . . . . . ♚
      #   a b c d e f g h

      let(:moveset) do
        { white: %w[],
          black: %w[g3-g2+ h3-h2 Ne2-c1 Ne2-g1 Ne2-c3 Ne2-d4 Ne2-f4] }
      end

      context 'when the initial result is nil' do
        let(:result) { nil }

        context 'when the current player turn is black' do
          let(:current_player) { :black }

          subject(:game_result_black_no_stalemate) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'leaves result as nil' do
            game_result_black_no_stalemate.update_result
            actual_result = game_result_black_no_stalemate.result
            expect(actual_result).to be_nil
          end
        end

        context 'when the current player turn is white' do
          let(:current_player) { :white }

          subject(:game_result_white_stalemate) { described_class.new(result:, current_player:, check: false, moveset:) }

          it 'updates result to be "Game Over: Draw, black stalemates white"' do
            game_result_white_stalemate.update_result
            actual_result = game_result_white_stalemate.result
            expect(actual_result).to eql('Game Over: Draw, black stalemates white')
          end
        end
      end
    end

    context 'when white checkmates black' do
      # 8 ♜ . . . . . . ♔
      # 7 ♜ . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . . . .
      # 2 . . . . . . . .
      # 1 . . . . . . . .
      #   a b c d e f g h

      let(:moveset) do
        { white: %w[Ra8-b8+ Ra8-c8+ Ra8-d8+ Ra8-e8+ Ra8-f8+ Ra8-g8+ Ra8xh8
                    Ra7-b7+ Ra7-c7+ Ra7-d7+ Ra7-e7+ Ra7-f7+ Ra7-g7+ Ra7-h7+
                    Ra7-a6+ Ra7-a5+ Ra7-a4+ Ra7-a3+ Ra7-a2+ Ra7-a1+],
          black: %w[] }
      end

      context 'when the initial result is nil' do
        let(:result) { nil }

        context 'when the current player turn is black' do
          let(:current_player) { :black }

          subject(:game_result_black_checkmate) { described_class.new(result:, current_player:, check: true, moveset:) }

          it 'updates result to be "Game Over: Winner, white checkmates black"' do
            game_result_black_checkmate.update_result
            actual_result = game_result_black_checkmate.result
            expect(actual_result).to eql('Game Over: Winner, white checkmates black')
          end
        end
      end
    end

    context 'when black checkmates white' do
      # 8 . . . . . . . .
      # 7 . . . . . . . .
      # 6 . . . . . . . .
      # 5 . . . . . . . .
      # 4 . . . . . . . .
      # 3 . . . . . ♙ . .
      # 2 . . . . . . ♕ .
      # 1 . . . . . . . ♚
      #   a b c d e f g h

      let(:moveset) do
        { white: %w[],
          black: %w[f3-f2+
                    Qg2xh1 Qg2-f1+ Qg2-h3+
                    Qg2-a2 Qg2-b2 Qg2-c2 Qg2-d2 Qg2-e2 Qg2-f2 Qg2-h2+
                    Qg2-g1+ Qg2-g3 Qg2-g4 Qg2-g5 Qg2-g6 Qg2-g7 Qg2-g8] }
      end

      context 'when the initial result is nil' do
        let(:result) { nil }

        context 'when the current player turn is white' do
          let(:current_player) { :white }

          subject(:game_result_white_checkmate) { described_class.new(result:, current_player:, check: true, moveset:) }

          it 'updates result to be "Game Over: Winner, black checkmates white"' do
            game_result_white_checkmate.update_result
            actual_result = game_result_white_checkmate.result
            expect(actual_result).to eql('Game Over: Winner, black checkmates white')
          end
        end
      end
    end
  end

  describe '#switch_player_turn' do
    # Incoming Command Message -> Test change in observable state

    context 'when the initial current_player is :white' do
      subject(:game_switch_player_white) { described_class.new(current_player: :white) }

      it 'switches the current_player to :black' do
        game_switch_player_white.switch_player_turn
        actual_current_player = game_switch_player_white.current_player
        expect(actual_current_player).to eql(:black)
      end
    end

    context 'when the initial current_player is :black' do
      subject(:game_switch_player_black) { described_class.new(current_player: :black) }

      it 'switches the current_player to :white' do
        game_switch_player_black.switch_player_turn
        actual_current_player = game_switch_player_black.current_player
        expect(actual_current_player).to eql(:white)
      end
    end
  end

  describe '#update_check' do
    # Incoming Command Message -> Test change in observable state

    context 'when check is initially false' do
      subject(:game_update_check_false) { described_class.new(check: false) }

      it 'sets check to false for the move "Ra1-a8"' do
        game_update_check_false.update_check('Ra1-a8')
        actual_check = game_update_check_false.check
        expect(actual_check).to eql(false)
      end

      it 'sets check to false for the move "b2-b4"' do
        game_update_check_false.update_check('b2-b4')
        actual_check = game_update_check_false.check
        expect(actual_check).to eql(false)
      end

      it 'sets check to true for the move "Ra1-a8+"' do
        game_update_check_false.update_check('Ra1-a8+')
        actual_check = game_update_check_false.check
        expect(actual_check).to eql(true)
      end

      it 'sets check to true for the move "Qc3-d4+"' do
        game_update_check_false.update_check('Qc3-d4+')
        actual_check = game_update_check_false.check
        expect(actual_check).to eql(true)
      end

      it 'sets check to true for the move "O-O-O+w"' do
        game_update_check_false.update_check('O-O-O+w')
        actual_check = game_update_check_false.check
        expect(actual_check).to eql(true)
      end
    end

    context 'when check is initially true' do
      subject(:game_update_check_true) { described_class.new(check: true) }

      it 'sets check to false for the move "Ra1-a8"' do
        game_update_check_true.update_check('Ra1-a8')
        actual_check = game_update_check_true.check
        expect(actual_check).to eql(false)
      end

      it 'sets check to false for the move "b2-b4"' do
        game_update_check_true.update_check('b2-b4')
        actual_check = game_update_check_true.check
        expect(actual_check).to eql(false)
      end

      it 'sets check to true for the move "Ra1-a8+"' do
        game_update_check_true.update_check('Ra1-a8+')
        actual_check = game_update_check_true.check
        expect(actual_check).to eql(true)
      end

      it 'sets check to true for the move "Qc3-d4+"' do
        game_update_check_true.update_check('Qc3-d4+')
        actual_check = game_update_check_true.check
        expect(actual_check).to eql(true)
      end

      it 'sets check to true for the move "O-O-O+w"' do
        game_update_check_true.update_check('O-O-O+w')
        actual_check = game_update_check_true.check
        expect(actual_check).to eql(true)
      end
    end
  end

  describe '#format_move' do
    # Incoming Query Message -> Test value returned

    context 'when the moveset of white (the current player) is ["Ra1-a8+", "h2-h3", "O-O", "O-O-O+"]' do
      let(:moveset) do
        { white: %w[Ra1-a8+ h2-h3 O-O O-O-O+],
          black: %w[] }
      end

      subject(:game_format_move) { described_class.new(current_player: :white, moveset:) }

      it 'returns nil for the user_move "g2-g3"' do
        formatted_move = game_format_move.format_move('g2-g3')
        expect(formatted_move).to be_nil
      end

      it 'returns "h2-h3" for the user_move "h2-h3"' do
        formatted_move = game_format_move.format_move('h2-h3')
        expect(formatted_move).to eql('h2-h3')
      end

      it 'returns nil for the user_move "h2-h3+"' do
        formatted_move = game_format_move.format_move('h2-h3+')
        expect(formatted_move).to be_nil
      end

      it 'returns "Ra1-a8+" for the user_move "Ra1-a8+"' do
        formatted_move = game_format_move.format_move('Ra1-a8+')
        expect(formatted_move).to eql('Ra1-a8+')
      end

      it 'returns "Ra1-a8+" for the user_move "Ra1-a8"' do
        formatted_move = game_format_move.format_move('Ra1-a8')
        expect(formatted_move).to eql('Ra1-a8+')
      end

      it 'returns "O-Ow" for the user_move "O-O"' do
        formatted_move = game_format_move.format_move('O-O')
        expect(formatted_move).to eql('O-Ow')
      end

      it 'returns "O-O-O+w" for the user_move "O-O-O+"' do
        formatted_move = game_format_move.format_move('O-O-O+')
        expect(formatted_move).to eql('O-O-O+w')
      end

      it 'returns nil for the user_move "O-O+"' do
        formatted_move = game_format_move.format_move('O-O+')
        expect(formatted_move).to be_nil
      end

      it 'returns "O-O-O+w" for the user_move "O-O-O"' do
        formatted_move = game_format_move.format_move('O-O-O')
        expect(formatted_move).to eql('O-O-O+w')
      end
    end

    context 'when the moveset of white (the current player) is ["Ra1-a8+", "g2-g3"]' do
      let(:moveset) do
        { white: %w[Ra1-a8+ g2-g3],
          black: %w[] }
      end

      subject(:game_format_move_white) { described_class.new(current_player: :white, moveset:) }

      it 'returns "g2-g3" for the user_move "g2-g3"' do
        formatted_move = game_format_move_white.format_move('g2-g3')
        expect(formatted_move).to eql('g2-g3')
      end

      it 'returns nil for the user_move "h2-h3"' do
        formatted_move = game_format_move_white.format_move('h2-h3')
        expect(formatted_move).to be_nil
      end

      it 'returns nil for the user_move "O-O"' do
        formatted_move = game_format_move_white.format_move('O-O')
        expect(formatted_move).to be_nil
      end
    end

    context 'when the moveset of black (the current player) is ["Ra1-a8+", "g2-g3", "O-O", "O-O-O+"]' do
      let(:moveset) do
        { white: %w[],
          black: %w[Ra1-a8+ g2-g3 O-O O-O-O+] }
      end

      subject(:game_format_move_black) { described_class.new(current_player: :black, moveset:) }

      it 'returns "g2-g3" for the user_move "g2-g3"' do
        formatted_move = game_format_move_black.format_move('g2-g3')
        expect(formatted_move).to eql('g2-g3')
      end

      it 'returns nil for the user_move "h2-h3"' do
        formatted_move = game_format_move_black.format_move('h2-h3')
        expect(formatted_move).to be_nil
      end

      it 'returns "O-Ob" for the user_move "O-O"' do
        formatted_move = game_format_move_black.format_move('O-O')
        expect(formatted_move).to eql('O-Ob')
      end

      it 'returns "O-O-O+b" for the user_move "O-O-O+"' do
        formatted_move = game_format_move_black.format_move('O-O-O+')
        expect(formatted_move).to eql('O-O-O+b')
      end
    end
  end

  describe '#game_loop' do
    # Looping Script Method -> Test loop behavior

    let(:board) { instance_double('Board') }
    let(:player) { instance_double('HumanPlayer') }

    before do
      allow(board).to receive(:print_board)
      allow(player).to receive(:make_move)
    end

    subject(:game_main_loop) { described_class.new(board:, players: { white: player, black: player }) }

    before do
      allow(game_main_loop).to receive(:puts)
      allow(game_main_loop).to receive(:update_result)
      allow(game_main_loop).to receive(:switch_player_turn)
      allow(game_main_loop).to receive(:current_player).and_return(:white)
    end

    context 'when the result is immediately updated' do
      before do
        allow(game_main_loop).to receive(:result).and_return('Game Over')
      end

      it 'does not loop and does not puts "Player turn: white"' do
        expect(game_main_loop).to_not receive(:puts).with('Player turn: white')
        game_main_loop.game_loop
      end
    end

    context 'when the result is nil, then updated' do
      before do
        allow(game_main_loop).to receive(:result).and_return(nil, 'Game Over')
      end

      it 'loops once and puts "Player turn: white" once' do
        expect(game_main_loop).to receive(:puts).with('Player turn: white').once
        game_main_loop.game_loop
      end
    end

    context 'when the result is nil, nil, nil, then updated' do
      before do
        allow(game_main_loop).to receive(:result).and_return(nil, nil, nil, 'Game Over')
      end

      it 'loops 3 times and puts "Player turn: white" 3 times' do
        expect(game_main_loop).to receive(:puts).with('Player turn: white').exactly(3).times
        game_main_loop.game_loop
      end
    end
  end

  describe '#update_result_to_resign' do
    # Incoming Command Message -> Test change in observable state

    context 'when the current player turn is white' do
      subject(:game_resign_white) { described_class.new(current_player: :white, result: nil) }

      it 'sets result to "Game Over: white resigns"' do
        game_resign_white.update_result_to_resign
        actual_result = game_resign_white.result
        expect(actual_result).to eql('Game Over: white resigns')
      end
    end

    context 'when the current player turn is black' do
      subject(:game_resign_black) { described_class.new(current_player: :black, result: nil) }

      it 'sets result to "Game Over: black resigns"' do
        game_resign_black.update_result_to_resign
        actual_result = game_resign_black.result
        expect(actual_result).to eql('Game Over: black resigns')
      end
    end
  end

  describe '#update_result_to_draw' do
    # Incoming Command Message -> Test change in observable state

    subject(:game_draw) { described_class.new(result: nil) }

    context 'when the draw is accepted' do
      let(:draw_accepted) { true }
      it 'sets result to "Game Over: Draw accepted"' do
        game_draw.update_result_to_draw(draw_accepted)
        expect(game_draw.result).to eql('Game Over: Draw accepted')
      end
    end

    context 'when the draw is not accepted' do
      let(:draw_accepted) { false }
      it 'leaves the result as nil' do
        game_draw.update_result_to_draw(draw_accepted)
        expect(game_draw.result).to be_nil
      end
    end
  end

  describe '#opposite_color' do
    # Incoming Query Message -> Test value returned

    subject(:game_opposite_color) { described_class.new }

    context 'when the color is white' do
      let(:color) { :white }

      it 'returns the color black' do
        opposite_color = game_opposite_color.opposite_color(color)
        expect(opposite_color).to eql(:black)
      end
    end

    context 'when the color is black' do
      let(:color) { :black }

      it 'returns the color white' do
        opposite_color = game_opposite_color.opposite_color(color)
        expect(opposite_color).to eql(:white)
      end
    end
  end
end
