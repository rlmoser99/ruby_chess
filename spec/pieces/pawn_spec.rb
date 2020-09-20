# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'

RSpec.describe Pawn do
  describe '#current_moves' do
    let(:piece) { instance_double(Piece) }

    context 'when pawn is black' do
      context 'when pawn has not moved' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 0] }) }

        context 'when bonus square is empty' do
          let(:board) { [[nil, nil], [black_pawn, nil], [nil, nil], [nil, nil]] }

          it 'has two moves' do
            results = black_pawn.current_moves(board)
            expect(results).to contain_exactly([2, 0], [3, 0])
          end
        end

        context 'when bonus square is occupied' do
          let(:board_occupied) { [[nil, nil], [black_pawn, nil], [nil, nil], [piece, nil]] }

          it 'has one move' do
            results = black_pawn.current_moves(board_occupied)
            expect(results).to contain_exactly([2, 0])
          end
        end
      end

      context 'when pawn has moved' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 0] }) }

        before do
          black_pawn.update_location(2, 0)
        end

        context 'when next square is empty' do
          let(:board) { [[nil, nil], [black_pawn, nil], [nil, nil], [nil, nil]] }

          it 'has one move' do
            results = black_pawn.current_moves(board)
            expect(results).to contain_exactly([3, 0])
          end
        end

        context 'when next square is occupied' do
          let(:board_occupied) { [[nil, nil], [black_pawn, nil], [nil, nil], [piece, nil]] }

          it 'has no moves' do
            results = black_pawn.current_moves(board_occupied)
            expect(results).to be_empty
          end
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn has not moved' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [2, 0] }) }

        context 'when bonus square is empty' do
          let(:board) { [[nil, nil], [nil, nil], [white_pawn, nil], [nil, nil]] }

          it 'has two moves' do
            results = white_pawn.current_moves(board)
            expect(results).to contain_exactly([0, 0], [1, 0])
          end
        end

        context 'when bonus square is occupied' do
          let(:board_bonus) { [[nil, nil], [white_pawn, nil], [nil, nil], [piece, nil]] }

          it 'has one move' do
            results = white_pawn.current_moves(board_bonus)
            expect(results).to contain_exactly([0, 0])
          end
        end
      end

      context 'when pawn has moved' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [2, 0] }) }

        before do
          white_pawn.update_location(1, 0)
        end

        context 'when next square is empty' do
          let(:board) { [[nil, nil], [nil, nil], [white_pawn, nil], [nil, nil]] }

          it 'has one move' do
            results = white_pawn.current_moves(board)
            expect(results).to contain_exactly([0, 0])
          end
        end

        context 'when next square is occupied' do
          let(:board_occupied) { [[piece, nil], [nil, nil], [white_pawn, nil], [nil, nil]] }

          it 'has no moves' do
            results = white_pawn.current_moves(board_occupied)
            expect(results).to be_empty
          end
        end
      end
    end
  end

  describe '#current_captures' do
    let(:black_piece) { instance_double(Piece, color: :black) }
    let(:white_piece) { instance_double(Piece, color: :white) }

    context 'when pawn is black' do
      context 'when pawn is in first file' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 0] }) }

        context 'when there is nothing to capture' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [black_pawn, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = black_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [black_pawn, nil, nil, nil, nil, nil, nil, nil],
              [nil, black_piece, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = black_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when an opposing piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [black_pawn, nil, nil, nil, nil, nil, nil, nil],
              [nil, white_piece, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            results = black_pawn.current_captures(board)
            expect(results).to contain_exactly([2, 1])
          end
        end
      end

      context 'when pawn is in second file' do
        context 'when an opposing piece in capture square' do
          subject(:black_pawn) { described_class.new({ color: :black, location: [1, 1] }) }
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, black_pawn, black_piece, nil, nil, nil, nil, nil],
              [white_piece, nil, nil, nil, nil, nil, nil, nil],
              [black_piece, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            results = black_pawn.current_captures(board)
            expect(results).to contain_exactly([2, 0])
          end
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn is in last file' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [6, 7] }) }

        context 'when there is nothing to capture' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, white_pawn],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = white_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, white_piece, nil],
              [nil, nil, nil, nil, nil, nil, nil, white_pawn],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = white_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when an opposite color piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, black_piece, nil],
              [nil, nil, nil, nil, nil, nil, nil, white_pawn],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            results = white_pawn.current_captures(board)
            expect(results).to contain_exactly([5, 6])
          end
        end
      end

      context 'when pawn is in middle file' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [6, 4] }) }

        context 'when there is nothing to capture' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, white_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = white_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, white_piece, nil, nil, nil],
              [nil, nil, nil, nil, white_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            results = white_pawn.current_captures(board)
            expect(results).to be_empty
          end
        end

        context 'when an opposite color piece in capture square' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, black_piece, nil, nil],
              [nil, nil, nil, nil, white_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            results = white_pawn.current_captures(board)
            expect(results).to contain_exactly([5, 5])
          end
        end

        context 'when two opposite color pieces are in capture squares' do
          let(:board) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, black_piece, nil, black_piece, nil, nil],
              [nil, nil, nil, nil, white_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has two captures' do
            results = white_pawn.current_captures(board)
            expect(results).to contain_exactly([5, 5], [5, 3])
          end
        end
      end
    end
  end

  describe '#update_location' do
    context 'when pawn moves one square' do
      subject(:black_pawn) { described_class.new({ color: :black, location: [1, 1] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_pawn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is not en passant' do
        black_pawn.update_location(2, 1)
        expect(black_pawn.en_passant).to be false
      end
    end

    context 'when pawn moves two squares' do
      subject(:black_pawn) { described_class.new({ color: :black, location: [1, 1] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_pawn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is en passant' do
        black_pawn.update_location(3, 1)
        expect(black_pawn.en_passant).to be true
      end
    end
  end
end
