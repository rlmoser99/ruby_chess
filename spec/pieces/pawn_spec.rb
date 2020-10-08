# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Pawn do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#current_moves' do
    let(:piece) { instance_double(Piece) }

    context 'when pawn is black' do
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 0]) }

      context 'when pawn has not moved' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 0] }) }

        context 'when bonus square is empty' do
          let(:data) { [[black_king, nil], [black_pawn, nil], [nil, nil], [nil, nil]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:black_king).and_return(black_king)
            # allow(piece).to receive(:color).and_return(:black)
          end

          it 'has two moves' do
            black_pawn.current_moves(board)
            moves = black_pawn.moves
            expect(moves).to contain_exactly([2, 0], [3, 0])
          end
        end

        context 'when bonus square is occupied' do
          let(:data) { [[black_king, nil], [black_pawn, nil], [nil, nil], [piece, nil]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:black_king).and_return(black_king)
            allow(piece).to receive(:color).and_return(:black)
          end

          it 'has one move' do
            black_pawn.current_moves(board)
            moves = black_pawn.moves
            expect(moves).to contain_exactly([2, 0])
          end
        end
      end

      context 'when pawn has moved' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 0] }) }

        before do
          black_pawn.update_location(2, 0)
        end

        context 'when next square is empty' do
          let(:data) { [[black_king, nil], [black_pawn, nil], [nil, nil], [nil, nil]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:black_king).and_return(black_king)
            allow(piece).to receive(:color).and_return(:black)
          end

          it 'has one move' do
            black_pawn.current_moves(board)
            moves = black_pawn.moves
            expect(moves).to contain_exactly([3, 0])
          end
        end

        context 'when next square is occupied' do
          let(:data) { [[black_king, nil], [black_pawn, nil], [nil, nil], [piece, nil]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:black_king).and_return(black_king)
            allow(piece).to receive(:color).and_return(:black)
          end

          it 'has no moves' do
            black_pawn.current_moves(board)
            moves = black_pawn.moves
            expect(moves).to be_empty
          end
        end
      end
    end

    context 'when pawn is white' do
      let(:white_king) { instance_double(Piece, color: :white, location: [3, 1]) }

      context 'when pawn has not moved' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [2, 0] }) }

        context 'when bonus square is empty' do
          let(:data) { [[nil, nil], [nil, nil], [white_pawn, nil], [nil, white_king]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:white_king).and_return(white_king)
            # allow(piece).to receive(:color).and_return(:white)
          end

          it 'has two moves' do
            white_pawn.current_moves(board)
            moves = white_pawn.moves
            expect(moves).to contain_exactly([0, 0], [1, 0])
          end
        end

        context 'when bonus square is occupied' do
          let(:data) { [[piece, nil], [nil, nil], [white_pawn, nil], [nil, white_king]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:white_king).and_return(white_king)
            allow(piece).to receive(:color).and_return(:white)
          end

          it 'has one move' do
            white_pawn.current_moves(board)
            moves = white_pawn.moves
            expect(moves).to contain_exactly([1, 0])
          end
        end
      end

      context 'when pawn has moved' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [2, 0] }) }

        before do
          white_pawn.update_location(1, 0)
        end

        context 'when next square is empty' do
          let(:data) { [[nil, nil], [nil, nil], [white_pawn, nil], [nil, white_king]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:white_king).and_return(white_king)
            # allow(piece).to receive(:color).and_return(:white)
          end

          it 'has one move' do
            white_pawn.current_moves(board)
            moves = white_pawn.moves
            expect(moves).to contain_exactly([0, 0])
          end
        end

        context 'when next square is occupied' do
          let(:data) { [[piece, nil], [nil, nil], [white_pawn, nil], [nil, white_king]] }

          before do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:white_king).and_return(white_king)
            allow(piece).to receive(:color).and_return(:white)
          end

          it 'has no moves' do
            white_pawn.current_moves(board)
            moves = white_pawn.moves
            expect(moves).to be_empty
          end
        end
      end
    end
  end

  describe '#current_captures' do
    let(:black_piece) { instance_double(Piece, color: :black, symbol: nil) }
    let(:white_piece) { instance_double(Piece, color: :white, symbol: nil) }

    context 'when pawn is black' do
      context 'when pawn is in first file' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 0] }) }

        context 'when there is nothing to capture' do
          let(:data) do
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
            results = black_pawn.current_captures(data, white_piece)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:data) do
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
            results = black_pawn.current_captures(data, white_piece)
            expect(results).to be_empty
          end
        end

        context 'when an opposing piece in capture square' do
          let(:data) do
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
            results = black_pawn.current_captures(data, white_piece)
            expect(results).to contain_exactly([2, 1])
          end
        end
      end

      context 'when pawn is in second file' do
        context 'when an opposing piece in capture square' do
          subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
          let(:data) do
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
            results = black_pawn.current_captures(data, white_piece)
            expect(results).to contain_exactly([2, 0])
          end
        end
      end

      context 'when pawn has en_passant' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:white_pawn) { instance_double(Pawn, en_passant: true, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, black_pawn, white_pawn, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          results = black_pawn.current_captures(data, white_pawn)
          expect(results).to contain_exactly([4, 2])
        end
      end

      context 'when pawn has a capture and is next to a pawn without en_passant' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:white_pawn) { instance_double(Pawn, en_passant: false, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, black_pawn, white_pawn, nil, nil, nil, nil, nil],
            [white_piece, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          results = black_pawn.current_captures(data, white_pawn)
          expect(results).to contain_exactly([5, 0])
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn is in last file' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [6, 7] }) }

        context 'when there is nothing to capture' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to be_empty
          end
        end

        context 'when an opposite color piece in capture square' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to contain_exactly([5, 6])
          end
        end
      end

      context 'when pawn is in middle file' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [6, 4] }) }

        context 'when there is nothing to capture' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to be_empty
          end
        end

        context 'when an opposite color piece in capture square' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to contain_exactly([5, 5])
          end
        end

        context 'when two opposite color pieces are in capture squares' do
          let(:data) do
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
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to contain_exactly([5, 5], [5, 3])
          end
        end

        context 'when pawn has en_passant and a capture' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 3] }) }
          let(:black_pawn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, black_piece, nil, nil, nil, nil, nil],
              [nil, nil, nil, white_pawn, black_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has two captures' do
            results = white_pawn.current_captures(data, black_pawn)
            expect(results).to contain_exactly([3, 4], [2, 2])
          end
        end

        context 'when pawn has en_passant but is not previous_piece' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 3] }) }
          let(:black_pawn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, black_piece, nil, nil, nil, nil, nil],
              [nil, nil, nil, white_pawn, black_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            results = white_pawn.current_captures(data, black_piece)
            expect(results).to contain_exactly([2, 2])
          end
        end
      end
    end
  end

  describe '#update_location' do
    context 'when pawn moves one square' do
      subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
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
      subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
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
